Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbaJ2PpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:45:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147AbaJ2PmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:08 -0400
Date: Wed, 29 Oct 2014 17:25:33 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Gaston Gonzalez <gascoar@gmail.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: imx-drm Fix checkpatch warning
Message-ID: <20141029092533.GA5886@kroah.com>
References: <1413427044-9980-1-git-send-email-gascoar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413427044-9980-1-git-send-email-gascoar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 11:37:24PM -0300, Gaston Gonzalez wrote:
> Fix line over 80 characters in imx-tve.c
> 
> Signed-off-by: Gaston Gonzalez <gascoar@gmail.com>
> ---
>  drivers/staging/imx-drm/imx-tve.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
> index 3e8b0a1..a46905f 100644
> --- a/drivers/staging/imx-drm/imx-tve.c
> +++ b/drivers/staging/imx-drm/imx-tve.c
> @@ -665,7 +665,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
>  
>  	ret = regmap_read(tve->regmap, TVE_COM_CONF_REG, &val);
>  	if (ret < 0) {
> -		dev_err(dev, "failed to read configuration register: %d\n", ret);
> +		dev_err(dev, "failed to read configuration register: %d\n",
> +			ret);
>  		return ret;
>  	}
>  	if (val != 0x00100000) {

Does not apply :(
