.PHONY: build deploy-task-mailbox deploy-avs-l1-contracts setup-avs-l1 deploy-avs-l2-contracts setup-avs-task-mailbox-config create-task

# Build the project
build:
	forge build

# Deploy Task Mailbox
deploy-task-mailbox:
	forge script script/local/DeployTaskMailbox.s.sol --rpc-url $(RPC_URL) --broadcast

# Deploy AVS L1 Contracts
deploy-avs-l1-contracts:
	forge script script/local/DeployAVSL1Contracts.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(address)" $(AVS_ADDRESS)

# Setup AVS L1
setup-avs-l1:
	forge script script/local/SetupAVSL1.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(address)" $(TASK_AVS_REGISTRAR_ADDRESS)

# Deploy AVS L2 Contracts
deploy-avs-l2-contracts:
	forge script script/local/DeployAVSL2Contracts.s.sol --rpc-url $(RPC_URL) --broadcast

# Setup AVS Task Mailbox Config
setup-avs-task-mailbox-config:
	forge script script/local/SetupAVSTaskMailboxConfig.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(address, address, address)" $(TASK_MAILBOX_ADDRESS) $(CERTIFICATE_VERIFIER_ADDRESS) $(TASK_HOOK_ADDRESS)

# Create Task
create-task:
	forge script script/local/CreateTask.s.sol --rpc-url $(RPC_URL) --broadcast --sig "run(address, address, uint256)" $(TASK_MAILBOX_ADDRESS) $(AVS_ADDRESS) $(VALUE)

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