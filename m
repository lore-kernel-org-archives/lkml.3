Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3GYIIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:08:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57581 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYIHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:07:48 -0400
Date: Thu, 25 Jul 2013 10:07:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] imx-drm: TODO: Remove LVDS support from missing
 features list.
Message-ID: <20130725080738.GW9434@pengutronix.de>
References: <1374599732-24255-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374599732-24255-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:07:25 up 41 days, 20:17, 19 users,  load average: 0.15, 0.07,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:15:32PM -0300, Fabio Estevam wrote:
> LVDS Display Bridge is currently supported, so remove it from the missing
> features list.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>


Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/TODO | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/TODO b/drivers/staging/imx-drm/TODO
> index f806415..9cfa2a7 100644
> --- a/drivers/staging/imx-drm/TODO
> +++ b/drivers/staging/imx-drm/TODO
> @@ -10,7 +10,6 @@ TODO:
>  Missing features (not necessarily for moving out of staging):
>  
>  - Add KMS plane support for CRTC driver
> -- Add LDB (LVDS Display Bridge) support
>  - Add i.MX6 HDMI support
>  - Add support for IC (Image converter)
>  - Add support for CSI (CMOS Sensor interface)
> -- 
> 1.8.1.2
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
