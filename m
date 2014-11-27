Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaK0N3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:29:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31487 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK0N3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:29:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-a7-547727241706
Message-id: <54772723.80007@samsung.com>
Date: Thu, 27 Nov 2014 22:29:07 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, beomho.seo@samsung.com,
        cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH v6 1/4] mfd: rt5033: Add Richtek RT5033 driver core.
References: <1416489406-12416-1-git-send-email-beomho.seo@samsung.com>
 <1416489406-12416-2-git-send-email-beomho.seo@samsung.com>
In-reply-to: <1416489406-12416-2-git-send-email-beomho.seo@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkSFdFvTzE4Nh0KYvTn7axW0x9+ITN
	4vqX56wWfya0sllMuj+BxeL9njOMFpd3zWGz+Nx7hNFixuSXbA6cHptWdbJ53Lm2h82jb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4Ms4d/sResHYCY8XEyT2MDYxtpV2MnBwSAiYSb/qbWCBs
	MYkL99azdTFycQgJLGWU2LP7GhtM0bSr7xkhEosYJT6dmwRV9ZpR4sfXf6wgVbwCGhKvl/9k
	ArFZBFQlmg9sZASx2QQ0Jd5PuQK2QlQgQuLKmjmMEPWCEj8m3wOLiwhYSbxof8UOMpQZZPWm
	g3OZQRLCAh4S15tmsEBsa2aUON97D6ybU8BdYs+TJqAODqAOPYn7F7VAwswC8hKb17xlBqmX
	ELjFLvF6Xhs7xEUCEt8mH2IBqZcQkJXYdIAZ4jVJiYMrbrBMYBSbheSmWQhTZyGZuoCReRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYBSe/vdswg7GewesDzEKcDAq8fBaHCgLEWJNLCuu
	zD3EaAp0xERmKdHkfGCs55XEGxqbGVmYmpgaG5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgTHQPlza6prw0j6XjU7l29++Snhv3REzJ8KmoWFJ9zr9g5uLbx1aHH4v4/7/
	6IcZ0RdWLq355JKTUsJh3hO7xXPrgi0f+3cdzVh3SnxH+MeHQvPbLdtytt5ZdP79IW+z7w+W
	3Fj9sfdowIVSviPuugz5gXzvPMOFuqPfXsi/ODeV5wYfk9iDmotKLMUZiYZazEXFiQC5IVxZ
	vQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAV0V9fIQg6vveS1Of9rGbjH14RM2
	i+tfnrNa/JnQymYx6f4EFov3e84wWlzeNYfN4nPvEUaLGZNfsjlwemxa1cnmcefaHjaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx7vAn9oK1Exgr
	Jk7uYWxgbCvtYuTkkBAwkZh29T0jhC0mceHeerYuRi4OIYFFjBKfzk2Ccl4zSvz4+o8VpIpX
	QEPi9fKfTCA2i4CqRPOBjWDdbAKaEu+nXGEBsUUFIiSurJnDCFEvKPFj8j2wuIiAlcSL9lfs
	IEOZBZYySmw6OJcZJCEs4CFxvWkGC8S2ZkaJ8733wLo5Bdwl9jxpAurgAOrQk7h/UQskzCwg
	L7F5zVvmCYwCs5DsmIVQNQtJ1QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH+TGoH
	48oGi0OMAhyMSjy8FgfKQoRYE8uKK3MPMUpwMCuJ8HIxlocI8aYkVlalFuXHF5XmpBYfYjQF
	hsBEZinR5Hxg+skriTc0NjEzsjQyN7QwMjZXEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoEx
	pfdzp35dy8KAnembjDO9J4gw57M05kncndR/x+K4uPlPJm7v1BDhRoXDM9PXqJ1/VX5b02TB
	PIdFC55uVkq7OPFwj8eZTQUaAewOnjeaXlVM0OScV7vN9senC8xym8sU/u+W/cAvkiNyz+6z
	+LX3Rta107Yl/q6UvH6P9YXx3IvrxG38X/ApsRRnJBpqMRcVJwIAOnURLQcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Would like some comment to this patch.

