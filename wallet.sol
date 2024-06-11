// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.19;

contract Wallet {

address public owner ;
mapping (address => User) public users ; 

struct User {
    address useraddress;
    uint allowance ;
    uint Validity ;
}

event RenewAllowance (address indexed _useraddress , uint allowance , uint TimeLimit ) ;
event SendCoin (address indexed reciver , uint amount) ; 

constructor () {
    owner =msg.sender ; 
}
modifier OnlyOwner {
    msg.sender == owner ; 
_;
}

function recieve () external payable OnlyOwner{}

function Getbalance () public view returns (uint) {
    return address(this).balance ;
} 

function AllowanceRenew (address _user , uint _allowance , uint _Timelimit) public OnlyOwner {
uint validity = block.timestamp + _Timelimit ; 
users [_user] = User (_user, _allowance , validity ) ; 
emit RenewAllowance(_user, _allowance, _Timelimit);
} 

function checkmyallowance () public view returns (uint) {
    return users[msg.sender].allowance ; 
}
function SpendCoins (address _reciever , uint _amount ) public {
   User storage users = users[msg.sender];
    require (_amount <= users.allowance , "Not Sufficient Allowance ") ; 
    require (block.timestamp <= users.validity , "Time has passed " ) ;
users.allowance -= _amount ; 
_reciever(_amount).transfer ; 
emit SendCoin(_reciever, _amount);
}










}
