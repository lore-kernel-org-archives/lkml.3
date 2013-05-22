Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3EVSlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:41:20 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:39945 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EVSlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:41:19 -0400
Date: Wed, 22 May 2013 20:36:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.10-rc2
In-Reply-To: <alpine.DEB.2.00.1305222034040.25309@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305222035230.25364@ayla.of.borg>
References: <alpine.DEB.2.00.1305222034040.25309@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.10-rc2 to v3.10-rc1[3], the summaries are:
>   - build errors: +2/-13

One false positive due to a line concatenation, and

  + error: drivers/built-in.o: undefined reference to `il_pm_ops':  => .data+0x51ce4)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6246/ (120 out of 118 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6218/ (all 118 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
