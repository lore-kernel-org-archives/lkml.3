Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaJHW6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaJHW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:58:39 -0400
Date: Wed, 8 Oct 2014 15:58:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rene Kolarik <rene.kolarik@gmail.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: staging: imx-drm driver cleanup
Message-ID: <20141008225839.GA10226@kroah.com>
References: <1412793288-30811-1-git-send-email-rene.kolarik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412793288-30811-1-git-send-email-rene.kolarik@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 08:34:48PM +0200, Rene Kolarik wrote:
> Wrapping two too long lines in two files of the imx-drm driver.
> 
> Signed-off-by: Rene Kolarik <rene.kolarik@gmail.com>
> ---
>  drivers/staging/imx-drm/imx-drm-core.c | 3 ++-
>  drivers/staging/imx-drm/imx-tve.c      | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 9cb222e..9d1f861 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -632,7 +632,8 @@ static int imx_drm_platform_probe(struct platform_device *pdev)
>  				continue;
>  			}
>  
> -			component_match_add(&pdev->dev, &match, compare_of, remote);
> +			component_match_add(&pdev->dev, &match, compare_of,
> +				remote);

Please line this up with the ( character on the line above.

thanks,

greg k-h
