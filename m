Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3ELUuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 16:50:11 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42409 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3ELUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 16:50:10 -0400
Date: Sun, 12 May 2013 22:50:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: devel@driverdev.osuosl.org
Subject: Re: Build regressions/improvements in v3.10-rc1 (staging)
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305122249360.5463@ayla.of.borg>
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

drivers/staging/android/logger.c:316:4: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
drivers/staging/android/logger.c:483:14: error: incompatible types when assigning to type 'uid_t' from type 'kuid_t': 2 errors in 2 logs
drivers/staging/android/logger.c:631:4: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
drivers/staging/android/logger.c:686:5: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
	v3.10-rc1/powerpc/powerpc-randconfig v3.10-rc1/sh4/sh-randconfig

drivers/staging/comedi/drivers/ni_labpc.c:980:9: error: implicit declaration of function 'virt_to_bus' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
	v3.10-rc1/powerpc/powerpc-allmodconfig v3.10-rc1/powerpc/powerpc-allyesconfig

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
