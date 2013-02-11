Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3BKQIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:08:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33475 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab3BKQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:08:00 -0500
Date: Mon, 11 Feb 2013 17:07:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Allow clock alias provision from device
 tree
Message-ID: <20130211160752.GG1906@pengutronix.de>
References: <1360597464-8491-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360597464-8491-1-git-send-email-rogerq@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:04:06 up 233 days,  7:15, 74 users,  load average: 1.45, 1.38,
 1.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:44:23PM +0200, Roger Quadros wrote:
> Currently on OMAP, it is not possible to specify a clock consumer
> to any of the OMAP generated clocks using the device tree. This can pose
> a problem for external devices that run off an OMAP clock as we
> can't reliably provide a reference to the clock in the device tree.

There is an established way of providing clocks in the devicetree using
the clocks/clock-names properties. Wouldn't it be better using this
for OMAP aswell?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
