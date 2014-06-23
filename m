Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaFWI2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:28:12 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39414 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFWI2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <1403511856-17875-1-git-send-email-geert@linux-m68k.org>
References: <1403511856-17875-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 23 Jun 2014 10:28:09 +0200
X-Google-Sender-Auth: YOFmIZfG50ZqfXSYsXktlpLOrs8
Message-ID: <CAMuHMdWJPJFPLQ3YMmuPXHXUDV_Gmx2YjPP-8Lri_RT1BWxfRQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:24 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc2[1]  to v3.16-rc1[3], the summaries are:
>   - build errors: +1/-6

  + /scratch/kisskb/src/drivers/edac/ppc4xx_edac.c: error: request for
member 'dimm' in something not a structure or union:  => 977:45

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7595/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7575/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
