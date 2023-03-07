if ($args[0] -eq "-h")
{
	Write-Host ' '
	Write-Host 'This script, by default, will print a list of stores which are unavailable for Online Ordering and why they are down.'
	Write-Host 'This script can take up to one of the following arguments:'
	Write-Host 'Print all stores regardless of status.................-v'
	Write-Host 'Check store status every 5 minutes*...................-l'
	Write-Host 'Print this information................................-h'
	Write-Host ' '
	Write-Host '* When the "-l" flag is active, the script will use colour codes to show which stores have been down for 10 or more minutes'
	Write-Host '  See below for a legend of meanings for the color codes used by this script:'
	Write-Host '  This style is used to indicate that PulseBOS is not reachable.' -ForegroundColor Red
	Write-Host '  This style is used to indicate that PulseBOS is reachable but the Online Order system is down.' -ForegroundColor Yellow
	Write-Host '  This style is used to indicate that the Online Order system has been manually disabled.' -ForegroundColor Green
	Write-Host '  This style is used to indicate that PulseBOS has been unreachable for more than 10 minutes.' -ForegroundColor Black -BackgroundColor Red
	Write-Host '  This style is used to indicate that PulseBOS is reachable but the Online Order system has been down for more than 10 minutes.' -ForegroundColor Black -BackgroundColor Yellow
	Write-Host '  This style is used to indicate that PulseBOS was reachable on last check but the Online Order system was down and now PulseBOS is unreachable.' -ForegroundColor Red -BackgroundColor Blue
	Write-Host '  This style is used to indicate that PulseBOS was unreachable on last check and is now reachable but the Online Order system is down.' -ForegroundColor Yellow -BackgroundColor Blue
}
else
{
	[console]::WindowWidth=26; [console]::WindowHeight=30; [console]::BufferWidth=[console]::WindowWidth
	$Loop = $true
	$DownStores = @{}
	while ($Loop)
	{
		cls
		$StoreList = Get-Content C:\ConnectionChecker\StoreList.txt
		for ($i = 0; $i -lt $StoreList.Length; $i++)
		{
			$StoreNumber = $StoreList[$i].split(',')[0]
			$PulseIP = $StoreList[$i].split(',')[1]
			$StoreURI = 'https://order.dominos.ca/power/store/' + $StoreNumber + '/profile?pretty'
			Try
			{
				[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
				$StoreProfile = (Invoke-WebRequest -Uri $StoreURI | ConvertFrom-Json)
				$StoreOnlineStatus = ($StoreProfile.OnlineStatusCode | Out-String)
			}
			Catch
			{
				if ($args[0] -eq "-v")
				{
					Write-Host 'Store'$StoreNumber': Read Error'
				}
			}
			if ($StoreOnlineStatus -ne $null)
			{
				if ($args[0] -eq "-v")
				{
					if ($StoreOnlineStatus -match "ConnectionError")
					{
						$IsPulseReachable = (ping -n 2 $PulseIP | Select-String -Pattern "Reply from $PulseIP")
						if ($IsPulseReachable -ne $null)
						{
							Write-Host 'Store' $StoreNumber':' $StoreOnlineStatus -ForegroundColor Yellow
						}
						else
						{
							Write-Host 'Store' $StoreNumber':' $StoreOnlineStatus -ForegroundColor Red
						}
					}
					elseif ($StoreOnlineStatus -match "ManualOffline")
					{
						Write-Host 'Store' $StoreNumber':' $StoreOnlineStatus '- OSIM Disabled' -ForegroundColor Green
					}
					else
					{
						Write-Host 'Store'$StoreNumber':' $StoreOnlineStatus -ForegroundColor Green
					}
				}
				else
				{
					if ($StoreOnlineStatus -match "ConnectionError")
					{
						$IsPulseReachable = (ping -n 2 $PulseIP | Select-String -Pattern "Reply from $PulseIP")
						if ($IsPulseReachable -ne $null)
						{
							if ($DownStores.ContainsKey($StoreNumber))
							{
								if ($DownStores[$StoreNumber])
								{
									Write-Host 'Store' $StoreNumber': Service Error' -ForegroundColor Black -BackgroundColor Yellow
								}
								else
								{
									Write-Host 'Store' $StoreNumber': Service Error' -ForegroundColor Yellow -BackgroundColor Blue
									$DownStores[$StoreNumber] = $true
								}
							}
							else
							{
								Write-Host 'Store' $StoreNumber': Service Error' -ForegroundColor Yellow
								$DownStores[$StoreNumber] = $true
							}
						}
						else
						{
							if ($DownStores.ContainsKey($StoreNumber))
							{
								if ($DownStores[$StoreNumber])
								{
									Write-Host 'Store' $StoreNumber': Network Error' -ForegroundColor Red -BackgroundColor Blue
									$DownStores[$StoreNumber] = $false
								}
								else
								{
									Write-Host 'Store' $StoreNumber': Network Error' -ForegroundColor Black -BackgroundColor Red
								}
							}
							else
							{
								Write-Host 'Store' $StoreNumber': Network Error' -ForegroundColor Red
								$DownStores[$StoreNumber] = $false
							}
						}
					}
					elseif ($StoreOnlineStatus -match "ManualOffline")
					{
						Write-Host 'Store' $StoreNumber': OSIM Disabled' -ForegroundColor Green
					}
				}
			}
			else
			{
				if ($DownStores.ContainsKey($StoreNumber))
				{
					$DownStores.Remove($StoreNumber)
				}
			}
		}
		if ($args[0] -ne "-l")
		{
			$Loop = $false
		}
		else
		{
			Start-Sleep -Seconds 300
		}
	}
}