Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3HTAYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:24:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24149 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3HTAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:24:35 -0400
X-AuditID: cbfee68e-b7f276d000002279-08-5212b740e81c
Message-id: <5212B740.2000000@samsung.com>
Date: Tue, 20 Aug 2013 09:24:32 +0900
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
        linux-usb@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB ID
 detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
 <1376648029-30659-2-git-send-email-george.cherian@ti.com>
In-reply-to: <1376648029-30659-2-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42JZI2JSpOuwXSjIoGOJjsXB+/UWd+b/ZbWY
	f+Qcq8Wpg8tZLQ782cFo8aa3g8ViYdsSFovLu+awWcxe0s9isWhZK7PF0usXmSxuN65gs5gw
	fS2LxeEVB5gs1r2czmLx6mAbi4OAx5p5axg93t9oZfdY8PkKu8fryRMYPV6tnsnqcefaHjaP
	vi2rGD2O39jO5PF5k5zHxrmhAVxRXDYpqTmZZalF+nYJXBkHFvxkKvgcVXF861yWBsYWzy5G
	Tg4JAROJji27mSBsMYkL99azdTFycQgJLGWUmLWylRmm6PDxnewQiemMEpefzmOEcF4xStza
	PRsow8HBK6AlMWlrAIjJIqAqcXu7GEgvG1B0/4sbbCC2qECYxMrpV1hAbF4BQYkfk++B2SJA
	Nf2XuplARjILfGGSmLUKYqSwQITEhRUKEKsaGSUWXLkPdhCngJvEi6ezwJqZBXQk9rdOY4Ow
	5SU2r3nLDNIgIbCFQ2LN7UtgDSwCAhLfJh9iARkqISArsekA1GOSEgdX3GCZwCg2C8lNs5CM
	nYVk7AJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgfF/+t+zvh2MNw9YH2JMBlo5kVlK
	NDkfmD7ySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cC44dZ086vbdu4Tb5lq+sla8dKfjhD99Q94D0/+MP+shot5w4GzmfExL0MtuAvabBdbu2z+
	UFO65eOhnbLRV74G/t5yJSlzl8iZ8sI8gas7v6z85Lxl46Z/6V4fyjSWpT24JrOX/ejOnuoe
	bp0zOwWWzbwzR+3aKea7X80m+Uq8NhXfpufcy2gfocRSnJFoqMVcVJwIAOurgZcVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQV2H7UJBBoe2K1gcvF9vcWf+X1aL
	+UfOsVqcOric1eLAnx2MFm96O1gsFrYtYbG4vGsOm8XsJf0sFouWtTJbLL1+kcniduMKNosJ
	09eyWBxecYDJYt3L6SwWrw62sTgIeKyZt4bR4/2NVnaPBZ+vsHu8njyB0ePV6pmsHneu7WHz
	6NuyitHj+I3tTB6fN8l5bJwbGsAV1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sIYx48CCn0wFn6Mqjm+dy9LA2OLZxcjJISFgInH4+E52CFtM4sK99WxdjFwcQgLTGSUuP53H
	COG8YpS4tXs2UBUHB6+AlsSkrQEgJouAqsTt7WIgvWxA0f0vbrCB2KICYRIrp19hAbF5BQQl
	fky+B2aLANX0X+pmAhnJLPCFSWLWKoiRwgIREhdWKECsamSUWHDlPjNIA6eAm8SLp7PAmpkF
	dCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcHJ5JrWDcWWDxSFGAQ5GJR7eTiWhICHWxLLiytxDjBIczEoivPElQCHelMTKqtSi/Pii
	0pzU4kOMycAQmMgsJZqcD0x8eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAmHtO6/jmuwsqt9v2rZWWLDzQsed9nVfXon3earq74vyW7y0VquLQay0KmpV0
	+1nG6l8Pbmgxc6++vyY0f3HDy/mJbnEOrjtkr16ZuJ1n1QvfWdkTloeuPF1pafw2rFbsiR5X
	yQ2xFReOT+Zw3rT/xy2tUN2pwvOdNW23+gaWKq/cNu3w8c7HOUosxRmJhlrMRcWJAJyPTuNy	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 08/16/2013 07:13 PM, George Cherian wrote:
> Adding extcon driver for USB ID detection to dynamically
> configure USB Host/Peripheral mode.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  .../devicetree/bindings/extcon/extcon-dra7xx.txt   |  19 ++
>  drivers/extcon/Kconfig                             |   7 +
>  drivers/extcon/Makefile                            |   1 +
>  drivers/extcon/extcon-dra7xx.c                     | 234 +++++++++++++++++++++
>  4 files changed, 261 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>  create mode 100644 drivers/extcon/extcon-dra7xx.c
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
> new file mode 100644
> index 0000000..37e4c22
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
> @@ -0,0 +1,19 @@
> +EXTCON FOR DRA7xx
> +
> +Required Properties:
> + - compatible : Should be "ti,dra7xx-usb"
> + - gpios : phandle to ID pin and interrupt gpio.
> +
> +Optional Properties:
> +  - interrupt-parent : interrupt controller phandle
> +  - interrupts : interrupt number
> +
> +
> +dra7x_extcon1 {

You used 'dra7xx-usb' device name. Why did you use 'dra7x_extcon1' name?
What is meaning 'dra7x_extcon1'? 

> +		compatible = "ti,dra7xx-usb";
> +		gpios = <&pcf_usb 1 0>,
> +			<&gpio6 11 2>;
> +		interrupt-parent = <&gpio6>;
> +		interrupts = <11>;
> +	};

