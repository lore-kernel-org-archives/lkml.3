Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbbAWH2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:28:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbAWH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:28:23 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfee68d-f79296d000004278-95-54c1f8147617
Content-transfer-encoding: 8BIT
Message-id: <54C1F814.10400@samsung.com>
Date: Fri, 23 Jan 2015 16:28:20 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski.k@gmail.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 3/6] power: max77843_charger: Add Max77843 charger device
 driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-4-git-send-email-jaewon02.kim@samsung.com>
 <CAJKOXPcLjJ3LPWC3e9KqXFA90zr14WAGGmSsdxEiJ1-ctnzefQ@mail.gmail.com>
In-reply-to: <CAJKOXPcLjJ3LPWC3e9KqXFA90zr14WAGGmSsdxEiJ1-ctnzefQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkUFf0x8EQg55JTBZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo8Wk+xNYLHY0HGG1eP7vB7vF/a9HGS0u75rDZvG59wijxdLrF5ks
	Jkxfy2LRuvcIu8Xp3SUO/B5r5q1h9Ljc18vksXPWXXaPlcu/sHlsWtXJ5nHn2h42j74tqxg9
	Pm+SC+CI4rJJSc3JLEst0rdL4Mq4ff4YU8HdZYwVP3sXsTUw3ijqYuTkkBAwkTh34Tw7hC0m
	ceHeerYuRi4OIYGljBKrZi5mhCk6decsE0RiEaPE0R3PmUASvAKCEj8m32PpYuTgYBaQlzhy
	KRvCVJeYMiUXovw1UHnjbEaIcg2JhzP3gy1jEVCVuLxoPdgYNgFNifdTrrCA2KICERLzj71m
	BrFFBPIlfr6eAXYQs8BpZonVf86BNQsLhEl82LWJBWLDOUaJxoaJYBs4BYIlzi/qBUtICMzl
	kDhyYRUjxDoBiW+TD4FdKiEgK7HpADPEZ5ISB1fcYJnAKDYLyT+zEP6ZhfDPAkbmVYyiqQXJ
	BcVJ6UWGesWJucWleel6yfm5mxiBMX7637PeHYy3D1gfYhTgYFTi4W3YcjBEiDWxrLgy9xCj
	KdANE5mlRJPzgYkkryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxr79ricOVRscyli4eHX95co1nO8ri7lZza1m72TtT1zYq3Vxovf04J/H5S4vNfq3
	z5Xd+Chju4ofU1yYsbR1WO72O5/CCjdvS1u5yoGhI+nDxRxhq8MZZcGTlzZP4t2zrf5BWEK2
	dsyvmBeNnPvU1NfzRjAybbn6ZX3E/02hO7eE7rxw8s7nJiWW4oxEQy3mouJEAMn88ZfsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAV2RHwdDDM5fNLKY+vAJm8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0m3Z/AYrGj4QirxfN/P9gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj52z7rJ7rFz+hc1j06pONo871/awefRtWcXo
	8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5b
	Zg7Q9UoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjNvnjzEV3F3GWPGz
	dxFbA+ONoi5GTg4JAROJU3fOMkHYYhIX7q1n62Lk4hASWMQocXTHc7AEr4CgxI/J91i6GDk4
	mAXkJY5cyoYw1SWmTMmFKH8NVN44mxGiXEPi4cz97CA2i4CqxOVF68HGsAloSryfcoUFxBYV
	iJCYf+w1M4gtIpAv8fP1DLC9zAKnmSVW/zkH1iwsECbxYdcmFogN5xglGhsmgm3gFAiWOL+o
	l2UCo8AsJPfNQrhvFsJ9CxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5BnUjsYVzZY
	HGIU4GBU4uFt2HIwRIg1say4MvcQowQHs5IIb9wXoBBvSmJlVWpRfnxRaU5q8SFGU6DvJjJL
	iSbnA5NbXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QDY5qm4u0p
	uw+7G2TEntr+bsHGYFHRSdKTOrx6q1N79IJOzmfTiZqzLK3CJmGG7aZWXunY7bJNeq8bLU8/
	qP1Sx8i9ySBIt6bz5YJNXuEsn2f+sbiUEqP59mOPzlvhzQ+aDjuah9tyyTdOnn3w+AzV9XPq
	a9d9sv62+0Hhp0ghs0OHg7Xr+g0eK7EUZyQaajEXFScCAFCm/aQ2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

