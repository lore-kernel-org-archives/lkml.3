Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaKRJhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:37:48 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33432 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaKRJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <1416302641.7024.7.camel@x220>
References: <1416302641.7024.7.camel@x220>
Date: Tue, 18 Nov 2014 10:36:35 +0100
X-Google-Sender-Auth: R4ZIBtzIBlcdh-gLMis09VTk5IQ
Message-ID: <CAMuHMdUFZo+r-N0Ofa1d6PHDtB6dqZfChpLgOz_XtruWD3_a3g@mail.gmail.com>
Subject: Re: ARM: shmobile: ARCH_R8A7793?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Nov 18, 2014 at 10:24 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Your commit 7a2071c58f36 ("ARM: shmobile: Add early debugging support
> using SCIF(A)") is included in today's linux-next (ie, next-20141118).
> It adds an (optional) dependency on the Kconfig symbol ARCH_R8A7793. But
> that symbol isn't part of next-20141118.
>
> Is a patch that adds this symbol queued somewhere?

Not yet. I was just a bit pro-active ;-)

However, there are already references to r8a7793 in DT binding documentation,
and in of_device_id arrays in drivers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
