Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3H2GYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:24:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3H2GX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:23:58 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-24-521ee8fb4cb0
Message-id: <521EE8FC.80802@samsung.com>
Date: Thu, 29 Aug 2013 15:23:56 +0900
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
 <521EA563.4060305@samsung.com> <521EB018.3000301@ti.com>
In-reply-to: <521EB018.3000301@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWyRsSkUPf3C7kgg2+LBSz+TjrGbnHwfr3F
	nfl/WS0eL//HZjH/yDlWi1MHl7NaHPizg9HiTW8Hi8XCtiUsFpd3zWGzmL2kn8Vi0bJWZoul
	1y8yWdxuXMFmMWH6WhaLrtfyFodXHGCyWPdyOovFjektrBavDraxOIh4rJm3htHj969JjB7v
	b7Syeyz4fIXd4/XkCYwel/t6mTx2zrrL7vFq9UxWjzvX9rB59Da/Y/Po27KK0eP4je1MHp83
	yXlsnBsawBfFZZOSmpNZllqkb5fAlbH2yTr2ghNzGStmn21laWBcVN7FyMkhIWAicfjjJHYI
	W0ziwr31bF2MXBxCAksZJa6eWs4OUzRl1Tx2iMR0Romla14zQTivGCVWLn0H5HBw8ApoSMz/
	4gDSwCKgKrHj5mQmEJtNQEti/4sbbCC2qECYxMrpV1hAbF4BQYkfk++B2SJANf2XusFmMgsc
	Y5ZYO3UnM0hCWCBB4vOc7ywQy/YwSqzvewA2lVNATeLi1HYwm1lAR2J/6zQ2CFteYvOat8wg
	DRICXzgkzv3/xwxxkoDEt8mHWEAulRCQldh0gBniNUmJgytusExgFJuF5KhZSMbOQjJ2ASPz
	KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAlHL637OJOxjvH7A+xJgMtHIis5Rocj4wJeWV
	xBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFjk5rK
	1ONvPT75uEWLnj92JOav09qEdxw8eudOiMgJ/s/1/RDd+/T+rMai6GRXvu9bshPk2ZodJuU9
	Us+r/T+ne7fVT/XFSlkCOyuVEqa+LPi84FOmnGuzhUDq7WztI3fO3OqymdFwLv7R5ZdfHtxv
	C4leofeq2MFrn7rbwRfeGas3JnnPslJiKc5INNRiLipOBADiIxqsPwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xoO7vF3JBBp+PMlr8nXSM3eLg/XqL
	O/P/slo8Xv6PzWL+kXOsFqcOLme1OPBnB6PFm94OFouFbUtYLC7vmsNmMXtJP4vFomWtzBZL
	r19ksrjduILNYsL0tSwWXa/lLQ6vOMBkse7ldBaLG9NbWC1eHWxjcRDxWDNvDaPH71+TGD3e
	32hl91jw+Qq7x+vJExg9Lvf1MnnsnHWX3ePV6pmsHneu7WHz6G1+x+bRt2UVo8fxG9uZPD5v
	kvPYODc0gC+qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA
	1y0zB+hlJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG2ifr2AtOzGWs
	mH22laWBcVF5FyMnh4SAicSUVfPYIWwxiQv31rN1MXJxCAlMZ5RYuuY1E4TzilFi5dJ3QA4H
	B6+AhsT8Lw4gDSwCqhI7bk5mArHZBLQk9r+4wQZiiwqESaycfoUFxOYVEJT4MfkemC0CVNN/
	qRtsJrPAMWaJtVN3MoMkhAUSJD7P+c4CsWwPo8T6vgdgUzkF1CQuTm0Hs5kFdCT2t05jg7Dl
	JTavecs8gVFgFpIls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMJ6JrWD
	cWWDxSFGAQ5GJR7eiN+yQUKsiWXFlbmHGCU4mJVEeE/tkwsS4k1JrKxKLcqPLyrNSS0+xJgM
	DIOJzFKiyfnAZJpXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYzLqvU49H/wMsyMPGTxgfOHALfln7knMlIZT7FzNcn8Ffp34v3LU24eu6ICpTaXzbtjt+kg
	h5JTZeUhw6XVaX0u1/J+dv5//H39AYPc60kLVI+fqtZ4n2chOGuSq+rN7V7c7Jd5n5qe0V10
	hHvZfBXbfX53N/05niT24o5Ixtw566aKsdxasllUiaU4I9FQi7moOBEAuN6ROpwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 08/29/2013 11:21 AM, George Cherian wrote:
