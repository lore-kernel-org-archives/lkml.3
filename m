Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaJAHWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:22:33 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52059 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaJAHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <542AFD8A.8060806@nod.at>
References: <20140930201244.0a4596ec@canb.auug.org.au>
	<542AFB5E.7040308@infradead.org>
	<542AFD8A.8060806@nod.at>
Date: Wed, 1 Oct 2014 09:22:28 +0200
X-Google-Sender-Auth: vDuaFyrdIM3HOiDL-XtkYRbeX6Y
Message-ID: <CAMuHMdUvHuheygXquDpgH6hbvDanxC5Y5=Qpa+Kh=ZAYSLCuUw@mail.gmail.com>
Subject: Re: linux-next: Tree for Sep 30 (uml)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Walter <dwalter@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 8:59 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 30.09.2014 20:50, schrieb Randy Dunlap:
>> On 09/30/14 03:12, Stephen Rothwell wrote:
>>> Changes since 20140926:
>>>
>>
>> uml defconfig on i386 and x86_64:
>>
>> In file included from ../arch/x86/um/asm/processor.h:31:0,
>>                  from ../arch/um/include/asm/uaccess.h:16,
>>                  from ../arch/um/include/asm/thread_info.h:13,
>>                  from ../include/linux/thread_info.h:54,
>>                  from ../include/asm-generic/current.h:4,
>>                  from arch/um/include/generated/asm/current.h:1,
>>                  from ../include/linux/mutex.h:13,
>>                  from ../include/linux/kernfs.h:13,
>>                  from ../include/linux/sysfs.h:15,
>>                  from ../include/linux/kobject.h:21,
>>                  from ../include/linux/device.h:17,
>>                  from ../include/linux/platform_device.h:14,
>>                  from ../drivers/base/platform.c:14:
>> ../arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
>>  #define cpu_data (&boot_cpu_data)
>>                    ^
>> ../include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
>>   struct gpd_cpu_data *cpu_data;
>
> Thank you Randy, will look into this tomorrow.

Cfr. https://lkml.org/lkml/2014/9/16/478 on frv.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
