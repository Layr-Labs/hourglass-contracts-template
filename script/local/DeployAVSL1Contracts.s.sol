// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {IAllocationManager} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";

import {TaskAVSRegistrar} from "../../src/l1-contracts/TaskAVSRegistrar.sol";

contract DeployAVSL1Contracts is Script {
    // Eigenlayer Core Contracts
    IAllocationManager public ALLOCATION_MANAGER = IAllocationManager(0x948a420b8CC1d6BFd0B6087C2E7c344a2CD0bc39);

    function setUp() public {}

    function run(
        address avs
    ) public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        address deployer = vm.addr(deployerPrivateKey);

        // 1. Deploy the TaskAVSRegistrar middleware contract
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        TaskAVSRegistrar taskAVSRegistrar = new TaskAVSRegistrar(avs, ALLOCATION_MANAGER);
        console.log("TaskAVSRegistrar deployed to:", address(taskAVSRegistrar));

        vm.stopBroadcast();

        // Add the addresses object
        string memory addresses = "addresses";
        addresses = vm.serializeAddress(addresses, "taskAVSRegistrar", address(taskAVSRegistrar));

        // Add the chainInfo object
        string memory chainInfo = "chainInfo";
        vm.serializeUint(chainInfo, "chainId", block.chainid);
        chainInfo = vm.serializeUint(chainInfo, "deploymentBlock", block.number);

        // Add parameters object
        string memory parameters = "parameters";
        parameters = vm.serializeAddress(parameters, "avs", avs);

        // Finalize the JSON
        string memory finalJson = "final";
        vm.serializeString(finalJson, "addresses", addresses);
        vm.serializeString(finalJson, "chainInfo", chainInfo);
        finalJson = vm.serializeString(finalJson, "parameters", parameters);

        // Write to output file
        string memory outputFile = string.concat("script/local/", "output/deploy_avs_l1_output.json");
        vm.writeJson(finalJson, outputFile);
    }
}
