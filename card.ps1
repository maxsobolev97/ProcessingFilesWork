#. .\SendMailFile.ps1
Import-Module "W:\BATCH\SendMailFile.ps1"
[string]$path_to_encr	 	= "C:\example\example\example\in\example\example"
[string]$path_to_encr_arc	= "C:\example\example\example"
[string]$path_to_decr		= "C:\example\example"
[string]$path_to_decr_arc	= "C:\example\example\example"
[string]$path_to_files		= "C:\example\example"
[string]$path_to_files_arc	= "C:\example\example\example"
[string]$crypto_path		= "C:\example\example\example\cryptcp.win32.exe"

[string]$path_card_arc	= "W:\example\"

[string]$path_ibso_in	= "W:\example\example"
[string]$path_ibso_out	= "W:\example\example"

[string]$path_jzdo_in	= "C:\example\example\example\example\example\example" 
[string]$path_jzdo_out	= "C:\example\example\example\example\example\example"
                                              
Function fRunExe {
    Param(
        $sProgram,
        $SArgs
    )

    $oProcess = New-Object System.Diagnostics.Process
    $oProcess.StartInfo.FileName = $sProgram
    $oProcess.StartInfo.Arguments = $SArgs
    $oProcess.StartInfo.RedirectStandardOutput = $true
    $oProcess.StartInfo.UseShellExecute = $false
    $oProcess.Start()
    $oProcess.WaitForExit()
    [string]$sProcessOut = $oProcess.StandardOutput.ReadToEnd()
}

Function fSortCardFile {  Param ( [string]$sMask, [string]$sAlias, $lIbso = 0, $lMail = 0 )

	$files_in_directory = Get-ChildItem $path_jzdo_in -Filter $sMask
	if ($files_in_directory) {
		foreach($file in $files_in_directory){
		    	if ($lIbso) { copy $file.FullName $path_ibso_in }
                        if ($lMail) { 
                            if($sAlias -eq "CBRFINREP\"){ 
                                Write-Host "Отправка для example"
                                SendMailFile "example@example.ru" "example@example.ru" $file.Name $file.FullName
                                Write-Host "Отправка для example"
                                SendMailFile "example@example.ru" "example@example.ru" $file.Name $file.FullName
                                } else {
                                SendMailFile "example@example.ru" "example@example.ru" $file.Name $file.FullName }
                            }
    			Move-Item -Force $file.FullName ($path_card_arc + $sAlias)
		}
	}
}

while($true){
    Write-Host("$(Get-Date)    Начало обработки")
    $files_in_directory = Get-ChildItem $path_to_encr -Filter "B001659*csv*"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        [Console]::WriteLine($file.FullName)
        $args_dec =  "-silent -decr -nochain -thumbprint 04bc65ed24bexamplea6050357936 " + $file.Fullname + " " + $path_to_decr +"\" + [io.path]::GetFileNameWithoutExtension($file.FullName)
        fRunExe $crypto_path $args_dec | Out-Null
        copy $file.FullName $path_to_encr_arc
        Remove-Item $file.FullName

    }
    }

    $files_in_directory = Get-ChildItem $path_to_decr -Filter "B001659*csv*"
	    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        $args_ver =  "-silent -verify -nochain -thumbprint e961223faexamplef1dfc6205fa " + $file.Fullname + " " + $path_to_files +"\" + [io.path]::GetFileNameWithoutExtension($file.FullName)
        fRunExe $crypto_path $args_ver
        copy $file.FullName $path_to_decr_arc
        Remove-Item $file.FullName
    }
    }

    $files_in_directory = Get-ChildItem $path_to_files -Filter "B001659*csv*"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        copy $file.FullName $path_to_files_arc
    }
    }

    fSortCardFile "CLEARINT_20*0583*" "CLEARINT\" 0 1
    fSortCardFile "BANKLIMIT_20*0583.csv*" "BANKLIMIT\" 0 0
    fSortCardFile "ACC_20*0583*" "ACC\" 1 0
    fSortCardFile "CTL20*0583*" "CTL\" 1 0
    fSortCardFile "OBI_20*0583*FEE" "OBI\" 1 0
    fSortCardFile "OBI_20*0583*" "OBI\" 0 0
    fSortCardFile "CTP20*0583*" "CTP\" 0 0
    fSortCardFile "OAI_20*0583*" "OAI\" 1 0
    fSortCardFile "OCGREP_20*0583*" "OCGREP\" 0 1
    fSortCardFile "OAH_20*0583*" "OAH\" 1 0
    fSortCardFile "OBR_20*0583*" "OBR\" 1 0
    fSortCardFile "IBI_20*0583*" "IBI\" 0 0
    fSortCardFile "IIA_20*0583*" "IIA\" 0 0
    fSortCardFile "OIA_20*0583*" "OIA\" 1 0
    fSortCardFile "OCI_20*0583*" "OCI\" 1 0
    fSortCardFile "DLV0583_20*0583*" "DLV\" 0 1
    fSortCardFile "APDET*0583*" "APDET\" 0 0
    fSortCardFile "GPDET*0583*" "GPDET\" 0 0
    fSortCardFile "OBM_*0583*" "OBM\" 0 0
    fSortCardFile "CSJN_20*0583*" "CSJN\" 1 0
    fSortCardFile "RATE_20*0583*" "RATE\" 1 1
    fSortCardFile "OCG058*" "OCG\" 1 1
    fSortCardFile "CBRFINREP*" "CBRFINREP\" 0 1

    $files_in_directory = Get-ChildItem $path_ibso_out -Filter "IBI_20*0583"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        copy $file.FullName $path_jzdo_out
        move $file.FullName ($path_card_arc + "IBI\")
    }
    }

    $files_in_directory = Get-ChildItem $path_ibso_out -Filter "RATE_20*0583"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        copy $file.FullName $path_jzdo_out
        move $file.FullName ($path_card_arc + "RATE\")
    }
    }

    $files_in_directory = Get-ChildItem $path_ibso_out -Filter "IIA_20*0583"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        copy $file.FullName $path_jzdo_out
        move $file.FullName ($path_card_arc + "IIA\")
    }
    }

    $files_in_directory = Get-ChildItem $path_ibso_out -Filter "OCG0583*"
    if ($files_in_directory) {
    foreach($file in $files_in_directory){
        copy $file.FullName $path_jzdo_out
        copy $file.FullName ($path_card_arc + "OCG\")
        Remove-Item $file.FullName -Force
    }
    }

    [System.GC]::Collect()
    Write-Host("$(Get-Date)    Завершение обработки")

    Write-Host("$(Get-Date)    Пауза 2 минуты")
    Start-Sleep 120

}