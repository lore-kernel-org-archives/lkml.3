Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaKJMtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:49:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65025 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaKJMt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:29 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f5-5460b45699f5
Message-id: <5460B456.8070604@samsung.com>
Date: Mon, 10 Nov 2014 21:49:26 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, cw00.choi@samsung.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jone@linaro.org>
Subject: Re: [PATCH v2 1/5] mfd: rt5033: Add Richtek RT5033 driver core.
References: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
 <1415603987-32475-2-git-send-email-beomho.seo@samsung.com>
 <20141110123901.GY21424@x1>
In-reply-to: <20141110123901.GY21424@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkSDdsS0KIwfVdChbXvzxntZh/5Byr
	xZ8JrWwWk+5PYLF4v+cMo8X9r0cZLS7vmsNm8bn3CKPF6W5WixmTX7I5cHncubaHzWPeyUCP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyrg4cRJjwb3pjBVdB3MaGJdXdzFyckgImEj8nnWD
	EcIWk7hwbz1bFyMXh5DAUkaJhmtNTDBFT+78YIVITGeU+HC7nQnCec0ocXfWd3aQKl4BLYnN
	t/+xgtgsAqoSfyb/ZwGx2QQ0Jd5PuQJmiwpESFxZM4cRol5Q4sfke0BxDg4RARWJc2/MQcLM
	Ao1MEpNuaYPYwgIeEl8nr2WE2LWQUaJp3RE2kASngIbE3IX3wXqZBdQlpkzJheiVl9i85i0z
	xNG32CXWfxOCOEdA4tvkQ2DlEgKyEpsOQJVIShxccYNlAqPYLCQHzUIYOgvJ0AWMzKsYRVML
	kguKk9KLTPSKE3OLS/PS9ZLzczcxAmPw9L9nE3Yw3jtgfYhRgINRiYfX4W18iBBrYllxZe4h
	RlOgIyYyS4km5wMjPa8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwsZa++ey8olPkjW/L9V8L/S+KLZyyWMzpetW+ypfLbDy3F1xQfRbBHNym2LT/z
	94Sy1O1Vz6e/67T5v9ruk/RckzvH1yYuE+f+PK23/7cMz6PWSL/0E+Ed96PPPq3VLZeS2by9
	TadLJvqeyd47qolv7s7bOMPU/otoRtbr6zulvTzZpFgfh61XYinOSDTUYi4qTgQAs2M1BLwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd2wLQkhBmuWi1hc//Kc1WL+kXOs
	Fn8mtLJZTLo/gcXi/Z4zjBb3vx5ltLi8aw6bxefeI4wWp7tZLWZMfsnmwOVx59oeNo95JwM9
	+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGxYmTGAvu
	TWes6DqY08C4vLqLkZNDQsBE4smdH6wQtpjEhXvr2boYuTiEBKYzSny43c4E4bxmlLg76zs7
	SBWvgJbE5tv/wDpYBFQl/kz+zwJiswloSryfcgXMFhWIkLiyZg4jRL2gxI/J94DiHBwiAioS
	596Yg4SZBRqZJCbd0gaxhQU8JL5OXssIsWsho0TTuiNsIAlOAQ2JuQvvg/UyC6hLTJmSC9Er
	L7F5zVvmCYwCs5BsmIVQNQtJ1QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH+TGoH
	48oGi0OMAhyMSjy8Dm/jQ4RYE8uKK3MPMUpwMCuJ8M5alhAixJuSWFmVWpQfX1Sak1p8iNEU
	6P+JzFKiyfnA9JNXEm9obGJmZGlkbmhhZGyuJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoEx
	tz1F4Dfz8ue72atnVS3Rvjuj83f0gVX5C+ubGTb2J5bL8eW5L/7529LJ7VjTnIlzUs6++C9Y
	0LSU/d9dw+X9Z12FVx9mlQs8MV3m/6RaOdboqcX1gvuZH3I5irs2NBw5V1zxqf/pxlyPS492
	W/S9Tj4c8HppFe+XkpfPZnJ4bNrgfMaF93WOEktxRqKhFnNRcSIALbf3/QcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your review.

