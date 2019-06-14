# This is the home of the MultiPoolMiner beta versions
https://github.com/MultiPoolMiner/MultiPoolMiner

## Changelog Version 3.4.0 Beta 3

#### Core Changes
- API: updated to version 0.94; added '/allminers'
- Added config item 'DevicePciOrderMapping' for configurations where PCI deviceID order does not match OpenCL DeviceId order (see README)
- Parameters '-MinerName' and '-ExcludeMinerName' can be in one of the 3 forms: MinerBaseName e.g. 'AMD-TeamRed'; MinerBaseName_Version, e.g. 'AMD-TeamRed_v0.5.1' or MinerName, e.g. 'AMD-TeamRed_v0.5.1-1xEllesmere8GB'
- Rewrote interval & hashrate collector scheduler (again)
- Fixed error 'Method invocation failed because [XmRig] does not contain a method named 'op_Addition'.' (https://github.com/MultiPoolMiner/MultiPoolMiner/issues/2341#issuecomment-501782784)

#### Miner changes
- Fixed AMD_NVIDIA-BMiner_v15.5.3; device enumeration was broken in mixed rigs (AMD &NVIDIA in the same computer)
- Fixed miners Claymore*, Gminer, lolMinerEquihash, Nanominer, SRBMinerCryptonight & Wildrig; device enumeration can now use mapping as configured by 'DevicePciOrderMapping' 
- Updated AMD-TeamRed_v0.5.1; support for X16r, X16s & X16rt
- Updated AMD-WildRig_v0.17.5; support for Blake2b-BTCC & Blake2b-Glt
- Updated NVIDIA-CcminerTrex_v0.11.1
- Updated NVIDIA-NBMiner_v23.3

### Breaking changes

**Parameter '-UseDeviceNameForStatsFileNaming' in no longer valid**
This will trigger all Benchmarks to be re-executed (unless you were running MPM with '-UseDeviceNameForStatsFileNaming:true' already)
## Changelog Version 3.4.0 Beta 2

#### Core changes
- Fixed Start cmd files (missing ")
- Removed code for '-UseDeviceNameForStatsFileNaming'
- Web dashboard: Added algorithm information to device status

#### Miner changes
- Removed code for '-UseDeviceNameForStatsFileNaming'
- Updated AMD_NVIDIA-GminerEquihash_v1.45
- Updated AMD_NVIDIA-NanoMiner_v1.3.5
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

#### Miner changes
- Fixed NVIDIA-CcminerZenemy_v2.00; invalid --devices0 parameter (https://github.com/MultiPoolMiner/MultiPoolMiner/issues/2339#issuecomment-495972633)
- Fixed AMD_NVIDIA-BMiner_v15.5.3 SSL for secondary algorithm
- Renamed NVIDIA-NBMiner_v23.3hotfix to NVIDIA-NBMiner_v23.2hotfix (typo)
- Renamed NVIDIA-CcminerZenemy_v2.00 to NVIDIA-CcminerZenemy_v20.0 (typo)
- Updated AMD_NVIDIA-ClaymoreEthash_v14.6
- Updated AMD-JCECryptonote_v0.33b18; changed API to XmRig
- Updated CPU-JCECryptonote_v0.33q; changed API to XmRig
- Updated NVIDIA-TTMiner_v2.2.5

#### Pool changes
- MiningPoolHubCoins: workaround for invalid MaxCoin host info in API (https://github.com/MultiPoolMiner/MultiPoolMiner/issues/2339#issuecomment-496887747)