You have to keep indentation rule.

> +
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index f1d54a3..b9cf0b2 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -64,4 +64,11 @@ config EXTCON_PALMAS
>  	  Say Y here to enable support for USB peripheral and USB host
>  	  detection by palmas usb.
>  
> +config EXTCON_DRA7XX
> +	tristate "DRA7XX EXTCON support"
> +	help
> +	  Say Y here to enable support for USB peripheral and USB host
> +	  detection by pcf8575 using DRA7XX extcon.

You should explain detailed description about pcf8575 on patch description
and change description of EXTCON_DRA7xx as following:
"using DRA7XX extcon" -> "using DRA7XX device" or "using DRA7XX usb"

> +
> +

Remove unnecessary blank line.

>  endif # MULTISTATE_SWITCH
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index e4fa8ba..e4778f9 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
>  obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>  obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
>  obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
> +obj-$(CONFIG_EXTCON_DRA7XX)	+= extcon-dra7xx.o
> diff --git a/drivers/extcon/extcon-dra7xx.c b/drivers/extcon/extcon-dra7xx.c
> new file mode 100644
> index 0000000..268c25e
> --- /dev/null
> +++ b/drivers/extcon/extcon-dra7xx.c
> @@ -0,0 +1,234 @@
> +/*
> + * DRA7XX USB ID pin detection driver
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
> +#include <linux/platform_device.h>
> +#include <linux/extcon.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +
> +struct dra7xx_usb {
> +	struct device *dev;
> +
> +	struct extcon_dev edev;
> +	struct task_struct *thread_task;
> +
> +	/*GPIO pin */

Add space between "/*" and "GPIO".

> +	int id_gpio;
> +	int irq_gpio;
> +
> +	int id_prev;
> +	int id_current;
> +
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
> +static int id_poll_func(void *data)
> +{
> +	struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
> +
> +	allow_signal(SIGINT);
> +	allow_signal(SIGTERM);
> +	allow_signal(SIGKILL);
> +	allow_signal(SIGUSR1);
> +
> +	set_freezable();
> +
> +	while (!kthread_should_stop()) {
> +		dra7xx_usb->id_current = gpio_get_value_cansleep
> +						(dra7xx_usb->id_gpio);
> +		if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
> +			schedule_timeout_interruptible
> +						(msecs_to_jiffies(2*1000));
> +			continue;
> +		} else if (dra7xx_usb->id_current == 0) {
> +			extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
> +			extcon_set_cable_state(&dra7xx_usb->edev,
> +						"USB-HOST", true);
> +		} else {
> +			extcon_set_cable_state(&dra7xx_usb->edev,
> +						"USB-HOST", false);
> +			extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
> +		}

Should dra7xx_usb keep always connected state with either USB or USB-HOST cable?
I don't understand. So please explain detailed operation method of dra7xx_usb device.

> +		dra7xx_usb->id_prev = dra7xx_usb->id_current;
> +	}
> +
> +	return 0;
> +}
> +
> +static irqreturn_t id_irq_handler(int irq, void *data)
> +{
> +	struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
> +
> +	dra7xx_usb->id_current = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
> +
> +	if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
> +		return IRQ_NONE;
> +	} else if (dra7xx_usb->id_current == 0) {
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", true);
> +	} else {
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", false);
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
> +	}

why did you do keep always connected state?

> +
> +	dra7xx_usb->id_prev = dra7xx_usb->id_current;

Add blank line.

> +	return IRQ_HANDLED;
> +

Remove unnecessary blank line.

> +}
> +
> +static int dra7xx_usb_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct dra7xx_usb *dra7xx_usb;
> +	int status;

'status' local variable is used for return value.
So, I prefer 'ret' variable instead of 'status' name.

> +	int irq_num;
> +	int gpio;
> +
> +	dra7xx_usb = devm_kzalloc(&pdev->dev, sizeof(*dra7xx_usb), GFP_KERNEL);
> +	if (!dra7xx_usb)
> +		return -ENOMEM;

You have to add error message with dev_err().

> +
> +

Remove unnecessary blank line.

> +	dra7xx_usb->dev	 = &pdev->dev;
> +
> +	platform_set_drvdata(pdev, dra7xx_usb);
> +
> +	dra7xx_usb->edev.name = dev_name(&pdev->dev);

