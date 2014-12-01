Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaLALBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:01:13 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaLALBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <1417431336-2012-1-git-send-email-geert@linux-m68k.org>
References: <1417431336-2012-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 1 Dec 2014 12:01:10 +0100
X-Google-Sender-Auth: JM2tAstaW6M8uY5F-eQb86vFC_0
Message-ID: <CAMuHMdXPoOe3srvZp1nQQ1O6CcuROyUzAy2wNukSqwDjobZCdQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 11:55 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc7[1]  to v3.18-rc6[3], the summaries are:
>   - build errors: +2/-10

Nothing interesting, just a known powerpc-randconfig issue and one more
truncated relocation in powerpc-allyesconfig[*].

> [1] http://kisskb.ellerman.id.au/kisskb/head/8143/ (262 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8117/ (120 out of 119 configs)

[*] Just wondering: Recently m68k had to fix a kernel size limitation (cfr.
    commit 486df8bc4627bdfc ("m68k: Increase initial mapping to 8 or 16 MiB
    if possible"), as multi_defconfig was no longer bootable. How long
    before PPC is forced to fix the toolchain due to kernel bloat ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
