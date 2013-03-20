Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3CTJiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:38:55 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61144 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3CTJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:38:53 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 10:38:52 +0100
X-Google-Sender-Auth: PilsUH1xCMLkILzOLBUQGJWJra4
Message-ID: <CAMuHMdVPNdrvOSDWNhKqOSuLJL39dMuDmDAjuKerFGnZ5WvkOQ@mail.gmail.com>
Subject: Missing WIDE_BUS_[48] (was: Re: mmc: bfin_sdh: Add support for new
 RSI controller in bf60x)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sonic Zhang <sonic.zhang@analog.com>, Chris Ball <cjb@laptop.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 4:28 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=4ffdcf0469f1e7e47476ee410e8dfbc6aba61b65
> Commit:     4ffdcf0469f1e7e47476ee410e8dfbc6aba61b65
> Parent:     0462566b1e3129b2920b63b62a653b70a1bc36fa
> Author:     Sonic Zhang <sonic.zhang@analog.com>
> AuthorDate: Wed Aug 8 00:13:32 2012 -0400
> Committer:  Chris Ball <cjb@laptop.org>
> CommitDate: Tue Sep 4 13:58:18 2012 -0400
>
>     mmc: bfin_sdh: Add support for new RSI controller in bf60x

> +               clk_ctl |= WIDE_BUS_4;

Any plans to introduce this "WIDE_BUS_4", and the corresponding "WIDE_BUS_8"
symbols in mainline?

http://kisskb.ellerman.id.au/kisskb/buildresult/8427478/

drivers/mmc/host/bfin_sdh.c:378:14: error: 'WIDE_BUS_4' undeclared
(first use in this function)
drivers/mmc/host/bfin_sdh.c:387:14: error: 'BYTE_BUS_8' undeclared
(first use in this function)

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
