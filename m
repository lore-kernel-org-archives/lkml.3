Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3ELUps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 16:45:48 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:38279 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3ELUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 16:45:47 -0400
Date: Sun, 12 May 2013 22:45:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: Build regressions/improvements in v3.10-rc1 (h8300)
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305122245160.5463@ayla.of.borg>
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

arch/h8300/kernel/entry.S:158: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
    ...
arch/h8300/kernel/entry.S:204: Error: invalid operands: 2 errors in 1 logs
    ...
arch/h8300/kernel/syscalls.S:100: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
arch/h8300/lib/abs.S:12: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
arch/h8300/lib/memcpy.S:13: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
arch/h8300/lib/memset.S:13: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
arch/h8300/platform/h8300h/generic/crt0_ram.S:25: Error: junk at end of line, first unrecognized character is `(': 1 errors in 1 logs
    ...
arch/h8300/platform/h8300h/generic/crt0_ram.S:68: Error: invalid operands: 1 errors in 1 logs
kernel/cpu/idle.c:70:4: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
	v3.10-rc1/h8300/h8300-defconfig
	Patch series sent last week


kernel/task_work.c:38:3: error: implicit declaration of function 'read_barrier_depends' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
	v3.10-rc1/h8300/h8300-defconfig
	Patch available


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
