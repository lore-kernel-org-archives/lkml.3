Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab3FCSSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:18:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34936 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab3FCSSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130603174847.GA11111@kroah.com>
References: <1370280225-27479-1-git-send-email-benchan@chromium.org> <20130603174847.GA11111@kroah.com>
From: Ben Chan <benchan@chromium.org>
Date: Mon, 3 Jun 2013 11:18:21 -0700
X-Google-Sender-Auth: i2pbs4yWRYoVPnWE3rz5RIBQPt8
Message-ID: <CAC5Y2nOcGdF=d6X-9ZimYMkfJD-spw6D81ZdB1o7ra0_05hkMg@mail.gmail.com>
Subject: Re: [PATCH] staging: gdm72xx: WIMAX_GDM72XX should depend on either
 USB or MMC
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sage Ahn <syahn@gctsemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I meant to send the revised patch but got the wrong file.

I'll add the Reported-by field.

Thanks,
Ben

On Mon, Jun 3, 2013 at 10:48 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 03, 2013 at 10:23:45AM -0700, Ben Chan wrote:
>> The gdm72xx driver needs to have either the USB or SDIO implementation
>> enabled to provide useful functionalities, so the driver should depend
>> on either USB or MMC.
>>
>> Signed-off-by: Ben Chan <benchan@chromium.org>
>> Cc: Sage Ahn <syahn@gctsemi.com>
>> ---
>>  drivers/staging/gdm72xx/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
>> index 6905913..8af0dd4 100644
>> --- a/drivers/staging/gdm72xx/Kconfig
>> +++ b/drivers/staging/gdm72xx/Kconfig
>> @@ -4,7 +4,7 @@
>>
>>  menuconfig WIMAX_GDM72XX
>>       tristate "GCT GDM72xx WiMAX support"
>> -     depends on NET
>> +     depends on NET && (USB || MMC)
>
> Alan Stern already told you how this would not solve the problem, why
> did you resend it to me again?
>
> And you forgot the "Reported-by:" line above, giving proper credit to
> the person who told you about this problem.
>
> Please fix both of them and resend.
>
> thanks,
>
> greg k-h
