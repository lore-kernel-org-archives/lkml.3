Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaLBAKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:10:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15020 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaLBAKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:10:35 -0500
X-AuditID: cbfee68d-f79296d000004278-d6-547d037840d0
Message-id: <547D0378.5060207@samsung.com>
Date: Tue, 02 Dec 2014 09:10:32 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com, lee.jone@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        Seung-Woo Kim <sw0312.kim@samsung.com>, beomho.seo@samsung.com
Subject: Re: [PATCH v6 1/4] mfd: rt5033: Add Richtek RT5033 driver core.
References: <1416489406-12416-1-git-send-email-beomho.seo@samsung.com>
 <1416489406-12416-2-git-send-email-beomho.seo@samsung.com>
 <20141201123936.GB11932@x1>
In-reply-to: <20141201123936.GB11932@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkRLeSuTbEYP0EFovTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq8XElZOZLfrfLGS1+DOhlc3i3KuVjBaT7gN1vN9zhtHi/tejjBbf
	rnQwWVzeNYfN4nPvEUaLpdcvMllMmL6WxaJ17xF2i9PdrBand5dYzJj8ks1B1GPNvDWMHpf7
	epk8ds66y+6xcvkXNo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBXFZZOSmpNZllqk
	b5fAlXH65EPWgpPOFa/vbGNtYOw162Lk5JAQMJE4vfINK4QtJnHh3nq2LkYuDiGBpYwS269t
	YocpOnl4ORNEYjqjxMwZP6Gc14wSHZ8/MoJU8QpoSXzfs5MFxGYRUJU4O6OHDcRmE9CUeD/l
	ClhcVCBC4sqaOVD1ghI/Jt8DinNwiAioSJx7Yw4yk1ngNbPE+s9bwDYLC3hIXG+awQKxbCGj
	xKEtrWAJTgENifvHtjCCNDMLqEtMmZILEmYWkJfYvOYtM0i9hMANDonpb+6wQRwkIPFt8iGw
	ZRICshKbDjBDfCYpcXDFDZYJjGKzkJw0C2HqLCRTFzAyr2IUTS1ILihOSi8y1CtOzC0uzUvX
	S87P3cQITBan/z3r3cF4+4D1IUYBDkYlHt6T52tChFgTy4orcw8xmgIdMZFZSjQ5H5iS8kri
	DY3NjCxMTUyNjcwtzZTEeRWlfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYAyf/z/hzaG9
	jsv9fq2Mn7z/aFDxFD+jVcbdX+XrzC8fWXMsSNZTW0ZISedIxDRPB+O3T5nOHtrn4/LQZouR
	06sba2KbFB5u7zGdHVdmYrPMcJn4zzUfjfwL3h2uDlh0+ffp9V4qJwVnN71ZZub3/FWvzeN/
	ykctUy54RzU9N5+VZNOYckOsL1+JpTgj0VCLuag4EQAceMW0EQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQd0K5toQg+6ZZhanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi/tfjzJa
	fLvSwWRxedccNovPvUcYLZZev8hkMWH6WhaL1r1H2C1Od7NanN5dYjFj8ks2B1GPNfPWMHpc
	7utl8tg56y67x8rlX9g8Nq/Q8ti0qpPN4861PWwe804GevRtWcXo8XmTXABXVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qi0oKZYk5pUChgMTi
	YiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjNMnH7IWnHSueH1nG2sDY69ZFyMnh4SAicTJ
	w8uZIGwxiQv31rN1MXJxCAlMZ5SYOeMnE4TzmlGi4/NHRpAqXgEtie97drKA2CwCqhJnZ/Sw
	gdhsApoS76dcAYuLCkRIXFkzB6peUOLH5HtAcQ4OEQEViXNvzEFmMgu8ZpZY/3kLO0iNsICH
	xPWmGSwQyxYyShza0gqW4BTQkLh/bAsjSDOzgLrElCm5IGFmAXmJzWveMk9gFJiFZMUshKpZ
	SKoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhORc+kdjCubLA4xCjAwajEw3vifE2I
	EGtiWXFl7iFGCQ5mJRHexyAh3pTEyqrUovz4otKc1OJDjKbAAJjILCWanA9Mk3kl8YbGJmZG
	lkbmhhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBKNTDOM53tuMrzat6tTH4e/1t31ix1
	XtF5SOHP5fd2u6tcv6ror9sRa9V61str4301s6dqsR4xnCuuHHZpstzqHXtm+emfH9elbU72
	XSdpfmpmqUywd1xI+Jwy438XpWrSytqu595ly75hsfLlk7R+mbKXKcrL4uVnikmxdrV9iDm1
	Vsbt6tWPEXFKLMUZiYZazEXFiQDWUV55WwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for advices.
