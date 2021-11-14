// SPDX-License-Identifier: MIT
//TODO - implement whitelisting 
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "./Mintable.sol";
import "@imtbl/imx-contracts/contracts/Mintable.sol";

contract Asset is ERC721, Mintable {
    
    struct Metadata {
        bytes manifestTx;
    }
    
    
    // Optional mapping for token URIs
    mapping (uint256 => Metadata) private metadata;
    
    string private _currentBaseURI;
    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        address _imx
    ) ERC721(_name, _symbol) Mintable(_owner, _imx) {
        setBaseURI("https://arweave.net/");
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner{
        _currentBaseURI = baseURI;
    }
    
    function _baseURI() internal view virtual override returns(string memory){
        return _currentBaseURI;    
    }
    


    function _mintFor(
        address user,
        uint256 id,
        bytes memory manifestTx
    ) internal override{
        //TODO - throw error if id is already used- dont override metadata
        metadata[id] = Metadata(manifestTx);
        _safeMint(user, id);
    }
    
    function claim(address user,
        uint256 id,
        bytes memory manifestTx) external {
        _mintFor(user, id, manifestTx);
    }
    
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
        require(_exists(_tokenId), "FUCK you");
        bytes memory manifestTx = metadata[_tokenId].manifestTx;
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, manifestTx)) : "fuck you";
    }

}
