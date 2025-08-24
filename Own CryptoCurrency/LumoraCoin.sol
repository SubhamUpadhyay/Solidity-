// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lumora_Coin {
    modifier checkCoin(uint amount) {
        require(amount > 0, "Amount should be greater than zero");
        _;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not the Owner");
        _;
    }

    address private owner;
    uint private _total_supply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint private initial_supply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(uint amount) checkCoin(amount) {
        _name = "Lumora";
        _symbol = "LMR";
        owner = msg.sender;
        
        _decimals = 18;
        initial_supply = amount*(10**uint(_decimals));
        balances[msg.sender] = initial_supply;
        _total_supply = initial_supply;
    }

    // ----- Basic ERC20 View Functions -----
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _total_supply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    // ----- ERC20 Write Functions -----
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address (burn account)");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "From address cannot be zero");
        require(_to != address(0), "Cannot transfer to zero address (burn account)");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Allowance exceeded");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // ----- Extra: Burn Function -----  => to adjust the cryptocurrency rate by reducing it 
    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient balance to burn");
        balances[msg.sender] -= _value;
        _total_supply -= _value;

        emit Transfer(msg.sender, address(0), _value); // Burn goes to zero address
        return true;
    }

    // ----- Extra: Mint Function (only owner) -----
    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        require(_to != address(0), "Cannot mint to zero address");

        balances[_to] += _value;
        _total_supply += _value;

        emit Transfer(address(0), _to, _value); // Mint from zero address
        return true;
    }
}
