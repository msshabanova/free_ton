
ragma ton-solidity >= 0.39.0;
pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;


import "Interfaces/InterfaceAirDrop.sol";
import "Interfaces/ITONTokenWallet.sol";
import "Libraries/MsgFlag.sol";
import "CheckOwner.sol";

// This is class that describes you smart contract.
contract ClientAirDrop is CheckOwner {

    address token;
    address token_wallet;
    address AirDropAddress;

    uint128 constant transfer_grams = 0.5 ton;


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

    function transferTokensForAirDrop (address AirDropAddress, uint256 amount) public pure checkOwnerAndAccept {

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

   

    function doAirDrop  (address AirDropAddress,  address [] arrayAddresses, uint256 [] arrayValues) public pure checkOwnerAndAccept {
        InterfaseAirDrop(AirDropAddress).AirDrop (arrayAddresses, arrayValues);
    }

}