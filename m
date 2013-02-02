Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3BBUIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:08:10 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:55413 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab3BBUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:08:09 -0500
Date: Sat, 2 Feb 2013 21:08:07 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: linux-sh@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: Build regressions/improvements in v3.8-rc6
In-Reply-To: <alpine.DEB.2.00.1302022103360.9586@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1302022105410.9650@ayla.of.borg>
References: <alpine.DEB.2.00.1302022103360.9586@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.8-rc6 to v3.8-rc5[3], the summaries are:
>   - build errors: +6/-6

Ignoring the ppc truncated relocations, there's only one regression:

  + error: spi-rspi.c: undefined reference to `shdma_chan_filter':  => .text+0xf1074)

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5846/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5828/ (all 117 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
