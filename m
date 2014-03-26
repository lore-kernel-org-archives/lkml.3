Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaCZHzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:55:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61524 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaCZHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <1395820064-19148-1-git-send-email-geert@linux-m68k.org>
References: <1395820064-19148-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 26 Mar 2014 08:55:37 +0100
X-Google-Sender-Auth: 7y28iHEWzypHy6JpUvbGvpopyV4
Message-ID: <CAMuHMdWQmAmG8oebHh8SVodAp_TXHX1wLBoEZRfMz=HRxVdQmg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 8:47 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc8[1]  to v3.14-rc7[3], the summaries are:
>   - build errors: +6/-1

  + /scratch/kisskb/src/arch/powerpc/include/asm/io.h: error:
'virt_phys_offset' undeclared (first use in this function):  =>
814:16, 807:16, 770:9, 787:17
  + /scratch/kisskb/src/include/linux/mm.h: error: 'virt_phys_offset'
undeclared (first use in this function):  => 890:9, 1402:20, 494:22

powerpc-randconfig

  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_HIGH_MASK' undeclared (first use in this function):  => 98:12
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_HIGH_SHIFT' undeclared (first use in this function):  =>
98:34, 145:10
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_LOW_MASK' undeclared (first use in this function):  => 97:21
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_LOW_SHIFT' undeclared (first use in this function):  =>
97:42, 145:10

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7303/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7277/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
