// SPDX-License-Identifier: BSL-1.1
pragma solidity 0.8.25;

import "./DeployScript.sol";
import "./DeployInterfaces.sol";
import "./Validator.sol";
import "./EventValidator.sol";

contract Deploy is Script, DeployScript, Validator, EventValidator {
    function run() external {
        uint256 n = 4;
        address[] memory curators = new address[](n);
        curators[0] = DeployConstants.STEAKHOUSE_MULTISIG;
        curators[1] = DeployConstants.RE7_MULTISIG;
        curators[2] = DeployConstants.AMPHOR_MULTISIG;
        curators[3] = DeployConstants.P2P_MULTISIG;

        string[] memory names = new string[](n);
        names[0] = DeployConstants.STEAKHOUSE_VAULT_NAME;
        names[1] = DeployConstants.RE7_VAULT_NAME;
        names[2] = DeployConstants.AMPHOR_VAULT_NAME;
        names[3] = DeployConstants.P2P_VAULT_NAME;

        string[] memory symbols = new string[](n);
        symbols[0] = DeployConstants.STEAKHOUSE_VAULT_SYMBOL;
        symbols[1] = DeployConstants.RE7_VAULT_SYMBOL;
        symbols[2] = DeployConstants.AMPHOR_VAULT_SYMBOL;
        symbols[3] = DeployConstants.P2P_VAULT_SYMBOL;

        DeployInterfaces.DeployParameters memory deployParams = DeployInterfaces
            .DeployParameters({
                deployer: DeployConstants.MAINNET_DEPLOYER,
                proxyAdmin: DeployConstants.MELLOW_LIDO_PROXY_MULTISIG,
                admin: DeployConstants.MELLOW_LIDO_MULTISIG,
                curator: address(0),
                lpTokenName: "",
                lpTokenSymbol: "",
                wstethDefaultBond: DeployConstants.WSTETH_DEFAULT_BOND,
                wstethDefaultBondFactory: DeployConstants
                    .WSTETH_DEFAULT_BOND_FACTORY,
                wsteth: DeployConstants.WSTETH,
                steth: DeployConstants.STETH,
                weth: DeployConstants.WETH,
                maximalTotalSupply: DeployConstants.MAXIMAL_TOTAL_SUPPLY,
                initialDepositETH: DeployConstants.INITIAL_DEPOSIT_ETH,
                firstDepositETH: DeployConstants.FIRST_DEPOSIT_ETH,
                initializer: Initializer(address(0)),
                initialImplementation: Vault(payable(address(0))),
                erc20TvlModule: ERC20TvlModule(address(0)),
                defaultBondTvlModule: DefaultBondTvlModule(address(0)),
                defaultBondModule: DefaultBondModule(address(0)),
                ratiosOracle: ManagedRatiosOracle(address(0)),
                priceOracle: ChainlinkOracle(address(0)),
                wethAggregatorV3: IAggregatorV3(address(0)),
                wstethAggregatorV3: IAggregatorV3(address(0)),
                defaultProxyImplementation: DefaultProxyImplementation(
                    address(0)
                )
            });

        DeployInterfaces.DeploySetup[]
            memory setups = new DeployInterfaces.DeploySetup[](n);
        vm.startBroadcast(uint256(bytes32(vm.envBytes("MAINNET_DEPLOYER"))));
        deployParams = commonContractsDeploy(deployParams);
        for (uint256 i = 0; i < n; i++) {
            deployParams.curator = curators[i];
            deployParams.lpTokenName = names[i];
            deployParams.lpTokenSymbol = symbols[i];

            vm.recordLogs();
            (deployParams, setups[i]) = deploy(deployParams);
            validateParameters(deployParams, setups[i], 0);
            validateEvents(deployParams, setups[i], vm.getRecordedLogs());
            setups[i].depositWrapper.deposit{
                value: deployParams.firstDepositETH
            }(
                deployParams.deployer,
                address(0),
                deployParams.firstDepositETH,
                0,
                type(uint256).max
            );
        }

        vm.stopBroadcast();
        for (uint256 i = 0; i < n; i++) {
            logSetup(setups[i]);
        }
        logDeployParams(deployParams);
    }

    function logSetup(DeployInterfaces.DeploySetup memory setup) internal view {
        console2.log(IERC20Metadata(address(setup.vault)).name());
        console2.log("Vault: ", address(setup.vault));
        console2.log("Configurator: ", address(setup.configurator));
        console2.log("Validator: ", address(setup.validator));
        console2.log(
            "DefaultBondStrategy: ",
            address(setup.defaultBondStrategy)
        );
        console2.log("DepositWrapper: ", address(setup.depositWrapper));
        console2.log("WstethAmountDeposited: ", setup.wstethAmountDeposited);
        console2.log(
            "TransparentUpgradeableProxy-ProxyAdmin: ",
            address(setup.proxyAdmin)
        );
        console2.log("---------------------------");
        block.timestamp;
    }

    function logDeployParams(
        DeployInterfaces.DeployParameters memory deployParams
    ) internal view {
        console2.log("Deployer: ", address(deployParams.deployer));
        console2.log("ProxyAdmin: ", address(deployParams.proxyAdmin));
        console2.log("Admin: ", address(deployParams.admin));
        console2.log("Curator: ", address(deployParams.curator));
        console2.log(
            "WstethDefaultBondFactory: ",
            address(deployParams.wstethDefaultBondFactory)
        );
        console2.log(
            "WstethDefaultBond: ",
            address(deployParams.wstethDefaultBond)
        );
        console2.log("Wsteth: ", address(deployParams.wsteth));
        console2.log("Steth: ", address(deployParams.steth));
        console2.log("Weth: ", address(deployParams.weth));
        console2.log("MaximalTotalSupply: ", deployParams.maximalTotalSupply);
        console2.log("LpTokenName: ", deployParams.lpTokenName);
        console2.log("LpTokenSymbol: ", deployParams.lpTokenSymbol);
        console2.log("InitialDepositETH: ", deployParams.initialDepositETH);
        console2.log("Initializer: ", address(deployParams.initializer));
        console2.log(
            "InitialImplementation: ",
            address(deployParams.initialImplementation)
        );
        console2.log("Erc20TvlModule: ", address(deployParams.erc20TvlModule));
        console2.log(
            "DefaultBondTvlModule: ",
            address(deployParams.defaultBondTvlModule)
        );
        console2.log(
            "DefaultBondModule: ",
            address(deployParams.defaultBondModule)
        );
        console2.log("RatiosOracle: ", address(deployParams.ratiosOracle));
        console2.log("PriceOracle: ", address(deployParams.priceOracle));
        console2.log(
            "WethAggregatorV3: ",
            address(deployParams.wethAggregatorV3)
        );
        console2.log(
            "WstethAggregatorV3: ",
            address(deployParams.wstethAggregatorV3)
        );
        console2.log(
            "DefaultProxyImplementation: ",
            address(deployParams.defaultProxyImplementation)
        );
        block.timestamp;
    }
}
