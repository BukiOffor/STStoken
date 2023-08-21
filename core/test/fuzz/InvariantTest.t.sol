// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

import {StellaHandler} from "./StellaHandler.t.sol";
import {Test} from "forge-std/Test.sol";
import {DeployStella} from "../../script/DeployStella.s.sol";
import { Stella} from "../../src/Stella.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";



contract InvariantTest is StdInvariant, Test {

    Stella sts;
    uint256 supply;
    uint256 amount;

    function setUp() external{
        DeployStella deployer = new DeployStella();
        (sts, supply,amount) = deployer.run();
        targetContract(address(sts));
    }

    function invariant_poolMustAlwaysBeConstant() public {
        uint _pool = amount * supply;
        uint pool = sts.getPool();
        assertEq(_pool, pool);

    }

}