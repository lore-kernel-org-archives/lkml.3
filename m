Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaJFUsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:48:03 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44152 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaJFUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:48:01 -0400
Date: Mon, 6 Oct 2014 21:47:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mfd: max77693: add haptic of_compatible in
 mfd_cell
Message-ID: <20141006204755.GB18035@lee--X1>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
 <1410972026-25189-3-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410972026-25189-3-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Jaewon Kim wrote:

> This patch add haptic of_compatible in order to use the haptic
> device driver using Devicetree.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max77693.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied for v3.19.

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index fbfed56..5b516fe 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
>  	{ .name = "max77693-charger", },
>  	{ .name = "max77693-flash", },
>  	{ .name = "max77693-muic", },
> -	{ .name = "max77693-haptic", },
> +	{
> +		.name = "max77693-haptic",
> +		.of_compatible = "maxim,max77693-haptic",
> +	},
>  };
>  
>  static const struct regmap_config max77693_regmap_config = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
