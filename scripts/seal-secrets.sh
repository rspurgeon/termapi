#!/bin/bash
#
# Script to seal secrets

if ! which kubeseal > /dev/null 2>&1; then
  echo 'Please install kubeseal. You can try "make install-kubeseal".'
  exit
fi

if ! which yq > /dev/null 2>&1; then
  echo 'Please install yq.'
  exit
fi

function seal_secrets {
  for secret in "$to_seal_dir"/*.yaml; do
    # Obtain just the filename without the file type.
    filename=${secret##*/}
    filename_without_file_type=${filename%.*}
   
    # Use kubeseal to construct a Sealed Secret with the same name.
    kubeseal --format=yaml --cert="${public_key}" < "$secret" > "${sealed_secret_dir}/${filename_without_file_type}.yaml"
    
    # Move secret which has been sealed to the "sealed" directory to stop constant re-sealing.
    mv "${secret}" "${sealed_dir}"
    
    printf "INFO - Successfully sealed %s\n" "${secret}"
  done
}
    
public_key="secrets/keys/bitnami.crt"
sealed_secret_dir="secrets/sealed"
to_seal_dir="secrets/local-toseal"
sealed_dir="secrets/local-sealed"

seal_secrets

