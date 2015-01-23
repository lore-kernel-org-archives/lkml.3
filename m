Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbbAWLRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:17:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34368 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbbAWLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:17:34 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee68e-f79b46d000002b74-b0-54c22dcb26d6
Content-transfer-encoding: 8BIT
Message-id: <54C22DCB.8050704@samsung.com>
Date: Fri, 23 Jan 2015 20:17:31 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH 2/6] extcon: max77843: Add max77843 MUIC driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-3-git-send-email-jaewon02.kim@samsung.com>
 <54C1E853.2020105@samsung.com>
In-reply-to: <54C1E853.2020105@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkRPeM7qEQg5e/OS1Of9rGbjH14RM2
	i+tfnrNazD9yjtWi/81CVotzr1YyWky6P4HF4v7Xo4wWl3fNYbP43HuE0WLp9YtMFhOmr2Wx
	aN17hN3i9O4SBz6PNfPWMHpc7utl8li5/Aubx6ZVnWwed67tYfPo27KK0ePzJrkA9igum5TU
	nMyy1CJ9uwSujAfTdzIXbO5iqnj67hhzA+P9m4xdjJwcEgImEr+XnIWyxSQu3FvP1sXIxSEk
	sJRR4vSzhXBFGyfPZoFILGKUmP9rNytIgldAUOLH5HtACQ4OZgF5iSOXskHCzAJmEo9a1jFD
	1L9mlFjw8gc7RL2WxPctB5lBbBYBVYnD/yeALWAT0Jb4vn4x2ExRgQiJ+cdeg9WICGhIzPx7
	hRFkELPAKWaJk4t7mEASwgLOElPbZ7JCbFjBKLH69j4WkAQn0KTdCy6B/SAhMJND4trETewQ
	6wQkvk0+BHaqhICsxKYDzBCvSUocXHGDZQKj2CwkD81CeGgWkocWMDKvYhRNLUguKE5KLzLS
	K07MLS7NS9dLzs/dxAiM6tP/nvXtYLx5wPoQowAHoxIPb+OWgyFCrIllxZW5hxhNgY6YyCwl
	mpwPTB15JfGGxmZGFqYmpsZG5pZmSuK8CVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	KrhceKq+PeTI3SefWt4vmnLDm8HBoGt526rpjB9vtLxarxAYsvBFfyFLY0eXMO/tJr5Du6ZK
	fSjym7U8aMqMJ7ev8EdPyf7rWjT75eUlkzyljhQcrM+qa7vm+ljdQNbBeNaNlhbzOa3ZAinf
	FuUtnfxnyuUNKZNEFdZHrDV7xTmzynOVxKIfAUosxRmJhlrMRcWJALeF5DrlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd3TuodCDBbvMrM4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWi/tfjzJaXN41h83ic+8RRoul1y8yWUyYvpbF
	onXvEXaL07tLHPg81sxbw+hxua+XyWPl8i9sHptWdbJ53Lm2h82jb8sqRo/Pm+QC2KMaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY8mL6TuWBzF1PF03fHmBsY799k7GLk
	5JAQMJHYOHk2C4QtJnHh3nq2LkYuDiGBRYwS83/tZgVJ8AoISvyYfA+oiIODWUBe4silbJAw
	s4CZxKOWdcwQ9a8ZJRa8/MEOUa8l8X3LQWYQm0VAVeLw/wlgy9gEtCW+r18MNlNUIEJi/rHX
	YDUiAhoSM/9eYQQZxCxwilni5OIeJpCEsICzxNT2mawQG1YwSqy+vQ/sVE6gSbsXXGKbwCgw
	C8mBsxAOnIXkwAWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPGM+kdjKsaLA4xCnAw
	KvHwNmw5GCLEmlhWXJl7iFGCg1lJhNda81CIEG9KYmVValF+fFFpTmrxIUZToPcmMkuJJucD
	01leSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAPj0kqLzQKKJxVV
	4l/PcZn16f25Pytvyyy28eSdx2twmbmEUVlU7c++enWd3dxWpnc4UqZ4pp8Q7n1h3i4r0DBL
	f13kORnJU5Vn9CXvRib1z5hUo83Rb3BG0aksJftjxpGHlvvqA874vLLUduE9eI5RX2JZwsG7
	PIZ7Xry6kyJp2P/N99PcD0ZKLMUZiYZazEXFiQAxpuuSLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