Best regards,
Beomho Seo

On 11/20/2014 10:16 PM, Beomho Seo wrote:
> This patch adds a new driver for Richtek RT5033 driver.
> RT5033 is a Multifunction device which includes battery charger, fuel gauge,
> flash LED current source, LDO and synchronous Buck converter. It is interfaced
> to host controller using I2C interface.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jone@linaro.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes in v6
> - Fix white space issue in mfd cell struct.
> 
> Changes in v5
> - Change possible built as a module.
> - Revise rt5033_dev mfd cell entry.
> - Fix incorrect typo.
> - Add module alias.
> 
> Changes in v4
> - none.
> 
> Changes in v3
> - Correct sentence errors.
> - Add author information the top of each drivers.
> - Remove unnecessary pre-initialise, struct member(rt5033->i2c) and blink.
> - Change some return check.
> - Use bool and of_match_ptr().
> 
> Changes in v2
> - Remove volatile_reg callback. Because this driver not in use regmap cache.
> - Revmoe unnecessary subnode of_compatible.
> - Add define for set_high impedance mode of charger.
> 
>  drivers/mfd/Kconfig                |   12 ++
>  drivers/mfd/Makefile               |    1 +
>  drivers/mfd/rt5033.c               |  141 +++++++++++++++++++
>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rt5033.h         |   62 +++++++++
>  5 files changed, 476 insertions(+)
>  create mode 100644 drivers/mfd/rt5033.c
>  create mode 100644 include/linux/mfd/rt5033-private.h
>  create mode 100644 include/linux/mfd/rt5033.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 72d3808..9c13170 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -618,6 +618,18 @@ config MFD_RTSX_PCI
>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>  	  Secure Digital and MultiMediaCard.
>  
> +config MFD_RT5033
> +	tristate "Richtek RT5033 Power Management IC"
> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  This driver provides for the Richtek RT5033 Power Management IC,
> +	  which includes the I2C driver and the Core APIs. This driver provides
> +	  common support for accessing the device. The device supports multiple
> +	  sub-devices like charger, fuel gauge, flash LED, current source,
> +	  LDO and Buck.
> +
>  config MFD_RTSX_USB
>  	tristate "Realtek USB card reader"
>  	depends on USB
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 53467e2..4059c24 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -176,6 +176,7 @@ obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
>  obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
>  obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
>  obj-$(CONFIG_MFD_DLN2)		+= dln2.o
> +obj-$(CONFIG_MFD_RT5033)	+= rt5033.o
>  
>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> diff --git a/drivers/mfd/rt5033.c b/drivers/mfd/rt5033.c
> new file mode 100644
> index 0000000..e2877c0
> --- /dev/null
> +++ b/drivers/mfd/rt5033.c
> @@ -0,0 +1,141 @@
> +/*
> + * MFD core driver for the Richtek RT5033.
> + *
> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/rt5033.h>
> +#include <linux/mfd/rt5033-private.h>
> +
> +static const struct regmap_irq rt5033_irqs[] = {
> +	{ .mask = RT5033_PMIC_IRQ_BUCKOCP, },
> +	{ .mask = RT5033_PMIC_IRQ_BUCKLV, },
> +	{ .mask = RT5033_PMIC_IRQ_SAFELDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_LDOLV, },
> +	{ .mask = RT5033_PMIC_IRQ_OT, },
> +	{ .mask = RT5033_PMIC_IRQ_VDDA_UV, },
> +};
> +
> +static const struct regmap_irq_chip rt5033_irq_chip = {
> +	.name		= "rt5033",
> +	.status_base	= RT5033_REG_PMIC_IRQ_STAT,
> +	.mask_base	= RT5033_REG_PMIC_IRQ_CTRL,
> +	.mask_invert	= true,
> +	.num_regs	= 1,
> +	.irqs		= rt5033_irqs,
> +	.num_irqs	= ARRAY_SIZE(rt5033_irqs),
> +};
> +
> +static const struct mfd_cell rt5033_devs[] = {
> +	{ .name = "rt5033-regulator", },
> +	{
> +		.name = "rt5033-charger",
> +		.of_compatible = "richtek,rt5033-charger",
> +	}, {
> +		.name = "rt5033-battery",
> +		.of_compatible = "richtek,rt5033-battery",
> +	},
> +};
> +
> +static const struct of_device_id rt5033_dt_match[] = {
> +	{ .compatible = "richtek,rt5033", },
> +	{ }
> +};
> +
> +static const struct regmap_config rt5033_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.max_register	= RT5033_REG_END,
> +};
> +
> +static int rt5033_i2c_probe(struct i2c_client *i2c,
> +				const struct i2c_device_id *id)
> +{
> +	struct rt5033_dev *rt5033;
> +	unsigned int data;
> +	int ret;
> +
> +	rt5033 = devm_kzalloc(&i2c->dev, sizeof(*rt5033), GFP_KERNEL);
> +	if (!rt5033)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, rt5033);
> +	rt5033->dev = &i2c->dev;
> +	rt5033->irq = i2c->irq;
> +	rt5033->wakeup = true;
> +
> +	rt5033->regmap = devm_regmap_init_i2c(i2c, &rt5033_regmap_config);
> +	if (IS_ERR(rt5033->regmap)) {
> +		dev_err(&i2c->dev, "Failed to allocate register map.\n");
> +		return PTR_ERR(rt5033->regmap);
> +	}
> +
> +	ret = regmap_read(rt5033->regmap, RT5033_REG_DEVICE_ID, &data);
> +	if (ret) {
> +		dev_err(&i2c->dev, "Device not found\n");
> +		return -ENODEV;
> +	}
> +	dev_info(&i2c->dev, "Device found Device ID: %04x\n", data);
> +
> +	ret = regmap_add_irq_chip(rt5033->regmap, rt5033->irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			0, &rt5033_irq_chip, &rt5033->irq_data);
> +	if (ret) {
> +		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
> +							rt5033->irq, ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(rt5033->dev, -1, rt5033_devs,
> +			ARRAY_SIZE(rt5033_devs), NULL, 0,
> +			regmap_irq_get_domain(rt5033->irq_data));
> +	if (ret < 0) {
> +		dev_err(&i2c->dev, "Failed to add RT5033 child devices.\n");
> +		return ret;
> +	}
> +
> +	device_init_wakeup(rt5033->dev, rt5033->wakeup);
> +
> +	return 0;
> +}
> +
> +static int rt5033_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct rt5033_dev *rt5033 = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(rt5033->dev);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id rt5033_i2c_id[] = {
> +	{ "rt5033", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, rt5033_i2c_id);
> +
> +static struct i2c_driver rt5033_driver = {
> +	.driver = {
> +		.name = "rt5033",
> +		.of_match_table = of_match_ptr(rt5033_dt_match),
> +	},
> +	.probe = rt5033_i2c_probe,
> +	.remove = rt5033_i2c_remove,
> +	.id_table = rt5033_i2c_id,
> +};
> +module_i2c_driver(rt5033_driver);
> +
> +MODULE_ALIAS("i2c:rt5033");
> +MODULE_DESCRIPTION("Richtek RT5033 multi-function core driver");
> +MODULE_AUTHOR("Beomho Seo <beomho.seo@samsung.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
> new file mode 100644
> index 0000000..1b63fc2
> --- /dev/null
> +++ b/include/linux/mfd/rt5033-private.h
> @@ -0,0 +1,260 @@
> +/*
> + * MFD core driver for Richtek RT5033
> + *
> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#ifndef __RT5033_PRIVATE_H__
> +#define __RT5033_PRIVATE_H__
> +
> +enum rt5033_reg {
> +	RT5033_REG_CHG_STAT		= 0x00,
> +	RT5033_REG_CHG_CTRL1		= 0x01,
> +	RT5033_REG_CHG_CTRL2		= 0x02,
> +	RT5033_REG_DEVICE_ID		= 0x03,
> +	RT5033_REG_CHG_CTRL3		= 0x04,
> +	RT5033_REG_CHG_CTRL4		= 0x05,
> +	RT5033_REG_CHG_CTRL5		= 0x06,
> +	RT5033_REG_RT_CTRL0		= 0x07,
> +	RT5033_REG_CHG_RESET		= 0x08,
> +	/* Reserved 0x09~0x18 */
> +	RT5033_REG_RT_CTRL1		= 0x19,
> +	/* Reserved 0x1A~0x20 */
> +	RT5033_REG_FLED_FUNCTION1	= 0x21,
> +	RT5033_REG_FLED_FUNCTION2	= 0x22,
> +	RT5033_REG_FLED_STROBE_CTRL1	= 0x23,
> +	RT5033_REG_FLED_STROBE_CTRL2	= 0x24,
> +	RT5033_REG_FLED_CTRL1		= 0x25,
> +	RT5033_REG_FLED_CTRL2		= 0x26,
> +	RT5033_REG_FLED_CTRL3		= 0x27,
> +	RT5033_REG_FLED_CTRL4		= 0x28,
> +	RT5033_REG_FLED_CTRL5		= 0x29,
> +	/* Reserved 0x2A~0x40 */
> +	RT5033_REG_CTRL			= 0x41,
> +	RT5033_REG_BUCK_CTRL		= 0x42,
> +	RT5033_REG_LDO_CTRL		= 0x43,
> +	/* Reserved 0x44~0x46 */
> +	RT5033_REG_MANUAL_RESET_CTRL	= 0x47,
> +	/* Reserved 0x48~0x5F */
> +	RT5033_REG_CHG_IRQ1		= 0x60,
> +	RT5033_REG_CHG_IRQ2		= 0x61,
> +	RT5033_REG_CHG_IRQ3		= 0x62,
> +	RT5033_REG_CHG_IRQ1_CTRL	= 0x63,
> +	RT5033_REG_CHG_IRQ2_CTRL	= 0x64,
> +	RT5033_REG_CHG_IRQ3_CTRL	= 0x65,
> +	RT5033_REG_LED_IRQ_STAT		= 0x66,
> +	RT5033_REG_LED_IRQ_CTRL		= 0x67,
> +	RT5033_REG_PMIC_IRQ_STAT	= 0x68,
> +	RT5033_REG_PMIC_IRQ_CTRL	= 0x69,
> +	RT5033_REG_SHDN_CTRL		= 0x6A,
> +	RT5033_REG_OFF_EVENT		= 0x6B,
> +
> +	RT5033_REG_END,
> +};
> +
> +/* RT5033 Charger state register */
> +#define RT5033_CHG_STAT_MASK		0x20
> +#define RT5033_CHG_STAT_DISCHARGING	0x00
> +#define RT5033_CHG_STAT_FULL		0x10
> +#define RT5033_CHG_STAT_CHARGING	0x20
> +#define RT5033_CHG_STAT_NOT_CHARGING	0x30
> +#define RT5033_CHG_STAT_TYPE_MASK	0x60
> +#define RT5033_CHG_STAT_TYPE_PRE	0x20
> +#define RT5033_CHG_STAT_TYPE_FAST	0x60
> +
> +/* RT5033 CHGCTRL1 register */
> +#define RT5033_CHGCTRL1_IAICR_MASK	0xe0
> +#define RT5033_CHGCTRL1_MODE_MASK	0x01
> +
> +/* RT5033 CHGCTRL2 register */
> +#define RT5033_CHGCTRL2_CV_MASK		0xfc
> +
> +/* RT5033 CHGCTRL3 register */
> +#define RT5033_CHGCTRL3_CFO_EN_MASK	0x40
> +#define RT5033_CHGCTRL3_TIMER_MASK	0x38
> +#define RT5033_CHGCTRL3_TIMER_EN_MASK	0x01
> +
> +/* RT5033 CHGCTRL4 register */
> +#define RT5033_CHGCTRL4_EOC_MASK	0x07
> +#define RT5033_CHGCTRL4_IPREC_MASK	0x18
> +
> +/* RT5033 CHGCTRL5 register */
> +#define RT5033_CHGCTRL5_VPREC_MASK	0x0f
> +#define RT5033_CHGCTRL5_ICHG_MASK	0xf0
> +#define RT5033_CHGCTRL5_ICHG_SHIFT	0x04
> +#define RT5033_CHG_MAX_CURRENT		0x0d
> +
> +/* RT5033 RT CTRL1 register */
> +#define RT5033_RT_CTRL1_UUG_MASK	0x02
> +#define RT5033_RT_HZ_MASK		0x01
> +
> +/* RT5033 control register */
> +#define RT5033_CTRL_FCCM_BUCK_MASK		0x00
> +#define RT5033_CTRL_BUCKOMS_MASK		0x01
> +#define RT5033_CTRL_LDOOMS_MASK			0x02
> +#define RT5033_CTRL_SLDOOMS_MASK		0x03
> +#define RT5033_CTRL_EN_BUCK_MASK		0x04
> +#define RT5033_CTRL_EN_LDO_MASK			0x05
> +#define RT5033_CTRL_EN_SAFE_LDO_MASK		0x06
> +#define RT5033_CTRL_LDO_SLEEP_MASK		0x07
> +
> +/* RT5033 BUCK control register */
> +#define RT5033_BUCK_CTRL_MASK			0x1f
> +
> +/* RT5033 LDO control register */
> +#define RT5033_LDO_CTRL_MASK			0x1f
> +
> +/* RT5033 charger property - model, manufacturer */
> +
> +#define RT5033_CHARGER_MODEL	"RT5033WSC Charger"
> +#define RT5033_MANUFACTURER	"Richtek Technology Corporation"
> +
> +/*
> + * RT5033 charger fast-charge current lmits (as in CHGCTRL1 register),
> + * AICR mode limits the input current for example,
> + * the AIRC 100 mode limits the input current to 100 mA.
> + */
> +#define RT5033_AICR_100_MODE			0x20
> +#define RT5033_AICR_500_MODE			0x40
> +#define RT5033_AICR_700_MODE			0x60
> +#define RT5033_AICR_900_MODE			0x80
> +#define RT5033_AICR_1500_MODE			0xc0
> +#define RT5033_AICR_2000_MODE			0xe0
> +#define RT5033_AICR_MODE_MASK			0xe0
> +
> +/* RT5033 use internal timer need to set time */
> +#define RT5033_FAST_CHARGE_TIMER4		0x00
> +#define RT5033_FAST_CHARGE_TIMER6		0x01
> +#define RT5033_FAST_CHARGE_TIMER8		0x02
> +#define RT5033_FAST_CHARGE_TIMER9		0x03
> +#define RT5033_FAST_CHARGE_TIMER12		0x04
> +#define RT5033_FAST_CHARGE_TIMER14		0x05
> +#define RT5033_FAST_CHARGE_TIMER16		0x06
> +
> +#define RT5033_INT_TIMER_ENABLE			0x01
> +
> +/* RT5033 charger termination enable mask */
> +#define RT5033_TE_ENABLE_MASK			0x08
> +
> +/*
> + * RT5033 charger opa mode. RT50300 have two opa mode charger mode
> + * and boost mode for OTG
> + */
> +
> +#define RT5033_CHARGER_MODE			0x00
> +#define RT5033_BOOST_MODE			0x01
> +
> +/* RT5033 charger termination enable */
> +#define RT5033_TE_ENABLE			0x08
> +
> +/* RT5033 charger CFO enable */
> +#define RT5033_CFO_ENABLE			0x40
> +
> +/* RT5033 charger constant charge voltage (as in CHGCTRL2 register), uV */
> +#define RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MIN	3650000U
> +#define RT5033_CHARGER_CONST_VOLTAGE_STEP_NUM   25000U
> +#define RT5033_CHARGER_CONST_VOLTAGE_LIMIT_MAX	4400000U
> +
> +/* RT5033 charger pre-charge current limits (as in CHGCTRL4 register), uA */
> +#define RT5033_CHARGER_PRE_CURRENT_LIMIT_MIN	350000U
> +#define RT5033_CHARGER_PRE_CURRENT_STEP_NUM	100000U
> +#define RT5033_CHARGER_PRE_CURRENT_LIMIT_MAX	650000U
> +
> +/* RT5033 charger fast-charge current (as in CHGCTRL5 register), uA */
> +#define RT5033_CHARGER_FAST_CURRENT_MIN		700000U
> +#define RT5033_CHARGER_FAST_CURRENT_STEP_NUM	100000U
> +#define RT5033_CHARGER_FAST_CURRENT_MAX		2000000U
> +
> +/*
> + * RT5033 charger const-charge end of charger current (
> + * as in CHGCTRL4 register), uA
> + */
> +#define RT5033_CHARGER_EOC_MIN			150000U
> +#define RT5033_CHARGER_EOC_REF			300000U
> +#define RT5033_CHARGER_EOC_STEP_NUM1		50000U
> +#define RT5033_CHARGER_EOC_STEP_NUM2		100000U
> +#define RT5033_CHARGER_EOC_MAX			600000U
> +
> +/*
> + * RT5033 charger pre-charge threshold volt limits
> + * (as in CHGCTRL5 register), uV
> + */
> +
> +#define RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MIN	2300000U
> +#define RT5033_CHARGER_PRE_THRESHOLD_STEP_NUM	100000U
> +#define RT5033_CHARGER_PRE_THRESHOLD_LIMIT_MAX	3800000U
> +
> +/*
> + * RT5033 charger enable UUG, If UUG enable MOS auto control by H/W charger
> + * circuit.
> + */
> +#define RT5033_CHARGER_UUG_ENABLE		0x02
> +
> +/* RT5033 charger High impedance mode */
> +#define RT5033_CHARGER_HZ_DISABLE		0x00
> +#define RT5033_CHARGER_HZ_ENABLE		0x01
> +
> +/* RT5033 regulator BUCK output voltage uV */
> +#define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
> +#define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
> +#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
> +#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
> +
> +/* RT5033 regulator LDO output voltage uV */
> +#define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
> +#define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
> +#define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
> +#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
> +
> +/* RT5033 regulator SAFE LDO output voltage uV */
> +#define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
> +
> +enum rt5033_fuel_reg {
> +	RT5033_FUEL_REG_OCV_H		= 0x00,
> +	RT5033_FUEL_REG_OCV_L		= 0x01,
> +	RT5033_FUEL_REG_VBAT_H		= 0x02,
> +	RT5033_FUEL_REG_VBAT_L		= 0x03,
> +	RT5033_FUEL_REG_SOC_H		= 0x04,
> +	RT5033_FUEL_REG_SOC_L		= 0x05,
> +	RT5033_FUEL_REG_CTRL_H		= 0x06,
> +	RT5033_FUEL_REG_CTRL_L		= 0x07,
> +	RT5033_FUEL_REG_CRATE		= 0x08,
> +	RT5033_FUEL_REG_DEVICE_ID	= 0x09,
> +	RT5033_FUEL_REG_AVG_VOLT_H	= 0x0A,
> +	RT5033_FUEL_REG_AVG_VOLT_L	= 0x0B,
> +	RT5033_FUEL_REG_CONFIG_H	= 0x0C,
> +	RT5033_FUEL_REG_CONFIG_L	= 0x0D,
> +	/* Reserved 0x0E~0x0F */
> +	RT5033_FUEL_REG_IRQ_CTRL	= 0x10,
> +	RT5033_FUEL_REG_IRQ_FLAG	= 0x11,
> +	RT5033_FUEL_VMIN		= 0x12,
> +	RT5033_FUEL_SMIN		= 0x13,
> +	/* Reserved 0x14~0x1F */
> +	RT5033_FUEL_VGCOMP1		= 0x20,
> +	RT5033_FUEL_VGCOMP2		= 0x21,
> +	RT5033_FUEL_VGCOMP3		= 0x22,
> +	RT5033_FUEL_VGCOMP4		= 0x23,
> +	/* Reserved 0x24~0xFD */
> +	RT5033_FUEL_MFA_H		= 0xFE,
> +	RT5033_FUEL_MFA_L		= 0xFF,
> +
> +	RT5033_FUEL_REG_END,
> +};
> +
> +/* RT5033 fuel gauge battery present property */
> +#define RT5033_FUEL_BAT_PRESENT		0x02
> +
> +/* RT5033 PMIC interrupts */
> +#define RT5033_PMIC_IRQ_BUCKOCP		2
> +#define RT5033_PMIC_IRQ_BUCKLV		3
> +#define RT5033_PMIC_IRQ_SAFELDOLV	4
> +#define RT5033_PMIC_IRQ_LDOLV		5
> +#define RT5033_PMIC_IRQ_OT		6
> +#define RT5033_PMIC_IRQ_VDDA_UV		7
> +
> +#endif /* __RT5033_PRIVATE_H__ */
> diff --git a/include/linux/mfd/rt5033.h b/include/linux/mfd/rt5033.h
> new file mode 100644
> index 0000000..bd06415
> --- /dev/null
> +++ b/include/linux/mfd/rt5033.h
> @@ -0,0 +1,62 @@
> +/*
> + * MFD core driver for the RT5033
> + *
> + * Copyright (C) 2014 Samsung Electronics
> + * Author: Beomho Seo <beomho.seo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published bythe Free Software Foundation.
> + */
> +
> +#ifndef __RT5033_H__
> +#define __RT5033_H__
> +
> +#include <linux/regulator/consumer.h>
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/power_supply.h>
> +
> +/* RT5033 regulator IDs */
> +enum rt5033_regulators {
> +	RT5033_BUCK = 0,
> +	RT5033_LDO,
> +	RT5033_SAFE_LDO,
> +
> +	RT5033_REGULATOR_NUM,
> +};
> +
> +struct rt5033_dev {
> +	struct device *dev;
> +
> +	struct regmap *regmap;
> +	struct regmap_irq_chip_data *irq_data;
> +	int irq;
> +	bool wakeup;
> +};
> +
> +struct rt5033_battery {
> +	struct i2c_client	*client;
> +	struct rt5033_dev	*rt5033;
> +	struct regmap		*regmap;
> +	struct power_supply	psy;
> +};
> +
> +/* RT5033 charger platform data */
> +struct rt5033_charger_data {
> +	unsigned int pre_uamp;
> +	unsigned int pre_uvolt;
> +	unsigned int const_uvolt;
> +	unsigned int eoc_uamp;
> +	unsigned int fast_uamp;
> +};
> +
> +struct rt5033_charger {
> +	struct device		*dev;
> +	struct rt5033_dev	*rt5033;
> +	struct power_supply	psy;
> +
> +	struct rt5033_charger_data	*data;
> +};
> +
> +#endif /* __RT5033_H__ */
> 

