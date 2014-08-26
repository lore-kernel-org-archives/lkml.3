Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaHZQeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:34:15 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34507 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaHZQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:34:14 -0400
Date: Tue, 26 Aug 2014 17:34:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 09/18] backlight: lm3639: remove unnecessary return
 statements
Message-ID: <20140826163407.GO26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b301cfc12d$a0831cf0$e18956d0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b301cfc12d$a0831cf0$e18956d0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: void function return statements are not generally useful
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/lm3639_bl.c | 2 --
>  1 file changed, 2 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
> index 5f36808d214f..cd50df5807ea 100644
> --- a/drivers/video/backlight/lm3639_bl.c
> +++ b/drivers/video/backlight/lm3639_bl.c
> @@ -254,7 +254,6 @@ static void lm3639_torch_brightness_set(struct led_classdev *cdev,
>  	return;
>  out:
>  	dev_err(pchip->dev, "i2c failed to access register\n");
> -	return;
>  }
>  
>  /* flash */
> @@ -293,7 +292,6 @@ static void lm3639_flash_brightness_set(struct led_classdev *cdev,
>  	return;
>  out:
>  	dev_err(pchip->dev, "i2c failed to access register\n");
> -	return;
>  }
>  
>  static const struct regmap_config lm3639_regmap = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
