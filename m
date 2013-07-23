Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab3GWQk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:40:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47447 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab3GWQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:40:26 -0400
Date: Tue, 23 Jul 2013 18:40:21 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Masanari Iida <standby24x7@gmail.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: imx-drm: Fix typo in staging/imx-drm
Message-ID: <20130723164021.GR9434@pengutronix.de>
References: <1374595507-26418-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374595507-26418-1-git-send-email-standby24x7@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:40:07 up 40 days,  4:50, 20 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:05:07AM +0900, Masanari Iida wrote:
> Correct spelling typo in staging/imx-drm
> 
> Singed-off-by: Masanari Iida <standby24x7@gmail.com>


Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/Kconfig   | 2 +-
>  drivers/staging/imx-drm/imx-ldb.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
> index 2233905..6156e3f 100644
> --- a/drivers/staging/imx-drm/Kconfig
> +++ b/drivers/staging/imx-drm/Kconfig
> @@ -15,7 +15,7 @@ config DRM_IMX_FB_HELPER
>  	help
>  	  The DRM framework can provide a legacy /dev/fb0 framebuffer
>  	  for your device. This is necessary to get a framebuffer console
> -	  and also for appplications using the legacy framebuffer API
> +	  and also for applications using the legacy framebuffer API
>  
>  config DRM_IMX_PARALLEL_DISPLAY
>  	tristate "Support for parallel displays"
> diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
> index 8af7f3b..bb7da0e 100644
> --- a/drivers/staging/imx-drm/imx-ldb.c
> +++ b/drivers/staging/imx-drm/imx-ldb.c
> @@ -497,7 +497,7 @@ static int imx_ldb_probe(struct platform_device *pdev)
>  		imx_ldb->ldb_ctrl |= LDB_SPLIT_MODE_EN;
>  
>  	/*
> -	 * There are three diferent possible clock mux configurations:
> +	 * There are three different possible clock mux configurations:
>  	 * i.MX53:  ipu1_di0_sel, ipu1_di1_sel
>  	 * i.MX6q:  ipu1_di0_sel, ipu1_di1_sel, ipu2_di0_sel, ipu2_di1_sel
>  	 * i.MX6dl: ipu1_di0_sel, ipu1_di1_sel, lcdif_sel
> -- 
> 1.8.3.3.820.ge3d4493
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
