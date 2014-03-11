Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaCKNmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:42:24 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65216 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbaCKNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140311132652.GS28112@sirena.org.uk>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<1394531952-3905-3-git-send-email-geert@linux-m68k.org>
	<20140311104713.GN28112@sirena.org.uk>
	<CAMuHMdWoPWebnyUu2uGebbnzu68Lh4qsgzpu-otnwMmvaeY1hQ@mail.gmail.com>
	<20140311132652.GS28112@sirena.org.uk>
Date: Tue, 11 Mar 2014 14:35:15 +0100
X-Google-Sender-Auth: r9Leg_CsGPl8ZsDoewNZISsRWAE
Message-ID: <CAMuHMdVf_4TPf6YKuHLztrgFKWHTeoVi5agesO6tFU5h_56DOA@mail.gmail.com>
Subject: Re: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core auto_runtime_pm
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Mar 11, 2014 at 2:26 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Mar 11, 2014 at 02:10:31PM +0100, Geert Uytterhoeven wrote:
>
>> Can you please elaborate what should be fixed?
>
>> If I disable CONFIG_PM_RUNTIME, the kernel prints:
>
>>     Runtime PM disabled, clock forced on.
>
>> and the clock is enabled all the time (verified by looking at the clock
>> registers)?
>
> That's very SH specific and doesn't apply in the general case (I would
> not be surprised if future SH updates broke it...).

Note that this is from drivers/base/power/clock_ops.c

So what should I do instead?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
