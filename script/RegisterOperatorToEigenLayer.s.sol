// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";
import {DelegationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/core/DelegationManager.sol";

contract RegisterOperatorToEigenLayer is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    DelegationManager delegationManager;

    function setUp() public {
        delegationManager = DelegationManager(MainnetConstants.DELEGATION_MANAGER);
    }

    function run(uint256 operatorPvtKey, uint32 allocatonDelay, string memory metadataURI) public {
        address operator = vm.addr(operatorPvtKey);
        // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);

        delegationManager.registerAsOperator(operator, allocatonDelay, metadataURI);

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
