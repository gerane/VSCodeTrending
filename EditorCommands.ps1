Register-EditorCommand `
    -Name 'VSCodeExtensions.FindTrendingExtension' `
    -DisplayName 'Find Trending VSCode Extensions' `
    -ScriptBlock {
        param([Microsoft.PowerShell.EditorServices.Extensions.EditorContext]$context)

        # Replace Path
        . "C:\Github\VSCodeTrending\Find-VSCodeTrendingExtension.ps1"

        $List = @(
            'Find Newest Extensions',
            'Find Daily Trending Extensions',
            'Find Weekly Trending Extensions',
            'Find Monthly Trending Extensions',
            'Find Monthly, Weekly, and Daily Trending Extensions',
            'Find Extensions with Most Installs',
            'Find Extensions with Highest Ratings'
        )

        $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @($List)
        $Selection = $host.ui.PromptForChoice('Please Select a Search', '', $choices,'0')
        $Name = $List[$Selection]

        switch ($Name)
        {
            'Find Newest Extensions'                              { $Splat = @{ Newest = $True } }
            'Find Daily Trending Extensions'                      { $Splat = @{ Trending = $True; TrendingType = 'Daily' } }
            'Find Weekly Trending Extensions'                     { $Splat = @{ Trending = $True; TrendingType = 'Weekly' } }
            'Find Monthly Trending Extensions'                    { $Splat = @{ Trending = $True; TrendingType = 'Monthly' } }
            'Find Monthly, Weekly, and Daily Trending Extensions' { $Splat = @{ Trending = $True } }
            'Find Extensions with Most Installs'                  { $Splat = @{ Installs = $True } }
            'Find Extensions with Highest Ratings'                { $Splat = @{ Rating = $True } }
        }

        Try
        {
            Find-VSCodeTrendingExtension @Splat
        }
        Catch
        {
            Throw
        }
    }

