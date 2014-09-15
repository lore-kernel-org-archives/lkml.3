Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaIOGrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:47:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35513 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIOGrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:47:40 -0400
X-AuditID: cbfee68f-f797f6d000001173-f3-54168b8099aa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Jeong'" <gshark.jeong@gmail.com>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Daniel Jeong'" <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1409309174-1137-1-git-send-email-gshark.jeong@gmail.com>
In-reply-to: <1409309174-1137-1-git-send-email-gshark.jeong@gmail.com>
Subject: Re: [PATCH] backlight: add new lm3509 backlight driver
Date: Mon, 15 Sep 2014 15:47:27 +0900
Message-id: <02a901cfd0b0$ea0b62f0$be2228d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/DdnyJ6eD6yWjlRu6cpV+BE9lrnwNOVcZA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI92GbrEQg0VbWSyO7pzIZLFn21Nm
	i8m7u1gtLi+8xGpx/+tRRosTfR+A3F1z2CzWPXzBZLF+/i02B06PnbPusnu8unCHxePOtT1s
	Hn1bVjF6HL+xncnj8ya5ALYoLpuU1JzMstQifbsEroz3D74yFvwoqLj74y1zA+OcqC5GTg4J
	AROJCee+sEPYYhIX7q1n62Lk4hASWMYosetAMxtM0ferH9khEtMZJdoOr4Sq+s0oceJwL1g7
	m4CaxJcvh8FsEQFtiWX9PWA2s8AuJol1r31AbCEBV4nt728zgticAm4Sx079ZwGxhQXsJc7s
	mQVWzyKgKjH95g6wzbwCthJzPx5kgbAFJX5MvscCMVNLYv3O40wQtrzE5jVvmbsYOYAuVZd4
	9FcX4gQjib+7lrFClIhI7HvxjhHkZgmBv+wS9xuvskHsEpD4NvkQC0SvrMSmA8wQD0tKHFxx
	g2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kREt39Oxjv
	HrA+xCjAwajEwxt4XjhEiDWxrLgy9xCjKdBFE5mlRJPzgSkkryTe0NjMyMLUxNTYyNzSTEmc
	d6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEfmT6w0fm9Q1VRXJcRq1pgXZi1uv71D
	cXH8oTMmvz4qfMg+5/vBdXJI+6UnH3adu7j/mGZweNsCJs835W0rmKS/v7S3P8zutGOFnKfD
	n1kPn8wW29+80PLSzNeCvjcWNT9OjL8ZWb3kzsTjP6+f++KT/sju8pn+k24fvrlfPB97fuPk
	v2t3ifkrsRRnJBpqMRcVJwIAG+eeBekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd36brEQg2s7rC2O7pzIZLFn21Nm
	i8m7u1gtLi+8xGpx/+tRRosTfR+A3F1z2CzWPXzBZLF+/i02B06PnbPusnu8unCHxePOtT1s
	Hn1bVjF6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCzlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	7x98ZSz4UVBx98db5gbGOVFdjJwcEgImEt+vfmSHsMUkLtxbz9bFyMUhJDCdUaLt8Eoo5zej
	xInDvWBVbAJqEl++HAazRQS0JZb194DZzAK7mCTWvfYBsYUEXCW2v7/NCGJzCrhJHDv1nwXE
	FhawlzizZxZYPYuAqsT0mzvYQGxeAVuJuR8PskDYghI/Jt9jgZipJbF+53EmCFteYvOat8xd
	jBxAl6pLPPqrC3GCkcTfXctYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBKeOZ1I7GFc2WBxiFOBgVOLhXXFROESINbGsuDL3EKMEB7OS
	CG+gu1iIEG9KYmVValF+fFFpTmrxIUZToEcnMkuJJucD01peSbyhsYmZkaWRmYWRibm5kjjv
	gVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZGhZcXJqxaEf49z/qFrMKinWvuf+K487h7ieun91+X
	353FI8nq9/pjmFjgBMswFYbvXTePNZn8TYzT/tNU/aKlRuTHb/1bQZZGR594P+fbVljELFF1
	UIM7ueDNKS+Wn67zTzkldnt5nCy4EH7JM67WQ8wlp3X7dLl+dl72OcH5rbrrDrRutj+uxFKc
	kWioxVxUnAgAr4gd8DMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 29, 2014 7:46 PM, Daniel Jeong wrote:
