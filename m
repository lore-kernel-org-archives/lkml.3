Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3H2Bfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:35:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3H2Bfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:35:33 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-48-521ea56242a9
Message-id: <521EA563.4060305@samsung.com>
Date: Thu, 29 Aug 2013 10:35:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: balbi@ti.com, myungjoo.ham@samsung.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com,
        davidb@codeaurora.org, arnd@arndb.de, swarren@nvidia.com,
        popcornmix@gmail.com
Subject: Re: [PATCH v3 1/3] extcon: extcon-gpio-usbvid: Generic USB VBUS/ID
 detection via GPIO
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com>
 <1377711185-31238-2-git-send-email-george.cherian@ti.com>
In-reply-to: <1377711185-31238-2-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWyRsSkRDdpqVyQQdNMTYu/k46xWxy8X29x
	Z/5fVovHy/+xWcw/co7V4tTB5awWB/7sYLR409vBYrGwbQmLxeVdc9gsZi/pZ7FYtKyV2WLp
	9YtMFrcbV7BZTJi+lsWi67W8xeEVB5gs1r2czmJxY3oLq8Wrg20sDiIea+atYfT4/WsSo8f7
	G63sHgs+X2H3eD15AqPH5b5eJo+ds+6ye7xaPZPV4861PWwevc3v2Dz6tqxi9Dh+YzuTx+dN
	ch4b54YG8EVx2aSk5mSWpRbp2yVwZSw6P4O9YGlexeJdKg2Mp8O7GDk5JARMJC6fnsIOYYtJ
	XLi3nq2LkYtDSGApo8THV0uZYIpuX73ODpFYxCjR/HMKK4TzilHi2fJzjCBVvAJaEt9PX2cG
	sVkEVCXeT9nBBmKzAcX3v7gBZosKhEmsnH6FBaJeUOLH5HtgtghQTf+lbiaQocwCx5gl1k7d
	CTZIWCBB4vOc7ywQ2xoZJS483QaW4BRwk3j5fBnYZmYBHYn9rdPYIGx5ic1r3jKDNEgIvOGQ
	mNi0iA3iJAGJb5MPAU3iAErISmw6wAzxm6TEwRU3WCYwis1CctQsJGNnIRm7gJF5FaNoakFy
	QXFSepGpXnFibnFpXrpecn7uJkZgQjn979nEHYz3D1gfYkwGWjmRWUo0OR+YkPJK4g2NzYws
	TE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGiuJBc7Sanasvxh
	pcGhh5Xz60+a3nKxsdIS/VZUKXzvc8q1Uv0JMWdDwwL9Tz4TO2D7qdLh+Ie0vtwFX40Mv4i8
	4fDZ5tQecXC649WC1Hc3lqZyGVxo1I9tbJgSYNBTEut77s0q92kt4fVie08fnPLDqkB3t7uz
	mP6m9vnGj5nz6iTyeJNuKrEUZyQaajEXFScCAEcK7dI+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xgG7SUrkgg9sXpC3+TjrGbnHwfr3F
	nfl/WS0eL//HZjH/yDlWi1MHl7NaHPizg9HiTW8Hi8XCtiUsFpd3zWGzmL2kn8Vi0bJWZoul
	1y8yWdxuXMFmMWH6WhaLrtfyFodXHGCyWPdyOovFjektrBavDraxOIh4rJm3htHj969JjB7v
	b7Syeyz4fIXd4/XkCYwel/t6mTx2zrrL7vFq9UxWjzvX9rB59Da/Y/Po27KK0eP4je1MHp83
	yXlsnBsawBfVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA/SykkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj0fkZ7AVL8yoW
	71JpYDwd3sXIySEhYCJx++p1dghbTOLCvfVsXYxcHEICixglmn9OYYVwXjFKPFt+jhGkildA
	S+L76evMIDaLgKrE+yk72EBsNqD4/hc3wGxRgTCJldOvsEDUC0r8mHwPzBYBqum/1M0EMpRZ
	4BizxNqpO8EGCQskSHye850FYlsjo8SFp9vAEpwCbhIvny8D28wsoCOxv3UaG4QtL7F5zVvm
	CYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgtPVM+kdjKsaLA4x
	CnAwKvHwRvyWDRJiTSwrrsw9xCjBwawkwjslUy5IiDclsbIqtSg/vqg0J7X4EGMyMAwmMkuJ
	JucDU2leSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAabxI8
	r/8i92ZZ0N7gRX2/jvTmRcU+/rKRa42r+1en6VetL1yfWuN8dEnXm5MHLr4UXTPLKDJw1q8V
	5SfErUX2KDnNftR+r/zU11uGB4I1jvkzNATOEnIUz0vZXOEgK1TI+dMrsCM531ZJ+uSXTQa5
	4VoZsg0hUpt01hzbzpex5PFHsdp3898psRRnJBpqMRcVJwIA1CpFypsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

