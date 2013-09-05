Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab3IEClx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:41:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317Ab3IEClv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:41:51 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-12-5227ef6da697
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 2/6] backlight: lm3630: apply chip revision
Date: Thu, 05 Sep 2013 11:41:49 +0900
Message-id: <002301cea9e1$787ff2f0$697fd8d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAACumA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zY93c9+pBBtd/G1rMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tigum5TUnMyy1CJ9uwSujMV737AWXGxhqlh6exl7A+PUa4xdjJwcEgImEo1LmpggbDGJC/fW
	s3UxcnEICSxjlOg6fZkNpuhtWwcTRGIRo8S+Z39YIZxfjBInTl9nBaliE1CT+PLlMHsXIweH
	iIC+RFuLBkgNs8BWRonNH3eD1QgJ2EqcXzIbbCqngJ3Epx97wc4QFrCWeHttCpjNIqAqceT9
	XLB6XqD6e5ffsEHYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWSvhIC6xKO/uiBhEQEjibMn
	TrFBlIhI7HvxjhHkHgmBj+wS6x+8gNolIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9C
	snkWks2zkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkhifuYLx/wPoQYzLQ+onM
	UqLJ+cAUkFcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRlmv9UujJi2SPV5zsdb8SP3awOQF3MwPnJz2ha6xVttd9UGIOWfDwcjMt089XrH5au0R
	MFLcN7ez7b2VwLXcF3veeF99xbzpsfqnFUvXButel5ZKOXz7e2rWnekSC+/xfL3OxLSl+OkC
	w3+Ca5988tarvzYzYb5DDttM/YPndTZni33PFQ/uC1RiKc5INNRiLipOBAAuDOjg9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd3c9+pBBjfWaVrMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDuU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmL975hLbjYwlSx9PYy9gbG
	qdcYuxg5OSQETCTetnUwQdhiEhfurWfrYuTiEBJYxCix79kfVgjnF6PEidPXWUGq2ATUJL58
	OczexcjBISKgL9HWogFSwyywlVFi88fdYDVCArYS55fMZgOxOQXsJD792Au2TVjAWuLttSlg
	NouAqsSR93PB6nmB6u9dfsMGYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqC
	hEUEjCTOnjjFBlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzhBPJPewbiqweIQowAHoxIPb4OxepAQa2JZcWXuIUYJDmYlEV6LlUAh3pTE
	yqrUovz4otKc1OJDjMlAj05klhJNzgcmr7ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYKz3rS6tVWr7cjvYIOGx0pS/97+f13zl+4DBLOimnv6cu26KOu91
	pvsu0Iy9uP/Q8lL19GMbOctX75h2zijpZ+b3boaiZZZvJHMOyz3U/9emfCs4zTFrgSVrbVRd
	784TXEe+HluySHo5w9PnAf3J8zvVb/3tF+kSWVZ7/1jXTV3nOaJ89n1u5UosxRmJhlrMRcWJ
	AM9qlrlUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LM3630 chip was revised by TI and chip name was also changed to LM3630A.
And register map, default values and initial sequences are changed.
The files, lm3630_bl.{c,h} are replaced by lm3630a_bl.{c,h}
You can find more information about LM3630A(datasheet, evm etc)
at http://www.ti.com/product/lm3630a

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/Kconfig          |    6 +-
 drivers/video/backlight/Makefile         |    2 +-
 drivers/video/backlight/lm3630_bl.c      |  475 -----------------------------
 drivers/video/backlight/lm3630a_bl.c     |  483 ++++++++++++++++++++++++++++++
 include/linux/platform_data/lm3630_bl.h  |   57 ----
 include/linux/platform_data/lm3630a_bl.h |   65 ++++
 6 files changed, 552 insertions(+), 536 deletions(-)
 delete mode 100644 drivers/video/backlight/lm3630_bl.c
 create mode 100644 drivers/video/backlight/lm3630a_bl.c
 delete mode 100644 include/linux/platform_data/lm3630_bl.h
 create mode 100644 include/linux/platform_data/lm3630a_bl.h

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index a65dd06..5a3eb2e 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -368,12 +368,12 @@ config BACKLIGHT_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  backlight driver.
 
-config BACKLIGHT_LM3630
-	tristate "Backlight Driver for LM3630"
+config BACKLIGHT_LM3630A
+	tristate "Backlight Driver for LM3630A"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select REGMAP_I2C
 	help
-	  This supports TI LM3630 Backlight Driver
+	  This supports TI LM3630A Backlight Driver
 
 config BACKLIGHT_LM3639
 	tristate "Backlight Driver for LM3639"
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 38e1bab..bb82002 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_BACKLIGHT_GPIO)		+= gpio_backlight.o
 obj-$(CONFIG_BACKLIGHT_HP680)		+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_HP700)		+= jornada720_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3533)		+= lm3533_bl.o
