Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3H3ALT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:11:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40982 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H3ALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:11:16 -0400
X-AuditID: cbfee68e-b7f756d000004512-b5-521fe31cdba8
Message-id: <521FE31D.8050902@samsung.com>
Date: Fri, 30 Aug 2013 09:11:09 +0900
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
 <521EE8FC.80802@samsung.com> <521EF88F.4070402@ti.com>
 <521F245E.8050506@samsung.com> <521F3515.7040001@ti.com>
 <521F3AA2.9010707@samsung.com> <521F505E.8090607@ti.com>
In-reply-to: <521F505E.8090607@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWyRsSkQFfmsXyQwbl2dYu/k46xWxy8X29x
	Z/5fVovHy/+xWcw/co7V4tTB5awWB/7sYLR409vBYrGwbQmLxeVdc9gsZi/pZ7FYtKyV2WLp
	9YtMFrcbV7BZTJi+lsWi67W8xeEVB5gs1r2czmJxY3oLq8Wrg20sDiIea+atYfT4/WsSo8f7
	G63sHgs+X2H3eD15AqPH5b5eJo+ds+6ye7xaPZPV4861PWwevc3v2Dz6tqxi9Dh+YzuTx+dN
	ch4b54YG8EVx2aSk5mSWpRbp2yVwZSw+E1Aw1aziz+7XLA2Mf7S6GDk5JARMJL60vGSGsMUk
	Ltxbz9bFyMUhJLCUUeLHsv3sMEWn/q1ghUhMZ5S41LMGynnFKNFw+TkjSBWvgJbEpb23WEFs
	FgFVidk3f7OA2GxA8f0vbrCB2KICYRIrp19hgagXlPgx+R6YLQJU03+pmwlkKLPAMWaJtVN3
	gt0kLJAg8XnOdxaIba+ZJF4v+AGW4BRQk9ixfRvYVGYBHYn9rdOgbHmJzWveMoM0SAi84JCY
	ufkm1EkCEt8mHwKaxAGUkJXYdADqaUmJgytusExgFJuF5KhZSMbOQjJ2ASPzKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYzAhHL637O+HYw3D1gfYkwGWjmRWUo0OR+YkPJK4g2NzYwsTE1M
	jY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJiySvSF1fpPu/XiCr0m
	28xw2zZ5R9Zp+9lvdohGSZSu7AnRMvzSd3CytL6k6bfzTCtNU3ZESRX13t0p1fhfxrl20dHD
	i7fsWe4T/e6FLK/zxoTZk2K1l68wmqDp8G/9pfPtYX16i+fJsXZl1M8IvsTvK/x+a5mBeTmr
	7uP0yKvlkw9KKtw9ckSJpTgj0VCLuag4EQAYJFfZPgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xoK7MY/kgg/8PZSz+TjrGbnHwfr3F
	nfl/WS0eL//HZjH/yDlWi1MHl7NaHPizg9HiTW8Hi8XCtiUsFpd3zWGzmL2kn8Vi0bJWZoul
	1y8yWdxuXMFmMWH6WhaLrtfyFodXHGCyWPdyOovFjektrBavDraxOIh4rJm3htHj969JjB7v
	b7Syeyz4fIXd4/XkCYwel/t6mTx2zrrL7vFq9UxWjzvX9rB59Da/Y/Po27KK0eP4je1MHp83
	yXlsnBsawBfVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA/SykkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj8ZmAgqlmFX92
	v2ZpYPyj1cXIySEhYCJx6t8KVghbTOLCvfVsXYxcHEIC0xklLvWsYYVwXjFKNFx+zghSxSug
	JXFp7y2wDhYBVYnZN3+zgNhsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkemC0CVNN/qZsJZCiz
	wDFmibVTdzKDJIQFEiQ+z/nOArHtNZPE6wU/wBKcAmoSO7ZvA5vKLKAjsb91GpQtL7F5zVvm
	CYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPVM6kdjCsbLA4x
	CnAwKvHwPgiWDxJiTSwrrsw9xCjBwawkwhu/DSjEm5JYWZValB9fVJqTWnyIMRkYBhOZpUST
	84GpNK8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGPmzAiyY
	1+pFbQu8vDYloDp9eU37hdtXlk12XOkecu3kkcTtP4zf7wyYoNu+zz+2mPeBU/Pc/RyRAYnu
	S1duKb3Inx+f6b7pcaeZvFleZk+J5bdU6a8quWcUX/5m2b0rjH9mz5k6797NFnL336qvjNX7
	ZHv4xv6QJcWND7IOqi3Pn+8go7BlkRJLcUaioRZzUXEiAARBF3KbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 08/29/2013 10:45 PM, George Cherian wrote:
