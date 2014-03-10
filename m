Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCJJLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:11:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33108 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaCJJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:11:00 -0400
X-AuditID: cbfee68f-b7f156d00000276c-1c-531d819f35bb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Jeong'" <gshark.jeong@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393838076-4559-1-git-send-email-gshark.jeong@gmail.com>
In-reply-to: <1393838076-4559-1-git-send-email-gshark.jeong@gmail.com>
Subject: Re: [PATCH] backlight: add new LP8860 backlight driver
Date: Mon, 10 Mar 2014 18:10:55 +0900
Message-id: <001b01cf3c40$a4b347e0$ee19d7a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac82wRegFGlWrUXBQCmZN3sO+qBY1gFe/2+g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zI935jbLBBu2PjSyO7pzIZDF5dxer
	xeWFl1gt7n89ymhxou8DkLtrDpvFuocvmCzWz7/F5sDhsXPWXXaPVxfusHjcubaHzaNvyypG
	j+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJVx+/MRpoIfixgr9rzTamBc2cjYxcjJISFgItF5
	+xgzhC0mceHeerYuRi4OIYFljBKr1n5hgSma9+0OVGIRo8SLX72MEM5vRok/ay6zg1SxCahJ
	fPlyGMwWEdCWWNbfww5SxCwwiUni+IWTrCAJIQFXiebLq4ESHBycAm4SP7cngoSFBewl3nx+
	B9bLIqAqMfPfDbDNvAK2Epu2zGOFsAUlfky+BxZnFtCSWL/zOBOELS+xec1bZpCREgLqEo/+
	6oKYIgJGErfv5UFUiEjse/EO7GQJgUYOiZ0H+xghVglIfJt8iAWiVVZi0wFoQEhKHFxxg2UC
	o8QsJItnIVk8C8niWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kREtP9OxjvHrA+
	xJgMtH4is5Rocj4wJeSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsb9gVdTNSM2Jrvu4k1aNOWQEcv1bcyfWecEhzHZbJKtt6udfNUmR8PLRiXq
	xaL1bZF1tw9yR547I8ngKTsjvXLRNrdUa7+Uwmcmr5eH7rt39O7VlaZ/N39K/faG5c/zDg3p
	NQsYzFvvurj0PrSasudxVtXtL12vc4QM3fT1xSWn5V58+ut45SQlluKMREMt5qLiRAAPXSiu
	/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd35jbLBBo3HtC2O7pzIZDF5dxer
	xeWFl1gt7n89ymhxou8DkLtrDpvFuocvmCzWz7/F5sDhsXPWXXaPVxfusHjcubaHzaNvyypG
	j+M3tjN5fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/bnI0wF
	PxYxVux5p9XAuLKRsYuRk0NCwERi3rc7bBC2mMSFe+uBbC4OIYFFjBIvfvUyQji/GSX+rLnM
	DlLFJqAm8eXLYTBbREBbYll/DztIEbPAJCaJ4xdOsoIkhARcJZovrwZKcHBwCrhJ/NyeCBIW
	FrCXePP5HVgvi4CqxMx/N1hAbF4BW4lNW+axQtiCEj8m3wOLMwtoSazfeZwJwpaX2LzmLTPI
	SAkBdYlHf3VBTBEBI4nb9/IgKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEJ4xn0jsYVzVYHGIU4GBU4uE98FYmWIg1say4MvcQowQHs5II
	b0acbLAQb0piZVVqUX58UWlOavEhxmSgPycyS4km5wOTWV5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MBp5ZM0UPblgY9KR2zH/NXX+GdecuiHovrtM078j
	Rl3lANevnJ3y97q5EmcZr2TdqXz71Lm5D3x+C2pfFrFmV+uRW70jYcar9dqt3k3vp/MJuCkp
	Lt62fE6i7lPVBduk/2w99Y+f/Z7Zwo1fXTreX0tYo37e+XvjtttNVx5HxHNHftXdZaxzmkeJ
	pTgj0VCLuag4EQAKzCG2XAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2014 6:15 PM, Daniel Jeong wrote:
> 

