using module ..\Include.psm1

class Gminer : Miner {
    [String[]]UpdateMinerData () {
        if ($this.GetStatus() -ne [MinerStatus]::Running) {return @()}

        $Server = "127.0.0.1"
        $Timeout = 5 #seconds

        $Request = "http://$($Server):$($this.Port)/stat"
        $Data = ""

        try {
            if ($Global:PSVersionTable.PSVersion -ge [System.Version]("6.0.0")) {
                $Data = Invoke-RestMethod $Request -TimeoutSec $Timeout -DisableKeepAlive -MaximumRetryCount 3 -RetryIntervalSec 1 -ErrorAction Stop
            }
            else {
                $Data = Invoke-RestMethod $Request -TimeoutSec $Timeout -DisableKeepAlive -ErrorAction Stop
            }
        }
        catch {
            return @($Request, $Data)
        }

        $HashRate = [PSCustomObject]@{}
        $HashRate_Name = [String]($this.Algorithm | Select-Object -Index 0)

        if ($this.AllowedBadShareRatio) {
            $Shares_Accepted = [Int64]($Data.gpu_status.good_shares | Measure-Object -Sum).Sum
            $Shares_Rejected = [Int64]($Data.gpu_status.bad_shares | Measure-Object -Sum).Sum
            if ((-not $Shares_Accepted -and $Shares_Rejected -ge 3) -or ($Shares_Accepted -and ($Shares_Rejected * $this.AllowedBadShareRatio -gt $Shares_Accepted))) {
                $this.SetStatus("Failed")
                $this.StatusMessage = " was stopped because of too many bad shares for algorithm $($HashRate_Name) (total: $($Shares_Accepted + $Shares_Rejected) / bad: $($Shares_Rejected) [Configured allowed ratio is 1:$(1 / $this.AllowedBadShareRatio)])"
                return @($Request, $Data)
            }
        }

        $HashRate | Add-Member @{$HashRate_Name = [Double]($Data.devices.speed | Measure-Object -Sum).Sum}

        if ($HashRate.PSObject.Properties.Value -gt 0) {
            $this.Data += [PSCustomObject]@{
                Date       = (Get-Date).ToUniversalTime()
                Raw        = $Data
                HashRate   = $HashRate
                PowerUsage = (Get-PowerUsage $this.DeviceName)
                Device     = @()
            }
        }

        return @($Request, $Data | ConvertTo-Json -Compress)
    }
}
