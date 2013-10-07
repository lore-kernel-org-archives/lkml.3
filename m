Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3JGT1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:27:14 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44348 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3JGT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <1381173828-3877-1-git-send-email-geert@linux-m68k.org>
References: <1381173828-3877-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 7 Oct 2013 21:27:06 +0200
X-Google-Sender-Auth: uJj6RwoSb-YNBvdPzAZ77KIfemo
Message-ID: <CAMuHMdVF=-RRRgDPjwc6C6=_2=hQJGyCUGtqBvRHCUjZftNrEg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.12-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 9:23 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.12-rc4 to v3.12-rc3[3], the summaries are:
>   - build errors: +6/-10

  + /scratch/kisskb/src/arch/powerpc/xmon/xmon.c: error: implicit
declaration of function 'dump_tlb_44x'
[-Werror=implicit-function-declaration]:  => 897:4
  + /scratch/kisskb/src/drivers/tty/serial/nwpserial.c: error:
implicit declaration of function 'udelay'
[-Werror=implicit-function-declaration]:  => 53:3

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6753/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6727/ (all 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
