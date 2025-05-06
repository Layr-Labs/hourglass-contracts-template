// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {
    IAllocationManager,
    IAllocationManagerTypes
} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";

import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {Constants} from "src/constants.sol";
import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";

contract CreateOperatorSet is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(Constants.CONTRACTS_REGISTRY);
    IStrategy public STRATEGY_ST_ETH = IStrategy(0x93c4b944D05dfe6df7645A86cd2206016c51564D);

    IAllocationManager public allocationManager;

    function setUp() public {
        allocationManager = IAllocationManager(0x948a420b8CC1d6BFd0B6087C2E7c344a2CD0bc39);
    }

    function run(uint32 operatorSetId) public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        uint256 avsPrivateKey = vm.envUint("AVS_PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        address avs = vm.addr(avsPrivateKey);
        vm.startBroadcast(avsPrivateKey);

        IStrategy[] memory strategies = new IStrategy[](1);
        strategies[0] = STRATEGY_ST_ETH;
        IAllocationManagerTypes.CreateSetParams[] memory createOperatorSetParams =
            new IAllocationManagerTypes.CreateSetParams[](1);
        createOperatorSetParams[0] =
            IAllocationManagerTypes.CreateSetParams({operatorSetId: operatorSetId, strategies: strategies});
        allocationManager.createOperatorSets(avs, createOperatorSetParams);
        console.log("Operator sets created: ", allocationManager.getOperatorSetCount(avs));

        vm.stopBroadcast();
    }
}
