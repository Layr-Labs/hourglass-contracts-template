// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";
import {AllocationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/core/AllocationManager.sol";
import {IAllocationManagerTypes} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";
import {OperatorSet} from "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/libraries/OperatorSetLib.sol";

contract ModifyAllocations is Script {
    AllocationManager allocationManager;

    function setUp() public {
        allocationManager = AllocationManager(MainnetConstants.ALLOCATION_MANAGER);
    }

    function run(
        uint256 operatorPvtKey,
        address[] memory strategies,
        uint64[] memory magnitudes,
        address avs,
        uint32 operatorSetId
    ) public {
        address operator = vm.addr(operatorPvtKey);
        // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);
        uint256 strategiesLength = strategies.length;
        uint256 magnitudesLength = magnitudes.length;

        require(strategiesLength == magnitudesLength, "strategies and magnitudes length should be equal");
        // allocationManager.setAllocationDelay(operator, 0);
        IAllocationManagerTypes.AllocateParams[] memory allocations = new IAllocationManagerTypes.AllocateParams[](1);
        OperatorSet memory opSet = OperatorSet({avs: avs, id: operatorSetId});

        IStrategy[] memory istrategies = new IStrategy[](strategiesLength);
        for (uint256 i = 0; i < strategiesLength; i++) {
            istrategies[i] = IStrategy(strategies[i]);
        }
        allocations[0] = IAllocationManagerTypes.AllocateParams({
            operatorSet: opSet,
            strategies: istrategies,
            newMagnitudes: magnitudes
        });
        allocationManager.modifyAllocations(operator, allocations);

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
