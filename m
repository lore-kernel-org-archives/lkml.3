Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGHIDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:03:22 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42322 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaGHIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <1404806449-30974-1-git-send-email-geert@linux-m68k.org>
References: <1404806449-30974-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 8 Jul 2014 10:03:16 +0200
X-Google-Sender-Auth: qGWwQaRhjntUEgtZQvaCNy9Y4fQ
Message-ID: <CAMuHMdVeE9eistCN5zcZoAL+Fm4bQ-m+-uY87eFTOF-Q5+LKBA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 10:00 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc4[1]  to v3.16-rc3[3], the summaries are:
>   - build errors: +7/-2

  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_HIGH_MASK' undeclared (first use in this function):  => 98:12
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_HIGH_SHIFT' undeclared (first use in this function):  =>
145:10, 98:34
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_LOW_MASK' undeclared (first use in this function):  => 97:21
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'CHCR_TS_LOW_SHIFT' undeclared (first use in this function):  =>
97:42, 145:10
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error:
'cached_to_uncached' undeclared (first use in this function):  =>
99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit
declaration of function 'cpu_context'
[-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error:
-mcall-aixdesc must be big endian:  => 1:0

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7639/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7619/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
