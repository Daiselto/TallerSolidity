// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election{
    address[] private candidates;
    address[] private authorizedVoters;
    address[] private registeredVoters;
    mapping(address=>uint256) private voteEmited;
    mapping(address => bool) private voted;
    mapping(address => bool) private authorized;
    mapping(address => bool) private registered; 
    mapping(address => bool) private _candidates;

    uint private totalVotes;
    bool private electionEnded; 
    address private owner;

    event emitedVote(address user, bytes32 voteHash);
    event openElection(bool electionEnded);
    event closeElection(address[] candidates, uint256[] votes, address winner);
    event registeredVoter(address user);

    constructor(){
        totalVotes=0;
        owner=msg.sender;

    }

    function openElections() public {
        require(electionEnded==false, "La eleccion ya esta abierta");
        electionEnded=false;
        emit openElection(electionEnded);
    }

    function closeElections() public {
        require(electionEnded==true, "La eleccion ya esta cerrada");
        electionEnded=true;

        uint256[] memory votesperCandidate = new uint256[](candidates.length);
        address winner;
        uint256 maxVotes=0;

        for (uint256 i = 0 ; i<candidates.length; i++)  {
            votesperCandidate[i]=voteEmited[candidates[i]];
            if (voteEmited[candidates[i]] > maxVotes) {
                maxVotes=voteEmited[candidates[i]];
                winner=candidates[i];
            }
        }
        emit closeElection(candidates, votesperCandidate, winner);

    }

    function UserRegister(address user) public  {
        require(authorized[user], "No esta autorizado");
        require(!registered[user], "Usuario ya esta registrado");
        registered[user]=true;
        registeredVoters.push(user);
        emit registeredVoter(user);
    }
    

    function addAuthorized(address user) public{
        require(msg.sender == owner, "Solo el dueno puede agregar");
        require(!authorized[user], "Usuario ya esta registrado");
        authorized[user]=true;
        authorizedVoters.push(user);
    }

    function vote(address user, address candidate) public {
         require(electionEnded==false, "Eleccion ya finalizo");
         require(registered[user], "Usuario ya esta registrado");
         require(_candidates[candidate], "Candidato no valido");
         totalVotes++;
         voteEmited[candidate]++;
         voted[user]=true;
         bytes32 voteHash=keccak256(abi.encodePacked(msg.sender, candidate));
         emit emitedVote(user, voteHash);
    }

    function addCandidate(address candidate) public {
        candidates.push(candidate);
        voteEmited[candidate]= 0;
        _candidates[candidate]=true;
    }



    }

    
