Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3KOL6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:58:04 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41244 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3KOL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:57:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAKaYPCNqzYcSyTUjjb9H3naErjzqjLDBthE2xfQ98j-YOzQWwg@mail.gmail.com>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<5285EE5A.1070202@southpole.se>
	<CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
	<5285FE1D.3020800@southpole.se>
	<CAKaYPCNqzYcSyTUjjb9H3naErjzqjLDBthE2xfQ98j-YOzQWwg@mail.gmail.com>
Date: Fri, 15 Nov 2013 12:57:51 +0100
X-Google-Sender-Auth: y8UzsLoflAzwu9qOPiSl4Yf2dT8
Message-ID: <CAMuHMdW4qTm5RbXAo1Vrp+TB0Rb4oxWVAU=78G3iFBSuVtcNyA@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Olof Kindgren <olof.kindgren@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux <linux@openrisc.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:39 PM, Olof Kindgren <olof.kindgren@gmail.com> wrote:
> More generally, can Linux use out-of-tree DTS files in an easy way? It's
> handy to have them in the kernel, but the best fit might actually be to put
> them in the corresponding orpsocv3 system directory. That would also make it
> easier to have separate device trees for differently configured FPGAs (they
> are reprogrammable after all).

If I'm not mistaken, this is ORPSoC v2?

Yes, it would be nice to have the DTS in ORPSoc itself.

Still, we would need overlays for the devices that are not defined in
ORPSoC, e.g. on-board (and off-board) devices on i2c and spi.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
