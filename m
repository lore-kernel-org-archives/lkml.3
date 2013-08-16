Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3HPJxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:53:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39192 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3HPJxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:53:15 -0400
Date: Fri, 16 Aug 2013 11:53:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] m25p80 / fast read
Message-ID: <20130816095302.GA1380@pengutronix.de>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:51:49 up 25 days, 14:09, 32 users,  load average: 11.73, 5.77,
 2.50
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

Any chance you take this for the next merge window?

Thanks
 Sascha

On Mon, Aug 12, 2013 at 12:22:22PM +0200, Sascha Hauer wrote:
> The following adds support for the mr25h10 chip to to the m25p80
> driver.
> 
> This driver currently has the problem that it unconditionally uses
> the fast_read command once it's enabled in Kconfig which of course
> leads to problems with multiboard kernels. This series adds a flag
> to the chip specific data to solve this. Also some unnecessary ifdefs
> are removed.
> 
> Sascha
> 
> ----------------------------------------------------------------
> Markus Niebel (1):
>       mtd: m25p80: add support for mr25h10
> 
> Sascha Hauer (3):
>       mtd: m25p80: Pass flags through CAT25_INFO macro
>       mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe to enable
>       mtd: m25p80: remove unnecessary ifdef
> 
>  drivers/mtd/devices/m25p80.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
