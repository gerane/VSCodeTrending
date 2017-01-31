function Send-SlackTrending
{
    [CmdletBinding()]
    param
    (
        [String]$Channel = 'general'
    )

    Import-Module PSSlack
    . .\Find-VSCodeTrendingExtension.ps1


    $Newest = Find-VSCodeTrendingExtension -Newest
    $Weekly = Find-VSCodeTrendingExtension -Trending -TrendingType Weekly

    $Trending = @()
    $Trending += @{
        title = 'Last 10 Published'
        value = ($Newest.'Last 10 Published' | Out-String)
        short = $true
    }

    $Trending += @{
        title = 'Weekly Trending'
        value = ($Weekly.'DisplayName' | Out-String)
        short = $true
    }


    New-SlackMessageAttachment -Color "#7CD197" `
                               -Fields $Trending `
                               -Fallback 'Your client is bad' |
        New-SlackMessage -Channel $Channel `
                         -Text "Trending Extensions" `
                         -IconUrl 'https://pbs.twimg.com/profile_images/676630166190166017/UYxw-HcD.png' |
            Send-SlackMessage
}