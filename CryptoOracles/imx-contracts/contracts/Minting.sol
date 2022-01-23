// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./String.sol";


library Minting {

    
    // Split the minting blob into token_id and blueprint portions(dna, hash)
    // {token_id}:{blueprint}
    function deserializeMintingBlob(bytes memory mintingBlob) internal pure returns (uint256, string memory, string memory) {
        string[] memory idParams = String.split(string(mintingBlob), ":");
        require(idParams.length == 2, "Invalid blob");
        string memory tokenIdString = idParams[0];//string memory tokenIdString = String.substring(idParams[0], 1, bytes(idParams[0]).length - 1);
        string memory paramsString = idParams[1];//string memory paramsString = String.substring(idParams[1], 1, bytes(idParams[1]).length - 1);

        string[] memory paramParts = String.split(paramsString, ",");
        require(paramParts.length == 2, "Invalid param count");

        uint256 tokenId = String.toUint(tokenIdString);
        string memory dna = String.toUint(paramParts[0]);
        string memory hash_ipfs = paramParts[1];

        return (tokenId, dna, hasH_ipfs);
    }

}