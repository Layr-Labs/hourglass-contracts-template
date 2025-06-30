// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";

import {IKeyRegistrarTypes} from "@eigenlayer-contracts/src/contracts/interfaces/IKeyRegistrar.sol";

import {ITaskMailboxTypes} from "@hourglass-monorepo/src/interfaces/core/ITaskMailbox.sol";
import {TaskMailbox} from "@hourglass-monorepo/src/core/TaskMailbox.sol";

contract DeployTaskMailbox is Script {
    function run(
        string memory environment,
        address bn254CertificateVerifier,
        address ecdsaCertificateVerifier
    ) public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        address deployer = vm.addr(deployerPrivateKey);

        // Deploy the TaskMailbox contract
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        ITaskMailboxTypes.CertificateVerifierConfig[] memory certificateVerifiers =
            new ITaskMailboxTypes.CertificateVerifierConfig[](2);
        certificateVerifiers[0] = ITaskMailboxTypes.CertificateVerifierConfig({
            curveType: IKeyRegistrarTypes.CurveType.BN254,
            verifier: bn254CertificateVerifier
        });
        certificateVerifiers[1] = ITaskMailboxTypes.CertificateVerifierConfig({
            curveType: IKeyRegistrarTypes.CurveType.ECDSA,
            verifier: ecdsaCertificateVerifier
        });

        TaskMailbox taskMailbox = new TaskMailbox(deployer, certificateVerifiers);
        console.log("TaskMailbox deployed to:", address(taskMailbox));

        vm.stopBroadcast();

        // Write deployment info to output file
        _writeOutputToJson(environment, address(taskMailbox));
    }

    function _writeOutputToJson(string memory environment, address taskMailbox) internal {
        // Add the addresses object
        string memory addresses = "addresses";
        addresses = vm.serializeAddress(addresses, "taskMailbox", taskMailbox);

        // Add the chainInfo object
        string memory chainInfo = "chainInfo";
        chainInfo = vm.serializeUint(chainInfo, "chainId", block.chainid);

        // Finalize the JSON
        string memory finalJson = "final";
        vm.serializeString(finalJson, "addresses", addresses);
        finalJson = vm.serializeString(finalJson, "chainInfo", chainInfo);

        // Write to output file
        string memory outputFile = string.concat("script/", environment, "/output/deploy_hourglass_core_output.json");
        vm.writeJson(finalJson, outputFile);
    }
}
