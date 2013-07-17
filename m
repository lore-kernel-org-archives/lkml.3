Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3GQIYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:24:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38920 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3GQIYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:24:05 -0400
Date: Wed, 17 Jul 2013 10:23:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: drm/imx: drop "select OF_VIDEOMODE"
Message-ID: <20130717082355.GC10380@pengutronix.de>
References: <1373801388.1370.15.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373801388.1370.15.camel@x61.thuisdomein>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:23:21 up 21:19, 61 users,  load average: 1.99, 1.24, 0.74
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 01:29:48PM +0200, Paul Bolle wrote:
> Commit ac4c1a9b33 ("staging: drm/imx: Add LDB support") added the
> DRM_IMX_LDB Kconfig entry. That entry selects OF_VIDEOMODE. But there is
> no Kconfig symbol named OF_VIDEOMODE. The select statement for that
> symbol is a nop. Drop it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Not tested!
> 
> 1) Perhaps OF_VIDEOMODE was selected because this commit added an
> include of <video/of_videomode>. But the functionality of that header
> requires the Kconfig symbol VIDEOMODE_HELPERS. The commit didn't use
> that Kconfig symbol.
> 
> The again, as far as I can tell, the drm/imx code doesn't actually use
> the videomode of-helper. So it seems the include of <video/of_videomode>
> isn't needed anyway.

Looks all good.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
