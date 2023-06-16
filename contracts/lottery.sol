//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract lottery {

    address payable admin;
    address payable[] public participants;
    uint public poolsize;
    uint public entryFee;
    uint public currentPoolSize = 0;
    address payable public lucky;
    


    constructor(uint _poolsize,uint _entryFee) {
        admin = payable(msg.sender);
        poolsize = _poolsize;
        entryFee = _entryFee;
    }

    receive() external payable{
        require(msg.value >= entryFee, '"minimum fee" + entryFee');
        participants.push(payable(msg.sender));
        currentPoolSize += 1;
    }

    function poolAmount() external view returns(uint){
        return address(this).balance;

    }

    function winner() external payable{
        require(participants.length >= poolsize,'pool doesnot have enough participants');
        lucky = participants[uint((keccak256(abi.encodePacked(block.difficulty,block.timestamp,block.timestamp+participants.length,participants.length))))%participants.length];
        lucky.transfer(address(this).balance);
        delete participants;
    }
}