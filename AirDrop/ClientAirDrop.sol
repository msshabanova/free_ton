
pragma ton-solidity >= 0.35.0;
pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Interfaces/IRootTokenContract.sol";
import "Interfaces/InterfaceAirDrop.sol";
import "Interfaces/ITONTokenWallet.sol";
import "Libraries/MsgFlag.sol";

// This is class that describes you smart contract.
contract ClientAirDrop  {

    address token;
    address token_wallet;

    uint128 constant deploy_wallet_grams = 0.2 ton;
    uint128 constant transfer_grams = 0.5 ton;

    address public owner;    
    
    function isInternalOwner(address forCheck) private inline view returns (bool) {
        return owner != address(0) && forCheck == owner;
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey() || isInternalOwner(msg.sender), 102);
        tvm.accept();
        _;
    }

    modifier checkOwner {
        require(msg.pubkey() == tvm.pubkey(), 107);
        _;
    }


    constructor(address _token) public {

        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

        token = _token;
        setUpTokenWallet();
    }

    function setUpTokenWallet() internal view {
        // Deploy token wallet
        IRootTokenContract(token).deployEmptyWallet{value: 1 ton}(
            deploy_wallet_grams,
            0,
            address(this),
            address(this)
        );

        // Request for token wallet address
        IRootTokenContract(token).getWalletAddress{
            value: 1 ton,
            callback: ClientAirDrop.setTokenWalletAddress
        }(0, address(this));
    }
    
    
    function setTokenWalletAddress(address wallet) external {
        require(msg.sender == token, 103);
        token_wallet = wallet;
    }

    function transferTokensForAirDrop (address AirDropAddress, uint128 amount) public view checkOwnerAndAccept {

        // Transfer tokens
        TvmCell empty;
        ITONTokenWallet(token_wallet).transfer{
            value: 0,
            flag: MsgFlag.ALL_NOT_RESERVED
        }(
            AirDropAddress,
            amount,
            transfer_grams,
            msg.sender,
            false,
            empty
        );
    }

    /*function sendTokensAndArraysToAirDrop (address AirDropAddress, uint256 valueOfTokens, address [] arrayRecieversAddr, uint [] arrayValues) public view checkOwnerAndAccept {
        address clientAddress = address(this);
        uint256 value = valueOfTokens;   
        InterfaseAirDrop(AirDropAddress).checkAirDrop(clientAddress, value, arrayRecieversAddr,  arrayValues);
    } */

   

    function doAirDrop  (address AirDropAddress,  address [] arrayAddresses, uint128 [] arrayValues) public pure checkOwnerAndAccept {
        InterfaceAirDrop(AirDropAddress).AirDrop (arrayAddresses, arrayValues);
    }

}