> Hi Chanwoo,
> 
> Thanks for the review and sorry for all the trivial mistakes.
> 
> On 8/29/2013 7:05 AM, Chanwoo Choi wrote:
>> Hi George,
>>
>> You didn't modify this patchset about my comment on v1 patchset.
>> Please pay attention to comment.
>>
>> On 08/29/2013 02:33 AM, George Cherian wrote:
>>> Add a generic USB VBUS/ID detection EXTCON driver. This driver expects
>>> the ID/VBUS pin are connected via GPIOs. This driver is tested on
>>> DRA7x board were the ID pin is routed via GPIOs. The driver supports
>>> both VBUS and ID pin configuration and ID pin only configuration.
>>>
>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>> ---
>>>   .../bindings/extcon/extcon-gpio-usbvid.txt         |  20 ++
>>>   drivers/extcon/Kconfig                             |   6 +
>>>   drivers/extcon/Makefile                            |   1 +
>>>   drivers/extcon/extcon-gpio-usbvid.c                | 286 +++++++++++++++++++++
>> You should keep following naming stlye. extcon-gpio-usbvid.c is wrong naming style.
>> - extcon-[device name].c
>> - extcon-gpio-usbvid.c -> extcon-dra7xx.c or etc.
> Actually dra7xx is the SoC name and the USB VBUS/ID detection is not specific to SoC.
> It uses gpios to detect the VBUS/ID change. So i thought it would be better to have generic
> gpio based VBUS/ID detection rather than making dra7xx specific. Stephen Warren had this opinion
> with patch v1.

Would you guarantee that this driver support all of extcon devices using gpio pin?

I can't agree. This driver has specific dependency on dra7x SoC.

First,
vbus_irq_handler() determine USB cable state according to "gpio_usbvid->vbus_gpio" state.
If "gpio_usbvid->vbus_gpio" value is VBUS_OFF(0), this patch set USB cable state as 'false'
But, it include potential problems. Other extcon device using gpio would set USB cable state
as 'true' when gpio state is 1. This way has dependency on specific SoC.

Second,
gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices 
would not control both "USB-HOST" and "USB" cable state at same time. 

Other extcon devices would support either "USB-HOST" or "USB" cable.

Third,
gpio_usbvid_probe() get both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq by using DT helper function.
and gpio_usbvid_request_irq() register each interrupt handler(id_irq and vbus_irq) according to DT data.
In result, 
	id_irq_handler() would control both "USB-HOST" and "USB" cable state.
	vbus_irq_handler() would control only "USB" cable state.

Two interrupt handler(id_irq_handler()/vbus_irq_handler()) would control "USB" cable state
according to each gpio state at same time. Also, It include critical problem.


