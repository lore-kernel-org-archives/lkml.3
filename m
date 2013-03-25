Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab3CZAXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:23:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:49249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3CZAXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:23:30 -0400
Message-ID: <5150DC7E.2090305@infradead.org>
Date: Mon, 25 Mar 2013 16:23:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CONFIG_EARLY_PRINTK
References: <1363194921.1218.14.camel@localhost.localdomain>   <5140D9DF.4010506@infradead.org>  <1363446518.12329.5.camel@localhost.localdomain>  <5144AE20.7030202@infradead.org> <1363961254.11400.8.camel@localhost.localdomain>
In-Reply-To: <1363961254.11400.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/13 07:07, Thomas Meyer wrote:
> Am Samstag, den 16.03.2013, 10:38 -0700 schrieb Randy Dunlap:
>> On 03/16/13 08:08, Thomas Meyer wrote:
>>> Am Mittwoch, den 13.03.2013, 12:56 -0700 schrieb Randy Dunlap:
>>> Yes,
>>>
>>> so why not do this? As the text to EARLY_PRINTK explains?
>>
>> Yes, the default should match the help text.
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>>
>> Please resend your patch with Signed-off-by: line.
>>
>> Thanks.
> 
> Align EARLY_PRINTK default value with help text value.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

tip??

> ---
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index b322f12..852d51c 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -32,7 +32,6 @@ config X86_VERBOSE_BOOTUP
>  
>  config EARLY_PRINTK
>         bool "Early printk" if EXPERT
> -       default y
>         ---help---
>           Write kernel log output directly into the VGA buffer or to a serial
>           port.
> 
> 
> --


-- 
~Randy
