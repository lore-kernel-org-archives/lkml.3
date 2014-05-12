Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaELJu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:50:57 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50784 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaELJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:50:55 -0400
Date: Mon, 12 May 2014 11:50:54 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.15-rc5
In-Reply-To: <alpine.DEB.2.02.1405121147480.29403@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1405121149270.29472@ayla.of.borg>
References: <alpine.DEB.2.02.1405121147480.29403@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.15-rc5[1]  to v3.15-rc4[3], the summaries are:
>   - build errors: +3/-7

  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7468/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7449/ (all 119 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
