Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaLPBJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:09:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9226 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLPBJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:09:31 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b8-548f86450a76
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <548F8645.3070002@samsung.com>
Date: Tue, 16 Dec 2014 10:09:25 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v6 1/2] Input: add regulator haptic driver
References: <1418380349-32588-1-git-send-email-jaewon02.kim@samsung.com>
 <1418380349-32588-2-git-send-email-jaewon02.kim@samsung.com>
 <20141213195611.GE22702@dtor-ws>
In-reply-to: <20141213195611.GE22702@dtor-ws>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkRNe1rT/E4M82A4vrX56zWhxe9ILR
	4vOHFnaL3gVX2SxufvrGanF51xw2ixnn9zE5sHvsnHWX3aNvyypGj8+b5AKYo7hsUlJzMstS
	i/TtErgyJj1exVawtazizIldLA2MVxK6GDk5JARMJBoXbGaBsMUkLtxbz9bFyMUhJLCUUeLn
	v5PMMEXnls9ngkhMZ5Q4c7CVDSTBKyAo8WPyPbBuZgEziUct65ghbFGJXy9PQdnaEssWvmaG
	aH7NKNH3bw9Us5bE4Xk9YDaLgKrE6z9dYIPYgBq+r1/MCmKLCkRIfFj1FaxGREBfYvvsX4wg
	g5gFrjJKnPuzGiwhLGAnceboDLBtQgKrGCU2PI0CsTkFdCVmdO8G2ywhcIxd4lFzIyvENgGJ
	b5MPAW3jAErISmw6APWmpMTBFTdYJjCKz0Ly3Cwkz81C8twsJM8tYGRZxSiaWpBcUJyUXmSk
	V5yYW1yal66XnJ+7iREYl6f/PevbwXjzgPUhRgEORiUe3sDC/hAh1sSy4srcQ4ymQBdNZJYS
	Tc4HRn9eSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	HR9yZIJly6fYG/+VTfplvJLv/4oHLp32tgVHRDNdmbIOBN33resKcG7yZZX/azfjQMfyDJtj
	RZqRN8Q4tFUjF5zcf+NJxb4jW86cMtWRZl3b3hH22WKzq9y3i9GVuW83f1OYPr/0AyeD8L/b
	NQKFLtvCHn+fLe1rleRi3t16hLdzNmu34CclluKMREMt5qLiRAAO4MuBxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQV3Xtv4Qg7vLVC2uf3nOanF40QtG
	i88fWtgtehdcZbO4+ekbq8XlXXPYLGac38fkwO6xc9Zddo++LasYPT5vkgtgjmpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLi4/j1LQXNpxbS1u9gbGBfFdzFyckgImEic
	Wz6fCcIWk7hwbz1bFyMXh5DAdEaJMwdb2UASvAKCEj8m32PpYuTgYBaQlzhyKRskzCxgJvGo
	ZR0zRP1rRom+f3ug6rUkDs/rAbNZBFQlXv/pYgGx2QS0Jb6vX8wKYosKREh8WPUVrEZEQF9i
	++xfjCCDmAWuMkqc+7MaLCEsYCdx5ugMZhBbSGAVo8SGp1EgNqeArsSM7t3MExgFZiG5bxbC
	fbOQ3LeAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAEP5PewbiqweIQowAHoxIPb2Bh
	f4gQa2JZcWXuIUYJDmYlEd6kLKAQb0piZVVqUX58UWlOavEhRlOg7yYyS4km5wOTS15JvKGx
	iZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA2PZKqOUkjP/y/ZucDWbrGTe
	99vur/ivW15L+Itvrnt48LhHPE+ErtK+0lPvH9hu3MN7ky9RiNX785O+9zPYl51mm8qvO1e7
	6uj89Or9b359it8+4xcb/5+jdxeV5Id3LvjHttYgpUroDY92+NVn2S8NPq8KnzSBq3iylt92
	H+eWzhs8O6L4dq9XYinOSDTUYi4qTgQAMep3P/YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

