Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3GJFxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:53:42 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61587 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3GJFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <51DC365E.7000900@metafoo.de>
References: <1373383278-3339-1-git-send-email-cristian.bercaru@freescale.com>
	<51DC365E.7000900@metafoo.de>
Date: Wed, 10 Jul 2013 07:53:41 +0200
X-Google-Sender-Auth: d_sLdFIl-hUrIoVUg4Y4RwIf_jA
Message-ID: <CAAxaTiN+4u1CYYOzw1Bu-gcyQ6+Db-Yk7DWdHOq6GRatfvHW7w@mail.gmail.com>
Subject: Re: [Cocci] [PATCH] invoke arguments the right way in coccinelle script
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Cristian Bercaru <cristian.bercaru@freescale.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristian,

You need Coccinelle version 1.0.0-rc11 or above. I think the minimal
required version
is about one year old.

For more information see Documentation/coccinelle.txt which have been updated.
If you prefer to stick to your current version, the commits to revert
are the following ones

ec97946ed038f4b3faa587bc76152b198805b0c4
93f14468491747d6d3efd0b3a42785b1d51a127a

Regards,


On Tue, Jul 9, 2013 at 6:12 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 07/09/2013 05:21 PM, Cristian Bercaru wrote:
>> Because the command line arguments were invoked incorrectly
>> 'make coccicheck' failed to run 'irqf_oneshot.cocci' and all tests that
>> followed. Fixed that.
>>
>> Signed-off-by: Cristian Bercaru <cristian.bercaru@freescale.com>
>
> Time to update your coccinelle installation ;)
>
> --no-include is support in new versions and is prefered over -no_includes
>
>> ---
>>  scripts/coccinelle/misc/irqf_oneshot.cocci | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/coccinelle/misc/irqf_oneshot.cocci b/scripts/coccinelle/misc/irqf_oneshot.cocci
>> index 6cfde94..5cca680 100644
>> --- a/scripts/coccinelle/misc/irqf_oneshot.cocci
>> +++ b/scripts/coccinelle/misc/irqf_oneshot.cocci
>> @@ -4,7 +4,7 @@
>>  //
>>  // Confidence: Good
>>  // Comments:
>> -// Options: --no-includes
>> +// Options: -no_includes
>>
>>  virtual patch
>>  virtual context
>
> _______________________________________________
> Cocci mailing list
> Cocci@systeme.lip6.fr
> https://systeme.lip6.fr/mailman/listinfo/cocci



-- 
Nicolas Palix
Tel: +33 4 76 51 46 27
http://membres-liglab.imag.fr/palix/
