Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422683Ab3DFL0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:26:44 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:43826 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab3DFL0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:26:43 -0400
Date: Sat, 6 Apr 2013 13:26:41 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.9-rc5
In-Reply-To: <alpine.DEB.2.00.1304061323250.9581@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1304061324130.9593@ayla.of.borg>
References: <alpine.DEB.2.00.1304061323250.9581@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Apr 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.9-rc5 to v3.9-rc4[3], the summaries are:
>   - build errors: +129/-0

> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.

I think the only real one (in powerpc-randconfig) is:

+ arch/powerpc/kernel/tm.S: Error: unsupported relocation against THREAD_VR0:  => 323
+ arch/powerpc/kernel/tm.S: Error: unsupported relocation against THREAD_VSCR:  => 320

> [1] http://kisskb.ellerman.id.au/kisskb/head/6041/ (118 out of 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6015/ (80 out of 117 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
