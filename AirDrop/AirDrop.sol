
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'InterfaseAirDrop.sol';

contract AirDrop {
    // mapping (address=>bool) public recipients;
    
    uint32 public timestamp;
    mapping (address=>uint256) ReceiversValues;

    constructor() public {

    }

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




    function checkAirDrop (address clientAddress, uint256 value, address [] arrayAddresses, uint256 [] arrayValues) OnlyOwner public {
        require(arrayAddresses.length = arrayValues.length && arrayAddresses > 0, 102);
        for (uint i = 0; i < arrayAddresses.length; i++) {
            ReceiversValues[arrayAddresses[i]] = arrayValues [i];
            uint sum += arrayValues [i];
        }
        require(sum > value, 103);
    }


}