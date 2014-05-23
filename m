Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEWJDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:03:51 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:35092 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaEWJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:03:49 -0400
Date: Fri, 23 May 2014 11:03:48 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Subject: Build regressions/improvements in v3.15-rc6
In-Reply-To: <alpine.DEB.2.02.1405231102060.22585@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1405231102350.22600@ayla.of.borg>
References: <alpine.DEB.2.02.1405231102060.22585@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.15-rc6[1]  to v3.15-rc5[3], the summaries are:
>   - build errors: +1/-3

  + error: initramfs.c: undefined reference to `__stack_chk_guard':  => .init.text+0x1528)

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7497/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7468/ (all 119 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
