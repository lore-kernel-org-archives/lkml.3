Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbbAWLSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:18:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44201 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbAWLSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:18:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-59-54c22d5d28b4
Content-transfer-encoding: 8BIT
Message-id: <1422011884.18205.4.camel@AMDC1943>
Subject: Re: [PATCH 1/6] mfd: max77843: Add max77843 MFD driver core driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>
Date: Fri, 23 Jan 2015 12:18:04 +0100
In-reply-to: <54C22C3B.8040403@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-2-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPfRYhJNUAE=W3zPWvyza9k_YA=hu4KjLRuLh7kie3guQA@mail.gmail.com>
 <54C1ED09.1080607@samsung.com> <1421997364.27149.5.camel@AMDC1943>
 <54C22C3B.8040403@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xq7qxuodCDPZskrM4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWix0NR1gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj5XLv7B5bFrVyeZx59oeNo++LasYPT5vkgtg
	j+KySUnNySxLLdK3S+DKmHe5n6Xgr01Fx+r8BsZWvS5GTg4JAROJxVM2M0PYYhIX7q1nA7GF
	BJYySszaKwxi8woISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuAWrmAyj8zSpxpOcIOUsMr
	oC/xsNUSxBQW8JZY3uQHUs4mYCyxefkSsOkiQK0773SCtTILfGKW2P1mNdgJLAKqEkdWXWQC
	6eUU0Ja4s9AWYvwWJomWzQcYQeISAsoSjf1uExgFZiE5bhbCcbOQHLeAkXkVo2hqaXJBcVJ6
	rpFecWJucWleul5yfu4mRkj0fN3BuPSY1SFGAQ5GJR7eA28OhgixJpYVV+YeYpTgYFYS4bXW
	PBQixJuSWFmVWpQfX1Sak1p8iJGJg1OqgfHIHYX5QaJz9y36+m+B5cSkNRfl36yZEuMgzH9H
	6U2ofL3G5SfzZKcvee3fezp/Tre9nqGVcvBpXevUPYc/zX3xwiaf50O6lrIdk4292lVGA0VO
	02ijrK2Ki8vPHfvqpnN9rcvy2qqeqYFb1gY+cHV3P8i0sGG12byUm7fb7E9XcCw2tCnu36XE
	UpyRaKjFXFScCAC5VunsfAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2015-01-23 at 20:10 +0900, Beomho Seo wrote:
