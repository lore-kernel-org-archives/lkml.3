Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaKSAjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:39:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31849 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaKSAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:39:14 -0500
X-AuditID: cbfee68f-f791c6d000004834-e5-546be6af2359
Message-id: <546BE6AF.8030601@samsung.com>
Date: Wed, 19 Nov 2014 09:39:11 +0900
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
        sw0312.kim@samsung.com, beomho.seo@samsung.com
Subject: Re: [PATCH v3 1/5] mfd: rt5033: Add Richtek RT5033 driver core.
References: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
 <1415794082-30277-2-git-send-email-beomho.seo@samsung.com>
 <20141118162537.GE13959@x1>
In-reply-to: <20141118162537.GE13959@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHeXfOjseZ8HrtdXQxSbxQ3i+vGCVCdiwULaPoQ7rmQU2dY1PJ
	b4pJpXm/JrqyEt3YMKaopYGJmTqTieaF1GGIptPEtFEk0o4j6ttz+T3/5//AQxP2+6SQTpNk
	szKJKMONEpBqxyDp2Y7V9AS/EaMn1n3vtsK1yysUnt1b4+OqlW0CPx2a4ONKZTWByzdb+Hi/
	oojCExtKgKsMFSTe7h8H2PDjPcCm6Yc8PPWmicK7pUMAt85O8nBFvYbERW+HrLCuhI91fdm4
	oXqdinBi1Ao1YKbKSnnM68ZFK0bZtkcxne3ejFb1iGIWZvopRjEaz5R1qQCzqz0RJ7glOJfM
	ZqTlsjLf80mC1Md9eko6cuHeYoFNPtgLKAbWNIJBSKkq4VtiZ6Rf6qCKgYC2h60AlarG+H+h
	xZlmYGk8B0ih/0haEiNAu98MPI6yhd5oue23maJpErqjmvoorkxBL7RdM01ysRO8iabVTcCC
	26Gf1UskhzvC02hiM5STJOBnAilMJopjHCCDNF1GnmVXC0A9o/pDR9bQE83Na/ncMAE9UE1N
	Jlcm4EnUqd4iOB7BBRo1FDcdCpEQIlP14OEyBI8j7QBhOcwFvWufIyuAc+N/lhr/qTb+p/oM
	ECrgxErFUvmdFFmgj1yUKc+RpPiIszK1wPwUuoPV8l6wOBA+CCAN3I7YJtXeTbDni3LleZmD
	INhsopIQOomzzH8kyU70DwwJwMFBwYEBoWEhbkdtW4S/rtnDFFE2m86yUlaWKMvJYOWDgEdb
	C/PBfZ3LpXzXML/6kC8M2R+zFDOcbLPm2hO2sT6uubhTH+FOiM9c7XkgxvPKyOhXJRLD3mRl
	XzgZa7IxNEWecgimyxPqvAovexYe+3rb48lOt1GRMzZA+9Ylo31N74u1pTa/0hvXP0XHxebp
	XjpOH4xJ4n3ih+VRw812Vwq2ojUf3Eh5qsjfm5DJRX8A2KkxHg8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAd31z7JDDB7/lrE4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2aL/zUJWiz8TWtkszr1ayWgx6f4EFov3e84wWtz/epTR
	4tuVDiaLy7vmsFl87j3CaLH0+kUmiwnT17JYtO49wm5xupvV4vTuEosZk1+yOYh6rJm3htHj
	cl8vk8fOWXfZPVYu/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4ohoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAXlRSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvTsvsBWcMK+4m4jdwPjF6MuRk4OCQETibvX
	5jJC2GISF+6tZ+ti5OIQEljEKDHvwlkWCOc1o8Tnd/eZQKp4BbQkHi7/DdTBwcEioCoxZbob
	SJhNQFPi/ZQrLCC2qECExJU1cxghygUlfky+xwJSLiKgInHujTnISGaB28wS8759YwOpERbw
	kFi75TUTxK6FjBLbT15gBUlwCmhI3Li5iRWkmVlAXWLKlFyQMLOAvMTmNW+ZJzAKzEKyYhZC
	1SwkVQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKehZ9I7GFc1WBxiFOBgVOLhTZya
	FSLEmlhWXJl7iFGCg1lJhFewOztEiDclsbIqtSg/vqg0J7X4EKMp0P8TmaVEk/OBKTKvJN7Q
	2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAOjXe7v2TPn2G8WZMqPZNK9
	W/r6glV/HsvGZpHnk1hc7CojmyaE7rsvrM0iflnta7CY95F+zYUbTz868r543vXF0c/uPlky
	b5+0m3FxY/Glk0+4YrIS6qPmnegVeP9o6/ESo6VrbjCcCd4j72nKrifPqrOP6+9W2ySG9O+b
	Gj3ZrU4sLP7q+CdMiaU4I9FQi7moOBEA1M1HqFkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

On 11/19/2014 01:25 AM, Lee Jones wrote:
> On Wed, 12 Nov 2014, Beomho Seo wrote:
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
>> ---
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
>> index 72d3808..55b6551 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -618,6 +618,18 @@ config MFD_RTSX_PCI
>>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>>  	  Secure Digital and MultiMediaCard.
>>  
>> +config MFD_RT5033
>> +	bool "Richtek RT5033 Power Management IC"
>> +	depends on I2C=y
>> +	select MFD_CORE
>> +	select REGMAP_I2C
>> +	help
>> +	  This driver provides for the Richtek RT5033 Power Management IC,
>> +	  which includes the I2C driver and the Core APIs. This driver provides
>> +	  common support for accessing the device. The device supports multiple
>> +	  sub-devices like charger, fuel gauge, flash LED, current source,
>> +	  LDO and Buck.
> 
> What's stopping this from being built as a module?
> 

I will change to possible building as a module.

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
>> index 0000000..e29c6d9
>> --- /dev/null
>> +++ b/drivers/mfd/rt5033.c
>> @@ -0,0 +1,141 @@
>> +/*
>> + * MFD core driver for the Richtek RT5033.
>> + *
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
> 
> Why have you included this if you can't build as a module?
> 

I will change that driver can build as a module.

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
>> +	{
>> +		.name = "rt5033-regulator",
>> +	}, {
> 
> Place this entry on one line.  Like you did in rt5033_irqs.
>

OK, I will fix it like rt5033_irqs style.

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
>> +
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
>> +		dev_err(&i2c->dev, "Failed to add RT5033 child device.\n");
> 
> s/device/devices/
> 

OK. I will fix it.

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
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id rt5033_i2c_id[] = {
>> +	{ "rt5033", },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, rt5033_i2c_id);
> 
> Why do you need to export this if you're not building as a module?
> 

I will change possible building as a module.

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
>>
>> +MODULE_DESCRIPTION("Richtek RT5033 multi-function core driver");
>> +MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
>> +MODULE_LICENSE("GPL");
> 
> More module stuff?
> 
> [...]
> 
OK. I will revise this patch on your advice.

Again Thank you for your advice.
I will submit next revision patch set.

Regards,
Beomho Seo
