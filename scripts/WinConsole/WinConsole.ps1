#Requires -Version 4.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Sets the console style to Gee Law's preference.

.LINK
    https://github.com/GeeLaw/PowerShellThingies/tree/master/scripts/WinConsole
#>

$script:WarningActionPreference = 'Inquire';
$script:ErrorActionPreference = 'Stop';

If ($Host.Version -lt '4.0')
{
    Write-Error 'This script requires PowerShell 4.0 or higher.';
}
Else
{
    Write-Warning "Install YaHei Consolas if you haven't.";
    Write-Warning 'The script is going to try installing YaHei Consolas Hybrid to your console (if not already installed).';

    $script:consoleTtf = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont';
    $script:page936 = Get-ItemProperty -Path $consoleTtf | Get-Member -MemberType NoteProperty | Where-Object Name -match '0*936'
    If (($page936 | Where-Object { (Get-ItemPropertyValue -Path $consoleTtf -Name $_.Name) -eq 'YaHei Consolas Hybrid' }).Length -gt 0)
    {
        Write-Host 'You have YaHei Consolas Hybrid in console fonts.';
    }
    Else
    {
        $script:propName = '936';
        While (($page936 | Where-Object Name -eq $propName).Length -gt 0)
        {
            $propName = '0' + $propName;
        }
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' -Name $propName -Value 'YaHei Consolas Hybrid';
        Write-Host 'Added YaHei Consolas Hybrid to console fonts.';
    }

    Write-Warning 'The script is going to reset all your console default preference to default.';

    Remove-Item -Path 'HKCU:\Console\*' -Force -Recurse;

    @{
        'ColorTable00' = 0x00000000;
        'ColorTable01' = 0x00800000;
        'ColorTable02' = 0x00008000;
        'ColorTable03' = 0x00808000;
        'ColorTable04' = 0x00000080;
        'ColorTable05' = 0x00800080;
        'ColorTable06' = 0x00008080;
        'ColorTable07' = 0x00c0c0c0;
        'ColorTable08' = 0x00808080;
        'ColorTable09' = 0x00ff0000;
        'ColorTable10' = 0x0000ff00;
        'ColorTable11' = 0x00ffff00;
        'ColorTable12' = 0x000000ff;
        'ColorTable13' = 0x00ff00ff;
        'ColorTable14' = 0x0000ffff;
        'ColorTable15' = 0x00ffffff;
        'CtrlKeyShortcutsDisabled' = 0x00000000;
        'CurrentPage' = 0x00000000;
        'CursorSize' = 0x00000019;
        'EnableColorSelection' = 0x00000000;
        'ExtendedEditKey' = 0x00000001;
        'ExtendedEditKeyCustom' = 0x00000000;
        'FilterOnPaste' = 0x00000000;
        'FontFamily' = 0x00000036;
        'FontSize' = 0x00120000;
        'FontWeight' = 0x00000190;
        'ForceV2' = 0x00000001;
        'FullScreen' = 0x00000000;
        'HistoryBufferSize' = 0x00000032;
        'HistoryNoDup' = 0x00000000;
        'InsertMode' = 0x00000001;
        'LineSelection' = 0x00000001;
        'LineWrap' = 0x00000001;
        'LoadConIme' = 0x00000001;
        'NumberOfHistoryBuffers' = 0x00000004;
        'PopupColors' = 0x000000f5;
        'QuickEdit' = 0x00000001;
        'ScreenBufferSize' = 0x23280078;
        'ScreenColors' = 0x0000000f;
        'ScrollScale' = 0x00000001;
        'TrimLeadingZeros' = 0x00000000;
        'WindowAlpha' = 0x000000ff;
        'WindowSize' = 0x00280078;
        'WordDelimiters' = 0x00000000
    }.GetEnumerator() | ForEach-Object `
    {
        Set-ItemProperty -Path 'HKCU:\Console' -Name $_.Name -Type 'DWord' -Value $_.Value;
    }

    Set-ItemProperty -Path 'HKCU:\Console' -Name 'FaceName' -Type 'String' -Value 'Microsoft YaHei Mono';

    Write-Host 'Finished configuring your console. You should recreate shortcuts of console applications you have used so that they get the default look.';
}
