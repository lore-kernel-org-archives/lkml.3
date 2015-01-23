Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbbAWHFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:05:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35594 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbAWHFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:05:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-88-54c1f22e8533
Content-transfer-encoding: 8BIT
Message-id: <1421996733.27149.0.camel@AMDC1943>
Subject: Re: [PATCH 1/6] mfd: max77843: Add max77843 MFD driver core driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Date: Fri, 23 Jan 2015 08:05:33 +0100
In-reply-to: <54C1F067.90907@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-2-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPfRYhJNUAE=W3zPWvyza9k_YA=hu4KjLRuLh7kie3guQA@mail.gmail.com>
 <54C1F067.90907@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xK7p6nw6GGPw8J2xx+tM2doupD5+w
	WVz/8pzVYv6Rc6wW/W8Wslqce7WS0WLS/QksFjsajrBa3P96lNHi8q45bBafe48wWiy9fpHJ
	YsL0tSwWrXuPsFuc3l3iwO+xZt4aRo/Lfb1MHiuXf2Hz2LSqk83jzrU9bB59W1YxenzeJBfA
	HsVlk5Kak1mWWqRvl8CVMXnpJ9aCw14Vfw+8Y2tg3GnSxcjJISFgIvHs1hZWCFtM4sK99Wxd
	jFwcQgJLGSXuXDgBluAVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUf2aUeLN+CztE
	vb7EoevfmEDqhQW8JZY3+YGE2QSMJTYvX8IGYosIaEocOXKEEaSXWeADs8T/3kNMIAkWAVWJ
	KZ+7weZwAhVNuP0ezBYSeMso8XyZFshMCQFlicZ+twmMArOQXDcL4bpZSK5bwMi8ilE0tTS5
	oDgpPddIrzgxt7g0L10vOT93EyMkhr7uYFx6zOoQowAHoxIP74E3B0OEWBPLiitzDzFKcDAr
	ifB2PwIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYPRznc52urErNb9zQdmhlGBRI/nbwanX9r1Y
	91zYwcXs3y4264JgWbnNKW7/i3weSzgd+vdtEo+k6K9X2Ypq6n9n+p7/m3tplvv5I/s33Nnh
	tN5/m/q2dZabTl1cPTFsbtyfs/dnC2907xfpWlLomb0hmnUr48F3S0KmifNvzdV3OLr7gsCi
	yeFKLMUZiYZazEXFiQDAbTjZfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2015-01-23 at 15:55 +0900, Jaewon Kim wrote:
