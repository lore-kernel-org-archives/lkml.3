Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaHZQdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:33:25 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65056 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaHZQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:33:24 -0400
Date: Tue, 26 Aug 2014 17:33:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 11/18] backlight: lp855x: add blank line after
 declarations
Message-ID: <20140826163318.GM26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b501cfc12d$b5a1c280$20e54780$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b501cfc12d$b5a1c280$20e54780$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/lp855x_bl.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index dcdd5443efcf..25fb8e3d75b1 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -268,6 +268,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
>  
>  	} else if (lp->mode == REGISTER_BASED) {
>  		u8 val = bl->props.brightness;
> +
>  		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
>  	}
>  
> @@ -308,6 +309,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
>  				struct device_attribute *attr, char *buf)
>  {
>  	struct lp855x *lp = dev_get_drvdata(dev);
> +
>  	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