(+CC Bryan Wu, Lee Jones)

Please add Bryan Wu, Lee Jones to CC list, when you send
patches for backlight.

>  This patch adds LP8860 backlight device driver.
> LP8860 is a low EMI and High performance 4 channel LED Driver of TI.
> This device driver provide the way to control brightness and currnet

(+CC Bryan Wu, Lee Jones)

s/provide/provides
s/currnet/current

> of each channel and provide the way to write eeprom.

s/provide/provides

> To support dt structure, another patch file will be sent.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---

'To support dt structure, another patch file will be sent.' is
NOT appropriate for the commit message. So, please move it as below.
Then, this message will not be included to the commit message, when
this patch will be merged to maintainer's tree.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
To support dt structure, another patch file will be sent.


>  drivers/video/backlight/Kconfig         |    7 +
>  drivers/video/backlight/Makefile        |    1 +
>  drivers/video/backlight/lp8860_bl.c     |  528 +++++++++++++++++++++++++++++++
>  include/linux/platform_data/lp8860_bl.h |   54 ++++
>  4 files changed, 590 insertions(+)
>  create mode 100644 drivers/video/backlight/lp8860_bl.c
>  create mode 100644 include/linux/platform_data/lp8860_bl.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 5a3eb2e..908048f 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -397,6 +397,13 @@ config BACKLIGHT_LP8788
>  	help
>  	  This supports TI LP8788 backlight driver.
> 
> +config BACKLIGHT_LP8860
> +	tristate "Backlight Driver for LP8860"
> +	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	select REGMAP_I2C
> +	help
> +	  This supports TI LP8860 Backlight Driver
> +
>  config BACKLIGHT_OT200
>  	tristate "Backlight driver for ot200 visualisation device"
>  	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT && GPIO_CS5535
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index bb82002..cbc5ac3 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
>  obj-$(CONFIG_BACKLIGHT_LOCOMO)		+= locomolcd.o
>  obj-$(CONFIG_BACKLIGHT_LP855X)		+= lp855x_bl.o
>  obj-$(CONFIG_BACKLIGHT_LP8788)		+= lp8788_bl.o
> +obj-$(CONFIG_BACKLIGHT_LP8860)		+= lp8860_bl.o
>  obj-$(CONFIG_BACKLIGHT_LV5207LP)	+= lv5207lp.o
>  obj-$(CONFIG_BACKLIGHT_MAX8925)		+= max8925_bl.o
>  obj-$(CONFIG_BACKLIGHT_OMAP1)		+= omap1_bl.o
> diff --git a/drivers/video/backlight/lp8860_bl.c b/drivers/video/backlight/lp8860_bl.c
> new file mode 100644
> index 0000000..4712e84
> --- /dev/null
> +++ b/drivers/video/backlight/lp8860_bl.c
> @@ -0,0 +1,528 @@
> +/*
> +* Simple driver for Texas Instruments lp8860 Backlight driver chip
> +*
> +* Copyright (C) 2014 Texas Instruments
> +* Author: Daniel Jeong  <gshark.jeong@gmail.com>
> +*		  Ldd Mlp <ldd-mlp@list.ti.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +*/
> +#include <linux/module.h>

Please move this header in alphabetical order.

