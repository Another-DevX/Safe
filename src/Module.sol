// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ISafe} from "../interfaces/ISafe.sol";
import {Enum} from "../libraries/Enum.sol";

contract Module {
    function addOwnerWithThreshold(
        address _safe,
        address _newOwner,
        uint256 _threshold
    ) public {
        address safe = _safe;

        bytes memory data = abi.encodeWithSignature(
            "addOwnerWithThreshold(address,uint256)",
            _newOwner,
            _threshold
        );
        bool success = ISafe(safe).execTransactionFromModule(
            safe,
            0,
            data,
            Enum.Operation.Call
        );

        require(success, "Failed to add owner");
    }
}
