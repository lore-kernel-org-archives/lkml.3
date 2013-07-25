Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3GYNhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:37:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60572 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3GYNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <204d93f8a9dffef6ff00d961f91be0b465f21841.1374751310.git.michal.simek@xilinx.com>
References: <204d93f8a9dffef6ff00d961f91be0b465f21841.1374751310.git.michal.simek@xilinx.com>
Date: Thu, 25 Jul 2013 15:36:55 +0200
X-Google-Sender-Auth: r9mHtk9AArRgoejqnfRzr6wgtuY
Message-ID: <CAMuHMdX2mKANduZO9HaBHRZ13V0PztOc-uYxTymUsH8-NE5FEQ@mail.gmail.com>
Subject: Re: [PATCH v2] video: xilinxfb: Fix compilation warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Michal Simek <monstr@monstr.eu>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 1:21 PM, Michal Simek <michal.simek@xilinx.com> wrote:
> regs_phys is phys_addr_t (u32 or u64).
> Lets retype it to u64.

This no longer matches the actual patch?

> Fixes compilation warning introduced by:
> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - Use %pa instead of casting

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
