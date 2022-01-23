// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Minting.sol";

contract Asset is ERC721, Ownable{
    
    struct Metadata {
        string dna;
        string hash_ipfs;
    }

    // Optional mapping for token URIs
    mapping (uint256 => Metadata) private metadata;

    address public imx;
        
    event NFTMinted(address to, uint256 id, string dna, string hash_ipfs);
    
    string private _currentBaseURI;

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        address _imx,
        string memory baseURI
    ) ERC721(_name, _symbol){
        imx = _imx;
        require(_owner != address(0), "Owner must not be empty");
        transferOwnership(_owner);
        setBaseURI(baseURI); //"https://gateway.pinata.cloud/ipfs/"
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner{
        _currentBaseURI = baseURI;
    }
    
    function _baseURI() internal view override returns(string memory){
        return _currentBaseURI;    
    }

    function mintFor(
        address to,
        uint256 quantity,
        bytes calldata mintingBlob
    ) public onlyOwnerOrIMX{
        require(quantity == 1, "Mintable: invalid quantity");
        (uint256 id, string memory dna, string memory hash_ipfs) = Minting.deserializeMintingBlob(mintingBlob);
        super._mint(to, id); 
        metadata[id] = Metadata(dna, hash_ipfs);   
        emit NFTMinted(user, id, dna, hash_ipfs);
    }
    
    function tokenURI(uint256 _tokenId) public view override returns (string memory){
        require(_exists(_tokenId), "Id already exists");
        string memory _hash = metadata[_tokenId].hash_ipfs;
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _hash)) : "URI invalid";
    }

    modifier onlyOwnerOrIMX() {
        require(msg.sender == imx || msg.sender == owner(), "Function can only be called by owner or IMX");
        _;
    }

}
