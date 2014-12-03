Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaLCCRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:17:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65147 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLCCRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:17:52 -0500
X-AuditID: cbfee68f-f791c6d000004834-5d-547e72cc3734
From: Jingoo Han <jg1.han@samsung.com>
To: gyungoh@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        treding@nvidia.com, florian.vaussard@epfl.ch, trivial@kernel.org,
        linux@roeck-us.net, andrew@lunn.ch, jic23@kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
 <1417507529-13654-3-git-send-email-jack.yoo@skyworksinc.com>
In-reply-to: <1417507529-13654-3-git-send-email-jack.yoo@skyworksinc.com>
Subject: Re: [PATCH v9 2/8] backlight: Add support Skyworks SKY81452 backlight
 driver
Date: Wed, 03 Dec 2014 11:19:06 +0900
Message-id: <001401d00e9f$83d6b660$8b842320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOBtPQ9s8b+6giSe+XR56nJnxyCQAl/whA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+845O24j7TS1PgcZ2BXJLlPXJ10oLDqh3egGEdWyk0pu2jZX
	YcisRFs1FSthlbV102VIVuYky6Yilc10NrXaTFExr4XmZWbldvpj/z3v+73P+3v4eLm44CNH
	yI2XKRm5TJIQRPKJ93+6RSEf5Kl7Vt7NAajebsbRtfZOEtWYcjB0u9rCQXW9WoCy+vUcVPm7
	DCBTy170t6OPgyy9hQB9utBGoLR7VgJZ9Y0c9O2cEUNtv2oAGm3KxJC1/CaJOvV1GLrf3ICh
	7LzHBEqvqPZC7y9x0JdJHzT02optgHRRfhGgrdorGP0g/RFOm3R2L7rw4QhJlxgvkrS6sp6g
	v9peknT+2120qWwYo6+cHyRp05jai9Y+MwK6UD9G0i9s+Tg9XBK4kzrAX3uMSYhXMfIV64/w
	46622sikF2dPa+2PMDXIZDSAx4VUGHxnuEWweg786CgmNYDPFVAPAJxwPgEawHUPNdwVs30D
	gM9Ka73Ywgng5cnLpMtNUovhyEiV+8GPSgOw/IYauAqcKsZhr+khxloyAKytKSBce3nUVthe
	u9Hl9qX2w+GqIo5LE9QimFdf4d7qTa2DTd2DOKtnw/FchzsrTgXDYlMtxur58GnRAM5GXQI7
	pkJcbT9KBLsMn3F2xA++6hl054HUUx4c+F73n0XB0VwzwXrnwZJKnP2KAPimoIXIBlDnQdZ5
	kHUeZJ0H4g4gjMCfSYpJUhyNlYcuV0ikimRZ7PKYRGkJYA8tqwzYK9eYAcUFQTO90aHUPQKO
	RKU4IzWD8OlEObjQPyZx+jZlysOrQsUiFB4WHipaHSEOmuutF07sFlCxEiVzgmGSGPlheXIC
	ozADjMsTqoHcsd+yoscJg8mFzcZ+nnMoqvj2vj6fqNLE6HFN2TV+x3FFtCbi+VRIwaYFs8UN
	FduWrgxQNv7El3FFFn7XjANh1zcLbdCx46BzfdwpXlrgpNF/e+T8XVm+pfMsPgGRs36rVAYl
	3NInPakUtMpmBNqih4xNKSkZjenn9/64dBAGEYo4yapgXK6Q/ANM94CbYwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSf0yMcRzHfZ/nueeu5nic4rv8as+Gabvqrrq+mUxY+xJbcmT+cJ66R7W6
	q91Tza9xfjQkV36t7dhxKDrRRHRNssiNWleOCKHQLBSVH0O465Y1vn+9P+/v5/X+/thHQsrM
	dIAkTZ/NG/RcBkv7Uo2/XjHyJsM2dWi+MwI5O+pJdLTzNY0a7AcJdOJ2swg19ZgAKnxvFaGb
	P6sBsj9ehX53vROh5p4ygB7ufkGhHWdcFHJZ74vQy502Ar343ADQlwd7CeSqOU6j19YmApU8
	aiVQUfEFCuXV3hajxv0i9PTHONRX5yIWQFxuKQfYZTpA4NK88yS2mzvEuOzsII0rbftobLzp
	pPCztus0ttxdge3VAwQ+sKuXxvavRjE2XbEBXGb9SuNrbRYSD1ROj2fWGsG8VJ7T8oZAXp+c
	qU3Tp0SzcSs1izQRqlCFXBGFItlAPafjo9nFy+LlsWkZ7v9gA3O5jBy3Fc8JAhsy//+EVepY
	ORoB18iXqxP+MsrQf9b6iyD1SHsbnXVt60ZTx3nCCPby+UAigUw4bD2tygc+bjkJtjyvoPOB
	r0TGnALwylWH2Ft8B7DgRwHt6aKZWXBw8Nbwhh+zA8CaY0bgKUimgoQ99rOEF9kDoKPhHOU5
	w4dZAjsdMR56IpMIB26VizyaYmbCYmftcKqUiYYPuntJr54Avx1+Tnk0yQTBCruD8OoZ8HL5
	B9J77dmwa0jusf0YJXxz6gnpbfGDN972giIgM49KMo9KMo9KMo9CTgLKBvz5rOQsISlFpwwW
	OJ2Qo08JTs7UVYLhueyeUg1sRlQPGAlgx0rRum1qmYjLFTbp6gGUkKyfND3JbUm13KbNvCFT
	Y8jJ4IV6EOF+6EEywD850z3l+myNIixcpYxSqpAyPDKSnSx93K5Ty5gULptP5/ks3jDCERKf
	APfcdBXUhs7TzimerP8oln7gunPWVQ816xylJWEgpCao9k7f6vgyjXZpf11uVMyjwpjo3eEL
	E6a9PWkK7G6z9h9PnM9vOKf4uQGXVG1xTf1EWsRdqZbWz84Tfftedh5aqGpK3O5/qF+2XnSJ
	r+wdf/T30L2nc4OLQuK+vWupqsoe09rPUkIqpwgiDQL3B1Gg04etAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 02, 2014 5:05 PM, Gyungoh Yoo wrote:
