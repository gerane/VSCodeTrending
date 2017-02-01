function Find-VSCodeTrendingExtension
{
    <#
        .SYNOPSIS
            Find Trending VSCode Extensions

        .DESCRIPTION
            Find Newest, Highest Rated, Most Installs, and Daily/Weekly/Monthly Trending VSCode Extensions.

         .PARAMETER Count
            Number of results to show

            Defaults to 10

        .PARAMETER Category
            Narrow results by a category or set of categories.

            Valid values are Languages, Snippets, Linters, Debuggers, Other, Themes, Formatters, and Keymaps

        .PARAMETER Tag
            Narrow results by a tag or set of tags.

        .PARAMETER Newest
            Show results for the last Published Extensions.

        .PARAMETER Trending
            Show the top Weekly, Monthly, Daily trending extensions.

        .PARAMETER TrendingType
            The type of Trending Extensions to show.

            Valid values are Weekly, Monthly, Daily, and All

        .PARAMETER Rating
            Show results for the Highest Rated Extensions.

            Valid values are Weekly, Monthly, Daily, and All

        .PARAMETER MinimumRatingCount
            Limit the restults by a minimum number of ratings for better results.

            Defaults to 5

        .PARAMETER Installs
            Show results for Extensions with the Highest Install counts.

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Installs

                Installs DisplayName         Description
                -------- -----------         -----------
                 1355320 C#                  C# for Visual Studio Code (powered by OmniSharp).
                 1198019 Python              Linting, Debugging (multi-threaded, remote), Intellisense, code formatting, refactoring, unit tests, snippets, Data Science (with Jupyter), PySpark and more.
                 1060161 vscode-icons        Icons for Visual Studio Code
                  927372 Debugger for Chrome Debug your JavaScript code in the Chrome browser, or any other target that supports the Chrome Debugger protocol.
                  819912 C/C++               Complete C/C++ language support including code-editing and debugging.
                  518409 ESLint              Integrates ESLint into VS Code.
                  492180 beautify            Beautify code in place for VS Code
                  449689 Go                  Rich Go language support for Visual Studio Code
                  425598 HTML Snippets       Full HTML tags including HTML5 Snippets
                  385887 PowerShell          Develop PowerShell scripts in Visual Studio Code!

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Newest

                Last 10 Published       Description
                -----------------       -----------
                FalconCobalt            Custom Cobalt2
                markdown-dir            Markdown directory navigation header generator
                sockscode-vscode        Pair programming
                5 Colors Dark           VSC simple dark theme
                Space Block Jumper      Jump vertically across space-delimited blocks.
                vscode-annotations      with this extension you will be able to annotate all the tech debt or reafactor to do in your Javascript applications
                opendss                 OpenDSS script support
                Toggle CodeLens         Toggle editor.codeLens item in settings.json
                zap                     WIP
                Schema language support Language support for the Improbable SpatialOS schema language

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Trending

                Trending Daily                   Trending Weekly                  Trending Monthly
                --------------                   ---------------                  ----------------
                php cs fixer                     Auto Complete Tag                Cucumber Auto Complete
                React Component                  Oceanic Next (Sublime Babel)     Arduino
                PHP intellisense for codeigniter angular-2-snippets               React Component
                C# IL Viewer                     php cs fixer                     Sencha Ext JS
                angular-2-snippets               C# IL Viewer                     CodeWorks Theme
                Auto Complete Tag                React Component                  CSS Modules
                Oceanic Next (Sublime Babel)     PHP intellisense for codeigniter snippet-creator
                CodeWorks Theme                  C# FixFormat                     Yeezy
                ASP.NET Core Snippets            React utils                      Hungry Delete
                Preview on Web Server            Preview on Web Server            monokai light

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Trending -Category Keymaps

                Trending Daily            Trending Weekly           Trending Monthly
                --------------            ---------------           ----------------
                Auto Complete Tag         Auto Complete Tag         Auto Complete Tag
                Quit Control for VSCode   Hungry Delete             Hungry Delete
                IntelliJ IDEA Keybindings Quit Control for VSCode   Quit Control for VSCode
                Delphi Keymap             Delphi Keymap             Eclipse Keymap
                lowercase                 IntelliJ IDEA Keybindings Visual Studio Keymap
                Visual Studio Keymap      Visual Studio Keymap      Delphi Keymap
                Eclipse Keymap            Eclipse Keymap            uppercase
                emacs-functions           uppercase                 emacs-functions
                Auto Close Tag            lowercase                 lowercase
                Sublime Text Keymap       emacs-functions           Atom Keymap

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Trending -Tag PowerShell

                Trending Daily                   Trending Weekly                  Trending Monthly
                --------------                   ---------------                  ----------------
                Code Runner                      Code Runner                      Code Runner
                PowerShell                       PowerShell                       PowerShell
                Start any shell                  PowerShell Stack Overflow Search PowerShell Stack Overflow Search
                PowerShell Stack Overflow Search Start any shell                  Start any shell
                CodeShell                        CodeShell                        CodeShell

        .EXAMPLE
            C:\PS> Find-VSCodeTrendingExtension -Rating -MinimumRatingCount 10

                DisplayName                                                    Average Rating Rating Count
                -----------                                                    -------------- ------------
                React Native Tools                                                          5           14
                change-case                                                                 5           13
                Output Colorizer                                                            5           13
                Markdown PDF                                                                5           12
                Relative Path                                                               5           12
                Subword Navigation                                                          5           11
                JavaScript Atom Grammar                                                     5           10
                JSFiddle Like Syntax Theme                                                  5           10
                Angular 2 (or higher) and TypeScript/HTML VS Code Snippets                  5           10
                GitLens                                                    4.9285712242126465           14

        .LINK
            https://github.com/gerane/VSCodeTrending

    #>
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
        Try
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
                        $Extensions.foreach{
                            ($ExtensionObj = $_).Statistics.Where{$_.StatisticName -eq 'Install'}.foreach{
                                    [PSCustomObject]@{
                                        'Installs'    = $_.Value
                                        'DisplayName' = $ExtensionObj.DisplayName
                                        'Description' = $ExtensionObj.shortDescription
                                    }
                            }
                        } | Sort-Object -Property @{Expression={$_.'Installs'};Descending=$True} | Select-Object -First $Count
                    }

                    'Rating'
                    {
                        $Extensions.foreach{($ExtensionObj = $_).Statistics.Where{
                            ($_.StatisticName -eq 'AverageRating') -AND
                            ($ExtensionObj.Statistics.Where{$_.StatisticName -eq 'RatingCount'}.Value -ge $MinimumRatingCount)}.foreach{
                                [PSCustomObject]@{
                                    'DisplayName' = $ExtensionObj.DisplayName
                                    'Average Rating' = [Decimal]$_.Value
                                    'Rating Count' = $ExtensionObj.Statistics.Where{$_.StatisticName -eq 'RatingCount'}.Value
                                }
                            }
                        } | Sort-Object -Property @{Expression={[Decimal]$_.'Average Rating'};Descending=$True},
                                                @{Expression={$_.'Rating Count'};Descending=$True} | Select-Object -First $Count
                    }

                    'Trending'
                    {
                        Switch ($TrendingType)
                        {
                            'Daily'
                            {
                                $Extensions | Sort-Object {$_.Statistics.Where{$_.StatisticName -eq 'TrendingDaily'}.Value} -Descending |
                                    Select-Object -First $Count -Property @{Name="Top $Count $TrendingType Trending";Expression={$_.displayName}},
                                                                        @{Name="Description";Expression={$_.ShortDescription}}
                            }

                            'Weekly'
                            {
                                $Extensions | Sort-Object {$_.Statistics.Where{$_.StatisticName -eq 'TrendingWeekly'}.Value} -Descending |
                                    Select-Object -First $Count -Property @{Name="Top $Count $TrendingType Trending";Expression={$_.displayName}},
                                                                        @{Name="Description";Expression={$_.ShortDescription}}
                            }

                            'Monthly'
                            {
                                $Extensions | Sort-Object {$_.Statistics.Where{$_.StatisticName -eq 'TrendingMonthly'}.Value} -Descending |
                                    Select-Object -First $Count -Property @{Name="Top $Count $TrendingType Trending";Expression={$_.displayName}},
                                                                        @{Name="Description";Expression={$_.ShortDescription}}
                            }

                            'All'
                            {
                                $TrendingAll = @()
                                $Daily = ($Extensions | Sort-Object { $_.Statistics.Where{$_.StatisticName -eq 'TrendingDaily'}.Value } -Descending | Select-Object -First $Count).DisplayName
                                $Weekly = ($Extensions | Sort-Object { $_.Statistics.Where{$_.StatisticName -eq 'TrendingWeekly'}.Value } -Descending | Select-Object -First $Count).DisplayName
                                $Monthly = ($Extensions | Sort-Object { $_.Statistics.Where{$_.StatisticName -eq 'TrendingMonthly'}.Value } -Descending | Select-Object -First $Count).DisplayName

                                (0..($Count - 1)).ForEach{
                                    $TrendingAll += [PSCustomObject]@{
                                        'Trending Daily'   = $Daily[$_]
                                        'Trending Weekly'  = $Weekly[$_]
                                        'Trending Monthly' = $Monthly[$_]
                                    }
                                }

                                Return $TrendingAll
                            }
                        }
                    }
                }
            }
        }
        Catch
        {
            Throw
        }
    }
}

