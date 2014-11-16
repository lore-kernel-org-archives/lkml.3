Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaKPJil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:38:41 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54885 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaKPJih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141110125806.GA16650@amd>
References: <20141110123118.GA31134@amd>
	<20141110125806.GA16650@amd>
Date: Sun, 16 Nov 2014 10:38:35 +0100
X-Google-Sender-Auth: oY1_AGb1oOK-FV900tV4rLPvTeY
Message-ID: <CAMuHMdUPxSZNPb=sv=OKfr5_PcHrBph=v5RVBb5Pp5DiW0pP9g@mail.gmail.com>
Subject: Re: dtb size limit? was Re: Tiny dts change breaks boot on n900
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@kernel.org>,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 1:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Breaks the boot. I'm using dtb append option. Any ideas? Nonbooting
> dtb is 68910 bytes.

Perhaps because it's not a multiple of 4?

$ factor 68910
68910: 2 3 5 2297

Does padding some property with 2 bytes help?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
