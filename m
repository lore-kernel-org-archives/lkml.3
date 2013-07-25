Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3GYXrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:47:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24979 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:47:39 -0400
X-AuditID: cbfee691-b7fef6d000002d62-eb-51f1b919f4df
From: Jingoo Han <jg1.han@samsung.com>
To: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <1374757513-2253-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374757513-2253-3-git-send-email-maxime.ripard@free-electrons.com>
In-reply-to: <1374757513-2253-3-git-send-email-maxime.ripard@free-electrons.com>
Subject: Re: [PATCHv2 2/3] video: hx8357: Make IM pins optional
Date: Fri, 26 Jul 2013 08:47:36 +0900
Message-id: <002201ce8991$5785e8e0$0691baa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHCDYD0czrDmGulXhA3S6xfgAYWkQGXOKF4mYJNhGA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI13JnR8DDW58lLLouLaYyeLJz/Ws
	FpcXXmK12PT4GqvFib4PQO6uOWwWWzftZbZY9/AFk8WLph3sFuvn32Jz4PKYdXU2o8eTTRcZ
	PV5duMPisXlJvUffllWMHsdvbGfy+LxJLoA9issmJTUnsyy1SN8ugSvjd9ML9oIV/BXvzp1k
	bmC8zN3FyMkhIWAicaV1IzOELSZx4d56ti5GLg4hgWWMEudO/2WBKbr99zcTiC0kMJ1RYuY/
	M4iiX4wSLxs3s4Mk2ATUJL58OQxmiwikSRy9/ZIZpIhZYCKTxL23jawQHVMZJfrevADbxykQ
	IHGuuRusQ1jAXmLz7c9gcRYBVYl1yzvYQGxeAUuJP/NWMEHYghI/Jt8DO4lZQEti/c7jTBC2
	vMTmNW+hflCQ2HH2NSPEFVYSrf8uQtWISOx78Y4R5AgJgV4Oif5lt9gglglIfJt8CGgoB1BC
	VmLTAag5khIHV9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYoTE/MQdjPcPWB9iTAZaP5FZSjQ5H5gy8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaP6LKfzw0WSzE7vlxHXd1u3WXH0vZPlFn92+atEL
	o2/Wp4q5pbhfFDl1I8Tw/7ZalQZ11S2tcZceSs/59+GD27YHU9Q3Tjdsm2VisbohPZ6zoG3O
	HecO5uzQiGlT57/6zSR25k2AwIVjhqrH3hzrq93Pxz17/znDIibeBs9GDbGW2vazbu9SlViK
	MxINtZiLihMB7k385A8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQV3JnR8DDTY2iVl0XFvMZPHk53pW
	i8sLL7FabHp8jdXiRN8HIHfXHDaLrZv2Mluse/iCyeJF0w52i/Xzb7E5cHnMujqb0ePJpouM
	Hq8u3GHx2Lyk3qNvyypGj+M3tjN5fN4kF8Ae1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0n5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsI4x43fTC/aCFfwV786dZG5gvMzdxcjJISFgInH7728mCFtM4sK99WwgtpDAdEaJ
	mf/Muhi5gOxfjBIvGzezgyTYBNQkvnw5DGaLCKRJHL39khmkiFlgIpPEvbeNrBAdUxkl+t68
	YAap4hQIkDjX3A3WISxgL7H59mewOIuAqsS65R1g63gFLCX+zFvBBGELSvyYfI8FxGYW0JJY
	v/M4E4QtL7F5zVtmiFMVJHacfc0IcYWVROu/i1A1IhL7XrxjnMAoNAvJqFlIRs1CMmoWkpYF
	jCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYITyjOpHYwrGywOMQpwMCrx8Co4fQwUYk0s
	K67MPcQowcGsJMJ7qxcoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAZJdXEm9obGJmZGlk
	ZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwMXpzSUb/dT046wsZ1sFLNOejv
	7rBpj9X/+l143v7w1HeRN/4l68IMfV7s8ap4/u/9hMV7Jz4OdIor3/n9wqIFn6/+01aZ97DG
	S/OrkoaEmQRTj9VJ/rTd6so+Z7uOPNWwjG/9O2faRdHfbHVCeh1N8oZvV4rVVLfPC1BhrNnj
	ZcLg9+KkVaESS3FGoqEWc1FxIgBKcA+ibAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 10:05 PM, Maxime Ripard wrote:
> 
> The IM pins of the HX8357 controller are used to define the interface
> used to feed pixel stream to the LCD panel.
> 
> Most of the time, these pins are directly routed to either the ground or
> the VCC to set their values.
> 
> Remove the need to assign GPIOs to these pins when we are in such a case.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/video/backlight/hx8357.c | 53 +++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 22 deletions(-)
> 

[.....]

> +	if (of_find_property(spi->dev.of_node, "im-gpios", NULL)) {
> +		lcd->use_im_pins = 1;
> +
> +		for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
> +			lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
> +							    "im-gpios", i);
> +			if (lcd->im_pins[i] == -EPROBE_DEFER) {
> +				dev_info(&spi->dev, "GPIO requested is not here yet, deferring the
> probe\n");
> +				return -EPROBE_DEFER;
> +			}
> +			if (!gpio_is_valid(lcd->im_pins[i])) {
> +				dev_err(&spi->dev, "Missing dt property: im-gpios\n");
> +				return -EINVAL;
> +			}
> +
> +			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> +						    GPIOF_OUT_INIT_LOW,
> +						    "im_pins");
> +			if (ret) {
> +				dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> +					lcd->im_pins[i], ret);
> +				return -EINVAL;
> +			}
>  		}
> -
> -		ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> -					GPIOF_OUT_INIT_LOW, "im_pins");
> -		if (ret) {
> -			dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> -				lcd->im_pins[i], ret);
> -			return -EINVAL;
> -		}
> -	}
> +	} else
> +		lcd->use_im_pins = 0;

According to the 'Documentation/CodingStyle', braces are necessary as below.

	} else {
		lcd->use_im_pins = 0;
	}

Others look good.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


