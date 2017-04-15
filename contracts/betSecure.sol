pragma solidity ^0.4.4;

import "./MiniMeToken.sol";

contract betSecure {

    address oracle;

    struct bounty {
        string commitHash;
        string scope;
        uint tokenGenTime;
        uint bountyTime;
        MiniMeToken bug;
        uint totalBug;
        MiniMeToken noBug;
        uint totalNoBug;
        bool isBug;
    }

    mapping (string => bounty) bounties;
 
    modifier onlyOracle() {
        if (msg.sender != oracle) {
            throw;
            _;
        }
    }

    function betSecure (address _oracle) {
        oracle = _oracle;
    }

    //USER

    function bet (string _commitHash, bool _bug) payable {
        var bounty = bounties[_commitHash];
        uint price;
        if (_bug == true) {  
            price = (bounty.totalBug + msg.value) /
                    (bounty.totalBug + bounty.totalNoBug + msg.value) ;
            if (!bounty.bug.generateTokens(msg.sender, msg.value + msg.value*price)) {throw;}
            bounty.totalBug += msg.value;
            if (bounty.bug.totalSupply() >= bounty.totalBug) {throw;} //invarient
        }
        else {
            price = (bounty.totalNoBug + msg.value) /
                    (bounty.totalBug + bounty.totalNoBug + msg.value) ;
            if(!bounty.noBug.generateTokens(msg.sender, msg.value + msg.value*price)) {throw;}
            bounty.totalNoBug += msg.value;
            if (bounty.noBug.totalSupply() >= bounty.totalNoBug) {throw;} //invarient
        }
    }

    function collect (string _commitHash) {
        MiniMeToken token;
        uint currentBal;
        if(now > bounties[_commitHash].bountyTime && 
           bounties[_commitHash].isBug == false) {
            token = bounties[_commitHash].noBug;
            currentBal = bounties[_commitHash].totalNoBug; 
        }
        if (bounties[_commitHash].isBug == true) {
            token = bounties[_commitHash].bug;  
        }
        payOut(_commitHash, token, currentBal);
    }

    // Private Internal
    function payOut (string _commitHash, MiniMeToken token,
                     uint currentBal) private {
        uint amount = token.balanceOf(msg.sender);
        if(!token.transferFrom(msg.sender, 0x0, amount)) {throw;}
        if(!msg.sender.send(amount)) {throw;}
    }
    

    // Only ORACLE!
    function addBounty (string _commitHash, string _scope,
                        uint _tokenGenTime, uint _bountyTime,
                        string bugTokenName, string bugTokenNameShort,
                        string noBugTokenName, string NoBugTokenNameShort) 
                       onlyOracle  { 
        //if (bounties[_commitHash].commitHash != "") {throw;}
        MiniMeTokenFactory miniMeFactory;
        MiniMeToken _bug = miniMeFactory.createCloneToken(0x0,0,
                                         bugTokenName,18,bugTokenNameShort,true);
        MiniMeToken _noBug = miniMeFactory.createCloneToken(0x0,0,
                                         noBugTokenName,18,NoBugTokenNameShort,true);
        bounties[_commitHash]=bounty(_commitHash, _scope, _tokenGenTime, 
                                     _bountyTime, _bug,0, _noBug,0, false);
    }

    function confirmBug (string _commitHash) onlyOracle {
        bounties[_commitHash].isBug = true;
    }

    function updateOracle (address _oracle) onlyOracle {
        oracle = _oracle;
    }
}
