Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbbAWLK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:10:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13645 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbAWLKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:10:54 -0500
X-AuditID: cbfee68f-f791c6d000004834-ed-54c22c3c14b5
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Message-id: <54C22C3B.8040403@samsung.com>
Date: Fri, 23 Jan 2015 20:10:51 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/6] mfd: max77843: Add max77843 MFD driver core driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-2-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPfRYhJNUAE=W3zPWvyza9k_YA=hu4KjLRuLh7kie3guQA@mail.gmail.com>
 <54C1ED09.1080607@samsung.com> <1421997364.27149.5.camel@AMDC1943>
In-reply-to: <1421997364.27149.5.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkUNdG51CIwbur3BZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo8Wk+xNYLHY0HGG1eP3C0OL+16OMFpd3zWGz+Nx7hNFi6fWLTBYT
	pq9lsWjde4Td4vTuEgd+jzXz1jB6XO7rZfJYufwLm8emVZ1sHneu7WHz6NuyitHj8ya5APYo
	LpuU1JzMstQifbsEroyH316xF6wOqejqecvSwLjOrouRk0NCwERi0eKnrBC2mMSFe+vZQGwh
	gaWMEveX1MPUvF87nQkivohRYu52NxCbV0BQ4sfkeyxdjBwczALqElOm5IKEmQVEJRp2TGSC
	sLUlli18zdzFyAXU+ppR4sftX+wQvVoSb47NZQGxWQRUJRq+9IDdwCagKfF+yhWwuKhAhMT8
	YyDNnBwiAoYSB3dvZwIZxCzwiVli95vVzCCLhQW8JZY3+UEsmMwk8WbNXLAFnAIGEk0b9rKC
	JCQEZnJIbLs8lxVim4DEt8mHwK6WEJCV2HSAGeJJSYmDK26wTGAUn4Xkt1kIv81C8tssJL8t
	YGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRGYAk7/e9a/g/HuAetDjAIcjEo8vA1bDoYI
	sSaWFVfmHmI0BTpoIrOUaHI+MNHklcQbGpsZWZiamBobmVuaKYnzLpT6GSwkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBUarx9jdrrsMa70zEln1SS2vYcOZz1P7CelOdf6wuNzt+PV9dUvQ7
	amvyVpPzrxbrh+auueu8JoRHYmrVu7rtn7X+S0sZLr3OVLDLx/KQhXDRke/fcpzur5+e+WTF
	OeONLntLtoUq7H+hv3Xni8gN37haLizSmb7jb/09ZrsZ8z6/Pt1YJtc//64SS3FGoqEWc1Fx
	IgBIwkFh/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAV0bnUMhBv/CLaY+fMJmcf3Lc1aL
	+UfOsVr0v1nIanHu1UpGi0n3J7BY7Gg4wmrx+oWhxf2vRxktLu+aw2bxufcIo8XS6xeZLCZM
	X8ti0br3CLvF6d0lDvwea+atYfS43NfL5LFy+Rc2j02rOtk87lzbw+bRt2UVo8fnTXIB7FEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNuHnzKXrA2uGL5jx7mBsYNtl2M
	nBwSAiYS79dOZ4KwxSQu3FvPBmILCSxilJi73Q3E5hUQlPgx+R5LFyMHB7OAvMSRS9kQprrE
	lCm5XYxcQNWvGSV+3P7FDlGuJfHm2FwWEJtFQFWi4UsPK4jNJqAp8X7KFbC4qECExPxjr5lB
	bBEBQ4mDu7czgQxiFvjELLH7zWpmkAXCAt4Sy5v8IBZMZpJ4s2Yu2AJOAQOJpg17WScwCsxC
	ct4shPNmIZy3gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwsngmvYNxVYPFIUYBDkYl
	Ht6GLQdDhFgTy4orcw8xSnAwK4nwWmseChHiTUmsrEotyo8vKs1JLT7EaAr03ERmKdHkfGAi
	yyuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYJxlXnD3eNWdh//f
	ez74d0d4o2/vuzfnSz665/G89pf7cWXWi7ajsgdbcz6wMvpN/BWsWXpU2CRloWnNN6s7+w2T
	pc86//z2UOXrzDcT7vt1qCwymWh22eev8K2uqgsbxbrarqixdEkeNPvf1Sy785fKBsuVyw5O
	r5A6O+fy2SVKffVpXsWdl/8osRRnJBpqMRcVJwIAv0tZYCwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 04:16 PM, Krzysztof Kozlowski wrote:
