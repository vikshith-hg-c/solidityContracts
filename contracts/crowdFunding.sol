//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract fundRaiser {

    mapping (address => uint) public contributers;
    address manager;
    uint public target;
    uint public deadline;
    uint public minContribution = 100 wei;
    uint public noOfcontributers;

    struct  request{
        string  description;
        uint  amount;
        address recipient;
        uint  noOfVoters;
        bool isPaid;
        mapping (address => bool) voters;
    }

    uint public noOfRequest=0;
    mapping(uint => request) public requests;

    constructor(uint _target,uint _deadline){
        manager = payable(msg.sender);
        target = _target;
        deadline = block.timestamp+_deadline;
    }

    function getBalance() public view returns(uint) {
        return(address(this).balance);
    }

    function sendFund() public payable{
        require(block.timestamp <= deadline, 'Thanks for your interst');
        require(msg.value >= minContribution, 'minimum amount : 100 wei');
        if (contributers[msg.sender] != 0){contributers[msg.sender] = contributers[msg.sender]+msg.value;}
        else {contributers[msg.sender] = msg.value; noOfcontributers++;}
    }

    function refund() public payable contributersAuth {
        payable(msg.sender).transfer(contributers[msg.sender]);
        contributers[msg.sender] = 0;
        noOfcontributers--;
    }

    function openRequest(string memory _description,address _recipient,uint _amount ) ManagerAuth public {
        
        request storage newRequest = requests[noOfRequest];
        noOfRequest++;
        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.recipient = _recipient;
    }

    function vote(uint _selectedRequest) public contributersAuth {
        request storage selected = requests[_selectedRequest];
        require(selected.voters[msg.sender] == false, 'You have voted');
        selected.noOfVoters++;
        selected.voters[msg.sender] == true;

    }

    function makePayment(uint _selectedRequest) public ManagerAuth{
        require(address(this).balance >=target && block.timestamp > deadline);
        request storage selected = requests[_selectedRequest];
        require(selected.noOfVoters > noOfcontributers/2);
        payable(selected.recipient).transfer(address(this).balance);
        selected.isPaid = true;
    }


    modifier contributersAuth {
        require(contributers[msg.sender] > 0,'You never contributed');
        _;
    }
    
    modifier ManagerAuth {
        require(msg.sender == manager, 'Not authorized');
        _;
    }

    
}
