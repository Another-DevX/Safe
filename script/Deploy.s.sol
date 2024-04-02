// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Guard} from "../src/Guard.sol";
import {SuperChainSmartAccountModule} from "../src/SuperChainSmartAccountModule.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Guard guard = new Guard();
        SuperChainSmartAccountModule module = new SuperChainSmartAccountModule();

        console.logString(
            string.concat(
                "SuperChainSmartAccountModule deployed at: ",
                vm.toString(address(module)),
                "\n",
                "Guard deployed at: ",
                vm.toString(address(guard))
            )
        );
        vm.stopBroadcast();
    }
}
