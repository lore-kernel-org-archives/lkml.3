Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaBKNdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:33:42 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50242 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:33:41 -0500
Date: Tue, 11 Feb 2014 14:33:39 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH 04/17] i2c: i2c-at91: deprecate class based instantiation
Message-ID: <20140211133338.GB1114@ldesroches-Latitude-E6320>
Mail-Followup-To: Wolfram Sang <wsa@the-dreams.de>,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
 <1392026654-5343-5-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392026654-5343-5-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:03:58AM +0100, Wolfram Sang wrote:
> Warn users that class based instantiation is going away soon in favour
> of more robust probing and faster bootup times.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks

> ---
> 
>  drivers/i2c/busses/i2c-at91.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 8edba9d..4babcdb 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -759,7 +759,7 @@ static int at91_twi_probe(struct platform_device *pdev)
>  	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
>  	i2c_set_adapdata(&dev->adapter, dev);
>  	dev->adapter.owner = THIS_MODULE;
> -	dev->adapter.class = I2C_CLASS_HWMON;
> +	dev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
>  	dev->adapter.algo = &at91_twi_algorithm;
>  	dev->adapter.dev.parent = dev->dev;
>  	dev->adapter.nr = pdev->id;
> -- 
> 1.8.5.1
> 
