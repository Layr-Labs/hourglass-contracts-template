.PHONY: build deploy-task-mailbox deploy-avs-l1-contracts setup-avs-l1 deploy-avs-l2-contracts setup-avs-task-mailbox-config create-task

# Build the project
build:
	forge build

# Deploy Task Mailbox
deploy-task-mailbox:
	forge script script/local/deploy/DeployTaskMailbox.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string)" $(ENVIRONMENT) -vvvv

# Deploy AVS L1 Contracts
deploy-avs-l1-contracts:
	forge script script/local/deploy/DeployAVSL1Contracts.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string, address, address)" $(ENVIRONMENT) $(AVS_ADDRESS) $(ALLOCATION_MANAGER_ADDRESS) -vvvv

# Setup AVS L1
setup-avs-l1:
	forge script script/local/setup/SetupAVSL1.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string, address, string, uint32, address[], uint32, address[])" $(ENVIRONMENT) $(ALLOCATION_MANAGER_ADDRESS) $(METADATA_URI) $(AGGREGATOR_OPERATOR_SET_ID) $(AGGREGATOR_STRATEGIES) $(EXECUTOR_OPERATOR_SET_ID) $(EXECUTOR_STRATEGIES) -vvvv

# Deploy AVS L2 Contracts
deploy-avs-l2-contracts:
	forge script script/local/deploy/DeployAVSL2Contracts.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string)" $(ENVIRONMENT) -vvvv

# Setup AVS Task Mailbox Config
setup-avs-task-mailbox-config:
	forge script script/local/setup/SetupAVSTaskMailboxConfig.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string, uint32, uint32, uint96)" $(ENVIRONMENT) $(AGGREGATOR_OPERATOR_SET_ID) $(EXECUTOR_OPERATOR_SET_ID) $(TASK_SLA) -vvvv

# Create Task
create-task:
	forge script script/local/run/CreateTask.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(string, address, uint32, bytes)" $(ENVIRONMENT) $(AVS_ADDRESS) $(EXECUTOR_OPERATOR_SET_ID) $(PAYLOAD) -vvvv

# Helper message
help:
	@echo "Available commands:"
	@echo "  make build - Build the project"
	@echo "  make deploy-task-mailbox    - Deploy Task Mailbox"
	@echo "  make deploy-avs-l1-contracts AVS_ADDRESS=0x... - Deploy AVS L1 Contracts"
	@echo "  make setup-avs-l1 TASK_AVS_REGISTRAR_ADDRESS=0x... - Setup AVS on L1"
	@echo "  make deploy-avs-l2-contracts - Deploy AVS L2 Contracts"
	@echo "  make setup-avs-task-mailbox-config TASK_MAILBOX_ADDRESS=0x... CERTIFICATE_VERIFIER_ADDRESS=0x... TASK_HOOK_ADDRESS=0x... - Setup AVS Task Mailbox Config"
	@echo "  make create-task TASK_MAILBOX_ADDRESS=0x... AVS_ADDRESS=0x... VALUE=5 - Create Task"
	@echo ""
	@echo "Note: Make sure to set RPC_URL and PRIVATE_KEY in your environment or .env file" 