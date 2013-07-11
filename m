Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3GKNKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:10:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47174 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3GKNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
	<20130711104307.GB28131@pd.tnic>
	<CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
Date: Thu, 11 Jul 2013 15:10:38 +0200
X-Google-Sender-Auth: dZWsCkZtl_SZerrm_uQP8icyivs
Message-ID: <CAMuHMdXUp+CcNYbc+oy9ux4PSbm+g6i2w_vann5ML9xwMqYAyw@mail.gmail.com>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:49 PM, Konrad Vrba <konrad.vrba@gmail.com> wrote:
> On 7/11/13, Borislav Petkov <bp@alien8.de> wrote:
>> On Thu, Jul 11, 2013 at 12:28:20PM +0200, Konrad Vrba wrote:
>>> Hello,
>>> I have following error while compiling new stable kernel 3.10:
>>>
>>>   CC      kernel/fork.o
>>>   CC      kernel/exec_domain.o
>>>   CC      kernel/panic.o
>>>   CC      kernel/printk.o
>>>   CC      kernel/cpu.o
>>>   CC      kernel/exit.o
>>>   CC      kernel/itimer.o
>>> make[1]: *** No rule to make target `kernel/timeconst.pl', needed by
>>> `kernel/timeconst.h'.  Stop.
>>> make: *** [kernel] Error 2
>>>
>>> Could somebody please advise how to fix this ?
>>
>> Can you save your config first, cleanup the build dir from kbuild stuff:
>>
>> make mrproper
>>
>> and then try building again?
>>
>> FWIW, 3.10 and later builds just fine here.
>
> cleaning up with 'make mrproper'  does not help.
> I still get the same error

Do you still have build files around after "make mrproper"?
If this is a git clone, "git ls-files --others" will tell you.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
