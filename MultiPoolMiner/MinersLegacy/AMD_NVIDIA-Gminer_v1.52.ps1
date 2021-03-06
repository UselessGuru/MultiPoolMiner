using module ..\Include.psm1

param(
    [PSCustomObject]$Pools,
    [PSCustomObject]$Stats,
    [PSCustomObject]$Config,
    [PSCustomObject[]]$Devices
)

$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Path = ".\Bin\$($Name)\miner.exe"
$HashSHA256 = "32158C2B40D92844BDB1FB810D6F3C2F09C0DE7BE9E07AAE9686C98F3BDEB536"
$Uri = "https://github.com/develsoftware/GMinerRelease/releases/download/1.52/gminer_1_52_windows64.zip"
$ManualUri = "https://bitcointalk.org/index.php?topic=5034735.0"

$Miner_Version = Get-MinerVersion $Name
$Miner_BaseName = Get-MinerBaseName $Name
$Miner_Config = $Config.MinersLegacy.$Miner_BaseName.$Miner_Version
if (-not $Miner_Config) {$Miner_Config = $Config.MinersLegacy.$Miner_BaseName."*"}

#Commands from config file take precedence
if ($Miner_Config.Commands) {$Commands = $Miner_Config.Commands}
else {
    $Commands = [PSCustomObject[]]@(
        [PSCustomObject]@{Algorithm = "BeamHash";      MinMemGB = 4.0; Vendor = @("NVIDIA");        Params = ""} #new in v1.51
        [PSCustomObject]@{Algorithm = "cuckaroo29";    MinMemGB = 4.0; Vendor = @("AMD", "NVIDIA"); Params = ""} #new in v1.19; Cuckaroo29 / Grin
        [PSCustomObject]@{Algorithm = "cuckaroo29s";   MinMemGB = 4.0; Vendor = @("AMD", "NVIDIA"); Params = ""} #new in v1.34; Cuckaroo29s / Swap
        [PSCustomObject]@{Algorithm = "cuckatoo31";    MinMemGB = 7.4; Vendor = @("NVIDIA");        Params = ""} #new in v1.31; Cuckatoo31 / Grin
        [PSCustomObject]@{Algorithm = "cuckoo29";      MinMemGB = 4.0; Vendor = @("AMD", "NVIDIA"); Params = ""} #new in v1.24; Cuckoo29 / Aeternity
        [PSCustomObject]@{Algorithm = "equihash96_5";  MinMemGB = 0.8; Vendor = @("NVIDIA");        Params = ""} #new in v1.13
        [PSCustomObject]@{Algorithm = "equihash125_4"; MinMemGB = 1.0; Vendor = @("NVIDIA");        Params = ""} #new in v1.46; ZelCash
        [PSCustomObject]@{Algorithm = "equihash144_5"; MinMemGB = 1.8; Vendor = @("AMD", "NVIDIA"); Params = ""}
        [PSCustomObject]@{Algorithm = "equihash150_5"; MinMemGB = 3.0; Vendor = @("AMD", "NVIDIA"); Params = ""} #new in v1.15
        [PSCustomObject]@{Algorithm = "equihash192_7"; MinMemGB = 2.8; Vendor = @("NVIDIA");        Params = ""}
        [PSCustomObject]@{Algorithm = "equihash210_9"; MinMemGB = 1.0; Vendor = @("NVIDIA");        Params = ""} #new in v1.09
        [PSCustomObject]@{Algorithm = "grin29";        MinMemGB = 1.0; Vendor = @("NVIDIA");        Params = ""} #new in v1.51
        [PSCustomObject]@{Algorithm = "vds";           MinMemGB = 1.0; Vendor = @("AMD", "NVIDIA"); Params = ""} #new in v1.43; Vds / V-Dimension
    )
}

#CommonCommands from config file take precedence
if ($Miner_Config.CommonParameters) {$CommonParameters = $Miner_Config.CommonParameters}
else {$CommonParameters = " --watchdog 0"}