If edev name is equal with device name, this line is unnecessary.
Because extcon_dev_register() use dev_name(&pdev->dev) as edev name
in extcon-class.c

> +	dra7xx_usb->edev.supported_cable = dra7xx_extcon_cable;
> +	dra7xx_usb->edev.mutually_exclusive = mutually_exclusive;
> +
> +	gpio = of_get_gpio(node, 0);
> +	if (gpio_is_valid(gpio)) {
> +		dra7xx_usb->id_gpio = gpio;
> +		status = gpio_request(dra7xx_usb->id_gpio, "id_gpio");
> +		if (status)
> +			return status;

You have to add error message with dev_err().

> +	} else {
> +		dev_err(&pdev->dev, "failed to get id gpio\n");
> +		return -ENODEV;
> +	}
> +
> +	gpio = of_get_gpio(node, 1);
> +	if (gpio_is_valid(gpio)) {
> +		dra7xx_usb->irq_gpio = gpio;
> +		irq_num = gpio_to_irq(dra7xx_usb->irq_gpio);
> +		if (irq_num < 0)
> +			dra7xx_usb->irq_gpio = 0;
> +	} else {
> +		dev_err(&pdev->dev, "failed to get irq gpio\n");
> +	}
> +
> +

Remove unnecessary blank line.

> +	status = extcon_dev_register(&dra7xx_usb->edev, dra7xx_usb->dev);
> +	if (status) {
> +		dev_err(&pdev->dev, "failed to register extcon device\n");
> +		return status;

You should restore previous operation about dra7xx_usb->irq_gpio.

> +	}
> +
> +	dra7xx_usb->id_prev = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
> +	if (dra7xx_usb->id_prev) {
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", false);
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
> +	} else {
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
> +		extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", true);
> +	}

why did you do keep always connected state?

> +
> +	if (dra7xx_usb->irq_gpio) {
> +		status = devm_request_threaded_irq(dra7xx_usb->dev, irq_num,
> +				NULL, id_irq_handler, IRQF_SHARED |
> +				IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
> +				dev_name(&pdev->dev), (void *) dra7xx_usb);
> +		if (status)
> +			dev_err(dra7xx_usb->dev, "failed to request irq #%d\n",
> +						irq_num);

If devm_request_threaded_irq() return fail state, why did not you do add error exception?

> +		else
> +			return 0;

If devm_request_threaded_irq() return success state, why did you directly call 'return'?
kthread_create operation isn't necessary?

> +	}
> +
> +	dra7xx_usb->thread_task = kthread_create(id_poll_func, dra7xx_usb,
> +						 dev_name(&pdev->dev));

Should you use polling method with kthread? I think it isn't proper method.
You did get the irq number by using DT helper function and register irq handler
with devm_request_threaded_irq(). I prefer interrupt method for detection of cable state.

Also, you set delay time as 2000 millisecond for kthread. kthread don't guarantee rapid response.
> +			schedule_timeout_interruptible
> +						(msecs_to_jiffies(2*1000));



> +	if (!dra7xx_usb->thread_task) {
> +		dev_err(dra7xx_usb->dev, "failed to create thread for %s\n"
> +					, dev_name(&pdev->dev));
> +		goto err0;

I need correct meaning name as err_thread or etc ...

> +	}
> +
> +	wake_up_process(dra7xx_usb->thread_task);
> +
> +	return 0;
> +
> +err0:

ditto.

> +	gpio_free(dra7xx_usb->id_gpio);
> +	extcon_dev_unregister(&dra7xx_usb->edev);
> +
> +	return status;
> +}
> +
> +static int dra7xx_usb_remove(struct platform_device *pdev)
> +{
> +	struct dra7xx_usb *dra7xx_usb = platform_get_drvdata(pdev);
> +
> +	if (!dra7xx_usb->irq_gpio)
> +		kthread_stop(dra7xx_usb->thread_task);
> +
> +	gpio_free(dra7xx_usb->id_gpio);
> +	extcon_dev_unregister(&dra7xx_usb->edev);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id of_dra7xx_match_tbl[] = {
> +	{ .compatible = "ti,dra7xx-usb", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver dra7xx_usb_driver = {
> +	.probe = dra7xx_usb_probe,
> +	.remove = dra7xx_usb_remove,
> +	.driver = {
> +		.name = "dra7xx-usb",
> +		.of_match_table = of_dra7xx_match_tbl,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(dra7xx_usb_driver);
> +
> +MODULE_ALIAS("platform:dra7xx-usb");
> +MODULE_AUTHOR("George Cherian <george.cherian@ti.com>");
> +MODULE_DESCRIPTION("DRA7x USB Connector driver");
> +MODULE_LICENSE("GPL");
> +MODULE_DEVICE_TABLE(of, of_dra7xx_match_tbl);
> 

Thanks,
Chanwoo Choi
