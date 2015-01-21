Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbAUQS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:18:28 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58568 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbAUQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:18:20 -0500
Date: Wed, 21 Jan 2015 16:18:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Support Opensource <support.opensource@diasemi.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] backlight: da9052_bl: terminate da9052_wled_ids array
 with empty element
Message-ID: <20150121161813.GF22024@x1>
References: <1421852768-29622-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421852768-29622-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Andrey Ryabinin wrote:

> Array of platform_device_id elements should be terminated
> with empty element.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  drivers/video/backlight/da9052_bl.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
> index d4bd74bd..b1943e7 100644
> --- a/drivers/video/backlight/da9052_bl.c
> +++ b/drivers/video/backlight/da9052_bl.c
> @@ -165,6 +165,7 @@ static struct platform_device_id da9052_wled_ids[] = {
>  		.name		= "da9052-wled3",
>  		.driver_data	= DA9052_TYPE_WLED3,
>  	},
> +	{ },
>  };
>  
>  static struct platform_driver da9052_wled_driver = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