On 11/10/2014 09:39 PM, Lee Jones wrote:
> On Mon, 10 Nov 2014, Beomho Seo wrote:
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
>> Changes in v2
>> - Remove volatile_reg callback. Because this driver not in use regmap cache.
>> - Revmoe unnecessary subnode of_compatible.
>> - Add define for set_high impedance mode of charger.
>> ---
>>
>>  drivers/mfd/Kconfig                |   11 ++
>>  drivers/mfd/Makefile               |    1 +
>>  drivers/mfd/rt5033.c               |  142 ++++++++++++++++++++
>>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/rt5033.h         |   64 +++++++++
>>  5 files changed, 478 insertions(+)
>>  create mode 100644 drivers/mfd/rt5033.c
>>  create mode 100644 include/linux/mfd/rt5033-private.h
>>  create mode 100644 include/linux/mfd/rt5033.h
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index cbdb109..6800068 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -607,6 +607,17 @@ config MFD_RTSX_PCI
>>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>>  	  Secure Digital and MultiMediaCard.
>>  
>> +config MFD_RT5033
>> +	bool "Richtek RT5033 Power Management IC"
>> +	depends on I2C=y
>> +	select MFD_CORE
>> +	select REGMAP_I2C
>> +	help
>> +	  This support for Richtek RT5033 Power Management IC. This includes
> 
> s/This /This driver provides/
> 
> s/for /for the
> 
> s/. This/, which
> 

Ok, I will revise above sentence.

