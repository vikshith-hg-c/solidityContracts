//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract will {

    struct kid{
        uint amount;
        uint maturity;
        bool paid;
        bool authflag;
    }

    uint256 public value;
    mapping(address => kid) public  kids;
    address admin;
    uint noOfKids;
    constructor() {
        admin = msg.sender;
    }

    
    function addkid(address _kidAddress,uint _caluculatedMaturity) external payable {
        require(msg.sender == admin, 'its is not your will');
        require(kids[_kidAddress].authflag == false,'kid exists');
        kids[_kidAddress] = kid(msg.value,block.timestamp + _caluculatedMaturity,false,true); 

    }

    function updateKidAddress(address _kidOldAddress,address _kidNewAddress) external {
        require(msg.sender == admin, 'bolimagne kalla');
        require((kids[_kidOldAddress].authflag == true && kids[_kidOldAddress].paid == false),'update failed');
        kids[_kidNewAddress] = kid(kids[_kidOldAddress].amount,kids[_kidOldAddress].maturity,false,true);
        kids[_kidOldAddress].authflag=false;
         
    }
   


    function withdraw() external {
        require(kids[msg.sender].authflag == true, 'Not authorized' );
        require(kids[msg.sender].maturity <= block.timestamp,'not matured');
        require(kids[msg.sender].paid == false, 'You have been paid');
        kids[msg.sender].paid = true;
        payable(msg.sender).transfer(kids[msg.sender].amount);
    }

}