>>
>> Also, you should change the file name of extcon-gpio-usbvid.txt.
>>
>> Finally, You used 'gpio_usbvid' prefix in extcon-gpio-usbvid.c.
>> It has caused the confusion that user would think extcon-gpio-usbvid.c driver
>> support all of extcon driver using gpio irq pin. So I'd like you to use
>> proper prefix including device name.
> I meant to support all of extcon driver using gpio for USB VBUS/ID detection.
>>
>>>   4 files changed, 313 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
>>>   create mode 100644 drivers/extcon/extcon-gpio-usbvid.c
> [snip]
>>> index f1d54a3..8097398 100644
>>> --- a/drivers/extcon/Kconfig
>>> +++ b/drivers/extcon/Kconfig
>>> @@ -64,4 +64,10 @@ config EXTCON_PALMAS
>>>         Say Y here to enable support for USB peripheral and USB host
>>>         detection by palmas usb.
>>>   +config EXTCON_GPIO_USBVID
>>> +    tristate "Generic USB VBUS/ID detection using GPIO EXTCON support"
>>> +    help
>>> +      Say Y here to enable support for USB VBUS/ID deetction by GPIO.
>>> +
>>> +
>> Remove blank line.
> okay
>>>   endif # MULTISTATE_SWITCH
> [snip]
>>> diff --git a/drivers/extcon/extcon-gpio-usbvid.c b/drivers/extcon/extcon-gpio-usbvid.c
>>> new file mode 100644
>>> index 0000000..e9bc2a97
>>> --- /dev/null
>>> +++ b/drivers/extcon/extcon-gpio-usbvid.c
>>> @@ -0,0 +1,286 @@
>>> +/*
>>> + * Generic  USB VBUS-ID pin detection driver
>>> + *
>>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * Author: George Cherian <george.cherian@ti.com>
>>> + *
>>> + * Based on extcon-palmas.c
>>> + *
>>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/kthread.h>
>>> +#include <linux/freezer.h>
>> kthead.h, freezer.h headerfile is used in this file?
> okay
>>> +#include <linux/platform_device.h>
>>> +#include <linux/extcon.h>
>>> +#include <linux/err.h>
>>> +#include <linux/of.h>
>>> +#include <linux/gpio.h>
>>> +#include <linux/of_gpio.h>
>>> +#include <linux/of_platform.h>
>> Order headerfile alphabetically.
> okay
>>
>>> +
>>> +struct gpio_usbvid {
>>> +    struct device *dev;
>>> +
>>> +    struct extcon_dev edev;
>>> +
>>> +    /*GPIO pin */
>> I commented previous your patch about this wrong coding style.
>> Why did not you fix this coding style?
> okay
>>> +    int id_gpio;
>>> +    int vbus_gpio;
>>> +
>>> +    int id_irq;
>>> +    int vbus_irq;
>>> +    int type;
>>> +};
>>> +
>>> +static const char *dra7xx_extcon_cable[] = {
>>> +    [0] = "USB",
>>> +    [1] = "USB-HOST",
>>> +    NULL,
>>> +};
>>> +
>>> +static const int mutually_exclusive[] = {0x3, 0x0};
>>> +
>>> +/* Two types of support are provided.
>>> + * Systems which has
>>> + *    1) VBUS and ID pin connected via GPIO
>>> + *    2)  only ID pin connected via GPIO
>> Remove blank between '2)' and 'only'.
> okay
>>> + *  For Case 1 both the gpios should be provided via DT
>>> + *  Always the first GPIO in dt is considered ID pin GPIO
>>> + */
>>> +
>>> +enum {
>>> +    UNKNOWN = 0,
>>> +    ID_DETECT,
>>> +    VBUS_ID_DETECT,
>>> +};
>>> +
>>> +#define ID_GND        0
>>> +#define ID_FLOAT    1
>>> +#define VBUS_OFF    0
>>> +#define VBUS_ON        1
>> I think you could only use two constant instead of four constant definition.
> you mean only ID_GND and VBUS_OFF?

you could only define two contant (0 and 1) to detect gpio state.

