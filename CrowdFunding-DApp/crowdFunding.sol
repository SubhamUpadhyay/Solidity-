// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//basically if the campaing succeed we will take the amount else we will return to the whoever contributed 

contract CrowdFunding{
    string public name; //campaign name
    string public description;
    uint256 public goal; //target amount
    uint256 public deadline; // ending time of the campagin 
    address owner; //the one who will deploy the campaign 
    bool public paused;

    enum CampaignState {Active,Successful,Failed}
    CampaignState public state;

    struct Tier{
        string name;
        uint256 amount;
        uint256 backers;
    }


    struct Backer{
        uint256 totalContribution;
        mapping(uint256=>bool) fundedTiers;

    }
    Tier[] public tiers;
    mapping(address => Backer) public backers;

    modifier  onlyOwner(){
        require(msg.sender == owner,"only the owner can access");
        _;
    }

    modifier campaignOpen(){
        require(state == CampaignState.Active,"campaign is not active");
        _;
    }

    modifier notPaused(){
        require(!paused,"Contract is paused.");
        _;
    }

    constructor(address _ownwer,string memory _name , string memory _description , uint256 _goal , uint  _deadline){
        name = _name;
        description= _description;
        goal = _goal;
        deadline = block.timestamp + (_deadline * 1 days);
        owner = _ownwer;
        state = CampaignState.Active;
    }

    function checkAndUpdateCampaignState() internal{
        if(state == CampaignState.Active)
        {
            if(block.timestamp >= deadline)
                {
                    state = address(this).balance >= goal?CampaignState.Successful:CampaignState.Failed;
                }else 
                {
                    state = address(this).balance >= goal?CampaignState.Successful:CampaignState.Active;
                }
        }
    }

    function fund(uint256 _tierIndex) public payable  campaignOpen notPaused
    {
        //require(msg.value > 0,"Must fund amount greater than 0.");
        //require(block.timestamp <= deadline,"campaign have ended ");
        require(_tierIndex < tiers.length,"Invalid tier");
        require(msg.value == tiers[_tierIndex].amount,"Incorrect amount");
        tiers[_tierIndex].backers++;
        backers[msg.sender].totalContribution += msg.value;
        backers[msg.sender].fundedTiers[_tierIndex] = true;

        checkAndUpdateCampaignState();

    }

    function addTier(string memory _tier , uint256 _amount) public onlyOwner
    {
        require(_amount>0,"Amount must be greater than 0");
        tiers.push(Tier(_tier,_amount,0));
    }
    function removeTier(uint256 _index) public  onlyOwner
    {
        require(_index<tiers.length,"Tier doesn't exist");
        tiers[_index] = tiers[tiers.length-1];
        tiers.pop();
    }   

    function withdraw() public onlyOwner
    {
        checkAndUpdateCampaignState();
        require(state==CampaignState.Successful,"Campaign not successful");
        //require(address(this).balance >= goal," Goal has not been reached");

        uint256 balance = address(this).balance;
        require(balance > 0 ,"No balance to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns(uint256)
    {
        return address(this).balance;
    }

    function get_owner_id() public view returns(address)
    {
        return msg.sender;
    }

    function refund() public {
        checkAndUpdateCampaignState();
        require(state == CampaignState.Failed,"Refund not Available");
        uint256 amount = backers[msg.sender].totalContribution;
        require(amount >0,"No contribution to refund");

        backers[msg.sender].totalContribution = 0;
        payable(msg.sender).transfer(amount);
    }

    function hasFundedTier(address _backer,uint256 _tierIndex) public view returns(bool)
    {
        return backers[_backer].fundedTiers[_tierIndex];
    }


    function getTiers() public view returns(Tier[] memory)
    {
        return tiers;
    }


    function togglePause() public onlyOwner{
        paused = !paused;
    }

    function getCampaignStatus() public view returns(CampaignState)
    {
        if(state == CampaignState.Active && block.timestamp > deadline)
        {
            return address(this).balance>=goal?CampaignState.Successful:CampaignState.Failed;
        }
        return state;
    }

    function extendDeadline(uint256 _daysToAdd) public  onlyOwner campaignOpen
    {
        deadline += _daysToAdd * 1 days;
    }



}
