pragma solidity ^0.4.23;

//VFY Test Token Contract
//Base capabilities: Token has capability for set of hard cap, with ability to mint up to hard cap, initialize at 0.
//Also capability to brun tokens from specific burner address, set by owner and can be changed.

import "./ERC20.sol"; //Pulls in ERC20 and ERC20Basic
import "./MintableToken.sol"; //Allows minting of token

//Note - add crowdsale capabilities for token

//Additions: added capability to set burner address, Adam L

contract VFYTESTA is ERC20, MintableToken {

 uint256 public cap = 1000000000; //Hard cap for token
 string public name = "VFY-TESTA"; // Name of token
 string public symbol = "VFYT"; // Symbol
 uint8 public decimals = 18; //Decimals`
 address public torch; //set burner address

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    require(totalSupply_.add(_amount) <= cap);

    return super.mint(_to, _amount);
  }

 event Burn(address indexed burner, uint256 value);

    //Set's burner address
  function setBurnaddress(address burnaddress) public {
       torch = burnaddress;
  }

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */

  function burn(uint256 _value) public {
    _burn(torch, _value); //burns only the tokens in the burner address; set by owner
  }

  function _burn(address _who, uint256 _value) onlyOwner hasMintPermission internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }

}
