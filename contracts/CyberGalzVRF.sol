// SPDX-License-Identifier: Business Source License 1.1
// license: Business Source License 1.1!
// effectively a time-delayed GPL-2.0-or-later license.
// The license limits use of the this source code in a commercial or production setting for up to two years, at which point it will convert to a GPL license into perpetuity.
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

// ╋╋╋╋╋╋╋┏┓╋╋╋╋╋╋╋╋╋╋╋╋┏┓
// ╋╋╋╋╋╋╋┃┃╋╋╋╋╋╋╋╋╋╋╋╋┃┃
// ┏━━┳┓╋┏┫┗━┳━━┳━┳━━┳━━┫┃┏━━━┓
// ┃┏━┫┃╋┃┃┏┓┃┃━┫┏┫┏┓┃┏┓┃┃┣━━┃┃
// ┃┗━┫┗━┛┃┗┛┃┃━┫┃┃┗┛┃┏┓┃┗┫┃━━┫
// ┗━━┻━┓┏┻━━┻━━┻┛┗━┓┣┛┗┻━┻━━━┛
// ╋╋╋┏━┛┃╋╋╋╋╋╋╋╋┏━┛┃
// ╋╋╋┗━━┛╋╋╋╋╋╋╋╋┗━━┛

contract CyberGalzVRF is VRFConsumerBase, Ownable {
	bytes32 internal keyHash;
	uint256 internal fee;

	uint256[] public randomResults; //keeps track of the random number from chainlink
	uint256 public totalDraws = 0; //drawID is drawID-1!
	string[] public ipfsProof; //proof list where the list participants is
	mapping(bytes32 => uint256) public requestIdToDrawIndex;

	event IPFSProofAdded(string proof);
	event RandomRequested(bytes32 indexed requestId, address indexed roller);
	event RandomLanded(bytes32 indexed requestId, uint256 indexed result);
	event Winners(uint256 randomResult, uint256[] expandedResult);
	event Winner(uint256 randomResult, uint256 winningNumber);

	constructor(
		address _vrfCoordinator,
		address _linkToken,
		bytes32 _keyHash,
		uint256 _fee
	) VRFConsumerBase(_vrfCoordinator, _linkToken) {
		keyHash = _keyHash;
		fee = _fee;
	}

	//you start by calling this function and having in IPFS the list of participants
	function addContestData(string memory ipfsHash) external onlyOwner {
		ipfsProof.push(ipfsHash);
		emit IPFSProofAdded(ipfsHash);
	}

	/**
	 * Requests randomness
	 */
	function getRandomNumber() external onlyOwner returns (bytes32 requestId) {
		require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in the contract");
		requestId = requestRandomness(keyHash, fee);
		emit RandomRequested(requestId, msg.sender);
		requestIdToDrawIndex[requestId] = totalDraws;
		return requestId;
	}

	/**
	 * Callback function used by VRF Coordinator
	 */
	function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
		randomResults.push(randomness);
		totalDraws++;
		emit RandomLanded(requestId, randomness);
	}

	//------ other things --------
	function withdrawLink() external onlyOwner {
		LINK.transfer(owner(), LINK.balanceOf(address(this)));
	}
}