On 12/01/2014 09:39 PM, Lee Jones wrote:
> Sorry for the delay.
> 
>> This patch adds a new driver for Richtek RT5033 driver.
>> RT5033 is a Multifunction device which includes battery charger, fuel gauge,
>> flash LED current source, LDO and synchronous Buck converter. It is interfaced
>> to host controller using I2C interface.
>>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: Lee Jones <lee.jone@linaro.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>> Changes in v6
>> - Fix white space issue in mfd cell struct.
>>
>> Changes in v5
>> - Change possible built as a module.
>> - Revise rt5033_dev mfd cell entry.
>> - Fix incorrect typo.
>> - Add module alias.
>>
>> Changes in v4
>> - none.
>>
>> Changes in v3
>> - Correct sentence errors.
>> - Add author information the top of each drivers.
>> - Remove unnecessary pre-initialise, struct member(rt5033->i2c) and blink.
>> - Change some return check.
>> - Use bool and of_match_ptr().
>>
>> Changes in v2
>> - Remove volatile_reg callback. Because this driver not in use regmap cache.
>> - Revmoe unnecessary subnode of_compatible.
>> - Add define for set_high impedance mode of charger.
>>
>>  drivers/mfd/Kconfig                |   12 ++
>>  drivers/mfd/Makefile               |    1 +
>>  drivers/mfd/rt5033.c               |  141 +++++++++++++++++++
>>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/rt5033.h         |   62 +++++++++
>>  5 files changed, 476 insertions(+)
>>  create mode 100644 drivers/mfd/rt5033.c
>>  create mode 100644 include/linux/mfd/rt5033-private.h
>>  create mode 100644 include/linux/mfd/rt5033.h
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 72d3808..9c13170 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -618,6 +618,18 @@ config MFD_RTSX_PCI
>>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>>  	  Secure Digital and MultiMediaCard.
>>  
>> +config MFD_RT5033
>> +	tristate "Richtek RT5033 Power Management IC"
>> +	depends on I2C=y
>> +	select MFD_CORE
>> +	select REGMAP_I2C
>> +	help
>> +	  This driver provides for the Richtek RT5033 Power Management IC,
>> +	  which includes the I2C driver and the Core APIs. This driver provides
>> +	  common support for accessing the device. The device supports multiple
>> +	  sub-devices like charger, fuel gauge, flash LED, current source,
>> +	  LDO and Buck.
>> +
>>  config MFD_RTSX_USB
>>  	tristate "Realtek USB card reader"
>>  	depends on USB
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 53467e2..4059c24 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -176,6 +176,7 @@ obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>>  obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
>>  obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
>>  obj-$(CONFIG_MFD_DLN2)		+= dln2.o
>> +obj-$(CONFIG_MFD_RT5033)	+= rt5033.o
>>  
>>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
>> diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
>> new file mode 100644
>> index 0000000..e2877c0
>> --- /dev/null
>> +++ b/drivers/mfd/rt5033.c
>> @@ -0,0 +1,141 @@
>> +/*
>> + * MFD core driver for the Richtek RT5033.
> 
> Nicer to put a small description of the h/w here.
> 

OK. I will put a small description.

>> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
>> + * Author: Beomho Seo <beomho.seo@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published bythe Free Software Foundation.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/of_device.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/mfd/rt5033.h>
>> +#include <linux/mfd/rt5033-private.h>
>> +
>> +static const struct regmap_irq rt5033_irqs[] = {
>> +	{ .mask = RT5033_PMIC_IRQ_BUCKOCP, },
>> +	{ .mask = RT5033_PMIC_IRQ_BUCKLV, },
>> +	{ .mask = RT5033_PMIC_IRQ_SAFELDOLV, },
>> +	{ .mask = RT5033_PMIC_IRQ_LDOLV, },
>> +	{ .mask = RT5033_PMIC_IRQ_OT, },
>> +	{ .mask = RT5033_PMIC_IRQ_VDDA_UV, },
>> +};
>> +
>> +static const struct regmap_irq_chip rt5033_irq_chip = {
>> +	.name		= "rt5033",
>> +	.status_base	= RT5033_REG_PMIC_IRQ_STAT,
>> +	.mask_base	= RT5033_REG_PMIC_IRQ_CTRL,
>> +	.mask_invert	= true,
>> +	.num_regs	= 1,
>> +	.irqs		= rt5033_irqs,
>> +	.num_irqs	= ARRAY_SIZE(rt5033_irqs),
>> +};
>> +
>> +static const struct mfd_cell rt5033_devs[] = {
>> +	{ .name = "rt5033-regulator", },
>> +	{
>> +		.name = "rt5033-charger",
>> +		.of_compatible = "richtek,rt5033-charger",
>> +	}, {
>> +		.name = "rt5033-battery",
>> +		.of_compatible = "richtek,rt5033-battery",
>> +	},
>> +};
>> +
>> +static const struct of_device_id rt5033_dt_match[] = {
>> +	{ .compatible = "richtek,rt5033", },
>> +	{ }
>> +};
> 
> Put this just above where you use it for the first time.
> 

I will be changed next version.

>> +static const struct regmap_config rt5033_regmap_config = {
>> +	.reg_bits	= 8,
>> +	.val_bits	= 8,
>> +	.max_register	= RT5033_REG_END,
>> +};
>> +
>> +static int rt5033_i2c_probe(struct i2c_client *i2c,
>> +				const struct i2c_device_id *id)
>> +{
>> +	struct rt5033_dev *rt5033;
>> +	unsigned int data;
> 
> 'data' is not a very good name for a variable.
> 
> "devid" or "id" would be better in this case.
> 

I will use "devid" or "id".

>> +	int ret;
>> +
>> +	rt5033 = devm_kzalloc(&i2c->dev, sizeof(*rt5033), GFP_KERNEL);
>> +	if (!rt5033)
>> +		return -ENOMEM;
>> +
>> +	i2c_set_clientdata(i2c, rt5033);
>> +	rt5033->dev = &i2c->dev;
>> +	rt5033->irq = i2c->irq;
>> +	rt5033->wakeup = true;
>> +
>> +	rt5033->regmap = devm_regmap_init_i2c(i2c, &rt5033_regmap_config);
>> +	if (IS_ERR(rt5033->regmap)) {
>> +		dev_err(&i2c->dev, "Failed to allocate register map.\n");
>> +		return PTR_ERR(rt5033->regmap);
>> +	}
>> +
>> +	ret = regmap_read(rt5033->regmap, RT5033_REG_DEVICE_ID, &data);
>> +	if (ret) {
>> +		dev_err(&i2c->dev, "Device not found\n");
>> +		return -ENODEV;
>> +	}
>> +	dev_info(&i2c->dev, "Device found Device ID: %04x\n", data);
>> +
>> +	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
>> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +			0, &rt5033_irq_chip, &rt5033->irq_data);
>> +	if (ret) {
>> +		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
>> +							rt5033->irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = mfd_add_devices(rt5033->dev, -1, rt5033_devs,
>> +			ARRAY_SIZE(rt5033_devs), NULL, 0,
>> +			regmap_irq_get_domain(rt5033->irq_data));
>> +	if (ret < 0) {
>> +		dev_err(&i2c->dev, "Failed to add RT5033 child devices.\n");
>> +		return ret;
>> +	}
>> +
>> +	device_init_wakeup(rt5033->dev, rt5033->wakeup);
>> +
>> +	return 0;
>> +}
>> +
>> +static int rt5033_i2c_remove(struct i2c_client *i2c)
>> +{
>> +	struct rt5033_dev *rt5033 = i2c_get_clientdata(i2c);
>> +
>> +	mfd_remove_devices(rt5033->dev);
> 
> &i2c->dev?
> 

It will be changed.

>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id rt5033_i2c_id[] = {
>> +	{ "rt5033", },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, rt5033_i2c_id);
>> +
>> +static struct i2c_driver rt5033_driver = {
>> +	.driver = {
>> +		.name = "rt5033",
>> +		.of_match_table = of_match_ptr(rt5033_dt_match),
>> +	},
>> +	.probe = rt5033_i2c_probe,
>> +	.remove = rt5033_i2c_remove,
>> +	.id_table = rt5033_i2c_id,
>> +};
>> +module_i2c_driver(rt5033_driver);
>> +
>> +MODULE_ALIAS("i2c:rt5033");
>> +MODULE_DESCRIPTION("Richtek RT5033 multi-function core driver");
>> +MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
>> +MODULE_LICENSE("GPL");
> 
> [...]
> 
>> +#endif /* __RT5033_PRIVATE_H__ */
>> diff --git a/include/linux/mfd/rt5033.h b/include/linux/mfd/rt5033.h
>> new file mode 100644
>> index 0000000..bd06415
>> --- /dev/null
>> +++ b/include/linux/mfd/rt5033.h
> 
> [...]
> 
>> +struct rt5033_charger {
>> +	struct device		*dev;
>> +	struct rt5033_dev	*rt5033;
>> +	struct power_supply	psy;
>> +
>> +	struct rt5033_charger_data	*data;
> 
> 'data' is not a good name for a variable.
> 

I will change variable name.

>> +};
>> +
>> +#endif /* __RT5033_H__ */
> 


Best regards,
Beomho Seo
