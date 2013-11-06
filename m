Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3KFJbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:31:07 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:43139 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3KFJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:31:05 -0500
Date: Wed, 6 Nov 2013 10:31:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.12
In-Reply-To: <alpine.DEB.2.02.1311061028420.20227@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1311061030340.20318@ayla.of.borg>
References: <alpine.DEB.2.02.1311061028420.20227@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.12 to v3.12-rc7[3], the summaries are:
>   - build errors: +11/-6

Nothing serious:

  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_MASK' undeclared (first use in this function):  => 98:12
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_SHIFT' undeclared (first use in this function):  => 98:34, 145:10
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_MASK' undeclared (first use in this function):  => 97:21
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_SHIFT' undeclared (first use in this function):  => 97:42, 145:10
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + error: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!:  => N/A

parisc-allmodconfig (evil lustre)

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6840/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6819/ (119 out of 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
