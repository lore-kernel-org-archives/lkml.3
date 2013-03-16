Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3CPUKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:10:45 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:58623 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3CPUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <5144AE20.7030202@infradead.org>
References: <1363194921.1218.14.camel@localhost.localdomain>
	<5140D9DF.4010506@infradead.org>
	<1363446518.12329.5.camel@localhost.localdomain>
	<5144AE20.7030202@infradead.org>
Date: Sat, 16 Mar 2013 21:10:43 +0100
X-Google-Sender-Auth: VkTXkNIuNod3gHH_DPaSq1gUVaA
Message-ID: <CAMuHMdUR8zEyHnJd65UhRh4L=hEWZjTFLkyetP5dvg02a-yntQ@mail.gmail.com>
Subject: Re: CONFIG_EARLY_PRINTK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 6:38 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 03/16/13 08:08, Thomas Meyer wrote:
>> Am Mittwoch, den 13.03.2013, 12:56 -0700 schrieb Randy Dunlap:
>>> On 03/13/13 10:15, Thomas Meyer wrote:
>>>> help text says:
>>>> "You should normally N here, unless you want to debug such a crash.
>>>> (Depends on: EXPERT [=n])"
>>>>
>>>> How to normally N here?

>> so why not do this? As the text to EARLY_PRINTK explains?
>
> Yes, the default should match the help text.

So just remove the "default n" line, as "n" is the default.

> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>
> Please resend your patch with Signed-off-by: line.
>
> Thanks.
>
>>
>> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
>> index b322f12..d6c2d89 100644
>> --- a/arch/x86/Kconfig.debug
>> +++ b/arch/x86/Kconfig.debug
>> @@ -32,7 +32,7 @@ config X86_VERBOSE_BOOTUP
>>
>>  config EARLY_PRINTK
>>         bool "Early printk" if EXPERT
>> -       default y
>> +       default n
>>         ---help---
>>           Write kernel log output directly into the VGA buffer or to a
>> serial
>>           port.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