> 
> This is a general driver for LM3509 backlgiht chip of TI.
> LM3509 is High Efficiency Boost for White LED's and/or OLED Displays with Dual
> Current Sinks. This driver supports OLED/White LED select, brightness control
> sub/main conrtorl.
> You can refer to the datasheet at http://www.ti.com/product/lm3509 for review.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  drivers/video/backlight/Kconfig     |    7 +
>  drivers/video/backlight/Makefile    |    1 +
>  drivers/video/backlight/lm3509_bl.c |  399 +++++++++++++++++++++++++++++++++++
>  3 files changed, 407 insertions(+)
>  create mode 100644 drivers/video/backlight/lm3509_bl.c
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 8d03924..9dc119e 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -366,6 +366,13 @@ config BACKLIGHT_AAT2870
>  	  If you have a AnalogicTech AAT2870 say Y to enable the
>  	  backlight driver.
> 
> +config BACKLIGHT_LM3509
> +	tristate "Backlight Driver for LM3509"
> +	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	select REGMAP_I2C
> +	help
> +	  This supports TI LM3509 Backlight Driver
> +
>  config BACKLIGHT_LM3630A
>  	tristate "Backlight Driver for LM3630A"
>  	depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index fcd50b73..c34ed98 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_BACKLIGHT_GPIO)		+= gpio_backlight.o
>  obj-$(CONFIG_BACKLIGHT_HP680)		+= hp680_bl.o
>  obj-$(CONFIG_BACKLIGHT_HP700)		+= jornada720_bl.o
>  obj-$(CONFIG_BACKLIGHT_IPAQ_MICRO)	+= ipaq_micro_bl.o
> +obj-$(CONFIG_BACKLIGHT_LM3509)		+= lm3509_bl.o
>  obj-$(CONFIG_BACKLIGHT_LM3533)		+= lm3533_bl.o
>  obj-$(CONFIG_BACKLIGHT_LM3630A)		+= lm3630a_bl.o
>  obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
> diff --git a/drivers/video/backlight/lm3509_bl.c b/drivers/video/backlight/lm3509_bl.c
> new file mode 100644
> index 0000000..4f4fb85
> --- /dev/null
> +++ b/drivers/video/backlight/lm3509_bl.c
> @@ -0,0 +1,399 @@
> +/*
> + * Simple driver for Texas Instruments LM3509 Backlight driver chip
> + * Copyright (C) 2014 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/backlight.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#define LM3509_NAME "lm3509"
> +
> +#define REG_GP	0x10
> +#define REG_BMAIN	0xa0
> +#define REG_BSUB	0xb0
> +#define REG_MAX		0xff

Please keep the same tab spaces for the readability as follows.

+#define REG_GP			0x10
+#define REG_BMAIN		0xa0
+#define REG_BSUB		0xb0
+#define REG_MAX			0xff

> +
> +#define LM3509_POR_BR_MAIN	0xe0
> +#define LM3509_POR_BR_SUB	0xe0
> +#define LM3509_MAX_BR		0xff

> +
> +enum lm3509_leds {
> +	BLED_BMAIN = 0,
> +	BLED_BSUB
> +};
> +
> +struct lm3509_chip {
> +	struct device *dev;
> +	struct backlight_device *bmain;
> +	struct backlight_device *bsub;
> +	struct regmap *regmap;
> +};
> +
> +/*
> + * enable main
> + * 0 : disables the main current sink and forces MAIN high impedence.
> + * 1 : enables the main current sink.
> + */
> +static ssize_t lm3509_bmain_enable_store(struct device *dev,
> +				      struct device_attribute *devAttr,
> +				      const char *buf, size_t size)
> +{
> +	struct lm3509_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int state;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &state);
> +	if (ret) {
> +		dev_err(pchip->dev, "input conversion fail\n");
> +		return ret;
> +	}
> +
> +	if (!state)
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x1, 0x0);
> +	else
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x1, 0x1);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +		return ret;
> +	}
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(main_enable, S_IWUSR, NULL, lm3509_bmain_enable_store);
> +
> +/*
> + * OLED mode control
> + * 0 : white led mode - main and sub current sinks are active
> + * 1 : OLED mode - sub current sink is idabled
> + */
> +static ssize_t lm3509_oled_mode_store(struct device *dev,
> +				      struct device_attribute *devAttr,
> +				      const char *buf, size_t size)
> +{
> +	struct lm3509_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int state;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &state);
> +	if (ret) {
> +		dev_err(pchip->dev, "input conversion fail\n");
> +		return ret;
> +	}
> +
> +	if (!state)
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x20, 0x00);
> +	else
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x20, 0x20);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +		return ret;
> +	}
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(oled_enable, S_IWUSR, NULL, lm3509_oled_mode_store);
> +
> +/*
> + * brightness rate of change
> + * set the rate of change of the LED current in to MAIN and SUB/FB
> + * in response to change in the contents of registers
> + * 0 - 51 us/step
> + * 1 - 13 ms/step
> + * 2 - 26 ms/step
> + * 3 - 52 ms/step
> + */
> +static ssize_t lm3509_rate_store(struct device *dev,
> +				      struct device_attribute *devAttr,
> +				      const char *buf, size_t size)
> +{
> +	struct lm3509_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int state;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &state);
> +	if (ret) {
> +		dev_err(pchip->dev, "input conversion fail\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_update_bits(pchip->regmap, REG_GP, 0x18, state << 3);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +		return ret;
> +	}
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(rate, S_IWUSR, NULL, lm3509_rate_store);
> +
> +/* update and get brightness */
> +static int lm3509_bmain_update_status(struct backlight_device *bl)
> +{
> +	struct lm3509_chip *pchip = bl_get_data(bl);
> +	int ret;
> +
> +	ret = regmap_write(pchip->regmap, REG_BMAIN, bl->props.brightness);
> +	if (ret < 0)
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +	return bl->props.brightness;
> +}
> +
> +static int lm3509_bmain_get_brightness(struct backlight_device *bl)
> +{
> +	return bl->props.brightness;
> +}
> +
> +static const struct backlight_ops lm3509_bmain_ops = {
> +	.options = BL_CORE_SUSPENDRESUME,
> +	.update_status = lm3509_bmain_update_status,
> +	.get_brightness = lm3509_bmain_get_brightness,

Please don't add 'lm3509_bmain_get_brightness' callback function,
when it just returns 'props.brightness'.

Please refer to the following links.

  http://www.spinics.net/lists/arm-kernel/msg335952.html
  http://www.spinics.net/lists/arm-kernel/msg335951.html

> +};
> +
> +/*
> + * enable sub
> + * 0 : disables the secondary current sink and forces SUB/FB high impedence.
> + * 1 : enables the secondary current sink.
> + */
> +static ssize_t lm3509_bsub_enable_store(struct device *dev,
> +				      struct device_attribute *devAttr,
> +				      const char *buf, size_t size)
> +{
> +	struct lm3509_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int state;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &state);
> +	if (ret) {
> +		dev_err(pchip->dev, "input conversion fail\n");
> +		return ret;
> +	}
> +
> +	if (!state)
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x2, 0x0);
> +	else
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x2, 0x2);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +		return ret;
> +	}
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(sub_enable, S_IWUSR, NULL, lm3509_bsub_enable_store);
> +
> +/*
> + * uni mode select
> + * 0 : allows the current into MAIN and SUB/FB to be independently controlled
> + *     via the bmain and bsub.
> + * 1 : disables the bsub register and causes the contents of bmain to set
> + *     the current in both the MAIN and SUB/FB current sinks.
> + */
> +static ssize_t lm3509_uni_mode_store(struct device *dev,
> +				      struct device_attribute *devAttr,
> +				      const char *buf, size_t size)
> +{
> +	struct lm3509_chip *pchip = dev_get_drvdata(dev);
> +	unsigned int state;
> +	ssize_t ret;
> +
> +	ret = kstrtouint(buf, 10, &state);
> +	if (ret) {
> +		dev_err(pchip->dev, "input conversion fail\n");
> +		return ret;
> +	}
> +
> +	if (!state)
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x4, 0x0);
> +	else
> +		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x4, 0x4);
> +	if (ret < 0) {
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +		return ret;
> +	}
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(uni_mode, S_IWUSR, NULL, lm3509_uni_mode_store);
> +
> +/* update and get brightness */
> +static int lm3509_bsub_update_status(struct backlight_device *bl)
> +{
> +	struct lm3509_chip *pchip = bl_get_data(bl);
> +	int ret;
> +
> +	ret = regmap_write(pchip->regmap, REG_BSUB, bl->props.brightness);
> +	if (ret < 0)
> +		dev_err(pchip->dev, "i2c access fail to register\n");
> +	return bl->props.brightness;
> +}
> +
> +static int lm3509_bsub_get_brightness(struct backlight_device *bl)
> +{
> +	return bl->props.brightness;
> +}
> +
> +static const struct backlight_ops lm3509_bsub_ops = {
> +	.options = BL_CORE_SUSPENDRESUME,
> +	.update_status = lm3509_bsub_update_status,
> +	.get_brightness = lm3509_bsub_get_brightness,
> +};

