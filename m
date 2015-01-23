Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbAWH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:26:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54894 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbAWH0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:26:41 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-da-54c1f7ae7415
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <54C1F7AE.6080805@samsung.com>
Date: Fri, 23 Jan 2015 16:26:38 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski.k@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH 5/6] regulator: max77843: Add max77843 regulator driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-6-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPdWTE6CQC57oV5vsz4TNK4H8==ehpd=3OOMYnJRW+ifWw@mail.gmail.com>
In-reply-to: <CAJKOXPdWTE6CQC57oV5vsz4TNK4H8==ehpd=3OOMYnJRW+ifWw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWHfd94MhBvPOG1uc/rSN3WLqwyds
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktJh0fwKLxfN/P9gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj52z7rJ7rFz+hc1j06pONo871/awefRtWcXo
	8XmTXABHFJdNSmpOZllqkb5dAlfGplfXWAtOB1Xc3/OFtYHxvlUXIyeHhICJxNt/m9kgbDGJ
	C/fWA9lcHEICSxklevccZOxi5AArWnvMD6RGSGARo8SDhVIgNq+AoMSPyfdYQGxmATOJLy8P
	s0LYohIPr6xjhLC1JZYtfM0MMfM1o8Tft3fYIJq1JKZves4OYrMIqErc2fKTCcRmA2r4vn4x
	2CBRgQiJ+cdAmjk5RATcJI69/gt2HLPAB2aJ/72HwBqEBbwlDk1vh7r6HKPEgvOtYBs4BYIl
	pp1ZC7ZaQmAlh8S7SROYIdYJSHybfIgF4jVZiU0HmCHel5Q4uOIGywRG8VlIvpuF5LtZSL6b
	heS7BYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzECk8Lpf88m7GC8d8D6EKMAB6MSD2/D
	loMhQqyJZcWVuYcYTYEumsgsJZqcD0w9eSXxhsZmRhamJqbGRuaWZkrivK+lfgYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYGT55KlcWsa7USb8RG25YsIpbdWdj3xYH35un9Pl7+u7OP4A
	r0TI0aQZmrvjPj8Uer3qTq2gGsd7zbn9W3lm56oLlslt8nuVY6qusfOn10Hb/5EeSscOfdIt
	Kt7DVz31Z92MHUWb/myo4zabMuWaEv+V+6vOaLcmx8kfOBb89ou+xqEqw4Uez5RYijMSDbWY
	i4oTAcUTX6QFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd113w+GGCx9p2Fx+tM2doupD5+w
	WVz/8pzVYv6Rc6wW/W8Wslqce7WS0WLS/QksFs///WC3uP/1KKPF5V1z2Cw+9x5htFh6/SKT
	xYTpa1ksWvceYbc4vbvEgd9jzbw1jB6X+3qZPHbOusvusXL5FzaPTas62TzuXNvD5tG3ZRWj
	x+dNcgEcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlA1ysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM74ducBa8Dug4uT7
	v2wNjP2WXYwcHBICJhJrj/l1MXICmWISF+6tZwOxhQQWMUo8WCgFYvMKCEr8mHyPBaScWUBe
	4silbJAws4CZxJeXh1m7GLmAyl8zSvx9e4cNol5LYvqm5+wgNouAqsSdLT+ZQGw2AW2J7+sX
	s4LYogIREvOPvWYGsUUE3CSOvf7LBjKIWeADs8T/3kNgDcIC3hKHprezQWw4xyix4Hwr2AZO
	gWCJaWfWMk9gFJiF5MBZCAfOQnLgAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB6eOZ
	1A7GlQ0WhxgFOBiVeHgbthwMEWJNLCuuzD3EKMHBrCTCG/cFKMSbklhZlVqUH19UmpNafIjR
	FOi9icxSosn5wNSWVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA
	eOTf2bWVGya/eB2u57f4Xj/zTd3zzSc97G014sN+PrR/t2QZ46clUkL7dl1RVTqYeF9iu/Ir
	X/O34rdbfkXfuCF/YVW55rrXS34dWbE0yfnc5sCPksfi9F4oi7PF72NkZFttFrjr/vuWqDeL
	Ln7NYq19X5B1zXWPoJbG85e1Ua2rv71e9GjbvBVKLMUZiYZazEXFiQBHe3owNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

