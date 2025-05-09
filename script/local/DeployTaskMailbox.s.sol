// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {TaskMailbox} from "@hourglass-monorepo/src/core/TaskMailbox.sol";

contract DeployTaskMailbox is Script {
    using stdJson for string;

    function setUp() public {}

    function run() public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        address deployer = vm.addr(deployerPrivateKey);

        // Deploy the TaskMailbox contract
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        TaskMailbox taskMailbox = new TaskMailbox();
        console.log("TaskMailbox deployed to:", address(taskMailbox));

        vm.stopBroadcast();

        // Add the addresses object
        string memory addresses = "addresses";
        addresses = vm.serializeAddress(addresses, "taskMailbox", address(taskMailbox));

        // Add the chainInfo object
        string memory chainInfo = "chainInfo";
        vm.serializeUint(chainInfo, "chainId", block.chainid);
        chainInfo = vm.serializeUint(chainInfo, "deploymentBlock", block.number);

        // Add parameters object
        string memory emptyParams = "{}";

        // Finalize the JSON
        string memory finalJson = "final";
        vm.serializeString(finalJson, "addresses", addresses);
        vm.serializeString(finalJson, "chainInfo", chainInfo);
        finalJson = vm.serializeString(finalJson, "parameters", emptyParams);

        // Write to output file
        string memory outputFile = string.concat("script/local/", "output/deploy_hourglass_core_output.json");
        vm.writeJson(finalJson, outputFile);
    }
}