You didn't modify this patchset about my comment on v1 patchset.
Please pay attention to comment.

On 08/29/2013 02:33 AM, George Cherian wrote:
> Add a generic USB VBUS/ID detection EXTCON driver. This driver expects
> the ID/VBUS pin are connected via GPIOs. This driver is tested on
> DRA7x board were the ID pin is routed via GPIOs. The driver supports
> both VBUS and ID pin configuration and ID pin only configuration.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  .../bindings/extcon/extcon-gpio-usbvid.txt         |  20 ++
>  drivers/extcon/Kconfig                             |   6 +
>  drivers/extcon/Makefile                            |   1 +
>  drivers/extcon/extcon-gpio-usbvid.c                | 286 +++++++++++++++++++++

You should keep following naming stlye. extcon-gpio-usbvid.c is wrong naming style.
- extcon-[device name].c
- extcon-gpio-usbvid.c -> extcon-dra7xx.c or etc.

Also, you should change the file name of extcon-gpio-usbvid.txt.

Finally, You used 'gpio_usbvid' prefix in extcon-gpio-usbvid.c.
It has caused the confusion that user would think extcon-gpio-usbvid.c driver
support all of extcon driver using gpio irq pin. So I'd like you to use
proper prefix including device name.

>  4 files changed, 313 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
>  create mode 100644 drivers/extcon/extcon-gpio-usbvid.c
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
> new file mode 100644
> index 0000000..eea0741
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
> @@ -0,0 +1,20 @@
> +EXTCON FOR USB VIA GPIO
> +
> +Required Properties:
> + - compatible : Should be "ti,gpio-usb-vid" for USB VBUS-ID detector
> +		using gpios or "ti,gpio-usb-id" for USB ID pin detector
> + - gpios : phandle and args ID pin gpio and VBUS gpio.
> +	   The first gpio used  for ID pin detection
> +	   and the second used for VBUS detection.
> +	   ID pin gpio is mandatory and VBUS is optional
> +	   depending on implementation.
> +
> +Please refer to ../gpio/gpio.txt for details of the common GPIO bindings
> +
> +Example:
> +
> +	gpio_usbvid_extcon1 {
> +		compatible = "ti,gpio-usb-vid";
> +		gpios = <&gpio1 1 0>,
> +			<&gpio2 2 0>;
> +	};
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index f1d54a3..8097398 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -64,4 +64,10 @@ config EXTCON_PALMAS
>  	  Say Y here to enable support for USB peripheral and USB host
>  	  detection by palmas usb.
>  
> +config EXTCON_GPIO_USBVID
> +	tristate "Generic USB VBUS/ID detection using GPIO EXTCON support"
> +	help
> +	  Say Y here to enable support for USB VBUS/ID deetction by GPIO.
> +
> +

Remove blank line.

>  endif # MULTISTATE_SWITCH
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index e4fa8ba..0451f698 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
>  obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>  obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
> +obj-$(CONFIG_EXTCON_GPIO_USBVID)	+= extcon-gpio-usbvid.o
> diff --git a/drivers/extcon/extcon-gpio-usbvid.c b/drivers/extcon/extcon-gpio-usbvid.c
> new file mode 100644
> index 0000000..e9bc2a97
> --- /dev/null
> +++ b/drivers/extcon/extcon-gpio-usbvid.c
> @@ -0,0 +1,286 @@
> +/*
> + * Generic  USB VBUS-ID pin detection driver
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: George Cherian <george.cherian@ti.com>
> + *
> + * Based on extcon-palmas.c
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>

kthead.h, freezer.h headerfile is used in this file?

> +#include <linux/platform_device.h>
> +#include <linux/extcon.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>

Order headerfile alphabetically.

> +
> +struct gpio_usbvid {
> +	struct device *dev;
> +
> +	struct extcon_dev edev;
> +
> +	/*GPIO pin */

I commented previous your patch about this wrong coding style.
Why did not you fix this coding style?

