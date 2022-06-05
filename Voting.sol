// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    constructor(string memory _ballotOfficialName, string memory _proposal) {
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;
        proposol = _proposal;

        state = State.Created;
    }

    struct vote {
        address voterAddress;
        bool choice;
    }

    struct voter {
        string voterName;
        bool voted;
    }

    uint private countResult = 0;
    uint public finalResult = 0;
    uint public totalVoter = 0;
    uint public totalVotes = 0;

    address public ballotOfficialAddress;
    string public ballotOfficialName;
    string public proposol;

    mapping(uint => vote) private vote;
    mapping(address => voter) public voterRegister;

    enum State {
        Created,
        Voting,
        Ended
    }
    State public state;
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyOfficial() {
        require(msg.sender == ballotOfficialAddress);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.created)
        onlyOfficial
    {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter ++ ;
    }

    function startVote() public inState(State.Created) onlyOfficial  {
        state = State.Voting;
    }

    function doVote(bool _choice) public inState(State.Voting) returns (bool voted) {
        bool found = false;

        if (voterRegister[msg.sender].voterName.length !=0 && !voterRegister[msg.sender].voted) {
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if (_choice) {
                countResult++;
            }            
            vote[totalVotes] = v;
            totalVotes++;
            found = true;
        }
        return found;
    }

    function endVote(){}

}