Ditto.

Please don't add 'lm3509_bsub_get_brightness' callback function,
when it just returns 'props.brightness'.

Best regards,
Jingoo Han

> +
> +static int lm3509_backlight_register(struct lm3509_chip *pchip,
> +				     enum lm3509_leds ledno)
> +{
> +	struct backlight_properties props;
> +
> +	props.type = BACKLIGHT_RAW;
> +	switch (ledno) {
> +	case BLED_BMAIN:
> +		props.brightness = LM3509_POR_BR_MAIN;
> +		props.max_brightness = LM3509_MAX_BR;
> +		pchip->bmain =
> +			devm_backlight_device_register(pchip->dev, "bmain",
> +				pchip->dev, pchip, &lm3509_bmain_ops, &props);
> +		if (IS_ERR(pchip->bmain))
> +			return -EIO;
> +		break;
> +	case BLED_BSUB:
> +		props.brightness = LM3509_POR_BR_SUB;
> +		props.max_brightness = LM3509_MAX_BR;
> +		pchip->bsub =
> +			devm_backlight_device_register(pchip->dev, "bsub",
> +				pchip->dev, pchip, &lm3509_bsub_ops, &props);
> +		if (IS_ERR(pchip->bsub))
> +			return -EIO;
> +		break;
> +	default:
> +		BUG();
> +	}
> +	return 0;
> +}
> +
> +static const struct regmap_config lm3509_regmap = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = REG_MAX,
> +};
> +
> +static int lm3509_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	struct lm3509_chip *pchip;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "fail : i2c functionality check\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	pchip = devm_kzalloc(&client->dev, sizeof(struct lm3509_chip),
> +			     GFP_KERNEL);
> +	if (!pchip)
> +		return -ENOMEM;
> +	pchip->dev = &client->dev;
> +
> +	pchip->regmap = devm_regmap_init_i2c(client, &lm3509_regmap);
> +	if (IS_ERR(pchip->regmap)) {
> +		dev_err(&client->dev, "fail : allocate register map\n");
> +		ret = PTR_ERR(pchip->regmap);
> +		return ret;
> +	}
> +	i2c_set_clientdata(client, pchip);
> +
> +	ret = lm3509_backlight_register(pchip, BLED_BMAIN);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = lm3509_backlight_register(pchip, BLED_BSUB);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_main_enable);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
> +	if (ret < 0)
> +		goto err_oled_enable;
> +
> +	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_rate);
> +	if (ret < 0)
> +		goto err_rate;
> +
> +	ret = device_create_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
> +	if (ret < 0)
> +		goto err_sub_enable;
> +
> +	ret = device_create_file(&(pchip->bsub->dev), &dev_attr_uni_mode);
> +	if (ret < 0)
> +		goto err_uni_mode;
> +
> +	return 0;
> +
> +err_uni_mode:
> +	device_remove_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
> +err_sub_enable:
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_rate);
> +err_rate:
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
> +err_oled_enable:
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_main_enable);
> +	dev_err(pchip->dev, "failed : add sysfs entries\n");
> +
> +	return ret;
> +}
> +
> +static int lm3509_remove(struct i2c_client *client)
> +{
> +	int ret;
> +	struct lm3509_chip *pchip = i2c_get_clientdata(client);
> +
> +	device_remove_file(&(pchip->bsub->dev), &dev_attr_uni_mode);
> +	device_remove_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_rate);
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
> +	device_remove_file(&(pchip->bmain->dev), &dev_attr_main_enable);
> +
> +	ret = regmap_write(pchip->regmap, REG_GP, 0x0);
> +	if (ret < 0)
> +		dev_err(pchip->dev, "i2c failed to access register\n");
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lm3509_id[] = {
> +	{LM3509_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lm3509_id);
> +
> +static struct i2c_driver lm3509_i2c_driver = {
> +	.driver = {
> +		.name = LM3509_NAME,
> +	},
> +	.probe = lm3509_probe,
> +	.remove = lm3509_remove,
> +	.id_table = lm3509_id,
> +};
> +
> +module_i2c_driver(lm3509_i2c_driver);
> +
> +MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3509");
> +MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5

