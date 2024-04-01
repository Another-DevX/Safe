// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Guard} from "../src/Guard.sol";
import {SuperChainSmartAccounModule} from "../src/SuperChainSmartAccounModule.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Guard guard = new Guard();
        SuperChainSmartAccounModule module = new SuperChainSmartAccounModule();
        
         console.logString(
            string.concat(
                "SuperChainSmartAccounModule deployed at: ",
                vm.toString(address(module)),
                "\n",
                "Guard deployed at: ",
                vm.toString(address(guard))
            )
        );
        vm.stopBroadcast();
    }
}