> On 01/23/2015 04:16 PM, Krzysztof Kozlowski wrote:
> > On pią, 2015-01-23 at 15:41 +0900, Beomho Seo wrote:
> >> On 01/23/2015 03:32 PM, Krzysztof Kozlowski wrote:
> >>> 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
> >>>> This patch adds MAX77843 core/irq driver to support PMIC,
> >>>> MUIC(Micro USB Interface Controller), Charger, Fuel Gauge,
> >>>> LED and Haptic device.
> >>>>
> >>>> Cc: Lee Jones <lee.jones@linaro.org>
> >>>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> >>>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> >>>> ---
> >>>>  drivers/mfd/Kconfig                  |   14 ++
> >>>>  drivers/mfd/Makefile                 |    1 +
> >>>>  drivers/mfd/max77843.c               |  241 ++++++++++++++++++++
> >>>>  include/linux/mfd/max77843-private.h |  410 ++++++++++++++++++++++++++++++++++
> >>>>  4 files changed, 666 insertions(+)
> >>>>  create mode 100644 drivers/mfd/max77843.c
> >>>>  create mode 100644 include/linux/mfd/max77843-private.h
> >>>>
> >>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >>>> index 2e6b731..0c67c79 100644
> >>>> --- a/drivers/mfd/Kconfig
> >>>> +++ b/drivers/mfd/Kconfig
> >>>> @@ -442,6 +442,20 @@ config MFD_MAX77693
> >>>>           additional drivers must be enabled in order to use the functionality
> >>>>           of the device.
> >>>>
> >>>> +config MFD_MAX77843
> >>>> +       bool "Maxim Semiconductor MAX77843 PMIC Support"
> >>>> +       depends on I2C=y
> >>>> +       select MFD_CORE
> >>>> +       select REGMAP_I2C
> >>>> +       select REGMAP_IRQ
> >>>> +       help
> >>>> +         Say yes here to add support for Maxim Semiconductor MAX77843.
> >>>> +         This is companion Power Management IC with LEDs, Haptic, Charger,
> >>>> +         Fuel Gauge, MUIC(Micro USB Interface Controller) controls on chip.
> >>>> +         This driver provides common support for accessing the device;
> >>>> +         additional drivers must be enabled in order to use the functionality
> >>>> +         of the device.
> >>>> +
> >>>>  config MFD_MAX8907
> >>>>         tristate "Maxim Semiconductor MAX8907 PMIC Support"
> >>>>         select MFD_CORE
> >>>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> >>>> index 53467e2..fe4f75c 100644
> >>>> --- a/drivers/mfd/Makefile
> >>>> +++ b/drivers/mfd/Makefile
> >>>> @@ -117,6 +117,7 @@ obj-$(CONFIG_MFD_DA9063)    += da9063.o
> >>>>  obj-$(CONFIG_MFD_MAX14577)     += max14577.o
> >>>>  obj-$(CONFIG_MFD_MAX77686)     += max77686.o
> >>>>  obj-$(CONFIG_MFD_MAX77693)     += max77693.o
> >>>> +obj-$(CONFIG_MFD_MAX77843)     += max77843.o
> >>>>  obj-$(CONFIG_MFD_MAX8907)      += max8907.o
> >>>>  max8925-objs                   := max8925-core.o max8925-i2c.o
> >>>>  obj-$(CONFIG_MFD_MAX8925)      += max8925.o
> >>>> diff --git a/drivers/mfd/max77843.c b/drivers/mfd/max77843.c
> >>>> new file mode 100644
> >>>> index 0000000..d7f8b76
> >>>> --- /dev/null
> >>>> +++ b/drivers/mfd/max77843.c
> >>>> @@ -0,0 +1,241 @@
> >>>> +/*
> >>>> + * max77843.c - MFD core driver for the Maxim MAX77843
> >>>> + *
> >>>> + * Copyright (C) 2014 Samsung Electrnoics
> >>>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify
> >>>> + * it under the terms of the GNU General Public License as published by
> >>>> + * the Free Software Foundation; either version 2 of the License, or
> >>>> + * (at your option) any later version.
> >>>> + */
> >>>> +
> >>>> +#include <linux/err.h>
> >>>> +#include <linux/i2c.h>
> >>>> +#include <linux/init.h>
> >>>> +#include <linux/interrupt.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/mfd/core.h>
> >>>> +#include <linux/mfd/max77843-private.h>
> >>>> +#include <linux/of_device.h>
> >>>> +#include <linux/platform_device.h>
> >>>> +
> >>>> +static const struct mfd_cell max77843_devs[] = {
> >>>> +       {
> >>>> +               .name = "max77843-muic",
> >>>> +               .of_compatible = "maxim,max77843-muic",
> >>>> +       }, {
> >>>> +               .name = "max77843-regulator",
> >>>> +               .of_compatible = "maxim,max77843-regulator",
> >>>> +       }, {
> >>>> +               .name = "max77843-charger",
> >>>> +               .of_compatible = "maxim,max77843-charger"
> >>>> +       }, {
> >>>> +               .name = "max77843-fuelgauge",
> >>>> +               .of_compatible = "maxim,max77843-fuelgauge",
> >>>> +       },
> >>>> +};
> >>>> +
> >>>> +static const struct regmap_config max77843_charger_regmap_config = {
> >>>> +       .reg_bits       = 8,
> >>>> +       .val_bits       = 8,
> >>>> +       .max_register   = MAX77843_CHG_REG_END,
> >>>> +};
> >>>> +
> >>>> +static const struct regmap_config max77843_regmap_config = {
> >>>> +       .reg_bits       = 8,
> >>>> +       .val_bits       = 8,
> >>>> +       .max_register   = MAX77843_SYS_REG_END,
> >>>> +};
> >>>> +
> >>>> +static const struct regmap_irq max77843_irqs[] = {
> >>>> +       /* TOPSYS interrupts */
> >>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSUVLO_INT, },
> >>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSOVLO_INT, },
> >>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TSHDN_INT, },
> >>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TM_INT, },
> >>>> +};
> >>>> +
> >>>> +static const struct regmap_irq_chip max77843_irq_chip = {
> >>>> +       .name           = "max77843",
> >>>> +       .status_base    = MAX77843_SYS_REG_SYSINTSRC,
> >>>> +       .mask_base      = MAX77843_SYS_REG_SYSINTMASK,
> >>>> +       .mask_invert    = false,
> >>>> +       .num_regs       = 1,
> >>>> +       .irqs           = max77843_irqs,
> >>>> +       .num_irqs       = ARRAY_SIZE(max77843_irqs),
> >>>> +};
> >>>> +
> >>>> +static int max77843_chg_init(struct max77843 *max77843)
> >>>> +{
> >>>
> >>> Could this function be moved to the charger driver? This way the
> >>> driver will manage its own resources instead of depending on parent
> >>> MFD driver.
> >>>
> >>
> >> Charger regulator and Charger share same resources.
> >> So I include this function core driver.
> > 
> > OK, I see... Could you describe it in comments somewhere? For example in
> > comment above the function. Currently this looks like only as regmap for
> > charger.
> > 
> 
> Charger regulator and Charger use same regmap.

OK, just put it in a comment around that function.

> 
> > Unfortunately current solution imposes problem with releasing resources.
> > Who is the owner of i2c dummy device?
> > 
> 
> Core driver owner of i2c dummy device.

OK, good idea. So the core driver should be the only place to unregister
it. So needed changes are:
1. Remove the i2c_unregister_device() call from
max77843_charger_probe().
2. Add i2c_unregister_device(max77843->i2c_chg) in max77843_remove().

The MFD core driver will handle it.

> 
> > 1. The charger driver will unregister it if max77843_charger_probe()
> > fails. What will happen with regulator driver in such case?
> > 
> 
> Charger is enabled/disabled by Charger regulator.
> Currently, If charger probe fails, charger regulator failed to read regmap and occur panic(It have to fix.)
> 
> 
> > 2. Who will release this i2c dummy device in normal unbind? Currently it
> > leaks.
> > 
> 
> I think core driver release i2c dummy device in normal unbind.
> We need to more discussion about this problem.
> If you have any idea, I hope tell me. Again, Thank you for your advice.

I think handling the ownership in core driver could solve this.

Best regards,
Krzysztof



