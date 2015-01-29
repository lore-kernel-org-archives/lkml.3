Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbbA2CXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:23:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10287 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbbA2BtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:49:15 -0500
X-AuditID: cbfee68d-f79296d000004278-94-54c99197f2d7
Message-id: <54C99197.5070605@samsung.com>
Date: Thu, 29 Jan 2015 10:49:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Roger Quadros <rogerq@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com, tony@atomide.com,
        george.cherian@ti.com, nsekhar@ti.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] extcon: usb-gpio: Introduce gpio usb extcon driver
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
 <1422274532-9488-2-git-send-email-rogerq@ti.com> <54C8D2F4.9050404@ti.com>
In-reply-to: <54C8D2F4.9050404@ti.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWHf6xJMhBg9+ylscvF9vMf/IOVaL
	UweXs1pc3jWHzWL2kn4Wi0XLWpktbjeuYLPY37uByaLnkZbF/iteDlwe375OYvHo27KK0eP4
	je1MHp83yQWwRHHZpKTmZJalFunbJXBlrHsyl7lgoWPF9WlnGRsY75h0MXJySAiYSHw628IG
	YYtJXLi3HswWEljKKPFpvXEXIwdYzfRV0V2MXEDh6YwS+xZ8YYJwXjNKNJzYyw7SwCugJbHl
	YDtYM4uAqsTSWc8ZQWw2oPj+FzfA4qICYRIrp19hgagXlPgx+R6YLSKgKHFvJchiLg5mgVuM
	EhN2HmQCSQgL+ElseH2bBWJbJ6PEvUeT2EBO4hRQk5izjBfEZBbQk7h/UQuknFlAXmLzmrfM
	IOUSArfYJd7sncYIcZCAxLfJh1ggvpGV2HSAGeJhSYmDK26wTGAUm4XkpFkIU2chmbqAkXkV
	o2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmAEnv73rHcH4+0D1ocYBTgYlXh4ExpPhgixJpYV
	V+YeYjQFOmIis5Rocj4wzvNK4g2NzYwsTE1MjY3MLc2UxHkVpX4GCwmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamAUcPOPq3wZtTL+MouY3z2V5mLX9U8cN7reTukK37rw68SY0rapOw/9kolM
	dNFp3720filjd/pST6vegp/Nwmr9l6y0Ph4Qm1upb/V134Fge5nHOTVr57xqvbB5ssyfJTFK
	ridfXJE9zv3ZYsKG9vgHXUaf/j568W6DU2q7XYPG6+tfehed1dNVYinOSDTUYi4qTgQAsbjW
	HrsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd3pE0+GGLzrFbM4eL/eYv6Rc6wW
	pw4uZ7W4vGsOm8XsJf0sFouWtTJb3G5cwWaxv3cDk0XPIy2L/Ve8HLg8vn2dxOLRt2UVo8fx
	G9uZPD5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLHuyVzmgoWO
	FdennWVsYLxj0sXIwSEhYCIxfVV0FyMnkCkmceHeerYuRi4OIYHpjBL7FnxhgnBeM0o0nNjL
	DlLFK6AlseVgOxuIzSKgKrF01nNGEJsNKL7/xQ2wuKhAmMTK6VdYIOoFJX5MvgdmiwgoStxb
	CbGBWeAWo8SEnQeZQBLCAn4SG17fZoHY1skoce/RJDaQ8zgF1CTmLOMFMZkF9CTuX9QCKWcW
	kJfYvOYt8wRGgVlIVsxCqJqFpGoBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAIfya9
	g3FVg8UhRgEORiUe3oTGkyFCrIllxZW5hxglOJiVRHivNwOFeFMSK6tSi/Lji0pzUosPMZoC
	A2Ais5Rocj4w+eSVxBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTAW
	HV7/74Xf1w+77st5XIoruBsm126+PPMJT+wfPs7Tk05+udHw+92RSy9Vtq16sNDl08T6fZnx
	t5gW//s6fU+KQFyXSvq81ZkS3mG3lVv77scum/qhtzuqv/R47warb9qmka++7Nfvt1CYt3Bl
	3X71Nh7T9OSCbx5Ly8x/JffO+1h47+dS5jniSizFGYmGWsxFxYkAEWEOyAYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