-obj-$(CONFIG_BACKLIGHT_LM3630)		+= lm3630_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3630A)		+= lm3630a_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)		+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_LP855X)		+= lp855x_bl.o
diff --git a/drivers/video/backlight/lm3630_bl.c b/drivers/video/backlight/lm3630_bl.c
deleted file mode 100644
index 76a62e9..0000000
--- a/drivers/video/backlight/lm3630_bl.c
+++ /dev/null
@@ -1,475 +0,0 @@
-/*
-* Simple driver for Texas Instruments LM3630 Backlight driver chip
-* Copyright (C) 2012 Texas Instruments
-*
-* This program is free software; you can redistribute it and/or modify
-* it under the terms of the GNU General Public License version 2 as
-* published by the Free Software Foundation.
-*
-*/
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <linux/backlight.h>
-#include <linux/err.h>
-#include <linux/delay.h>
-#include <linux/uaccess.h>
-#include <linux/interrupt.h>
-#include <linux/regmap.h>
-#include <linux/platform_data/lm3630_bl.h>
-
-#define REG_CTRL	0x00
-#define REG_CONFIG	0x01
-#define REG_BRT_A	0x03
-#define REG_BRT_B	0x04
-#define REG_INT_STATUS	0x09
-#define REG_INT_EN	0x0A
-#define REG_FAULT	0x0B
-#define REG_PWM_OUTLOW	0x12
-#define REG_PWM_OUTHIGH	0x13
-#define REG_MAX		0x1F
-
-#define INT_DEBOUNCE_MSEC	10
-
-enum lm3630_leds {
-	BLED_ALL = 0,
-	BLED_1,
-	BLED_2
-};
-
-static const char * const bled_name[] = {
-	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
-	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
-	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
-};
-
-struct lm3630_chip_data {
-	struct device *dev;
-	struct delayed_work work;
-	int irq;
-	struct workqueue_struct *irqthread;
-	struct lm3630_platform_data *pdata;
-	struct backlight_device *bled1;
-	struct backlight_device *bled2;
-	struct regmap *regmap;
-};
-
-/* initialize chip */
-static int lm3630_chip_init(struct lm3630_chip_data *pchip)
-{
-	int ret;
-	unsigned int reg_val;
-	struct lm3630_platform_data *pdata = pchip->pdata;
-
-	/*pwm control */
-	reg_val = ((pdata->pwm_active & 0x01) << 2) | (pdata->pwm_ctrl & 0x03);
-	ret = regmap_update_bits(pchip->regmap, REG_CONFIG, 0x07, reg_val);
-	if (ret < 0)
-		goto out;
-
-	/* bank control */
-	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1) |
-			(pdata->bank_a_ctrl & 0x07);
-	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x07, reg_val);
-	if (ret < 0)
-		goto out;
-
-	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-	if (ret < 0)
-		goto out;
-
-	/* set initial brightness */
-	if (pdata->bank_a_ctrl != BANK_A_CTRL_DISABLE) {
-		ret = regmap_write(pchip->regmap,
-				   REG_BRT_A, pdata->init_brt_led1);
-		if (ret < 0)
-			goto out;
-	}
-
-	if (pdata->bank_b_ctrl != BANK_B_CTRL_DISABLE) {
-		ret = regmap_write(pchip->regmap,
-				   REG_BRT_B, pdata->init_brt_led2);
-		if (ret < 0)
-			goto out;
-	}
-	return ret;
-
-out:
-	dev_err(pchip->dev, "i2c failed to access register\n");
-	return ret;
-}
-
-/* interrupt handling */
-static void lm3630_delayed_func(struct work_struct *work)
-{
-	int ret;
-	unsigned int reg_val;
-	struct lm3630_chip_data *pchip;
-
-	pchip = container_of(work, struct lm3630_chip_data, work.work);
-
-	ret = regmap_read(pchip->regmap, REG_INT_STATUS, &reg_val);
-	if (ret < 0) {
-		dev_err(pchip->dev,
-			"i2c failed to access REG_INT_STATUS Register\n");
-		return;
-	}
-
-	dev_info(pchip->dev, "REG_INT_STATUS Register is 0x%x\n", reg_val);
-}
-
-static irqreturn_t lm3630_isr_func(int irq, void *chip)
-{
-	int ret;
-	struct lm3630_chip_data *pchip = chip;
-	unsigned long delay = msecs_to_jiffies(INT_DEBOUNCE_MSEC);
-
-	queue_delayed_work(pchip->irqthread, &pchip->work, delay);
-
-	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-	if (ret < 0)
-		goto out;
-
-	return IRQ_HANDLED;
-out:
-	dev_err(pchip->dev, "i2c failed to access register\n");
-	return IRQ_HANDLED;
-}
-
-static int lm3630_intr_config(struct lm3630_chip_data *pchip)
-{
-	INIT_DELAYED_WORK(&pchip->work, lm3630_delayed_func);
-	pchip->irqthread = create_singlethread_workqueue("lm3630-irqthd");
-	if (!pchip->irqthread) {
-		dev_err(pchip->dev, "create irq thread fail...\n");
-		return -1;
-	}
-	if (request_threaded_irq
-	    (pchip->irq, NULL, lm3630_isr_func,
-	     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "lm3630_irq", pchip)) {
-		dev_err(pchip->dev, "request threaded irq fail..\n");
-		return -1;
-	}
-	return 0;
-}
-
-static bool
-set_intensity(struct backlight_device *bl, struct lm3630_chip_data *pchip)
-{
-	if (!pchip->pdata->pwm_set_intensity)
-		return false;
-	pchip->pdata->pwm_set_intensity(bl->props.brightness - 1,
-					pchip->pdata->pwm_period);
-	return true;
-}
-
-/* update and get brightness */
-static int lm3630_bank_a_update_status(struct backlight_device *bl)
-{
-	int ret;
-	struct lm3630_chip_data *pchip = bl_get_data(bl);
-	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
-
-	/* brightness 0 means disable */
-	if (!bl->props.brightness) {
-		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x04, 0x00);
-		if (ret < 0)
-			goto out;
-		return bl->props.brightness;
-	}
-
-	/* pwm control */
-	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (!set_intensity(bl, pchip))
-			dev_err(pchip->dev, "No pwm control func. in plat-data\n");
-	} else {
-
-		/* i2c control */
-		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-		if (ret < 0)
-			goto out;
-		mdelay(1);
-		ret = regmap_write(pchip->regmap,
-				   REG_BRT_A, bl->props.brightness - 1);
-		if (ret < 0)
-			goto out;
-	}
-	return bl->props.brightness;
-out:
-	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
-	return bl->props.brightness;
-}
-
-static int lm3630_bank_a_get_brightness(struct backlight_device *bl)
-{
-	unsigned int reg_val;
-	int brightness, ret;
-	struct lm3630_chip_data *pchip = bl_get_data(bl);
-	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
-
-	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = reg_val & 0x01;
-		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = ((brightness << 8) | reg_val) + 1;
-	} else {
-		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-		if (ret < 0)
-			goto out;
-		mdelay(1);
-		ret = regmap_read(pchip->regmap, REG_BRT_A, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = reg_val + 1;
-	}
-	bl->props.brightness = brightness;
-	return bl->props.brightness;
-out:
-	dev_err(pchip->dev, "i2c failed to access register\n");
-	return 0;
-}
-
-static const struct backlight_ops lm3630_bank_a_ops = {
-	.options = BL_CORE_SUSPENDRESUME,
-	.update_status = lm3630_bank_a_update_status,
-	.get_brightness = lm3630_bank_a_get_brightness,
-};
-
-static int lm3630_bank_b_update_status(struct backlight_device *bl)
-{
-	int ret;
-	struct lm3630_chip_data *pchip = bl_get_data(bl);
-	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
-
-	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (!set_intensity(bl, pchip))
-			dev_err(pchip->dev,
-				"no pwm control func. in plat-data\n");
-	} else {
-		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-		if (ret < 0)
-			goto out;
-		mdelay(1);
-		ret = regmap_write(pchip->regmap,
-				   REG_BRT_B, bl->props.brightness - 1);
-	}
-	return bl->props.brightness;
-out:
-	dev_err(pchip->dev, "i2c failed to access register\n");
-	return bl->props.brightness;
-}
-
-static int lm3630_bank_b_get_brightness(struct backlight_device *bl)
-{
-	unsigned int reg_val;
-	int brightness, ret;
-	struct lm3630_chip_data *pchip = bl_get_data(bl);
-	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
-
-	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = reg_val & 0x01;
-		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = ((brightness << 8) | reg_val) + 1;
-	} else {
-		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
-		if (ret < 0)
-			goto out;
-		mdelay(1);
-		ret = regmap_read(pchip->regmap, REG_BRT_B, &reg_val);
-		if (ret < 0)
-			goto out;
-		brightness = reg_val + 1;
-	}
-	bl->props.brightness = brightness;
-
-	return bl->props.brightness;
-out:
-	dev_err(pchip->dev, "i2c failed to access register\n");
-	return bl->props.brightness;
-}
-
-static const struct backlight_ops lm3630_bank_b_ops = {
-	.options = BL_CORE_SUSPENDRESUME,
-	.update_status = lm3630_bank_b_update_status,
-	.get_brightness = lm3630_bank_b_get_brightness,
-};
-
-static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
-				     enum lm3630_leds ledno)
-{
-	const char *name = bled_name[ledno];
-	struct backlight_properties props;
-	struct lm3630_platform_data *pdata = pchip->pdata;
-
-	props.type = BACKLIGHT_RAW;
-	switch (ledno) {
-	case BLED_1:
-	case BLED_ALL:
-		props.brightness = pdata->init_brt_led1;
-		props.max_brightness = pdata->max_brt_led1;
-		pchip->bled1 =
-		    backlight_device_register(name, pchip->dev, pchip,
-					      &lm3630_bank_a_ops, &props);
-		if (IS_ERR(pchip->bled1))
-			return PTR_ERR(pchip->bled1);
-		break;
-	case BLED_2:
-		props.brightness = pdata->init_brt_led2;
-		props.max_brightness = pdata->max_brt_led2;
-		pchip->bled2 =
-		    backlight_device_register(name, pchip->dev, pchip,
-					      &lm3630_bank_b_ops, &props);
-		if (IS_ERR(pchip->bled2))
-			return PTR_ERR(pchip->bled2);
-		break;
-	}
-	return 0;
-}
-
-static void lm3630_backlight_unregister(struct lm3630_chip_data *pchip)
-{
-	if (pchip->bled1)
-		backlight_device_unregister(pchip->bled1);
-	if (pchip->bled2)
-		backlight_device_unregister(pchip->bled2);
-}
-
-static const struct regmap_config lm3630_regmap = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = REG_MAX,
-};
-
-static int lm3630_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
-{
-	struct lm3630_platform_data *pdata = client->dev.platform_data;
-	struct lm3630_chip_data *pchip;
-	int ret;
-
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		dev_err(&client->dev, "fail : i2c functionality check...\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (pdata == NULL) {
-		dev_err(&client->dev, "fail : no platform data.\n");
-		return -ENODATA;
-	}
-
-	pchip = devm_kzalloc(&client->dev, sizeof(struct lm3630_chip_data),
-			     GFP_KERNEL);
-	if (!pchip)
-		return -ENOMEM;
-	pchip->pdata = pdata;
-	pchip->dev = &client->dev;
-
-	pchip->regmap = devm_regmap_init_i2c(client, &lm3630_regmap);
-	if (IS_ERR(pchip->regmap)) {
-		ret = PTR_ERR(pchip->regmap);
-		dev_err(&client->dev, "fail : allocate register map: %d\n",
-			ret);
-		return ret;
-	}
-	i2c_set_clientdata(client, pchip);
-
-	/* chip initialize */
-	ret = lm3630_chip_init(pchip);
-	if (ret < 0) {
-		dev_err(&client->dev, "fail : init chip\n");
-		goto err_chip_init;
-	}
-
-	switch (pdata->bank_a_ctrl) {
-	case BANK_A_CTRL_ALL:
-		ret = lm3630_backlight_register(pchip, BLED_ALL);
-		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
-		break;
-	case BANK_A_CTRL_LED1:
-		ret = lm3630_backlight_register(pchip, BLED_1);
-		break;
-	case BANK_A_CTRL_LED2:
-		ret = lm3630_backlight_register(pchip, BLED_2);
-		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
-		break;
-	default:
-		break;
-	}
-
-	if (ret < 0)
-		goto err_bl_reg;
-
-	if (pdata->bank_b_ctrl && pchip->bled2 == NULL) {
-		ret = lm3630_backlight_register(pchip, BLED_2);
-		if (ret < 0)
-			goto err_bl_reg;
-	}
-
-	/* interrupt enable  : irq 0 is not allowed for lm3630 */
-	pchip->irq = client->irq;
-	if (pchip->irq)
-		lm3630_intr_config(pchip);
-
-	dev_info(&client->dev, "LM3630 backlight register OK.\n");
-	return 0;
-
-err_bl_reg:
-	dev_err(&client->dev, "fail : backlight register.\n");
-	lm3630_backlight_unregister(pchip);
-err_chip_init:
-	return ret;
-}
-
-static int lm3630_remove(struct i2c_client *client)
-{
-	int ret;
-	struct lm3630_chip_data *pchip = i2c_get_clientdata(client);
-
-	ret = regmap_write(pchip->regmap, REG_BRT_A, 0);
-	if (ret < 0)
-		dev_err(pchip->dev, "i2c failed to access register\n");
-
-	ret = regmap_write(pchip->regmap, REG_BRT_B, 0);
-	if (ret < 0)
-		dev_err(pchip->dev, "i2c failed to access register\n");
-
-	lm3630_backlight_unregister(pchip);
-	if (pchip->irq) {
-		free_irq(pchip->irq, pchip);
-		flush_workqueue(pchip->irqthread);
-		destroy_workqueue(pchip->irqthread);
-	}
-	return 0;
-}
-
-static const struct i2c_device_id lm3630_id[] = {
-	{LM3630_NAME, 0},
-	{}
-};
-
-MODULE_DEVICE_TABLE(i2c, lm3630_id);
-
-static struct i2c_driver lm3630_i2c_driver = {
-	.driver = {
-		   .name = LM3630_NAME,
-		   },
-	.probe = lm3630_probe,
-	.remove = lm3630_remove,
-	.id_table = lm3630_id,
-};
-
-module_i2c_driver(lm3630_i2c_driver);
-
-MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3630");
-MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
-MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
new file mode 100644
index 0000000..cf40cc8
--- /dev/null
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -0,0 +1,483 @@
+/*
+* Simple driver for Texas Instruments LM3630A Backlight driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+*/
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/pwm.h>
+#include <linux/platform_data/lm3630a_bl.h>
+
+#define REG_CTRL	0x00
+#define REG_BOOST	0x02
+#define REG_CONFIG	0x01
+#define REG_BRT_A	0x03
+#define REG_BRT_B	0x04
+#define REG_I_A		0x05
+#define REG_I_B		0x06
+#define REG_INT_STATUS	0x09
+#define REG_INT_EN	0x0A
+#define REG_FAULT	0x0B
+#define REG_PWM_OUTLOW	0x12
+#define REG_PWM_OUTHIGH	0x13
+#define REG_MAX		0x1F
+
+#define INT_DEBOUNCE_MSEC	10
+struct lm3630a_chip {
+	struct device *dev;
+	struct delayed_work work;
+
+	int irq;
+	struct workqueue_struct *irqthread;
+	struct lm3630a_platform_data *pdata;
+	struct backlight_device *bleda;
+	struct backlight_device *bledb;
+	struct regmap *regmap;
+	struct pwm_device *pwmd;
+};
+
+/* i2c access */
+static int lm3630a_read(struct lm3630a_chip *pchip, unsigned int reg)
+{
+	int rval;
+	unsigned int reg_val;
+
+	rval = regmap_read(pchip->regmap, reg, &reg_val);
+	if (rval < 0)
+		return rval;
+	return reg_val & 0xFF;
+}
+
+static int lm3630a_write(struct lm3630a_chip *pchip,
+			 unsigned int reg, unsigned int data)
+{
+	return regmap_write(pchip->regmap, reg, data);
+}
+
+static int lm3630a_update(struct lm3630a_chip *pchip,
+			  unsigned int reg, unsigned int mask,
+			  unsigned int data)
+{
+	return regmap_update_bits(pchip->regmap, reg, mask, data);
+}
+
+/* initialize chip */
+static int lm3630a_chip_init(struct lm3630a_chip *pchip)
+{
+	int rval;
+	struct lm3630a_platform_data *pdata = pchip->pdata;
+
+	usleep_range(1000, 2000);
+	/* set Filter Strength Register */
+	rval = lm3630a_write(pchip, 0x50, 0x03);
+	/* set Cofig. register */
+	rval |= lm3630a_update(pchip, REG_CONFIG, 0x07, pdata->pwm_ctrl);
+	/* set boost control */
+	rval |= lm3630a_write(pchip, REG_BOOST, 0x38);
+	/* set current A */
+	rval |= lm3630a_update(pchip, REG_I_A, 0x1F, 0x1F);
+	/* set current B */
+	rval |= lm3630a_write(pchip, REG_I_B, 0x1F);
+	/* set control */
+	rval |=
+	    lm3630a_write(pchip, REG_CTRL, pdata->leda_ctrl | pdata->ledb_ctrl);
+	usleep_range(1000, 2000);
+	/* set brightness A and B */
+	rval |= lm3630a_write(pchip, REG_BRT_A, pdata->leda_init_brt);
+	rval |= lm3630a_write(pchip, REG_BRT_B, pdata->ledb_init_brt);
+
+	if (rval < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+	return rval;
+}
+
+/* interrupt handling */
+static void lm3630a_delayed_func(struct work_struct *work)
+{
+	unsigned int rval;
+	struct lm3630a_chip *pchip;
+
+	pchip = container_of(work, struct lm3630a_chip, work.work);
+
+	rval = lm3630a_read(pchip, REG_INT_STATUS);
+	if (rval < 0) {
+		dev_err(pchip->dev,
+			"i2c failed to access REG_INT_STATUS Register\n");
+		return;
+	}
+
+	dev_info(pchip->dev, "REG_INT_STATUS Register is 0x%x\n", rval);
+}
+
+static irqreturn_t lm3630a_isr_func(int irq, void *chip)
+{
+	int rval;
+	struct lm3630a_chip *pchip = chip;
+	unsigned long delay = msecs_to_jiffies(INT_DEBOUNCE_MSEC);
+
+	queue_delayed_work(pchip->irqthread, &pchip->work, delay);
+
+	rval = lm3630a_update(pchip, REG_CTRL, 0x80, 0x00);
+	if (rval < 0) {
+		dev_err(pchip->dev, "i2c failed to access register\n");
+		return IRQ_NONE;
+	}
+	return IRQ_HANDLED;
+}
+
+static int lm3630a_intr_config(struct lm3630a_chip *pchip)
+{
+	int rval;
+
+	rval = lm3630a_write(pchip, REG_INT_EN, 0x87);
+	if (rval < 0)
+		return rval;
+
+	INIT_DELAYED_WORK(&pchip->work, lm3630a_delayed_func);
+	pchip->irqthread = create_singlethread_workqueue("lm3630a-irqthd");
+	if (!pchip->irqthread) {
+		dev_err(pchip->dev, "create irq thread fail\n");
+		return -ENOMEM;
+	}
+	if (request_threaded_irq
+	    (pchip->irq, NULL, lm3630a_isr_func,
+	     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "lm3630a_irq", pchip)) {
+		dev_err(pchip->dev, "request threaded irq fail\n");
+		return -ENOMEM;
+	}
+	return rval;
+}
+
+static void lm3630a_pwm_ctrl(struct lm3630a_chip *pchip, int br, int br_max)
+{
+	unsigned int period = pwm_get_period(pchip->pwmd);
+	unsigned int duty = br * period / br_max;
+
+	pwm_config(pchip->pwmd, duty, period);
+	if (duty)
+		pwm_enable(pchip->pwmd);
+	else
+		pwm_disable(pchip->pwmd);
+}
+
+/* update and get brightness */
+static int lm3630a_bank_a_update_status(struct backlight_device *bl)
+{
+	int ret;
+	struct lm3630a_chip *pchip = bl_get_data(bl);
+	enum lm3630a_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	/* pwm control */
+	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
+		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
+				 bl->props.max_brightness);
+		return bl->props.brightness;
+	}
+
+	/* disable sleep */
+	ret = lm3630a_update(pchip, REG_CTRL, 0x80, 0x00);
+	if (ret < 0)
+		goto out_i2c_err;
+	usleep_range(1000, 2000);
+	/* minimum brightness is 0x04 */
+	ret = lm3630a_write(pchip, REG_BRT_A, bl->props.brightness);
+	if (bl->props.brightness < 0x4)
+		ret |= lm3630a_update(pchip, REG_CTRL, LM3630A_LEDA_ENABLE, 0);
+	else
+		ret |= lm3630a_update(pchip, REG_CTRL,
+				      LM3630A_LEDA_ENABLE, LM3630A_LEDA_ENABLE);
+	if (ret < 0)
+		goto out_i2c_err;
+	return bl->props.brightness;
+
+out_i2c_err:
+	dev_err(pchip->dev, "i2c failed to access\n");
+	return bl->props.brightness;
+}
+
+static int lm3630a_bank_a_get_brightness(struct backlight_device *bl)
+{
+	int brightness, rval;
+	struct lm3630a_chip *pchip = bl_get_data(bl);
+	enum lm3630a_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
+		rval = lm3630a_read(pchip, REG_PWM_OUTHIGH);
+		if (rval < 0)
+			goto out_i2c_err;
+		brightness = (rval & 0x01) << 8;
+		rval = lm3630a_read(pchip, REG_PWM_OUTLOW);
+		if (rval < 0)
+			goto out_i2c_err;
+		brightness |= rval;
+		goto out;
+	}
+
+	/* disable sleep */
+	rval = lm3630a_update(pchip, REG_CTRL, 0x80, 0x00);
+	if (rval < 0)
+		goto out_i2c_err;
+	usleep_range(1000, 2000);
+	rval = lm3630a_read(pchip, REG_BRT_A);
+	if (rval < 0)
+		goto out_i2c_err;
+	brightness = rval;
+
+out:
+	bl->props.brightness = brightness;
+	return bl->props.brightness;
+out_i2c_err:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return 0;
+}
+
+static const struct backlight_ops lm3630a_bank_a_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3630a_bank_a_update_status,
+	.get_brightness = lm3630a_bank_a_get_brightness,
+};
+
+/* update and get brightness */
+static int lm3630a_bank_b_update_status(struct backlight_device *bl)
+{
+	int ret;
+	struct lm3630a_chip *pchip = bl_get_data(bl);
+	enum lm3630a_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	/* pwm control */
+	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
+		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
+				 bl->props.max_brightness);
+		return bl->props.brightness;
+	}
+
+	/* disable sleep */
+	ret = lm3630a_update(pchip, REG_CTRL, 0x80, 0x00);
+	if (ret < 0)
+		goto out_i2c_err;
+	usleep_range(1000, 2000);
+	/* minimum brightness is 0x04 */
+	ret = lm3630a_write(pchip, REG_BRT_B, bl->props.brightness);
+	if (bl->props.brightness < 0x4)
+		ret |= lm3630a_update(pchip, REG_CTRL, LM3630A_LEDB_ENABLE, 0);
+	else
+		ret |= lm3630a_update(pchip, REG_CTRL,
+				      LM3630A_LEDB_ENABLE, LM3630A_LEDB_ENABLE);
+	if (ret < 0)
+		goto out_i2c_err;
+	return bl->props.brightness;
+
+out_i2c_err:
+	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
+	return bl->props.brightness;
+}
+
+static int lm3630a_bank_b_get_brightness(struct backlight_device *bl)
+{
+	int brightness, rval;
+	struct lm3630a_chip *pchip = bl_get_data(bl);
+	enum lm3630a_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
+
+	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
+		rval = lm3630a_read(pchip, REG_PWM_OUTHIGH);
+		if (rval < 0)
+			goto out_i2c_err;
+		brightness = (rval & 0x01) << 8;
+		rval = lm3630a_read(pchip, REG_PWM_OUTLOW);
+		if (rval < 0)
+			goto out_i2c_err;
+		brightness |= rval;
+		goto out;
+	}
+
+	/* disable sleep */
+	rval = lm3630a_update(pchip, REG_CTRL, 0x80, 0x00);
+	if (rval < 0)
+		goto out_i2c_err;
+	usleep_range(1000, 2000);
+	rval = lm3630a_read(pchip, REG_BRT_B);
+	if (rval < 0)
+		goto out_i2c_err;
+	brightness = rval;
+
+out:
+	bl->props.brightness = brightness;
+	return bl->props.brightness;
+out_i2c_err:
+	dev_err(pchip->dev, "i2c failed to access register\n");
+	return 0;
+}
+
+static const struct backlight_ops lm3630a_bank_b_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3630a_bank_b_update_status,
+	.get_brightness = lm3630a_bank_b_get_brightness,
+};
+
+static int lm3630a_backlight_register(struct lm3630a_chip *pchip)
+{
+	struct backlight_properties props;
+	struct lm3630a_platform_data *pdata = pchip->pdata;
+
+	props.type = BACKLIGHT_RAW;
+	if (pdata->leda_ctrl != LM3630A_LEDA_DISABLE) {
+		props.brightness = pdata->leda_init_brt;
+		props.max_brightness = pdata->leda_max_brt;
+		pchip->bleda =
+		    devm_backlight_device_register(pchip->dev, "lm3630a_leda",
+						   pchip->dev, pchip,
+						   &lm3630a_bank_a_ops, &props);
+		if (IS_ERR(pchip->bleda))
+			return PTR_ERR(pchip->bleda);
+	}
+
+	if ((pdata->ledb_ctrl != LM3630A_LEDB_DISABLE) &&
+	    (pdata->ledb_ctrl != LM3630A_LEDB_ON_A)) {
+		props.brightness = pdata->ledb_init_brt;
+		props.max_brightness = pdata->ledb_max_brt;
+		pchip->bledb =
+		    devm_backlight_device_register(pchip->dev, "lm3630a_ledb",
+						   pchip->dev, pchip,
+						   &lm3630a_bank_b_ops, &props);
+		if (IS_ERR(pchip->bledb))
+			return PTR_ERR(pchip->bledb);
+	}
+	return 0;
+}
+
+static const struct regmap_config lm3630a_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = REG_MAX,
+};
+
+static int lm3630a_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct lm3630a_platform_data *pdata = client->dev.platform_data;
+	struct lm3630a_chip *pchip;
+	int rval;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "fail : i2c functionality check\n");
+		return -EOPNOTSUPP;
+	}
+
+	pchip = devm_kzalloc(&client->dev, sizeof(struct lm3630a_chip),
+			     GFP_KERNEL);
+	if (!pchip)
+		return -ENOMEM;
+	pchip->dev = &client->dev;
+
+	pchip->regmap = devm_regmap_init_i2c(client, &lm3630a_regmap);
+	if (IS_ERR(pchip->regmap)) {
+		rval = PTR_ERR(pchip->regmap);
+		dev_err(&client->dev, "fail : allocate reg. map: %d\n", rval);
+		return rval;
+	}
+
+	i2c_set_clientdata(client, pchip);
+	if (pdata == NULL) {
+		pchip->pdata = devm_kzalloc(pchip->dev,
+					    sizeof(struct
+						   lm3630a_platform_data),
+					    GFP_KERNEL);
+		if (pchip->pdata == NULL)
+			return -ENOMEM;
+		/* default values */
+		pchip->pdata->leda_ctrl = LM3630A_LEDA_ENABLE;
+		pchip->pdata->ledb_ctrl = LM3630A_LEDB_ENABLE;
+		pchip->pdata->leda_max_brt = LM3630A_MAX_BRIGHTNESS;
+		pchip->pdata->ledb_max_brt = LM3630A_MAX_BRIGHTNESS;
+		pchip->pdata->leda_init_brt = LM3630A_MAX_BRIGHTNESS;
+		pchip->pdata->ledb_init_brt = LM3630A_MAX_BRIGHTNESS;
+	} else {
+		pchip->pdata = pdata;
+	}
+	/* chip initialize */
+	rval = lm3630a_chip_init(pchip);
+	if (rval < 0) {
+		dev_err(&client->dev, "fail : init chip\n");
+		return rval;
+	}
+	/* backlight register */
+	rval = lm3630a_backlight_register(pchip);
+	if (rval < 0) {
+		dev_err(&client->dev, "fail : backlight register.\n");
+		return rval;
+	}
+	/* pwm */
+	if (pdata->pwm_ctrl != LM3630A_PWM_DISABLE) {
+		pchip->pwmd = devm_pwm_get(pchip->dev, "lm3630a-pwm");
+		if (IS_ERR(pchip->pwmd)) {
+			dev_err(&client->dev, "fail : get pwm device\n");
+			return PTR_ERR(pchip->pwmd);
+		}
+	}
+	pchip->pwmd->period = pdata->pwm_period;
+
+	/* interrupt enable  : irq 0 is not allowed */
+	pchip->irq = client->irq;
+	if (pchip->irq) {
+		rval = lm3630a_intr_config(pchip);
+		if (rval < 0)
+			return rval;
+	}
+	dev_info(&client->dev, "LM3630A backlight register OK.\n");
+	return 0;
+}
+
+static int lm3630a_remove(struct i2c_client *client)
+{
+	int rval;
+	struct lm3630a_chip *pchip = i2c_get_clientdata(client);
+
+	rval = lm3630a_write(pchip, REG_BRT_A, 0);
+	if (rval < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+
+	rval = lm3630a_write(pchip, REG_BRT_B, 0);
+	if (rval < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+
+	if (pchip->irq) {
+		free_irq(pchip->irq, pchip);
+		flush_workqueue(pchip->irqthread);
+		destroy_workqueue(pchip->irqthread);
+	}
+	return 0;
+}
+
+static const struct i2c_device_id lm3630a_id[] = {
+	{LM3630A_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3630a_id);
+
+static struct i2c_driver lm3630a_i2c_driver = {
+	.driver = {
+		   .name = LM3630A_NAME,
+		   },
+	.probe = lm3630a_probe,
+	.remove = lm3630a_remove,
+	.id_table = lm3630a_id,
+};
+
+module_i2c_driver(lm3630a_i2c_driver);
+
+MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3630A");
+MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
+MODULE_AUTHOR("LDD MLP <ldd-mlp@list.ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/lm3630_bl.h b/include/linux/platform_data/lm3630_bl.h
deleted file mode 100644
index 9176dd3..0000000
--- a/include/linux/platform_data/lm3630_bl.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
-* Simple driver for Texas Instruments LM3630 LED Flash driver chip
-* Copyright (C) 2012 Texas Instruments
-*
-* This program is free software; you can redistribute it and/or modify
-* it under the terms of the GNU General Public License version 2 as
-* published by the Free Software Foundation.
-*
-*/
-
-#ifndef __LINUX_LM3630_H
-#define __LINUX_LM3630_H
-
-#define LM3630_NAME "lm3630_bl"
-
-enum lm3630_pwm_ctrl {
-	PWM_CTRL_DISABLE = 0,
-	PWM_CTRL_BANK_A,
-	PWM_CTRL_BANK_B,
-	PWM_CTRL_BANK_ALL,
-};
-
-enum lm3630_pwm_active {
-	PWM_ACTIVE_HIGH = 0,
-	PWM_ACTIVE_LOW,
-};
-
-enum lm3630_bank_a_ctrl {
-	BANK_A_CTRL_DISABLE = 0x0,
-	BANK_A_CTRL_LED1 = 0x4,
-	BANK_A_CTRL_LED2 = 0x1,
-	BANK_A_CTRL_ALL = 0x5,
-};
-
-enum lm3630_bank_b_ctrl {
-	BANK_B_CTRL_DISABLE = 0,
-	BANK_B_CTRL_LED2,
-};
-
-struct lm3630_platform_data {
-
-	/* maximum brightness */
-	int max_brt_led1;
-	int max_brt_led2;
-
-	/* initial on brightness */
-	int init_brt_led1;
-	int init_brt_led2;
-	enum lm3630_pwm_ctrl pwm_ctrl;
-	enum lm3630_pwm_active pwm_active;
-	enum lm3630_bank_a_ctrl bank_a_ctrl;
-	enum lm3630_bank_b_ctrl bank_b_ctrl;
-	unsigned int pwm_period;
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-};
-
-#endif /* __LINUX_LM3630_H */
diff --git a/include/linux/platform_data/lm3630a_bl.h b/include/linux/platform_data/lm3630a_bl.h
new file mode 100644
index 0000000..7538e38
--- /dev/null
+++ b/include/linux/platform_data/lm3630a_bl.h
@@ -0,0 +1,65 @@
+/*
+* Simple driver for Texas Instruments LM3630A LED Flash driver chip
+* Copyright (C) 2012 Texas Instruments
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+*/
+
+#ifndef __LINUX_LM3630A_H
+#define __LINUX_LM3630A_H
+
+#define LM3630A_NAME "lm3630a_bl"
+
+enum lm3630a_pwm_ctrl {
+	LM3630A_PWM_DISABLE = 0x00,
+	LM3630A_PWM_BANK_A,
+	LM3630A_PWM_BANK_B,
+	LM3630A_PWM_BANK_ALL,
+	LM3630A_PWM_BANK_A_ACT_LOW = 0x05,
+	LM3630A_PWM_BANK_B_ACT_LOW,
+	LM3630A_PWM_BANK_ALL_ACT_LOW,
+};
+
+enum lm3630a_leda_ctrl {
+	LM3630A_LEDA_DISABLE = 0x00,
+	LM3630A_LEDA_ENABLE = 0x04,
+	LM3630A_LEDA_ENABLE_LINEAR = 0x14,
+};
+
+enum lm3630a_ledb_ctrl {
+	LM3630A_LEDB_DISABLE = 0x00,
+	LM3630A_LEDB_ON_A = 0x01,
+	LM3630A_LEDB_ENABLE = 0x02,
+	LM3630A_LEDB_ENABLE_LINEAR = 0x0A,
+};
+
+#define LM3630A_MAX_BRIGHTNESS 255
+/*
+ *@leda_init_brt : led a init brightness. 4~255
+ *@leda_max_brt  : led a max brightness.  4~255
+ *@leda_ctrl     : led a disable, enable linear, enable exponential
+ *@ledb_init_brt : led b init brightness. 4~255
+ *@ledb_max_brt  : led b max brightness.  4~255
+ *@ledb_ctrl     : led b disable, enable linear, enable exponential
+ *@pwm_period    : pwm period
+ *@pwm_ctrl      : pwm disable, bank a or b, active high or low
+ */
+struct lm3630a_platform_data {
+
+	/* led a config.  */
+	int leda_init_brt;
+	int leda_max_brt;
+	enum lm3630a_leda_ctrl leda_ctrl;
+	/* led b config. */
+	int ledb_init_brt;
+	int ledb_max_brt;
+	enum lm3630a_ledb_ctrl ledb_ctrl;
+	/* pwm config. */
+	unsigned int pwm_period;
+	enum lm3630a_pwm_ctrl pwm_ctrl;
+};
+
+#endif /* __LINUX_LM3630A_H */
-- 
1.7.10.4


