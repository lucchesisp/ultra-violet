// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract ERC20 {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract UltraViolet is Ownable, ERC20{
    uint internal _totalSupply;
    mapping(address => uint) internal _balances;
    mapping(address => mapping(address => uint)) internal _allowed;

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return _balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(_balances[msg.sender] >= tokens);
        require(to != address(0));
        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        _allowed[msg.sender][spender] = tokens;
        
        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return _allowed[tokenOwner][spender];
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(_balances[from] >= tokens);
        require(to != address(0));

        _balances[from] = _balances[from].sub(tokens);
        _balances[to] = _balances[to].add(tokens);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

        emit Transfer(from, to, tokens);

        return true;
    }
}

contract MintableToken is UltraViolet {
    string public constant name = "Ultra Violet";
    string public constant symbol = "UVT";
    uint8 public constant decimals = 18;

    event Mint(address indexed to, uint tokens);

    function mint(address to, uint tokens) onlyOwner public {
        _balances[to] = balances[to].add(tokens);
        _totalSupply = _totalSupply.add(tokens);

        emit Mint(to, tokens);
    }
}