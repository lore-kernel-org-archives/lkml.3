Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3B1BM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:12:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15424 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1BM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:12:57 -0500
X-AuditID: cbfee690-b7f6b6d000004563-54-512eaf1753fb
Date: Thu, 28 Feb 2013 01:12:55 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/2] leds: Add support for Palmas LEDs
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130228011210436@jg1.han
Msgkey: 20130228011210436@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130228011210436@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <24550733.220381362013975218.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJsWRmVeSWpSXmKPExsVy+t8zA12J9XqBBlc3MFlc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM+L37MmPBlZeMFedmHGZpYLzwmLGLkZNDSEBJYtLJvWC2hICJxIHn
	U5khbDGJC/fWs3UxcgHVLGOUuLF7GlCCA6yo50otRO98RolrZ+NAbBYBVYk/E3cwgdhsAuoS
	E343s4DYwgJWEh3Nl1hBbBEBNYmvD3YygsxkFjjGKtH7cgkzxCBZiXuTZ4PZvAKCEidnPmGB
	OEJBomfFLzaIuKLE2kk/2SDiEhJ37u9nhbB5JWa0P4Wql5OY9nUN1APSEudnbWCEeWbx98dQ
	cX6JY7dBDuUA631yPxhmzO7NX6DGC0hMPXMQqlVV4n1XL1Qrn8SahW+hVglKnL7WzQzT27Dx
	NzuIzQx05pTuh1C2lsSXH/vY0L3FK+Ak8efvf5YJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckF
	xUnpRSbI0b2JEZIKJ+xgvHfA+hDjfkZgpExklhJNzgcm07ySeENjYxMzE1MTc0tTc1MKhM2N
	TA2AadXAkDrCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwyrn1mco0SN2fs+qk
	zLkpU2sCuGUXvahSnnhv0uropcx7/JizWbK2JK1du3my8NkLUeknJ68zXWGx7uznlw2nDs7M
	95q2eXGVmMo2ybkBiUs3LvadOe3h9le2xd/fsjRZ9uWG39L6a3jhQET864cuk3S2ROdqHuT7
	1pV31CfwU3HYS6V1j11XP1diKc5INNRiLipOBADkb4By+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/2DF3x9XqBBt93WFhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jN+7LzMWXHnJWHFuxmGWBsYLjxm7GDk5hASUJCad3Atkc3BICJhI9FypBQlLCIhJXLi3ng2i
	ZD6jxLWzcSA2i4CqxJ+JO5hAbDYBdYkJv5tZQGxhASuJjuZLrCC2iICaxNcHO4FGcnEwCxxj
	leh9uYQZYpCsxL3Js8FsXgFBiZMzn7BALFOQ6Fnxiw0iriixdtJPNoi4hMSd+/tZIWxeiRnt
	T6Hq5SSmfV3DDGFLS5yftYER5ujF3x9Dxfkljt0GOZQDrPfJ/WCYMbs3f4EaLyAx9cxBqFZV
	ifddvVCtfBJrFr6FWiUocfpaNzNMb8PG3+wgNjPQmVO6H0LZWhJffuxjQ/cWr4CTxJ+//1km
	MMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjrFSfmFpfmpesl5+duYgQnqWeLdzD+P299
	iFGAg1GJh9fBQS9QiDWxrLgy9xCjBAezkgjvtjqgEG9KYmVValF+fFFpTmrxIcZkYAxOZJYS
	Tc4HJtC8knhDY2MTMxNTcwMLA0tz0oSVxHlDbNQDhQTSE0tSs1NTC1KLYLYwcXBKNTD6fElg
	O5MqpGI44Xe3woFWtv0idf6d1z8WTp8aGMa+MEJPUdftr2S3TOnO3UxTP+8W/rNXZW1Wm5sM
	X+7MzKoVjjYzdtjorlfm/9/TvLNAcUvkuxrbbz5f/pcall3IY6xYnmDMeF1rubPrpJyUzTa/
	zjZLTWOWmLcsSis5194qqXx6UiXnDyWW4oxEQy3mouJEAMlJJMqWAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1S1D3te010912

