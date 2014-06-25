Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaFYWDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:03:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbaFYWC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:02:59 -0400
Date: Thu, 26 Jun 2014 00:02:55 +0200
From: Jean Delvare <jdelvare@suse.de>
To: "Julien D'Ascenzio" <jdascenzio@yahoo.fr>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (gpio-fan) Change name used in
 hwmon_device_register_with_groups
Message-ID: <20140626000255.1a5e2770@endymion.delvare>
In-Reply-To: <1403726431-18749-1-git-send-email-jdascenzio@yahoo.fr>
References: <1403726431-18749-1-git-send-email-jdascenzio@yahoo.fr>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 22:00:31 +0200, Julien D'Ascenzio wrote:
> Since commit 648cd48c9e566f53c5df30d79857e0937ae13b09
> The hwmon name attributes must not include '-' so the name must be
> rename from gpio-fan to gpio_fan
> 
> Signed-off-by: Julien D'Ascenzio <jdascenzio@yahoo.fr>
> ---
>  drivers/hwmon/gpio-fan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
> index 73181be..160ca00 100644
> --- a/drivers/hwmon/gpio-fan.c
> +++ b/drivers/hwmon/gpio-fan.c
> @@ -538,7 +538,7 @@ static int gpio_fan_probe(struct platform_device *pdev)
>  
>  	/* Make this driver part of hwmon class. */
>  	fan_data->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
> -						"gpio-fan", fan_data,
> +						"gpio_fan", fan_data,
>  						gpio_fan_groups);
>  	if (IS_ERR(fan_data->hwmon_dev))
>  		return PTR_ERR(fan_data->hwmon_dev);

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
