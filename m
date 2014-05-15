Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaEOM02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:26:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaEOM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:26:26 -0400
Date: Thu, 15 May 2014 14:25:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: remove check for CONFIG_SDMA_IRAM
Message-ID: <20140515122553.GF5858@pengutronix.de>
References: <1400140671.20469.7.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400140671.20469.7.camel@x220>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:24:20 up 22 days,  5:55, 43 users,  load average: 0.19, 0.12,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, May 15, 2014 at 09:57:51AM +0200, Paul Bolle wrote:
> A check for CONFIG_SDMA_IRAM was added in v2.6.34. But the Kconfig
> symbol SDMA_IRAM was never added. Remove this check.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> Note that none of the MX51_MXC_DMA_CHANNEL_* macros are actually used.
> Why are they needed?

All these can be removed. They came in with the initial i.MX5 commit and
were never meaningful in a mainline kernel.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
