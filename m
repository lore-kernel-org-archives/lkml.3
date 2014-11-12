Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaKLBKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:10:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaKLBKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:10 -0500
X-AuditID: cbfee68d-f79296d000004278-86-5462b36edc00
Message-id: <5462B36E.80600@samsung.com>
Date: Wed, 12 Nov 2014 10:10:06 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: myungjoo.ham@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rongjun.ying@csr.com, Baohua.Song@csr.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] extcon: gpio: Add dt support for the driver
References: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
 <1415201388-32060-2-git-send-email-george.cherian@ti.com>
In-reply-to: <1415201388-32060-2-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkQDdvc1KIwc57ZhYvZ15ltZh/5Byr
	Rf+bhawWpw4uZ7U492olo8XlXXPYLGYv6WexWHr9IpPF7cYVbBYTpq9lsWjde4TdYt+FP6wO
	PB5r5q1h9Ljc18vksWvnHFaPlcu/sHlsWtXJ5tG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst
	0rdL4MrY+bKfpWBJWMX+Rf4NjPtcuhg5OSQETCQa/n1gh7DFJC7cW8/WxcjFISSwlFFiccMp
	VpiizY8uMUMkpjNKPLraBuW8ZpR4POc6SxcjBwevgIbEwd3SIA0sAqoSv07uZAax2QS0JPa/
	uMEGYosKhEmsnH6FBcTmFRCU+DH5HpgtAlTTf6mbCWQms8A0Jol3068xgswUFvCW+PhBD2JX
	I6PE+5lnwBo4BdwkevpvMoLYzAI6Evtbp7FB2PISm9e8BTtOQqCXQ6JnaQcjxEUCEt8mHwI7
	VEJAVmLTAWaIzyQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0osM9YoTc4tL89L1
	kvNzNzEC4/j0v2e9OxhvH7A+xCjAwajEw5uwJilEiDWxrLgy9xCjKdAVE5mlRJPzgckiryTe
	0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvjFmy05Gd/V
	nPxXa3LYJPUSp0lPwmrVNxcmSh2dM3n7m0lBjit4Hj+2WBurkWsxwUpbMCZ/Qd6J82eLq8wP
	8ntpru0LOeTj8aVgYoIRr4XY9L/P+e/vEJtywW7Wi6TmabU/Hhdzcs9+qnml/b672qYHJtyM
	htc2qUZExeQdS5d76fPDrEVVRomlOCPRUIu5qDgRALHbQrzeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd28zUkhBqtOalu8nHmV1WL+kXOs
	Fv1vFrJanDq4nNXi3KuVjBaXd81hs5i9pJ/FYun1i0wWtxtXsFlMmL6WxaJ17xF2i30X/rA6
	8HismbeG0eNyXy+Tx66dc1g9Vi7/wuaxaVUnm0ffllWMHsdvbGfy+LxJLoAjqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxs6X/SwFS8Iq9i/yb2Dc59LFyMkhIWAisfnR
	JWYIW0ziwr31bF2MXBxCAtMZJR5dbWOGcF4zSjyec52li5GDg1dAQ+LgbmmQBhYBVYlfJ3eC
	NbMJaEnsf3GDDcQWFQiTWDn9CguIzSsgKPFj8j0wWwSopv9SNxPITGaBaUwS76ZfYwSZKSzg
	LfHxgx7ErkZGifczz4A1cAq4SfT032QEsZkFdCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJS
	toCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJJ4JrWDcWWDxSFGAQ5GJR7exDVJIUKs
	iWXFlbmHGCU4mJVEeB8sBQrxpiRWVqUW5ccXleakFh9iNAUGwURmKdHkfGACyyuJNzQ2MTOy
	NDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwHjgycrTCYvE1/cW605Rf2X7cgn/
	1mLWAO7u0yn6nsW1EuLv7tnEd967LHP/1/HbYUcjJ01uv5X1YB6D4kuf2ZI6XSy3tH9evKG6
	orpJ1uHW+vs3UudHpDqYMpsedzbP4VNKfaJpfCixZebPd6FzT9r8k372hnmTpvj1iedubFv3
	IvnjtESmSaJKLMUZiYZazEXFiQAVv/SHKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

How do you test this patch? This patch cannot test it 
because this patch has not compatible string for binding through DT.

You have to add following of_device_id for extcon-gpio:

+#if defined(CONFIG_OF)
+static const struct of_device_id gpio_extcon_of_match[] = {
+       { .compatible = "extcon-gpio", },
+       {},
+};
+MODULE_DEVICE_TABLE(of, gpio_extcon_of_match);
+#endif
+
 static struct platform_driver gpio_extcon_driver = {
        .probe          = gpio_extcon_probe,
        .remove         = gpio_extcon_remove,
        .driver         = {
                .name   = "extcon-gpio",
                .owner  = THIS_MODULE,
+               .of_match_table = of_match_ptr(gpio_extcon_of_match),
                .pm     = &gpio_extcon_pm_ops,
        },
 };