>>> +
>>> +
>> This blank line isn't necessary.
>>
>>> +static irqreturn_t id_irq_handler(int irq, void *data)
>>> +{
>>> +    struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
>> You should delete blank between ')' and 'data' as follwong:
>>     - (struct gpio_usbvid *)data;
> okay
>>
>>> +    int id_current;
>>> +
>>> +    id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>> +    if (id_current == ID_GND) {
>>> +        if (gpio_usbvid->type == ID_DETECT)
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", false);
>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>> As else statement, you should set "USB-HOST" cable state to improve readability.
>>
>>         extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>         if (gpio_usbvid->type == ID_DETECT)
>>             extcon_set_cable_state(&gpio_usbvid->edev,
>>                             "USB", false);
> Actually, USB-HOST state should be set in the id_irq handler. But in cases were only ID pin is routed to gpio
> and VBUS is not used we set the USB state too. The gpio_usbvid->type differentiates whether its an ID only or
> VBUS and ID.

I don't understand. Wht does not you change the order of function call as following?

	Before:
	        if (gpio_usbvid->type == ID_DETECT)
			extcon_set_cable_state(&gpio_usbvid->edev,
	                            	"USB", false);
		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);

	After:
		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
		if (gpio_usbvid->type == ID_DETECT)
			extcon_set_cable_state(&gpio_usbvid->edev,
					"USB", false);

id_irq_handler() determine the state of "USB-HOST" cable according to 'id_current' value.
And this function dermine the state of "USB" cable accordign to "gpio_usbvid->type" value.

>>> +    } else {
>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>> +        if (gpio_usbvid->type == ID_DETECT)
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", true);
>>> +    }
>> Add blank line.
> okay
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +static irqreturn_t vbus_irq_handler(int irq, void *data)
>>> +{
>>> +    struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
>> ditto.
> okay
>>> +    int vbus_current;
>>> +
>>> +    vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>> +    if (vbus_current == VBUS_OFF)
>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>> +    else
>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);

First,
vbus_irq_handler() determine USB cable state according to "gpio_usbvid->vbus_gpio" state.
If "gpio_usbvid->vbus_gpio" value is VBUS_OFF(0), this patch set USB cable state as 'false'
But, it include potential problems. Other extcon device using gpio would set USB cable state
as 'true' when gpio state is 1. This way has dependency on specific SoC.

