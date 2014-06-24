Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaFXLRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:17:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9180 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFXLRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:17:15 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-cc-53a95e375fb0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Jeong'" <gshark.jeong@gmail.com>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Daniel Jeong'" <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403594330-15387-1-git-send-email-gshark.jeong@gmail.com>
 <1403594330-15387-2-git-send-email-gshark.jeong@gmail.com>
In-reply-to: <1403594330-15387-2-git-send-email-gshark.jeong@gmail.com>
Subject: Re: [RFC v3 1/2] backlight: add new tps611xx backlight driver
Date: Tue, 24 Jun 2014 20:17:11 +0900
Message-id: <000101cf8f9d$d83c1f50$88b45df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+PfNpoYgYfRHveTFW6iuNQA4lk7wAHoN/Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zA12LuJXBBg0bGS2O7pzIZLFn21Nm
	i/lHzrFaHPizg9Fi8u4uVovLCy+xWtz/epTRYmHbEhaLE30fgGK75rBZrHv4gsni7Z3pLBat
	e4+wW6yff4vNgc9j56y77B6bV2h5vLpwh8Vj06pONo871/awefRtWcXocfzGdiaPz5vkAjii
	uGxSUnMyy1KL9O0SuDIOXLzBUnDSq2LFuk9sDYz/LLoYOTkkBEwkThw6wgZhi0lcuLceyObi
	EBJYxihxZtNmRpiiS9ObmCAS0xklvnz7xwKSEBL4zSjROysVxGYTUJP48uUwO4gtIqAtsay/
	hx2kgVngLbPEz99z2CG6mxkljvRvZwKp4hRwl1jS/B2sQ1jATWLNp+VgU1kEVCU+rTkKVsMr
	YCsxf+9CKFtQ4sfke2A1zAJaEut3HmeCsOUlNq95y9zFyAF0qrrEo7+6EEcYSVx6eg+qRERi
	34t3jCA3SAhs4ZDYeQpml4DEt8mHWCB6ZSU2HWCG+FhS4uCKGywTGCVmIdk8C8nmWUg2z0Ky
	YgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkBQxcQfj/QPWhxiTgdZPZJYSTc4Hppi8
	knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDc2279
	W2UNz9Pqd0JimnsPr9rb2zWT5+GmZmvl77/DTA4/j6h8uINf5PGZkIQJoU8DdbJa1W4vy8s0
	2HzqiNDF3Iz9FgWhegsPLc0/LxOge3P6+3SWP3nLeSbUzTG4mfPb+/LRstvuE3QOlr5fllxx
	f8q541O7G9bG/u24sGle0cHtc07uPxZ7WomlOCPRUIu5qDgRAEPKoRknAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQV3zuJXBBvduWlgc3TmRyWLPtqfM
	FvOPnGO1OPBnB6PF5N1drBaXF15itbj/9SijxcK2JSwWJ/o+AMV2zWGzWPfwBZPF2zvTWSxa
	9x5ht1g//xabA5/Hzll32T02r9DyeHXhDovHplWdbB53ru1h8+jbsorR4/iN7UwenzfJBXBE
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdrqRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOHDxBkvBSa+KFes+sTUw/rPo
	YuTkkBAwkbg0vYkJwhaTuHBvPVsXIxeHkMB0Rokv3/6xgCSEBH4zSvTOSgWx2QTUJL58OcwO
	YosIaEss6+9hB2lgFnjLLPHz9xx2iO5mRokj/dvBxnIKuEssaf4O1iEs4Cax5tNysKksAqoS
	n9YcBavhFbCVmL93IZQtKPFj8j2wGmYBLYn1O48zQdjyEpvXvGXuYuQAOlVd4tFfXYgjjCQu
	Pb0HVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOAE9k9rBuLLB4hCjAAejEg8vg/+KYCHWxLLiytxDjBIczEoivCHhK4OFeFMSK6tSi/Lj
	i0pzUosPMZoCPTqRWUo0OR+YHPNK4g2NTcyMLI3MLIxMzM2VxHkPtFoHCgmkJ5akZqemFqQW
	wfQxcXBKNTBWXXeu1ZuUr7SRSy8z9RXT+lVxyQ8PL7GVnb1F8PsBdcPvbUVXGs63P4pdv8XC
	J+KyZ1fh5XqxBZwMtmwT5l7VMBaOt5LLZuW92LX5VNHslR/Ya+q+nd7DqWo57xZ/dFdSSMHF
	v2/zwx5W3RZgcwi2fvsvz03HZ/XN99astcnPp7sWXSv/fl2JpTgj0VCLuag4EQBm3+pOVgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2014 4:19 PM, Daniel Jeong wrote:
> 
> This driver a general version for tps611xx backlgiht chips of TI.

s/This driver a general/This driver is a general
-> "is" is missing.