> +#include <linux/backlight.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/platform_data/lp8860_bl.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#define REG_CL0_BRT_H	0x00
> +#define REG_CL0_BRT_L	0x01
> +#define REG_CL0_I_H		0x02
> +#define REG_CL0_I_L		0x03
> +
> +#define REG_CL1_BRT_H	0x04
> +#define REG_CL1_BRT_L	0x05
> +#define REG_CL1_I		0x06
> +
> +#define REG_CL2_BRT_H	0x07
> +#define REG_CL2_BRT_L	0x08
> +#define REG_CL2_I		0x09
> +
> +#define REG_CL3_BRT_H	0x0a
> +#define REG_CL3_BRT_L	0x0b
> +#define REG_CL3_I		0x0c
> +
> +#define REG_CONF	0x0d
> +#define REG_STATUS	0x0e
> +#define REG_ID		0x12
> +
> +#define REG_ROM_CTRL	0x19
> +#define REG_ROM_UNLOCK	0x1a
> +#define REG_ROM_START	0x60
> +#define REG_ROM_END		0x78
> +
> +#define REG_EEPROM_START	0x60
> +#define REG_EEPROM_END		0x78
> +#define REG_MAX	0xFF
> +
> +struct lp8860_chip {
> +	struct device *dev;
> +	struct lp8860_platform_data *pdata;
> +	struct backlight_device *bled[LP8860_LED_MAX];
> +	struct regmap *regmap;
> +};
> +
> +/* brightness control */
> +static int lp8860_bled_update_status(struct backlight_device *bl,
> +				     enum lp8860_leds nsr)
> +{
> +	int ret = -EINVAL;
> +	struct lp8860_chip *pchip = bl_get_data(bl);
> +
> +	if (pchip->pdata->mode)
> +		return 0;
> +
> +	if (bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
> +		bl->props.brightness = 0;
> +
> +	switch (nsr) {
> +	case LP8860_LED0:
> +		ret = regmap_write(pchip->regmap,
> +				   REG_CL0_BRT_H, bl->props.brightness >> 8);
> +		ret |= regmap_write(pchip->regmap,
> +				    REG_CL0_BRT_L, bl->props.brightness & 0xff);
> +		break;
> +	case LP8860_LED1:
> +		ret = regmap_write(pchip->regmap,
> +				   REG_CL1_BRT_H,
> +				   (bl->props.brightness >> 8) & 0x1f);
> +		ret |=
> +		    regmap_write(pchip->regmap, REG_CL1_BRT_L,
> +				 bl->props.brightness & 0xff);
> +		break;
> +	case LP8860_LED2:
> +		ret = regmap_write(pchip->regmap,
> +				   REG_CL2_BRT_H,
> +				   (bl->props.brightness >> 8) & 0x1f);
> +		ret |=
> +		    regmap_write(pchip->regmap, REG_CL2_BRT_L,
> +				 bl->props.brightness & 0xff);
> +		break;
> +	case LP8860_LED3:
> +		ret = regmap_write(pchip->regmap,
> +				   REG_CL3_BRT_H,
> +				   (bl->props.brightness >> 8) & 0x1f);
> +		ret |=
> +		    regmap_write(pchip->regmap, REG_CL3_BRT_L,
> +				 bl->props.brightness & 0xff);
> +		break;
> +	default:
> +		BUG();
> +	}
> +	if (ret < 0)
> +		dev_err(pchip->dev, "fail : i2c access to register.\n");
> +	else
> +		ret = bl->props.brightness;
> +
> +	return ret;
> +}
> +
> +static int lp8860_bled_get_brightness(struct backlight_device *bl,
> +				      enum lp8860_leds nsr)
> +{
> +	struct lp8860_chip *pchip = bl_get_data(bl);
> +	unsigned int rval_h, rval_l;
> +	int ret = -EINVAL;
> +
> +	switch (nsr) {
> +	case LP8860_LED0:
> +		ret = regmap_read(pchip->regmap, REG_CL0_BRT_H, &rval_h);
> +		ret |= regmap_read(pchip->regmap, REG_CL0_BRT_L, &rval_l);
> +		break;
> +	case LP8860_LED1:
> +		ret = regmap_read(pchip->regmap, REG_CL1_BRT_H, &rval_h);
> +		ret |= regmap_read(pchip->regmap, REG_CL1_BRT_L, &rval_l);
> +		break;
> +	case LP8860_LED2:
> +		ret = regmap_read(pchip->regmap, REG_CL2_BRT_H, &rval_h);
> +		ret |= regmap_read(pchip->regmap, REG_CL2_BRT_L, &rval_l);
> +		break;
> +	case LP8860_LED3:
> +		ret = regmap_read(pchip->regmap, REG_CL3_BRT_H, &rval_h);
> +		ret |= regmap_read(pchip->regmap, REG_CL3_BRT_L, &rval_l);
> +		break;
> +	default:
> +		BUG();
> +	}
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "fail : i2c access to register.\n");
> +		return ret;
> +	}
> +	bl->props.brightness = (rval_h << 8) | rval_l;
> +	return bl->props.brightness;
> +}
> +
> +static int lp8860_update_status_bled0(struct backlight_device *bl)
> +{
> +	return lp8860_bled_update_status(bl, LP8860_LED0);
> +}
> +
> +static int lp8860_get_brightness_bled0(struct backlight_device *bl)
> +{
> +	return lp8860_bled_get_brightness(bl, LP8860_LED0);
> +}
> +
> +static int lp8860_update_status_bled1(struct backlight_device *bl)
> +{
> +	return lp8860_bled_update_status(bl, LP8860_LED1);
> +}
> +
> +static int lp8860_get_brightness_bled1(struct backlight_device *bl)
> +{
> +	return lp8860_bled_get_brightness(bl, LP8860_LED1);
> +}
> +
> +static int lp8860_update_status_bled2(struct backlight_device *bl)
> +{
> +	return lp8860_bled_update_status(bl, LP8860_LED2);
> +}
> +
> +static int lp8860_get_brightness_bled2(struct backlight_device *bl)
> +{
> +	return lp8860_bled_get_brightness(bl, LP8860_LED2);
> +}
> +
> +static int lp8860_update_status_bled3(struct backlight_device *bl)
> +{
> +	return lp8860_bled_update_status(bl, LP8860_LED3);
> +}
> +
> +static int lp8860_get_brightness_bled3(struct backlight_device *bl)
> +{
> +	return lp8860_bled_get_brightness(bl, LP8860_LED3);
> +}
> +
> +#define lp8860_bled_ops(_id)\
> +{\
> +	.options = BL_CORE_SUSPENDRESUME,\
> +	.update_status = lp8860_update_status_bled##_id,\
> +	.get_brightness = lp8860_get_brightness_bled##_id,\
> +}
> +
> +static const struct backlight_ops lp8860_bled_ops[LP8860_LED_MAX] = {
> +	[LP8860_LED0] = lp8860_bled_ops(0),
> +	[LP8860_LED1] = lp8860_bled_ops(1),
> +	[LP8860_LED2] = lp8860_bled_ops(2),
> +	[LP8860_LED3] = lp8860_bled_ops(3),
> +};
> +
> +/* current control */
> +static int lp8860_set_current(struct device *dev,
> +			      const char *buf, enum lp8860_leds nsr)
> +{
> +	struct lp8860_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int ival;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &ival);
> +	if (ret)
> +		return ret;
> +
> +	switch (nsr) {
> +	case LP8860_LED0:
> +		ival = min_t(unsigned int, ival, LP8860_LED0_BR_MAX);
> +		ret = regmap_write(pchip->regmap, REG_CL0_I_H, ival >> 8);
> +		ret |= regmap_write(pchip->regmap, REG_CL0_I_L, ival & 0xff);
> +		break;
> +	case LP8860_LED1:
> +		ival = min_t(unsigned int, ival, LP8860_LED1_BR_MAX);
> +		ret = regmap_write(pchip->regmap, REG_CL1_I, ival & 0xff);
> +		break;
> +	case LP8860_LED2:
> +		ival = min_t(unsigned int, ival, LP8860_LED2_BR_MAX);
> +		ret = regmap_write(pchip->regmap, REG_CL2_I, ival & 0xff);
> +		break;
> +	case LP8860_LED3:
> +		ival = min_t(unsigned int, ival, LP8860_LED3_BR_MAX);
> +		ret = regmap_write(pchip->regmap, REG_CL3_I, ival & 0xff);
> +		break;
> +	default:
> +		BUG();
> +	}
> +	if (ret < 0)
> +		dev_err(pchip->dev, "fail : i2c access error.\n");
> +
> +	return ret;
> +}
> +
> +static ssize_t lp8860_current_store_bled0(struct device *dev,
> +					  struct device_attribute *devAttr,
> +					  const char *buf, size_t size)
> +{
> +	int ret;
> +
> +	ret = lp8860_set_current(dev, buf, LP8860_LED0);
> +	if (ret < 0)
> +		return ret;
> +	return size;
> +}
> +
> +static ssize_t lp8860_current_store_bled1(struct device *dev,
> +					  struct device_attribute *devAttr,
> +					  const char *buf, size_t size)
> +{
> +	int ret;
> +
> +	ret = lp8860_set_current(dev, buf, LP8860_LED1);
> +	if (ret < 0)
> +		return ret;
> +	return size;
> +}
> +
> +static ssize_t lp8860_current_store_bled2(struct device *dev,
> +					  struct device_attribute *devAttr,
> +					  const char *buf, size_t size)
> +{
> +	int ret;
> +
> +	ret = lp8860_set_current(dev, buf, LP8860_LED2);
> +	if (ret < 0)
> +		return ret;
> +	return size;
> +}
> +
> +static ssize_t lp8860_current_store_bled3(struct device *dev,
> +					  struct device_attribute *devAttr,
> +					  const char *buf, size_t size)
> +{
> +	int ret;
> +
> +	ret = lp8860_set_current(dev, buf, LP8860_LED3);
> +	if (ret < 0)
> +		return ret;
> +	return size;
> +}
> +
> +#define lp8860_attr(_name, _show, _store)\
> +{\
> +	.attr = {\
> +		.name = _name,\
> +		.mode = S_IWUSR,\
> +	},\
> +	.show = _show,\
> +	.store = _store,\
> +}
> +
> +static struct device_attribute lp8860_dev_attr[LP8860_LED_MAX] = {
> +	[LP8860_LED0] = lp8860_attr("current", NULL,
> +				    lp8860_current_store_bled0),
> +	[LP8860_LED1] = lp8860_attr("current", NULL,
> +				    lp8860_current_store_bled1),
> +	[LP8860_LED2] = lp8860_attr("current", NULL,
> +				    lp8860_current_store_bled2),
> +	[LP8860_LED3] = lp8860_attr("current", NULL,
> +				    lp8860_current_store_bled3),
> +};
> +
> +/*
> + * eeprom write and readback to check.
> + * eeprom register range is from 60h to 78h
> + * buffer value to write data [reg] [data]
> + * e.g) to change the register 0x60 value to 0xff
> + *      buffer value should be 60 ff
> + */
> +static ssize_t lp8860_eeprom_store(struct device *dev,
> +				   struct device_attribute *devAttr,
> +				   const char *buf, size_t size)
> +{
> +	struct lp8860_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int reg, data, rval;
> +	char *tok;
> +	int ret;
> +
> +	/* register no. */
> +	tok = strsep((char **)&buf, " ,\n");
> +	if (tok == NULL)
> +		goto err_input;
> +	ret = kstrtouint(tok, 16, &reg);
> +	if (ret)
> +		goto err_input;
> +
> +	/* register value */
> +	tok = strsep((char **)&buf, " ,\n");
> +	if (tok == NULL)
> +		goto err_input;
> +	ret = kstrtouint(tok, 16, &data);
> +	if (ret)
> +		goto err_input;
> +	/*
> +	 * EEPROM Programming sequence
> +	 *    (program data permanently from registers to NVM)
> +	 * 1. Unlock EEPROM by writing
> +	 *    the unlock codes to register 1Ah(08, BA, EF)
> +	 * 2. Write data to EEPROM registers (address 60h...78h)
> +	 * 3. Write EE_PROG to 1 in address 19h. (02h to address 19h)
> +	 * 4. Wait 100ms

If possible, please add the reason why 100ms is necessary.
100ms is very huge delay.

> +	 * 5. Write EE_PROG to 0 in address 19h. (00h to address 19h)
> +	 */
> +	if (reg < REG_EEPROM_START || reg > REG_EEPROM_END || data > 0xff)
> +		goto err_input;
> +	ret = regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0x08);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0xba);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0xef);
> +	ret |= regmap_write(pchip->regmap, reg, data);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_CTRL, 0x02);
> +	msleep(100);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_CTRL, 0x00);
> +	if (ret < 0)
> +		goto err_i2c;
> +
> +	/* read back */
> +	ret = regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0x08);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0xba);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_UNLOCK, 0xef);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_CTRL, 0x01);
> +	msleep(100);
> +	ret |= regmap_write(pchip->regmap, REG_ROM_CTRL, 0x00);
> +	ret |= regmap_read(pchip->regmap, reg, &rval);
> +	if (ret < 0)
> +		goto err_i2c;
> +	if (rval != data)
> +		dev_err(pchip->dev, "fail : eeprom did not change.\n");
> +
> +	return size;
> +
> +err_i2c:
> +	dev_err(pchip->dev, "fail : i2c access error.\n");
> +	return ret;
> +
> +err_input:
> +	dev_err(pchip->dev, "fail : input fail.\n");
> +	return -EINVAL;
> +}
> +
> +static DEVICE_ATTR(eeprom, S_IWUSR, NULL, lp8860_eeprom_store);
> +
> +/* backlight register and remove */
> +static char *lp8860_bled_name[LP8860_LED_MAX] = {
> +	[LP8860_LED0] = "bled0",
> +	[LP8860_LED1] = "bled1",
> +	[LP8860_LED2] = "bled2",
> +	[LP8860_LED3] = "bled3",
> +};
> +
> +static int lp8860_backlight_remove(struct lp8860_chip *pchip)
> +{
> +	int icnt;
> +
> +	device_remove_file(&(pchip->bled[0]->dev), &dev_attr_eeprom);
> +	for (icnt = LP8860_LED0; icnt < LP8860_LED_MAX; icnt++) {
> +		if (pchip->bled[icnt]) {
> +			backlight_device_unregister(pchip->bled[icnt]);
> +			device_remove_file(&(pchip->bled[icnt]->dev),
> +					   &lp8860_dev_attr[icnt]);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int lp8860_backlight_registers(struct lp8860_chip *pchip)
> +{
> +	struct backlight_properties props;
> +	struct lp8860_platform_data *pdata = pchip->pdata;
> +	int icnt, ret;
> +
> +	props.type = BACKLIGHT_RAW;
> +	for (icnt = LP8860_LED0; icnt < LP8860_LED_MAX; icnt++) {
> +		props.max_brightness = pdata->max_brt[icnt];
> +		pchip->bled[icnt] =
> +		    backlight_device_register(lp8860_bled_name[icnt],

devm_* functions will make the code simpler.
Thus, please use devm_backlight_device_register(), instead of
backlight_device_register().

> +					      pchip->dev, pchip,
> +					      &lp8860_bled_ops[icnt], &props);
> +		if (IS_ERR(pchip->bled[icnt])) {
> +			dev_err(pchip->dev, "fail : backlight register.\n");
> +			ret = PTR_ERR(pchip->bled[icnt]);
> +			goto err_out;
> +		}
> +
> +		ret = device_create_file(&(pchip->bled[icnt]->dev),
> +					 &lp8860_dev_attr[icnt]);
> +		if (ret < 0) {
> +			dev_err(pchip->dev, "fail : to add sysfs entries.\n");
> +			goto err_out;
> +		}
> +	}
> +	/* access eeprom */
> +	ret = device_create_file(&(pchip->bled[LP8860_LED0]->dev),
> +				 &dev_attr_eeprom);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "fail : to add sysfs entries.\n");
> +		goto err_out;
> +	}
> +	return 0;
> +
> +err_out:
> +	lp8860_backlight_remove(pchip);
> +	return ret;
> +}
> +
> +static const struct regmap_config lp8860_regmap = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = REG_MAX,
> +};
> +
> +static int lp8860_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct lp8860_chip *pchip;
> +	struct lp8860_platform_data *pdata = dev_get_platdata(&client->dev);
> +	int ret, icnt;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "fail : i2c functionality check.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	pchip = devm_kzalloc(&client->dev,
> +			     sizeof(struct lp8860_chip), GFP_KERNEL);
> +	if (!pchip)
> +		return -ENOMEM;
> +	pchip->dev = &client->dev;
> +
> +	pchip->regmap = devm_regmap_init_i2c(client, &lp8860_regmap);
> +	if (IS_ERR(pchip->regmap)) {
> +		ret = PTR_ERR(pchip->regmap);
> +		dev_err(pchip->dev, "fail : allocate i2c register map.\n");
> +		return ret;
> +	}
> +
> +	if (pdata == NULL) {
> +		pdata = devm_kzalloc(pchip->dev,
> +				     sizeof(struct lp8860_platform_data),
> +				     GFP_KERNEL);
> +		if (pdata == NULL)
> +			return -ENOMEM;
> +		pdata->max_brt[LP8860_LED0] = 65535;
> +		for (icnt = LP8860_LED1; icnt < LP8860_LED_MAX; icnt++)
> +			pdata->max_brt[icnt] = 8191;
> +		pchip->pdata = pdata;
> +	} else {
> +		pchip->pdata = pdata;
> +	}
> +	i2c_set_clientdata(client, pchip);
> +	ret = lp8860_backlight_registers(pchip);
> +	return ret;
> +}
> +
> +static int lp8860_remove(struct i2c_client *client)
> +{
> +	return lp8860_backlight_remove(i2c_get_clientdata(client));
> +}
> +
> +static const struct i2c_device_id lp8860_id[] = {
> +	{LP8860_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lp8860_id);
> +static struct i2c_driver lp8860_i2c_driver = {
> +	.driver = {
> +		   .name = LP8860_NAME,
> +		   },

Fix the indent style as below.

 +	   },

> +	.probe = lp8860_probe,
> +	.remove = lp8860_remove,
> +	.id_table = lp8860_id,
> +};
> +
> +module_i2c_driver(lp8860_i2c_driver);
> +
> +MODULE_DESCRIPTION("Texas Instruments LP8860 Backlight Driver");
> +MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
> +MODULE_AUTHOR("Ldd Mlp <ldd-mlp@list.ti.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/platform_data/lp8860_bl.h b/include/linux/platform_data/lp8860_bl.h
> new file mode 100644
> index 0000000..61bd0f5
> --- /dev/null
> +++ b/include/linux/platform_data/lp8860_bl.h
> @@ -0,0 +1,54 @@
> +/*
> + * Simple driver for Texas Instruments LM3642 LED Flash driver chip
> + * Copyright (C) 2014 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __LINUX_LP8860_H
> +#define __LINUX_LP8860_H

Prefix 'LINUX' looks redundant.
Please replace '__LINUX_LP8860_H' with '__LP8860_H'.

If the datasheet of 'lp8860' is not closed, please let us
know where the datasheet is. It would be helpful for reviewing
your patch.

Best regards,
Jingoo Han

> +
> +#define LP8860_NAME "lp8860"
> +#define LP8860_ADDR 0x2d
> +
> +#define LP8860_LED0_BR_MAX 65535
> +#define LP8860_LED1_BR_MAX 8191
> +#define LP8860_LED2_BR_MAX 8191
> +#define LP8860_LED3_BR_MAX 8191
> +
> +#define LP8860_LED0_I_MAX 4095
> +#define LP8860_LED1_I_MAX 255
> +#define LP8860_LED2_I_MAX 255
> +#define LP8860_LED3_I_MAX 255
> +
> +enum lp8860_leds {
> +	LP8860_LED0 = 0,
> +	LP8860_LED1,
> +	LP8860_LED2,
> +	LP8860_LED3,
> +	LP8860_LED_MAX
> +};
> +
> +enum lp8860_ctrl_mode {
> +	LP8860_CTRL_I2C = 0,
> +	LP8860_CTRL_I2C_PWM,
> +};
> +
> +/* struct lp8860 platform data
> + * @mode : control mode
> + * @max_brt : maximum brightness.
> + *		LED0 0 ~ 65535
> + *		LED1 0 ~ 8191
> + *		LED2 0 ~ 8191
> + *		LED3 0 ~ 8191
> + */
> +struct lp8860_platform_data {
> +
> +	enum lp8860_ctrl_mode mode;
> +	int max_brt[LP8860_LED_MAX];
> +};
> +
> +#endif /* __LINUX_LP8860_H */
> --
> 1.7.9.5

