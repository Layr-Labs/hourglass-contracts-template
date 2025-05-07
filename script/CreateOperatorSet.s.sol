// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {
    IAllocationManager,
    IAllocationManagerTypes
} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";

import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";
import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";

contract CreateOperatorSet is Script {
    IContractsRegistry public contractsRegistry;
    IAllocationManager public allocationManager;

    function setUp() public {
        allocationManager = IAllocationManager(MainnetConstants.ALLOCATION_MANAGER);
        contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    }

    function run(uint32 operatorSetId, address[] memory strategiesAddress) public {
        // Load the private key from the environment variable
        uint256 avsPrivateKey = vm.envUint("AVS_PRIVATE_KEY");
        address avs = vm.addr(avsPrivateKey);
        vm.startBroadcast(avsPrivateKey);
        IStrategy[] memory strategies = new IStrategy[](strategiesAddress.length);
        for (uint256 i = 0; i < strategiesAddress.length; i++) {
            strategies[i] = IStrategy(strategiesAddress[i]);
        }
        IAllocationManagerTypes.CreateSetParams[] memory createOperatorSetParams =
            new IAllocationManagerTypes.CreateSetParams[](1);
        createOperatorSetParams[0] =
            IAllocationManagerTypes.CreateSetParams({operatorSetId: operatorSetId, strategies: strategies});
        allocationManager.createOperatorSets(avs, createOperatorSetParams);
        console.log("Operator sets created: ", allocationManager.getOperatorSetCount(avs));
        vm.stopBroadcast();
    }
}