On Wednesday, February 27, 2013 10:13 PM, Ian Lartey wrote:
> 
> The Palmas familly of chips has LED support. This is not always muxed
> to output pins so depending on the setting of the mux this driver
> will create the appropriate LED class devices.

Hi Ian Lartey,

I added some minor comments :)
Good luck.

> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
>  drivers/leds/leds-palmas.c |  574 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/palmas.h |   60 +++++
>  2 files changed, 634 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-palmas.c
> 
> diff --git a/drivers/leds/leds-palmas.c b/drivers/leds/leds-palmas.c
> new file mode 100644
> index 0000000..4cb73aa
> --- /dev/null
> +++ b/drivers/leds/leds-palmas.c
> @@ -0,0 +1,574 @@
> +/*
> + * Driver for LED part of Palmas PMIC Chips
> + *
> + * Copyright 2011 Texas Instruments Inc.

2013 ?

> + *
> + * Author: Graeme Gregory <gg@slimlogic.co.uk>
> + * Author: Ian Lartey <ian@slimlogic.co.uk>
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under  the terms of the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/leds.h>
> +#include <linux/err.h>
> +#include <linux/mfd/palmas.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>

Would you order header files according to alphabetical ordering?
It would be better for the readability.

> +
> +struct palmas_leds_data;
> +
> +struct palmas_led {
> +	struct led_classdev cdev;
> +	struct palmas_leds_data *leds_data;
> +	int led_no;
> +	struct work_struct work;
> +	struct mutex mutex;
> +
> +	spinlock_t value_lock;
> +
> +	int blink;
> +	int on_time;
> +	int period;
> +	enum led_brightness brightness;
> +};
> +
> +struct palmas_leds_data {
> +	struct device *dev;
> +	struct led_classdev cdev;
> +	struct palmas *palmas;
> +
> +	struct palmas_led *palmas_led;
> +	int no_leds;
> +};
> +
> +#define to_palmas_led(led_cdev) \
> +	container_of(led_cdev, struct palmas_led, cdev)
> +
> +#define LED_ON_62_5MS		0x00
> +#define LED_ON_125MS		0x01
> +#define LED_ON_250MS		0x02
> +#define LED_ON_500MS		0x03
> +
> +#define LED_PERIOD_OFF		0x00
> +#define LED_PERIOD_125MS	0x01
> +#define LED_PERIOD_250MS	0x02
> +#define LED_PERIOD_500MS	0x03
> +#define LED_PERIOD_1000MS	0x04
> +#define LED_PERIOD_2000MS	0x05
> +#define LED_PERIOD_4000MS	0x06
> +#define LED_PERIOD_8000MS	0x07
> +
> +
> +static char *palmas_led_names[] = {
> +	"palmas:led1",
> +	"palmas:led2",
> +	"palmas:led3",
> +	"palmas:led4",
> +};
> +
> +static int palmas_led_read(struct palmas_leds_data *leds, unsigned int reg,
> +		unsigned int *dest)
> +{
> +	unsigned int addr;
> +
> +	addr = PALMAS_BASE_TO_REG(PALMAS_LED_BASE, reg);
> +
> +	return palmas_read(leds->palmas, PALMAS_LED_BASE, addr, dest);
> +}
> +
> +static int palmas_led_write(struct palmas_leds_data *leds, unsigned int reg,
> +		unsigned int value)
> +{
> +	unsigned int addr;
> +
> +	addr = PALMAS_BASE_TO_REG(PALMAS_LED_BASE, reg);
> +
> +	return palmas_write(leds->palmas, PALMAS_LED_BASE, addr, value);
> +}
> +
> +static int palmas_led_update_bits(struct palmas_leds_data *leds,
> +		unsigned int reg, unsigned int mask, unsigned int value)
> +{
> +	unsigned int addr;
> +
> +	addr = PALMAS_BASE_TO_REG(PALMAS_LED_BASE, reg);
> +
> +	return palmas_update_bits(leds->palmas, PALMAS_LED_BASE,
> +			addr, mask, value);
> +}
> +
> +static void palmas_leds_work(struct work_struct *work)
> +{
> +	struct palmas_led *led = container_of(work, struct palmas_led, work);
> +	unsigned int period, ctrl;
> +	unsigned long flags;
> +
> +	mutex_lock(&led->mutex);
> +
> +	palmas_led_read(led->leds_data, PALMAS_LED_CTRL, &ctrl);
> +	palmas_led_read(led->leds_data, PALMAS_LED_PERIOD_CTRL, &period);
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
> +
> +	switch (led->led_no) {
> +	case 1:
> +		ctrl &= ~PALMAS_LED_CTRL_LED_1_ON_TIME_MASK;
> +		period &= ~PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_MASK;
> +
> +		if (led->blink) {
> +			ctrl |= led->on_time <<
> +				PALMAS_LED_CTRL_LED_1_ON_TIME_SHIFT;
> +			period |= led->period <<
> +				PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_SHIFT;
> +		} else {
> +			/*
> +			 * for off value is zero which we already set by
> +			 * masking earlier.
> +			 */
> +			if (led->brightness) {
> +				ctrl |= LED_ON_500MS <<
> +					PALMAS_LED_CTRL_LED_1_ON_TIME_SHIFT;
> +				period |= LED_PERIOD_500MS <<
> +				PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_SHIFT;
> +			}
> +		}
> +	case 2:
> +		ctrl &= ~PALMAS_LED_CTRL_LED_2_ON_TIME_MASK;
> +		period &= ~PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_MASK;
> +
> +		if (led->blink) {
> +			ctrl |= led->on_time <<
> +				PALMAS_LED_CTRL_LED_2_ON_TIME_SHIFT;
> +			period |= led->period <<
> +				PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_SHIFT;
> +		} else {
> +			/*
> +			 * for off value is zero which we already set by
> +			 * masking earlier.
> +			 */
> +			if (led->brightness) {
> +				ctrl |= LED_ON_500MS <<
> +					PALMAS_LED_CTRL_LED_2_ON_TIME_SHIFT;
> +				period |= LED_PERIOD_500MS <<
> +				PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_SHIFT;
> +			}
> +		}
> +	case 3:
> +		ctrl &= ~PALMAS_LED_CTRL2_LED_3_ON_TIME_MASK;
> +		period &= ~PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_MASK;
> +
> +		if (led->blink) {
> +			ctrl |= led->on_time <<
> +				PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT;
> +			period |= led->period <<
> +				PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT;
> +		} else {
> +			/*
> +			 * for off value is zero which we already set by
> +			 * masking earlier.
> +			 */
> +			if (led->brightness) {
> +				ctrl |= LED_ON_500MS <<
> +					PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT;
> +				period |= LED_PERIOD_500MS <<
> +				PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT;
> +			}
> +		}
> +		break;
> +	case 4:
> +		ctrl &= ~PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_MASK;
> +		period &= ~PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_MASK;
> +
> +		if (led->blink) {
> +			ctrl |= led->on_time <<
> +				PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT;
> +			period |= led->period <<
> +				PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT;
> +		} else {
> +			/*
> +			 * for off value is zero which we already set by
> +			 * masking earlier.
> +			 */
> +			if (led->brightness) {
> +				ctrl |= LED_ON_500MS <<
> +					PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT;
> +				period |= LED_PERIOD_500MS <<
> +				PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT;
> +			}
> +		}
> +		break;
> +	}
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +
> +	if (led->led_no < 3) {
> +		palmas_led_write(led->leds_data, PALMAS_LED_CTRL, ctrl);
> +		palmas_led_write(led->leds_data, PALMAS_LED_PERIOD_CTRL,
> +				period);
> +	} else {
> +		palmas_led_write(led->leds_data, PALMAS_LED_CTRL2, ctrl);
> +		palmas_led_write(led->leds_data, PALMAS_LED_PERIOD2_CTRL,
> +				period);
> +	}
> +
> +	if (is_palmas_charger(led->leds_data->palmas->product_id)) {
> +		if (led->brightness || led->blink)
> +			palmas_led_update_bits(led->leds_data, PALMAS_LED_EN,
> +					1 << (led->led_no - 1), 0xFF);
> +		else
> +			palmas_led_update_bits(led->leds_data, PALMAS_LED_EN,
> +					1 << (led->led_no - 1), 0x00);
> +	}
> +	mutex_unlock(&led->mutex);
> +}
> +
> +static void palmas_leds_set(struct led_classdev *led_cdev,
> +			   enum led_brightness value)
> +{
> +	struct palmas_led *led = to_palmas_led(led_cdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
> +	led->brightness = value;
> +	led->blink = 0;
> +	schedule_work(&led->work);
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +}
> +
> +static int palmas_leds_blink_set(struct led_classdev *led_cdev,
> +				   unsigned long *delay_on,
> +				   unsigned long *delay_off)
> +{
> +	struct palmas_led *led = to_palmas_led(led_cdev);
> +	unsigned long flags;
> +	int ret = 0;
> +	int period;
> +
> +	/* Pick some defaults if we've not been given times */
> +	if (*delay_on == 0 && *delay_off == 0) {
> +		*delay_on = 250;
> +		*delay_off = 250;
> +	}
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
> +
> +	/* We only have a limited selection of settings, see if we can
> +	 * support the configuration we're being given */

According to the Coding Style, the preferred style for multi-line comments is:

 +	/*
 +	 * We only have a limited selection of settings, see if we can
 +	 * support the configuration we're being given
 +	 */


> +	switch (*delay_on) {
> +	case 500:
> +		led->on_time = LED_ON_500MS;
> +		break;
> +	case 250:
> +		led->on_time = LED_ON_250MS;
> +		break;
> +	case 125:
> +		led->on_time = LED_ON_125MS;
> +		break;
> +	case 62:
> +	case 63:
> +		/* Actually 62.5ms */
> +		led->on_time = LED_ON_62_5MS;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	period = *delay_on + *delay_off;
> +
> +	if (ret == 0) {
> +		switch (period) {
> +		case 124:
> +		case 125:
> +		case 126:
> +			/* All possible variations of 62.5 + 62.5 */
> +			led->period = LED_PERIOD_125MS;
> +			break;
> +		case 250:
> +			led->period = LED_PERIOD_250MS;
> +			break;
> +		case 500:
> +			led->period = LED_PERIOD_500MS;
> +			break;
> +		case 1000:
> +			led->period = LED_PERIOD_1000MS;
> +			break;
> +		case 2000:
> +			led->period = LED_PERIOD_2000MS;
> +			break;
> +		case 4000:
> +			led->period = LED_PERIOD_4000MS;
> +			break;
> +		case 8000:
> +			led->period = LED_PERIOD_8000MS;
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +	}
> +
> +	if (ret == 0)
> +		led->blink = 1;
> +	else
> +		led->blink = 0;
> +
> +	/* Always update; if we fail turn off blinking since we expect
> +	 * a software fallback. */

Same as above.

> +	schedule_work(&led->work);
> +
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +
> +	return ret;
> +}
> +
> +static void palmas_init_led(struct palmas_leds_data *leds_data, int offset,
> +		int led_no)
> +{
> +	mutex_init(&leds_data->palmas_led[offset].mutex);
> +	INIT_WORK(&leds_data->palmas_led[offset].work, palmas_leds_work);
> +	spin_lock_init(&leds_data->palmas_led[offset].value_lock);
> +
> +	leds_data->palmas_led[offset].leds_data = leds_data;
> +	leds_data->palmas_led[offset].led_no = led_no;
> +	leds_data->palmas_led[offset].cdev.name = palmas_led_names[led_no - 1];
> +	leds_data->palmas_led[offset].cdev.default_trigger = NULL;
> +	leds_data->palmas_led[offset].cdev.brightness_set = palmas_leds_set;
> +	leds_data->palmas_led[offset].cdev.blink_set = palmas_leds_blink_set;
> +}
> +
> +static int  palmas_dt_to_pdata(struct device *dev,
> +		struct device_node *node,
> +		struct palmas_leds_platform_data *pdata)
> +{
> +	struct device_node *child_node;
> +	int ret;
> +	u32 prop;
> +
> +	child_node = of_get_child_by_name(node, "palmas_leds");
> +	if (!child_node) {
> +		dev_err(dev, "child node 'palmas_leds' not found\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = of_property_read_u32(child_node, "ti,led1_current", &prop);
> +	if (!ret)
> +		pdata->led1_current = prop;
> +
> +	ret = of_property_read_u32(child_node, "ti,led2_current", &prop);
> +	if (!ret)
> +		pdata->led2_current = prop;
> +
> +	ret = of_property_read_u32(child_node, "ti,led3_current", &prop);
> +	if (!ret)
> +		pdata->led3_current = prop;
> +
> +	ret = of_property_read_u32(child_node, "ti,led4_current", &prop);
> +	if (!ret)
> +		pdata->led4_current = prop;
> +
> +	ret = of_property_read_u32(child_node, "ti,chrg_led_mode", &prop);
> +	if (!ret)
> +		pdata->chrg_led_mode = prop;
> +
> +	ret = of_property_read_u32(child_node, "ti,chrg_led_vbat_low", &prop);
> +	if (!ret)
> +		pdata->chrg_led_vbat_low = prop;
> +
> +	return 0;
> +}
> +
> +static int palmas_leds_probe(struct platform_device *pdev)
> +{
> +	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +	struct palmas_leds_platform_data *pdata = pdev->dev.platform_data;
> +	struct palmas_leds_data *leds_data;
> +	struct device_node *node = pdev->dev.of_node;
> +	int ret, i;
> +	int offset = 0;
> +
> +	if (!palmas->led_muxed && !is_palmas_charger(palmas->product_id)) {
> +		dev_err(&pdev->dev, "there are no LEDs muxed\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Palmas charger requires platform data */
> +	if (is_palmas_charger(palmas->product_id) && node && !pdata) {
> +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +
> +		if (!pdata)
> +			return -ENOMEM;
> +
> +		ret = palmas_dt_to_pdata(&pdev->dev, node, pdata);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (is_palmas_charger(palmas->product_id) && !pdata)
> +		return -EINVAL;
> +
> +	leds_data = kzalloc(sizeof(*leds_data), GFP_KERNEL);

How about using devm_kzalloc()?
Memory allocated with this function is automatically freed
on driver detach. So it makes error path more simple.


> +	if (!leds_data)
> +		return -ENOMEM;
> +	platform_set_drvdata(pdev, leds_data);
> +
> +	leds_data->palmas = palmas;
> +
> +	switch (palmas->led_muxed) {
> +	case PALMAS_LED1_MUXED | PALMAS_LED2_MUXED:
> +		leds_data->no_leds = 2;
> +		break;
> +	case PALMAS_LED1_MUXED:
> +	case PALMAS_LED2_MUXED:
> +		leds_data->no_leds = 1;
> +		break;
> +	default:
> +		leds_data->no_leds = 0;
> +		break;
> +	}
> +
> +	if (is_palmas_charger(palmas->product_id)) {
> +		if (pdata->chrg_led_mode)
> +			leds_data->no_leds += 2;
> +		else
> +			leds_data->no_leds++;
> +	}
> +
> +	leds_data->palmas_led = kcalloc(leds_data->no_leds,
> +			sizeof(struct palmas_led), GFP_KERNEL);

How about using devm_kzalloc()?


> +
> +	/* Initialise LED1 */
> +	if (palmas->led_muxed & PALMAS_LED1_MUXED) {
> +		palmas_init_led(leds_data, offset, 1);
> +		offset++;
> +	}
> +
> +	/* Initialise LED2 */
> +	if (palmas->led_muxed & PALMAS_LED2_MUXED) {
> +		palmas_init_led(leds_data, offset, 2);
> +		offset++;
> +	}
> +
> +	if (is_palmas_charger(palmas->product_id)) {
> +		palmas_init_led(leds_data, offset, 3);
> +		offset++;
> +
> +		if (pdata->chrg_led_mode) {
> +			palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
> +					PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE,
> +					PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE);
> +
> +			palmas_init_led(leds_data, offset, 4);
> +		}
> +	}
> +
> +	for (i = 0; i < leds_data->no_leds; i++) {
> +		ret = led_classdev_register(leds_data->dev,
> +				&leds_data->palmas_led[i].cdev);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev,
> +				"Failed to register LED no: %d err: %d\n",
> +				i, ret);
> +			goto err_led;
> +		}
> +	}
> +
> +	if (!is_palmas_charger(palmas->product_id))
> +		return 0;
> +
> +	/* Set the LED current registers if set in platform data */
> +	if (pdata->led1_current)
> +		palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL1,
> +				PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_MASK,
> +				pdata->led1_current);
> +
> +	if (pdata->led2_current)
> +		palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL1,
> +				PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_MASK,
> +				pdata->led2_current <<
> +				PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_SHIFT);
> +
> +	if (pdata->led3_current)
> +		palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL2,
> +				PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK,
> +				pdata->led3_current);
> +
> +	if (pdata->led3_current)
> +		palmas_led_update_bits(leds_data, PALMAS_LED_CURRENT_CTRL2,
> +				PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK,
> +				pdata->led3_current);
> +
> +	if (pdata->led4_current)
> +		palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
> +				PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_MASK,
> +				pdata->led4_current <<
> +				PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_SHIFT);
> +
> +	if (pdata->chrg_led_vbat_low)
> +		palmas_led_update_bits(leds_data, PALMAS_CHRG_LED_CTRL,
> +				PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS,
> +				PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS);
> +
> +	return 0;
> +
> +err_led:
> +	for (i = 0; i < leds_data->no_leds; i++)
> +		led_classdev_unregister(&leds_data->palmas_led[i].cdev);
> +	kfree(leds_data->palmas_led);
> +	kfree(leds_data);

If you use devm_kzalloc() above, you don't need to use kfree().

> +	return ret;
> +}
> +
> +static int palmas_leds_remove(struct platform_device *pdev)
> +{
> +	struct palmas_leds_data *leds_data = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < leds_data->no_leds; i++)
> +		led_classdev_unregister(&leds_data->palmas_led[i].cdev);
> +	if (i)
> +		kfree(leds_data->palmas_led);
> +	kfree(leds_data);

If you use devm_kzalloc() above, you don't need to use kfree().

> +
> +	return 0;
> +}
> +
> +static struct of_device_id of_palmas_match_tbl[] = {
> +	{ .compatible = "ti,palmas-leds", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver palmas_leds_driver = {
> +	.driver = {
> +		.name = "palmas-leds",
> +		.of_match_table = of_palmas_match_tbl,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = palmas_leds_probe,
> +	.remove = palmas_leds_remove,
> +};
> +
> +static int  palmas_leds_init(void)
> +{
> +	return platform_driver_register(&palmas_leds_driver);
> +}
> +module_init(palmas_leds_init);
> +
> +static void palmas_leds_exit(void)
> +{
> +	platform_driver_unregister(&palmas_leds_driver);
> +}
> +module_exit(palmas_leds_exit);

Please use module_platform_driver() macro which makes the code
smaller and simpler.

+module_platform_driver(palmas_leds_driver);


> +
> +MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
> +MODULE_DESCRIPTION("Palmas LED driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:palmas-leds");
> +MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 0b86845..856f54e 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -232,6 +232,16 @@ struct palmas_clk_platform_data {
>  	int clk32kgaudio_mode_sleep;
>  };
> 
> +struct palmas_leds_platform_data {
> +	int led1_current;
> +	int led2_current;
> +	int led3_current;
> +	int led4_current;
> +
> +	int chrg_led_mode;
> +	int chrg_led_vbat_low;
> +};
> +
>  struct palmas_platform_data {
>  	int gpio_base;
> 
> @@ -1855,6 +1865,12 @@ enum usb_irq_events {
>  #define PALMAS_LED_CTRL						0x1
>  #define PALMAS_PWM_CTRL1					0x2
>  #define PALMAS_PWM_CTRL2					0x3
> +#define PALMAS_LED_PERIOD2_CTRL					0x4
> +#define PALMAS_LED_CTRL2					0x5
> +#define PALMAS_LED_CURRENT_CTRL1				0x6
> +#define PALMAS_LED_CURRENT_CTRL2				0x7
> +#define PALMAS_CHRG_LED_CTRL					0x8
> +#define PALMAS_LED_EN						0x9
> 
>  /* Bit definitions for LED_PERIOD_CTRL */
>  #define PALMAS_LED_PERIOD_CTRL_LED_2_PERIOD_MASK		0x38
> @@ -1882,6 +1898,50 @@ enum usb_irq_events {
>  #define PALMAS_PWM_CTRL2_PWM_DUTY_SEL_MASK			0xff
>  #define PALMAS_PWM_CTRL2_PWM_DUTY_SEL_SHIFT			0
> 
> +/* Bit definitions for LED_PERIOD2_CTRL */
> +#define PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_MASK		0x38
> +#define PALMAS_LED_PERIOD2_CTRL_CHRG_LED_PERIOD_SHIFT		3
> +#define PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_MASK		0x07
> +#define PALMAS_LED_PERIOD2_CTRL_LED_3_PERIOD_SHIFT		0
> +
> +/* Bit definitions for LED_CTRL2 */
> +#define PALMAS_LED_CTRL2_CHRG_LED_SEQ				0x20
> +#define PALMAS_LED_CTRL2_CHRG_LED_SEQ_SHIFT			5
> +#define PALMAS_LED_CTRL2_LED_3_SEQ				0x10
> +#define PALMAS_LED_CTRL2_LED_3_SEQ_SHIFT			4
> +#define PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_MASK			0x0c
> +#define PALMAS_LED_CTRL2_CHRG_LED_ON_TIME_SHIFT			2
> +#define PALMAS_LED_CTRL2_LED_3_ON_TIME_MASK			0x03
> +#define PALMAS_LED_CTRL2_LED_3_ON_TIME_SHIFT			0
> +
> +/* Bit definitions for LED_CURRENT_CTRL1 */
> +#define PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_MASK		0x38
> +#define PALMAS_LED_CURRENT_CTRL1_LED_2_CURRENT_SHIFT		3
> +#define PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_MASK		0x07
> +#define PALMAS_LED_CURRENT_CTRL1_LED_1_CURRENT_SHIFT		0
> +
> +/* Bit definitions for LED_CURRENT_CTRL2 */
> +#define PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_MASK		0x07
> +#define PALMAS_LED_CURRENT_CTRL2_LED_3_CURRENT_SHIFT		0
> +
> +/* Bit definitions for CHRG_LED_CTRL */
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_MASK		0x38
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_CURRENT_SHIFT		3
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS		0x02
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LOWBAT_BLK_DIS_SHIFT		1
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE			0x01
> +#define PALMAS_CHRG_LED_CTRL_CHRG_LED_MODE_SHIFT		0
> +
> +/* Bit definitions for LED_EN */
> +#define PALMAS_LED_EN_CHRG_LED_EN				0x08
> +#define PALMAS_LED_EN_CHRG_LED_EN_SHIFT				3
> +#define PALMAS_LED_EN_LED_3_EN					0x04
> +#define PALMAS_LED_EN_LED_3_EN_SHIFT				2
> +#define PALMAS_LED_EN_LED_2_EN					0x02
> +#define PALMAS_LED_EN_LED_2_EN_SHIFT				1
> +#define PALMAS_LED_EN_LED_1_EN					0x01
> +#define PALMAS_LED_EN_LED_1_EN_SHIFT				0
> +
>  /* Registers for function INTERRUPT */
>  #define PALMAS_INT1_STATUS					0x0
>  #define PALMAS_INT1_MASK					0x1
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
