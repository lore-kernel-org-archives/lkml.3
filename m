Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3CPRi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:38:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:52450 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3CPRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:38:25 -0400
Message-ID: <5144AE20.7030202@infradead.org>
Date: Sat, 16 Mar 2013 10:38:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CONFIG_EARLY_PRINTK
References: <1363194921.1218.14.camel@localhost.localdomain>  <5140D9DF.4010506@infradead.org> <1363446518.12329.5.camel@localhost.localdomain>
In-Reply-To: <1363446518.12329.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/13 08:08, Thomas Meyer wrote:
> Am Mittwoch, den 13.03.2013, 12:56 -0700 schrieb Randy Dunlap:
>> On 03/13/13 10:15, Thomas Meyer wrote:
>>> Hi,
>>>
>>>  -*- Early printk 
>>>
>>> help text says:
>>> "You should normally N here, unless you want to debug such a crash.
>>> (Depends on: EXPERT [=n])"
>>>
>>> How to normally N here?
>>
>> You'll have to enable CONFIG_EXPERT and then you can disable EARLY_PRINTK.
>>
>> You may even have to disable CONFIG_EMBEDDED before you can enable
>> CONFIG_EXPERT (I did).
>>
>> Too many hoops to have to jump through.   :(
>>
> 
> Yes,
> 
> so why not do this? As the text to EARLY_PRINTK explains?

Yes, the default should match the help text.
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Please resend your patch with Signed-off-by: line.

Thanks.

> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index b322f12..d6c2d89 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -32,7 +32,7 @@ config X86_VERBOSE_BOOTUP
>  
>  config EARLY_PRINTK
>         bool "Early printk" if EXPERT
> -       default y
> +       default n
>         ---help---
>           Write kernel log output directly into the VGA buffer or to a
> serial
>           port.
> 
> 
> 


-- 
~Randy
