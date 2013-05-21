Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3EUGiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:38:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42038 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3EUGiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:38:15 -0400
Date: Tue, 21 May 2013 08:38:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] imx-drm: imx-tve: Check the return value of
 'regulator_enable()'
Message-ID: <20130521063808.GG32299@pengutronix.de>
References: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:37:45 up 331 days, 21:49, 28 users,  load average: 0.44, 0.55,
 0.50
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:55:49AM -0300, Fabio Estevam wrote:
> Check the return value of 'regulator_enable()' to fix the following build error:
> 
> drivers/staging/imx-drm/imx-tve.c: In function 'imx_tve_probe':
> drivers/staging/imx-drm/imx-tve.c:671:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

All three:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
