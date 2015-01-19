Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbbASTN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:13:29 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49508 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbASTN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXMsxhcD9C079YPc6Toxdo0e23oqM_9KeSG=NrFa4auRQ@mail.gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
	<1415342669-30640-2-git-send-email-cernekee@gmail.com>
	<CAMuHMdW+L8YbE8Z8jrtnm8xWk63sRGaFdM7TPM6MmrDg9XwHuQ@mail.gmail.com>
	<20141114163843.GH29662@linux-mips.org>
	<20141114170525.GL3698@titan.lakedaemon.net>
	<CAMuHMdXMsxhcD9C079YPc6Toxdo0e23oqM_9KeSG=NrFa4auRQ@mail.gmail.com>
Date: Mon, 19 Jan 2015 20:13:25 +0100
X-Google-Sender-Auth: juuyVqQ0_k8Qs29_xQE0a7KeXiA
Message-ID: <CAMuHMdUpxURV4ztpa3x0TORsSWtxiKxe6_EDO5QsO_vhedip0A@mail.gmail.com>
Subject: Re: [PATCH V4 01/14] sh: Eliminate unused irq_reg_{readl,writel} accessors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Sun, Nov 16, 2014 at 10:34 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Jason,
>
> On Fri, Nov 14, 2014 at 6:05 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> On Fri, Nov 14, 2014 at 05:38:44PM +0100, Ralf Baechle wrote:
>>> On Mon, Nov 10, 2014 at 09:13:49AM +0100, Geert Uytterhoeven wrote:
>>>
>>> > On Fri, Nov 7, 2014 at 7:44 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
>>> > > Defining these macros way down in arch/sh/.../irq.c doesn't cause
>>> > > kernel/irq/generic-chip.c to use them.  As far as I can tell this code
>>> > > has no effect.
>>> > >
>>> > > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
>>> >
>>> > Compared preprocessor and asm output before and after, no difference
>>> > except for line numbers, so
>>> >
>>> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>>
>>> I noticed the remainder of of this series is now in Jason Cooper's irqchip
>>> tree.  Is anybody still taking care of SH?  If not I can funnel it
>>> through the MIPS tree.
>>
>> Are the SH maintainers active?  I admit I know very little about the
>> arch.  I'm more than happy to pick it up and keep it with the rest of
>> the series, I just didn't want to step on toes...
>
> SH is orphaned, so it would be great if you could pick it up.
> Thanks!

I think you forgot to pick it up, as se7343 and se7722 are still broken:

http://kisskb.ellerman.id.au/kisskb/buildresult/12346740/
http://kisskb.ellerman.id.au/kisskb/buildresult/12346745/

Will you still do so, or shall I forward the patch to Andrew Morton?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
