Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaHZQhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:37:13 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45330 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaHZQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:37:11 -0400
Date: Tue, 26 Aug 2014 17:37:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 03/18] backlight: adp8870: add blank line after
 declarations
Message-ID: <20140826163705.GU26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00ad01cfc12d$5b9e16d0$12da4470$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00ad01cfc12d$5b9e16d0$12da4470$%han@samsung.com>
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
>  drivers/video/backlight/adp8870_bl.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 251af4d38d86..037e43083343 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -144,6 +144,7 @@ static int adp8870_read(struct i2c_client *client, int reg, uint8_t *val)
>  static int adp8870_write(struct i2c_client *client, u8 reg, u8 val)
>  {
>  	int ret = i2c_smbus_write_byte_data(client, reg, val);
> +
>  	if (ret)
>  		dev_err(&client->dev, "failed to write\n");
>  
> @@ -195,6 +196,7 @@ static int adp8870_clr_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>  static void adp8870_led_work(struct work_struct *work)
>  {
>  	struct adp8870_led *led = container_of(work, struct adp8870_led, work);
> +
>  	adp8870_write(led->client, ADP8870_ISC1 + led->id - 1,
>  			 led->new_brightness >> 1);
>  }
> @@ -399,6 +401,7 @@ static int adp8870_bl_set(struct backlight_device *bl, int brightness)
>  static int adp8870_bl_update_status(struct backlight_device *bl)
>  {
>  	int brightness = bl->props.brightness;
> +
>  	if (bl->props.power != FB_BLANK_UNBLANK)
>  		brightness = 0;
>  
> @@ -649,6 +652,7 @@ static ssize_t adp8870_bl_l1_daylight_max_store(struct device *dev,
>  {
>  	struct adp8870_bl *data = dev_get_drvdata(dev);
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
