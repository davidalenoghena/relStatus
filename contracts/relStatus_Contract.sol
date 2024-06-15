// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract relStatus_Contract {
    struct Profile {
        uint256 id;
        address profileAddress;
        string name;
        bool relStatus;
        address partner;
        string instID;
    }

    Profile[] public profiles;
    uint256 public profileCount = 0;
    //mapping(uint256 => Profile) public profiles;

    uint256 public numberOfProfiles = 0;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //check if the address exists
    function Search(address _profileAddress) public view returns (Profile memory) {
        bool exists = false;
        uint256 profileId;

        for (uint256 id = 0; id < profiles.length; id++) {
            if (profiles[id].profileAddress == _profileAddress) {
                exists = true;
                profileId = id;
            }
            else exists = false;
        }
        
        require(exists == true, "Address does not exist");
        //if the address exists, return the details of the profile

        return profiles[profileId];
    }
    
    //returns the ID of an address
    function returnID(address _profileAddress) private view returns (uint256) {
        bool exists = addressExist(_profileAddress);
        require(exists == false, "Address does not exist");

        uint256 profileId;

        for (uint256 id = 0; id < profiles.length; id++) {
            if (profiles[id].profileAddress == _profileAddress) {
                profileId = id;
            }
        }

        return profileId;
    }

    //check if an address exists in the database
    function addressExist(address _profileAddress) public view returns (bool) {
        for (uint256 id = 0; id < profiles.length; id++) {
            if (profiles[id].profileAddress == _profileAddress) {
                return true;
            }
            return false;
        }
    }

    //check if an instagram account exists in the database
    function instExist(string memory _instID) public view returns (bool) {
        for (uint256 id = 0; id < profiles.length; id++) {
            if (profiles[id].instID == _instID) {
                return true;
            }
            return false;
        }
    }

    //check if an address has been connected as a partner already
    function partnerExist(address _partnerID) public view returns (bool) {
        for (uint256 id = 0; id < profiles.length; id++) {
            if (profiles[id].partner == _partnerID) {
                return true;
            }
            return false;
        }
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
    
    //create a profile
    function createProfile(address owner, string memory _name, address _partner, string memory _instID) public {
        require(owner != _partner, "Your address and your partner's address cannot be the same");
        require(instExist(_instID) == false, "This Instagram ID already exists");
        profiles.push(Profile(profileCount, owner, _name, false, _partner, _instID));
        profileCount ++;
    }

    //fetch all the profiles
    function getProfiles() public view returns (Profile[] memory) {
        return profiles;
    }

    //update relationship status to single/in_rel
    function update_relStatus(uint256 _profileId) public {
        profiles[_profileId].relStatus = !profiles[_profileId].relStatus;
    } 

    //connect to a partner
    function connectPartner(address _partner) public {
        require(partnerExist(_partner) == false, "Partner already connected");
        uint256 ownerId = returnID(owner);
        profiles[ownerId].partner = _partner;
    }

    //disconnect from a partner
    function disconnectPartner() public {
        uint256 ownerId = returnID(owner);
        profiles[ownerId].partner = address(0);
        profiles[ownerId].relStatus = false;
    }
    
    //check the relationship status of an address
    function check_relStatus() public view returns (bool) {
        uint256 ownerId = returnID(owner);
        bool Status = profiles[ownerId].relStatus;

        return Status;
    } 
}