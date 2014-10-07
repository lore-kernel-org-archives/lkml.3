Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaJGJP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:15:56 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:47130 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaJGJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:15:54 -0400
Date: Tue, 7 Oct 2014 10:15:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RESEND v5 2/3] mfd: max77693: add haptic of_compatible in
 mfd_cell
Message-ID: <20141007091548.GO25331@lee--X1>
References: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
 <1412145838-7563-3-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412145838-7563-3-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014, Jaewon Kim wrote:

> This patch add haptic of_compatible in order to use the haptic
> device driver using Devicetree.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/max77693.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied, thanks.

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
