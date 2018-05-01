pragma solidity ^0.4.11;

contract LockBox {


    function LockBox(address _renter, address _landlord, address _arbitrator, uint _timestampExpired) payable {

        assert(_timestampExpired > now);


        actors.push(_renter);

        actors.push(_landlord);

        actors.push(_arbitrator);

        timestampExpired = _timestampExpired;

    }



    /*

       Any of the initially specified actors can call confirm().

       Once there are enough confirmations (2) confirm releases funds back tp renter.

    */

    function confirm() only_actor {

        confirmations[msg.sender] = true;

        if (isConfirmed()) {

            // use call to forward gas in case complex function receives gas

            assert(renter().call.value(this.balance)());

        }

    }



    /*

        Sender can void escrow agreement after expiration.

        Voiding sends all funds held in contract back to the sender.

    */

    function void() only_renter {

        assert(now > timestampExpired);

        // use call to forward gas in case complex function receives gas

        assert(renter().call.value(this.balance)());

    }



    /*

       Sender of funds in contract.

       Only party that can void and return funds

    */

    function renter() constant returns (address) {

        return actors[0];

    }



    /*

       Recipient of funds in contract.

       Receives funds after two confirms from distinct valid parties

    */

    function landlord() constant returns (address) {

        return actors[1];

    }



    /*

       Arbitrator of escrow contract

       Can act as 1 of the 3 required actors for `confirm`ing

    */

    function arbitrator() constant returns (address) {

        return actors[2];

    }



    /*

       Count number of confirms

       returns true if two or more

    */

    function isConfirmed() constant returns (bool) {

        uint confCount = 0;

        for (uint i = 0; i < actors.length; i++) {

            if (confirmations[actors[i]]) {

                confCount++;

            }

        }

        return (confCount >= 2);

    }



    /*

       returns true if address is either the sender, recipient, or arbitrator

    */

    function isActor(address addr) constant returns (bool) {

        for (uint i = 0; i < actors.length; i++) {

            if (actors[i] == addr) return true;

        }

        return false;

    }



    modifier only_actor { require(isActor(msg.sender)); _; }

    modifier only_renter { require(renter() == msg.sender); _; }



    address[] public actors;

    mapping (address => bool) public confirmations;

    uint public timestampExpired;

}