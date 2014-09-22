Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaIVIHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:07:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39993 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaIVIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:07:43 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-a1-541fd8cd617c
Message-id: <541FD8CD.1060400@samsung.com>
Date: Mon, 22 Sep 2014 17:07:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] extcon: gpio: Convert the driver to use gpio desc API's
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
 <1410236078-11713-3-git-send-email-george.cherian@ti.com>
In-reply-to: <1410236078-11713-3-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkUPfsDfkQg82npCzmHznHatH/ZiGr
	xamDy1ktDvzZwWhx7tVKRovLu+awWTxZeIbJYun1i0wWtxtXsFlMmL6WxaJ17xF2i30X/rA6
	8HismbeG0eNyXy+Tx66dc1g9Vi7/wuaxaVUnm8eda3vYPHZ+b2D36NuyitHj+I3tTB6fN8kF
	cEVx2aSk5mSWpRbp2yVwZTS8ucZYcEus4u2+KUwNjIeEuhg5OSQETCQetX1kh7DFJC7cW8/W
	xcjFISSwlFHi5d+Z7DBF7dfvMEIkFjFKbH/znQnCec0osfbJfbAqXgEtiabZM1lBbBYBVYm2
	/1OZQGw2oPj+FzfYQGxRgTCJldOvsEDUC0r8mHwPzBYBqum/1A02lFlgEpPEtu19YAlhgQCJ
	zg2PoVY3Mkrc3/6DGSTBKeAmsXTBAbAiZgEdif2t09ggbHmJzWveMoM0SAhM5ZCYcPsiM8RJ
	AhLfJh8CauAASshKbDrADPGbpMTBFTdYJjCKzUJy1CwkY2chGbuAkXkVo2hqQXJBcVJ6kYle
	cWJucWleul5yfu4mRmCEn/73bMIOxnsHrA8xCnAwKvHw/miRDxFiTSwrrsw9xGgKdMVEZinR
	5HxgGskriTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	WbY6273dLku8pt30eLE7YCr/nTlnbzdPESmISDpoZSvTfeMj90kxp0lLwlvE9k+5fHtxn8SB
	K14mvRtSbNlyrRQKNxV1eG6Sf15rn/Tvwnkbv9+1ktnCx6wPcc5JiFU5WdB/4Ep1qljItjzx
	VN/uL3umpAqvKr+UvTJt1/9d4cw580IvsR1QYinOSDTUYi4qTgQAQm5VBusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd2zN+RDDG7/FrSYf+Qcq0X/m4Ws
	FqcOLme1OPBnB6PFuVcrGS0u75rDZvFk4Rkmi6XXLzJZ3G5cwWYxYfpaFovWvUfYLfZd+MPq
	wOOxZt4aRo/Lfb1MHrt2zmH1WLn8C5vHplWdbB53ru1h89j5vYHdo2/LKkaP4ze2M3l83iQX
	wBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S5
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjGj4c01xoJbYhVv901hamA8
	JNTFyMkhIWAi0X79DiOELSZx4d56ti5GLg4hgUWMEtvffGeCcF4zSqx9cp8dpIpXQEuiafZM
	VhCbRUBVou3/VCYQmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRYBq+i91gw1lFpjEJLFt
	ex9YQlggQKJzw2NGiG2NjBL3t/9gBklwCrhJLF1wAKyIWUBHYn/rNDYIW15i85q3zBMYBWYh
	WTILSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnj2dSOxhXNlgcYhTgYFTi
	4V3QJB8ixJpYVlyZe4hRgoNZSYT3aA5QiDclsbIqtSg/vqg0J7X4EKMpMAwmMkuJJucDU1te
	SbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGFqtvms95PMs+dLAL
	Xlt+gu19i0h6xN9XaxNnC83e4X/r7d5s0893TKpE79jYB+xrvnhs9punqw889+HkUi5m84lk
	um+VFFHjtOnfiTM9/w9/Vrm3yPwIK9PB5KWb5VhyX9t+v6H5eG1N2GSZ/+sW551Z5BF8daHH
	PVvry7cXXv7mOK3h6681tUosxRmJhlrMRcWJAMUvMfA1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

This patch removes 'gpio_active_low' field of struct gpio_extcon_data.
But, include/linux/extcon-gpio.h has the description of 'gpio_active_low' field.

Also,
This patch has not included the any description/comment of removing 'gpio_active_low'.

Also,
How to set 'FLAG_ACTIVE_LOW' bit for gpio when using platform data?
This patch don't call 'set_bit()' function to set FLAG_ACTIVE_LOW flag.

Thanks,
Chanwoo Choi

On 09/09/2014 01:14 PM, George Cherian wrote:
> Convert the driver to use gpiod_* API's.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/extcon/extcon-gpio.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 72f19a3..25269f6 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -33,8 +33,7 @@
>  
>  struct gpio_extcon_data {
>  	struct extcon_dev *edev;
> -	unsigned gpio;
> -	bool gpio_active_low;
> +	struct gpio_desc *gpiod;
>  	const char *state_on;
>  	const char *state_off;
>  	int irq;
> @@ -50,9 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
>  		container_of(to_delayed_work(work), struct gpio_extcon_data,
>  			     work);
>  
> -	state = gpio_get_value(data->gpio);
> -	if (data->gpio_active_low)
> -		state = !state;
> +	state = gpiod_get_value(data->gpiod);
>  	extcon_set_state(data->edev, state);
>  }
>  
> @@ -106,22 +103,21 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	}
>  	extcon_data->edev->name = pdata->name;
>  
> -	extcon_data->gpio = pdata->gpio;
> -	extcon_data->gpio_active_low = pdata->gpio_active_low;
> +	extcon_data->gpiod = gpio_to_desc(pdata->gpio);
>  	extcon_data->state_on = pdata->state_on;
>  	extcon_data->state_off = pdata->state_off;
>  	extcon_data->check_on_resume = pdata->check_on_resume;
>  	if (pdata->state_on && pdata->state_off)
>  		extcon_data->edev->print_state = extcon_gpio_print_state;
>  
> -	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
> +	ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
>  				    pdev->name);
>  	if (ret < 0)
>  		return ret;
>  
>  	if (pdata->debounce) {
> -		ret = gpio_set_debounce(extcon_data->gpio,
> -					pdata->debounce * 1000);
> +		ret = gpiod_set_debounce(extcon_data->gpiod,
> +					 pdata->debounce * 1000);
>  		if (ret < 0)
>  			extcon_data->debounce_jiffies =
>  				msecs_to_jiffies(pdata->debounce);
> @@ -133,7 +129,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  
>  	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>  
> -	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
> +	extcon_data->irq = gpiod_to_irq(extcon_data->gpiod);
>  	if (extcon_data->irq < 0)
>  		return extcon_data->irq;
>  
> 

