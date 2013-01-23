Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3AWVPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:15:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57903 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWVO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:14:56 -0500
Date: Wed, 23 Jan 2013 22:14:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ipu-di: Change DI address info to dev_dbg
Message-ID: <20130123211452.GG1906@pengutronix.de>
References: <1357746750-28675-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357746750-28675-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:14:28 up 214 days, 12:26, 52 users,  load average: 0.12, 0.52,
 1.16
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 01:52:30PM -0200, Fabio Estevam wrote:
> Currently when ipuv3 is probed we have:
> 
> imx-ipuv3 40000000.ipu: DI0 base: 0x5e040000 remapped to a08aa000
> imx-ipuv3 40000000.ipu: DI1 base: 0x5e048000 remapped to a08ac000
> imx-ipuv3 40000000.ipu: IPUv3EX probed
> 
> The DI base address and the remapped address are more interesting for debug 
> purposes, so mark this message as dev_dbg instead.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-di.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> index 67d974f..ec340da 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
> @@ -677,7 +677,7 @@ int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
>  		goto failed_clk_register;
>  	}
>  
> -	dev_info(dev, "DI%d base: 0x%08lx remapped to %p\n",
> +	dev_dbg(dev, "DI%d base: 0x%08lx remapped to %p\n",
>  			id, base, di->base);
>  	di->inuse = false;
>  	di->ipu = ipu;
> -- 
> 1.7.9.5
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
