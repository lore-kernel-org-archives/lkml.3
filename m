Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbAYXot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:44:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbAYXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:44:46 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-9c-54c57fe2e122
Message-id: <54C57FE2.3070908@samsung.com>
Date: Mon, 26 Jan 2015 08:44:34 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Sebastian Reichel <sre@kernel.org>, Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/6] power: max77843_battery: Add Max77843 fuel gauge
 device driver
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-5-git-send-email-jaewon02.kim@samsung.com>
 <20150125135340.GC2719@earth.universe>
In-reply-to: <20150125135340.GC2719@earth.universe>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkSPdx/dEQg+bJjBZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo8Wk+xNYLHY0HGG1uP/1KKPF5V1z2Cw+9x5htFh6/SKTxYTpa1ks
	WvceYbc4vbvEgc9jzbw1jB6X+3qZPFYu/8LmsWlVJ5vHnWt72Dz6tqxi9Pi8SS6APYrLJiU1
	J7MstUjfLoEro2f3BbaCW0EVP36uYm1gbHbuYuTkkBAwkdh6YR4ThC0mceHeerYuRi4OIYGl
	jBLHzl9nhSk6cOE3C4gtJDCdUaLhfB2E/ZpR4spr7i5GDg5eAS2JeU9sQMIsAqoSM1ZOYAex
	2QQ0Jd5PuQLWKioQITH/2GtmEJtXQFDix+R7LCCtIgK+Eg2v6kHCzAJLmSU6p8iD2MICkRKT
	j19ngThnA6PEhdV3wXo5BYwlJr47xwzSyyygJ3H/ohZEr7zE5jVvmUHqJQQmckg0Ny1ngrhH
	QOLb5ENguyQEZCU2HWCG+EpS4uCKGywTGMVmIbloFsLUWUimLmBkXsUomlqQXFCclF5kolec
	mFtcmpeul5yfu4kRGMen/z2bsIPx3gHrQ4wCHIxKPLwdK4+ECLEmlhVX5h5iNAU6YiKzlGhy
	PjBZ5JXEGxqbGVmYmpgaG5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVHl
	l++BWaKXApUldxuFzH9kcvnq/Pa80HvHX197rzJNM8Xv+Jypi+67aC50nrbwh/NzUeMy9i8S
	5ybYxAjwO05eYrXeaNUvmcMrDh3W8f648noGu/31eqk+7QszszNjBe9lHzn4wTdogUas1cTM
	0CAOwbNtUy/3vK7M02j1q9D5MvnP8hss5y2VWIozEg21mIuKEwHI3zTK3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd1H9UdDDBZdN7aY+vAJm8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0m3Z/AYrGj4Qirxf2vRxktLu+aw2bxufcIo8XS6xeZLCZMX8ti
	0br3CLvF6d0lDnwea+atYfS43NfL5LFy+Rc2j02rOtk87lzbw+bRt2UVo8fnTXIB7FENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN6dl9gK7gVVPHj5yrWBsZm5y5GTg4J
	AROJAxd+s0DYYhIX7q1nA7GFBKYzSjScr4OwXzNKXHnN3cXIwcEroCUx74kNSJhFQFVixsoJ
	7CA2m4CmxPspV8DGiApESMw/9poZxOYVEJT4MfkeC0iriICvRMOrepAws8BSZonOKfIgtrBA
	pMTk49eBSriANm1glLiw+i5YL6eAscTEd+eYQXqZBfQk7l/UguiVl9i85i3zBEaBWUg2zEKo
	moWkagEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4CTxTHoH46oGi0OMAhyMSjy8HSuP
	hAixJpYVV+YeYpTgYFYS4Y2sOBoixJuSWFmVWpQfX1Sak1p8iNEU6P+JzFKiyfnABJZXEm9o
	bGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cCotoT9lty1/4yv8zM552bY
	365w4rTrTvjA/PSo7O5Czus/N7m42Wx+03FT8VmcTsT+E19uvfSemfHTqW6nQ2WvuXCyUHwS
	+5mLZnvEf1zY27Fk6jd3p6JD0r+Ppk09kqp1wFztbTZfwvelHv8mhzDIeuyVOfat+Lv51nvS
	jAt6uufNvJmgMJtLiaU4I9FQi7moOBEAb228+CgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your review.