On 11/06/2014 12:29 AM, George Cherian wrote:
> Add device tree support to extcon-gpio driver.
> Add devicetree binding documentation
> 
> While at that
> 	- Cleanup the pdata as there are no users for the same.
> 	- Convert the driver to use gpiod_* API's.
> 	- Some gpio's can sleep while reading, so always use gpio_get_value_cansleep
> 	to get data. This fixes warning from gpiolib due to wrong API usage.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  .../devicetree/bindings/extcon/extcon-gpio.txt     | 21 ++++++
>  drivers/extcon/extcon-gpio.c                       | 83 +++++++---------------
>  include/linux/extcon/extcon-gpio.h                 | 59 ---------------
>  3 files changed, 46 insertions(+), 117 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>  delete mode 100644 include/linux/extcon/extcon-gpio.h
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> new file mode 100644
> index 0000000..30aa2e1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> @@ -0,0 +1,21 @@
> +GPIO based EXTCON
> +
> +EXTCON GPIO
> +-----------
> +
> +Required Properties:
> + - compatible: should be:
> +	* "linux,extcon-gpio"

I prefer to use simply "extcon-gpio" compatible" instead of "linux,extcon-gpio".

> + - gpios: specifies the gpio pin used.
> +
> +Optional Properties:
> + - debounce: Debounce time for GPIO IRQ in ms
> +
> +

Remove unneeded blank line.

> +Eg:
> +
> +	extcon1: am43_usbid_extcon1 {

I want to change the example of extcon-gpio as following:
	"extcon1: am43_usbid_extcon1" -> "usb_extcon: extcon-gpio0"

> +		compatible = "linux,extcon-gpio";

ditto.

> +		gpios = <&gpio3 12 GPIO_ACTIVE_HIGH>;
> +		debounce = <20>;
> +		};

You have to fix indentation of brace.

> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 72f19a3..85795de 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -21,26 +21,23 @@
>  */
>  
>  #include <linux/extcon.h>
> -#include <linux/extcon/extcon-gpio.h>
>  #include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  
>  struct gpio_extcon_data {
>  	struct extcon_dev *edev;
> -	unsigned gpio;
> -	bool gpio_active_low;
> -	const char *state_on;
> -	const char *state_off;
> +	struct gpio_desc *gpiod;
>  	int irq;
>  	struct delayed_work work;
>  	unsigned long debounce_jiffies;
> -	bool check_on_resume;
>  };
>  
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -50,9 +47,7 @@ static void gpio_extcon_work(struct work_struct *work)
>  		container_of(to_delayed_work(work), struct gpio_extcon_data,
>  			     work);
>  
> -	state = gpio_get_value(data->gpio);
> -	if (data->gpio_active_low)
> -		state = !state;
> +	state = gpiod_get_value_cansleep(data->gpiod);
>  	extcon_set_state(data->edev, state);
>  }
>  
> @@ -65,34 +60,16 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
> -{
> -	struct device *dev = edev->dev.parent;
> -	struct gpio_extcon_data *extcon_data = dev_get_drvdata(dev);
> -	const char *state;
> -
> -	if (extcon_get_state(edev))
> -		state = extcon_data->state_on;
> -	else
> -		state = extcon_data->state_off;
> -
> -	if (state)
> -		return sprintf(buf, "%s\n", state);
> -	return -EINVAL;
> -}
> -
>  static int gpio_extcon_probe(struct platform_device *pdev)
>  {
> -	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	struct device_node *np = pdev->dev.of_node;
>  	struct gpio_extcon_data *extcon_data;
> +	unsigned int irq_flags;
> +	unsigned int debounce = 0;
>  	int ret;
>  
> -	if (!pdata)
> -		return -EBUSY;
> -	if (!pdata->irq_flags) {
> -		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
> +	if (!np)
>  		return -EINVAL;
> -	}
>  
>  	extcon_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_extcon_data),
>  				   GFP_KERNEL);
> @@ -104,27 +81,23 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "failed to allocate extcon device\n");
>  		return -ENOMEM;
>  	}
> -	extcon_data->edev->name = pdata->name;
> -
> -	extcon_data->gpio = pdata->gpio;
> -	extcon_data->gpio_active_low = pdata->gpio_active_low;
> -	extcon_data->state_on = pdata->state_on;
> -	extcon_data->state_off = pdata->state_off;
> -	extcon_data->check_on_resume = pdata->check_on_resume;
> -	if (pdata->state_on && pdata->state_off)
> -		extcon_data->edev->print_state = extcon_gpio_print_state;
> -
> -	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
> -				    pdev->name);
> -	if (ret < 0)
> -		return ret;
> +	extcon_data->edev->name = np->name;
> +	extcon_data->gpiod = gpiod_get(&pdev->dev, NULL);
> +	if (IS_ERR(extcon_data->gpiod))
> +		return PTR_ERR(extcon_data->gpiod);
>  
> -	if (pdata->debounce) {
> -		ret = gpio_set_debounce(extcon_data->gpio,
> -					pdata->debounce * 1000);
> +	extcon_data->irq = gpiod_to_irq(extcon_data->gpiod);
> +	if (extcon_data->irq < 0)
> +		return extcon_data->irq;
> +
> +	irq_flags = irq_get_trigger_type(extcon_data->irq);

I recommend to use interrupt flags as following:
	irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;

> +	of_property_read_u32(np, "debounce", &debounce);

I don't want to use additional variable ('debounce').
You better to use 'data->debounce_jiffies' direclty instead of 'debounce'
Also, I prefer to check the return value of of_property_read_u32().

> +	if (debounce) {
> +		ret = gpiod_set_debounce(extcon_data->gpiod,
> +					 debounce * 1000);
>  		if (ret < 0)
>  			extcon_data->debounce_jiffies =
> -				msecs_to_jiffies(pdata->debounce);
> +				msecs_to_jiffies(debounce);
>  	}

How about following codes?

	if (of_property_read_u32(np, "debounce", &data->debounce_jiffies))
		data->debounce_jiffies = 0;

	ret = gpiod_set_debounce(data->gpiod, data->debounce_jiffies * 1000);
	if (ret < 0)
		data->debounce_jiffies
			= msecs_to_jiffies(data->debounce_jiffies);


>  
>  	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
> @@ -132,13 +105,8 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  		return ret;
>  
>  	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
> -
> -	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
> -	if (extcon_data->irq < 0)
> -		return extcon_data->irq;
> -
>  	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
> -				      pdata->irq_flags, pdev->name,
> +				      irq_flags, pdev->name,
>  				      extcon_data);
>  	if (ret < 0)
>  		return ret;
> @@ -166,9 +134,8 @@ static int gpio_extcon_resume(struct device *dev)
>  	struct gpio_extcon_data *extcon_data;
>  
>  	extcon_data = dev_get_drvdata(dev);
> -	if (extcon_data->check_on_resume)