We need to discuss one point about 'id_irqwake'.
I don't recommend to use 'id_irqwake' field.

And I catch build warning by using "select" keywork in Kconfig.
It is my wrong guide of "select" keyword. So, I'll change it 
as 'depends on' keyword.

Looks good to me except for 'id_irqwake'. 
I'll apply this patch on 3.21 queue after completing this discussion.

On 01/28/2015 09:15 PM, Roger Quadros wrote:
> This driver observes the USB ID pin connected over a GPIO and
> updates the USB cable extcon states accordingly.
> 
> The existing GPIO extcon driver is not suitable for this purpose
> as it needs to be taught to understand USB cable states and it
> can't handle more than one cable per instance.
> 
> For the USB case we need to handle 2 cable states.
> 1) USB (attach/detach)
> 2) USB-Host (attach/detach)
> 
> This driver can be easily updated in the future to handle VBUS
> events in case it happens to be available on GPIO for any platform.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
> v3:
> - removed IRQF_NO_SUSPEND flag. Added IRQF_TRIGGER_RISING and
>   IRQF_TRIGGER_FALLING
> - Added disable_irq() to suspend() and enable_irq() to resume()
> 
>  .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  18 ++
>  drivers/extcon/Kconfig                             |   7 +
>  drivers/extcon/Makefile                            |   1 +
>  drivers/extcon/extcon-usb-gpio.c                   | 233 +++++++++++++++++++++
>  4 files changed, 259 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>  create mode 100644 drivers/extcon/extcon-usb-gpio.c
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
> new file mode 100644
> index 0000000..85fe6b0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
> @@ -0,0 +1,18 @@
> +USB GPIO Extcon device
> +
> +This is a virtual device used to generate USB cable states from the USB ID pin
> +connected to a GPIO pin.
> +
> +Required properties:
> +- compatible: Should be "linux,extcon-usb-gpio"
> +- id-gpio: gpio for USB ID pin. See gpio binding.
> +
> +Example:
> +	extcon_usb1 {
> +		compatible = "linux,extcon-usb-gpio";
> +		id-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
> +	}
> +
> +	&omap_dwc3_1 {
> +		extcon = <&extcon_usb1>;
> +	};
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6a1f7de..fd11536 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -93,4 +93,11 @@ config EXTCON_SM5502
>  	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
>  	  detector and switch.
>  
> +config EXTCON_USB_GPIO
> +	tristate "USB GPIO extcon support"
> +	select GPIOLIB

I catch the build warning if using 'select' instead of 'depends on' as following:
It is my wrong guide to you. So, I'll modify it by using "depends on" as your original patch.

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- zImage  -j 8
scripts/kconfig/conf --silentoldconfig Kconfig
drivers/gpio/Kconfig:34:error: recursive dependency detected!
drivers/gpio/Kconfig:34:	symbol GPIOLIB is selected by EXTCON_USB_GPIO
drivers/extcon/Kconfig:96:	symbol EXTCON_USB_GPIO depends on EXTCON
drivers/extcon/Kconfig:1:	symbol EXTCON is selected by CHARGER_MANAGER
drivers/power/Kconfig:316:	symbol CHARGER_MANAGER depends on POWER_SUPPLY
drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
drivers/hid/Kconfig:670:	symbol HID_SONY depends on NEW_LEDS
drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by BCMA_DRIVER_GPIO
drivers/bcma/Kconfig:75:	symbol BCMA_DRIVER_GPIO depends on GPIOLIB

