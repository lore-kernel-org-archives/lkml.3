Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3FQVXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:23:00 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52446 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3FQVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
	<CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
	<CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
	<20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
Date: Mon, 17 Jun 2013 23:22:58 +0200
X-Google-Sender-Auth: vOxJPHl_xXGL4TSOT0y1ggDVFkg
Message-ID: <CAMuHMdX6iryPpkBHsbfZJpScVNhAJ2pmAwgHsWr1yt8nY5-T2w@mail.gmail.com>
Subject: Re: Linux 3.10-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro
>
> f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
> on_each_cpu()") converted on_each_cpu() to a C function.  This required
> inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
> header ordering hell.
>
> Switch on_each_cpu() back to a macro to fix this.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
