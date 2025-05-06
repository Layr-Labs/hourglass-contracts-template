// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {Constants} from "src/constants.sol";
import {AllocationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/core/AllocationManager.sol";
    import {IAllocationManagerTypes} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
    import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";
import {OperatorSet} from "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/libraries/OperatorSetLib.sol";
contract ModifyAllocations is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(Constants.CONTRACTS_REGISTRY);
    AllocationManager allocationManager;
    function setUp() public {
        allocationManager = AllocationManager(contractsRegistry.nameToAddress("allocationManager"));
    }

    function run(uint operatorPvtKey,address strategy ,uint64 allocation ,address avs,uint32 operatorSetId) public {

        address operator = vm.addr(operatorPvtKey);
        // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);

        allocationManager.setAllocationDelay(operator,0);
        vm.warp(10000);
        IAllocationManagerTypes.AllocateParams[] memory allocations = new IAllocationManagerTypes.AllocateParams[](1);
        OperatorSet memory opSet = OperatorSet({avs: avs,id:operatorSetId});
        IStrategy[] memory istrategy = new IStrategy[](1);
        istrategy[0] = IStrategy(strategy);
        uint64[] memory magnitudes = new uint64[](1);
        magnitudes[0] = allocation;
        allocations[0] = IAllocationManagerTypes.AllocateParams({operatorSet:opSet,strategies: istrategy,newMagnitudes:magnitudes});
        allocationManager.modifyAllocations(operator,allocations);
      
        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
