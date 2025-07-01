// name=ERC20.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20 {
    string public name = "ERC20";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

<<<<<<< Updated upstream
=======
    address public owner;

>>>>>>> Stashed changes
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

<<<<<<< Updated upstream
=======
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

>>>>>>> Stashed changes
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Not enough balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not allowed");
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

<<<<<<< Updated upstream
    function mint(address to, uint256 amount) public {
=======
    function mint(address to, uint256 amount) public onlyOwner {
>>>>>>> Stashed changes
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

<<<<<<< Updated upstream
    function burn(address from, uint256 amount) public {
            require(balanceOf[from] >= amount, "Insufficient balance");
            totalSupply -= amount;
            balanceOf[from] -= amount;
            emit Transfer(from, address(0), amount);
=======
    function burn(address from, uint256 amount) public onlyOwner {
        require(balanceOf[from] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balanceOf[from] -= amount;
        emit Transfer(from, address(0), amount);
>>>>>>> Stashed changes
    }
}