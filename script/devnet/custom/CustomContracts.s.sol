// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {IAllocationManager} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
import {ITaskMailbox, ITaskMailboxTypes} from "@hourglass-monorepo/src/interfaces/core/ITaskMailbox.sol";
import {ITaskAVSRegistrar, ITaskAVSRegistrarTypes} from "@hourglass-monorepo/src/interfaces/avs/l1/ITaskAVSRegistrar.sol";
import {IAVSTaskHook} from "@hourglass-monorepo/src/interfaces/avs/l2/IAVSTaskHook.sol";
import {IBN254CertificateVerifier} from "@hourglass-monorepo/src/interfaces/avs/l2/IBN254CertificateVerifier.sol";

contract CustomContracts is Script {
    using stdJson for string;

    struct Context {
        address avs;
        uint256 avsPrivateKey;
        uint256 deployerPrivateKey;
        ITaskMailbox taskMailbox;
        ITaskAVSRegistrar taskAVSRegistrar;
        IAVSTaskHook taskHook;
        IBN254CertificateVerifier certificateVerifier;
    }

    function run(string memory environment, string memory _context, address /* allocationManager */) public {
        // Read the context
        Context memory context = _readContext(environment, _context);

        vm.startBroadcast(context.deployerPrivateKey);
        console.log("Deployer address:", vm.addr(context.deployerPrivateKey));

        //TODO: Deploy the custom contracts
        // CustomContract customContract = new CustomContract();
        // console.log("CustomContract deployed to:", address(customContract));

        vm.stopBroadcast();

        vm.startBroadcast(context.avsPrivateKey);
        console.log("AVS address:", context.avs);

        //TODO: Do any additional AVS setup

        vm.stopBroadcast();
    }

    function _readContext(
        string memory environment,
        string memory _context
    ) internal view returns (Context memory) {
        // Parse the context
        Context memory context;
        context.avs = stdJson.readAddress(_context, ".context.avs.address");
        context.avsPrivateKey = uint256(stdJson.readBytes32(_context, ".context.avs.avs_private_key"));
        context.deployerPrivateKey = uint256(stdJson.readBytes32(_context, ".context.deployer_private_key"));
        context.taskMailbox = ITaskMailbox(_readHourglassConfigAddress(environment, "TaskMailbox"));
        context.taskAVSRegistrar = ITaskAVSRegistrar(_readAVSL1ConfigAddress(environment, "AVSRegistrar"));
        context.taskHook = IAVSTaskHook(_readAVSL2ConfigAddress(environment, "AVSTaskHook"));
        context.certificateVerifier = IBN254CertificateVerifier(_readAVSL2ConfigAddress(environment, "CertificateVerifier"));

        return context;
    }

    function _readHourglassConfigAddress(
        string memory environment,
        string memory key
    ) internal view returns (address) {
        // Load the Hourglass config file
        string memory hourglassConfigFile =
            string.concat("script/", environment, "/output/deploy_hourglass_core_output.json");
        string memory hourglassConfig = vm.readFile(hourglassConfigFile);

        // Parse and return the address
        return stdJson.readAddress(hourglassConfig, string.concat(".addresses.", key));
    }

    function _readAVSL1ConfigAddress(string memory environment, string memory key) internal view returns (address) {
        // Load the AVS L1 config file
        string memory avsL1ConfigFile = string.concat("script/", environment, "/output/deploy_avs_l1_output.json");
        string memory avsL1Config = vm.readFile(avsL1ConfigFile);

        // Parse and return the address
        return stdJson.readAddress(avsL1Config, string.concat(".addresses.", key));
    }

    function _readAVSL2ConfigAddress(string memory environment, string memory key) internal view returns (address) {
        // Load the AVS L2 config file
        string memory avsL2ConfigFile = string.concat("script/", environment, "/output/deploy_avs_l2_output.json");
        string memory avsL2Config = vm.readFile(avsL2ConfigFile);

        // Parse and return the address
        return stdJson.readAddress(avsL2Config, string.concat(".addresses.", key));
    }
}