> +	int id_gpio;
> +	int vbus_gpio;
> +
> +	int id_irq;
> +	int vbus_irq;
> +	int type;
> +};
> +
> +static const char *dra7xx_extcon_cable[] = {
> +	[0] = "USB",
> +	[1] = "USB-HOST",
> +	NULL,
> +};
> +
> +static const int mutually_exclusive[] = {0x3, 0x0};
> +
> +/* Two types of support are provided.
> + * Systems which has
> + *	1) VBUS and ID pin connected via GPIO
> + *	2)  only ID pin connected via GPIO

Remove blank between '2)' and 'only'.

> + *  For Case 1 both the gpios should be provided via DT
> + *  Always the first GPIO in dt is considered ID pin GPIO
> + */
> +
> +enum {
> +	UNKNOWN = 0,
> +	ID_DETECT,
> +	VBUS_ID_DETECT,
> +};
> +
> +#define ID_GND		0
> +#define ID_FLOAT	1
> +#define VBUS_OFF	0
> +#define VBUS_ON		1

I think you could only use two constant instead of four constant definition.

> +
> +

This blank line isn't necessary.

> +static irqreturn_t id_irq_handler(int irq, void *data)
> +{
> +	struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;

You should delete blank between ')' and 'data' as follwong: 
	- (struct gpio_usbvid *)data;

> +	int id_current;
> +
> +	id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
> +	if (id_current == ID_GND) {
> +		if (gpio_usbvid->type == ID_DETECT)
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", false);
> +		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);

As else statement, you should set "USB-HOST" cable state to improve readability.

		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
		if (gpio_usbvid->type == ID_DETECT)
			extcon_set_cable_state(&gpio_usbvid->edev,
							"USB", false);

> +	} else {
> +		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
> +		if (gpio_usbvid->type == ID_DETECT)
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", true);
> +	}

Add blank line.

> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t vbus_irq_handler(int irq, void *data)
> +{
> +	struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;

ditto.

> +	int vbus_current;
> +
> +	vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
> +	if (vbus_current == VBUS_OFF)
> +		extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
> +	else
> +		extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +

This blank line isn't necessary.
I commented unnecessary blank line on previous review.

> +static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
> +{
> +	int id_current;
> +	int vbus_current;

Define loacal variable on one line as following:
	int id_current, vbus_current;

> +
> +	switch (gpio_usbvid->type) {
> +	case ID_DETECT:
> +		id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
> +		if (!!id_current == ID_FLOAT) {
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB-HOST", false);
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", true);
> +		} else {
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", false);
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB-HOST", true);
> +		}
> +		break;
> +
> +	case VBUS_ID_DETECT:
> +		id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
> +		if (!!id_current == ID_FLOAT)
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB-HOST", false);
> +		else
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB-HOST", true);
> +
> +		vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
> +		if (!!vbus_current == VBUS_ON)
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", true);
> +		else
> +			extcon_set_cable_state(&gpio_usbvid->edev,
> +							"USB", false);
> +		break;
> +
> +	default:
> +		dev_err(gpio_usbvid->dev, "Unknown VBUS-ID type\n");
> +	}
> +}
> +
> +static int gpio_usbvid_request_irq(struct gpio_usbvid *gpio_usbvid)
> +{
> +	int ret;

Add blank line.

> +	ret = devm_request_threaded_irq(gpio_usbvid->dev, gpio_usbvid->id_irq,
> +					NULL, id_irq_handler,
> +					IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
> +					dev_name(gpio_usbvid->dev),
> +					(void *) gpio_usbvid);
> +	if (ret) {
> +		dev_err(gpio_usbvid->dev, "failed to request id irq #%d\n",
> +					gpio_usbvid->id_irq);
> +		return ret;
> +	}
> +	if (gpio_usbvid->type == VBUS_ID_DETECT) {
> +		ret = devm_request_threaded_irq(gpio_usbvid->dev,
> +					gpio_usbvid->vbus_irq, NULL,
> +					vbus_irq_handler,
> +					IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
> +					dev_name(gpio_usbvid->dev),

Why do you use the same interrupt name both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq?
You should use characteristic interrupt name.

> +					(void *) gpio_usbvid);
> +		if (ret)
> +			dev_err(gpio_usbvid->dev, "failed to request vbus irq #%d\n",
> +						gpio_usbvid->vbus_irq);
> +	}

Add blank line.

> +	return ret;
> +}
> +
> +static int gpio_usbvid_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct gpio_usbvid *gpio_usbvid;
> +	int ret;
> +	int gpio;

Define loacal variable on one line as following:
	int ret, gpio;

> +
> +	gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid),
> +								GFP_KERNEL);

