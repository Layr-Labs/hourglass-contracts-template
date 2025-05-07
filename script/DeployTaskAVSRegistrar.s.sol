// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {IAllocationManager} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";

import {TaskAVSRegistrar} from "../src/l1-contracts/TaskAVSRegistrar.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";

contract DeployTaskAVSRegistrar is Script {
    IContractsRegistry public contractsRegistry;
    IAllocationManager public allocationManager;

    function setUp() public {
        allocationManager = IAllocationManager(MainnetConstants.ALLOCATION_MANAGER);
        contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    }

    function run() public {
        // Load the private key from the environment variable
        uint256 avsPrivateKey = vm.envUint("AVS_PRIVATE_KEY");
        address avs = vm.addr(avsPrivateKey);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        address deployer = vm.addr(deployerPrivateKey);

        // 1. Deploy the TaskAVSRegistrar middleware contract
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        TaskAVSRegistrar taskAVSRegistrar = new TaskAVSRegistrar(avs, allocationManager);
        console.log("TaskAVSRegistrar deployed to:", address(taskAVSRegistrar));
        contractsRegistry.registerContract("TaskAVSRegistrar", address(taskAVSRegistrar));
        vm.stopBroadcast();
    }
}