> Hi Krzysztof,
> 
> 2015년 01월 23일 15:32에 Krzysztof Kozlowski 이(가) 쓴 글:
> > 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
> >> This patch adds MAX77843 core/irq driver to support PMIC,
> >> MUIC(Micro USB Interface Controller), Charger, Fuel Gauge,
> >> LED and Haptic device.
> >>
> >> Cc: Lee Jones <lee.jones@linaro.org>
> >> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> >> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> >> ---
> >>   drivers/mfd/Kconfig                  |   14 ++
> >>   drivers/mfd/Makefile                 |    1 +
> >>   drivers/mfd/max77843.c               |  241 ++++++++++++++++++++
> >>   include/linux/mfd/max77843-private.h |  410 ++++++++++++++++++++++++++++++++++
> >>   4 files changed, 666 insertions(+)
> >>   create mode 100644 drivers/mfd/max77843.c
> >>   create mode 100644 include/linux/mfd/max77843-private.h
> >>
> >> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >> index 2e6b731..0c67c79 100644
> >> --- a/drivers/mfd/Kconfig
> >> +++ b/drivers/mfd/Kconfig
> >> @@ -442,6 +442,20 @@ config MFD_MAX77693
> >>            additional drivers must be enabled in order to use the functionality
> >>            of the device.
> >>
> >> +config MFD_MAX77843
> >> +       bool "Maxim Semiconductor MAX77843 PMIC Support"
> >> +       depends on I2C=y
> >> +       select MFD_CORE
> >> +       select REGMAP_I2C
> >> +       select REGMAP_IRQ
> >> +       help
> >> +         Say yes here to add support for Maxim Semiconductor MAX77843.
> >> +         This is companion Power Management IC with LEDs, Haptic, Charger,
> >> +         Fuel Gauge, MUIC(Micro USB Interface Controller) controls on chip.
> >> +         This driver provides common support for accessing the device;
> >> +         additional drivers must be enabled in order to use the functionality
> >> +         of the device.
> >> +
> >>   config MFD_MAX8907
> >>          tristate "Maxim Semiconductor MAX8907 PMIC Support"
> >>          select MFD_CORE
> >> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> >> index 53467e2..fe4f75c 100644
> >> --- a/drivers/mfd/Makefile
> >> +++ b/drivers/mfd/Makefile
> >> @@ -117,6 +117,7 @@ obj-$(CONFIG_MFD_DA9063)    += da9063.o
> >>   obj-$(CONFIG_MFD_MAX14577)     += max14577.o
> >>   obj-$(CONFIG_MFD_MAX77686)     += max77686.o
> >>   obj-$(CONFIG_MFD_MAX77693)     += max77693.o
> >> +obj-$(CONFIG_MFD_MAX77843)     += max77843.o
> >>   obj-$(CONFIG_MFD_MAX8907)      += max8907.o
> >>   max8925-objs                   := max8925-core.o max8925-i2c.o
> >>   obj-$(CONFIG_MFD_MAX8925)      += max8925.o
> >> diff --git a/drivers/mfd/max77843.c b/drivers/mfd/max77843.c
> >> new file mode 100644
> >> index 0000000..d7f8b76
> >> --- /dev/null
> >> +++ b/drivers/mfd/max77843.c
> >> @@ -0,0 +1,241 @@
> >> +/*
> >> + * max77843.c - MFD core driver for the Maxim MAX77843
> >> + *
> >> + * Copyright (C) 2014 Samsung Electrnoics
> >> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + */
> >> +
> >> +#include <linux/err.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/init.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/module.h>
> >> +#include <linux/mfd/core.h>
> >> +#include <linux/mfd/max77843-private.h>
> >> +#include <linux/of_device.h>
> >> +#include <linux/platform_device.h>
> >> +
> >> +static const struct mfd_cell max77843_devs[] = {
> >> +       {
> >> +               .name = "max77843-muic",
> >> +               .of_compatible = "maxim,max77843-muic",
> >> +       }, {
> >> +               .name = "max77843-regulator",
> >> +               .of_compatible = "maxim,max77843-regulator",
> >> +       }, {
> >> +               .name = "max77843-charger",
> >> +               .of_compatible = "maxim,max77843-charger"
> >> +       }, {
> >> +               .name = "max77843-fuelgauge",
> >> +               .of_compatible = "maxim,max77843-fuelgauge",
> >> +       },
> >> +};
> >> +
> >> +static const struct regmap_config max77843_charger_regmap_config = {
> >> +       .reg_bits       = 8,
> >> +       .val_bits       = 8,
> >> +       .max_register   = MAX77843_CHG_REG_END,
> >> +};
> >> +
> >> +static const struct regmap_config max77843_regmap_config = {
> >> +       .reg_bits       = 8,
> >> +       .val_bits       = 8,
> >> +       .max_register   = MAX77843_SYS_REG_END,
> >> +};
> >> +
> >> +static const struct regmap_irq max77843_irqs[] = {
> >> +       /* TOPSYS interrupts */
> >> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSUVLO_INT, },
> >> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSOVLO_INT, },
> >> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TSHDN_INT, },
> >> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TM_INT, },
> >> +};
> >> +
> >> +static const struct regmap_irq_chip max77843_irq_chip = {
> >> +       .name           = "max77843",
> >> +       .status_base    = MAX77843_SYS_REG_SYSINTSRC,
> >> +       .mask_base      = MAX77843_SYS_REG_SYSINTMASK,
> >> +       .mask_invert    = false,
> >> +       .num_regs       = 1,
> >> +       .irqs           = max77843_irqs,
> >> +       .num_irqs       = ARRAY_SIZE(max77843_irqs),
> >> +};
> >> +
> >> +static int max77843_chg_init(struct max77843 *max77843)
> >> +{
> > Could this function be moved to the charger driver? This way the
> > driver will manage its own resources instead of depending on parent
> > MFD driver.
> >
> >> +       int ret;
> >> +
> >> +       max77843->i2c_chg = i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_CHG);
> >> +       if (!max77843->i2c_chg) {
> >> +               dev_err(&max77843->i2c->dev,
> >> +                               "Cannot allocate I2C device for Charger\n");
> >> +               return PTR_ERR(max77843->i2c_chg);
> >> +       }
> >> +       i2c_set_clientdata(max77843->i2c_chg, max77843);
> >> +
> >> +       max77843->regmap_chg = devm_regmap_init_i2c(max77843->i2c_chg,
> >> +                       &max77843_charger_regmap_config);
> >> +       if (IS_ERR(max77843->regmap_chg)) {
> >> +               ret = PTR_ERR(max77843->regmap_chg);
> >> +               goto err_chg_i2c;
> >> +       }
> >> +
> >> +       return 0;
> >> +
> >> +err_chg_i2c:
> >> +       i2c_unregister_device(max77843->i2c_chg);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static int max77843_probe(struct i2c_client *i2c,
> >> +                                       const struct i2c_device_id *id)
> >> +{
> >> +       struct max77843 *max77843;
> >> +       int ret;
> >> +       unsigned int reg_data;
> >> +
> >> +       max77843 = devm_kzalloc(&i2c->dev, sizeof(*max77843), GFP_KERNEL);
> >> +       if (!max77843)
> >> +               return -ENOMEM;
> >> +
> >> +       i2c_set_clientdata(i2c, max77843);
> >> +       max77843->dev = &i2c->dev;
> >> +       max77843->i2c = i2c;
> >> +       max77843->irq = i2c->irq;
> >> +
> >> +       max77843->regmap = devm_regmap_init_i2c(i2c,
> >> +                       &max77843_regmap_config);
> >> +       if (IS_ERR(max77843->regmap)) {
> >> +               dev_err(&i2c->dev, "Failed to allocate topsys register map\n");
> >> +               return PTR_ERR(max77843->regmap);
> >> +       }
> >> +
> >> +       ret = regmap_add_irq_chip(max77843->regmap, max77843->irq,
> >> +                       IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
> >> +                       0, &max77843_irq_chip, &max77843->irq_data);
> > Why shared IRQ?
> 
> This IRQ shared with submodules.
> you can see another IRQ register process in extcon-max77843 driver.

Right, I found it later.

> 
> >
> >> +       if (ret) {
> >> +               dev_err(&i2c->dev, "Failed to add TOPSYS IRQ chip\n");
> >> +               return ret;
> >> +       }
> >> +
> >> +       ret = regmap_read(max77843->regmap,
> >> +                       MAX77843_SYS_REG_PMICID, &reg_data);
> >> +       if (ret < 0) {
> >> +               dev_err(&i2c->dev, "Failed to read PMIC ID\n");
> >> +               goto err_pmic_id;
> >> +       }
> >> +       dev_info(&i2c->dev, "device ID: 0x%x\n", reg_data);
> >> +
> >> +       ret = max77843_chg_init(max77843);
> >> +       if (ret) {
> >> +               dev_err(&i2c->dev, "Failed to init Charger\n");
> >> +               goto err_pmic_id;
> >> +       }
> >> +
> >> +       ret = regmap_update_bits(max77843->regmap,
> >> +                       MAX77843_SYS_REG_INTSRCMASK,
> >> +                       MAX77843_INTSRC_MASK_MASK,
> >> +                       (unsigned int)~MAX77843_INTSRC_MASK_MASK);
> >> +       if (ret < 0) {
> >> +               dev_err(&i2c->dev, "Failed to unmask interrupt sourece\n");
> > s/sourece/source/
> 
> I will fix typo in next version.
> 
> >
> > Best regards,
> > Krzysztof
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Thanks to review my patch.
> Jaewon Kim

