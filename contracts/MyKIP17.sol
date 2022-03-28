pragma solidity ^0.5.6;

import "./token/KIP17/KIP17Full.sol";
import "./token/KIP17/KIP17Mintable.sol";
import "./token/KIP17/KIP17Burnable.sol";
import "./token/KIP17/KIP17Pausable.sol";
import "./ownership/Ownable.sol";
import "./math/SafeMath.sol";
import "./utils/Strings.sol";

contract MyKIP17 is KIP17Full, KIP17Mintable, KIP17Burnable, Ownable {
    using SafeMath for uint256;
    string private _baseTokenURI;

    constructor( 
        string memory _name,
        string memory _symbol,
        string memory _URI ) 
    KIP17Full(_name, _symbol) public 
    { setBaseTokenURI(_URI);}

    function setBaseTokenURI(string memory _URI) public onlyOwner {
        _setBaseTokenURI(_URI);
    }

    function _setBaseTokenURI(string memory _URI) internal {
        _baseTokenURI = _URI;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        return bytes(_baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI(), Strings.uint2str(_tokenId))) : "";
    }

    function baseTokenURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    function contractURI() public view returns (string memory) {
        return bytes(_baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI(), "contract")) : "";
    }

    function massMint(uint256 start, uint256 end, address toAddress) external onlyMinter {
        for (uint256 i = start; i <= end; i += 1) {
            mint(toAddress, i);
        }
    }

    function bulkTransfer(address[] calldata toAddresses, uint256[] calldata tokenIds) external {
        uint256 length = tokenIds.length;
        for (uint256 i = 0; i < length; i += 1) {
            transferFrom(msg.sender, toAddresses[i], tokenIds[i]);
        }
    }
}