> +	help
> +	  Say Y here to enable GPIO based USB cable detection extcon support.
> +	  Used typically if GPIO is used for USB ID pin detection.
> +
>  endif # MULTISTATE_SWITCH
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 0370b42..6a08a98 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
>  obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
>  obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
> +obj-$(CONFIG_EXTCON_USB_GPIO)	+= extcon-usb-gpio.o
> diff --git a/drivers/extcon/extcon-usb-gpio.c b/drivers/extcon/extcon-usb-gpio.c
> new file mode 100644
> index 0000000..99a58b2
> --- /dev/null
> +++ b/drivers/extcon/extcon-usb-gpio.c
> @@ -0,0 +1,233 @@
> +/**
> + * drivers/extcon/extcon-usb-gpio.c - USB GPIO extcon driver
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com
> + * Author: Roger Quadros <rogerq@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/extcon.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#define USB_GPIO_DEBOUNCE_MS	20	/* ms */
> +
> +struct usb_extcon_info {
> +	struct device *dev;
> +	struct extcon_dev *edev;
> +
> +	struct gpio_desc *id_gpiod;
> +	int id_irq;
> +	bool id_irqwake;		/* ID wakeup enabled flag */

Do you really think id_irqwake is necessary?
I think it is not necessary.

> +
> +	unsigned long debounce_jiffies;
> +	struct delayed_work wq_detcable;
> +};
> +
> +/* List of detectable cables */
> +enum {
> +	EXTCON_CABLE_USB = 0,
> +	EXTCON_CABLE_USB_HOST,
> +
> +	EXTCON_CABLE_END,
> +};
> +
> +static const char *usb_extcon_cable[] = {
> +	[EXTCON_CABLE_USB] = "USB",
> +	[EXTCON_CABLE_USB_HOST] = "USB-Host",
> +	NULL,
> +};
> +

[snip]

> +
> +static int usb_extcon_remove(struct platform_device *pdev)
> +{
> +	struct usb_extcon_info *info = platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&info->wq_detcable);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int usb_extcon_suspend(struct device *dev)
> +{
> +	struct usb_extcon_info *info = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		if (!enable_irq_wake(info->id_irq))
> +			info->id_irqwake = true;
> +

You can simplify this code as following without 'id_irqwake':

	if (device_may_wakeup(dev))
		enable_irq_wake(info->id_irq);

> +	/*
> +	 * We don't want to process any IRQs after this point
> +	 * as GPIOs used behind I2C subsystem might not be
> +	 * accessible until resume completes. So disable IRQ.
> +	 */
> +	disable_irq(info->id_irq);
> +
> +	return 0;
> +}
> +
> +static int usb_extcon_resume(struct device *dev)
> +{
> +	struct usb_extcon_info *info = dev_get_drvdata(dev);
> +
> +	if (info->id_irqwake) {
> +		disable_irq_wake(info->id_irq);
> +		info->id_irqwake = false;
> +	}

ditto.

	if (device_may_wakeup(dev))
		disable_irq_wake(info->id_irq);

> +
> +	enable_irq(info->id_irq);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(usb_extcon_pm_ops,
> +			 usb_extcon_suspend, usb_extcon_resume);
> +
> +static struct of_device_id usb_extcon_dt_match[] = {
> +	{ .compatible = "linux,extcon-usb-gpio", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, usb_extcon_dt_match);
> +
> +static struct platform_driver usb_extcon_driver = {
> +	.probe		= usb_extcon_probe,
> +	.remove		= usb_extcon_remove,
> +	.driver		= {
> +		.name	= "extcon-usb-gpio",
> +		.pm	= &usb_extcon_pm_ops,
> +		.of_match_table = usb_extcon_dt_match,
> +	},
> +};
> +
> +module_platform_driver(usb_extcon_driver);
> +
> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
> +MODULE_DESCRIPTION("USB GPIO extcon driver");
> +MODULE_LICENSE("GPL v2");
> 

Thanks,
Chanwoo Choi

