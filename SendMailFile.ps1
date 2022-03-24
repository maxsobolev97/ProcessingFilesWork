Function SendMailFile { Param(
        $aTo,
	$aFrom,
	$fSubj,
	$fAttachment
	)
	$MailMessage = New-Object system.net.mail.mailmessage 
	$MailMessage.from = $aFrom
	$MailMessage.To.add($aTo)
	$MailMessage.IsBodyHtml = 1
	$MailMessage.Body = 'Card File'
	$MailMessage.Subject = $fSubj
        $MailMessage.Attachments.Add($fAttachment)
	$SmtpClient = New-Object system.net.mail.smtpClient("mail.example.ru",25) 
	$SmtpClient.UseDefaultCredentials = 0
	$SmtpClient.Send($MailMessage)	
	$MailMessage.Dispose()
}









