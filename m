Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3GIHvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:51:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3GIHv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:51:29 -0400
Date: Tue, 9 Jul 2013 09:51:24 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: grant.likely@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
Message-ID: <20130709075124.GR516@pengutronix.de>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>
 <20130709070541.GQ516@pengutronix.de>
 <51DBBFDA.70302@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51DBBFDA.70302@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:49:17 up 12 days, 20:58, 70 users,  load average: 2.06, 8.07,
 7.58
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
> 于 2013年07月09日 15:05, Sascha Hauer 写道:
> >Why don't you set the matching order in the driver the way you want it
> >to be, i.e.:
> >
> >	{ .compatible = "fsl,imx6q-uart", ... },
> >	{ .compatible = "fsl,imx21-uart", ... },
> >	{ .compatible = "fsl,imx1-uart", ... },
> >
> yes. i can set it like this.
> 
> but this method looks like a ugly workaround.

If a driver has different ways of supporting a single device, then
putting the preferred or most feature rich on top doesn't look very ugly
to me.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
