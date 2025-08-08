// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string private message;
    uint256 private messageCounter;
    mapping(address=>string) private userMessages;

    event MessageUpdate(string newMessage, address updateBy);
    event UserMessageStored(address user, string message);

    constructor(){
        message = "Hello World";
        messageCounter=0;
    }

    function getMessage() public view returns (string memory){
        return message; 
    }

    function setMessage(string memory newMessage) public{
        message=newMessage;
        messageCounter++;
        emit MessageUpdate(newMessage, msg.sender);
    } 
    
    function getMessageCounter() public view returns (uint256){
        return messageCounter;
    }

    function getUserMessages(address user) public view returns (string memory){
        return userMessages[user];
    }

    function storeUserMessage(string memory userMessage) public {
        userMessages[msg.sender]=userMessage;
        messageCounter++;
    }

    function combineMessages() public returns (string memory){
        
        require(bytes(userMessages[msg.sender]).length > 0, "No user Message");

        string memory combined=string(
            abi.encodePacked(
                message,
                " & ",
                userMessages[msg.sender]
            )
        );
        message = combined;
        messageCounter++;
        emit MessageUpdate(combined, msg.sender);
        return combined;
    }
}