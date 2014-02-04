Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaBDNj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:39:58 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57854 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaBDNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <3180926.X9oRPa7ARL@myon.chronox.de>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
	<3180926.X9oRPa7ARL@myon.chronox.de>
Date: Tue, 4 Feb 2014 14:39:54 +0100
X-Google-Sender-Auth: Uuvmaqj8jHEN8_r_p5ThRZ_vzQU
Message-ID: <CAMuHMdUpgifUHOYbYLDiLfDdTQ74PBUjjEJWGopg3BwD+qWR6g@mail.gmail.com>
Subject: Re: [PATCH 2/5] CPU Jitter RNG: Enable compilation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 1:40 PM, Stephan Mueller <smueller@chronox.de> wrote:
> +CFLAGS_jitterentropy-base.o    = -O0

Why? if really needed, this deserves a comment.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
