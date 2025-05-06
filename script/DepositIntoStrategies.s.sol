// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {StrategyManager} from "@eigenlayer-contracts/src/contracts/core/StrategyManager.sol";
import {IStrategy} from "@eigenlayer-contracts/src/contracts/interfaces/IStrategy.sol";
import {Constants} from "src/constants.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@eigenlayer-contracts/src/contracts/core/DelegationManager.sol";
import "forge-std/Test.sol";

contract DepositIntoStrategies is Script, Test {
    // IContractsRegistry public contractsRegistry = IContractsRegistry(Constants.CONTRACTS_REGISTRY);
    StrategyManager strategyManager;
    DelegationManager delegationManager;

    function setUp() public {
        strategyManager = StrategyManager(0x858646372CC42E1A627fcE94aa7A7033e7CF075A);
        delegationManager = DelegationManager(0x39053D51B77DC0d36036Fc1fCc8Cb819df8Ef37A);
    }

    function run(address strategy, uint256 operatorPvtKey) public {
        IStrategy[] memory istrategies = new IStrategy[](1);
        istrategies[0] = IStrategy(strategy);

        vm.startBroadcast();

        vm.stopBroadcast();
        // // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);
        IStrategy istrategy = IStrategy(strategy);
        address operator = vm.addr(operatorPvtKey);
        address token = address(istrategy.underlyingToken());
        vm.assume()
        // StdCheats.deal(address(token), address(operator), 10000 ether);

        // uint256 balance = IERC20(token).balanceOf(operator);
        // require(IERC20(token).approve(address(strategyManager), type(uint256).max),"failed to approve");
        // strategyManager.depositIntoStrategy(IStrategy(strategy), IERC20(token), IERC20(token).balanceOf(operator));  

        vm.stopBroadcast();
    }
}
