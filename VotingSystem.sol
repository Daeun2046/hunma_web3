// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingSystem {
    address public owner;

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 createdAt;
        bool exists;
    }

    mapping(address => bool) public isVoter;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public nextProposalId;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    modifier onlyVoter() {
        require(isVoter[msg.sender], "Only voter can do this");
        _;
    }

    constructor(address[] memory _voters) {
        owner = msg.sender;
        for (uint256 i = 0; i < _voters.length; i++) {
            isVoter[_voters[i]] = true;
        }
    }

    function addProposal(string memory _description) public onlyOwner {
        proposals[nextProposalId] = Proposal({
            id: nextProposalId,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            createdAt: block.timestamp,
            exists: true
        });
        nextProposalId++;
    }

    function vote(uint256 proposalId, bool support) public onlyVoter {
        require(proposals[proposalId].exists, "Proposal not found");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
    }

    function getProposal(uint256 proposalId) public view returns (
        string memory description,
        uint256 votesFor,
        uint256 votesAgainst,
        uint256 createdAt
    ) {
        require(proposals[proposalId].exists, "Proposal not found");
        Proposal memory p = proposals[proposalId];
        return (p.description, p.votesFor, p.votesAgainst, p.createdAt);
    }

    function checkResult(uint256 proposalId) public view returns (string memory result) {
        require(proposals[proposalId].exists, "Proposal not found");
        Proposal memory p = proposals[proposalId];
        require(block.timestamp >= p.createdAt + 5 minutes, "Voting still in progress");

        if (p.votesFor > p.votesAgainst) {
            return "Proposal Passed";
        } else if (p.votesFor < p.votesAgainst) {
            return "Proposal Rejected";
        } else {
            return "Tie";
        }
    }
}