> 
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
> Changes v9:
> Nothing
> 
> Changes v8:
> Renamed property names for backlight with vendor prefix
> Modified gpio-enable property to generic property for GPIO
> 
> Changes v7:
> Modified licensing text to GPLv2
> 
> Changes v6:
> Added new line character at the end of line of dev_err()
> 
> Changes v5:
> Move sky81452-backlight.h to include/linux/platform_data
> 
> Changes v4:
> Reordering header files for readability
> Removed calling to backlight_device_unregister()
> Removed MODULE_VERSION()
> Modified license to GPLv2
> 
> Changes v3:
> Modified DBG messages
> 
> Changes v2:
> Added 'compatible' attribute in the driver
> Added message for exception or errors
> 
>  drivers/video/backlight/Kconfig                  |  10 +
>  drivers/video/backlight/Makefile                 |   1 +
>  drivers/video/backlight/sky81452-backlight.c     | 340 +++++++++++++++++++++++
>  include/linux/platform_data/sky81452-backlight.h |  46 +++
>  4 files changed, 397 insertions(+)
>  create mode 100644 drivers/video/backlight/sky81452-backlight.c
>  create mode 100644 include/linux/platform_data/sky81452-backlight.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 8d03924..2586fdd 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -409,6 +409,16 @@ config BACKLIGHT_PANDORA
>  	  If you have a Pandora console, say Y to enable the
>  	  backlight driver.
> 
> +config BACKLIGHT_SKY81452
> +	tristate "Backlight driver for SKY81452"
> +	depends on BACKLIGHT_CLASS_DEVICE && MFD_SKY81452
> +	help
> +	  If you have a Skyworks SKY81452, say Y to enable the
> +	  backlight driver.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called sky81452-backlight
> +
>  config BACKLIGHT_TPS65217
>  	tristate "TPS65217 Backlight"
>  	depends on BACKLIGHT_CLASS_DEVICE && MFD_TPS65217
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index fcd50b73..d67073f 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -50,6 +50,7 @@ obj-$(CONFIG_BACKLIGHT_PANDORA)		+= pandora_bl.o
>  obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
>  obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
>  obj-$(CONFIG_BACKLIGHT_SAHARA)		+= kb3886_bl.o
> +obj-$(CONFIG_BACKLIGHT_SKY81452)	+= sky81452-backlight.o
>  obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o
>  obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o
>  obj-$(CONFIG_BACKLIGHT_WM831X)		+= wm831x_bl.o
> diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-
> backlight.c
> new file mode 100644
> index 0000000..45e575f
> --- /dev/null
> +++ b/drivers/video/backlight/sky81452-backlight.c
> @@ -0,0 +1,340 @@
> +/*
> + * sky81452-backlight.c	SKY81452 backlight driver
> + *
> + * Copyright 2014 Skyworks Solutions Inc.
> + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_data/sky81452-backlight.h>
> +#include <linux/slab.h>
> +
> +/* registers */
> +#define SKY81452_REG0	0x00
> +#define SKY81452_REG1	0x01
> +#define SKY81452_REG2	0x02
> +#define SKY81452_REG4	0x04
> +#define SKY81452_REG5	0x05
> +
> +/* bit mask */
> +#define SKY81452_CS	0xFF
> +#define SKY81452_EN	0x3F
> +#define SKY81452_IGPW	0x20
> +#define SKY81452_PWMMD	0x10
> +#define SKY81452_PHASE	0x08
> +#define SKY81452_ILIM	0x04
> +#define SKY81452_VSHRT	0x03
> +#define SKY81452_OCP	0x80
> +#define SKY81452_OTMP	0x40
> +#define SKY81452_SHRT	0x3F
> +#define SKY81452_OPN	0x3F
> +
> +#define SKY81452_DEFAULT_NAME "lcd-backlight"
> +#define SKY81452_MAX_BRIGHTNESS	(SKY81452_CS + 1)
> +
> +#define CTZ(b) __builtin_ctz(b)
> +
> +static int sky81452_bl_update_status(struct backlight_device *bd)
> +{
> +	const struct sky81452_bl_platform_data *pdata =
> +			dev_get_platdata(bd->dev.parent);
> +	const unsigned int brightness = (unsigned int)bd->props.brightness;
> +	struct regmap *regmap = bl_get_data(bd);
> +	int ret;
> +
> +	if (brightness > 0) {
> +		ret = regmap_write(regmap, SKY81452_REG0, brightness - 1);
> +		if (IS_ERR_VALUE(ret))
> +			return ret;
> +
> +		return regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN,
> +					pdata->enable << CTZ(SKY81452_EN));
> +	}
> +
> +	return regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN, 0);
> +}
> +
> +static int sky81452_bl_get_brightness(struct backlight_device *bd)
> +{
> +	return bd->props.brightness;
> +}