> Hi Chanwoo,
> 
> 
> On 8/29/2013 5:42 PM, Chanwoo Choi wrote:
> [big snip ]
>>>> I tested various development board based on Samsung Exynos series SoC.
>>>> Although some gpio of Exynos series SoC set high state(non zero, 1) as default value,
>>>> this gpio state could mean off state, disconnected or un-powered state according to gpio.
>>>> Of course, above explanation about specific gpio don't include all gpios.
>>>> This is meaning that there is possibility.
>>> okay then how about adding a flag for inverted logic too.  something like this
>>>
>>> if(of_property_read_bool(np,"inverted_gpio))
>>>      gpio_usbvid->gpio_inv = 1;
>>> And always check on this before deciding?
> Is this fine ?

OK.
But, as Stephen commented on other mail, you should use proper DT helper function.

>>>
>>>>>> Second,
>>>>>> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
>>>>>> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
>>>>>> would not control both "USB-HOST" and "USB" cable state at same time.
>>>>>>
>>>>>> Other extcon devices would support either "USB-HOST" or "USB" cable.
>>>>> The driver has 2 configurations.
>>>>> 1) supports implementations with both VBUS and ID pin are routed via gpio's for swicthing roles(compatible  gpio-usb-vid).
>>>> As you explained about case 1, it is only used on dra7x SoC.
>>> No gpio-usb-id is used in dra7xx. dra7xx has got only ID pin routed via gpio.
>>>> Other SoC could not wish to control both "USB-HOST" and "USB" cable at same time.
> I could'nt actually parse this. You meant since the id_irq_handler handles both USB and USB-HOST cable
> its not proper?

It's not proper in general case. The generic driver must guarantee all of extcon device using gpio.
As far as I know, the generic driver cannot direclty control gpio pin and get value from gpio pin.
Almost device driver including in kernel/drivers control gpio pin on specific device driver 
instead of generic driver.

>> I need your answer about above my opinion for other SoC.
> So how about this, I have removed the dra7x specific stuffs (gpio-usb-id)
> 
> static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
> {
>         int id_current, vbus_current;
> 
>     id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>     if (!!id_current == ID_FLOAT)
>         extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>     else
>         extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
> 
>     vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>      if (!!vbus_current == VBUS_ON)
>         extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
>     else
>         extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
> }
> 
> and the irq handlers like this
> 
> static irqreturn_t id_irq_handler(int irq, void *data)
> {
>         struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>         int id_current;
> 
>         id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>         if (id_current == ID_GND)
>                 extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>         else
>                 extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>         return IRQ_HANDLED;
> }
> 
> static irqreturn_t vbus_irq_handler(int irq, void *data)
> {
>         struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>         int vbus_current;
> 
>         vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>         if (vbus_current == VBUS_OFF)
>                 extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>         else
>                 extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
> 
>         return IRQ_HANDLED;
> }

I know your intention dividing interrupt handler for each cable.
But I don't think this driver must guarantee all of extcon device using gpio.

For example,
below three SoC wish to detect USB/USB-HOST cable with each different methods.

"SoC A" wish to detect USB/USB-HOST cable through only one gpio pin.
"SoC B" wish to detect USB/USB-HOST cable through ADC value instead of gpio pin.
"SoC C" wish to detect USB/USB-HOST cable through two gpio pin because USB connected on gpio an USB-HOST connected on another.

In addition,
if "SoC A/C" wish to write some data to own specific registers for proper opeating,
Could we write some data to register on generic driver?

Finally,
"SoC D" wish to detect USB/USB-HOST/JIG cable through two gpio pin
- one gpio may detect either USB or USB-HOST and another may detect JIG cable
or one gpio may detect either USb or JIG and another may detect USB-HOST cable.

That way, there are many cases we cannot guarantee all of extcon devices.

I think this driver could support dra7x series SoC but as I mentioned,
this driver may not guarantee all of cases.

> [snip]
>>>> I have some confusion. I need additional your explanation.
>>>> Could this driver register only one interrupt handler either id_irq_handler() or vbus_irq_handler()?
>>> If compatible == ID_DETECT, only one handler --> id_irq_handler() and it will handle both USB and USB-HOST
>>>> or
>>>> Could this driver register two interrupt handler both id_irq_handler() or vbus_irq_handler()?
>>> If compatible == VBUS_ID_DETECT, 2 handlers --> id_irq_handler() will handle USB-HOST and vbus_irq_handler will handle USB.
>> As you mentioned, we cannot only control either USB or USB-HOST cable on this extcon driver.
>> This extcon driver is only suitable dra7x SoC.
> Do you still feel its dra7x specific if i modify it as above?

I commented above about your modification.

>> Because id_irq_handler() control both "USB-HOST" and "USB" cable at same time,
>> you need this setting order between "USB-HOST" and "USB" cable.
>>> yes
>> I think that the setting order between cables isn't general. It is specific method for dra7x SoC.
> So if i remove that part then?

The setting order should be removed in generic driver.

>>>> Did you think that SoC should always connect either "USB-HOST" cable or "USB" cable?
>>> No,  even if a physical cable is not connected it should  default to either USB-HOST or USB
>> It isn't general.
>>
>> If physical cable isn't connected to extcon device, the state both USB-HOST and USB cable
>> should certainly be zero. Because The extcon consumer driver could set proper operation
>> according to cable state.
> okay
>>
>>>
>>>> I don't know this case except for dra7x SoC. So, I think it has dependency on specific SoC.
>> I need your answer about above my opinion.
> Hope i could answer you :-)
>>>> and can't agree as generic extcon gpio driver.
>>
> 

Thanks,
Chanwoo Choi
