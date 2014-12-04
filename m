Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaLDBnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:43:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39451 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaLDBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:43:17 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
X-AuditID: cbfee68d-f79296d000004278-15-547fbc3322b5
Content-transfer-encoding: 8BIT
Message-id: <547FBC32.9050202@samsung.com>
Date: Thu, 04 Dec 2014 10:43:14 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v4 1/2] Input: add regulator haptic driver
References: <1417399873-19575-1-git-send-email-jaewon02.kim@samsung.com>
 <1417399873-19575-2-git-send-email-jaewon02.kim@samsung.com>
 <20141203060247.GE7411@dtor-glaptop> <547EADAD.9060100@samsung.com>
In-reply-to: <547EADAD.9060100@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkSNd4T32Iwby3shaHF71gtPj8oYXd
	onfBVTaLm5++sVpc3jWHzWLG+X1MDmweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
	jMNvf7AUvC2smHn4NWMD45SILkZODgkBE4k9ky+zQNhiEhfurWcDsYUEljJKPPyRAlOze+Fi
	oDgXUHwRo8T6maeYQBK8AoISPybfA2rm4GAWkJc4cikbJMwsYCbx5eVhVoj614wSpzpms0PU
	a0n8mf+MDaSeRUBV4tf5MJAwm4C2xPf1i1lBbFGBCIkra+YwgtgiAvoS22f/YgSZwyywnlGi
	4dlVsDnCAnYSt788hVpwllHiyIYJYB9wAk16tfwGE0hCQmAfu8Tzgx/B3mEREJD4NvkQ2KUS
	ArISmw4wQ3wmKXFwxQ2WCYxis5D8Mwvhn1lI/lnAyLyKUTS1ILmgOCm9yFCvODG3uDQvXS85
	P3cTIzCuTv971ruD8fYB60OMAhyMSjy8BbvrQ4RYE8uKK3MPMZoCHTGRWUo0OR8YvXkl8YbG
	ZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDmre1J/J6uertd
	eLpfVvODd5GHb2zLC9Hc0nPwkoRarVRHSLfvToc71w++sf3C+GjPqyUdDa9ZS/17qyr6VSMZ
	/C0mdD6/UrTjhe9UR7Nn2/sniZx0OMn1iSepjHduTuq0ZrPZn6/qC4RsMHGd+XXehMQjbJe6
	qqeenbbo+Ic5FpPqBI9XFlYrsRRnJBpqMRcVJwIAOQlFvaYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAV3jPfUhBpcuC1kcXvSC0eLzhxZ2
	i94FV9ksbn76xmpxedccNosZ5/cxObB57Jx1l92jb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMOv/3BUvC2sGLm4deMDYxTIroYOTkkBEwkdi9czAZh
	i0lcuLceyObiEBJYxCixfuYpJpAEr4CgxI/J91i6GDk4mAXkJY5cygYJMwuYSXx5eZgVov41
	o8SpjtnsEPVaEn/mP2MDqWcRUJX4dT4MJMwmoC3xff1iVhBbVCBC4sqaOYwgtoiAvsT22b8Y
	QeYwC6xnlGh4dhVsjrCAncTtL0+hFpxllDiyYQILSIITaNKr5TeYJjAKzEJy3yyE+2YhuW8B
	I/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4fSa1g3Flg8UhRgEORiUe3oLd9SFCrIll
	xZW5hxglOJiVRHhzeoFCvCmJlVWpRfnxRaU5qcWHGE2BvpvILCWanA9MKXkl8YbGJmZGlkbm
	hhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBKNTCunq1ws1vat/PVku/14mc7m6VqdF9V
	yvyadHdB3kGrxFrdVfr+pX6Zj3mP6M+Z2sBg2H5/KY/tkb4Pk4U9+E4+Ca96tahzA9uLiYm7
	yy5ask4vPN/Pw6Ty5HLevZhgi1/69j7x+RxeM6csSlQ5VXu+bI/at9dvLpodS2Z6vaVo7vJL
	l9f0T9+oxFKckWioxVxUnAgAfIq98vECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmity,