$Devices = $Devices | Where-Object Type -EQ "GPU"
$Devices | Select-Object Type, Model -Unique | ForEach-Object {
    $Device = @($Devices | Where-Object Type -EQ $_.Type | Where-Object Model -EQ $_.Model)
    $Miner_Port = $Config.APIPort + ($Device | Select-Object -First 1 -ExpandProperty Index) + 1

    $Commands | ForEach-Object {$Algorithm_Norm = Get-Algorithm $_.Algorithm; $_} | Where-Object {$_.Vendor -contains $Device.Vendor_ShortName -and $Pools.$Algorithm_Norm.Host} | ForEach-Object {
        $Algorithm = $_.Algorithm
        $MinMemGB = $_.MinMemGB
        $Parameters = $_.Parameters
        
        #Windows 10 requires 1 GB extra
        if ($Algorithm -match "cuckaroo29|cuckaroo29s|cuckoo" -and ([System.Version]$PSVersionTable.BuildVersion -ge "10.0.0.0")) {$MinMemGB += 1}

        if ($Miner_Device = @($Device | Where-Object {([math]::Round((10 * $_.OpenCL.GlobalMemSize / 1GB), 0) / 10) -ge $MinMemGB})) {
            $Miner_Name = (@($Name) + @(($Miner_Device.Model_Norm | Sort-Object -unique | ForEach-Object {$Model_Norm = $_; "$(@($Miner_Device | Where-Object Model_Norm -eq $Model_Norm).Count)x$Model_Norm"}) -join '_') | Select-Object) -join '-'

            #Get parameters for active miner devices
            if ($Miner_Config.Parameters.$Algorithm_Norm) {
                $Parameters = Get-ParameterPerDevice $Miner_Config.Parameters.$Algorithm_Norm $Miner_Device.Type_Index
            }
            elseif ($Miner_Config.Parameters."*") {
                $Parameters = Get-ParameterPerDevice $Miner_Config.Parameters."*" $Miner_Device.Type_Index
            }
            else {
                $Parameters = Get-ParameterPerDevice $Parameters $Miner_Device.Type_Index
            }

            if ($Algorithm_Norm -match "Equihash1445|Equihash1927") {
                #define --pers for Equihash1445 & Equihash1927
                $AlgoPers = " --pers $(Get-AlgoCoinPers -Algorithm $Algorithm_Norm -CoinName $Pools.$Algorithm_Norm.CoinName -Default 'auto')"
            }
            else {$AlgoPers = ""}

            if ($Algorithm_Norm -notmatch "Equihash1445|Equihash1972" -or $AlgoPers) {
                [PSCustomObject]@{
                    Name               = $Miner_Name
                    BaseName           = $Miner_BaseName
                    Version            = $Miner_Version
                    DeviceName         = $Miner_Device.Name
                    Path               = $Path
                    HashSHA256         = $HashSHA256
                    Arguments          = ("--algo $Algorithm$AlgoPers --api $($Miner_Port)$(if ($Pools.$Algorithm_Norm.SSL) {" --ssl --ssl_verification 0"}) --server $($Pools.$Algorithm_Norm.Host) --port $($Pools.$Algorithm_Norm.Port) --user $($Pools.$Algorithm_Norm.User) --pass $($Pools.$Algorithm_Norm.Pass)$Parameters$CommonParameters --devices $(($Miner_Device | ForEach-Object {'{0:x}' -f ($_.PCIBus_Type_Index)}) -join ' ')" -replace "\s+", " ").trim()
                    HashRates          = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Miner_Name)_$($Algorithm_Norm)_HashRate".Week}
                    API                = "Gminer"
                    Port               = $Miner_Port
                    URI                = $Uri
                    Fees               = [PSCustomObject]@{$Algorithm_Norm = 2 / 100}
                    WarmupTime         = 45 #seconds
                }
            }
        }
    }
}