Please remove sky81452_bl_get_brightness().
In the case of just returning 'props.brightness',
backglight core can also return 'props.brightness'.
So, there is no need to add sky81452_bl_get_brightness().

Please refer to the following patches.
  backlight: Remove trivial get_brightness implementations
  backlight: Show brightness even if get_brightness is not implemented

Others look good.
Thanks.

Best regards,
Jingoo Han

> +
> +static const struct backlight_ops sky81452_bl_ops = {
> +	.update_status = sky81452_bl_update_status,
> +	.get_brightness = sky81452_bl_get_brightness,
> +};
> +
> +static ssize_t sky81452_bl_store_enable(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned long value;
> +	int ret;
> +
> +	ret = kstrtoul(buf, 16, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	ret = regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN,
> +					value << CTZ(SKY81452_EN));
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	return count;
> +}
> +
> +static ssize_t sky81452_bl_show_open_short(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned int reg, value = 0;
> +	char tmp[3];
> +	int i, ret;
> +
> +	reg = !strcmp(attr->attr.name, "open") ? SKY81452_REG5 : SKY81452_REG4;
> +	ret = regmap_read(regmap, reg, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	if (value & SKY81452_SHRT) {
> +		*buf = 0;
> +		for (i = 0; i < 6; i++) {
> +			if (value & 0x01) {
> +				sprintf(tmp, "%d ", i + 1);
> +				strcat(buf, tmp);
> +			}
> +			value >>= 1;
> +		}
> +		strcat(buf, "\n");
> +	} else {
> +		strcpy(buf, "none\n");
> +	}
> +
> +	return strlen(buf);
> +}
> +
> +static ssize_t sky81452_bl_show_fault(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned int value = 0;
> +	int ret;
> +
> +	ret = regmap_read(regmap, SKY81452_REG4, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	*buf = 0;
> +
> +	if (value & SKY81452_OCP)
> +		strcat(buf, "over-current ");
> +
> +	if (value & SKY81452_OTMP)
> +		strcat(buf, "over-temperature");
> +
> +	strcat(buf, "\n");
> +	return strlen(buf);
> +}
> +
> +static DEVICE_ATTR(enable, S_IWGRP | S_IWUSR, NULL, sky81452_bl_store_enable);
> +static DEVICE_ATTR(open, S_IRUGO, sky81452_bl_show_open_short, NULL);
> +static DEVICE_ATTR(short, S_IRUGO, sky81452_bl_show_open_short, NULL);
> +static DEVICE_ATTR(fault, S_IRUGO, sky81452_bl_show_fault, NULL);
> +
> +static struct attribute *sky81452_bl_attribute[] = {
> +	&dev_attr_enable.attr,
> +	&dev_attr_open.attr,
> +	&dev_attr_short.attr,
> +	&dev_attr_fault.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group sky81452_bl_attr_group = {
> +	.attrs = sky81452_bl_attribute,
> +};
> +
> +#ifdef CONFIG_OF
> +static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
> +							struct device *dev)
> +{
> +	struct device_node *np = of_node_get(dev->of_node);
> +	struct sky81452_bl_platform_data *pdata;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(dev, "backlight node not found.\n");
> +		return ERR_PTR(-ENODATA);
> +	}
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		of_node_put(np);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	of_property_read_string(np, "name", &pdata->name);
> +	pdata->ignore_pwm = of_property_read_bool(np, "skyworks,ignore-pwm");
> +	pdata->dpwm_mode = of_property_read_bool(np, "skyworks,dpwm-mode");
> +	pdata->phase_shift = of_property_read_bool(np, "skyworks,phase-shift");
> +	pdata->gpio_enable = of_get_gpio(np, 0);
> +
> +	ret = of_property_read_u32(np, "skyworks,en-channels", &pdata->enable);
> +	if (IS_ERR_VALUE(ret))
> +		pdata->enable = SKY81452_EN >> CTZ(SKY81452_EN);
> +
> +	ret = of_property_read_u32(np, "skyworks,short-detection-threshold",
> +			&pdata->short_detection_threshold);
> +	if (IS_ERR_VALUE(ret))
> +		pdata->short_detection_threshold = 7;
> +
> +	ret = of_property_read_u32(np, "skyworks,current-limit",
> +			&pdata->boost_current_limit);
> +	if (IS_ERR_VALUE(ret))
> +		pdata->boost_current_limit = 2750;
> +
> +	of_node_put(np);
> +	return pdata;
> +}
> +#else
> +static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
> +							struct device *dev)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +#endif
> +
> +static int sky81452_bl_init_device(struct regmap *regmap,
> +		struct sky81452_bl_platform_data *pdata)
> +{
> +	unsigned int value;
> +
> +	value = pdata->ignore_pwm ? SKY81452_IGPW : 0;
> +	value |= pdata->dpwm_mode ? SKY81452_PWMMD : 0;
> +	value |= pdata->phase_shift ? 0 : SKY81452_PHASE;
> +
> +	if (pdata->boost_current_limit == 2300)
> +		value |= SKY81452_ILIM;
> +	else if (pdata->boost_current_limit != 2750)
> +		return -EINVAL;
> +
> +	if (pdata->short_detection_threshold < 4 ||
> +				pdata->short_detection_threshold > 7)
> +		return -EINVAL;
> +	value |= (7 - pdata->short_detection_threshold) << CTZ(SKY81452_VSHRT);
> +
> +	return regmap_write(regmap, SKY81452_REG2, value);
> +}
> +
> +static int sky81452_bl_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct regmap *regmap = dev_get_drvdata(dev->parent);
> +	struct sky81452_bl_platform_data *pdata = dev_get_platdata(dev);
> +	struct backlight_device *bd;
> +	struct backlight_properties props;
> +	const char *name;
> +	int ret;
> +
> +	if (!pdata) {
> +		pdata = sky81452_bl_parse_dt(dev);
> +		if (IS_ERR(pdata))
> +			return PTR_ERR(pdata);
> +	}
> +
> +	if (gpio_is_valid(pdata->gpio_enable)) {
> +		ret = devm_gpio_request_one(dev, pdata->gpio_enable,
> +					GPIOF_OUT_INIT_HIGH, "sky81452-en");
> +		if (IS_ERR_VALUE(ret)) {
> +			dev_err(dev, "failed to request GPIO. err=%d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	ret = sky81452_bl_init_device(regmap, pdata);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(dev, "failed to initialize. err=%d\n", ret);
> +		return ret;
> +	}
> +
> +	memset(&props, 0, sizeof(props));
> +	props.max_brightness = SKY81452_MAX_BRIGHTNESS,
> +	name = pdata->name ? pdata->name : SKY81452_DEFAULT_NAME;
> +	bd = devm_backlight_device_register(dev, name, dev, regmap,
> +						&sky81452_bl_ops, &props);
> +	if (IS_ERR(bd)) {
> +		dev_err(dev, "failed to register. err=%ld\n", PTR_ERR(bd));
> +		return PTR_ERR(bd);
> +	}
> +
> +	platform_set_drvdata(pdev, bd);
> +
> +	ret  = sysfs_create_group(&bd->dev.kobj, &sky81452_bl_attr_group);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(dev, "failed to create attribute. err=%d\n", ret);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int sky81452_bl_remove(struct platform_device *pdev)
> +{
> +	const struct sky81452_bl_platform_data *pdata =
> +						dev_get_platdata(&pdev->dev);
> +	struct backlight_device *bd = platform_get_drvdata(pdev);
> +
> +	sysfs_remove_group(&bd->dev.kobj, &sky81452_bl_attr_group);
> +
> +	bd->props.power = FB_BLANK_UNBLANK;
> +	bd->props.brightness = 0;
> +	backlight_update_status(bd);
> +
> +	if (gpio_is_valid(pdata->gpio_enable))
> +		gpio_set_value_cansleep(pdata->gpio_enable, 0);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id sky81452_bl_of_match[] = {
> +	{ .compatible = "skyworks,sky81452-backlight", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, sky81452_bl_of_match);
> +#endif
> +
> +static struct platform_driver sky81452_bl_driver = {
> +	.driver = {
> +		.name = "sky81452-backlight",
> +		.of_match_table = of_match_ptr(sky81452_bl_of_match),
> +	},
> +	.probe = sky81452_bl_probe,
> +	.remove = sky81452_bl_remove,
> +};
> +
> +module_platform_driver(sky81452_bl_driver);
> +
> +MODULE_DESCRIPTION("Skyworks SKY81452 backlight driver");
> +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/platform_data/sky81452-backlight.h b/include/linux/platform_data/sky81452-
> backlight.h
> new file mode 100644
> index 0000000..1231e9b
> --- /dev/null
> +++ b/include/linux/platform_data/sky81452-backlight.h
> @@ -0,0 +1,46 @@
> +/*
> + * sky81452.h	SKY81452 backlight driver
> + *
> + * Copyright 2014 Skyworks Solutions Inc.
> + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _SKY81452_BACKLIGHT_H
> +#define _SKY81452_BACKLIGHT_H
> +
> +/**
> + * struct sky81452_platform_data
> + * @name:	backlight driver name.
> +		If it is not defined, default name is lcd-backlight.
> + * @gpio_enable:GPIO number which control EN pin
> + * @enable:	Enable mask for current sink channel 1, 2, 3, 4, 5 and 6.
> + * @ignore_pwm:	true if DPWMI should be ignored.
> + * @dpwm_mode:	true is DPWM dimming mode, otherwise Analog dimming mode.
> + * @phase_shift:true is phase shift mode.
> + * @short_detecion_threshold:	It should be one of 4, 5, 6 and 7V.
> + * @boost_current_limit:	It should be one of 2300, 2750mA.
> + */
> +struct sky81452_bl_platform_data {
> +	const char *name;
> +	int gpio_enable;
> +	unsigned int enable;
> +	bool ignore_pwm;
> +	bool dpwm_mode;
> +	bool phase_shift;
> +	unsigned int short_detection_threshold;
> +	unsigned int boost_current_limit;
> +};
> +
> +#endif
> --
> 1.9.1

