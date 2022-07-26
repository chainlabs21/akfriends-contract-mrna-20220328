pragma solidity ^0.5.0;

import "./KIP17-custom-mint.sol";
import "./KIP17Enumerable.sol";
import "./KIP17Metadata.sol";
import "./KIP17Mintable.sol";
/**
 * @title Full KIP-17 Token
 * This implementation includes all the required and some optional functionality of the KIP-17 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see http://kips.klaytn.com/KIPs/kip-17-non_fungible_token
 */
contract KIP17Full is KIP17, KIP17Enumerable, KIP17Metadata
 , KIP17Mintable
 {
    constructor (string memory name, string memory symbol) public KIP17Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}
