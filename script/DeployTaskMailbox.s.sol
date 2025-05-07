// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {TaskMailbox} from "@hourglass-monorepo/src/core/TaskMailbox.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";

contract DeployTaskMailbox is Script {
    IContractsRegistry public contractsRegistry;

    function setUp() public {
        contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    }

    function run() public {
        // Get the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the TaskMailbox contract
        TaskMailbox taskMailbox = new TaskMailbox();

        // Log the contract address
        console.log("TaskMailbox deployed to:", address(taskMailbox));
        contractsRegistry.registerContract("TaskMailbox", address(taskMailbox));
        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