2014년 12월 14일 04:56에 Dmitry Torokhov 이(가) 쓴 글:
> Hi Jaewon,
>
> On Fri, Dec 12, 2014 at 07:32:28PM +0900, Jaewon Kim wrote:
>> This patch adds support for haptic driver controlled by
>> voltage of regulator. And this driver support for
>> Force Feedback interface from input framework
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
>>   drivers/input/misc/Kconfig                         |   11 +
>>   drivers/input/misc/Makefile                        |    1 +
>>   drivers/input/misc/regulator-haptic.c              |  259 ++++++++++++++++++++
>>   include/linux/input/regulator-haptic.h             |   31 +++
>>   5 files changed, 323 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
>>   create mode 100644 drivers/input/misc/regulator-haptic.c
>>   create mode 100644 include/linux/input/regulator-haptic.h
>>
>> diff --git a/Documentation/devicetree/bindings/input/regulator-haptic.txt b/Documentation/devicetree/bindings/input/regulator-haptic.txt
>> new file mode 100644
>> index 0000000..3ed1c7e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
>> @@ -0,0 +1,21 @@
>> +* Regulator Haptic Device Tree Bindings
>> +
>> +Required Properties:
>> + - compatible : Should be "regulator-haptic"
>> + - haptic-supply : Power supply to the haptic motor.
>> +	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>> +
>> + - max-microvolt : The maximum voltage value supplied to the haptic motor.
>> +		[The unit of the voltage is a micro]
>> +
>> + - min-microvolt : The minimum voltage value supplied to the haptic motor.
>> +		[The unit of the voltage is a micro]
>> +
>> +Example:
>> +
>> +	haptics {
>> +		compatible = "regulator-haptic";
>> +		haptic-supply = <&motor_regulator>;
>> +		max-microvolt = <2700000>;
>> +		min-microvolt = <1100000>;
>> +	};
>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>> index 23297ab..e5e556d 100644
>> --- a/drivers/input/misc/Kconfig
>> +++ b/drivers/input/misc/Kconfig
>> @@ -394,6 +394,17 @@ config INPUT_CM109
>>   	  To compile this driver as a module, choose M here: the module will be
>>   	  called cm109.
>>   
>> +config INPUT_REGULATOR_HAPTIC
>> +	tristate "regulator haptics support"
>> +	select INPUT_FF_MEMLESS
>> +	help
>> +	  This option enables device driver support for the haptic controlled
>> +	  by regulator. This driver supports ff-memless interface
>> +	  from input framework.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called regulator-haptic.
>> +
>>   config INPUT_RETU_PWRBUTTON
>>   	tristate "Retu Power button Driver"
>>   	depends on MFD_RETU
>> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>> index 19c7603..1f135af 100644
>> --- a/drivers/input/misc/Makefile
>> +++ b/drivers/input/misc/Makefile
>> @@ -53,6 +53,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
>>   obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
>>   obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
>>   obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
>> +obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)	+= regulator-haptic.o
>>   obj-$(CONFIG_INPUT_RETU_PWRBUTTON)	+= retu-pwrbutton.o
>>   obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
>>   obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
>> diff --git a/drivers/input/misc/regulator-haptic.c b/drivers/input/misc/regulator-haptic.c
>> new file mode 100644
>> index 0000000..2fa94bc
>> --- /dev/null
>> +++ b/drivers/input/misc/regulator-haptic.c
>> @@ -0,0 +1,259 @@
>> +/*
>> + * Regulator haptic driver
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/input.h>
>> +#include <linux/input/regulator-haptic.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +
>> +#define MAX_MAGNITUDE_SHIFT	16
>> +
>> +struct regulator_haptic {
>> +	struct device *dev;
>> +	struct input_dev *input_dev;
>> +	struct regulator *regulator;
>> +
>> +	struct work_struct work;
>> +	struct mutex mutex;
>> +
>> +	bool enabled;
>> +	bool suspend_state;
>> +	unsigned int max_volt;
>> +	unsigned int min_volt;
>> +	unsigned int intensity;
>> +	unsigned int magnitude;
>> +};
>> +
>> +static void regulator_haptic_enable(struct regulator_haptic *haptic, bool state)
>> +{
>> +	int error;
>> +
>> +	if (haptic->enabled == state)
>> +		return;
>> +
>> +	if (state)
>> +		error = regulator_enable(haptic->regulator);
>> +	else
>> +		error = regulator_disable(haptic->regulator);
>> +	if (error) {
> Hmm, maybe:
>
> 	error = state ? regulator_enable(haptic->regulator) :
> 			regulator_disable(haptic->regulator);
> 	if (error)
> 		...
>
Okay, i will change it.
>> +		dev_err(haptic->dev, "cannot enable regulator\n");
>> +		return;
>> +	}
>> +
>> +	haptic->enabled = state;
>> +}
>> +
>> +static void regulator_haptic_work(struct work_struct *work)
>> +{
>> +	struct regulator_haptic *haptic = container_of(work,
>> +					struct regulator_haptic, work);
>> +	int error;
>> +
>> +	if (haptic->suspend_state)
>> +		return;
>> +
> Why is this check outside of mutex?
I will include this in next version.
>
>> +	mutex_lock(&haptic->mutex);
>> +
>> +	error = regulator_set_voltage(haptic->regulator,
>> +			haptic->intensity + haptic->min_volt, haptic->max_volt);
>> +	if (error) {
>> +		dev_err(haptic->dev, "cannot set regulator voltage\n");
>> +		goto err;
>> +	}
>> +
>> +	if (haptic->magnitude)
>> +		regulator_haptic_enable(haptic, true);
>> +	else
>> +		regulator_haptic_enable(haptic, false);
>> +
>> +err:
>> +	mutex_unlock(&haptic->mutex);
>> +}
>> +
>> +static int regulator_haptic_play_effect(struct input_dev *input, void *data,
>> +					struct ff_effect *effect)
>> +{
>> +	struct regulator_haptic *haptic = input_get_drvdata(input);
>> +	u64 volt_mag_multi;
>> +
>> +	haptic->magnitude = effect->u.rumble.strong_magnitude;
>> +	if (!haptic->magnitude)
>> +		haptic->magnitude = effect->u.rumble.weak_magnitude;
>> +
>> +
>> +	volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) *
>> +					haptic->magnitude;
>> +	haptic->intensity = (unsigned int)(volt_mag_multi >>
>> +					MAX_MAGNITUDE_SHIFT);
>> +
>> +	schedule_work(&haptic->work);
>> +
>> +	return 0;
>> +}
>> +
>> +static void regulator_haptic_close(struct input_dev *input)
>> +{
>> +	struct regulator_haptic *haptic = input_get_drvdata(input);
>> +
>> +	cancel_work_sync(&haptic->work);
>> +	regulator_haptic_enable(haptic, false);
>> +}
>> +
>> +#ifdef CONFIG_OF
>> +static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
>> +{
>> +	struct device_node *node = haptic->dev->of_node;
>> +	int error;
>> +
>> +	error = of_property_read_u32(node, "max-microvolt", &haptic->max_volt);
>> +	if (error) {
>> +		dev_err(haptic->dev, "cannot parse max-microvolt\n");
>> +		return error;
>> +	}
>> +
>> +	error = of_property_read_u32(node, "min-microvolt", &haptic->min_volt);
>> +	if (error) {
>> +		dev_err(haptic->dev, "cannot parse min-microvolt\n");
>> +		return error;
>> +	}
>> +
>> +	return 0;
>> +}
>> +#else
>> +static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
>> +{
>> +	return 0;
> This does not seem right. If you do not have platform data and CONFOG_OF
> is disabled you can't continue initialization.
>
>> +}
>> +#endif /* CONFIG_OF */
>> +
>> +static int regulator_haptic_probe(struct platform_device *pdev)
>> +{
>> +	struct regulator_haptic *haptic;
>> +	struct regulator_haptic_data *data = dev_get_platdata(&pdev->dev);
>> +	struct input_dev *input_dev;
>> +	int error;
>> +
>> +	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
>> +	if (!haptic)
>> +		return -ENOMEM;
>> +
>> +	haptic->dev = &pdev->dev;
>> +	haptic->enabled = false;
>> +	haptic->suspend_state = false;
>> +	mutex_init(&haptic->mutex);
>> +	INIT_WORK(&haptic->work, regulator_haptic_work);
>> +
>> +	if (!data) {
>> +		if (pdev->dev.of_node) {
> I'd rather we moved check for presence of of_node into
> regulator_haptic_parse_dt().

Okay. I will move it to haptic_parse_dt() and remove CONFIG_OF.
>
>
>> +			error = regulator_haptic_parse_dt(haptic);
>> +			if (error) {
>> +				dev_err(&pdev->dev, "failed to parse device tree\n");
>> +				return error;
>> +			}
>> +		} else {
>> +			dev_err(&pdev->dev, "failed to get platdata\n");
>> +			return -EINVAL;
>> +		}
>> +	} else {
>> +		haptic->regulator = data->regulator;
> What is the point of having regulator in platform data and doing
> assignment here if you are going to clobber it a few lines down?

You are right, this is unnecessary process.
I will remove it in next version.

>
>> +		haptic->max_volt = data->max_volt;
>> +		haptic->min_volt = data->min_volt;
>> +	}
>> +
>> +	haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, "haptic");
>> +	if (IS_ERR(haptic->regulator)) {
>> +		dev_err(&pdev->dev, "failed to get regulator\n");
>> +		return PTR_ERR(haptic->regulator);
>> +	}
>> +
>> +	input_dev = devm_input_allocate_device(&pdev->dev);
>> +	if (!input_dev)
>> +		return  -ENOMEM;
> Nit: extra space between return and error value.
>
>> +
>> +	haptic->input_dev = input_dev;
>> +	haptic->input_dev->name = "regulator-haptic";
>> +	haptic->input_dev->dev.parent = &pdev->dev;
>> +	haptic->input_dev->close = regulator_haptic_close;
>> +	input_set_drvdata(haptic->input_dev, haptic);
>> +	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
>> +
>> +	error = input_ff_create_memless(input_dev, NULL,
>> +			      regulator_haptic_play_effect);
>> +	if (error) {
>> +		dev_err(&pdev->dev, "failed to create force-feedback\n");
>> +		return error;
>> +	}
>> +
>> +	error = input_register_device(haptic->input_dev);
>> +	if (error) {
>> +		dev_err(&pdev->dev, "failed to register input device\n");
>> +		return error;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, haptic);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __maybe_unused regulator_haptic_suspend(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
>> +
>> +	mutex_lock(&haptic->mutex);
>> +	if (haptic->enabled) {
>> +		regulator_haptic_enable(haptic, false);
>> +		haptic->suspend_state = true;
> Why do we only set suspend_state if an effect was playing? I think we
> should always indicate that the device is suspended so that we do not
> try to start playing another effect - while it is true that normally
> effects are played by request from userspace which should be frozen by
> now, it is theoretically possible to trigger an effect from kernel as
> well.

This variable name seems to make you confuse.
I used this variable to restore the old state.

When kernel is entering suspend state while the motor is vibrating,
I store vibrating state for vibrate again after escape suspend state.


I will change variable name to "suspend_restore".
And prevent to start playing effect  when kernel entering suspend state.

>
>> +	}
>> +	mutex_unlock(&haptic->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __maybe_unused regulator_haptic_resume(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
>> +
>> +	if (haptic->suspend_state) {
> I think you should be gating enabling regulator not on suspend_state but
> rather non-zero magnitude. And also lock the mutex to make absolutely
> sure you are not racing with work item.
>
>> +		regulator_haptic_enable(haptic, true);
>> +		haptic->suspend_state = false;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static SIMPLE_DEV_PM_OPS(regulator_haptic_pm_ops,
>> +		regulator_haptic_suspend, regulator_haptic_resume);
>> +
>> +static struct of_device_id regulator_haptic_dt_match[] = {
>> +	{ .compatible = "regulator-haptic" },
>> +	{ /* sentinel */ },
>> +};
>> +
>> +static struct platform_driver regulator_haptic_driver = {
>> +	.probe		= regulator_haptic_probe,
>> +	.driver		= {
>> +		.name		= "regulator-haptic",
>> +		.of_match_table = regulator_haptic_dt_match,
>> +		.pm		= &regulator_haptic_pm_ops,
>> +	},
>> +};
>> +module_platform_driver(regulator_haptic_driver);
>> +
>> +MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
>> +MODULE_AUTHOR("Hyunhee Kim <hyunhee.kim@samsung.com>");
>> +MODULE_DESCRIPTION("Regulator haptic driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/input/regulator-haptic.h b/include/linux/input/regulator-haptic.h
>> new file mode 100644
>> index 0000000..05ae038
>> --- /dev/null
>> +++ b/include/linux/input/regulator-haptic.h
> Hmm, move it to include/linux/platform-data/ maybe?
Okay, i will move it.
>
>> @@ -0,0 +1,31 @@
>> +/*
>> + * Regulator Haptic Platform Data
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef _REGULATOR_HAPTIC_H
>> +#define _REGULATOR_HAPTIC_H
>> +
>> +/*
>> + * struct regulator_haptic_data - Platform device data
>> + *
>> + * @regulator: Power supply to the haptic motor
>> + * @max_volt: maximum voltage value supplied to the haptic motor.
>> + * 		<The unit of the voltage is a micro>
>> + * @min_volt: minimum voltage value supplied to the haptic motor.
>> + * 		<The unit of the voltage is a micro>
>> + */
>> +struct regulator_haptic_data {
>> +	struct regulator *regulator;
>> +	unsigned int max_volt;
>> +	unsigned int min_volt;
>> +};
>> +
>> +#endif /* _REGULATOR_HAPTIC_H */
>> -- 
>> 1.7.9.5
>>
> Thanks.
>

Thanks
Jaewon Kim