> On pią, 2015-01-23 at 15:41 +0900, Beomho Seo wrote:
>> On 01/23/2015 03:32 PM, Krzysztof Kozlowski wrote:
>>> 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
>>>> This patch adds MAX77843 core/irq driver to support PMIC,
>>>> MUIC(Micro USB Interface Controller), Charger, Fuel Gauge,
>>>> LED and Haptic device.
>>>>
>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>>>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>>>> ---
>>>>  drivers/mfd/Kconfig                  |   14 ++
>>>>  drivers/mfd/Makefile                 |    1 +
>>>>  drivers/mfd/max77843.c               |  241 ++++++++++++++++++++
>>>>  include/linux/mfd/max77843-private.h |  410 ++++++++++++++++++++++++++++++++++
>>>>  4 files changed, 666 insertions(+)
>>>>  create mode 100644 drivers/mfd/max77843.c
>>>>  create mode 100644 include/linux/mfd/max77843-private.h
>>>>
>>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>>> index 2e6b731..0c67c79 100644
>>>> --- a/drivers/mfd/Kconfig
>>>> +++ b/drivers/mfd/Kconfig
>>>> @@ -442,6 +442,20 @@ config MFD_MAX77693
>>>>           additional drivers must be enabled in order to use the functionality
>>>>           of the device.
>>>>
>>>> +config MFD_MAX77843
>>>> +       bool "Maxim Semiconductor MAX77843 PMIC Support"
>>>> +       depends on I2C=y
>>>> +       select MFD_CORE
>>>> +       select REGMAP_I2C
>>>> +       select REGMAP_IRQ
>>>> +       help
>>>> +         Say yes here to add support for Maxim Semiconductor MAX77843.
>>>> +         This is companion Power Management IC with LEDs, Haptic, Charger,
>>>> +         Fuel Gauge, MUIC(Micro USB Interface Controller) controls on chip.
>>>> +         This driver provides common support for accessing the device;
>>>> +         additional drivers must be enabled in order to use the functionality
>>>> +         of the device.
>>>> +
>>>>  config MFD_MAX8907
>>>>         tristate "Maxim Semiconductor MAX8907 PMIC Support"
>>>>         select MFD_CORE
>>>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>>>> index 53467e2..fe4f75c 100644
>>>> --- a/drivers/mfd/Makefile
>>>> +++ b/drivers/mfd/Makefile
>>>> @@ -117,6 +117,7 @@ obj-$(CONFIG_MFD_DA9063)    += da9063.o
>>>>  obj-$(CONFIG_MFD_MAX14577)     += max14577.o
>>>>  obj-$(CONFIG_MFD_MAX77686)     += max77686.o
>>>>  obj-$(CONFIG_MFD_MAX77693)     += max77693.o
>>>> +obj-$(CONFIG_MFD_MAX77843)     += max77843.o
>>>>  obj-$(CONFIG_MFD_MAX8907)      += max8907.o
>>>>  max8925-objs                   := max8925-core.o max8925-i2c.o
>>>>  obj-$(CONFIG_MFD_MAX8925)      += max8925.o
>>>> diff --git a/drivers/mfd/max77843.c b/drivers/mfd/max77843.c
>>>> new file mode 100644
>>>> index 0000000..d7f8b76
>>>> --- /dev/null
>>>> +++ b/drivers/mfd/max77843.c
>>>> @@ -0,0 +1,241 @@
>>>> +/*
>>>> + * max77843.c - MFD core driver for the Maxim MAX77843
>>>> + *
>>>> + * Copyright (C) 2014 Samsung Electrnoics
>>>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License as published by
>>>> + * the Free Software Foundation; either version 2 of the License, or
>>>> + * (at your option) any later version.
>>>> + */
>>>> +
>>>> +#include <linux/err.h>
>>>> +#include <linux/i2c.h>
>>>> +#include <linux/init.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/mfd/core.h>
>>>> +#include <linux/mfd/max77843-private.h>
>>>> +#include <linux/of_device.h>
>>>> +#include <linux/platform_device.h>
>>>> +
>>>> +static const struct mfd_cell max77843_devs[] = {
>>>> +       {
>>>> +               .name = "max77843-muic",
>>>> +               .of_compatible = "maxim,max77843-muic",
>>>> +       }, {
>>>> +               .name = "max77843-regulator",
>>>> +               .of_compatible = "maxim,max77843-regulator",
>>>> +       }, {
>>>> +               .name = "max77843-charger",
>>>> +               .of_compatible = "maxim,max77843-charger"
>>>> +       }, {
>>>> +               .name = "max77843-fuelgauge",
>>>> +               .of_compatible = "maxim,max77843-fuelgauge",
>>>> +       },
>>>> +};
>>>> +
>>>> +static const struct regmap_config max77843_charger_regmap_config = {
>>>> +       .reg_bits       = 8,
>>>> +       .val_bits       = 8,
>>>> +       .max_register   = MAX77843_CHG_REG_END,
>>>> +};
>>>> +
>>>> +static const struct regmap_config max77843_regmap_config = {
>>>> +       .reg_bits       = 8,
>>>> +       .val_bits       = 8,
>>>> +       .max_register   = MAX77843_SYS_REG_END,
>>>> +};
>>>> +
>>>> +static const struct regmap_irq max77843_irqs[] = {
>>>> +       /* TOPSYS interrupts */
>>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSUVLO_INT, },
>>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSOVLO_INT, },
>>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TSHDN_INT, },
>>>> +       { .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TM_INT, },
>>>> +};
>>>> +
>>>> +static const struct regmap_irq_chip max77843_irq_chip = {
>>>> +       .name           = "max77843",
>>>> +       .status_base    = MAX77843_SYS_REG_SYSINTSRC,
>>>> +       .mask_base      = MAX77843_SYS_REG_SYSINTMASK,
>>>> +       .mask_invert    = false,
>>>> +       .num_regs       = 1,
>>>> +       .irqs           = max77843_irqs,
>>>> +       .num_irqs       = ARRAY_SIZE(max77843_irqs),
>>>> +};
>>>> +
>>>> +static int max77843_chg_init(struct max77843 *max77843)
>>>> +{
>>>
>>> Could this function be moved to the charger driver? This way the
>>> driver will manage its own resources instead of depending on parent
>>> MFD driver.
>>>
>>
>> Charger regulator and Charger share same resources.
>> So I include this function core driver.
> 
> OK, I see... Could you describe it in comments somewhere? For example in
> comment above the function. Currently this looks like only as regmap for
> charger.
> 

Charger regulator and Charger use same regmap.

> Unfortunately current solution imposes problem with releasing resources.
> Who is the owner of i2c dummy device?
> 

Core driver owner of i2c dummy device.

> 1. The charger driver will unregister it if max77843_charger_probe()
> fails. What will happen with regulator driver in such case?
> 

Charger is enabled/disabled by Charger regulator.
Currently, If charger probe fails, charger regulator failed to read regmap and occur panic(It have to fix.)


> 2. Who will release this i2c dummy device in normal unbind? Currently it
> leaks.
> 

I think core driver release i2c dummy device in normal unbind.
We need to more discussion about this problem.
If you have any idea, I hope tell me. Again, Thank you for your advice.

Thanks,
Beomho Seo


> Best regards,
> Krzysztof
> 
>>
>>>> +       int ret;
>>>> +
>>>> +       max77843->i2c_chg = i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_CHG);
>>>> +       if (!max77843->i2c_chg) {
>>>> +               dev_err(&max77843->i2c->dev,
>>>> +                               "Cannot allocate I2C device for Charger\n");
>>>> +               return PTR_ERR(max77843->i2c_chg);
>>>> +       }
>>>> +       i2c_set_clientdata(max77843->i2c_chg, max77843);
>>>> +
>>>> +       max77843->regmap_chg = devm_regmap_init_i2c(max77843->i2c_chg,
>>>> +                       &max77843_charger_regmap_config);
>>>> +       if (IS_ERR(max77843->regmap_chg)) {
>>>> +               ret = PTR_ERR(max77843->regmap_chg);
>>>> +               goto err_chg_i2c;
>>>> +       }
>>>> +
>>>> +       return 0;
>>>> +
>>>> +err_chg_i2c:
>>>> +       i2c_unregister_device(max77843->i2c_chg);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int max77843_probe(struct i2c_client *i2c,
>>>> +                                       const struct i2c_device_id *id)
>>>> +{
>>>> +       struct max77843 *max77843;
>>>> +       int ret;
>>>> +       unsigned int reg_data;
>>>> +
>>>> +       max77843 = devm_kzalloc(&i2c->dev, sizeof(*max77843), GFP_KERNEL);
>>>> +       if (!max77843)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       i2c_set_clientdata(i2c, max77843);
>>>> +       max77843->dev = &i2c->dev;
>>>> +       max77843->i2c = i2c;
>>>> +       max77843->irq = i2c->irq;
>>>> +
>>>> +       max77843->regmap = devm_regmap_init_i2c(i2c,
>>>> +                       &max77843_regmap_config);
>>>> +       if (IS_ERR(max77843->regmap)) {
>>>> +               dev_err(&i2c->dev, "Failed to allocate topsys register map\n");
>>>> +               return PTR_ERR(max77843->regmap);
>>>> +       }
>>>> +
>>>> +       ret = regmap_add_irq_chip(max77843->regmap, max77843->irq,
>>>> +                       IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
>>>> +                       0, &max77843_irq_chip, &max77843->irq_data);
>>>
>>> Why shared IRQ?
>>>
>>>> +       if (ret) {
>>>> +               dev_err(&i2c->dev, "Failed to add TOPSYS IRQ chip\n");
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       ret = regmap_read(max77843->regmap,
>>>> +                       MAX77843_SYS_REG_PMICID, &reg_data);
>>>> +       if (ret < 0) {
>>>> +               dev_err(&i2c->dev, "Failed to read PMIC ID\n");
>>>> +               goto err_pmic_id;
>>>> +       }
>>>> +       dev_info(&i2c->dev, "device ID: 0x%x\n", reg_data);
>>>> +
>>>> +       ret = max77843_chg_init(max77843);
>>>> +       if (ret) {
>>>> +               dev_err(&i2c->dev, "Failed to init Charger\n");
>>>> +               goto err_pmic_id;
>>>> +       }
>>>> +
>>>> +       ret = regmap_update_bits(max77843->regmap,
>>>> +                       MAX77843_SYS_REG_INTSRCMASK,
>>>> +                       MAX77843_INTSRC_MASK_MASK,
>>>> +                       (unsigned int)~MAX77843_INTSRC_MASK_MASK);
>>>> +       if (ret < 0) {
>>>> +               dev_err(&i2c->dev, "Failed to unmask interrupt sourece\n");
>>>
>>> s/sourece/source/
>>>
>>> Best regards,
>>> Krzysztof
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