2015년 01월 23일 16:18에 Krzysztof Kozłowski 이(가) 쓴 글:
> 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
>> This patch adds new regulator driver to support max77843
>> MFD(Multi Function Device) chip`s regulators.
>> The Max77843 has two voltage regulators for USB safeout.
>>
>> Cc: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> ---
>>   drivers/regulator/Kconfig    |    8 ++
>>   drivers/regulator/Makefile   |    1 +
>>   drivers/regulator/max77843.c |  259 ++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 268 insertions(+)
>>   create mode 100644 drivers/regulator/max77843.c
>>
>> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
>> index c3a60b5..c1f9c33 100644
>> --- a/drivers/regulator/Kconfig
>> +++ b/drivers/regulator/Kconfig
>> @@ -414,6 +414,14 @@ config REGULATOR_MAX77802
>>            Exynos5420/Exynos5800 SoCs to control various voltages.
>>            It includes support for control of voltage and ramp speed.
>>
>> +config REGULATOR_MAX77843
>> +       tristate "Maxim 77843 regulator"
>> +       depends on MFD_MAX77843
>> +       help
>> +         This driver controls a Maxim 77843 regulator.
>> +         The regulator include two 'SAFEOUT' for USB(Universal Serial Bus)
>> +         This is suitable for Exynos5433 SoC chips.
>> +
>>   config REGULATOR_MC13XXX_CORE
>>          tristate
>>
>> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
>> index 1f28ebf..12408d6 100644
>> --- a/drivers/regulator/Makefile
>> +++ b/drivers/regulator/Makefile
>> @@ -55,6 +55,7 @@ obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
>>   obj-$(CONFIG_REGULATOR_MAX77686) += max77686.o
>>   obj-$(CONFIG_REGULATOR_MAX77693) += max77693.o
>>   obj-$(CONFIG_REGULATOR_MAX77802) += max77802.o
>> +obj-$(CONFIG_REGULATOR_MAX77843) += max77843.o
>>   obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>>   obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
>>   obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
>> diff --git a/drivers/regulator/max77843.c b/drivers/regulator/max77843.c
>> new file mode 100644
>> index 0000000..86afc7a
>> --- /dev/null
>> +++ b/drivers/regulator/max77843.c
>> @@ -0,0 +1,259 @@
>> +/*
>> + * max77843.c - Regulator driver for the Maxim MAX77843
>> + *
>> + * Copyright (C) 2014 Samsung Electrnoics
>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regulator/driver.h>
>> +#include <linux/regulator/machine.h>
>> +#include <linux/mfd/max77843-private.h>
>> +#include <linux/regulator/of_regulator.h>
>> +
>> +#define MAX77843_SUPPORTED_VOLTAGE_NUM 4
>> +
>> +enum max77843_regulator_type {
>> +       MAX77843_SAFEOUT1 = 0,
>> +       MAX77843_SAFEOUT2,
>> +       MAX77843_CHARGER,
>> +
>> +       MAX77843_NUM,
>> +};
>> +
>> +static const unsigned int max77843_regulator_table[] = {
>> +       4850000,
>> +       4900000,
>> +       4950000,
>> +       3300000,
>> +};
>> +
>> +static int max77843_reg_is_enabled(struct regulator_dev *rdev)
>> +{
>> +       struct regmap *regmap = rdev->regmap;
>> +       int ret;
>> +       unsigned int reg;
>> +
>> +       ret = regmap_read(regmap, rdev->desc->enable_reg, &reg);
>> +       if (ret) {
>> +               dev_err(&rdev->dev, "Fialed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       return (reg & rdev->desc->enable_mask) == rdev->desc->enable_mask;
>> +}
>> +
>> +static int max77843_reg_get_current_limit(struct regulator_dev *rdev)
>> +{
>> +       struct regmap *regmap = rdev->regmap;
>> +       unsigned int chg_min_uA = rdev->constraints->min_uA;
>> +       unsigned int chg_max_uA = rdev->constraints->max_uA;
>> +       unsigned int val;
>> +       int ret;
>> +       unsigned int reg, sel;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_CNFG_02, &reg);
>> +       if (ret) {
>> +               dev_err(&rdev->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       sel = reg & MAX77843_CHG_FAST_CHG_CURRENT_MASK;
>> +
>> +       if (sel < 0x03)
>> +               sel = 0;
>> +       else
>> +               sel -= 2;
>> +
>> +       val = chg_min_uA + MAX77843_CHG_FAST_CHG_CURRENT_STEP * sel;
>> +       if (val > chg_max_uA)
>> +               return -EINVAL;
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_reg_set_current_limit(struct regulator_dev *rdev,
>> +               int min_uA, int max_uA)
>> +{
>> +       struct regmap *regmap = rdev->regmap;
>> +       unsigned int chg_min_uA = rdev->constraints->min_uA;
>> +       int sel = 0;
>> +
>> +       while (chg_min_uA + MAX77843_CHG_FAST_CHG_CURRENT_STEP * sel < min_uA)
>> +               sel++;
>> +
>> +       if (chg_min_uA + MAX77843_CHG_FAST_CHG_CURRENT_STEP * sel > max_uA)
>> +               return -EINVAL;
>> +
>> +       sel += 2;
>> +
>> +       return regmap_write(regmap, MAX77843_CHG_REG_CHG_CNFG_02, sel);
>> +}
>> +
>> +static struct regulator_ops max77843_charger_ops = {
>> +       .is_enabled             = max77843_reg_is_enabled,
>> +       .enable                 = regulator_enable_regmap,
>> +       .disable                = regulator_disable_regmap,
>> +       .get_current_limit      = max77843_reg_get_current_limit,
>> +       .set_current_limit      = max77843_reg_set_current_limit,
>> +};
>> +
>> +static struct regulator_ops max77843_regulator_ops = {
>> +       .is_enabled             = regulator_is_enabled_regmap,
>> +       .enable                 = regulator_enable_regmap,
>> +       .disable                = regulator_disable_regmap,
>> +       .list_voltage           = regulator_list_voltage_table,
>> +       .get_voltage_sel        = regulator_get_voltage_sel_regmap,
>> +       .set_voltage_sel        = regulator_set_voltage_sel_regmap,
>> +};
>> +
>> +static const struct regulator_desc max77843_supported_regulators[] = {
>> +       [MAX77843_SAFEOUT1] = {
>> +               .name           = "SAFEOUT1",
>> +               .id             = MAX77843_SAFEOUT1,
>> +               .ops            = &max77843_regulator_ops,
>> +               .type           = REGULATOR_VOLTAGE,
>> +               .owner          = THIS_MODULE,
>> +               .n_voltages     = MAX77843_SUPPORTED_VOLTAGE_NUM,
>> +               .volt_table     = max77843_regulator_table,
>> +               .enable_reg     = MAX77843_SYS_REG_SAFEOUTCTRL,
>> +               .enable_mask    = MAX77843_REG_SAFEOUTCTRL_ENSAFEOUT1,
>> +               .vsel_reg       = MAX77843_SYS_REG_SAFEOUTCTRL,
>> +               .vsel_mask      = MAX77843_REG_SAFEOUTCTRL_SAFEOUT1_MASK,
>> +       },
>> +       [MAX77843_SAFEOUT2] = {
>> +               .name           = "SAFEOUT2",
>> +               .id             = MAX77843_SAFEOUT2,
>> +               .ops            = &max77843_regulator_ops,
>> +               .type           = REGULATOR_VOLTAGE,
>> +               .owner          = THIS_MODULE,
>> +               .n_voltages     = MAX77843_SUPPORTED_VOLTAGE_NUM,
>> +               .volt_table     = max77843_regulator_table,
>> +               .enable_reg     = MAX77843_SYS_REG_SAFEOUTCTRL,
>> +               .enable_mask    = MAX77843_REG_SAFEOUTCTRL_ENSAFEOUT2,
>> +               .vsel_reg       = MAX77843_SYS_REG_SAFEOUTCTRL,
>> +               .vsel_mask      = MAX77843_REG_SAFEOUTCTRL_SAFEOUT2_MASK,
>> +       },
>> +       [MAX77843_CHARGER] = {
>> +               .name           = "CHARGER",
>> +               .id             = MAX77843_CHARGER,
>> +               .ops            = &max77843_charger_ops,
>> +               .type           = REGULATOR_CURRENT,
>> +               .owner          = THIS_MODULE,
>> +               .enable_reg     = MAX77843_CHG_REG_CHG_CNFG_00,
>> +               .enable_mask    = MAX77843_CHG_MASK,
>> +       },
>> +};
>> +
>> +static struct of_regulator_match max77843_regulator_matches[] = {
>> +       { .name = "SAFEOUT1", },
>> +       { .name = "SAFEOUT2", },
>> +       { .name = "CHARGER", },
>> +};
>> +
>> +static struct regmap *max77843_get_regmap(struct max77843 *max77843, int reg_id)
>> +{
>> +       switch (reg_id) {
>> +       case MAX77843_SAFEOUT1:
>> +       case MAX77843_SAFEOUT2:
>> +               return max77843->regmap;
>> +       case MAX77843_CHARGER:
>> +               return max77843->regmap_chg;
>> +       default:
>> +               return max77843->regmap;
>> +       }
>> +}
>> +
>> +static int max77843_regulator_dt_parse(struct platform_device *pdev)
>> +{
>> +       struct device_node *np;
>> +       int ret;
>> +
>> +       np = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
>> +       if (!np) {
>> +               dev_err(&pdev->dev,
>> +                       "Cannot get child OF node for regulators\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = of_regulator_match(&pdev->dev, np, max77843_regulator_matches,
>> +                       ARRAY_SIZE(max77843_regulator_matches));
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Cannot parsing regulator init data\n");
>> +               return ret;
>> +       }
>> +
>> +       of_node_put(np);
>> +
>> +       return 0;
> Use simplified DT parsing method (of_match and regulators_node from
> regulators_desc). This function could be removed then.

Thanks to advice.
I will use more simplified method in next version.
>
> Best regards,
> Krzysztof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks,
Jaewon Kim
