
# Mellow contest details

- Join [Sherlock Discord](https://discord.gg/MABEWyASkp)
- Submit findings using the issue page in your private contest repo (label issues as med or high)
- [Read for more details](https://docs.sherlock.xyz/audits/watsons)

# Q&A

### Q: On what chains are the smart contracts going to be deployed?
Ethereum
___

### Q: If you are integrating tokens, are you allowing only whitelisted tokens to work with the codebase or any complying with the standard? Are they assumed to have certain properties, e.g. be non-reentrant? Are there any types of [weird tokens](https://github.com/d-xo/weird-erc20) you want to integrate?
whitelisted tokens:
eth
weth - https://etherscan.io/token/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
steth - https://etherscan.io/token/0xae7ab96520de3a18e5e111b5eaab095312d7fe84
wsteth - https://etherscan.io/token/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0
___

### Q: Are there any limitations on values set by admins (or other roles) in the codebase, including restrictions on array lengths?
Only the parameters from the deployment script below:
https://github.com/mellow-finance/mellow-lrt/blob/dev-symbiotic-deploy/scripts/mainnet/Deploy.s.sol#L9


___

### Q: Are there any limitations on values set by admins (or other roles) in protocols you integrate with, including restrictions on array lengths?
No.
___

### Q: For permissioned functions, please list all checks and requirements that will be made before calling the function.
Users should call all functions only if they have the appropriate permissions according to the code.
___

### Q: Is the codebase expected to comply with any EIPs? Can there be/are there any deviations from the specification?
 Vault.sol is an optionally compliant with EIP-20 standard with transfer blocking capability.
___

### Q: Are there any off-chain mechanisms or off-chain procedures for the protocol (keeper bots, arbitrage bots, etc.)?
No.
___

### Q: Are there any hardcoded values that you intend to change before (some) deployments?
No.
___

### Q: If the codebase is to be deployed on an L2, what should be the behavior of the protocol in case of sequencer issues (if applicable)? Should Sherlock assume that the Sequencer won't misbehave, including going offline?
There will be no deployment to L2.
___

### Q: Should potential issues, like broken assumptions about function behavior, be reported if they could pose risks in future integrations, even if they might not be an issue in the context of the scope? If yes, can you elaborate on properties/invariants that should hold?
No.
___

### Q: Please discuss any design choices you made.
Withdrawal from the system consists of two steps. The first step is always the call to the registerWithdrawal function, which is initiated by the user.

There are two possible scenarios afterward:

    The Vault Manager calls the processAll (or processWithdrawals) function of the DefaultBondStrategy, which processes pending withdrawal requests. In this case, the funds are immediately transferred to the users' balances.
    If the Manager does not process the requests within the emergencyWithdrawalDelay period for any reason, the user can call the emergencyWithdraw function, which will withdraw the corresponding portion of tokens from the system. In this scenario, the user formally receives a portion of each ERC20 token in the system, determined by the ratio lpAmount / totalSupply.
___

### Q: Please list any known issues and explicitly state the acceptable risks for each known issue.
In src/oracles/ChainlinkOracle.sol, the priceX96 function does not take into account IERC20(base).decimals() and IERC20(token).decimals() when converting. For the current deployment, this is not a problem because the system operates with tokens from the set [weth, wsteth, steth].

All findings from the Statemind audit report.
___

### Q: We will report issues where the core protocol functionality is inaccessible for at least 7 days. Would you like to override this value?
No.
___

### Q: Please provide links to previous audits (if any).
https://github.com/mellow-finance/mellow-lrt/blob/dev-symbiotic-deploy/audits/202406_Statemind/Mellow%20LRT%20report%20with%20deployment.pdf
___

### Q: Please list any relevant protocol resources.
https://docs.mellow.finance/mellow-lrt-primitive/overview
https://docs.mellow.finance/mellow-lrt-primitive/lrt-contracts
https://docs.mellow.finance/mellow-lrt-primitive/contract-deployments
https://docs.mellow.finance/mellow-lrt-primitive/user-tutorials
https://mellowprotocol.notion.site/Mellow-LRT-Contracts-8dd218fa23a84df489fb31b3e6221f10?pvs=74

___



# Audit scope


[mellow-lrt @ a7165a279330a213d7d24b0b2ea6adf2d61b8d69](https://github.com/mellow-finance/mellow-lrt/tree/a7165a279330a213d7d24b0b2ea6adf2d61b8d69)
- [mellow-lrt/src/Vault.sol](mellow-lrt/src/Vault.sol)
- [mellow-lrt/src/VaultConfigurator.sol](mellow-lrt/src/VaultConfigurator.sol)
- [mellow-lrt/src/libraries/external/FullMath.sol](mellow-lrt/src/libraries/external/FullMath.sol)
- [mellow-lrt/src/modules/DefaultModule.sol](mellow-lrt/src/modules/DefaultModule.sol)
- [mellow-lrt/src/modules/erc20/ERC20TvlModule.sol](mellow-lrt/src/modules/erc20/ERC20TvlModule.sol)
- [mellow-lrt/src/modules/erc20/ManagedTvlModule.sol](mellow-lrt/src/modules/erc20/ManagedTvlModule.sol)
- [mellow-lrt/src/modules/obol/StakingModule.sol](mellow-lrt/src/modules/obol/StakingModule.sol)
- [mellow-lrt/src/modules/symbiotic/DefaultBondModule.sol](mellow-lrt/src/modules/symbiotic/DefaultBondModule.sol)
- [mellow-lrt/src/modules/symbiotic/DefaultBondTvlModule.sol](mellow-lrt/src/modules/symbiotic/DefaultBondTvlModule.sol)
- [mellow-lrt/src/oracles/ChainlinkOracle.sol](mellow-lrt/src/oracles/ChainlinkOracle.sol)
- [mellow-lrt/src/oracles/ConstantAggregatorV3.sol](mellow-lrt/src/oracles/ConstantAggregatorV3.sol)
- [mellow-lrt/src/oracles/ManagedRatiosOracle.sol](mellow-lrt/src/oracles/ManagedRatiosOracle.sol)
- [mellow-lrt/src/oracles/WStethRatiosAggregatorV3.sol](mellow-lrt/src/oracles/WStethRatiosAggregatorV3.sol)
- [mellow-lrt/src/security/AdminProxy.sol](mellow-lrt/src/security/AdminProxy.sol)
- [mellow-lrt/src/security/DefaultProxyImplementation.sol](mellow-lrt/src/security/DefaultProxyImplementation.sol)
- [mellow-lrt/src/security/Initializer.sol](mellow-lrt/src/security/Initializer.sol)
- [mellow-lrt/src/strategies/DefaultBondStrategy.sol](mellow-lrt/src/strategies/DefaultBondStrategy.sol)
- [mellow-lrt/src/strategies/SimpleDVTStakingStrategy.sol](mellow-lrt/src/strategies/SimpleDVTStakingStrategy.sol)
- [mellow-lrt/src/utils/DefaultAccessControl.sol](mellow-lrt/src/utils/DefaultAccessControl.sol)
- [mellow-lrt/src/utils/DepositWrapper.sol](mellow-lrt/src/utils/DepositWrapper.sol)
- [mellow-lrt/src/utils/RestrictingKeeper.sol](mellow-lrt/src/utils/RestrictingKeeper.sol)
- [mellow-lrt/src/validators/AllowAllValidator.sol](mellow-lrt/src/validators/AllowAllValidator.sol)
- [mellow-lrt/src/validators/DefaultBondValidator.sol](mellow-lrt/src/validators/DefaultBondValidator.sol)
- [mellow-lrt/src/validators/ManagedValidator.sol](mellow-lrt/src/validators/ManagedValidator.sol)

