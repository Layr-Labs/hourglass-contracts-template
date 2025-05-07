// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {StrategyManager} from "@eigenlayer-contracts/src/contracts/core/StrategyManager.sol";
import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";
import {MainnetConstants} from "src/MainnetConstants.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@eigenlayer-contracts/src/contracts/core/DelegationManager.sol";
import "forge-std/Test.sol";

contract DepositIntoStrategies is Script, Test {
    IContractsRegistry public contractsRegistry = IContractsRegistry(MainnetConstants.CONTRACTS_REGISTRY);
    StrategyManager strategyManager;
    DelegationManager delegationManager;

    function setUp() public {
        strategyManager = StrategyManager(MainnetConstants.STRATEGY_MANAGER);
        delegationManager = DelegationManager(MainnetConstants.DELEGATION_MANAGER);
    }

    function run(address strategy, uint256 operatorPvtKey) public {}
}
