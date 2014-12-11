Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaLKBqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:46:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55068 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaLKBqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:46:33 -0500
X-AuditID: cbfee68f-f791c6d000004834-f0-5488f77626b7
Message-id: <5488F775.1030304@samsung.com>
Date: Thu, 11 Dec 2014 10:46:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] extcon: add MAX3355 driver
References: <14631865.01KLlU2iKL@wasted.cogentembedded.com>
In-reply-to: <14631865.01KLlU2iKL@wasted.cogentembedded.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkULfse0eIwYxOcYv5R86xWvS/Wchq
	ceDPDkaLc69WMlpc3jWHzWLOnynMFouWtTJbLL1+kcniduMKNosJ09eyWLTuPcJucWbVLXYH
	Ho8189Ywelzu62XyeDD1P5PHyuVf2Dw2repk87hzbQ+bR9+WVYwenzfJBXBEcdmkpOZklqUW
	6dslcGW8ap/NXLDOuuLi64oGxhP6XYycHBICJhKdDW2MELaYxIV769m6GLk4hASWMkqsPriL
	DaZo6ddbYEVCAtMZJdZ+54Uoes0o0fFjIztIgldAS2LK+d9gDSwCqhLr1p5jArHZgOL7X9wA
	i4sKhEmsnH6FBaJeUOLH5HtgtoiAhcTdxkUsIEOZBeYzSUw8sAGsQVhAX+LFxddsEJutJZ5/
	6wKzOQVsJD4vXwt2EbOAjsT+1mlsELa8xOY1b5khrm7lkFhz3w3iIAGJb5MPAS3gAIrLSmw6
	AFUiKXFwxQ2WCYxis5CcNAvJ1FlIpi5gZF7FKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERjF
	p/8969/BePeA9SFGAQ5GJR7eFVfbQ4RYE8uKK3MPMZoCXTGRWUo0OR+YKvJK4g2NzYwsTE1M
	jY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDYe9xJZPNJ3mDbtzlVMX8r
	Hb73J8y7NV2KX198UfXsRT+Ub4arSog8CAo9+O1VcVqD0HSdzde091yxiJazm+mw/VeuL8+e
	v+xm7hqzGKYuqYo9dG+3ycbcL+xZTU95bJ01lz5f6sButP1tyKQ5xtnLiqbuFfbf5PW16+wd
	xhM9YksDJRJ6lbOUWIozEg21mIuKEwF1V+153QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd2y7x0hBjdm8lrMP3KO1aL/zUJW
	iwN/djBanHu1ktHi8q45bBZz/kxhtli0rJXZYun1i0wWtxtXsFlMmL6WxaJ17xF2izOrbrE7
	8HismbeG0eNyXy+Tx4Op/5k8Vi7/wuaxaVUnm8eda3vYPPq2rGL0+LxJLoAjqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqv22cwF66wrLr6uaGA8od/FyMkhIWAisfTr
	LUYIW0ziwr31bCC2kMB0Rom133m7GLmA7NeMEh0/NrKDJHgFtCSmnP8NVsQioCqxbu05JhCb
	DSi+/8UNsLioQJjEyulXWCDqBSV+TL4HZosIWEjcbVzEAjKUWWA+k8TEAxvAGoQF9CVeXHwN
	tdla4vm3LjCbU8BG4vPytWDXMQvoSOxvncYGYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgJPFMegfjqgaLQ4wCHIxKPLwBl9tDhFgTy4orcw8x
	SnAwK4nwJt3oCBHiTUmsrEotyo8vKs1JLT7EaAoMgonMUqLJ+cAEllcSb2hsYmZkaWRuaGFk
	bK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwFh+kDHbuLjx1JW1GW9kw75yfDRafJH3+qa9
	bCU9NeKtRSeOqLdKHN0ZEKh9fOKEd49ufdvx7/iFrrKz19qq+GbtOzPj7p/Vn1WL/y6+EHkt
	m/dAkOYDjRr77zYLlyyfXVvCLM89LX3jbuvas9HPtfmWxc5Yalfe91/7ZDV3n7+p8/WFTXPL
	HsYpsRRnJBpqMRcVJwIAVgCRySgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

I reviewed this patch quickly. This driver has just two gpio without any registers for IP.
I wonder whether MAX3355E is separate chip to detect external connector or just use gpio of AP.

Could you send the datasheet of MAX3355E to me?

Thanks,
Chanwoo Choi

