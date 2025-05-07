// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {IAllocationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";

import {AVSTaskHook} from "../src/l2-contracts/AVSTaskHook.sol";
import {BN254CertificateVerifier} from "../src/l2-contracts/BN254CertificateVerifier.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";

contract DeployAVSL2Contracts is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);

    function setUp() public {}

    function run() public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);
        // Deploy the AVSTaskHook and CertificateVerifier contracts
        AVSTaskHook avsTaskHook = new AVSTaskHook();
        console.log("AVSTaskHook deployed to:", address(avsTaskHook));
        contractsRegistry.registerContract("AVSTaskHook", address(avsTaskHook));
        BN254CertificateVerifier bn254CertificateVerifier = new BN254CertificateVerifier();
        console.log("BN254CertificateVerifier deployed to:", address(bn254CertificateVerifier));
        contractsRegistry.registerContract("BN254CertificateVerifier", address(bn254CertificateVerifier));
        vm.stopBroadcast();
    }
}