2014년 12월 03일 15:29에 Jaewon Kim 이(가) 쓴 글:
> Hi Dmitry,
>
> 2014년 12월 03일 15:02에 Dmitry Torokhov 이(가) 쓴 글:
>> Hi Jaewon,
>>
>> On Mon, Dec 01, 2014 at 11:11:12AM +0900, Jaewon Kim wrote:
>>> This patch adds support for haptic driver controlled by
>>> voltage of regulator. And this driver support for
>>> Force Feedback interface from input framework
>>>
>>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>>> ---
>>>   .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
>>>   drivers/input/misc/Kconfig                         |   11 +
>>>   drivers/input/misc/Makefile                        |    1 +
>>>   drivers/input/misc/regulator-haptic.c              |  247 
>>> ++++++++++++++++++++
>>>   include/linux/input/regulator-haptic.h             |   31 +++
>>>   5 files changed, 311 insertions(+)
>>>   create mode 100644 
>>> Documentation/devicetree/bindings/input/regulator-haptic.txt
>>>   create mode 100644 drivers/input/misc/regulator-haptic.c
>>>   create mode 100644 include/linux/input/regulator-haptic.h
>>>
>>> diff --git 
>>> a/Documentation/devicetree/bindings/input/regulator-haptic.txt 
>>> b/Documentation/devicetree/bindings/input/regulator-haptic.txt
>>> new file mode 100644
>>> index 0000000..3ed1c7e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
>>> @@ -0,0 +1,21 @@
>>> +* Regulator Haptic Device Tree Bindings
>>> +
>>> +Required Properties:
>>> + - compatible : Should be "regulator-haptic"
>>> + - haptic-supply : Power supply to the haptic motor.
>>> +    [*] refer 
>>> Documentation/devicetree/bindings/regulator/regulator.txt
>>> +
>>> + - max-microvolt : The maximum voltage value supplied to the haptic 
>>> motor.
>>> +        [The unit of the voltage is a micro]
>>> +
>>> + - min-microvolt : The minimum voltage value supplied to the haptic 
>>> motor.
>>> +        [The unit of the voltage is a micro]
>>> +
>>> +Example:
>>> +
>>> +    haptics {
>>> +        compatible = "regulator-haptic";
>>> +        haptic-supply = <&motor_regulator>;
>>> +        max-microvolt = <2700000>;
>>> +        min-microvolt = <1100000>;
>>> +    };
>>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>>> index 23297ab..e5e556d 100644
>>> --- a/drivers/input/misc/Kconfig
>>> +++ b/drivers/input/misc/Kconfig
>>> @@ -394,6 +394,17 @@ config INPUT_CM109
>>>         To compile this driver as a module, choose M here: the 
>>> module will be
>>>         called cm109.
>>>   +config INPUT_REGULATOR_HAPTIC
>>> +    tristate "regulator haptics support"
>>> +    select INPUT_FF_MEMLESS
>>> +    help
>>> +      This option enables device driver support for the haptic 
>>> controlled
>>> +      by regulator. This driver supports ff-memless interface
>>> +      from input framework.
>>> +
>>> +      To compile this driver as a module, choose M here: the
>>> +      module will be called regulator-haptic.
>>> +
>>>   config INPUT_RETU_PWRBUTTON
>>>       tristate "Retu Power button Driver"
>>>       depends on MFD_RETU
>>> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>>> index 19c7603..1f135af 100644
>>> --- a/drivers/input/misc/Makefile
>>> +++ b/drivers/input/misc/Makefile
>>> @@ -53,6 +53,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)    += 
>>> pmic8xxx-pwrkey.o
>>>   obj-$(CONFIG_INPUT_POWERMATE)        += powermate.o
>>>   obj-$(CONFIG_INPUT_PWM_BEEPER)        += pwm-beeper.o
>>>   obj-$(CONFIG_INPUT_RB532_BUTTON)    += rb532_button.o
>>> +obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)    += regulator-haptic.o
>>>   obj-$(CONFIG_INPUT_RETU_PWRBUTTON)    += retu-pwrbutton.o
>>>   obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)    += rotary_encoder.o
>>>   obj-$(CONFIG_INPUT_SGI_BTNS)        += sgi_btns.o
>>> diff --git a/drivers/input/misc/regulator-haptic.c 
>>> b/drivers/input/misc/regulator-haptic.c
>>> new file mode 100644
>>> index 0000000..6bc8e45
>>> --- /dev/null
>>> +++ b/drivers/input/misc/regulator-haptic.c
>>> @@ -0,0 +1,247 @@
>>> +/*
>>> + * Regulator haptic driver
>>> + *
>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>>> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or 
>>> modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <linux/input.h>
>>> +#include <linux/input/regulator-haptic.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/regulator/consumer.h>
>>> +#include <linux/slab.h>
>>> +
>>> +#define MAX_MAGNITUDE_SHIFT    16
>>> +
>>> +struct regulator_haptic {
>>> +    struct device *dev;
>>> +    struct input_dev *input_dev;
>>> +    struct regulator *regulator;
>>> +    struct work_struct work;
>>> +
>>> +    bool enabled;
>>> +    bool suspend_state;
>>> +    unsigned int max_volt;
>>> +    unsigned int min_volt;
>>> +    unsigned int intensity;
>>> +    unsigned int magnitude;
>>> +};
>>> +
>>> +static void regulator_haptic_enable(struct regulator_haptic 
>>> *haptic, bool state)
>>> +{
>>> +    int error;
>>> +
>>> +    if (haptic->enabled == state)
>>> +        return;
>>> +
>>> +    if (state)
>>> +        error = regulator_enable(haptic->regulator);
>>> +    else
>>> +        error = regulator_disable(haptic->regulator);
>>> +    if (error) {
>>> +        dev_err(haptic->dev, "cannot enable regulator\n");
>>> +        return;
>>> +    }
>>> +
>>> +    haptic->enabled = state;
>>> +}
>>> +
>>> +static void regulator_haptic_work(struct work_struct *work)
>>> +{
>>> +    struct regulator_haptic *haptic = container_of(work,
>>> +                    struct regulator_haptic, work);
>>> +    int error;
>>> +
>>> +    error = regulator_set_voltage(haptic->regulator,
>>> +            haptic->intensity + haptic->min_volt, haptic->max_volt);
>>> +    if (error) {
>>> +        dev_err(haptic->dev, "cannot set regulator voltage\n");
>>> +        return;
>>> +    }
>>> +
>>> +    if (haptic->magnitude)
>>> +        regulator_haptic_enable(haptic, true);
>>> +    else
>>> +        regulator_haptic_enable(haptic, false);
>>> +}
>>> +
>>> +static int regulator_haptic_play_effect(struct input_dev *input, 
>>> void *data,
>>> +                    struct ff_effect *effect)
>>> +{
>>> +    struct regulator_haptic *haptic = input_get_drvdata(input);
>>> +    u64 volt_mag_multi;
>>> +
>>> +    haptic->magnitude = effect->u.rumble.strong_magnitude;
>>> +    if (!haptic->magnitude)
>>> +        haptic->magnitude = effect->u.rumble.weak_magnitude;
>>> +
>>> +
>>> +    volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) *
>>> +                    haptic->magnitude;
>>> +    haptic->intensity = (unsigned int)(volt_mag_multi >>
>>> +                    MAX_MAGNITUDE_SHIFT);
>>> +
>>> +    schedule_work(&haptic->work);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void regulator_haptic_close(struct input_dev *input)
>>> +{
>>> +    struct regulator_haptic *haptic = input_get_drvdata(input);
>>> +
>>> +    cancel_work_sync(&haptic->work);
>>> +    regulator_haptic_enable(haptic, false);
>>> +}
>>> +
>>> +#ifdef CONFIG_OF
>>> +static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
>>> +{
>>> +    struct device_node *node = haptic->dev->of_node;
>>> +    int error;
>>> +
>>> +    error = of_property_read_u32(node, "max-microvolt", 
>>> &haptic->max_volt);
>>> +    if (error) {
>>> +        dev_err(haptic->dev, "cannot parse max-microvolt\n");
>>> +        return error;
>>> +    }
>>> +
>>> +    error = of_property_read_u32(node, "min-microvolt", 
>>> &haptic->min_volt);
>>> +    if (error) {
>>> +        dev_err(haptic->dev, "cannot parse min-microvolt\n");
>>> +        return error;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +#else
>>> +static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
>>> +{
>>> +    return 0;
>>> +}
>>> +#endif /* CONFIG_OF */
>>> +
>>> +static int regulator_haptic_probe(struct platform_device *pdev)
>>> +{
>>> +    struct regulator_haptic *haptic;
>>> +    struct regulator_haptic_data *data;
>>> +    struct input_dev *input_dev;
>>> +    int error;
>>> +
>>> +    haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
>>> +    if (!haptic)
>>> +        return -ENOMEM;
>>> +
>>> +    haptic->dev = &pdev->dev;
>>> +    haptic->enabled = false;
>>> +    haptic->suspend_state = false;
>>> +    INIT_WORK(&haptic->work, regulator_haptic_work);
>>> +
>>> +    if (pdev->dev.of_node) {
>>> +        error = regulator_haptic_parse_dt(haptic);
>>> +        if (error) {
>>> +            dev_err(&pdev->dev, "failed to parse device tree\n");
>>> +            return error;
>>> +        }
>>> +    } else {
>>> +        data = dev_get_platdata(&pdev->dev);
>>> +        if (data) {
>>> +            dev_err(&pdev->dev, "failed to get platdata\n");
>>> +            return -EINVAL;
>>> +        }
>>> +
>>> +        haptic->regulator = data->regulator;
>>> +        haptic->max_volt = data->max_volt;
>>> +        haptic->min_volt = data->min_volt;
>> Please give preference to platform data if supplied, and if not then try
>> fetching settings from device tree.
>
> Ok. i will give prefrence to platform data in next version.
>
>>
>>> +    }
>>> +
>>> +    haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, 
>>> "haptic");
>>> +    if (IS_ERR(haptic->regulator)) {
>>> +        dev_err(&pdev->dev, "failed to get regulator\n");
>>> +        return PTR_ERR(haptic->regulator);
>>> +    }
>>> +
>>> +    input_dev = devm_input_allocate_device(&pdev->dev);
>>> +    if (!input_dev)
>>> +        return  -ENOMEM;
>>> +
>>> +    haptic->input_dev = input_dev;
>>> +    haptic->input_dev->name = "regulator-haptic";
>>> +    haptic->input_dev->dev.parent = &pdev->dev;
>>> +    haptic->input_dev->close = regulator_haptic_close;
>>> +    input_set_drvdata(haptic->input_dev, haptic);
>>> +    input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
>>> +
>>> +    error = input_ff_create_memless(input_dev, NULL,
>>> +                  regulator_haptic_play_effect);
>>> +    if (error) {
>>> +        dev_err(&pdev->dev, "failed to create force-feedback\n");
>>> +        return error;
>>> +    }
>>> +
>>> +    error = input_register_device(haptic->input_dev);
>>> +    if (error) {
>>> +        dev_err(&pdev->dev, "failed to register input device\n");
>>> +        return error;
>>> +    }
>>> +
>>> +    platform_set_drvdata(pdev, haptic);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int __maybe_unused regulator_haptic_suspend(struct device *dev)
>>> +{
>>> +    struct platform_device *pdev = to_platform_device(dev);
>>> +    struct regulator_haptic *haptic = platform_get_drvdata(pdev);
>>> +
>>> +    if (haptic->enabled) {
>> You need to protect this code from racing with the work item.

I saw this review now but i sent v5. It did not reflect in v5.
I will send soon and modifies in v6.

>>
>>> +        regulator_haptic_enable(haptic, false);
>>> +        haptic->suspend_state = true;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int __maybe_unused regulator_haptic_resume(struct device *dev)
>>> +{
>>> +    struct platform_device *pdev = to_platform_device(dev);
>>> +    struct regulator_haptic *haptic = platform_get_drvdata(pdev);
>>> +
>>> +    if (haptic->suspend_state) {
>>> +        regulator_haptic_enable(haptic, true);
>>> +        haptic->suspend_state = false;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static SIMPLE_DEV_PM_OPS(regulator_haptic_pm_ops,
>>> +        regulator_haptic_suspend, regulator_haptic_resume);
>>> +
>>> +static struct of_device_id regulator_haptic_dt_match[] = {
>>> +    { .compatible = "regulator-haptic" },
>>> +    { /* sentinel */ },
>>> +};
>>> +
>>> +static struct platform_driver regulator_haptic_driver = {
>>> +    .probe        = regulator_haptic_probe,
>>> +    .driver        = {
>>> +        .name        = "regulator-haptic",
>>> +        .of_match_table = regulator_haptic_dt_match,
>>> +        .pm        = &regulator_haptic_pm_ops,
>>> +    },
>>> +};
>>> +module_platform_driver(regulator_haptic_driver);
>>> +
>>> +MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
>>> +MODULE_AUTHOR("Hyunhee Kim <hyunhee.kim@samsung.com>");
>>> +MODULE_DESCRIPTION("Regulator haptic driver");
>>> +MODULE_LICENSE("GPL");
>>> diff --git a/include/linux/input/regulator-haptic.h 
>>> b/include/linux/input/regulator-haptic.h
>>> new file mode 100644
>>> index 0000000..05ae038
>>> --- /dev/null
>>> +++ b/include/linux/input/regulator-haptic.h
>>> @@ -0,0 +1,31 @@
>>> +/*
>>> + * Regulator Haptic Platform Data
>>> + *
>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
>>> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or 
>>> modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef _REGULATOR_HAPTIC_H
>>> +#define _REGULATOR_HAPTIC_H
>>> +
>>> +/*
>>> + * struct regulator_haptic_data - Platform device data
>>> + *
>>> + * @regulator: Power supply to the haptic motor
>>> + * @max_volt: maximum voltage value supplied to the haptic motor.
>>> + *         <The unit of the voltage is a micro>
>>> + * @min_volt: minimum voltage value supplied to the haptic motor.
>>> + *         <The unit of the voltage is a micro>
>>> + */
>>> +struct regulator_haptic_data {
>>> +    struct regulator *regulator;
>>> +    unsigned int max_volt;
>>> +    unsigned int min_volt;
>>> +};
>>> +
>>> +#endif /* _REGULATOR_HAPTIC_H */
>>> -- 
>>> 1.7.9.5
>>>
>> Thanks.
>>
>
> Thanks.
> Jaewon Kim.