> It supports tps61158, tps61161, tps61163 and tps61165 backlight driver
> based on EasyScale protocol(1-Wire Control Interface).
> 
> EasyScale
> EasyScale is a simple but flexible one pin interface to configure the current.
> The interface is based on a master-slave structure, where the master is
> typically a microcontroller or application processor and the IC is the slave.
> The advantage of EasyScale compared with other one pin interfaces is that
> its bit detection is in a large extent independent from the bit transmission rate.
> It can automatically detect bit rates between 1.7kBit/sec and up to 160kBit/sec.
> 
> EasyScale on TPS61163
> A command consists of 24 bits, including an 8-bit device address byte and a 16-bit data byte.
> All of the 24 bits should be transmitted together each time, and the LSB bit should be
> transmitted first. The device address byte A7(MSB)~A0(LSB) is fixed to 0x8F.
> The data byte includes 9 bits D8(MSB)~D0(LSB) for brightness information and an RFA bit.
> The RFA bit set to "1" indicates the Request for Acknowledge condition. The Acknowledge
> condition is only applied when the protocol is received correctly.
> Bit sream : D0-D8 | 0 | RFA | 00000 | A0-A7
> Please refer http://www.ti.com/lit/ds/symlink/tps61163.pdf for more details.
> 
> EasyScale on TPS61158/61/65
> A command consists of 16 bits, including an 8-bit device address byte and a 8-bit data byte.
> All of the 16 bits should be transmitted together each time, and the MSB bit should be
> transmitted first. The device address byte A7(MSB)~A0(LSB) is fixed (tps61158 0x58
> tps61161 and tps61165 0x72). The data byte includes an RFA bit.
> The RFA bit set to "1" indicates the Request for Acknowledge condition. The Acknowledge
> condition is only applied when the protocol is received correctly.
> Bit sream : A7-A0 | RFA | 00 | D4-D0
> Please refer the links below  for more details.

s/refer/refer to

> tps61158 : http://www.ti.com/lit/ds/symlink/tps61158.pdf
> tps61161 : http://www.ti.com.cn/cn/lit/ds/symlink/tps61161-q1.pdf
> tps61165 : http://www.ti.com/lit/ds/symlink/tps61165.pdf

These columns of the commit message are long.
Please keep 80 columns for the readability, if possible.

> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  drivers/video/backlight/Kconfig           |    7 +
>  drivers/video/backlight/Makefile          |    1 +
>  drivers/video/backlight/tps611xx_bl.c     |  494 +++++++++++++++++++++++++++++
>  include/linux/platform_data/tps611xx_bl.h |   31 ++
>  4 files changed, 533 insertions(+)
>  create mode 100644 drivers/video/backlight/tps611xx_bl.c
>  create mode 100644 include/linux/platform_data/tps611xx_bl.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 5a3eb2e..c779a85 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -418,6 +418,13 @@ config BACKLIGHT_TPS65217
>  	  If you have a Texas Instruments TPS65217 say Y to enable the
>  	  backlight driver.
> 
> +config BACKLIGHT_TPS611xx
> +	tristate "TPS611xx Backlight"
> +	depends on BACKLIGHT_CLASS_DEVICE && GPIOLIB
> +	help
> +	  This supports TI TPS61158,TPS61161, TPS61163 and TPS61165
> +	  backlight driver based on EasyScale Protocol.
> +
>  config BACKLIGHT_AS3711
>  	tristate "AS3711 Backlight"
>  	depends on BACKLIGHT_CLASS_DEVICE && MFD_AS3711
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index bb82002..44f1641 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -52,4 +52,5 @@ obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
>  obj-$(CONFIG_BACKLIGHT_SAHARA)		+= kb3886_bl.o
>  obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o
>  obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o
> +obj-$(CONFIG_BACKLIGHT_TPS611xx)	+= tps611xx_bl.o

Please add it in an alphabetical order as below.

+obj-$(CONFIG_BACKLIGHT_TPS611xx)	+= tps611xx_bl.o
 obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o

>  obj-$(CONFIG_BACKLIGHT_WM831X)		+= wm831x_bl.o
> diff --git a/drivers/video/backlight/tps611xx_bl.c b/drivers/video/backlight/tps611xx_bl.c
> new file mode 100644
> index 0000000..8dcc88a
> --- /dev/null
> +++ b/drivers/video/backlight/tps611xx_bl.c
> @@ -0,0 +1,494 @@

[...]

