
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
interface InterfaceAirDrop {

    function AirDrop( address[] arrayAddresses, uint128 [] arrayValues) external;
    
}