>> +	  the I2C driver and the Core APIs. This driver provides common support
>> +	  for accessing the device. The device supports multiple sub-devices
>> +	  like charger, fuel gauge, flash LED, current source, LDO and Buck.
>> +
>>  config MFD_RTSX_USB
>>  	tristate "Realtek USB card reader"
>>  	depends on USB
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 8e679d6..94e0f1c 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -175,6 +175,7 @@ obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>>  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>>  obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
>>  obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
>> +obj-$(CONFIG_MFD_RT5033)	+= rt5033.o
>>  
>>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
>> diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
>> new file mode 100644
>> index 0000000..8f5aee0
>> --- /dev/null
>> +++ b/drivers/mfd/rt5033.c
>> @@ -0,0 +1,142 @@
>> +/*
>> + * MFD core driver for the Richtek RT5033.
>> + *
>> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
>> + * Beomho Seo <beomho.seo@samsung.com>
> 
> Babysitter, butcher, pool cleaner or author?
> 

OK, I will add "author".

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
>> +	{
>> +		.name = "rt5033-regulator",
>> +	}, {
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
>> +	int ret = 0;
> 
> No need to pre-initialise.
> 
>> +	rt5033 = devm_kzalloc(&i2c->dev, sizeof(*rt5033), GFP_KERNEL);
>> +	if (!rt5033)
>> +		return -ENOMEM;
>> +
>> +	i2c_set_clientdata(i2c, rt5033);
>> +	rt5033->dev = &i2c->dev;
>> +	rt5033->i2c = i2c;
>> +	rt5033->irq = i2c->irq;
> 
> If you're saving 'i2c', do you really need to save the other two.  You
> can just derive them from the former.
> 
>> +	rt5033->wakeup = 1;
> 
> This is a bool; true or false.
> 
>> +	rt5033->regmap = devm_regmap_init_i2c(i2c, &rt5033_regmap_config);
>> +	if (IS_ERR(rt5033->regmap)) {
>> +		dev_err(&i2c->dev, "Failed to allocate register map.\n");
>> +		return PTR_ERR(rt5033->regmap);
>> +	}
>> +
>> +	ret = regmap_read(rt5033->regmap, RT5033_REG_DEVICE_ID, &data);
>> +	if (ret < 0) {
>> +		dev_err(&i2c->dev, "Device not found\n");
>> +		return -ENODEV;
>> +	}
>> +	dev_info(&i2c->dev, "Device found Device ID: %04x\n", data);
>> +
>> +	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
>> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +			0, &rt5033_irq_chip, &rt5033->irq_data);
>> +	if (ret < 0) {
> 
> regmap_add_irq_chip() doesn't return >0, so check can simply be
> 
> if (ret) ...
> 
>> +		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
>> +							rt5033->irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = mfd_add_devices(rt5033->dev, -1, rt5033_devs,
>> +			ARRAY_SIZE(rt5033_devs), NULL, 0,
>> +			regmap_irq_get_domain(rt5033->irq_data));
>> +	if (ret < 0) {
> 
> Again, mfd_add_devices() can't return >0, so just check for 'ret'.
> 
>> +		dev_err(&i2c->dev, "Failed to add rt5033 mfd device.\n");
> 
> "Failed to add RT5033 child devices"
> 
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
>> +
>> +static struct i2c_driver rt5033_driver = {
>> +	.driver = {
>> +		.name = "rt5033",
>> +		.of_match_table = rt5033_dt_match,
> 
> Should this driver depend on OF?  If not, you need to use
> of_match_ptr() here.
> 
>> +	},
>> +	.probe = rt5033_i2c_probe,
>> +	.remove = rt5033_i2c_remove,
>> +	.id_table = rt5033_i2c_id,
>> +};
>> +module_i2c_driver(rt5033_driver);
>> +
>> +MODULE_DESCRIPTION("Richtek RT5033 multi-function core driver");
>> +MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
>> new file mode 100644
>> index 0000000..9eff0e5
>> --- /dev/null
>> +++ b/include/linux/mfd/rt5033-private.h
>> @@ -0,0 +1,260 @@
>> +/*
>> + * MFD core driver for Richtek RT5033
>> + *
>> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
>> + * Beomho Seo <beomho.seo@samsung.com>
> 
>  * Author: ...
> 
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published bythe Free Software Foundation.
>> + */
>> +
>> +#ifndef __RT5033_PRIVATE_H__
>> +#define __RT5033_PRIVATE_H__
>> +
>> +enum rt5033_reg {
>> +	RT5033_REG_CHG_STAT		= 0x00,
>> +	RT5033_REG_CHG_CTRL1		= 0x01,
>> +	RT5033_REG_CHG_CTRL2		= 0x02,
>> +	RT5033_REG_DEVICE_ID		= 0x03,
>> +	RT5033_REG_CHG_CTRL3		= 0x04,
>> +	RT5033_REG_CHG_CTRL4		= 0x05,
>> +	RT5033_REG_CHG_CTRL5		= 0x06,
>> +	RT5033_REG_RT_CTRL0		= 0x07,
>> +	RT5033_REG_CHG_RESET		= 0x08,
>> +	/* Reserved 0x09~0x18 */
>> +	RT5033_REG_RT_CTRL1		= 0x19,
>> +	/* Reserved 0x1A~0x20 */
>> +	RT5033_REG_FLED_FUNCTION1	= 0x21,
>> +	RT5033_REG_FLED_FUNCTION2	= 0x22,
>> +	RT5033_REG_FLED_STROBE_CTRL1	= 0x23,
>> +	RT5033_REG_FLED_STROBE_CTRL2	= 0x24,
>> +	RT5033_REG_FLED_CTRL1		= 0x25,
>> +	RT5033_REG_FLED_CTRL2		= 0x26,
>> +	RT5033_REG_FLED_CTRL3		= 0x27,
>> +	RT5033_REG_FLED_CTRL4		= 0x28,
>> +	RT5033_REG_FLED_CTRL5		= 0x29,
>> +	/* Reserved 0x2A~0x40 */
>> +	RT5033_REG_CTRL			= 0x41,
>> +	RT5033_REG_BUCK_CTRL		= 0x42,
>> +	RT5033_REG_LDO_CTRL		= 0x43,
>> +	/* Reserved 0x44~0x46 */
>> +	RT5033_REG_MANUAL_RESET_CTRL	= 0x47,
>> +	/* Reserved 0x48~0x5F */
>> +	RT5033_REG_CHG_IRQ1		= 0x60,
>> +	RT5033_REG_CHG_IRQ2		= 0x61,
>> +	RT5033_REG_CHG_IRQ3		= 0x62,
>> +	RT5033_REG_CHG_IRQ1_CTRL	= 0x63,
>> +	RT5033_REG_CHG_IRQ2_CTRL	= 0x64,
>> +	RT5033_REG_CHG_IRQ3_CTRL	= 0x65,
>> +	RT5033_REG_LED_IRQ_STAT		= 0x66,
>> +	RT5033_REG_LED_IRQ_CTRL		= 0x67,
>> +	RT5033_REG_PMIC_IRQ_STAT	= 0x68,
>> +	RT5033_REG_PMIC_IRQ_CTRL	= 0x69,
>> +	RT5033_REG_SHDN_CTRL		= 0x6A,
>> +	RT5033_REG_OFF_EVENT		= 0x6B,
>> +
>> +	RT5033_REG_END,
>> +};
>> +
>> +/* RT5033 Charger state register */
>> +#define RT5033_CHG_STAT_MASK		0x20
>> +#define RT5033_CHG_STAT_DISCHARGING	0x00
>> +#define RT5033_CHG_STAT_FULL		0x10
>> +#define RT5033_CHG_STAT_CHARGING	0x20
>> +#define RT5033_CHG_STAT_NOT_CHARGING	0x30
>> +#define RT5033_CHG_STAT_TYPE_MASK	0x60
>> +#define RT5033_CHG_STAT_TYPE_PRE	0x20
>> +#define RT5033_CHG_STAT_TYPE_FAST	0x60
>> +
>> +/* RT5033 CHGCTRL1 register */
>> +#define RT5033_CHGCTRL1_IAICR_MASK	0xe0
>> +#define RT5033_CHGCTRL1_MODE_MASK	0x01
>> +
>> +/* RT5033 CHGCTRL2 register */
>> +#define RT5033_CHGCTRL2_CV_MASK		0xfc
>> +
>> +/* RT5033 CHGCTRL3 register */
>> +#define RT5033_CHGCTRL3_CFO_EN_MASK	0x40
>> +#define RT5033_CHGCTRL3_TIMER_MASK	0x38
>> +#define RT5033_CHGCTRL3_TIMER_EN_MASK	0x01
>> +
>> +/* RT5033 CHGCTRL4 register */
>> +#define RT5033_CHGCTRL4_EOC_MASK	0x07
>> +#define RT5033_CHGCTRL4_IPREC_MASK	0x18
>> +
>> +/* RT5033 CHGCTRL5 register */
>> +#define RT5033_CHGCTRL5_VPREC_MASK	0x0f
>> +#define RT5033_CHGCTRL5_ICHG_MASK	0xf0
>> +#define RT5033_CHGCTRL5_ICHG_SHIFT	0x04
>> +#define RT5033_CHG_MAX_CURRENT		0x0d
>> +
>> +/* RT5033 RT CTRL1 register */
>> +#define RT5033_RT_CTRL1_UUG_MASK	0x02
>> +#define RT5033_RT_HZ_MASK		0x01
>> +
>> +/* RT5033 control register */
>> +#define RT5033_CTRL_FCCM_BUCK_MASK		0x00
>> +#define RT5033_CTRL_BUCKOMS_MASK		0x01
>> +#define RT5033_CTRL_LDOOMS_MASK			0x02
>> +#define RT5033_CTRL_SLDOOMS_MASK		0x03
>> +#define RT5033_CTRL_EN_BUCK_MASK		0x04
>> +#define RT5033_CTRL_EN_LDO_MASK			0x05
>> +#define RT5033_CTRL_EN_SAFE_LDO_MASK		0x06
>> +#define RT5033_CTRL_LDO_SLEEP_MASK		0x07
>> +
>> +/* RT5033 BUCK control register */
>> +#define RT5033_BUCK_CTRL_MASK			0x1f
>> +
>> +/* RT5033 LDO control register */
>> +#define RT5033_LDO_CTRL_MASK			0x1f
>> +
>> +/* RT5033 charger property - model, manufacturer */
>> +
>> +#define RT5033_CHARGER_MODEL	"RT5033WSC Charger"
>> +#define RT5033_MANUFACTURER	"Richtek Technology Corporation"
>> +
>> +/*
>> + * RT5033 charger fast-charge current lmits (as in CHGCTRL1 register),
>> + * AICR mode limits the input current for example,
>> + * the AIRC 100 mode limits the input current to 100 mA.
>> + */
>> +#define RT5033_AICR_100_MODE			0x20
>> +#define RT5033_AICR_500_MODE			0x40
>> +#define RT5033_AICR_700_MODE			0x60
>> +#define RT5033_AICR_900_MODE			0x80
>> +#define RT5033_AICR_1500_MODE			0xc0
>> +#define RT5033_AICR_2000_MODE			0xe0
>> +#define RT5033_AICR_MODE_MASK			0xe0
>> +
>> +/* RT5033 use internal timer need to set time */
>> +#define RT5033_FAST_CHARGE_TIMER4		0x00
>> +#define RT5033_FAST_CHARGE_TIMER6		0x01
>> +#define RT5033_FAST_CHARGE_TIMER8		0x02
>> +#define RT5033_FAST_CHARGE_TIMER9		0x03
>> +#define RT5033_FAST_CHARGE_TIMER12		0x04
>> +#define RT5033_FAST_CHARGE_TIMER14		0x05
>> +#define RT5033_FAST_CHARGE_TIMER16		0x06
>> +
>> +#define RT5033_INT_TIMER_ENABLE			0x01
>> +
>> +/* RT5033 charger termination enable mask */
>> +#define RT5033_TE_ENABLE_MASK			0x08
>> +
>> +/*
>> + * RT5033 charger opa mode. RT50300 have two opa mode charger mode
>> + * and boost mode for OTG
>> + */
>> +
>> +#define RT5033_CHARGER_MODE			0x00
>> +#define RT5033_BOOST_MODE			0x01
>> +
>> +/* RT5033 charger termination enable */
>> +#define RT5033_TE_ENABLE			0x08
>> +
>> +/* RT5033 charger CFO enable */
>> +#define RT5033_CFO_ENABLE			0x40
>> +
>> +/* RT5033 charger constant charge voltage (as in CHGCTRL2 register), uV */
>> +#define RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN	3650000U
>> +#define RT5033_CHARGER_CONST_VOLTAGE_STEP_NUM   25000U
>> +#define RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX	4400000U
>> +
>> +/* RT5033 charger pre-charge current limits (as in CHGCTRL4 register), uA */
>> +#define RT5033_CHARGER_PRE_CURRENT_LIMIT_MIN	350000U
>> +#define RT5033_CHARGER_PRE_CURRENT_STEP_NUM	100000U
>> +#define RT5033_CHARGER_PRE_CURRENT_LIMIT_MAX	650000U
>> +
>> +/* RT5033 charger fast-charge current (as in CHGCTRL5 register), uA */
>> +#define RT5033_CHARGER_FAST_CURRENT_MIN		700000U
>> +#define RT5033_CHARGER_FAST_CURRENT_STEP_NUM	100000U
>> +#define RT5033_CHARGER_FAST_CURRENT_MAX		2000000U
>> +
>> +/*
>> + * RT5033 charger const-charge end of charger current (
>> + * as in CHGCTRL4 register), uA
>> + */
>> +#define RT5033_CHARGER_EOC_MIN			150000U
>> +#define RT5033_CHARGER_EOC_REF			300000U
>> +#define RT5033_CHARGER_EOC_STEP_NUM1		50000U
>> +#define RT5033_CHARGER_EOC_STEP_NUM2		100000U
>> +#define RT5033_CHARGER_EOC_MAX			600000U
>> +
>> +/*
>> + * RT5033 charger pre-charge threshold volt limits
>> + * (as in CHGCTRL5 register), uV
>> + */
>> +
>> +#define RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MIN	2300000U
>> +#define RT5033_CHARGER_PRE_THRESHOLD_STEP_NUM	100000U
>> +#define RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MAX	3800000U
>> +
>> +/*
>> + * RT5033 charger enable UUG, If UUG enable MOS auto control by H/W charger
>> + * circuit.
>> + */
>> +#define RT5033_CHARGER_UUG_ENABLE		0x02
>> +
>> +/* RT5033 charger High impedance mode */
>> +#define RT5033_CHARGER_HZ_DISABLE		0x00
>> +#define RT5033_CHARGER_HZ_ENABLE		0x01
>> +
>> +/* RT5033 regulator BUCK output voltage uV */
>> +#define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
>> +#define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
>> +#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
>> +#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
>> +
>> +/* RT5033 regulator LDO output voltage uV */
>> +#define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
>> +#define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
>> +#define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
>> +#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
>> +
>> +/* RT5033 regulator SAFE LDO output voltage uV */
>> +#define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
>> +
>> +enum rt5033_fuel_reg {
>> +	RT5033_FUEL_REG_OCV_H		= 0x00,
>> +	RT5033_FUEL_REG_OCV_L		= 0x01,
>> +	RT5033_FUEL_REG_VBAT_H		= 0x02,
>> +	RT5033_FUEL_REG_VBAT_L		= 0x03,
>> +	RT5033_FUEL_REG_SOC_H		= 0x04,
>> +	RT5033_FUEL_REG_SOC_L		= 0x05,
>> +	RT5033_FUEL_REG_CTRL_H		= 0x06,
>> +	RT5033_FUEL_REG_CTRL_L		= 0x07,
>> +	RT5033_FUEL_REG_CRATE		= 0x08,
>> +	RT5033_FUEL_REG_DEVICE_ID	= 0x09,
>> +	RT5033_FUEL_REG_AVG_VOLT_H	= 0x0A,
>> +	RT5033_FUEL_REG_AVG_VOLT_L	= 0x0B,
>> +	RT5033_FUEL_REG_CONFIG_H	= 0x0C,
>> +	RT5033_FUEL_REG_CONFIG_L	= 0x0D,
>> +	/* Reserved 0x0E~0x0F */
>> +	RT5033_FUEL_REG_IRQ_CTRL	= 0x10,
>> +	RT5033_FUEL_REG_IRQ_FLAG	= 0x11,
>> +	RT5033_FUEL_VMIN		= 0x12,
>> +	RT5033_FUEL_SMIN		= 0x13,
>> +	/* Reserved 0x14~0x1F */
>> +	RT5033_FUEL_VGCOMP1		= 0x20,
>> +	RT5033_FUEL_VGCOMP2		= 0x21,
>> +	RT5033_FUEL_VGCOMP3		= 0x22,
>> +	RT5033_FUEL_VGCOMP4		= 0x23,
>> +	/* Reserved 0x24~0xFD */
>> +	RT5033_FUEL_MFA_H		= 0xFE,
>> +	RT5033_FUEL_MFA_L		= 0xFF,
>> +
>> +	RT5033_FUEL_REG_END,
>> +};
>> +
>> +/* RT5033 fuel gauge battery present property */
>> +#define RT5033_FUEL_BAT_PRESENT		0x02
>> +
>> +/* RT5033 PMIC interrupts */
>> +#define RT5033_PMIC_IRQ_BUCKOCP		2
>> +#define RT5033_PMIC_IRQ_BUCKLV		3
>> +#define RT5033_PMIC_IRQ_SAFELDOLV	4
>> +#define RT5033_PMIC_IRQ_LDOLV		5
>> +#define RT5033_PMIC_IRQ_OT		6
>> +#define RT5033_PMIC_IRQ_VDDA_UV		7
>> +
>> +#endif /* __RT5033_PRIVATE_H__ */
>> diff --git a/include/linux/mfd/rt5033.h b/include/linux/mfd/rt5033.h
>> new file mode 100644
>> index 0000000..5fb8ab1
>> --- /dev/null
>> +++ b/include/linux/mfd/rt5033.h
>> @@ -0,0 +1,64 @@
>> +/*
>> + * MFD core driver for the RT5033
>> + *
>> + * Copyright (C) 2014 Samsung Electronics
>> + * Beomho Seo <beomho.seo@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published bythe Free Software Foundation.
>> + */
>> +
>> +#ifndef __RT5033_H__
>> +#define __RT5033_H__
>> +
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/i2c.h>
>> +#include <linux/regmap.h>
>> +#include <linux/power_supply.h>
>> +
>> +/* RT5033 regulator IDs */
>> +enum rt5033_regulators {
>> +	RT5033_BUCK = 0,
>> +	RT5033_LDO,
>> +	RT5033_SAFE_LDO,
>> +
>> +	RT5033_REGULATOR_NUM,
>> +};
>> +
>> +struct rt5033_dev {
>> +	struct device *dev;
>> +	struct i2c_client *i2c;
>> +
>> +	struct regmap *regmap;
>> +	struct regmap_irq_chip_data *irq_data;
>> +	int irq;
>> +	bool wakeup;
>> +};
>> +
>> +struct rt5033_battery {
>> +	struct i2c_client	*client;
>> +	struct rt5033_dev	*rt5033;
>> +	struct regmap		*regmap;
>> +	struct power_supply	psy;
>> +};
>> +
>> +/* RT5033 charger platform data */
>> +struct rt5033_charger_data {
>> +	unsigned int pre_uamp;
>> +	unsigned int pre_uvolt;
>> +	unsigned int const_uvolt;
>> +	unsigned int eoc_uamp;
>> +	unsigned int fast_uamp;
>> +};
>> +
>> +struct rt5033_charger {
>> +	struct device		*dev;
>> +	struct rt5033_dev	*rt5033;
>> +	struct power_supply	psy;
>> +
>> +	struct rt5033_charger_data	*data;
>> +};
>> +
>> +
> 
> Too many '\n's here.
> 

OK, I will revise everything you have pointed out.
Again, Thank you for your advices.
I'll fix them and send v3 patch soon.

>> +#endif /* __RT5033_H__ */
> 

Best regards,
Beomho Seo

