pragma solidity =0.5.16;

import './interfaces/IShadeFactory.sol';
import './ShadePair.sol';

contract ShadeFactory is IShadeFactory {
    address public feeTo;
    address public feeToSetter;
    bytes32 public constant INIT_CODE_PAIR_HASH= keccak256(abi.encodePacked(type(ShadePair).creationCode));

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Shade: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Shade: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Shade: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(ShadePair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IShadePair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'Shade: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'Shade: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