>>> +
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +
>> This blank line isn't necessary.
>> I commented unnecessary blank line on previous review.
> okay
>>> +static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
>>> +{
>>> +    int id_current;
>>> +    int vbus_current;
>> Define loacal variable on one line as following:
>>     int id_current, vbus_current;
> okay
>>> +
>>> +    switch (gpio_usbvid->type) {
>>> +    case ID_DETECT:
>>> +        id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>> +        if (!!id_current == ID_FLOAT) {
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", false);
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", true);
>>> +        } else {
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", false);
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", true);
>>> +        }

Second,
gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices 
would not control both "USB-HOST" and "USB" cable state at same time. 

Other extcon devices would support either "USB-HOST" or "USB" cable.

>>> +        break;
>>> +
>>> +    case VBUS_ID_DETECT:
>>> +        id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>> +        if (!!id_current == ID_FLOAT)
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", false);
>>> +        else
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", true);
>>> +
>>> +        vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>> +        if (!!vbus_current == VBUS_ON)
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", true);
>>> +        else
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", false);
>>> +        break;
>>> +
>>> +    default:
>>> +        dev_err(gpio_usbvid->dev, "Unknown VBUS-ID type\n");
>>> +    }
>>> +}
>>> +
>>> +static int gpio_usbvid_request_irq(struct gpio_usbvid *gpio_usbvid)
>>> +{
>>> +    int ret;
>> Add blank line.
> okay
>>> +    ret = devm_request_threaded_irq(gpio_usbvid->dev, gpio_usbvid->id_irq,
>>> +                    NULL, id_irq_handler,
>>> +                    IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
>>> +                    dev_name(gpio_usbvid->dev),
>>> +                    (void *) gpio_usbvid);
>>> +    if (ret) {
>>> +        dev_err(gpio_usbvid->dev, "failed to request id irq #%d\n",
>>> +                    gpio_usbvid->id_irq);
>>> +        return ret;
>>> +    }
>>> +    if (gpio_usbvid->type == VBUS_ID_DETECT) {
>>> +        ret = devm_request_threaded_irq(gpio_usbvid->dev,
>>> +                    gpio_usbvid->vbus_irq, NULL,
>>> +                    vbus_irq_handler,
>>> +                    IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
>>> +                    dev_name(gpio_usbvid->dev),
>> Why do you use the same interrupt name both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq?
>> You should use characteristic interrupt name.
> if I use dev_name it gives me 2 same name interrupts associated with a single extcon device.
> Where as if i use characteristic (for eg: VBUS or ID) names then I will get multiple with same name
> since there will be 2 instances of extcon being used as of now.

I can't agree. Single extcon driver can have various interrupt.
If you use same interrupt name about different two interrupt,
can we know the kind of interrupt which is happened on /proc/interrupts?
We cannot count the number of each interrupt occurrences.

>>> +                    (void *) gpio_usbvid);
>>> +        if (ret)
>>> +            dev_err(gpio_usbvid->dev, "failed to request vbus irq #%d\n",
>>> +                        gpio_usbvid->vbus_irq);
>>> +    }
>> Add blank line.
> okay
>>> +    return ret;
>>> +}
>>> +
>>> +static int gpio_usbvid_probe(struct platform_device *pdev)
>>> +{
>>> +    struct device_node *node = pdev->dev.of_node;
>>> +    struct gpio_usbvid *gpio_usbvid;
>>> +    int ret;
>>> +    int gpio;
>> Define loacal variable on one line as following:
>>     int ret, gpio;
>>
>>> +
>>> +    gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid),
>>> +                                GFP_KERNEL);
>> If this statement over 80 line, you have to keep proper indentation as following:
>>     gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid),
>>                   GFP_KERNEL);
> okay
>>
>>> +    if (!gpio_usbvid)
>>> +        return -ENOMEM;
>>> +
>>> +
>> Remove blank line.
> okay
>>> +    gpio_usbvid->dev     = &pdev->dev;
>> Use space instead of tab.
> okay
>>> +
>>> +    platform_set_drvdata(pdev, gpio_usbvid);
>>> +
>>> +    gpio_usbvid->edev.name = dev_name(&pdev->dev);
>> I add as follwong comment about your v1 patchset
>>
>>     "If edev name is equal with device name, this line is unnecessary.
>>     Because extcon_dev_register() use dev_name(&pdev->dev) as edev name
>>     in extcon-class.c"
>>
>> Why did not apply for my comment to v3 patchset?
>> Plesae pay attention for previous comment.
> I removed it but it gave me a  NULL pointer dereference  in extcon_get_extcon_dev (strcmp the sd->name was NULL).
> I am based on v3.11-rc3, did you have any fix for this in later rc's? probably I would rebase to your latest and check.

Always, you have to develop patch based on extcon-next or extcon-linux branch according to patch content.

This feature related to your NULL pointer issue will include v3.12.
- http://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-next&id=6eee5b3b493824731ed34ade0299241f91f04096

