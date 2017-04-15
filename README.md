# Bet Secure
Bet upon the sercurity of Dapps. 

# How it works
A bounty is created which defines the github commit hash and the scope of the bug bounty
and a deadline for no bugs being found. 

A betting market is created where people can be at the market odds on wheather a bug
within the defined scope will be found in the given git code commit hash. 

If a bug is found the centralized oracle will call `confirmBug` which will pay out the people
who bet for a bug. 

Otherwise once the deadline passes the people who bet that no bug would be found will be paid out. 

# Intention
This system will allow for a market that rewards the search for bugs in smart contracts.

It will also allow for people to hedge their positions of holding tokens against security bugs. 

It is hoped that people hedging their positions will fund security researches to find bugs.

# Market Mechanism
The sale of new tokens is always open. However the pay out is adjusted based upon the total bet on
the opposite side of the market. 

```
priceNoBug = (bounty.totalNoBug + msg.value) /
        (bounty.totalBug + bounty.totalNoBug + msg.value) ;

priceBug = (bounty.totalBug + msg.value) /
        (bounty.totalBug + bounty.totalNoBug + msg.value) ;
```
Users can only withdraw after the payout has happened or after a bug has been accepted by the oracle. 

# Tokenization
These bets are tokenized using the miniMe token which is totally ERC20 complient. 
They can be traded on Exchange, Used with leverate smart contracts or used to create 
risk minimized portfolio tokens. 

