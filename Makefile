CURRENT_WORKING_DIR=$(shell pwd)
WHO_AM_I=$(shell whoami)
TIMESTAMP=$(shell date)

SYNC ?= false

pad=$(printf '%0.1s' "-"{1..80})

install-yq:
	@echo "Installing yq (assumes arm64)"
	@wget -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_arm64
	@echo "May be prompted for password to install in /usr/local/bin"
	@sudo install -m 755 yq_darwin_arm64 /usr/local/bin/yq
	@rm -f yq_darwin_arm64
	@yq --version

sync:
ifeq (${SYNC},true)
	deck sync
endif

dump:
	deck dump

