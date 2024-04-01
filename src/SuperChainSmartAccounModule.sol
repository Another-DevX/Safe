// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ISafe} from "../interfaces/ISafe.sol";
import {Enum} from "../libraries/Enum.sol";

contract SuperChainSmartAccounModule {
    mapping(address => mapping(address => bool))
        private _isPopulatedAddOwnerWithThreshold;
    mapping(address => address) public superChainSmartAccount;

    function addOwnerWithThreshold(address _safe, address _newOwner) public {
        require(
            superChainSmartAccount[_newOwner] == address(0),
            "Owner already has a SuperChainSmartAccount"
        );
        require(
            _isPopulatedAddOwnerWithThreshold[_newOwner][_safe],
            "Owner not populated"
        );
        bytes memory data = abi.encodeWithSignature(
            "addOwnerWithThreshold(address,uint256)",
            _newOwner,
            1
        );
        bool success = ISafe(_safe).execTransactionFromModule(
            _safe,
            0,
            data,
            Enum.Operation.Call
        );

        require(success, "Failed to add owner");
    }
    function populateAddOwner(address _safe, address _newOwner) public {
        require(ISafe(_safe).isOwner(_newOwner), "Owner already exists");
        require(
            !_isPopulatedAddOwnerWithThreshold[_newOwner][_safe],
            "Owner already populated"
        );
        require(
            superChainSmartAccount[_newOwner] == address(0),
            "Owner already has a SuperChainSmartAccount"
        );
        _isPopulatedAddOwnerWithThreshold[_newOwner][_safe] = true;
    }
}
