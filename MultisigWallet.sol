// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultisigWallet {
    address public owner;
    mapping(address => bool) public isVoter;

    struct Proposal {
        uint256 id;
        address to;
        uint256 value;
        bytes data;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 id, address to, uint256 value, bytes data);
    event Voted(uint256 id, address voter, bool support);
    event Executed(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address[] memory voters) {
        owner = msg.sender;
        for (uint i = 0; i < voters.length; i++) {
            isVoter[voters[i]] = true;
        }
    }

    function addProposal(address to, uint256 value, bytes memory data) external onlyOwner {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.to = to;
        p.value = value;
        p.data = data;

        emit ProposalCreated(proposalCount, to, value, data);
    }

    function vote(
        uint256 id,
        bool support,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");

        bytes32 messageHash = keccak256(abi.encodePacked(p.id, p.to, p.value, p.data));
        bytes32 ethSignedMessageHash = toEthSignedMessageHash(messageHash);

        address signer = ecrecover(ethSignedMessageHash, v, r, s);
        require(isVoter[signer], "Invalid signer");
        require(!p.voted[signer], "Already voted");

        p.voted[signer] = true;

        if (support) {
            p.yesVotes++;
        } else {
            p.noVotes++;
        }

        emit Voted(id, signer, support);
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.yesVotes > p.noVotes, "Not enough yes votes");

        p.executed = true;

        (bool success, ) = p.to.call{value: p.value}(p.data);
        require(success, "Transaction failed");

        emit Executed(id);
    }

    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
    }

    // 컨트랙트가 이더를 받을 수 있도록
    receive() external payable {}
}