Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3GAIKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:10:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37418 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3GAIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:10:33 -0400
Date: Mon, 1 Jul 2013 10:10:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 1/4] imx-drm: imx-drm-core: Export
 imx_drm_encoder_get_mux_id
Message-ID: <20130701081007.GU516@pengutronix.de>
References: <1372438530-1819-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372438530-1819-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:09:39 up 4 days, 21:19, 44 users,  load average: 8.35, 10.13,
 9.75
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:55:27PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we
> get the following build error:
> 
> ERROR: "imx_drm_encoder_get_mux_id" [drivers/staging/imx-drm/imx-ldb.ko] undefined!
> 
> Export the required function to avoid this problem.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

All: Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
> Changes since v1:
> - None
> 
>  drivers/staging/imx-drm/imx-drm-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 9854a1d..6bc205b 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -678,6 +678,7 @@ found:
>  
>  	return i;
>  }
> +EXPORT_SYMBOL_GPL(imx_drm_encoder_get_mux_id);
>  
>  /*
>   * imx_drm_remove_encoder - remove an encoder
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
