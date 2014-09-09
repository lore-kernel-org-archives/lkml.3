Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaIIIPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:15:43 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56862 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaIIIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:15:41 -0400
Date: Tue, 9 Sep 2014 09:15:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v3 3/4] mfd: max77693: add haptic of_compatible in
 mfd_cell
Message-ID: <20140909081535.GI30307@lee--X1>
References: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
 <1409917702-17009-4-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409917702-17009-4-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Jaewon Kim wrote:

> This patch add haptic of_compatible in order to use the haptic
> device driver using Devicetree.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/mfd/max77693.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index fbfed56..03fd431 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
>  	{ .name = "max77693-charger", },
>  	{ .name = "max77693-flash", },
>  	{ .name = "max77693-muic", },
> -	{ .name = "max77693-haptic", },
> +	{
> +	  .name = "max77693-haptic",
> +	  .of_compatible = "maxim,max77693-haptic",
> +	},

Proper tabbing please.

>  };
>  
>  static const struct regmap_config max77693_regmap_config = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
