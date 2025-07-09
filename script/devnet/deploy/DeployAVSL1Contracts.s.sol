// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {IAllocationManager} from "@eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
import {IKeyRegistrar} from "@eigenlayer-contracts/src/contracts/interfaces/IKeyRegistrar.sol";

import {ITaskAVSRegistrarBaseTypes} from "@hourglass-monorepo/src/interfaces/avs/l1/ITaskAVSRegistrarBase.sol";

import {TaskAVSRegistrar} from "@project/l1-contracts/TaskAVSRegistrar.sol";

contract DeployAVSL1Contracts is Script {
    function run(
        string memory environment,
        address avs,
        address allocationManager,
        address keyRegistrar,
        uint32 aggregatorOperatorSetId,
        uint32 executorOperatorSetId
    ) public {
        // Load the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        address deployer = vm.addr(deployerPrivateKey);

        // Deploy the TaskAVSRegistrar middleware contract with proxy pattern
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deployer address:", deployer);

        // Create initial config
        uint32[] memory executorOperatorSetIds = new uint32[](1);
        executorOperatorSetIds[0] = executorOperatorSetId;
        ITaskAVSRegistrarBaseTypes.AvsConfig memory initialConfig = ITaskAVSRegistrarBaseTypes.AvsConfig({
            aggregatorOperatorSetId: aggregatorOperatorSetId,
            executorOperatorSetIds: executorOperatorSetIds
        });

        // Deploy ProxyAdmin
        ProxyAdmin proxyAdmin = new ProxyAdmin();
        console.log("ProxyAdmin deployed to:", address(proxyAdmin));

        // Deploy implementation
        TaskAVSRegistrar taskAVSRegistrarImpl = new TaskAVSRegistrar(
            avs, IAllocationManager(allocationManager), IKeyRegistrar(keyRegistrar)
        );
        console.log("TaskAVSRegistrar implementation deployed to:", address(taskAVSRegistrarImpl));

        // Deploy proxy with initialization
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(taskAVSRegistrarImpl),
            address(proxyAdmin),
            abi.encodeWithSelector(TaskAVSRegistrar.initialize.selector, avs, initialConfig)
        );
        console.log("TaskAVSRegistrar proxy deployed to:", address(proxy));

        // Transfer ProxyAdmin ownership to avs (or a multisig in production)
        proxyAdmin.transferOwnership(avs);

        vm.stopBroadcast();

        // Write deployment info to output file
        _writeOutputToJson(environment, address(proxy), address(taskAVSRegistrarImpl), address(proxyAdmin));
    }

    function _writeOutputToJson(string memory environment, address taskAVSRegistrarProxy, address taskAVSRegistrarImpl, address proxyAdmin) internal {
        // Add the addresses object
        string memory addresses = "addresses";
        vm.serializeAddress(addresses, "taskAVSRegistrar", taskAVSRegistrarProxy);
        vm.serializeAddress(addresses, "taskAVSRegistrarImpl", taskAVSRegistrarImpl);
        addresses = vm.serializeAddress(addresses, "l1ProxyAdmin", proxyAdmin);

        // Add the chainInfo object
        string memory chainInfo = "chainInfo";
        chainInfo = vm.serializeUint(chainInfo, "chainId", block.chainid);

        // Finalize the JSON
        string memory finalJson = "final";
        vm.serializeString(finalJson, "addresses", addresses);
        finalJson = vm.serializeString(finalJson, "chainInfo", chainInfo);

        // Write to output file
        string memory outputFile = string.concat("script/", environment, "/output/deploy_avs_l1_output.json");
        vm.writeJson(finalJson, outputFile);
    }
}
