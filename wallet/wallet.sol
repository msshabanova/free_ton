
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract wallet {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call
    uint32 public timestamp;

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

        timestamp = now;
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 103);
        tvm.accept();
        _;
    }

    function sendValueTaxIncluded (address dest, uint128 amount, bool bounce) public checkOwnerAndAccept view {
        // It allows to make a transfer with arbitrary settings
        dest.transfer(amount, bounce, 0);
    }
        
    function sendValueTaxNotIncluded (address dest, uint128 amount, bool bounce) public checkOwnerAndAccept view {
        // It allows to make a transfer with arbitrary settings
        dest.transfer(amount, bounce, 1);
    }
            
    function sendAllValueAndDestroy (address dest, uint128 amount, bool bounce) public checkOwnerAndAccept view {
        // It allows to make a transfer with arbitrary settings
        dest.transfer(amount, bounce, 160);
    }
}