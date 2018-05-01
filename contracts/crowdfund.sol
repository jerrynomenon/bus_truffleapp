pragma solidity ^0.4.17;

contract crowdFund { 



    address owner;

    address developer;

    

    /* Public variables of the token */

    string public name;

    string public symbol;

    uint8 public decimals;



    /* This creates an array with all balances */

    mapping (address => uint256) public balanceOf;



    /* This generates a public event on the blockchain that will notify clients */

    event Transfer(address indexed from, address indexed to, uint256 value);



    function crowdFund(string tokenName, uint8 decimalUnits, string tokenSymbol) {

        name = tokenName;                                   // Set the name for display purposes     

        symbol = tokenSymbol;                               // Set the symbol for display purposes    

        decimals = decimalUnits;                            // Amount of decimals for display purposes   

        

        owner = msg.sender;

    }



    /* send tokens, can only be called by contract */

    function transfer(address _to, uint256 _value) internal {

        balanceOf[this] -= _value;                          // Subtract from the sender

        balanceOf[_to] += _value;                            // Add the same to the recipient            

        Transfer(this, _to, _value);                        // Notify anyone listening that this transfer took place

    }

    

    function invest(){

        transfer(msg.sender, msg.value/1 ether); // convert value from wei to ether

    }

    

    function returnFunds(uint256 _value){

        if(balanceOf[msg.sender]<_value)_value = balanceOf[msg.sender]; // if less than funds, send total amount

        transfer(this, _value);

        uint256 amountInEther = _value * 1 ether; 

        msg.sender.send(amountInEther);

    }

    

    function payOut(uint256 amount){

        if(balanceOf[msg.sender]<amount)amount = balanceOf[msg.sender];

        transfer(this, amount);

        developer.send(amount);

    }

    

    function changeDeveloper(address v){

        if(msg.sender != owner)throw;

        developer = v;

    }

    

    function changeOwner(address v){

        if(msg.sender != owner)throw;

        owner = v;

    }

}    