On 01/23/2015 04:04 PM, Krzysztof Kozłowski wrote:
> 2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
>> From: Beomho Seo <beomho.seo@samsung.com>
>>
>> This patch adds device driver of max77843 charger. This driver provide
>> initialize each charging mode(e.g. fast charge, top-off mode and constant
>> charging mode so on.). Additionally, control charging paramters to use
>> i2c interface.
>>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> ---
>>  drivers/power/Kconfig            |    7 +
>>  drivers/power/Makefile           |    1 +
>>  drivers/power/max77843_charger.c |  506 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 514 insertions(+)
>>  create mode 100644 drivers/power/max77843_charger.c
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index 0108c2a..a054a28 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -332,6 +332,13 @@ config CHARGER_MAX14577
>>           Say Y to enable support for the battery charger control sysfs and
>>           platform data of MAX14577/77836 MUICs.
>>
>> +config CHARGER_MAX77843
>> +       tristate "Maxim MAX77843 battery charger driver"
>> +       depends on MFD_MAX77843
>> +       help
>> +         Say Y to enable support for the battery charger control sysfs and
>> +         platform data of MAX77843
>> +
>>  config CHARGER_MAX8997
>>         tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
>>         depends on MFD_MAX8997 && REGULATOR_MAX8997
>> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>> index dfa8942..212c6a2 100644
>> --- a/drivers/power/Makefile
>> +++ b/drivers/power/Makefile
>> @@ -50,6 +50,7 @@ obj-$(CONFIG_CHARGER_LP8788)  += lp8788-charger.o
>>  obj-$(CONFIG_CHARGER_GPIO)     += gpio-charger.o
>>  obj-$(CONFIG_CHARGER_MANAGER)  += charger-manager.o
>>  obj-$(CONFIG_CHARGER_MAX14577) += max14577_charger.o
>> +obj-$(CONFIG_CHARGER_MAX77843) += max77843_charger.o
>>  obj-$(CONFIG_CHARGER_MAX8997)  += max8997_charger.o
>>  obj-$(CONFIG_CHARGER_MAX8998)  += max8998_charger.o
>>  obj-$(CONFIG_CHARGER_BQ2415X)  += bq2415x_charger.o
>> diff --git a/drivers/power/max77843_charger.c b/drivers/power/max77843_charger.c
>> new file mode 100644
>> index 0000000..317b2cc
>> --- /dev/null
>> +++ b/drivers/power/max77843_charger.c
>> @@ -0,0 +1,506 @@
>> +/*
>> + * Charger driver for Maxim MAX77843
>> + *
>> + * Copyright (C) 2014 Samsung Electronics, Co., Ltd.
>> + * Author: Beomho Seo <beomho.seo@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published bythe Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/power_supply.h>
>> +#include <linux/mfd/max77843-private.h>
>> +
>> +struct max77843_charger_info {
>> +       u32 fast_charge_uamp;
>> +       u32 top_off_uamp;
>> +       u32 input_uamp_limit;
>> +};
>> +
>> +struct max77843_charger {
>> +       struct device           *dev;
>> +       struct max77843         *max77843;
>> +       struct i2c_client       *client;
>> +       struct regmap           *regmap;
>> +       struct power_supply     psy;
>> +
>> +       struct max77843_charger_info    *info;
>> +};
> 
> Why creating two separate structures?
> 

max77843_charger_info structure just have property of charger.
If you want to merge one structure, I will revise above structure.

>> +
>> +static int max77843_charger_get_max_current(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = 0;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_CNFG_09, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       if (reg_data <= 0x03) {
>> +               val = MAX77843_CHG_INPUT_CURRENT_LIMIT_MIN;
>> +       } else if (reg_data >= 0x78) {
>> +               val = MAX77843_CHG_INPUT_CURRENT_LIMIT_MAX;
>> +       } else {
>> +               val = reg_data / 3;
>> +               if (reg_data % 3 == 0)
>> +                       val *= 100000;
>> +               else if (reg_data % 3 == 1)
>> +                       val = val * 100000 + 33000;
>> +               else
>> +                       val = val * 100000 + 67000;
>> +       }
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_charger_get_now_current(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = 0;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_CNFG_02, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
> 
> This error log shows up in many places. Please print also error code.
> 
> Additionally I think it could be useful to print also details about
> register which failed. Currently user would not know which register
> access failed. Consider adding short description like "Failed to read
> current charger register: %d...". However I do not insist on this so
> it is up to you.
> 

OK. I will fix error log.

>> +               return ret;
>> +       }
>> +
>> +       reg_data &= MAX77843_CHG_FAST_CHG_CURRENT_MASK;
>> +
>> +       if (reg_data <= 0x02)
>> +               val = MAX77843_CHG_FAST_CHG_CURRENT_MIN;
>> +       else if (reg_data >= 0x3f)
>> +               val = MAX77843_CHG_FAST_CHG_CURRENT_MAX;
>> +       else
>> +               val = reg_data * MAX77843_CHG_FAST_CHG_CURRENT_STEP;
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_charger_get_online(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = 0;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_INT_OK, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       if (reg_data & MAX77843_CHG_CHGIN_OK)
>> +               val = true;
>> +       else
>> +               val = false;
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_charger_get_present(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = 0;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_DTLS_00, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       if (reg_data & MAX77843_CHG_BAT_DTLS)
>> +               val = false;
>> +       else
>> +               val = true;
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_charger_get_health(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = POWER_SUPPLY_HEALTH_UNKNOWN;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_DTLS_01, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       reg_data &= MAX77843_CHG_BAT_DTLS_MASK;
>> +
>> +       switch (reg_data) {
>> +       case MAX77843_CHG_NO_BAT:
>> +               val = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
>> +               break;
>> +       case MAX77843_CHG_LOW_VOLT_BAT:
>> +       case MAX77843_CHG_OK_BAT:
>> +       case MAX77843_CHG_OK_LOW_VOLT_BAT:
>> +               val = POWER_SUPPLY_HEALTH_GOOD;
>> +               break;
>> +       case MAX77843_CHG_LONG_BAT_TIME:
>> +               val = POWER_SUPPLY_HEALTH_DEAD;
>> +               break;
>> +       case MAX77843_CHG_OVER_VOLT_BAT:
>> +       case MAX77843_CHG_OVER_CURRENT_BAT:
>> +               val = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
>> +               break;
>> +       default:
>> +               val = POWER_SUPPLY_HEALTH_UNKNOWN;
>> +               break;
>> +       }
>> +
>> +       return val;
>> +}
>> +
>> +static int max77843_charger_get_status(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret, val = 0;
>> +       unsigned int reg_data;
>> +
>> +       ret = regmap_read(regmap, MAX77843_CHG_REG_CHG_DTLS_01, &reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to read charger register\n");
>> +               return ret;
>> +       }
>> +
>> +       reg_data &= MAX77843_CHG_DTLS_MASK;
>> +
>> +       switch (reg_data) {
>> +       case MAX77843_CHG_PQ_MODE:
>> +       case MAX77843_CHG_CC_MODE:
>> +       case MAX77843_CHG_CV_MODE:
>> +               val = POWER_SUPPLY_STATUS_CHARGING;
>> +               break;
>> +       case MAX77843_CHG_TO_MODE:
>> +       case MAX77843_CHG_DO_MODE:
>> +               val = POWER_SUPPLY_STATUS_FULL;
>> +               break;
>> +       case MAX77843_CHG_HT_MODE:
>> +       case MAX77843_CHG_TF_MODE:
>> +       case MAX77843_CHG_TS_MODE:
>> +               val = POWER_SUPPLY_STATUS_NOT_CHARGING;
>> +               break;
>> +       case MAX77843_CHG_OFF_MODE:
>> +               val = POWER_SUPPLY_STATUS_DISCHARGING;
>> +               break;
>> +       default:
>> +               val = POWER_SUPPLY_STATUS_UNKNOWN;
>> +               break;
>> +       }
>> +
>> +       return val;
>> +}
>> +
>> +static const char *model_name = "MAX77843";
>> +static const char *manufacturer = "Maxim Integrated";
>> +
>> +static int max77843_charger_get_property(struct power_supply *psy,
>> +               enum power_supply_property psp,
>> +               union power_supply_propval *val)
>> +{
>> +       struct max77843_charger *charger = container_of(psy,
>> +                               struct max77843_charger, psy);
>> +
>> +       switch (psp) {
>> +       case POWER_SUPPLY_PROP_STATUS:
>> +               val->intval = max77843_charger_get_status(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_HEALTH:
>> +               val->intval = max77843_charger_get_health(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_PRESENT:
>> +               val->intval = max77843_charger_get_present(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_ONLINE:
>> +               val->intval = max77843_charger_get_online(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +               val->intval = max77843_charger_get_now_current(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_CURRENT_MAX:
>> +               val->intval = max77843_charger_get_max_current(charger);
>> +               break;
>> +       case POWER_SUPPLY_PROP_MODEL_NAME:
>> +               val->strval =  model_name;
>> +               break;
>> +       case POWER_SUPPLY_PROP_MANUFACTURER:
>> +               val->strval = manufacturer;
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static enum power_supply_property max77843_charger_props[] = {
>> +       POWER_SUPPLY_PROP_STATUS,
>> +       POWER_SUPPLY_PROP_HEALTH,
>> +       POWER_SUPPLY_PROP_PRESENT,
>> +       POWER_SUPPLY_PROP_ONLINE,
>> +       POWER_SUPPLY_PROP_CURRENT_NOW,
>> +       POWER_SUPPLY_PROP_CURRENT_MAX,
>> +       POWER_SUPPLY_PROP_MODEL_NAME,
>> +       POWER_SUPPLY_PROP_MANUFACTURER,
>> +};
>> +
>> +static int max77843_charger_init_current_limit(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       struct max77843_charger_info *info = charger->info;
>> +       unsigned int input_uamp_limit = info->input_uamp_limit;
>> +       int ret;
>> +       unsigned int reg_data, val;
>> +
>> +       ret = regmap_update_bits(regmap, MAX77843_CHG_REG_CHG_CNFG_02,
>> +                       MAX77843_CHG_OTG_ILIMIT_MASK,
>> +                       MAX77843_CHG_OTG_ILIMIT_900);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
> 
> Same as in case of "read" operation failures - please print also error code.
> 

OK.

>> +               return ret;
>> +       }
>> +
>> +       if (input_uamp_limit == MAX77843_CHG_INPUT_CURRENT_LIMIT_MIN) {
>> +               reg_data = 0x03;
>> +       } else if (input_uamp_limit == MAX77843_CHG_INPUT_CURRENT_LIMIT_MAX) {
>> +               reg_data = 0x78;
>> +       } else {
>> +               if (input_uamp_limit < MAX77843_CHG_INPUT_CURRENT_LIMIT_REF)
>> +                       val = 0x03;
>> +               else
>> +                       val = 0x02;
>> +
>> +               input_uamp_limit -= MAX77843_CHG_INPUT_CURRENT_LIMIT_MIN;
>> +               input_uamp_limit /= MAX77843_CHG_INPUT_CURRENT_LIMIT_STEP;
>> +               reg_data = val + input_uamp_limit;
>> +       }
>> +
>> +       ret = regmap_write(regmap, MAX77843_CHG_REG_CHG_CNFG_09, reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
>> +               return ret;
>> +       }
>> +
>> +       return 0;
> 
> Could you merge it into:
> 
>        ret = regmap_write(regmap, MAX77843_CHG_REG_CHG_CNFG_09, reg_data);
>        if (ret)
>               dev_err(charger->dev, "Failed to write configure register\n");
>        return ret;
> 
> 

I will merge it into.

>> +
>> +static int max77843_charger_init_top_off(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       struct max77843_charger_info *info = charger->info;
>> +       unsigned int top_off_uamp = info->top_off_uamp;
>> +       int ret;
>> +       unsigned int reg_data;
>> +
>> +       if (top_off_uamp == MAX77843_CHG_TOP_OFF_CURRENT_MIN) {
>> +               reg_data = 0x00;
>> +       } else if (top_off_uamp == MAX77843_CHG_TOP_OFF_CURRENT_MAX) {
>> +               reg_data = 0x07;
>> +       } else {
>> +               top_off_uamp -= MAX77843_CHG_TOP_OFF_CURRENT_MIN;
>> +               top_off_uamp /= MAX77843_CHG_TOP_OFF_CURRENT_STEP;
>> +               reg_data = top_off_uamp;
>> +       }
>> +
>> +       ret = regmap_update_bits(regmap, MAX77843_CHG_REG_CHG_CNFG_03,
>> +                       MAX77843_CHG_TOP_OFF_CURRENT_MASK, reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
>> +               return ret;
>> +       }
>> +
>> +       return 0;
> 
> Ditto
> 

Ditto

>> +}
>> +
>> +static int max77843_charger_init_fast_charge(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       struct max77843_charger_info *info = charger->info;
>> +       unsigned int fast_charge_uamp = info->fast_charge_uamp;
>> +       int ret;
>> +       unsigned int reg_data;
>> +
>> +       if (fast_charge_uamp < info->input_uamp_limit) {
>> +               reg_data = 0x09;
>> +       } else if (fast_charge_uamp == MAX77843_CHG_FAST_CHG_CURRENT_MIN) {
>> +               reg_data = 0x02;
>> +       } else if (fast_charge_uamp == MAX77843_CHG_FAST_CHG_CURRENT_MAX) {
>> +               reg_data = 0x3f;
>> +       } else {
>> +               fast_charge_uamp -= MAX77843_CHG_FAST_CHG_CURRENT_MIN;
>> +               fast_charge_uamp /= MAX77843_CHG_FAST_CHG_CURRENT_STEP;
>> +               reg_data = 0x02 + fast_charge_uamp;
>> +       }
>> +
>> +       ret = regmap_update_bits(regmap, MAX77843_CHG_REG_CHG_CNFG_02,
>> +                       MAX77843_CHG_FAST_CHG_CURRENT_MASK, reg_data);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
>> +               return ret;
>> +       }
>> +
>> +       return 0;
> 
> Ditto
> 
>> +}
>> +
>> +static int max77843_charger_init(struct max77843_charger *charger)
>> +{
>> +       struct regmap *regmap = charger->regmap;
>> +       int ret;
>> +
>> +       ret = regmap_write(regmap, MAX77843_CHG_REG_CHG_CNFG_06,
>> +                       MAX77843_CHG_WRITE_CAP_UNBLOCK);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = regmap_write(regmap, MAX77843_CHG_REG_CHG_CNFG_01,
>> +                       MAX77843_CHG_RESTART_THRESHOLD_DISABLE);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to write configure register\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = max77843_charger_init_fast_charge(charger);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to set fast charge mode.\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = max77843_charger_init_top_off(charger);
>> +       if (ret) {
>> +               dev_err(charger->dev, "Failed to set top off charge mode.\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = max77843_charger_init_current_limit(charger);
>> +
> 
> Why this return value is ignored?
> 

I will fix it.

>> +       return 0;
>> +}
>> +
>> +static struct max77843_charger_info *max77843_charger_dt_init(
>> +               struct platform_device *pdev)
>> +{
>> +       struct max77843_charger_info *info;
>> +       struct device_node *np = pdev->dev.of_node;
>> +       int ret;
>> +
>> +       if (!np) {
>> +               dev_err(&pdev->dev, "No charger OF node\n");
>> +               return ERR_PTR(-EINVAL);
>> +       }
>> +
>> +       info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>> +       if (!info)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       ret = of_property_read_u32(np, "maxim,fast-charge-uamp",
>> +                       &info->fast_charge_uamp);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Cannot parse fast charge current.\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +
>> +       ret = of_property_read_u32(np, "maxim,top-off-uamp",
>> +                       &info->top_off_uamp);
>> +       if (ret) {
>> +               dev_err(&pdev->dev,
>> +                       "Cannot parse primary charger termination voltage.\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +
>> +       ret = of_property_read_u32(np, "maxim,input-uamp-limit",
>> +                       &info->input_uamp_limit);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Cannot parse input current limit value\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +
>> +       return info;
>> +}
>> +
>> +static int max77843_charger_probe(struct platform_device *pdev)
>> +{
>> +       struct max77843 *max77843 = dev_get_drvdata(pdev->dev.parent);
>> +       struct max77843_charger *charger;
>> +       int ret;
>> +
>> +       charger = devm_kzalloc(&pdev->dev, sizeof(*charger), GFP_KERNEL);
>> +       if (!charger)
>> +               return -ENOMEM;
>> +
>> +       platform_set_drvdata(pdev, charger);
>> +       charger->dev = &pdev->dev;
>> +       charger->max77843 = max77843;
>> +       charger->client = max77843->i2c_chg;
>> +       charger->regmap = max77843->regmap_chg;
>> +
>> +       charger->info = max77843_charger_dt_init(pdev);
>> +       if (IS_ERR_OR_NULL(charger->info)) {
>> +               ret = PTR_ERR(charger->info);
>> +               goto err_i2c;
>> +       }
>> +
>> +       charger->psy.name       = "max77843-charger";
>> +       charger->psy.type       = POWER_SUPPLY_TYPE_MAINS;
>> +       charger->psy.get_property       = max77843_charger_get_property;
>> +       charger->psy.properties         = max77843_charger_props;
>> +       charger->psy.num_properties     = ARRAY_SIZE(max77843_charger_props);
>> +
>> +       ret = max77843_charger_init(charger);
>> +       if (ret)
>> +               goto err_i2c;
>> +
>> +       ret = power_supply_register(&pdev->dev, &charger->psy);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Failed  to register power supply\n");
>> +               goto err_i2c;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_i2c:
>> +       i2c_unregister_device(charger->client);
> 
> This seems complicated. The MFD registers the i2c dummy for charger...
> and sometimes charger driver unregisters it and sometimes not. The
> ownership should be in one place: probably in charger driver... but I
> asked about this in another thread so lets discuss it there.
> 

OK. I will revise after discuss it.

> Best regards,
> Krzysztof
> 

Thanks,
Beomho Seo