Why did you remove 'check_on_resume' flag without any description?

> -		queue_delayed_work(system_power_efficient_wq,
> -			&extcon_data->work, extcon_data->debounce_jiffies);
> +	queue_delayed_work(system_power_efficient_wq,
> +			   &extcon_data->work, extcon_data->debounce_jiffies);
>  
>  	return 0;
>  }
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> deleted file mode 100644
> index 0b17ad4..0000000
> --- a/include/linux/extcon/extcon-gpio.h
> +++ /dev/null
> @@ -1,59 +0,0 @@
> -/*
> - *  External connector (extcon) class generic GPIO driver
> - *
> - * Copyright (C) 2012 Samsung Electronics
> - * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
> - *
> - * based on switch class driver
> - * Copyright (C) 2008 Google, Inc.
> - * Author: Mike Lockwood <lockwood@android.com>
> - *
> - * This software is licensed under the terms of the GNU General Public
> - * License version 2, as published by the Free Software Foundation, and
> - * may be copied, distributed, and modified under those terms.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> -*/
> -#ifndef __EXTCON_GPIO_H__
> -#define __EXTCON_GPIO_H__ __FILE__
> -
> -#include <linux/extcon.h>
> -
> -/**
> - * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
> - * @name:		The name of this GPIO extcon device.
> - * @gpio:		Corresponding GPIO.
> - * @gpio_active_low:	Boolean describing whether gpio active state is 1 or 0
> - *			If true, low state of gpio means active.
> - *			If false, high state of gpio means active.
> - * @debounce:		Debounce time for GPIO IRQ in ms.
> - * @irq_flags:		IRQ Flags (e.g., IRQF_TRIGGER_LOW).
> - * @state_on:		print_state is overriden with state_on if attached.
> - *			If NULL, default method of extcon class is used.
> - * @state_off:		print_state is overriden with state_off if detached.
> - *			If NUll, default method of extcon class is used.
> - * @check_on_resume:	Boolean describing whether to check the state of gpio
> - *			while resuming from sleep.
> - *
> - * Note that in order for state_on or state_off to be valid, both state_on
> - * and state_off should be not NULL. If at least one of them is NULL,
> - * the print_state is not overriden.
> - */
> -struct gpio_extcon_platform_data {
> -	const char *name;
> -	unsigned gpio;
> -	bool gpio_active_low;
> -	unsigned long debounce;
> -	unsigned long irq_flags;
> -
> -	/* if NULL, "0" or "1" will be printed */
> -	const char *state_on;
> -	const char *state_off;
> -	bool check_on_resume;
> -};
> -
> -#endif /* __EXTCON_GPIO_H__ */
> 

Thanks,
Chanwoo Choi
