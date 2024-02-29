pragma solidity ^0.8.0;

contract ChatCode {

    mapping(address => mapping(address=>bool)) friend;
 
    constructor(){}
    modifier selfCheck(address person){
    require(msg.sender != person, "cannot request yourself");
    _;
    }

    modifier request(address person){
        require(friend[msg.sender][person] == false,"Friend request already accepted"); 
        require(friend[person][msg.sender] == true, "Friend request not present");
        _;
    }

    function requestFriend(address person) selfCheck(person) public {
        require(friend[msg.sender][person] != true, "Friend request already requested");
        require(friend[person][msg.sender] != true, "Friend request already received");
        friend[msg.sender][person] = true;
    }

    function cancelFriendRequest(address person) selfCheck(person) public {
        require(friend[msg.sender][person] == true, "Friend request not sent");
        require(friend[person][msg.sender] != true, "Friend request already accepted");
        delete friend[msg.sender][person];
    }

    function approveFriendRequest(address person) request(person) selfCheck(person) public {    
            friend[msg.sender][person] = true;
    }

    function rejectFriendRequest(address person) request(person) selfCheck(person) public{
            delete friend[person][msg.sender];
    }

    function verifyFriendshipStatus(address person1, address person2) public view returns(bool)
    { 
        if(friend[person1][person2] == true && friend[person2][person1] == true) return true;
        else return false;
    }
}
