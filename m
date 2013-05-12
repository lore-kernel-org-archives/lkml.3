Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3ELUqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 16:46:33 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33320 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3ELUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 16:46:32 -0400
Date: Sun, 12 May 2013 22:46:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/MIPS Development <linux-mips@linux-mips.org>
Subject: Re: Build regressions/improvements in v3.10-rc1 (mips)
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305122245510.5463@ayla.of.borg>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg> <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> However, the full list of errors isn't that unmanageable, so I'm following
> up with a digested list...

arch/mips/kernel/crash_dump.c:67:17: error: assignment makes pointer from integer without a cast [-Werror]: 1 errors in 1 logs
arch/mips/kernel/crash_dump.c:67:2: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
	v3.10-rc1/mips/mips-allmodconfig


drivers/net/ethernet/3com/3c59x.c:1026:2: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/net/ethernet/3com/3c59x.c:1038:3: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
	v3.10-rc1/mips/mips-allmodconfig


sound/oss/soundcard.c:69:31: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function): 1 errors in 1 logs
	v3.10-rc1/mips/mips-allmodconfig

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
