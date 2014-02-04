Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaBDTji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:39:38 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45674 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140204192325.GA11831@thunk.org>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
	<20140204170823.GF12768@thunk.org>
	<52F13A1C.3040003@zytor.com>
	<20140204192325.GA11831@thunk.org>
Date: Tue, 4 Feb 2014 20:39:34 +0100
X-Google-Sender-Auth: FhodWGFVUR1NO_xB6du8Y_9cmfM
Message-ID: <CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephan Mueller <smueller@chronox.de>,
        =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 8:23 PM,  <tytso@mit.edu> wrote:
> However, where a decade ago the ethernet card probably had its own
> independent clock crystal/oscillator, I'm going to guess that these
> days with SOC's and even on laptops, with ethernet device part of the
> chipset, it is probably being driven off the same master oscillator.

USB typically still has its own crystal.

> I wonder if there's anyway we can either figure out manually, or
> preferably, automatically at boot time, which devices actually have
> independent clock oscillators.

You may find this information in the DT on some platforms (if you're
lucky).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
