// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

interface IERC20 {

    //Returns the number of existing tokens
    function totalSupply() external view returns (uint256);

    //Returns the number of tokens held by an `account`
    function balanceOf(address account) external view returns (uint256);

    /* Make a transfer of tokens to a recipient.
    Returns a boolean value indicating whether the operation was successful. 
    Emit a {Transfer} event */
    function transfer(address from, address to, uint256 amount) external returns (bool);

    /* It is issued when a token transfer is made. 
    Note that `value` can be zero. */
    event Transfer(address indexed from, address indexed to, uint256 value);
}

// Smart Contract of ERC20 tokens
contract ERC20 is IERC20 {

    // Data structures
    mapping(address => uint256) private _balances;
    
    // Variables
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address public owner;

    modifier onlyOwner(address _direccion) {
        require(_direccion == owner, "You do not have permissions to run this function.");
        _;
    }

    /* Sets the value of the token name and symbol. 
    The default value for {decimaes} is 18. To select a different value for
    {decimals} we must replace it. */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
    }

    // Returns the name of the token.
    function name() public view virtual returns (string memory) {
        return _name;
    }

    // Returns the token symbol, usually a shorter version of the name.
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /* Returns the number of decimal places used to obtain your user representation.
    For example, if `decimals` is equal to `2`, a balance of `505` tokens would
    be displayed to the user as `5.05` (`505/10**2`).
    Tokens usually opt for a value of 18, imitating the relationship between
    Ether and Wei. This is the value that {ERC20} uses, unless this function is
    be annulled. */
    function decimals() public view virtual returns (uint8) {
        return 0;
    }

    // Ver: {IERC20-totalSupply}.
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    // Ver: {IERC20-balanceOf}.
    function balanceOf(address account) public view virtual override returns (uint256) {       
        return _balances[account];
    }

    /* Ver: {IERC20-transfer}.
    Requirements:
    - `to` cannot be address zero.
    - the person executing must have a balance of at least `amount`. */
    function transfer(address from,address to, uint256 amount) public virtual override returns (bool) {
        _transfer(from, to, amount);
        return true;
    }

    function mint(uint256 amount) public virtual onlyOwner(msg.sender) returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }

    /* Moves `amount` of tokens from `sender` to `recipient`.
    This internal function is equivalent to {transfer}, and can be used to
    for example, implementing automatic token fees, etc.
    Emit a {Transfer} event.
    Requirements:
    - `from` and `to` cannot be zero addresses.
    - `from` must have a balance of at least `amount`. */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    /* Creates `amount` tokens and assigns them to `account`, increasing
    the total supply.
    Emits a {Transfer} event with "from" as address zero.
    Requirements:
    - `account` cannot be address zero. */
    function _mint(address account, uint256 amount) internal virtual{
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
}