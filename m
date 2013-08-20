Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3HTJZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:25:04 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:42929 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3HTJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:25:03 -0400
Date: Tue, 20 Aug 2013 11:24:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.11-rc6
In-Reply-To: <alpine.DEB.2.02.1308201120400.26995@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1308201121150.27907@ayla.of.borg>
References: <alpine.DEB.2.02.1308201120400.26995@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.11-rc6 to v3.11-rc5[3], the summaries are:
>   - build errors: +6/-9

  + arch/powerpc/kvm/book3s_xics.c: error: implicit declaration of function 'get_tb' [-Werror=implicit-function-declaration]:  => 812:3

powerpc-randconfig

  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A

i386-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6556/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6532/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
