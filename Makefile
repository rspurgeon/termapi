CURRENT_WORKING_DIR=$(shell pwd)
WHO_AM_I=$(shell whoami)
TIMESTAMP=$(shell date)

YQ_VERSION = 4.25.1
BITNAMI_SEALED_SECRETS_VERSION=0.17.5

pad=$(printf '%0.1s' "-"{1..80})

install-yq:
	@echo "Installing yq (assumes arm64)"
	@wget -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_arm64
	@echo "May be prompted for password to install in /usr/local/bin"
	@sudo install -m 755 yq_darwin_arm64 /usr/local/bin/yq
	@rm -f yq_darwin_arm64
	@yq --version

install-kubeseal:
	@echo "Installing kubeseal (assumes arm64)"
	@wget -q https://github.com/bitnami-labs/sealed-secrets/releases/download/v${BITNAMI_SEALED_SECRETS_VERSION}/kubeseal-${BITNAMI_SEALED_SECRETS_VERSION}-darwin-arm64.tar.gz -P bitnami
	@tar xC bitnami -f bitnami/kubeseal-*-darwin-arm64.tar.gz
	@echo "May be prompted for password to install in /usr/local/bin"
	@sudo install -m 755 bitnami/kubeseal /usr/local/bin/kubeseal
	@rm -rf bitnami 
	@kubeseal --version

install-bitnami-secret-controller:
	kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v${BITNAMI_SEALED_SECRETS_VERSION}/controller.yaml

wait-for-secret-controller:
	./scripts/wait-for-secret-controller.sh

get-bitnami-secrect-controller-public-key:
	kubeseal --fetch-cert > secrets/keys/bitnami.crt

seal-secrets:
	@./scripts/seal-secrets.sh

