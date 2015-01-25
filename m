Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbbAYKNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:13:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:50515 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbbAYKNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501241851090.5526@nanos>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
	<1415342669-30640-2-git-send-email-cernekee@gmail.com>
	<CAMuHMdW+L8YbE8Z8jrtnm8xWk63sRGaFdM7TPM6MmrDg9XwHuQ@mail.gmail.com>
	<20141114163843.GH29662@linux-mips.org>
	<20141114170525.GL3698@titan.lakedaemon.net>
	<CAMuHMdXMsxhcD9C079YPc6Toxdo0e23oqM_9KeSG=NrFa4auRQ@mail.gmail.com>
	<CAMuHMdUpxURV4ztpa3x0TORsSWtxiKxe6_EDO5QsO_vhedip0A@mail.gmail.com>
	<alpine.DEB.2.11.1501241851090.5526@nanos>
Date: Sun, 25 Jan 2015 11:13:42 +0100
X-Google-Sender-Auth: IpMSbe7qTV1H6obYQGgV3A5b1xE
Message-ID: <CAMuHMdWQWVv+RJhhae59b+GEv_Gfgn0UQpWgFQ2Q7y+KGjTrEg@mail.gmail.com>
Subject: Re: [PATCH V4 01/14] sh: Eliminate unused irq_reg_{readl,writel} accessors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>, Ralf Baechle <ralf@linux-mips.org>,
        Kevin Cernekee <cernekee@gmail.com>,
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

On Sat, Jan 24, 2015 at 6:51 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 19 Jan 2015, Geert Uytterhoeven wrote:
>> Will you still do so, or shall I forward the patch to Andrew Morton?
>
> akpm please.

Forwarded with build failure descriptions added.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