I'll fix patch as your advice.

Thanks,
Beomho Seo

On 01/25/2015 10:53 PM, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Jan 23, 2015 at 02:02:45PM +0900, Jaewon Kim wrote:
>> From: Beomho Seo <beomho.seo@samsung.com>
>>
>> This patch adds device driver of max77843 fuel gauge.
>> The driver support for battery fuel gauge in Maxim Max77843.
>> It is fuel-gauge systems for lithuum-ion batteries in handled and
>> portable devices.
>>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> ---
>>  drivers/power/Kconfig            |    9 ++
>>  drivers/power/Makefile           |    1 +
>>  drivers/power/max77843_battery.c |  283 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 293 insertions(+)
>>  create mode 100644 drivers/power/max77843_battery.c
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index a054a28..0039bbb 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -212,6 +212,15 @@ config BATTERY_MAX17042
>>  	  with MAX17042. This driver also supports max17047/50 chips which are
>>  	  improved version of max17042.
>>  
>> +config BATTERY_MAX77843
>> +	tristate "Maxim MAX77843 Fuel Gauge"
>> +	depends on MFD_MAX77843
>> +	help
>> +	  This add support for battery fuel gauge in Maxim MAX77843.
> 
> add -> adds
> 
>> +	  It is fuel-gauge systems for lithuum-ion (Li+) batteries in handled and
>> +	  portable devices. The MAX17040 is configured to operate with a single
>> +	  lithium cell.
> 
> It is a fuel-gauge for a lithium-ion batteries with a single
> cell and can be found in portable devices.
> 
>> +
>>  config BATTERY_Z2
>>  	tristate "Z2 battery driver"
>>  	depends on I2C && MACH_ZIPIT2
>> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>> index 212c6a2..ae0d795 100644
>> --- a/drivers/power/Makefile
>> +++ b/drivers/power/Makefile
>> @@ -33,6 +33,7 @@ obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
>>  obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
>>  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
>>  obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
>> +obj-$(CONFIG_BATTERY_MAX77843)	+= max77843_battery.o
>>  obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
>>  obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
>>  obj-$(CONFIG_BATTERY_TWL4030_MADC)	+= twl4030_madc_battery.o
>> diff --git a/drivers/power/max77843_battery.c b/drivers/power/max77843_battery.c
>> new file mode 100644
>> index 0000000..a08dd0c
>> --- /dev/null
>> +++ b/drivers/power/max77843_battery.c
>> @@ -0,0 +1,283 @@
>> +/*
>> + * Fuel gauge driver for Maxim MAX77843
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
>> +#include <linux/platform_device.h>
>> +#include <linux/power_supply.h>
>> +#include <linux/mfd/max77843-private.h>
>> +
>> +struct max77843_battery {
>> +	struct device		*dev;
>> +	struct max77843		*max77843;
>> +	struct i2c_client	*client;
>> +	struct regmap		*regmap;
>> +	struct power_supply	psy;
>> +};
>> +
>> +static int max77843_battery_get_capacity(struct max77843_battery *battery)
>> +{
>> +	struct regmap *regmap = battery->regmap;
>> +	int ret, val;
>> +	u8 reg_data[2];
>> +
>> +	ret = regmap_bulk_read(regmap, MAX77843_FG_REG_SOCREP, reg_data, 2);
>> +	if (ret) {
>> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
>> +		return ret;
>> +	}
>> +
>> +	val =  ((reg_data[1] * 100) + (reg_data[0] * 100 / 256)) / 100;
> 
> so
> 
> val = reg_data[1]?
> 
>> +	return val;
>> +}
>> +
>> +static int max77843_battery_get_energy_prop(struct max77843_battery *battery,
>> +		enum power_supply_property psp)
>> +{
>> +	struct regmap *regmap = battery->regmap;
>> +	unsigned int reg;
>> +	int ret, val;
>> +	u8 reg_data[2];
>> +
>> +	switch (psp) {
>> +	case POWER_SUPPLY_PROP_ENERGY_FULL:
>> +		reg = MAX77843_FG_REG_FULLCAP;
>> +		break;
>> +	case POWER_SUPPLY_PROP_ENERGY_NOW:
>> +		reg = MAX77843_FG_REG_REMCAP_REP;
>> +		break;
>> +	case POWER_SUPPLY_PROP_ENERGY_AVG:
>> +		reg = MAX77843_FG_REG_REMCAP_AV;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
>> +	if (ret) {
>> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
>> +		return ret;
>> +	}
>> +
>> +	val = (reg_data[1] << 8) | reg_data[0];
>> +
>> +	return val;
>> +}
>> +
>> +static int max77843_battery_get_current_prop(struct max77843_battery *battery,
>> +		enum power_supply_property psp)
>> +{
>> +	struct regmap *regmap = battery->regmap;
>> +	unsigned int reg;
>> +	int ret, val;
>> +	u8 reg_data[2];
>> +
>> +	switch (psp) {
>> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +		reg = MAX77843_FG_REG_CURRENT;
>> +		break;
>> +	case POWER_SUPPLY_PROP_CURRENT_AVG:
>> +		reg = MAX77843_FG_REG_AVG_CURRENT;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
>> +	if (ret) {
>> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
>> +		return ret;
>> +	}
>> +
>> +	val = (reg_data[1] << 8) | reg_data[0];
>> +	if (val & 0x8000) {
>> +		/* Negative */
>> +		val = ~val & 0xffff;
>> +		val++;
>> +		val *= -1;
>> +	}
>> +	/* Unit of current is mA */
>> +	val =  val * 15625 / 100000;
>> +
>> +	return val;
>> +}
>> +
>> +static int max77843_battery_get_voltage_prop(struct max77843_battery *battery,
>> +		enum power_supply_property psp)
>> +{
>> +	struct regmap *regmap = battery->regmap;
>> +	unsigned int reg;
>> +	int ret, val;
>> +	u8 reg_data[2];
>> +
>> +	switch (psp) {
>> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> +		reg = MAX77843_FG_REG_VCELL;
>> +		break;
>> +	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
>> +		reg = MAX77843_FG_REG_AVG_VCELL;
>> +		break;
>> +	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
>> +		reg = MAX77843_FG_REG_OCV;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = regmap_bulk_read(regmap, reg, reg_data, 2);
>> +	if (ret) {
>> +		dev_err(battery->dev, "Failed to read fuelgauge register\n");
>> +		return ret;
>> +	}
>> +
>> +	val = ((reg_data[1] << 4) + (reg_data[0] >> 4)) * 125;
>> +	val /= 100;
>> +
>> +	return val;
>> +}
>> +
>> +static const char *model_name = "MAX77843";
>> +static const char *manufacturer = "Maxim Integrated";
>> +
>> +static int max77843_battery_get_property(struct power_supply *psy,
>> +		enum power_supply_property psp,
>> +		union power_supply_propval *val)
>> +{
>> +	struct max77843_battery *battery = container_of(psy,
>> +				struct max77843_battery, psy);
>> +	switch (psp) {
>> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> +	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
>> +	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
>> +		val->intval = max77843_battery_get_voltage_prop(battery, psp);
>> +		break;
>> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +	case POWER_SUPPLY_PROP_CURRENT_AVG:
>> +		val->intval = max77843_battery_get_current_prop(battery, psp);
>> +		break;
>> +	case POWER_SUPPLY_PROP_ENERGY_FULL:
>> +	case POWER_SUPPLY_PROP_ENERGY_NOW:
>> +	case POWER_SUPPLY_PROP_ENERGY_AVG:
>> +		val->intval = max77843_battery_get_energy_prop(battery, psp);
>> +		break;
>> +	case POWER_SUPPLY_PROP_CAPACITY:
>> +		val->intval = max77843_battery_get_capacity(battery);
>> +		break;
>> +	case POWER_SUPPLY_PROP_MODEL_NAME:
>> +		val->strval =  model_name;
>> +		break;
>> +	case POWER_SUPPLY_PROP_MANUFACTURER:
>> +		val->strval = manufacturer;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static enum power_supply_property max77843_battery_props[] = {
>> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>> +	POWER_SUPPLY_PROP_VOLTAGE_AVG,
>> +	POWER_SUPPLY_PROP_VOLTAGE_OCV,
>> +	POWER_SUPPLY_PROP_CURRENT_NOW,
>> +	POWER_SUPPLY_PROP_CURRENT_AVG,
>> +	POWER_SUPPLY_PROP_ENERGY_FULL,
>> +	POWER_SUPPLY_PROP_ENERGY_NOW,
>> +	POWER_SUPPLY_PROP_ENERGY_AVG,
>> +	POWER_SUPPLY_PROP_CAPACITY,
>> +	POWER_SUPPLY_PROP_MODEL_NAME,
>> +	POWER_SUPPLY_PROP_MANUFACTURER,
>> +};
>> +
>> +static const struct regmap_config max77843_fuel_regmap_config = {
>> +	.reg_bits	= 8,
>> +	.val_bits	= 8,
>> +	.max_register	= MAX77843_FG_END,
>> +};
> 
> You always read 2 bytes, so it seems the device uses 16 bit sized
> values?
> 
>> +static int max77843_battery_probe(struct platform_device *pdev)
>> +{
>> +	struct max77843 *max77843 = dev_get_drvdata(pdev->dev.parent);
>> +	struct max77843_battery *battery;
>> +	int ret;
>> +
>> +	battery = devm_kzalloc(&pdev->dev, sizeof(*battery), GFP_KERNEL);
>> +	if (!battery)
>> +		return -ENOMEM;
>> +
>> +	battery->dev = &pdev->dev;
>> +	battery->max77843 = max77843;
>> +
>> +	battery->client = i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_FG);
>> +	if (!battery->client) {
>> +		dev_err(&pdev->dev, "Failed to get dummy i2c client.\n");
>> +		return PTR_ERR(battery->client);
>> +	}
>> +	i2c_set_clientdata(battery->client, max77843);
>> +
>> +	battery->regmap = devm_regmap_init_i2c(battery->client,
>> +			&max77843_fuel_regmap_config);
>> +	if (IS_ERR(battery->regmap)) {
>> +		ret = PTR_ERR(battery->regmap);
>> +		goto err_i2c;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, battery);
>> +
>> +	battery->psy.name	= "max77843-fuelgauge";
>> +	battery->psy.type	= POWER_SUPPLY_TYPE_BATTERY;
>> +	battery->psy.get_property	= max77843_battery_get_property;
>> +	battery->psy.properties		= max77843_battery_props;
>> +	battery->psy.num_properties	= ARRAY_SIZE(max77843_battery_props);
>> +
>> +	ret = power_supply_register(&pdev->dev, &battery->psy);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed  to register power supply\n");
>> +		goto err_i2c;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_i2c:
>> +	i2c_unregister_device(battery->client);
> 
> This is missing in max77843_battery_remove()
> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77843_battery_remove(struct platform_device *pdev)
>> +{
>> +	struct max77843_battery *battery = platform_get_drvdata(pdev);
>> +
>> +	power_supply_unregister(&battery->psy);
>> +
>> +	return 0;
>> +}
> 
>> [...]
> 
> -- Sebastian
> 

