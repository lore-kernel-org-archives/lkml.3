Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473Ab3DIVHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:07:06 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:41011 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936437Ab3DIVHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:07:03 -0400
Date: Tue, 9 Apr 2013 23:07:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.9-rc6
In-Reply-To: <alpine.DEB.2.00.1304092304220.23715@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1304092304550.23730@ayla.of.borg>
References: <alpine.DEB.2.00.1304092304220.23715@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.9-rc6 to v3.9-rc5[3], the summaries are:
>   - build errors: +8/-13

Ignoring R_PPC64_REL24 truncated relocations, as usual:

  + error: binder.c: undefined reference to `get_vm_area':  => .text+0x2fe8b8)
  + error: binder.c: undefined reference to `map_vm_area':  => .text+0x2fa11c) 
  + error: binder.c: undefined reference to `zap_page_range':  => .text+0x2fa354)

sh4/sh-randconfig

  + error: cuboot-pq2.c: undefined reference to `fsl_get_immr':  => .text+0x314)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6063/ (all 118 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6041/ (all 118 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