2015년 01월 23일 15:21에 Chanwoo Choi 이(가) 쓴 글:
> Hi Jaewon,
>
> On 01/23/2015 02:02 PM, Jaewon Kim wrote:
>> This patch adds MAX77843 extcon driver to support for MUIC(Micro
> Add company name (MAX77843 -> Maxim MAX77843)

Okay. I will fix it.
>
>> USB Interface Controller) device by using EXTCON subsystem to handle
>> various external connectors.
>>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> ---
>>   drivers/extcon/Kconfig           |   10 +
>>   drivers/extcon/Makefile          |    1 +
>>   drivers/extcon/extcon-max77843.c |  871 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 882 insertions(+)
>>   create mode 100644 drivers/extcon/extcon-max77843.c
>>
>> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
>> index 6a1f7de..0b67538 100644
>> --- a/drivers/extcon/Kconfig
>> +++ b/drivers/extcon/Kconfig
>> @@ -55,6 +55,16 @@ config EXTCON_MAX77693
>>   	  Maxim MAX77693 PMIC. The MAX77693 MUIC is a USB port accessory
>>   	  detector and switch.
>>   
>> +config EXTCON_MAX77843
>> +	tristate "MAX77843 EXTCON Support"
>> +	depends on MFD_MAX77843
>> +	select IRQ_DOMAIN
>> +	select REGMAP_I2C
>> +	help
>> +	  If you say yes here you get support for the MUIC device of
>> +	  Maxim MAX77843. The MAX77843 MUIC is a USB port accessory
>> +	  detector add switch.
>> +
>>   config EXTCON_MAX8997
>>   	tristate "MAX8997 EXTCON Support"
>>   	depends on MFD_MAX8997 && IRQ_DOMAIN
>> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
>> index 0370b42..f21d5c4 100644
>> --- a/drivers/extcon/Makefile
>> +++ b/drivers/extcon/Makefile
>> @@ -8,6 +8,7 @@ obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
>>   obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
>>   obj-$(CONFIG_EXTCON_MAX14577)	+= extcon-max14577.o
>>   obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
>> +obj-$(CONFIG_EXTCON_MAX77843)	+= extcon-max77843.o
>>   obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>>   obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
>>   obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
>> diff --git a/drivers/extcon/extcon-max77843.c b/drivers/extcon/extcon-max77843.c
>> new file mode 100644
>> index 0000000..caae9a7
>> --- /dev/null
>> +++ b/drivers/extcon/extcon-max77843.c
>> @@ -0,0 +1,871 @@
>> +/*
>> + * extcon-max77843.c - MAX77843 extcon driver to support MUIC
>> + *
>> + * Copyright (C) 2014 Samsung Electrnoics
>> + *  Author: Jaewon Kim <jaewon02.kim@samsung.com>
> Remove un-necessary blank before 'Author'.

Okay. I will fix it.
>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/extcon.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/mfd/max77843-private.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/workqueue.h>
>> +
>> +#define DELAY_MS_DEFAULT		15000	/* unit: millisecond */
>> +
>> +enum max77843_muic_acc_type {
>> +	MAX77843_MUIC_ADC_GROUND = 0,
>> +	MAX77843_MUIC_ADC_SEND_END_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S1_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S2_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S3_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S4_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S5_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S6_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S7_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S8_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S9_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S10_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S11_BUTTON,
>> +	MAX77843_MUIC_ADC_REMOTE_S12_BUTTON,
>> +	MAX77843_MUIC_ADC_RESERVED_ACC_1,
>> +	MAX77843_MUIC_ADC_RESERVED_ACC_2,
>> +	MAX77843_MUIC_ADC_RESERVED_ACC_3,
>> +	MAX77843_MUIC_ADC_RESERVED_ACC_4,
>> +	MAX77843_MUIC_ADC_RESERVED_ACC_5,
>> +	MAX77843_MUIC_ADC_AUDIO_DEVICE_TYPE2,
>> +	MAX77843_MUIC_ADC_PHONE_POWERED_DEV,
>> +	MAX77843_MUIC_ADC_TTY_CONVERTER,
>> +	MAX77843_MUIC_ADC_UART_CABLE,
>> +	MAX77843_MUIC_ADC_CEA936A_TYPE1_CHG,
>> +	MAX77843_MUIC_ADC_FACTORY_MODE_USB_OFF,
>> +	MAX77843_MUIC_ADC_FACTORY_MODE_USB_ON,
>> +	MAX77843_MUIC_ADC_AV_CABLE_NOLOAD,
>> +	MAX77843_MUIC_ADC_CEA936A_TYPE2_CHG,
>> +	MAX77843_MUIC_ADC_FACTORY_MODE_UART_OFF,
>> +	MAX77843_MUIC_ADC_FACTORY_MODE_UART_ON,
>> +	MAX77843_MUIC_ADC_AUDIO_DEVICE_TYPE1,
>> +	MAX77843_MUIC_ADC_OPEN,
>> +};
>> +
>> +enum max77843_muic_cable_group {
>> +	MAX77843_CABLE_GROUP_ADC = 0,
>> +	MAX77843_CABLE_GROUP_CHG,
>> +	MAX77843_CABLE_GROUP_GND,
>> +};
> Cable group show the category of supported cables.
> I think you better move this enum on upper of 'enum max77843_muic_acc_type'

This is not a cable type.
I categorized cable group. GROUP_ADC  is

We can know cable group by IRQ type. so I categorized cable group.

It is used to parameter of 'max77843_muic_get_cable_type()' function.


>
>> +
>> +enum max77843_muic_adv_debounce_time {
>> +	MAX77843_DEBOUNCE_TIME_5MS = 0,
>> +	MAX77843_DEBOUNCE_TIME_10MS,
>> +	MAX77843_DEBOUNCE_TIME_25MS,
>> +	MAX77843_DEBOUNCE_TIME_38_62MS,
>> +};
>> +
>> +enum max77843_muic_support_list {
> Use only 'enum' keyword without 'max77843_muic_support_list' enum name.
Okay, i remove enum name.
>
>> +	EXTCON_CABLE_USB = 0,
>> +	EXTCON_CABLE_USB_HOST,
>> +	EXTCON_CABLE_USB_HOST_TA,
>> +	EXTCON_CABLE_TA,
>> +	EXTCON_CABLE_FAST_CHARGER,
>> +	EXTCON_CABLE_SLOW_CHARGER,
>> +	EXTCON_CABLE_CHARGE_DOWNSTREAM,
>> +	EXTCON_CABLE_MHL,
>> +	EXTCON_CABLE_MHL_TA,
>> +	EXTCON_CABLE_JIG_USB_ON,
>> +	EXTCON_CABLE_JIG_USB_OFF,
>> +	EXTCON_CABLE_JIG_UART_OFF,
>> +	EXTCON_CABLE_JIG_UART_ON,
>> +
>> +	EXTCON_CABLE_NUM,
>> +};
>> +
>> +enum max77843_muic_gnd_cable {
>> +	MAX77843_MUIC_GND_USB_OTG	= 0x0,
>> +	MAX77843_MUIC_GND_USB_OTG_VB	= 0x1,
>> +	MAX77843_MUIC_GND_MHL		= 0x2,
>> +	MAX77843_MUIC_GND_MHL_VB	= 0x3,
> Why do you need 'max77843_muic_gnd_cable' enum?
> You have to express supported all cables in 'max77843_muic_acc_type' enum list.
> If you define one more cables enumeration, It is possible to incur the confusion
> of what this driver is supported cable.
I will clean up 'max77843_muic_gnd_cable' and it will be move to 
'max77843_muic_acc_type'

>
>
>> +
>> +	MAX77843_MUIC_GND_NUM,
>> +};
>> +
>> +enum max77843_muic_status {
>> +	MAX77843_MUIC_STATUS1 = 0,
>> +	MAX77843_MUIC_STATUS2,
>> +	MAX77843_MUIC_STATUS3,
>> +
>> +	MAX77843_MUIC_STATUS_NUM,
>> +};
>> +
>> +enum max77843_muic_charger_type {
>> +	MAX77843_CHG_TYPE_NONE = 0,
>> +	MAX77843_CHG_TYPE_USB,
>> +	MAX77843_CHG_TYPE_DOWNSTREAM,
>> +	MAX77843_CHG_TYPE_DEDICATED,
>> +	MAX77843_CHG_TYPE_SPECIAL_500MA,
>> +	MAX77843_CHG_TYPE_SPECIAL_1A,
>> +	MAX77843_CHG_TYPE_SPECIAL_BIAS,
>> +
>> +	MAX77843_CHG_TYPE_END,
>> +};
>> +
>> +enum max77843_muic_detection {
>> +	MAX77843_MUIC_AUTO_NONE = 0,
>> +	MAX77843_MUIC_AUTO_USB,
>> +	MAX77843_MUIC_AUTO_FAC,
>> +	MAX77843_MUIC_AUTO_USB_FAC,
>> +};
> It it wrong. This enum is used to write the value to MUIC register.
> You have to define it in max77843-private.h with 'enum' keyword.
> I think you could refer other definition in max77843-private.h.
>
> You have to re-order the definition by using follwoing sequence
> to improbe readability.
> 1. cable group
> 2. supported cables
> 3. other definition with enum
>
> Also,
> I'm difficult to understand the meaning of enum definition.
> MAX77843_MUIC_*
> MAX77843_CABLE_*
> MAX77843_DEBOUNCE_*
> MAX77843_CHG_*
>
> I think you need to clarify the meaning of enum definition
> by makingt the name pattern to improve readability.

