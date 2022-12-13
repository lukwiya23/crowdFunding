// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint targetAmount;
        uint deadline;
        uint amountCollected;
        string image;
        address[] donators;
        uint[] donations;
    }

    mapping(uint => Campaign) public campaigns;

    uint public numberOfCampaigns = 0;

    // create a campaign
    function createCampaign(address _owner, string memory _title,
     string memory _description, uint _target, uint _deadline,
      string memory _image) public returns(uint)
      {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.targetAmount = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;
    }

// donate to a campaign of your choice
    function donateToCampaign(uint _id) public payable{
        uint amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(payable(msg.sender));
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // return a list of donors to a campaign
    function getDonators(uint _id) public view returns(address[] memory, uint[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns(Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i; i < numberOfCampaigns; i++){
            Campaign storage item =  campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}