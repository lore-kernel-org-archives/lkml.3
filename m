Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3ELUur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 16:50:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:59974 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3ELUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 16:50:46 -0400
Date: Sun, 12 May 2013 22:50:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.10-rc1 (s390)
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305122250110.5463@ayla.of.borg>
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

drivers/net/ethernet/sfc/efx.c:646:3: error: call to '__compiletime_assert_648' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) + EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2: 2 errors in 2 logs
	v3.10-rc1/s390x/s390-allyesconfig v3.10-rc1/s390x/s390-allmodconfig

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
