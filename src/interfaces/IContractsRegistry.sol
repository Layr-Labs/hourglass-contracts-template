// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";

interface IContractsRegistry {
    function nameToAddress(
        string memory name
    ) external view returns (address);

    function registerContract(string memory contractName, address contractAddress) external;
}
