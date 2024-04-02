// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ISafe} from "../interfaces/ISafe.sol";
import {Enum} from "../libraries/Enum.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract SuperChainSmartAccountModule is EIP712 {
    using ECDSA for bytes32;

    event OwnerPopulated(address indexed safe, address indexed newOwner);
    event OwnerAdded(address indexed safe, address indexed newOwner);

    mapping(address => mapping(address => bool))
        public _isPopulatedAddOwnerWithThreshold;
    mapping(address => address) public superChainSmartAccount;

    struct AddOwnerRequest {
        address superChainAccount;
        address newOwner;
    }

    constructor() EIP712("SuperChainSmartAccountModule", "1") {}

    function addOwnerWithThreshold(
        address _safe,
        address _newOwner,
        bytes calldata signature
    ) public {
        require(
            _verifySignature(_safe, _newOwner, signature),
            "Signature verification failed"
        );
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
        superChainSmartAccount[_newOwner] = _safe;
        emit OwnerAdded(_safe, _newOwner);
    }
    function populateAddOwner(address _safe, address _newOwner) public {
        require(msg.sender == _safe, "Caller is not the Safe");
        require(!ISafe(_safe).isOwner(_newOwner), "Owner already exists");
        require(
            !_isPopulatedAddOwnerWithThreshold[_newOwner][_safe],
            "Owner already populated"
        );
        require(
            superChainSmartAccount[_newOwner] == address(0),
            "Owner already has a SuperChainSmartAccount"
        );
        _isPopulatedAddOwnerWithThreshold[_newOwner][_safe] = true;
        emit OwnerPopulated(_safe, _newOwner);
    }

    function _verifySignature(
        address _safe,
        address _newOwner,
        bytes calldata signature
    ) public view returns (bool) {
        AddOwnerRequest memory request = AddOwnerRequest({
            superChainAccount: _safe,
            newOwner: _newOwner
        });

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256(
                    "AddOwnerRequest(address superChainAccount,address newOwner)"
                ),
                request.superChainAccount,
                request.newOwner
            )
        );

        bytes32 digest = _hashTypedDataV4(structHash);

        address signer = ECDSA.recover(digest, signature);

        if (signer == _newOwner) {
            return true;
        } else {
            return false;
        }
    }
}
