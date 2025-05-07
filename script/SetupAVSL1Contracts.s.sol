// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {
    IAllocationManager,
    IAllocationManagerTypes
} from "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
import {IAVSRegistrar} from "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAVSRegistrar.sol";
import {IStrategy} from "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";
import {ITaskAVSRegistrar} from "@hourglass-monorepo/src/interfaces/avs/l1/ITaskAVSRegistrar.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";

contract SetupAVSL1Contracts is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    // Eigenlayer Core Contracts
    IAllocationManager public allocationManager;

    // Eigenlayer Strategies

    function setUp() public {
        allocationManager = IAllocationManager(MainnetConstants.ALLOCATION_MANAGER);
    }

    function run(
        string memory metadataURI
    ) public {
        address taskAVSRegistrar = contractsRegistry.nameToAddress("TaskAVSRegistrar");
        // Load the private key from the environment variable
        uint256 avsPrivateKey = vm.envUint("AVS_PRIVATE_KEY");
        address avs = vm.addr(avsPrivateKey);

        vm.startBroadcast(avsPrivateKey);

        // 1. Update the AVS metadata URI
        allocationManager.updateAVSMetadataURI(avs, metadataURI);
        // 2. Set the AVS Registrar
        allocationManager.setAVSRegistrar(avs, IAVSRegistrar(taskAVSRegistrar));
        // console.log("AVS Registrar set:", address(allocationManager.getAVSRegistrar(avs)));

        vm.stopBroadcast();
    }
}
