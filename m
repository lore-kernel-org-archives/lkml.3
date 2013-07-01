Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3GAHMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:12:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3GAHM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:12:29 -0400
Message-ID: <1372662720.4971.16.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/4] imx-drm: imx-drm-core: Export
 imx_drm_encoder_get_mux_id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Mon, 01 Jul 2013 09:12:00 +0200
In-Reply-To: <1372438530-1819-1-git-send-email-festevam@gmail.com>
References: <1372438530-1819-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 28.06.2013, 13:55 -0300 schrieb Fabio Estevam:
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

All four
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

