Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaHZQhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:37:38 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63467 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaHZQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:37:35 -0400
Date: Tue, 26 Aug 2014 17:37:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 02/18] backlight: adp8860: add blank line after
 declarations
Message-ID: <20140826163729.GV26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00ac01cfc12d$4f288b60$ed79a220$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00ac01cfc12d$4f288b60$ed79a220$%han@samsung.com>
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
>  drivers/video/backlight/adp8860_bl.c | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
> index be8d83deca7d..71147f4461b8 100644
> --- a/drivers/video/backlight/adp8860_bl.c
> +++ b/drivers/video/backlight/adp8860_bl.c
> @@ -181,6 +181,7 @@ static int adp8860_clr_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>  static void adp8860_led_work(struct work_struct *work)
>  {
>  	struct adp8860_led *led = container_of(work, struct adp8860_led, work);
> +
>  	adp8860_write(led->client, ADP8860_ISC1 - led->id + 1,
>  			 led->new_brightness >> 1);
>  }
> @@ -362,6 +363,7 @@ static int adp8860_bl_set(struct backlight_device *bl, int brightness)
>  static int adp8860_bl_update_status(struct backlight_device *bl)
>  {
>  	int brightness = bl->props.brightness;
> +
>  	if (bl->props.power != FB_BLANK_UNBLANK)
>  		brightness = 0;
>  
> @@ -499,6 +501,7 @@ static ssize_t adp8860_bl_l1_daylight_max_store(struct device *dev,
>  {
>  	struct adp8860_bl *data = dev_get_drvdata(dev);
>  	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
> +
>  	if (ret)
>  		return ret;
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
