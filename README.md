# This is the home of the MultiPoolMiner beta versions
https://github.com/MultiPoolMiner/MultiPoolMiner

## Changelog Version 3.4.0 Beta 2

### Breaking changes

**Parameter '-UseDeviceNameForStatsFileNaming' in no longer valid**
This will trigger all Benchmarks to be re-executed (unless you were running MPM with '-UseDeviceNameForStatsFileNaming:true' already)

#### Core changes
- Web dashboard: Added algorithm information to device status
- Removed code for '-UseDeviceNameForStatsFileNaming'

#### Miner Changes
- Removed code for '-UseDeviceNameForStatsFileNaming'
- Updated AMD_NVIDIA-GminerEquihash_v1.45
- Updated AMD_NVIDIA-NanoMiner_v1.3.3
- Updated NVIDIA-CryptoDredge_v0.20.1

## Changelog Version 3.4.0 Beta 1

#### Core changes
- API: updated to version 0.93; added '/alldevices'
- Added parameter '-DisableMinersWithDevFee'
- Improved config file validation
- Renamed parameter '-NoDevFeeMiners' to '-DisableDevFeeMining' to better reflect its function
- Rewrote interval & hashrate collector scheduler
- Start cmd files: Do not launch a second instance of SnakeTail.exe
- Web dashboard: Added column 'Status' to devices overview (available status: 'Disabled', 'Idle', 'Running (MinerName)', 'Benchmarking (MinerName)' & 'Failed'

#### Miner Changes
- Fixed NVIDIA-CcminerZenemy_v2.00; invalid --devices0 parameter (https://github.com/MultiPoolMiner/MultiPoolMiner/issues/2339#issuecomment-495972633)
- Fixed AMD_NVIDIA-BMiner_v15.5.3 SSL for secondary algorithm
- Renamed NVIDIA-NBMiner_v23.3hotfix to NVIDIA-NBMiner_v23.2hotfix (typo)
- Renamed NVIDIA-CcminerZenemy_v2.00 to NVIDIA-CcminerZenemy_v20.0 (typo)
- Updated AMD_NVIDIA-ClaymoreEthash_v14.6
- Updated AMD-JCECryptonote_v0.33b18; changed API to XmRig
- Updated AMD-WildRig_v0.17.3
- Updated CPU-JCECryptonote_v0.33q; changed API to XmRig
- Updated NVIDIA-TTMiner_v2.2.5

#### Pool changes
- MiningPoolHubCoins: workaround for invalid MaxCoin host info in API (https://github.com/MultiPoolMiner/MultiPoolMiner/issues/2339#issuecomment-496887747)