Thank to point out confusing names.
I will cleanup overall enum lists.

>
>> +
>> +struct max77843_muic_info {
>> +	struct device *dev;
>> +	struct max77843 *max77843;
>> +	struct extcon_dev *edev;
>> +
>> +	struct mutex mutex;
>> +	struct work_struct irq_work;
>> +	struct delayed_work wq_detcable;
>> +	struct max77843_muic_irq *muic_irqs;
>> +
>> +	u8 status[MAX77843_MUIC_STATUS_NUM];
>> +	int prev_cable_type;
>> +	int prev_chg_type;
>> +	int prev_gnd_type;
>> +
>> +	bool irq_adc;
>> +	bool irq_chg;
>> +	bool init_done;
> I don't want to use the 'init_done' field. I think it is legacy way
> to solve some issue. I recommend you use other way.
Okay, I will check it than use init_done variable.
>
>> +};
>> +
>> +struct max77843_muic_irq {
>> +	unsigned int irq;
>> +	const char *name;
>> +	unsigned int virq;
>> +};
>> +
>> +static const struct regmap_config max77843_muic_regmap_config = {
>> +	.reg_bits       = 8,
>> +	.val_bits       = 8,
>> +	.max_register   = MAX77843_MUIC_REG_END,
>> +};
>> +
>> +static const struct regmap_irq max77843_muic_irq[] = {
>> +	/* MUIC:INT1 interrupts */
> 	
> Don' need 'MUIC:' prefix and fix string (s/interrupts/interrupt).
>
>> +	{ .reg_offset = 0, .mask = MAX77843_MUIC_ADC, },
>> +	{ .reg_offset = 0, .mask = MAX77843_MUIC_ADCERROR, },
>> +	{ .reg_offset = 0, .mask = MAX77843_MUIC_ADC1K, },
>> +
>> +	/* MUIC:INT2 interrupts */
> ditto.
>
>> +	{ .reg_offset = 1, .mask = MAX77843_MUIC_CHGTYP, },
>> +	{ .reg_offset = 1, .mask = MAX77843_MUIC_CHGDETRUN, },
>> +	{ .reg_offset = 1, .mask = MAX77843_MUIC_DCDTMR, },
>> +	{ .reg_offset = 1, .mask = MAX77843_MUIC_DXOVP, },
>> +	{ .reg_offset = 1, .mask = MAX77843_MUIC_VBVOLT, },
>> +
>> +	/* MUIC:INT3 interrupts */
> ditto.
>
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_VBADC, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_VDNMON, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_DNRES, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_MPNACK, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_MRXBUFOW, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_MRXTRF, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_MRXPERR, },
>> +	{ .reg_offset = 2, .mask = MAX77843_MUIC_MRXRDY, },
>> +};
>> +
>> +static const struct regmap_irq_chip max77843_muic_irq_chip = {
>> +	.name           = "max77843-muic",
>> +	.status_base    = MAX77843_MUIC_REG_INT1,
>> +	.mask_base      = MAX77843_MUIC_REG_INTMASK1,
>> +	.mask_invert    = true,
>> +	.num_regs       = 3,
>> +	.irqs           = max77843_muic_irq,
>> +	.num_irqs       = ARRAY_SIZE(max77843_muic_irq),
>> +};
>> +
>> +static const char *max77843_extcon_cable[] = {
>> +	[EXTCON_CABLE_USB]			= "USB",
>> +	[EXTCON_CABLE_USB_HOST]			= "USB-HOST",
>> +	[EXTCON_CABLE_USB_HOST_TA]		= "USB-HOST-TA",
>> +	[EXTCON_CABLE_TA]			= "TA",
>> +	[EXTCON_CABLE_FAST_CHARGER]		= "FAST-CHARGER",
>> +	[EXTCON_CABLE_SLOW_CHARGER]		= "SLOW-CHARGER",
>> +	[EXTCON_CABLE_CHARGE_DOWNSTREAM]	= "CHARGER-DOWNSTREAM",
>> +	[EXTCON_CABLE_MHL]			= "MHL",
>> +	[EXTCON_CABLE_MHL_TA]			= "MHL-TA",
>> +	[EXTCON_CABLE_JIG_USB_ON]		= "JIG-USB-ON",
>> +	[EXTCON_CABLE_JIG_USB_OFF]		= "JIG-USB-OFF",
>> +	[EXTCON_CABLE_JIG_UART_OFF]		= "JIG-UART-OFF",
>> +	[EXTCON_CABLE_JIG_UART_ON]		= "JIG-UART-ON",
>> +};
>> +
>> +static struct max77843_muic_irq max77843_muic_irqs[] = {
>> +	{ MAX77843_MUIC_IRQ_INT1_ADC,		"MUIC-ADC" },
>> +	{ MAX77843_MUIC_IRQ_INT1_ADCERROR,	"MUIC-ADC_ERROR" },
>> +	{ MAX77843_MUIC_IRQ_INT1_ADC1K,		"MUIC-ADC1K" },
>> +	{ MAX77843_MUIC_IRQ_INT2_CHGTYP,	"MUIC-CHGTYP" },
>> +	{ MAX77843_MUIC_IRQ_INT2_CHGDETRUN,	"MUIC-CHGDETRUN" },
>> +	{ MAX77843_MUIC_IRQ_INT2_DCDTMR,	"MUIC-DCDTMR" },
>> +	{ MAX77843_MUIC_IRQ_INT2_DXOVP,		"MUIC-DXOVP" },
>> +	{ MAX77843_MUIC_IRQ_INT2_VBVOLT,	"MUIC-VBVOLT" },
>> +	{ MAX77843_MUIC_IRQ_INT3_VBADC,		"MUIC-VBADC" },
>> +	{ MAX77843_MUIC_IRQ_INT3_VDNMON,	"MUIC-VDNMON" },
>> +	{ MAX77843_MUIC_IRQ_INT3_DNRES,		"MUIC-DNRES" },
>> +	{ MAX77843_MUIC_IRQ_INT3_MPNACK,	"MUIC-MPNACK"},
>> +	{ MAX77843_MUIC_IRQ_INT3_MRXBUFOW,	"MUIC-MRXBUFOW"},
>> +	{ MAX77843_MUIC_IRQ_INT3_MRXTRF,	"MUIC-MRXTRF"},
>> +	{ MAX77843_MUIC_IRQ_INT3_MRXPERR,	"MUIC-MRXPERR"},
>> +	{ MAX77843_MUIC_IRQ_INT3_MRXRDY,	"MUIC-MRXRDY"},
>> +};
>> +
>> +static int max77843_muic_set_path(struct max77843_muic_info *info,
>> +		u8 val, bool attached)
>> +{
>> +	struct max77843 *max77843 = info->max77843;
>> +	int ret = 0;
>> +	unsigned int ctrl1, ctrl2;
>> +
>> +	if (attached)
>> +		ctrl1 = val;
>> +	else
>> +		ctrl1 = MAX77843_SWITCH_OPEN;
> 'SWITCH' keyword is right?
> I can't the 'SWITCH' word in CONTROL1 register of MAX77843 MUIC datasheet.
> When you define the field for register, I prefer to use the word which
> expressed in register map of datasheet.
>
>> +
>> +	ret = regmap_update_bits(max77843->regmap_muic,
>> +			MAX77843_MUIC_REG_CONTROL1,
>> +			MAX77843_SIWTH_PORT, ctrl1);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "Cannot switch MUIC port\n");
>> +		return ret;
>> +	}
>> +
>> +	if (attached)
>> +		ctrl2 = MAX77843_MUIC_CONTROL2_CPEN_MASK;
>> +	else
>> +		ctrl2 = MAX77843_MUIC_CONTROL2_LOWPWR_MASK;
>> +
>> +	ret = regmap_update_bits(max77843->regmap_muic,
>> +			MAX77843_MUIC_REG_CONTROL2,
>> +			MAX77843_MUIC_CONTROL2_LOWPWR_MASK |
>> +			MAX77843_MUIC_CONTROL2_CPEN_MASK, ctrl2);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "Cannot update lowpower mode\n");
>> +		return ret;
>> +	}
>> +
>> +	dev_dbg(info->dev,
>> +		"CONTROL1 : 0x%02x, CONTROL2 : 0x%02x, state : %s\n",
>> +		ctrl1, ctrl2, attached ? "attached" : "detached");
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77843_muic_get_cable_type(struct max77843_muic_info *info,
>> +		enum max77843_muic_cable_group group, bool *attached)
>> +{
>> +	int adc, chg_type, cable_type, gnd_type;
>> +
>> +	adc = info->status[MAX77843_MUIC_STATUS1] &
>> +			MAX77843_MUIC_STATUS1_ADC_MASK;
> If you use the short definition for 'MAX77843_MUIC_STATUS1',
> you could make this code on one line.
>
>> +	adc >>= STATUS1_ADC_SHIFT;
>> +
>> +	switch (group) {
>> +	case MAX77843_CABLE_GROUP_ADC:
>> +		if (adc == MAX77843_MUIC_ADC_OPEN) {
>> +			*attached = false;
>> +			cable_type = info->prev_cable_type;
>> +			info->prev_cable_type = MAX77843_MUIC_ADC_OPEN;
>> +		} else {
>> +			*attached = true;
>> +			cable_type = info->prev_cable_type = adc;
>> +		}
>> +
>> +		break;
>> +	case MAX77843_CABLE_GROUP_CHG:
>> +		if (adc == MAX77843_MUIC_ADC_GROUND) {
>> +			*attached = true;
>> +			cable_type = adc;
>> +			break;
>> +		}
>> +
>> +		chg_type = info->status[MAX77843_MUIC_STATUS2] &
>> +			MAX77843_MUIC_STATUS2_CHGTYP_MASK;
> ditto and I think you need one more indentation for readabiltiy.
>
>
>> +		chg_type >>= STATUS2_CHGTYP_SHIFT;
>> +
> Remove unneeded blank line.
>
>> +		if (chg_type == MAX77843_CHG_TYPE_NONE) {
>> +			*attached = false;
>> +			cable_type = info->prev_chg_type;
>> +			info->prev_chg_type = MAX77843_CHG_TYPE_NONE;
>> +		} else {
>> +			*attached = true;
>> +			cable_type = info->prev_chg_type = chg_type;
>> +		}
>> +
>> +		break;
>> +	case MAX77843_CABLE_GROUP_GND:
>> +		adc = info->status[MAX77843_MUIC_STATUS1] &
>> +			MAX77843_MUIC_STATUS1_ADC_MASK;
> ditto.
>
>> +		adc >>= STATUS1_ADC_SHIFT;
>> +
>> +		if (adc == MAX77843_MUIC_ADC_GROUND) {
>> +			*attached = true;
>> +			gnd_type = (info->status[MAX77843_MUIC_STATUS1] &
>> +					MAX77843_MUIC_STATUS1_ADC1K_MASK) >>
>> +					(STATUS1_ADC1K_SHIFT-1);
>> +			gnd_type |= (info->status[MAX77843_MUIC_STATUS2] &
>> +					MAX77843_MUIC_STATUS2_VBVOLT_MASK) >>
>> +					STATUS2_VBVOLT_SHIFT;
>> +			cable_type = info->prev_gnd_type = gnd_type;
>> +		} else {
>> +			*attached = false;
>> +			cable_type = info->prev_gnd_type;
>> +			info->prev_gnd_type = MAX77843_MUIC_GND_NUM;
>> +		}
>> +
>> +		break;
>> +	default:
>> +		dev_err(info->dev, "Unknown cable group (%d)\n", group);
>> +		cable_type = -EINVAL;
>> +
>> +		break;
>> +	}
>> +
>> +	return cable_type;
>> +}
>> +
>> +static int max77843_muic_adc_gnd_handler(struct max77843_muic_info *info)
>> +{
>> +	int ret, gnd_cable_type;
>> +	u8 path;
>> +	bool attached;
>> +
>> +	gnd_cable_type = max77843_muic_get_cable_type(info,
>> +			MAX77843_CABLE_GROUP_GND, &attached);
>> +	dev_dbg(info->dev, "external connector is %s (gnd:0x%02x)\n",
>> +			attached ? "attached" : "detached", gnd_cable_type);
>> +
>> +	switch (gnd_cable_type) {
>> +	case MAX77843_MUIC_GND_USB_OTG:
>> +		extcon_set_cable_state(info->edev, "USB-HOST", attached);
>> +		path = MAX77843_SWITCH_USB;
> Change the name insted of 'SWITCH' word.
>
> Also, I think you have to change the path before sending uevent about cable information.
> If you set cable state before setting the path, user-process might get the uevent
> before changing the MUIC path. You have to modify it when cable state is changed.
>
>> +		info->irq_chg = false;
>> +		break;
>> +	case MAX77843_MUIC_GND_USB_OTG_VB:
>> +		extcon_set_cable_state(info->edev, "USB-HOST-TA", attached);
>> +		path = MAX77843_SWITCH_USB;
> ditto.
>
>> +		info->irq_chg = false;
>> +		break;
>> +	case MAX77843_MUIC_GND_MHL:
>> +		extcon_set_cable_state(info->edev, "MHL", attached);
>> +		path = MAX77843_SWITCH_OPEN;
> ditto.
>
>> +		info->irq_chg = false;
>> +		break;
>> +	case MAX77843_MUIC_GND_MHL_VB:
>> +		extcon_set_cable_state(info->edev, "MHL-TA", attached);
>> +		path = MAX77843_SWITCH_OPEN;
> ditto.
>
>> +		info->irq_chg = false;
>> +		break;
>> +	default:
>> +		dev_err(info->dev, "Cannot detect %s cable of gnd type\n",
>> +			attached ? "attached" : "detached");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = max77843_muic_set_path(info, path, attached);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77843_muic_jig_handler(struct max77843_muic_info *info,
>> +		int cable_type, bool attached)
>> +{
>> +	char cable_name[32];
> Remove 'cable_name' array
>
>> +	u8 path = MAX77843_SWITCH_OPEN;
>> +	int ret;
>> +
>> +	dev_dbg(info->dev, "external connector is %s (adc:0x%02x)\n",
>> +			attached ? "attached" : "detached", cable_type);
>> +
>> +	switch (cable_type) {
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_USB_OFF:
>> +		strcpy(cable_name, "JIG-USB-OFF");
> You execute direclty extcon_set_cable_state() function instead of using strcpy.
Okay, i will fix it.
>
>> +		path = MAX77843_SWITCH_USB;
>> +		break;
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_USB_ON:
>> +		strcpy(cable_name, "JIG-USB-ON");
>> +		path = MAX77843_SWITCH_USB;
>> +		break;
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_UART_OFF:
>> +		strcpy(cable_name, "JIG-UART-OFF");
>> +		path = MAX77843_SWITCH_UART;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	ret = max77843_muic_set_path(info, path, attached);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	extcon_set_cable_state(info->edev, cable_name, attached);
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77843_muic_adc_handler(struct max77843_muic_info *info)
>> +{
>> +	int ret, cable_type;
>> +	bool attached;
>> +
>> +	cable_type = max77843_muic_get_cable_type(info,
>> +			MAX77843_CABLE_GROUP_ADC, &attached);
>> +
>> +	dev_dbg(info->dev,
>> +		"external connector is %s (adc:0x%02x, prev_adc:0x%x)\n",
>> +		attached ? "attached" : "detached", cable_type,
>> +		info->prev_cable_type);
>> +
>> +	switch (cable_type) {
>> +	case MAX77843_MUIC_ADC_GROUND:
>> +		ret = max77843_muic_adc_gnd_handler(info);
>> +		if (ret < 0)
>> +			return ret;
>> +		break;
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_USB_OFF:
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_USB_ON:
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_UART_OFF:
>> +		ret = max77843_muic_jig_handler(info, cable_type, attached);
>> +		if (ret < 0)
>> +			return ret;
>> +		break;
>> +	case MAX77843_MUIC_ADC_SEND_END_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S1_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S2_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S3_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S4_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S5_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S6_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S7_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S8_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S9_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S10_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S11_BUTTON:
>> +	case MAX77843_MUIC_ADC_REMOTE_S12_BUTTON:
>> +	case MAX77843_MUIC_ADC_RESERVED_ACC_1:
>> +	case MAX77843_MUIC_ADC_RESERVED_ACC_2:
>> +	case MAX77843_MUIC_ADC_RESERVED_ACC_3:
>> +	case MAX77843_MUIC_ADC_RESERVED_ACC_4:
>> +	case MAX77843_MUIC_ADC_RESERVED_ACC_5:
>> +	case MAX77843_MUIC_ADC_AUDIO_DEVICE_TYPE2:
>> +	case MAX77843_MUIC_ADC_PHONE_POWERED_DEV:
>> +	case MAX77843_MUIC_ADC_TTY_CONVERTER:
>> +	case MAX77843_MUIC_ADC_UART_CABLE:
>> +	case MAX77843_MUIC_ADC_CEA936A_TYPE1_CHG:
>> +	case MAX77843_MUIC_ADC_AV_CABLE_NOLOAD:
>> +	case MAX77843_MUIC_ADC_CEA936A_TYPE2_CHG:
>> +	case MAX77843_MUIC_ADC_FACTORY_MODE_UART_ON:
>> +	case MAX77843_MUIC_ADC_AUDIO_DEVICE_TYPE1:
>> +	case MAX77843_MUIC_ADC_OPEN:
>> +		dev_err(info->dev,
>> +			"accessory is %s but it isn't used (adc:0x%x)\n",
>> +			attached ? "attached" : "detached", cable_type);
>> +		return -EAGAIN;
>> +	default:
>> +		dev_err(info->dev,
>> +			"failed to detect %s accessory (adc:0x%x)\n",
>> +			attached ? "attached" : "detached", cable_type);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77843_muic_chg_handler(struct max77843_muic_info *info)
>> +{
>> +	int ret, chg_type;
>> +	bool attached;
>> +	u8 path = MAX77843_SWITCH_OPEN;
> ditto.
>
>> +
>> +	chg_type = max77843_muic_get_cable_type(info,
>> +			MAX77843_CABLE_GROUP_CHG, &attached);
>> +
>> +	dev_dbg(info->dev,
>> +		"external connector is %s(chg_type:0x%x, prev_chg_type:0x%x)\n",
>> +		attached ? "attached" : "detached",
>> +		chg_type, info->prev_chg_type);
>> +
>> +	switch (chg_type) {
>> +	case MAX77843_CHG_TYPE_USB:
>> +		path = MAX77843_SWITCH_USB;
>> +		extcon_set_cable_state(info->edev, "USB", attached);
> ditto. you have to change the muic path before setting the cable state.
Okay, iwill fix it.
>
>> +		break;
>> +	case MAX77843_CHG_TYPE_DOWNSTREAM:
>> +		path = MAX77843_SWITCH_OPEN;
>> +		extcon_set_cable_state(info->edev,
>> +				"CHARGER-DOWNSTREAM", attached);
>> +		break;
>> +	case MAX77843_CHG_TYPE_DEDICATED:
>> +		path = MAX77843_SWITCH_OPEN;
>> +		extcon_set_cable_state(info->edev, "TA", attached);
>> +		break;
>> +	case MAX77843_CHG_TYPE_SPECIAL_500MA:
>> +		path = MAX77843_SWITCH_OPEN;
>> +		extcon_set_cable_state(info->edev, "SLOW-CHAREGER", attached);
>> +		break;
>> +	case MAX77843_CHG_TYPE_SPECIAL_1A:
>> +		path = MAX77843_SWITCH_OPEN;
>> +		extcon_set_cable_state(info->edev, "FAST-CHARGER", attached);
>> +		break;
>> +	case MAX77843_CHG_TYPE_SPECIAL_BIAS:
>> +		path = MAX77843_SWITCH_OPEN;
>> +		break;
>> +	case MAX77843_CHG_TYPE_NONE:
>> +		return 0;
>> +	default:
>> +		dev_err(info->dev,
>> +			"failed to detect %s accessory (chg_type:0x%x)\n",
>> +			attached ? "attached" : "detached", chg_type);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = max77843_muic_set_path(info, path, attached);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static void max77843_muic_irq_work(struct work_struct *work)
>> +{
>> +	struct max77843_muic_info *info = container_of(work,
>> +			struct max77843_muic_info, irq_work);
>> +	struct max77843 *max77843 = info->max77843;
>> +	int ret = 0;
>> +
>> +	if (!info->edev)
>> +		return;
>> +
>> +	mutex_lock(&info->mutex);
>> +
>> +	ret = regmap_bulk_read(max77843->regmap_muic,
>> +			MAX77843_MUIC_REG_STATUS1, info->status,
>> +			MAX77843_MUIC_STATUS_NUM);
>> +	if (ret) {
>> +		dev_err(info->dev, "Cannot read STATUS registers\n");
>> +		mutex_unlock(&info->mutex);
>> +		return;
>> +	}
>> +
>> +	if (info->irq_adc) {
>> +		ret = max77843_muic_adc_handler(info);
>> +		if (ret)
>> +			dev_err(info->dev, "Unknown cable type\n");
>> +		info->irq_adc = false;
>> +	}
>> +
>> +	if (info->irq_chg) {
>> +		ret = max77843_muic_chg_handler(info);
>> +		if (ret)
>> +			dev_err(info->dev, "Unknown charger type\n");
>> +		info->irq_chg = false;
>> +	}
>> +
>> +	mutex_unlock(&info->mutex);
>> +}
>> +
>> +static irqreturn_t max77843_muic_irq_handler(int irq, void *data)
>> +{
>> +	struct max77843_muic_info *info = data;
>> +	int i, irq_type = -1;
>> +
>> +	if (!info->init_done)
>> +		return IRQ_HANDLED;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(max77843_muic_irqs); i++)
>> +		if (irq == info->muic_irqs[i].virq)
>> +			irq_type = info->muic_irqs[i].irq;
>> +
>> +	switch (irq_type) {
>> +	case MAX77843_MUIC_IRQ_INT1_ADC:
>> +	case MAX77843_MUIC_IRQ_INT1_ADCERROR:
>> +	case MAX77843_MUIC_IRQ_INT1_ADC1K:
>> +		info->irq_adc = true;
>> +		break;
>> +	case MAX77843_MUIC_IRQ_INT2_CHGTYP:
>> +	case MAX77843_MUIC_IRQ_INT2_CHGDETRUN:
>> +	case MAX77843_MUIC_IRQ_INT2_DCDTMR:
>> +	case MAX77843_MUIC_IRQ_INT2_DXOVP:
>> +	case MAX77843_MUIC_IRQ_INT2_VBVOLT:
>> +		info->irq_chg = true;
>> +		break;
>> +	case MAX77843_MUIC_IRQ_INT3_VBADC:
>> +	case MAX77843_MUIC_IRQ_INT3_VDNMON:
>> +	case MAX77843_MUIC_IRQ_INT3_DNRES:
>> +	case MAX77843_MUIC_IRQ_INT3_MPNACK:
>> +	case MAX77843_MUIC_IRQ_INT3_MRXBUFOW:
>> +	case MAX77843_MUIC_IRQ_INT3_MRXTRF:
>> +	case MAX77843_MUIC_IRQ_INT3_MRXPERR:
>> +	case MAX77843_MUIC_IRQ_INT3_MRXRDY:
>> +		break;
>> +	default:
>> +		dev_err(info->dev, "Cannot recognize IRQ(%d)\n", irq_type);
>> +		break;
>> +	}
>> +
>> +	schedule_work(&info->irq_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void max77843_muic_detect_cable_wq(struct work_struct *work)
>> +{
>> +	struct max77843_muic_info *info = container_of(to_delayed_work(work),
>> +			struct max77843_muic_info, wq_detcable);
>> +	struct max77843 *max77843 = info->max77843;
>> +	int chg_type, adc, ret;
>> +	bool attached;
>> +
>> +	mutex_lock(&info->mutex);
>> +
>> +	ret = regmap_bulk_read(max77843->regmap_muic,
>> +			MAX77843_MUIC_REG_STATUS1, info->status,
>> +			MAX77843_MUIC_STATUS_NUM);
>> +	if (ret) {
>> +		dev_err(info->dev, "Cannot read STATUS registers\n");
>> +		goto err_cable_wq;
>> +	}
>> +
>> +	adc = max77843_muic_get_cable_type(info,
>> +			MAX77843_CABLE_GROUP_ADC, &attached);
>> +	if (attached && adc != MAX77843_MUIC_ADC_OPEN) {
>> +		ret = max77843_muic_adc_handler(info);
>> +		if (ret < 0) {
>> +			dev_err(info->dev, "Cannot detect accessory\n");
>> +			goto err_cable_wq;
>> +		}
>> +	}
>> +
>> +	chg_type = max77843_muic_get_cable_type(info,
>> +			MAX77843_CABLE_GROUP_CHG, &attached);
>> +	if (attached && chg_type != MAX77843_CHG_TYPE_NONE) {
>> +		ret = max77843_muic_chg_handler(info);
>> +		if (ret < 0) {
>> +			dev_err(info->dev, "Cannot detect charger accessory\n");
>> +			goto err_cable_wq;
>> +		}
>> +	}
>> +
>> +err_cable_wq:
>> +	mutex_unlock(&info->mutex);
>> +}
>> +
>> +static int max77843_muic_set_debounce_time(struct max77843_muic_info *info,
>> +		enum max77843_muic_adv_debounce_time time)
>> +{
>> +	struct max77843 *max77843 = info->max77843;
>> +	unsigned int ret;
>> +
>> +	switch (time) {
>> +	case MAX77843_DEBOUNCE_TIME_5MS:
>> +	case MAX77843_DEBOUNCE_TIME_10MS:
>> +	case MAX77843_DEBOUNCE_TIME_25MS:
>> +	case MAX77843_DEBOUNCE_TIME_38_62MS:
>> +		ret = regmap_update_bits(max77843->regmap_muic,
>> +				MAX77843_MUIC_REG_CONTROL4,
>> +				MAX77843_MUIC_CONTROL4_ADCDBSET_MASK,
>> +				time << CONTROL4_ADCDBSET_SHIFT);
>> +		if (ret) {
> I prfer to use following condition statement to check return value
> 	if (ret) -> if (ret < 0)
Okay, i will fix it.
>
>> +			dev_err(info->dev, "Cannot write MUIC regmap\n");
>> +			return ret;
>> +		}
>> +
>> +		break;
>> +	default:
>> +		dev_err(info->dev, "Invalid ADC debounce time\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77843_init_muic_regmap(struct max77843 *max77843)
>> +{
>> +	int ret;
>> +
>> +	max77843->i2c_muic = i2c_new_dummy(max77843->i2c->adapter,
>> +			I2C_ADDR_MUIC);
>> +	if (!max77843->i2c_muic) {
>> +		dev_err(&max77843->i2c->dev,
>> +				"Cannot allocate I2C device for MUIC\n");
>> +		return PTR_ERR(max77843->i2c_muic);
>> +	}
>> +
>> +	i2c_set_clientdata(max77843->i2c_muic, max77843);
>> +
>> +	max77843->regmap_muic = devm_regmap_init_i2c(max77843->i2c_muic,
>> +			&max77843_muic_regmap_config);
>> +	if (IS_ERR(max77843->regmap_muic)) {
>> +		ret = PTR_ERR(max77843->regmap_muic);
>> +		goto err_muic_i2c;
>> +	}
>> +
>> +	ret = regmap_add_irq_chip(max77843->regmap_muic, max77843->irq,
>> +			IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
>> +			0, &max77843_muic_irq_chip, &max77843->irq_data_muic);
>> +	if (ret) {
> ditto.
> 	if (ret < 0)
okay, I will fix it.
>> +		dev_err(&max77843->i2c->dev, "Cannot add MUIC IRQ chip\n");
>> +		goto err_muic_i2c;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_muic_i2c:
>> +	i2c_unregister_device(max77843->i2c_muic);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77843_muic_probe(struct platform_device *pdev)
>> +{
>> +	struct max77843 *max77843 = dev_get_drvdata(pdev->dev.parent);
>> +	struct max77843_muic_info *info;
>> +	unsigned int id;
>> +	int i, ret;
>> +
>> +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>> +	if (!info)
>> +		return -ENOMEM;
>> +
>> +	info->dev = &pdev->dev;
>> +	info->max77843 = max77843;
>> +	info->muic_irqs = max77843_muic_irqs;
>> +	info->init_done = false;
>> +
>> +	platform_set_drvdata(pdev, info);
>> +	mutex_init(&info->mutex);
>> +	INIT_WORK(&info->irq_work, max77843_muic_irq_work);
>> +
>> +	/* Initialize i2c and regmap */
>> +	ret = max77843_init_muic_regmap(max77843);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed to init MUIC regmap\n");
>> +		return ret;
>> +	}
>> +
>> +	/* Turn off auto detection configuration */
>> +	ret = regmap_update_bits(max77843->regmap_muic,
>> +			MAX77843_MUIC_REG_CONTROL4,
>> +			MAX77843_MUIC_CONTROL4_USBAUTO_MASK |
>> +			MAX77843_MUIC_CONTROL4_FCTAUTO_MASK,
>> +			MAX77843_MUIC_AUTO_NONE << CONTROL4_USBAUTO_SHIFT);
>> +
>> +	/* Support virtual irq domain for max77843 MUIC device */
>> +	for (i = 0; i < ARRAY_SIZE(max77843_muic_irqs); i++) {
>> +		struct max77843_muic_irq *muic_irq = &info->muic_irqs[i];
>> +		unsigned int virq = 0;
>> +
>> +		virq = regmap_irq_get_virq(max77843->irq_data_muic,
>> +				muic_irq->irq);
>> +		if (virq <= 0) {
>> +			ret = -EINVAL;
>> +			goto err_muic_irq;
>> +		}
>> +		muic_irq->virq = virq;
>> +
>> +		ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
>> +				max77843_muic_irq_handler, IRQF_NO_SUSPEND,
>> +				muic_irq->name, info);
>> +		if (ret) {
>> +			dev_err(&pdev->dev,
>> +				"Failed: irq request (IRQ: %d, error: %d)\n",
>> +				muic_irq->irq, ret);
>> +			goto err_muic_irq;
>> +		}
>> +	}
>> +
>> +	/* Initialize extcon device */
>> +	info->edev = devm_extcon_dev_allocate(&pdev->dev,
>> +			max77843_extcon_cable);
>> +	if (IS_ERR(info->edev)) {
>> +		dev_err(&pdev->dev, "Failed to allocate memory for extcon\n");
>> +		ret = -ENODEV;
>> +		goto err_muic_irq;
>> +	}
>> +
>> +	info->edev->name = dev_name(&pdev->dev);
> Don't need it. extcon_dev_register() set the name of extcon device.
Okay, I will fix it.
>
>> +
>> +	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed to register extcon device\n");
>> +		goto err_muic_irq;
>> +	}
>> +
>> +	/* Set ADC debounce time */
>> +	max77843_muic_set_debounce_time(info, MAX77843_DEBOUNCE_TIME_25MS);
>> +
>> +	/* Set initial path for UART */
>> +	max77843_muic_set_path(info, MAX77843_SWITCH_UART, true);
>> +
>> +	/* Detect accessory after completing the initialization of platform */
>> +	INIT_DELAYED_WORK(&info->wq_detcable, max77843_muic_detect_cable_wq);
>> +	queue_delayed_work(system_power_efficient_wq,
>> +			&info->wq_detcable, msecs_to_jiffies(DELAY_MS_DEFAULT));
>> +
>> +	/* Check revision number of MUIC device */
>> +	ret = regmap_read(max77843->regmap_muic, MAX77843_MUIC_REG_ID, &id);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "Failed to read revision number\n");
>> +		return ret;
>> +	}
>> +	dev_info(info->dev, "MUIC device ID : 0x%x\n", id);
>> +
>> +	info->init_done = true;
>> +
>> +	return 0;
>> +
>> +err_muic_irq:
>> +	regmap_del_irq_chip(max77843->irq, max77843->irq_data_muic);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77843_muic_remove(struct platform_device *pdev)
>> +{
>> +	struct max77843_muic_info *info = platform_get_drvdata(pdev);
>> +
>> +	cancel_work_sync(&info->irq_work);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct platform_device_id max77843_muic_id[] = {
>> +	{ "max77843-muic", },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(platform, max77843_muic_id);
>> +
>> +static struct platform_driver max77843_muic_driver = {
>> +	.driver		= {
>> +		.name		= "max77843-muic",
>> +	},
>> +	.probe		= max77843_muic_probe,
>> +	.remove		= max77843_muic_remove,
>> +	.id_table	= max77843_muic_id,
>> +};
>> +
>> +static int __init max77843_muic_init(void)
>> +{
>> +	return platform_driver_register(&max77843_muic_driver);
>> +}
>> +subsys_initcall(max77843_muic_init);
>> +
>> +MODULE_DESCRIPTION("Maxim MAX77843 Extcon driver");
>> +MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
>> +MODULE_LICENSE("GPL");
>>
> Thanks,
> Chanwoo Choi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I list up your review list.
1. cleanup enum lists
2. set path befor send uevent.
3. fix variable names and typos for readability.

Thanks
Jaewon Kim