> +
> +static struct tps611xx_esdata tps611xx_info[] = {
> +	[TPS61158_ID] = {
> +			 .id = TPS61158_ID,
> +			 .name = "tps61158",
> +			 .addr = 0x5800,
> +			 .cmd = {
> +				 .seq = CMD_FORWARD,
> +				 .size = 16,
> +				 .brt_max = 31,
> +				 .brt_bmask = 0x1f,
> +				 .rfa_bmask = 0x80
> +				},

Please keep the standard for coding style as below.

	[TPS61158_ID] = {
		.id = TPS61158_ID,
		.name = "tps61158",
		.addr = 0x5800,
		.cmd = {
			 .seq = CMD_FORWARD,
			 .size = 16,
			 .brt_max = 31,
			 .brt_bmask = 0x1f,
			 .rfa_bmask = 0x80
		},


> +			 .time = {
> +				  .es_delay = 100000,
> +				  .es_det = 450000,
> +				  .start = 3500,
> +				  .eos = 3500,
> +				  .reset = 4,
> +				  .logic_1_low = 5000,
> +				  .logic_0_low = 15000,
> +				  .ackn = 900000,
> +				  .ack_poll = 2000
> +				},
> +			 },
> +
> +	[TPS61161_ID] = {
> +			 .id = TPS61161_ID,
> +			 .name = "tps61161",
> +			 .addr = 0x7200,
> +			 .cmd = {
> +				 .seq = CMD_FORWARD,
> +				 .size = 16,
> +				 .brt_max = 31,
> +				 .brt_bmask = 0x1f,
> +				 .rfa_bmask = 0x80
> +				},
> +			 .time = {
> +				  .es_delay = 120000,
> +				  .es_det = 280000,
> +				  .start = 2000,
> +				  .eos = 2000,
> +				  .reset = 3,
> +				  .logic_1_low = 3000,
> +				  .logic_0_low = 7000,
> +				  .ackn = 512000,
> +				  .ack_poll = 2000
> +				},
> +			 },
> +
> +	[TPS61163_ID] = {
> +			 .id = TPS61163_ID,
> +			 .name = "tps61163",
> +			 .addr = 0x8F0000,
> +			 .cmd = {
> +				 .seq = CMD_BACKWARD,
> +				 .size = 24,
> +				 .brt_max = 511,
> +				 .brt_bmask = 0x1ff,
> +				 .rfa_bmask = 0x400
> +				},
> +			 .time = {
> +				  .es_delay = 100000,
> +				  .es_det = 260000,
> +				  .start = 2000,
> +				  .eos = 2000,
> +				  .reset = 3,
> +				  .logic_1_low = 3000,
> +				  .logic_0_low = 7000,
> +				  .ackn = 512000,
> +				  .ack_poll = 2000
> +				},
> +			 },
> +
> +	[TPS61165_ID] = {
> +			 .id = TPS61165_ID,
> +			 .name = "tps61165",
> +			 .addr = 0x7200,
> +			 .cmd = {
> +				 .seq = CMD_FORWARD,
> +				 .size = 16,
> +				 .brt_max = 31,
> +				 .brt_bmask = 0x1f,
> +				 .rfa_bmask = 0x80
> +				},
> +			 .time = {
> +				  .es_delay = 120000,
> +				  .es_det = 280000,
> +				  .start = 4000,
> +				  .eos = 4000,
> +				  .reset = 3,
> +				  .logic_1_low = 3000,
> +				  .logic_0_low = 7000,
> +				  .ackn = 512000,
> +				  .ack_poll = 2000
> +				},
> +			 },
> +};

Same as above mentioned comment.

[...]

> +
> +static int tps611xx_bl_get_brightness(struct backlight_device *bl)
> +{
> +	return bl->props.brightness;
> +}
> +
> +static const struct backlight_ops tps611xx_bl_ops = {
> +	.update_status = tps611xx_bl_update_status,
> +	.get_brightness = tps611xx_bl_get_brightness,

Please don't add 'tps611xx_bl_get_brightness' callback function,
when it just returns 'props.brightness'.

Please refer to the following links.

  http://www.spinics.net/lists/arm-kernel/msg335952.html
  http://www.spinics.net/lists/arm-kernel/msg335951.html

[...]

> +
> +static struct platform_driver tps611xx_backlight_driver = {
> +	.driver = {
> +		   .name = TPS611XX_NAME,
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(tps611xx_backlight_of_match),
> +		   },

Please keep the coding style as below.

+	}

> +	.probe = tps611xx_backlight_probe,
> +	.remove = tps611xx_backlight_remove,
> +	.id_table = tps611xx_id_table,
> +};
> +
> +module_platform_driver(tps611xx_backlight_driver);
> +
> +MODULE_DESCRIPTION("EasyScale based tps611xx Backlight Driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:tps611xx_bl");
> diff --git a/include/linux/platform_data/tps611xx_bl.h b/include/linux/platform_data/tps611xx_bl.h
> new file mode 100644
> index 0000000..73d1f08
> --- /dev/null
> +++ b/include/linux/platform_data/tps611xx_bl.h
> @@ -0,0 +1,31 @@
> +/*
> + * Simple driver for Texas Instruments TPS61163a Backlight driver chip

s/TPS61163a/TPS611xx

> + * Copyright (C) 2014 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __TPS611XX_H
> +#define __TPS611XX_H
> +
> +#define TPS611XX_NAME "tps611xx_bl"
> +#define TPS61158_NAME "tps61158_bl"
> +#define TPS61161_NAME "tps61161_bl"
> +#define TPS61163_NAME "tps61163_bl"
> +#define TPS61165_NAME "tps61165_bl"
> +
> +/*
> + * struct tps61163a platform data

s/tps61163a/tps611xx

Best regards,
Jingoo Han

> + * @rfa_en : request for acknowledge
> + * @en_gpio_num : gpio number for en_pin
> + */
> +struct tps611xx_platform_data {
> +
> +	int rfa_en;
> +	unsigned int en_gpio_num;
> +};
> +
> +#endif /* __TPS611XX_H */
> --
> 1.7.9.5

