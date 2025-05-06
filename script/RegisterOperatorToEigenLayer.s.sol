// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {Constants} from "src/constants.sol";
import {DelegationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/core/DelegationManager.sol";

contract RegisterOperatorToEigenLayer is Script {
    // IContractsRegistry public contractsRegistry = IContractsRegistry(Constants.CONTRACTS_REGISTRY);
    DelegationManager delegationManager;

    function setUp() public {
        delegationManager = DelegationManager(0x39053D51B77DC0d36036Fc1fCc8Cb819df8Ef37A);
    }

    function run(uint256 operatorPvtKey) public {
        address operator = vm.addr(operatorPvtKey);
        // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);

        delegationManager.registerAsOperator(operator, 0, "devkit-cli-metadata");

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
