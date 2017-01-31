<#
.SYNOPSIS
    Find Trending VSCode Extensions
.DESCRIPTION
    Find  Newest, Highest Rated, Most Installs, and Daily/Weekly/Monthly Trending VSCode Extensions.
.EXAMPLE
    C:\PS> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Find-VSCodeTrendingExtension
{
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]$Count = '10',

        [Parameter(Mandatory=$false)]
        [ValidateSet('Languages','Snippets','Linters','Debuggers','Other','Themes','Formatters','Keymaps')]
        [string[]]$Category,

        [Parameter(Mandatory=$false)]
        [string[]]$Tag,

        [Parameter(ParameterSetName='Newest')]
        [Switch]$Newest,

        [Parameter(ParameterSetName='Trending')]
        [Switch]$Trending,

        [Parameter(Mandatory=$false,ParameterSetName='Trending')]
        [ValidateSet('Daily','Weekly','Monthly','All')]
        [String]$TrendingType = 'All',

        [Parameter(ParameterSetName='Rating')]
        [Switch]$Rating,

        [Parameter(Mandatory=$false,ParameterSetName='Rating')]
        [Int]$MinimumRatingCount,

        [Parameter(ParameterSetName='Installs')]
        [Switch]$Installs
    )

    Begin
    {
        $Results = Invoke-RestMethod -Method Get -Uri 'https://vscode.blob.core.windows.net/gallery/index'
    }

    Process
    {
        $Extensions = $Results.results.extensions

        if ($Category)
        {
            $CategoryExts = @()
            foreach ($Cat in $Category)
            {
                $CategoryExts += $Extensions | Where-Object { $_.categories -contains $Cat }
            }
            $Extensions = $CategoryExts | Sort-Object -Property ExtensionName -Unique
        }

        if ($Tag)
        {
            $TagExts = @()
            foreach ($TagName in $Tag)
            {
                 $TagExts += $Extensions | Where-Object { $_.tags -like $TagName }
            }
            $Extensions = $TagExts | Sort-Object -Property ExtensionName -Unique
        }

        If ($Extensions)
        {
            Switch ($PSCmdlet.ParameterSetName)
            {
                'Newest'
                {
                    $Extensions | Sort-Object -Property publishedDate -Descending |
                            Select-Object -Property @{Name="Last $Count Published"; Expression={$_.displayname}},
                                                    @{Name="Description"; Expression={$_.shortdescription}} -First $Count
                }

                'Installs'
                {
                    $Extensions.foreach({
                        ($ExtensionObj = $_).Statistics.Where({($_.StatisticName -eq 'Install')}).foreach({
                                [PSCustomObject]@{
                                    'Installs'    = $_.Value
                                    'DisplayName' = $ExtensionObj.DisplayName
                                    'Description' = $ExtensionObj.shortDescription
                                }
                        })
                    }) | Sort-Object -Property @{Expression={$_.'Installs'};Descending=$True},
                                               @{Expression={$_.DisplayName};Descending=$False} | Select-Object -First $Count
                }

                'Rating'
                {
                    $Extensions.foreach({($ExtensionObj = $_).Statistics.Where({
                        ($_.StatisticName -eq 'AverageRating') -AND
                        ($ExtensionObj.Statistics.Where({$_.StatisticName -eq 'RatingCount'}).Value -gt $MinimumRatingCount)}).foreach({
                            [PSCustomObject]@{
                                'DisplayName' = $ExtensionObj.DisplayName
                                'Average Rating' = [Decimal]$_.Value
                                'Rating Count' = $ExtensionObj.Statistics.Where({$_.StatisticName -eq 'RatingCount'}).Value
                            }
                        })
                    }) | Sort-Object -Property @{Expression={[Decimal]$_.'Average Rating'};Descending=$True},
                                               @{Expression={$_.DisplayName};Descending=$False} | Select-Object -First $Count
                }

                'Trending'
                {
                    function GetTrending
                    {
                        param([string]$Type)

                        $Extensions.foreach({($ExtensionObj = $_).Statistics.Where({$_.StatisticName -eq $Type}).foreach({
                                [PSCustomObject]@{
                                    $Type         = [Decimal]$_.Value
                                    'DisplayName' = $ExtensionObj.DisplayName
                                    'Description' = $ExtensionObj.shortDescription
                                }
                            })
                        }) | Sort-Object -Property @{Expression={[Decimal]$_.$Type};Descending=$True},
                                                   @{Expression={$_.DisplayName};Descending=$False} | Select-Object -First $Count -Property DisplayName, Description
                    }

                    Switch ($TrendingType)
                    {
                        'Daily'
                        {
                            GetTrending -Type 'TrendingDaily'
                        }

                        'Weekly'
                        {
                            GetTrending -Type 'TrendingWeekly'
                        }

                        'Monthly'
                        {
                            GetTrending -Type 'TrendingMonthly'
                        }

                        'All'
                        {
                            $TrendingAll = @()
                            $Daily = GetTrending -Type 'TrendingMonthly'
                            $Weekly = GetTrending -Type 'TrendingWeekly'
                            $Monthly = GetTrending -Type 'TrendingMonthly'

                            (0..($Count - 1)).ForEach({
                                $TrendingAll += [PSCustomObject]@{
                                    'Trending Daily'   = $Daily[$_].DisplayName
                                    'Trending Weekly'  = $Weekly[$_].DisplayName
                                    'Trending Monthly' = $Monthly[$_].DisplayName
                                }
                            })

                            Return $TrendingAll
                        }
                    }
                }
            }
        }
    }
}

