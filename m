Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBJQIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:08:49 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33091 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaBJQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:08:48 -0500
Date: Mon, 10 Feb 2014 16:08:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: jdelvare@suse.de, linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (max6650) Rename the device ids to contain the
 hwmon suffix
Message-ID: <20140210160842.GB26997@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392045953-26596-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the preparation of creating an mfd driver and then refactor this one into a
> platform driver in order to add some pinctrl functionality to the chip, it is
> necessary to start the series with this change so that the mfd driver can refer
> to the proper name in the subsequent change without making changes in more than
> one driver later.
> 
> This was a request from Lee Jones, the MFD subsystem maintainer.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/hwmon/max6650.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> index 0cafc39..3c36edc 100644
> --- a/drivers/hwmon/max6650.c
> +++ b/drivers/hwmon/max6650.c
> @@ -116,8 +116,8 @@ static struct max6650_data *max6650_update_device(struct device *dev);
>   */
>  
>  static const struct i2c_device_id max6650_id[] = {
> -	{ "max6650", 1 },
> -	{ "max6651", 4 },
> +	{ "max6650-hwmon", 1 },
> +	{ "max6651-hwmon", 4 },

Might be worth taking the opportunity to swap out these magic numbers
now.

>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, max6650_id);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
