Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaBSOOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:14:17 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42055 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaBSOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:14:16 -0500
MIME-Version: 1.0
In-Reply-To: <5304A5DF.8070302@cogentembedded.com>
References: <3035873.ZkIlzycZBr@daeseok-laptop.cloud.net>
	<5304A5DF.8070302@cogentembedded.com>
Date: Wed, 19 Feb 2014 23:14:14 +0900
Message-ID: <CAHb8M2DRCQW1qrNbijYbcj_JcZyb7QUWiqbCs6jzVC3qhcB3+Q@mail.gmail.com>
Subject: Re: [PATCH] ata: libahci: make ahci_pmp_retry_softreset() as static
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: tj <tj@kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-19 21:38 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> Hello.
>
>
> On 19-0202014 9:07, Daeseok Youn wrote:
>
>>  From 2a428e5e45bca3fc38fad17b9e2e14c5e6514ca0 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Wed, 19 Feb 2014 10:56:37 +0900
>> Subject: [PATCH] ata: libahci: make ahci_pmp_retry_softreset() as static
>
>
>    This header is not needed.
Actually, this patch was made by "git format-patch" command and
attached to mail client.

>
>
>> sparse says:
>
>
>> drivers/ata/libahci.c:1390:5: warning:
>>   symbol 'ahci_pmp_retry_softreset' was not declared. Should it be static?
>
>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>   drivers/ata/libahci.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
>> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
>> index 36605ab..f9600fe 100644
>> --- a/drivers/ata/libahci.c
>> +++ b/drivers/ata/libahci.c
>> @@ -1387,7 +1387,7 @@ static int ahci_bad_pmp_check_ready(struct ata_link
>> *link)
>>         return ata_check_ready(status);
>>   }
>>
>> -int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int *class,
>> +static int ahci_pmp_retry_softreset(struct ata_link *link, unsigned int
>> *class,
>>                                 unsigned long deadline)
>
>
>     Realign this continuation line too, for it to start under *struct* on
> the first line.

I will realign and send this patch again.

>
> WBR, Sergei
>

Thanks for your comment.
Daeseok Youn.
