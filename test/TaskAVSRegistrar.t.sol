// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {TaskAVSRegistrar} from "src/l1-contracts/TaskAVSRegistrar.sol";

contract TaskAVSRegistrarTest is Test {
    TaskAVSRegistrar public taskAVSRegistrar;

    function setUp() public {
        // Deploy the TaskAVSRegistrar contract
        taskAVSRegistrar = new TaskAVSRegistrar(address(0), address(0));
    }

    function testDummy() public pure returns (bool) {
        return true;
    }
}
