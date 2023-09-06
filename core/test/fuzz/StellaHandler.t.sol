// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import{ Stella } from "../../src/Stella.sol";
import { DeployStella } from "../../script/DeployStella.s.sol";
import {console} from "forge-std/console.sol";




contract StellaHandler is Test {

    Stella sts;
    uint96 public constant maxAmount = type(uint96).max;
    address user = makeAddr('user');

    
    constructor(Stella _sts ){
        sts = _sts;
    }


    function swapEthforSTS(uint256 _amount) payable external {
        vm.deal(address(this), (type(uint256).max));
        _amount = bound(_amount,1e18,1e18);
        uint balance = sts.balanceOf(address(sts));
        if( balance < 1e10 ){return ;}
        console.log("Remaining balance is ", balance);
        uint tokenprice = sts.requestSTSforETH(_amount);
        console.log("token price is ", tokenprice);
        sts.swapETHforSTS{value:_amount}();
        console.log("token is  swapped", tokenprice);

    }

    
}
