// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@imtbl/imx-contracts/contracts/Mintable.sol";

contract Asset is ERC721, Mintable {
    
    struct Metadata {
        string dna;
        string hash;
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
        setBaseURI("https://gateway.pinata.cloud/ipfs/");
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
        bytes memory blueprint
    ) internal override{
        //TODO - throw error if id is already used- dont override metadata
        //encode blueprint at the source (in JavaScript): const data = abiCoder.encode(["string", "string"], [s1, s2])
        (string memory dna, string memory hash) = abi.decode(blueprint, (string, string));
        metadata[id] = Metadata(dna, hash);
        _safeMint(user, id);
    }
    
    function claim(address user,
        uint256 id,
        bytes memory manifestTx) external {
        _mintFor(user, id, manifestTx);
    }
    
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
        require(_exists(_tokenId), "Id already exists");
        string memory hash = metadata[_tokenId].hash;
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, hash)) : "URI invalid";
    }

}
