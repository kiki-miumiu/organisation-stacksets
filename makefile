SHELL=/bin/bash -euxo pipefail

AWS_REGION ?= ap-southeast-2
AWSCLI ?= aws --region $(AWS_REGION)

check_appname:
ifndef appname
	@echo 'appname variable is missing'
	@echo 'make appname=<name> prerequisites-basic'
	@exit 1
endif

PREREQUISITES_BASIC_CFN_STACK_NAME := $(appname)-prerequisites-basic
CFN_STACK_TAGS := App=$(appname) DataClassification=GroupUse


prerequisites-basic: check_appname
	$(AWSCLI) cloudformation deploy \
		--template-file cloudformation/prerequisites-basic.yml \
		--stack-name $(PREREQUISITES_CFN_STACK_NAME) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset \
		--tags $(CFN_STACK_TAGS)