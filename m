Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3KOKrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:47:22 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50072 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3KOKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:47:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<5285EE5A.1070202@southpole.se>
	<CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
Date: Fri, 15 Nov 2013 11:47:12 +0100
X-Google-Sender-Auth: SuohPDOzEEB2c0h6Hf02ZM4zVHw
Message-ID: <CAMuHMdV=u04Y2saVygB=FSPTDgqSf+0YNUb0q3=aVZ9oTORs+Q@mail.gmail.com>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:22 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> The supplied schematics filename is de0-nano-c4-rev-c\(release_cd_rom\).pdf,
> and the drawings mention "Rev C".
> The block diagram on page 2 still says "EPCS16 (16 Mb), but on page 8 it
> mentions "EPCS64", which is what's on my board.

I found the Rev B schematics on the web. It lacks the EPCS drawing
on page 8.

According to
http://forums.parallax.com/showthread.php/132578-Getting-started-with-FPGAs/page7
there are also versions with a 64 Mbit Altera EPCS64.

So my guess is:
  Rev A: EPCS16
  Rev B: Altera EPCS64
  Rev C: Spansian EPCS64

Unless Andrew and I have Rev Fs, as there's no "C" on our boards.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
