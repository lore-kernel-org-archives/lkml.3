Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaHSOGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:06:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaHSOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:05:59 -0400
Message-ID: <1408457139.2899.11.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Yannis Damigos <giannis.damigos@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2014 16:05:39 +0200
In-Reply-To: <1408456797-19437-1-git-send-email-giannis.damigos@gmail.com>
References: <20140819124112.GB7791@kroah.com>
	 <1408456797-19437-1-git-send-email-giannis.damigos@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 19.08.2014, 16:59 +0300 schrieb Yannis Damigos:
> This is a patch to the ipuv3-crtc.c file that fixes up two "lines
> over 80 characters" warnings found by the checkpatch.pl tool.
> 
> Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
> ---
>  drivers/staging/imx-drm/ipuv3-crtc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
> index 720868b..c4c6455 100644
> --- a/drivers/staging/imx-drm/ipuv3-crtc.c
> +++ b/drivers/staging/imx-drm/ipuv3-crtc.c
> @@ -201,9 +201,9 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
>  		return ret;
>  	}
>  
> -	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
> -				  0, 0, mode->hdisplay, mode->vdisplay,
> -				  x, y, mode->hdisplay, mode->vdisplay);
> +	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
> +			crtc->primary->fb, 0, 0, mode->hdisplay, mode->vdisplay,
> +			x, y, mode->hdisplay, mode->vdisplay);
>  }
>  
>  static void ipu_crtc_handle_pageflip(struct ipu_crtc *ipu_crtc)

This doesn't improve readability, though. Can we keep the alignment of
the x/y/width/height parameters?

> @@ -227,7 +227,8 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
>  
>  	if (ipu_crtc->newfb) {
>  		ipu_crtc->newfb = NULL;
> -		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
> +		ipu_plane_set_base(ipu_crtc->plane[0],
> +				ipu_crtc->base.primary->fb,
>  				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);
>  		ipu_crtc_handle_pageflip(ipu_crtc);
>  	}

regards
Philipp

