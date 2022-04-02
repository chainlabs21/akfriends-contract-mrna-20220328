pragma solidity ^0.5.0;
import "./IKIP17.sol";
import "./KIP17.sol";
import "./KIP17Enumerable.sol";
import "./KIP17Metadata.sol";
import "./KIP17Mintable.sol";
/**
 * @title Full KIP-17 Token
 * This implementation includes all the required and some optional functionality of the KIP-17 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see http://kips.klaytn.com/KIPs/kip-17-non_fungible_token
 */
contract KIP17Full is KIP17
	, KIP17Enumerable
	, KIP17Metadata
	, KIP17Mintable
{
	address public _reward_token ;
	uint256 public _reward_amount = 1 * 10**18 ;
	address public _owner ;
	mapping (address => mapping ( uint256 => uint256 )) public _deposit_time ; // user => token id => timestamp
	constructor (string memory name, string memory symbol) public KIP17Metadata(name, symbol) { // solhint-disable-previous-line no-empty-blocks
		_owner = msg.sender ;
	}
	function set_reward_token ( address _address ) public {
  	require ( msg.sender == _owner , "ERR() not privileged") ;
    _reward_token = _address ;
  }
	function deposit ( address _erc721, uint256 _tokenid ) public {
		IKIP17 ( _erc721).safeTransferFrom ( msg.sender , address(this) , _tokenid) ;		
//		_balancesums [ msg.sender ] += 1; 
	//	_balances [msg.sender][ _tokenid] = 1;
    IKIP17 ( _erc721 ).approve ( msg.sender , _tokenid ) ;
//		_count_deposited += 1 ;
    if ( IERC20( _reward_token ).balanceOf( address(this) ) >= _reward_amount ) {
    	IERC20 (_reward_token).transfer ( msg.sender , _reward_amount ) ;
    } 
		else {}
		_deposit_time [ msg.sender ][ _tokenid ] = block.timestamp ;
//		emit Deposit ( _erc721 , _tokenid );
	}
	function deposit_batch ( address _erc721 , uint256 [] memory _tokenids ) public {
		uint256 N= _tokenids.length;
		for (uint256 i=0; i< N ; i++){
      uint256 tokenid = _tokenids[ i ] ;
			IKIP17 (_erc721).safeTransferFrom ( msg.sender , address ( this), tokenid ) ;
//			_balances [msg.sender][ tokenid ] = 1;
			IKIP17 ( _erc721 ).approve ( msg.sender , tokenid ) ;
			_deposit_time [ msg.sender ][ tokenid ] = block.timestamp ;
		}
//		_count_deposited += N ;
    if ( IERC20( _reward_token ).balanceOf( address(this) ) >=_tokenids.length * _reward_amount ) {
    	IERC20 (_reward_token).transfer ( msg.sender , _tokenids.length *  _reward_amount ) ;
		}
		else {}
//		_balancesums [ msg.sender ] += N ;
		emit Deposit ( _erc721 , _tokenids[ 0 ] );
	}
	function claim ( ) public {
		IERC20 ( _reward_token ).transfer ( msg.sender , _reward_amount ) ;
	}
  function mybalance ( address _token ) public view returns ( uint256 ){ 
		return IERC20( _token ).balanceOf ( address ( this ) );
  }
	function withdraw_fund ( address _token , address _to , uint256 _amount ) public {
  	require (msg.sender == _owner , "ERR() not privileged") ;
    IERC20( _token ).transfer ( _to , _amount );
	}
}