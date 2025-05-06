// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {IContractsRegistry} from "src/interfaces/IContractsRegistry.sol";
import {Constants} from "src/constants.sol";
import {AllocationManager} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/core/AllocationManager.sol";
import {IAllocationManagerTypes} from
    "@eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/interfaces/IAllocationManager.sol";
import {
    ITaskAVSRegistrar, ITaskAVSRegistrarTypes
} from "@hourglass-monorepo/src/interfaces/avs/l1/ITaskAVSRegistrar.sol";
import {BN254} from "@eigenlayer-middleware/src/libraries/BN254.sol";

contract RegisterOperatorToAvs is Script {
    IContractsRegistry public contractsRegistry = IContractsRegistry(Constants.CONTRACTS_REGISTRY);
    AllocationManager allocationManager;

    BN254.G1Point pubkeyG1;
    BN254.G2Point pubkeyG2;

    function setUp() public {
        allocationManager = AllocationManager(contractsRegistry.nameToAddress("allocationManager"));
    }

    function run(
        uint32 operatorSetId,
        uint256 operatorPvtKey,
        uint256 g1_x,
        uint256 g1_y,
        uint256 g2_x_0,
        uint256 g2_x_1,
        uint256 g2_y_0,
        uint256 g2_y_1,
        uint256 pubkeyRegistrationMessageHash_X,
        uint256 pubkeyRegistrationMessageHash_Y
    ) public {
        // Start broadcasting transactions
        vm.startBroadcast(operatorPvtKey);
        address operator = vm.addr(operatorPvtKey);
        uint256 avsPrivateKey = vm.envUint("AVS_PRIVATE_KEY");
        address avs = vm.addr(avsPrivateKey);
        uint32[] memory operatorSetIds = new uint32[](1);
        operatorSetIds[0] = operatorSetId;

        // Construct the G1 signature point
        BN254.G1Point memory signature =
            BN254.G1Point({X: pubkeyRegistrationMessageHash_X, Y: pubkeyRegistrationMessageHash_Y});

        // Construct the BLS pubkey (G1)
        pubkeyG1 = BN254.G1Point({X: g1_x, Y: g1_y});

        // Construct the BLS pubkey (G2)
        pubkeyG2 = BN254.G2Point({X: [g2_x_1, g2_x_0], Y: [g2_y_1, g2_y_0]});

        // Bundle into pubkey registration params
        ITaskAVSRegistrarTypes.PubkeyRegistrationParams memory pubkeyParams = ITaskAVSRegistrarTypes
            .PubkeyRegistrationParams({pubkeyRegistrationSignature: signature, pubkeyG1: pubkeyG1, pubkeyG2: pubkeyG2});

        // Compose final registration params
        ITaskAVSRegistrarTypes.OperatorRegistrationParams memory operatorRegistrationParams = ITaskAVSRegistrarTypes
            .OperatorRegistrationParams({socket: "localhost:1234", pubkeyRegistrationParams: pubkeyParams});

        // Encode the struct
        bytes memory data = abi.encode(operatorRegistrationParams);
        IAllocationManagerTypes.RegisterParams memory registerParams =
            IAllocationManagerTypes.RegisterParams({avs: avs, operatorSetIds: operatorSetIds, data: data});

        allocationManager.registerForOperatorSets(operator, registerParams);

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
