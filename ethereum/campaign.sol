pragma solidity ^0.8.19;


contract campaignFactory{
    address [] public deployedCampaign;

    function createCampaign (uint minimum) public{
        address newCampaign = new campaign(minimum, msg.sender);
        deployedCampaign.push(newCampaign);
    }

    function getDeployedCampaign() public view returns(address[]){
        return deployedCampaign;
    }

}
contract campaign{

    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    
    }


    address public manager;
    uint public minimumContribution;
    Request [] public requests;
    uint public approversCount;
    mapping(address => bool) public approvers;


    constructor(uint minimum, address creator) public{
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    function createRequest(string description, uint value, address recipient) public restricted{
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            approvalCount:0,
            complete:false
        });
        requests.push(newRequest);
    }

    function approveRequest(uint index) public{
        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount++;

    }

    function finalizeRequests(uint index) public restricted{
        Request storage request = requests[index];
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        request.recipient.transfer(request.value);
        request.complete = true;

    }

    function getRequestsCount() public view returns(uint){
        return requests.length;
    }
}