# VSCode Extension Statistics

Included are a few examples of how to gather Extension Statistics and display them in intersting ways.

The **Find-VSCodeTrendingExtension.ps1** contains the main logic for gathering the Statistics from the same data that the Marketplace uses. This is based on the command **Get-VSCodeExtensionStats** in my [VSCodeExtensions Module](https://github.com/gerane/VSCodeExtensions). I wanted something like this to have a standalone option, but I am also debating adding something like this back into the Module. I have been working on some refactoring and improvements to the module and may add this when I publish those.


## Usage

There are a few examples of how this can be used. You could add one of these to your profile MOTD, but be prepared to add roughly 3-4 seconds to you profile load time. There is always the option of just running the commands in the shell, but also covered are examples of Slack messages and VSCode PowerShell Extension Editor Commands. I currently have a few of these that will occasionally send a slack messages with Statistics that I am interested in.

To get more information on setting up and using Editor Commands you can see this blog post [Getting Started with Editor Commands](http://brandonpadgett.com/powershell/Getting-Started-With-Editor-Commands/)

The slack example is using [psCookieMonster's](https://twitter.com/psCookieMonster) PowerShell [PSSlack Module](https://github.com/RamblingCookieMonster/PSSlack). His repository has a nice readme with instructions on how to set it up.


## Examples

### Newest and Weekly Trending - Slack Message

```powershell
 C:\PS> Send-SlackTrending
```

![Output](/Images/Slack_Newest_Weekly.png)


### Most Installed

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Installs
```

![Output](/Images/Console_Installs.png)


### Highest Rating

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Rating
```

![Output](/Images/Console_Rating.png)


### Daily, Weekly, and Monthly Trending

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Trending
```

![Output](/Images/Console_Trending.png)


### Daily Trending

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Rating -TrendingType Daily
```

![Output](/Images/Console_Trending_Daily.png)


### Weekly Trending

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Trending -TrendingType Weekly
```

![Output](/Images/Console_Trending_Weekly.png)


### Daily, Weekly, and Monthly Trending Themes

```powershell
 C:\PS> Find-VSCodeTrendingExtension -Trending -Category Themes
```

![Output](/Images/Console_Trending_Themes.png)


### Newest Themes - Editor Command

Access Editor Command Menu

=> Select *Find Trending VSCode Extensions*

=> Select *Find Newest Extensions*

![Output](/Images/EditorCommand_Newest.gif)


## Links

- Github - [Brandon Padgett](https://github.com/gerane)
- Twitter - [@brandonpadgett](https://twitter.com/BrandonPadgett)
- Website - [BrandonPadgett.com](http://brandonpadgett.com)


## License

[MIT](LICENSE)


## Notes

[PSSlack Module](https://github.com/RamblingCookieMonster/PSSlack)

[VSCodeExtensions Module](https://github.com/gerane/VSCodeExtensions)

[Getting Started with Editor Commands](http://brandonpadgett.com/powershell/Getting-Started-With-Editor-Commands/)