On 12/11/2014 08:28 AM, Sergei Shtylyov wrote:
> MAX3355E chip integrates a charge pump and comparators to enable a system with
> an integrated USB OTG dual-role transceiver to function as a USB OTG dual-role
> device. In addition to sensing/controlling Vbus, the chip also passes thru the
> ID signal from the USB OTG connector.  On some Renesas boards, this signal  is
> just  fed into the SoC thru a GPIO pin -- there's no real OTG controller, only
> host and gadget USB controllers sharing the same USB bus; however,  we'd  like
> to allow host or gadget drivers to be loaded depending on the cable type, hence
> the need for the MAX3355 extcon driver. The Vbus status signals are also wired
> to GPIOs (however, we're not currently intested in them), the  OFFVBUS# signal
> is controlled  by the host controllers, there's also the SHDN# signal wired to
> GPIO, which should be high for normal operation.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> The patch is against the 'extcon-next' branch of the 'extcon.git' repo.
> 
>  Documentation/devicetree/bindings/extcon/extcon-max3355.txt |   21 ++
>  drivers/extcon/Kconfig                                      |    6 
>  drivers/extcon/Makefile                                     |    1 
>  drivers/extcon/extcon-max3355.c                             |  122 ++++++++++++
>  4 files changed, 150 insertions(+)
> 
> Index: extcon/Documentation/devicetree/bindings/extcon/extcon-max3355.txt
> ===================================================================
> --- /dev/null
> +++ extcon/Documentation/devicetree/bindings/extcon/extcon-max3355.txt
> @@ -0,0 +1,21 @@
> +MAX3355 USB OTG chip
> +--------------------
> +
> +MAX3355 integrates a charge pump and comparators to enable a system with an
> +integrated USB OTG dual-role transceiver to function as a USB OTG dual-role
> +device.
> +
> +Required properties:
> +- compatible: should be "maxim,max3355";
> +- maxim,shdn-gpio: should contain a phandle and GPIO specifier for the GPIO pin
> +  connected to the MAX3355's SHDN# pin;
> +- maxim,id-gpio: should contain a phandle and GPIO specifier for the GPIO pin
> +  connected to the MAX3355's ID_OUT pin.
> +
> +Example (Koelsch board):
> +
> +	usb-otg {
> +		compatible = "maxim,max3355";
> +		maxim,shdn-gpio = <&gpio2 4 GPIO_ACTIVE_LOW>;
> +		maxim,id-gpio = <&gpio5 31 GPIO_ACTIVE_HIGH>;
> +	};
> Index: extcon/drivers/extcon/Kconfig
> ===================================================================
> --- extcon.orig/drivers/extcon/Kconfig
> +++ extcon/drivers/extcon/Kconfig
> @@ -45,6 +45,12 @@ config EXTCON_MAX14577
>  	  Maxim MAX14577/77836. The MAX14577/77836 MUIC is a USB port accessory
>  	  detector and switch.
>  
> +config EXTCON_MAX3355
> +	tristate "MAX3355 USB OTG EXTCON Support"
> +	help
> +	  Say Y here to enable support for the USB host detection by MAX3355
> +	  OTG USB chip.
> +
>  config EXTCON_MAX77693
>  	tristate "MAX77693 EXTCON Support"
>  	depends on MFD_MAX77693 && INPUT
> Index: extcon/drivers/extcon/Makefile
> ===================================================================
> --- extcon.orig/drivers/extcon/Makefile
> +++ extcon/drivers/extcon/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-
>  obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
>  obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
>  obj-$(CONFIG_EXTCON_MAX14577)	+= extcon-max14577.o
> +obj-$(CONFIG_EXTCON_MAX3355)	+= extcon-max3355.o
>  obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
>  obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
> Index: extcon/drivers/extcon/extcon-max3355.c
> ===================================================================
> --- /dev/null
> +++ extcon/drivers/extcon/extcon-max3355.c
> @@ -0,0 +1,122 @@
> +/*
> + * MAX3355 USB OTG chip extcon driver
> + *
> + * Copyright (C) 2014 Cogent Embedded, Inc.
> + * Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + */
> +
> +#include <linux/extcon.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +struct max3355_data {
> +	struct extcon_dev *edev;
> +	int id_gpio;
> +};
> +
> +static const char *max3355_cable[] = {
> +	[0] = "USB-HOST",
> +	NULL,
> +};
> +
> +static irqreturn_t max3355_id_irq(int irq, void *dev_id)
> +{
> +	struct max3355_data *data = dev_id;
> +	int id = gpio_get_value(data->id_gpio);
> +
> +	extcon_set_cable_state(data->edev, "USB-HOST", !id);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int max3355_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct max3355_data *data;
> +	int gpio, irq, ret;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(struct max3355_data),
> +			    GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->edev = devm_extcon_dev_allocate(&pdev->dev, max3355_cable);
> +	if (IS_ERR(data->edev)) {
> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
> +		return PTR_ERR(data->edev);
> +	}
> +	data->edev->name = kstrdup(np->name, GFP_KERNEL);
> +
> +	gpio = of_get_named_gpio(np, "maxim,id-gpio", 0);
> +	if (gpio < 0)
> +		return gpio;
> +	data->id_gpio = gpio;
> +
> +	gpio = of_get_named_gpio(np, "maxim,shdn-gpio", 0);
> +	if (gpio < 0)
> +		return gpio;
> +
> +	ret = devm_gpio_request_one(&pdev->dev, gpio, GPIOF_DIR_OUT |
> +				    GPIOF_INIT_HIGH, pdev->name);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = devm_gpio_request_one(&pdev->dev, data->id_gpio, GPIOF_DIR_IN,
> +				    pdev->name);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = devm_extcon_dev_register(&pdev->dev, data->edev);
> +	if (ret < 0)
> +		return ret;
> +
> +	irq = gpio_to_irq(data->id_gpio);
> +	if (irq < 0)
> +		return irq;
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, max3355_id_irq,
> +					IRQF_TRIGGER_RISING |
> +					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +					pdev->name, data);
> +	if (ret < 0)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	/* Perform initial detection */
> +	max3355_id_irq(irq, data);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id max3355_match_table[] = {
> +	{ .compatible = "maxim,max3355", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, max3355_match_table);
> +
> +static struct platform_driver max3355_driver = {
> +	.probe		= max3355_probe,
> +	.driver		= {
> +		.name	= "extcon-max3355",
> +		.of_match_table = max3355_match_table,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(max3355_driver);
> +
> +MODULE_AUTHOR("Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>");
> +MODULE_DESCRIPTION("MAX3355 extcon driver");
> +MODULE_LICENSE("GPL v2");
> 
> 