If this statement over 80 line, you have to keep proper indentation as following:
	gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid),
				  GFP_KERNEL);

> +	if (!gpio_usbvid)
> +		return -ENOMEM;
> +
> +

Remove blank line.

> +	gpio_usbvid->dev	 = &pdev->dev;

Use space instead of tab.

> +
> +	platform_set_drvdata(pdev, gpio_usbvid);
> +
> +	gpio_usbvid->edev.name = dev_name(&pdev->dev);

I add as follwong comment about your v1 patchset

	"If edev name is equal with device name, this line is unnecessary.
	Because extcon_dev_register() use dev_name(&pdev->dev) as edev name
	in extcon-class.c"

Why did not apply for my comment to v3 patchset?
Plesae pay attention for previous comment.

> +	gpio_usbvid->edev.supported_cable = dra7xx_extcon_cable;
> +	gpio_usbvid->edev.mutually_exclusive = mutually_exclusive;
> +
> +	if (of_device_is_compatible(node, "ti,gpio-usb-id"))
> +		gpio_usbvid->type = ID_DETECT;
> +
> +	gpio = of_get_gpio(node, 0);
> +	if (gpio_is_valid(gpio)) {
> +		gpio_usbvid->id_gpio = gpio;
> +		ret = devm_gpio_request(&pdev->dev, gpio_usbvid->id_gpio,
> +					"id_gpio");
> +		if (ret)
> +			return ret;

Add blank line.

> +		gpio_usbvid->id_irq = gpio_to_irq(gpio_usbvid->id_gpio);
> +	} else {
> +		dev_err(&pdev->dev, "failed to get id gpio\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_device_is_compatible(node, "ti,gpio-usb-vid")) {
> +		gpio_usbvid->type = VBUS_ID_DETECT;
> +		gpio = of_get_gpio(node, 1);
> +		if (gpio_is_valid(gpio)) {
> +			gpio_usbvid->vbus_gpio = gpio;
> +			ret = devm_gpio_request(&pdev->dev,
> +						gpio_usbvid->vbus_gpio,
> +						"vbus_gpio");
> +			if (ret)
> +				return ret;

Add blank line.

> +			gpio_usbvid->vbus_irq =
> +					gpio_to_irq(gpio_usbvid->vbus_gpio);
> +		} else {
> +			dev_err(&pdev->dev, "failed to get vbus gpio\n");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	ret = extcon_dev_register(&gpio_usbvid->edev, gpio_usbvid->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register extcon device\n");
> +		return ret;
> +	}
> +
> +	gpio_usbvid_set_initial_state(gpio_usbvid);
> +	ret = gpio_usbvid_request_irq(gpio_usbvid);

You should move gpio_usbvid_request_irq() call before extcon_dev_register().

> +	if (ret)
> +		goto err0;

? As following previous comment about v1 patchset:
	I need correct meaning name as err_thread or etc ...

> +
> +	return 0;
> +
> +err0:

ditto.

> +	extcon_dev_unregister(&gpio_usbvid->edev);
> +
> +	return ret;
> +}
> +
> +static int gpio_usbvid_remove(struct platform_device *pdev)
> +{
> +	struct gpio_usbvid *gpio_usbvid = platform_get_drvdata(pdev);
> +
> +	extcon_dev_unregister(&gpio_usbvid->edev);
> +	return 0;
> +}
> +
> +static struct of_device_id of_gpio_usbvid_match_tbl[] = {
> +	{ .compatible = "ti,gpio-usb-vid", },
> +	{ .compatible = "ti,gpio-usb-id", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver gpio_usbvid_driver = {
> +	.probe = gpio_usbvid_probe,
> +	.remove = gpio_usbvid_remove,
> +	.driver = {
> +		.name = "gpio-usbvid",
> +		.of_match_table = of_gpio_usbvid_match_tbl,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(gpio_usbvid_driver);
> +
> +MODULE_ALIAS("platform:gpio-usbvid");
> +MODULE_AUTHOR("George Cherian <george.cherian@ti.com>");
> +MODULE_DESCRIPTION("GPIO based USB Connector driver");
> +MODULE_LICENSE("GPL");
> +MODULE_DEVICE_TABLE(of, of_gpio_usbvid_match_tbl);
> 

Cheers,
Chanwoo Choi
