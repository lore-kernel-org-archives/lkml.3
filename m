Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3H3GxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:53:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3H3GxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:53:15 -0400
X-AuditID: cbfee68e-b7f756d000004512-23-522041573c73
Message-id: <52204158.8070406@samsung.com>
Date: Fri, 30 Aug 2013 15:53:12 +0900
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
 <521FE31D.8050902@samsung.com> <52203872.2050304@ti.com>
In-reply-to: <52203872.2050304@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsWyRsSkSDfcUSHI4OJDdou/k46xWxy8X29x
	Z/5fVovHy/+xWcw/co7V4tTB5awWB/7sYLR409vBYrGwbQmLxeVdc9gsZi/pZ7FYtKyV2WLp
	9YtMFrcbV7BZTJi+lsWi67W8xeEVB5gs1r2czmJxY3oLq8Wrg20sDiIea+atYfT4/WsSo8f7
	G63sHgs+X2H3eD15AqPH5b5eJo+ds+6ye7xaPZPV4861PWwevc3v2Dz6tqxi9Dh+YzuTx+dN
	ch4b54YG8EVx2aSk5mSWpRbp2yVwZTS84ijYGFDx8NpPlgbGTocuRk4OCQETicOrnrFB2GIS
	F+6tB7K5OIQEljJKdB3fwQZT9O7nD1aIxHRGiWU3n0I5rxgljv84wApSxSugJdHxeQs7iM0i
	oCqx6vJFsDgbUHz/ixtgk0QFwiRWTr/CAlEvKPFj8j0wWwSopv9SNxPIUGaBY8wSa6fuZAZJ
	CAskSHye850FYtsyZokL/dPAOjgF1CT+vXnFBGIzC+hI7G+dxgZhy0tsXvOWGeLuNxwSG86U
	QlwkIPFt8iGgXg6guKzEpgNQJZISB1fcYJnAKDYLyU2zkEydhWTqAkbmVYyiqQXJBcVJ6UVG
	esWJucWleel6yfm5mxiB6eT0v2d9OxhvHrA+xJgMtHIis5Rocj4wHeWVxBsamxlZmJqYGhuZ
	W5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVFM1SbgQ9jczuqbjMwlUtOb
	ovY+fOsuHJy0pkfOLF3fvOqYf5TmBqV1/1rWhYkcZCuWYeZglwq5Y/n61cZJPKJTS/Zoeq9a
	sfZ+VPeza98ETLznqB+4q+F3Vv1HcRCfzEp/vqdHT7V+/WkvEmkTd0Xx6+l19jc7ZIzTPjo0
	OBmuXN5/2kzmrxJLcUaioRZzUXEiAFoWgWg9AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xoG6Yo0KQwdfXFhZ/Jx1jtzh4v97i
	zvy/rBaPl/9js5h/5ByrxamDy1ktDvzZwWjxpreDxWJh2xIWi8u75rBZzF7Sz2KxaFkrs8XS
	6xeZLG43rmCzmDB9LYtF12t5i8MrDjBZrHs5ncXixvQWVotXB9tYHEQ81sxbw+jx+9ckRo/3
	N1rZPRZ8vsLu8XryBEaPy329TB47Z91l93i1eiarx51re9g8epvfsXn0bVnF6HH8xnYmj8+b
	5Dw2zg0N4ItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAXpZSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR8IqjYGNAxcNr
	P1kaGDsduhg5OSQETCTe/fzBCmGLSVy4t56ti5GLQ0hgOqPEsptPWSGcV4wSx38cAKviFdCS
	6Pi8hR3EZhFQlVh1+SJYnA0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRYBq+i91M4EMZRY4
	xiyxdupOZpCEsECCxOc531kgti1jlrjQPw2sg1NATeLfm1dMIDazgI7E/tZpbBC2vMTmNW+Z
	JzAKzEKyZBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE5Xz6R3MK5qsDjE
	KMDBqMTD2zBVPkiINbGsuDL3EKMEB7OSCK+ArkKQEG9KYmVValF+fFFpTmrxIcZkYBhMZJYS
	Tc4HptK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBMXfRZ
	fL+4+K5DU2tP3eTX0T92IGT9/1Wia9qS54VPOXD9VO0i14lT/F6fkpV8ZZP5s3Rz/NwZ32P5
	lpu2fHN98GbdPVFv4Rgxd3/7vmdyp68kirQ1z7ecyfizjkPtdK9iU5LXOuWZ/ReZb3V9YNjZ
	JlAprvS41PeKn7L/M46bfAZtpg62kycpsRRnJBpqMRcVJwIAGqncF5sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 08/30/2013 03:15 PM, George Cherian wrote:
> Hi Chanwoo,
> 
> On 8/30/2013 5:41 AM, Chanwoo Choi wrote:
>> Hi George,
>>
>> On 08/29/2013 10:45 PM, George Cherian wrote:
>>> Hi Chanwoo,
>>>
>>>
>>> On 8/29/2013 5:42 PM, Chanwoo Choi wrote:
>>> [big snip ]
>>>>>> I tested various development board based on Samsung Exynos series SoC.
>>>>>> Although some gpio of Exynos series SoC set high state(non zero, 1) as default value,
>>>>>> this gpio state could mean off state, disconnected or un-powered state according to gpio.
>>>>>> Of course, above explanation about specific gpio don't include all gpios.
>>>>>> This is meaning that there is possibility.
>>>>> okay then how about adding a flag for inverted logic too.  something like this
>>>>>
>>>>> if(of_property_read_bool(np,"inverted_gpio))
>>>>>       gpio_usbvid->gpio_inv = 1;
>>>>> And always check on this before deciding?
>>> Is this fine ?
>> OK.
>> But, as Stephen commented on other mail, you should use proper DT helper function.
> okay
>>>>>>>> Second,
>>>>>>>> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
>>>>>>>> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
>>>>>>>> would not control both "USB-HOST" and "USB" cable state at same time.
>>>>>>>>
>>>>>>>> Other extcon devices would support either "USB-HOST" or "USB" cable.
>>>>>>> The driver has 2 configurations.
>>>>>>> 1) supports implementations with both VBUS and ID pin are routed via gpio's for swicthing roles(compatible  gpio-usb-vid).
>>>>>> As you explained about case 1, it is only used on dra7x SoC.
>>>>> No gpio-usb-id is used in dra7xx. dra7xx has got only ID pin routed via gpio.
>>>>>> Other SoC could not wish to control both "USB-HOST" and "USB" cable at same time.
>>> I could'nt actually parse this. You meant since the id_irq_handler handles both USB and USB-HOST cable
>>> its not proper?
>> It's not proper in general case. The generic driver must guarantee all of extcon device using gpio.
>> As far as I know, the generic driver cannot direclty control gpio pin and get value from gpio pin.
>> Almost device driver including in kernel/drivers control gpio pin on specific device driver
>> instead of generic driver.
> But without reading the gpio value how can we set the cable states? for this driver the assumption is the dedicated gpio
> is always DIR_IN and in the driver we just read the value.
>>>> I need your answer about above my opinion for other SoC.
>>> So how about this, I have removed the dra7x specific stuffs (gpio-usb-id)
>>>
>>> static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
>>> {
>>>          int id_current, vbus_current;
>>>
>>>      id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>      if (!!id_current == ID_FLOAT)
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>>      else
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>
>>>      vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>>       if (!!vbus_current == VBUS_ON)
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
>>>      else
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>> }
>>>
>>> and the irq handlers like this
>>>
>>> static irqreturn_t id_irq_handler(int irq, void *data)
>>> {
>>>          struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>>>          int id_current;
>>>
>>>          id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>          if (id_current == ID_GND)
>>>                  extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>          else
>>>                  extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>>          return IRQ_HANDLED;
>>> }
>>>
>>> static irqreturn_t vbus_irq_handler(int irq, void *data)
>>> {
>>>          struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>>>          int vbus_current;
>>>
>>>          vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>>          if (vbus_current == VBUS_OFF)
>>>                  extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>>          else
>>>                  extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
>>>
>>>          return IRQ_HANDLED;
>>> }
>> I know your intention dividing interrupt handler for each cable.
>> But I don't think this driver must guarantee all of extcon device using gpio.
>>
>> For example,
>> below three SoC wish to detect USB/USB-HOST cable with each different methods.
>>
>> "SoC A" wish to detect USB/USB-HOST cable through only one gpio pin.
> 
> You mean to say that both USB ID pin and VBUS are connected to same gpio?
> If so that is a really bad h/w design and it will not fly.
> Or, you meant that only USB ID pin is connected to single gpio and it controls the state of the USB/USB-HOST cables?
> If so thats what exactly the v3 driver did with compatible gpio-usb-id.

My original question intention,
I'd like you to answer that this driver can support all case of "SoC A"/"SoC B"/"SoC C" without othe implementation?

> 
>> "SoC B" wish to detect USB/USB-HOST cable through ADC value instead of gpio pin.
> 
> Via ADC this driver should never be used , it should be extcon-adc-usbvid driver and not extcon-gpio-usbvid driver.

No, we cannot implement many generic extcon device driver whenever this is the case.

>> "SoC C" wish to detect USB/USB-HOST cable through two gpio pin because USB connected on gpio an USB-HOST connected on another.
> 
> Whatever modifications above should meet this need  in combination with named gpios (id_gpio and vbus_gpio in dt)as stephen pointed.
> But still i feel the above modification would even support Soc A provided the code registered for the notifier could handle it properly.

I'd like you to answer that this driver can support all case of "SoC A"/"SoC B"/"SoC C"?
If we should implement extcon device driver according each case,
Could you tell me that this driver is generic? I think NO.

>>
>> In addition,
>> if "SoC A/C" wish to write some data to own specific registers for proper opeating,
>> Could we write some data to register on generic driver?
> 
> Yes definitely, those register configuration should not be part of this driver and it should be done in the notifier handler.

No. there are many extcon consumer driver. We cannot order the sequence of notification reception among all of extcon consumer driver.
Only, extcon consumer driver get the changed state of cable and can never set cable H/W setting in extcon consumer driver.
Certainly, we have to set cabe H/W setting in extcon producer driver.

>>
>> Finally,
>> "SoC D" wish to detect USB/USB-HOST/JIG cable through two gpio pin
> Correct me If I am wrong, USB JIG is not a standard cable. so for supporting that anyways you need to have
> a different driver.

No, we cannot guarantee that some cable would be connected to SoC.
If this dirver is generic, it have to certainly support above all case in this driver.

>> - one gpio may detect either USB or USB-HOST and another may detect JIG cable
> I assume u meant the USB ID pin is connected to one gpio and based on it value USB/USB-HOST  is detected.
>> or one gpio may detect either USb or JIG and another may detect USB-HOST cable.
>  As I mentioned earlier these are gpios configured as input and if you try to drive with 2 sources (USB and JIG or USB and USB-HOST etc)
> then its a potentially bad design . If at all we need to identify all 3 then there should be 3 dedicated gpios.
> 
>> That way, there are many cases we cannot guarantee all of extcon devices.
>>
>> I think this driver could support dra7x series SoC but as I mentioned,
>> this driver may not guarantee all of cases.
> I am sorry, I feel it supports all standard cases except for something like a JIG cable which is not standard.

I've never seen spec documentation that USB/USB-HOST cable have to be only connected to SoC.
As I mentioned above, there are many cases we cannot think about various extcon devices.

>>
>>> [snip]
>>>>>> I have some confusion. I need additional your explanation.
>>>>>> Could this driver register only one interrupt handler either id_irq_handler() or vbus_irq_handler()?
>>>>> If compatible == ID_DETECT, only one handler --> id_irq_handler() and it will handle both USB and USB-HOST
>>>>>> or
>>>>>> Could this driver register two interrupt handler both id_irq_handler() or vbus_irq_handler()?
>>>>> If compatible == VBUS_ID_DETECT, 2 handlers --> id_irq_handler() will handle USB-HOST and vbus_irq_handler will handle USB.
>>>> As you mentioned, we cannot only control either USB or USB-HOST cable on this extcon driver.
>>>> This extcon driver is only suitable dra7x SoC.
>>> Do you still feel its dra7x specific if i modify it as above?
>> I commented above about your modification.
>>
>>>> Because id_irq_handler() control both "USB-HOST" and "USB" cable at same time,
>>>> you need this setting order between "USB-HOST" and "USB" cable.
>>>>> yes
>>>> I think that the setting order between cables isn't general. It is specific method for dra7x SoC.
>>> So if i remove that part then?
>> The setting order should be removed in generic driver.
> Yes I agree and should be done by the subscriber to the notifier.

OK.

>>
>>>>>> Did you think that SoC should always connect either "USB-HOST" cable or "USB" cable?
>>>>> No,  even if a physical cable is not connected it should  default to either USB-HOST or USB
>>>> It isn't general.
>>>>
>>>> If physical cable isn't connected to extcon device, the state both USB-HOST and USB cable
>>>> should certainly be zero. Because The extcon consumer driver could set proper operation
>>>> according to cable state.
>>> okay
>>>>>> I don't know this case except for dra7x SoC. So, I think it has dependency on specific SoC.
>>>> I need your answer about above my opinion.
>>> Hope i could answer you :-)
>>>>>> and can't agree as generic extcon gpio driver.
>> Thanks,
>> Chanwoo Choi


Thanks,
Chanwoo Choi