>>> +    gpio_usbvid->edev.supported_cable = dra7xx_extcon_cable;
>>> +    gpio_usbvid->edev.mutually_exclusive = mutually_exclusive;
>>> +
>>> +    if (of_device_is_compatible(node, "ti,gpio-usb-id"))
>>> +        gpio_usbvid->type = ID_DETECT;
>>> +
>>> +    gpio = of_get_gpio(node, 0);
>>> +    if (gpio_is_valid(gpio)) {
>>> +        gpio_usbvid->id_gpio = gpio;
>>> +        ret = devm_gpio_request(&pdev->dev, gpio_usbvid->id_gpio,
>>> +                    "id_gpio");
>>> +        if (ret)
>>> +            return ret;
>> Add blank line.
>>
>>> +        gpio_usbvid->id_irq = gpio_to_irq(gpio_usbvid->id_gpio);
>>> +    } else {
>>> +        dev_err(&pdev->dev, "failed to get id gpio\n");
>>> +        return -ENODEV;
>>> +    }
>>> +
>>> +    if (of_device_is_compatible(node, "ti,gpio-usb-vid")) {
>>> +        gpio_usbvid->type = VBUS_ID_DETECT;
>>> +        gpio = of_get_gpio(node, 1);
>>> +        if (gpio_is_valid(gpio)) {
>>> +            gpio_usbvid->vbus_gpio = gpio;
>>> +            ret = devm_gpio_request(&pdev->dev,
>>> +                        gpio_usbvid->vbus_gpio,
>>> +                        "vbus_gpio");
>>> +            if (ret)
>>> +                return ret;
>> Add blank line.
>>
>>> +            gpio_usbvid->vbus_irq =
>>> +                    gpio_to_irq(gpio_usbvid->vbus_gpio);
>>> +        } else {
>>> +            dev_err(&pdev->dev, "failed to get vbus gpio\n");
>>> +            return -ENODEV;
>>> +        }
>>> +    }
>>> +
>>> +    ret = extcon_dev_register(&gpio_usbvid->edev, gpio_usbvid->dev);
>>> +    if (ret) {
>>> +        dev_err(&pdev->dev, "failed to register extcon device\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    gpio_usbvid_set_initial_state(gpio_usbvid);
>>> +    ret = gpio_usbvid_request_irq(gpio_usbvid);

Third,
gpio_usbvid_probe() get both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq by using DT helper function.
and gpio_usbvid_request_irq() register each interrupt handler(id_irq and vbus_irq) according to DT data.
In result, 
id_irq_handler() would control both "USB-HOST" and "USB" cable state.
vbus_irq_handler() would control only "USB" cable state.

Two interrupt handler(id_irq_handler()/vbus_irq_handler()) would control "USB" cable state
according to each gpio state at same time. Also, It include critical problem.

>> You should move gpio_usbvid_request_irq() call before extcon_dev_register().
>>
>>> +    if (ret)
>>> +        goto err0;
>> ? As following previous comment about v1 patchset:
>>     I need correct meaning name as err_thread or etc ...
> okay
>>
>>> +
>>> +    return 0;
>>> +
>>> +err0:
>> ditto.
> okay
>>> +    extcon_dev_unregister(&gpio_usbvid->edev);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int gpio_usbvid_remove(struct platform_device *pdev)
>>> +{
>>> +    struct gpio_usbvid *gpio_usbvid = platform_get_drvdata(pdev);
>>> +
>>> +    extcon_dev_unregister(&gpio_usbvid->edev);
>>> +    return 0;
>>> +}
>>> +
>>> +static struct of_device_id of_gpio_usbvid_match_tbl[] = {
>>> +    { .compatible = "ti,gpio-usb-vid", },
>>> +    { .compatible = "ti,gpio-usb-id", },
>>> +    { /* end */ }
>>> +};
>>> +
>>> +static struct platform_driver gpio_usbvid_driver = {
>>> +    .probe = gpio_usbvid_probe,
>>> +    .remove = gpio_usbvid_remove,
>>> +    .driver = {
>>> +        .name = "gpio-usbvid",
>>> +        .of_match_table = of_gpio_usbvid_match_tbl,
>>> +        .owner = THIS_MODULE,
>>> +    },
>>> +};
>>> +
>>> +module_platform_driver(gpio_usbvid_driver);
>>> +
>>> +MODULE_ALIAS("platform:gpio-usbvid");
>>> +MODULE_AUTHOR("George Cherian <george.cherian@ti.com>");
>>> +MODULE_DESCRIPTION("GPIO based USB Connector driver");
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_DEVICE_TABLE(of, of_gpio_usbvid_match_tbl);
>>>
>> Cheers,
>> Chanwoo Choi
> 
> 

Thanks,
Chanwoo Choi

