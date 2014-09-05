Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaIEDAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:00:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48175 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaIEDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:00:32 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee68f-f797f6d000001173-f4-5409274d065c
Content-transfer-encoding: 8BIT
Message-id: <5409274D.7080105@samsung.com>
Date: Fri, 05 Sep 2014 12:00:29 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 2/4] Input: misc: Add haptic driver on max77693
References: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
 <1409842891-26549-3-git-send-email-jaewon02.kim@samsung.com>
 <20140904165958.GA10224@core.coreip.homeip.net>
In-reply-to: <20140904165958.GA10224@core.coreip.homeip.net>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkRNdPnTPEoPEds8X1L89ZLQ4vesFo
	cf/rUUaLm5++sVpc3jWHzeJ0N6sDm8fOWXfZPe5c28PmMe9koEffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlbHjzgrFga3HFwbWTGRsY58d1MXJySAiYSDxr3c8MYYtJXLi3nq2LkYtDSGAp
	o8S6KafZYYqaO4+xQCQWMUo83HUbrINXQFDix+R7QAkODmYBeYkjl7JBwswCZhKPWtYxQ9S/
	ZpS4taOdHaJeS+Lf8nNgvSwCqhKHNi1iBLHZBLQlvq9fzApiiwqESTz7dZAJxBYR0JfYPvsX
	I8ggZoH1jBKrzs1kAUkIC7hJNHx4zAqxYSejRMvtU2DdnAI2En2PdzOBJCQETrFLnPywngVi
	nYDEt8mHwE6VEJCV2HQA6mdJiYMrbrBMYBSbheShWQgPzULy0AJG5lWMoqkFyQXFSelFxnrF
	ibnFpXnpesn5uZsYgbF2+t+z/h2Mdw9YH2IU4GBU4uFd8JkjRIg1say4MvcQoynQEROZpUST
	84ERnVcSb2hsZmRhamJqbGRuaaYkzrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbK
	zSa17/68Dqt8NuPTmmN9H5lPsm5dJzJx+pdA3y3Nx4XSxVaaBjEufCXrI9Bp9D5M1Zj3sfO0
	WSdLP+j/MmfIS8/4bn/D8sGee4kLF9pezSyNf9b3WmxGnfzOb37O4U8yeyrvZvXwW+853/pl
	nszS8/qGSxU/T0xcIlZ6KCi1kYW/z9Fc6IoSS3FGoqEWc1FxIgBNDjcvsAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAV1fdc4Qg+ezzSyuf3nOanF40QtG
	i/tfjzJa3Pz0jdXi8q45bBanu1kd2Dx2zrrL7nHn2h42j3knAz36tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aGNy8YC7YWVxxcO5mxgXF+XBcjJ4eE
	gIlEc+cxFghbTOLCvfVsXYxcHEICixglHu66zQyS4BUQlPgx+R5QEQcHs4C8xJFL2SBhZgEz
	iUct65gh6l8zStza0c4OUa8l8W/5ObBeFgFViUObFjGC2GwC2hLf1y9mBbFFBcIknv06yARi
	iwjoS2yf/YsRZBCzwHpGiVXnZoJdJCzgJtHw4TErxIadjBItt0+BdXMK2Ej0Pd7NNIFRYBaS
	A2chHDgLyYELGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH8jPpHYyrGiwOMQpwMCrx
	8C74zBEixJpYVlyZe4hRgoNZSYTX6w1QiDclsbIqtSg/vqg0J7X4EKMp0HsTmaVEk/OBSSav
	JN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANjmXrIafEfZz/a571a
	WBjvyKGUkv5xFfv2M2EtygcupM1LMlSY0stmcfH2eZNFPetWPpxyte7r88sOxZtXSUzYmJp2
	57L+Ky7242yuipuviy99XNYzqeP5phivK/rTdlpF/qx59ev55N0Mcm9kZk3dePpTQ+zTwhTH
	NMbkrBXdTn21AnIhnvvuKLEUZyQaajEXFScCAFv1mC36AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry Torokhov

thanks to review my patchs.

2014년 09월 05일 01:59에 Dmitry Torokhov 이(가) 쓴 글:
> Hi Jaewon,
>
> On Fri, Sep 05, 2014 at 12:01:29AM +0900, Jaewon Kim wrote:
>> This patch add max77693-haptic device driver to support the haptic controller
>> on MAX77693. The MAX77693 is a Multifunction device with PMIC, CHARGER, LED,
>> MUIC, HAPTIC and the patch is haptic device driver in the MAX77693. This driver
>> support external pwm and LRA(Linear Resonant Actuator) motor. User can control
>> the haptic driver by using force feedback framework.
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   drivers/input/misc/Kconfig           |   12 ++
>>   drivers/input/misc/Makefile          |    1 +
>>   drivers/input/misc/max77693-haptic.c |  333 ++++++++++++++++++++++++++++++++++
>>   include/linux/mfd/max77693-private.h |    9 +
>>   4 files changed, 355 insertions(+)
>>   create mode 100644 drivers/input/misc/max77693-haptic.c
>>
>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>> index 2ff4425..c597c52 100644
>> --- a/drivers/input/misc/Kconfig
>> +++ b/drivers/input/misc/Kconfig
>> @@ -144,6 +144,18 @@ config INPUT_M68K_BEEP
>>   	tristate "M68k Beeper support"
>>   	depends on M68K
>>   
>> +config INPUT_MAX77693_HAPTIC
>> +	tristate "MAXIM MAX77693 haptic controller support"
>> +	depends on MFD_MAX77693 && PWM
>> +	select INPUT_FF_MEMLESS
>> +	help
>> +	  This option enables device driver support for the haptic controller
>> +	  on MAXIM MAX77693 chip. This driver supports ff-memless interface
>> +	  from input framework.
>> +
>> +	  To compile this driver as module, choose M here: the
>> +	  module will be called max77693-haptic.
>> +
>>   config INPUT_MAX8925_ONKEY
>>   	tristate "MAX8925 ONKEY support"
>>   	depends on MFD_MAX8925
>> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>> index 4955ad3..b28570c 100644
>> --- a/drivers/input/misc/Makefile
>> +++ b/drivers/input/misc/Makefile
>> @@ -35,6 +35,7 @@ obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
>>   obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
>>   obj-$(CONFIG_INPUT_KXTJ9)		+= kxtj9.o
>>   obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
>> +obj-$(CONFIG_INPUT_MAX77693_HAPTIC)	+= max77693-haptic.o
>>   obj-$(CONFIG_INPUT_MAX8925_ONKEY)	+= max8925_onkey.o
>>   obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
>>   obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
>> diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
>> new file mode 100644
>> index 0000000..2a69496
>> --- /dev/null
>> +++ b/drivers/input/misc/max77693-haptic.c
>> @@ -0,0 +1,333 @@
>> +/*
>> + * max77693-haptic.c - MAXIM MAX77693 Haptic device driver
>> + *
>> + * Copyright (C) 2014 Samsung Electronics
>> + * Jaewon Kim <jaewon02.kim@samsung.com>
>> + *
>> + * This program is not provided / owned by Maxim Integrated Products.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/regmap.h>
>> +#include <linux/input.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +#include <linux/slab.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/mfd/max77693.h>
>> +#include <linux/mfd/max77693-private.h>
>> +
>> +#define MAX_MAGNITUDE_SHIFT	16
>> +
>> +enum max77693_haptic_motor_type {
>> +	MAX77693_HAPTIC_ERM = 0,
>> +	MAX77693_HAPTIC_LRA,
>> +};
>> +
>> +enum max77693_haptic_pulse_mode {
>> +	MAX77693_HAPTIC_EXTERNAL_MODE = 0,
>> +	MAX77693_HAPTIC_INTERNAL_MODE,
>> +};
>> +
>> +enum max77693_haptic_pwm_divisor {
>> +	MAX77693_HAPTIC_PWM_DIVISOR_32 = 0,
>> +	MAX77693_HAPTIC_PWM_DIVISOR_64,
>> +	MAX77693_HAPTIC_PWM_DIVISOR_128,
>> +	MAX77693_HAPTIC_PWM_DIVISOR_256,
>> +};
>> +
>> +struct max77693_haptic {
>> +	struct regmap *regmap_pmic;
>> +	struct regmap *regmap_haptic;
>> +	struct device *dev;
>> +	struct input_dev *input_dev;
>> +	struct pwm_device *pwm_dev;
>> +	struct regulator *motor_reg;
>> +
>> +	bool enabled;
>> +	unsigned int magnitude;
>> +	enum max77693_haptic_motor_type type;
>> +	enum max77693_haptic_pulse_mode mode;
>> +	enum max77693_haptic_pwm_divisor pwm_divisor;
>> +
>> +	struct mutex mutex;
>> +	struct work_struct work;
>> +};
>> +
>> +static int max77693_haptic_set_duty_cycle(struct max77693_haptic *haptic,
>> +						unsigned int pwm_duty)
>> +{
>> +	int ret;
>> +	int delta = (haptic->pwm_dev->period + pwm_duty)/2;
>> +
>> +	ret = pwm_config(haptic->pwm_dev, delta, haptic->pwm_dev->period);
>> +	if (ret) {
>> +		dev_err(haptic->dev, "cannot configuration pwm\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77693_haptic_configure(struct max77693_haptic *haptic,
>> +						unsigned int enable)
>> +{
>> +	int ret;
>> +	unsigned int value = 0;
>> +
>> +	value = ((haptic->type << MAX77693_CONFIG2_MODE) |
>> +		(enable << MAX77693_CONFIG2_MEN) |
>> +		(haptic->mode << MAX77693_CONFIG2_HTYP) |
>> +		(haptic->pwm_divisor));
>> +
>> +	ret = regmap_write(haptic->regmap_haptic,
>> +				MAX77693_HAPTIC_REG_CONFIG2, value);
>> +	if (ret) {
>> +		dev_err(haptic->dev, "cannot write haptic regmap\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77693_haptic_lowsys(struct max77693_haptic *haptic,
>> +						unsigned int enable)
>> +{
>> +	int ret;
>> +
>> +	ret = regmap_update_bits(haptic->regmap_pmic,
>> +			MAX77693_PMIC_REG_LSCNFG,
>> +			MAX77693_PMIC_LOW_SYS_MASK,
>> +			enable << MAX77693_PMIC_LOW_SYS_SHIFT);
>> +	if (ret) {
>> +		dev_err(haptic->dev, "cannot update pmic regmap\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void max77693_haptic_enable(struct max77693_haptic *haptic)
>> +{
>> +	int ret;
>> +
>> +	if (haptic->enabled)
>> +		return;
>> +
>> +	ret = pwm_enable(haptic->pwm_dev);
>> +	if (ret < 0) {
>> +		dev_err(haptic->dev, "cannot enable haptic pwm device");
>> +		return;
>> +	}
>> +
>> +	ret = regulator_enable(haptic->motor_reg);
>> +	if (ret) {
>> +		dev_err(haptic->dev, "cannot enable haptic regulator\n");
>> +		goto err_pwm_enable;
>> +	}
>> +
>> +	ret = max77693_haptic_lowsys(haptic, 1);
>> +	if (ret)
>> +		goto err_enable_lowsys;
>> +
>> +	ret = max77693_haptic_configure(haptic, 1);
>> +	if (ret < 0)
>> +		goto err_enable_config;
>> +
>> +	haptic->enabled = true;
>> +
>> +	return;
>> +
>> +err_enable_config:
>> +	max77693_haptic_lowsys(haptic, 0);
>> +err_enable_lowsys:
>> +	regulator_disable(haptic->motor_reg);
>> +err_pwm_enable:
>> +	pwm_disable(haptic->pwm_dev);
>> +}
>> +
>> +static void max77693_haptic_disable(struct max77693_haptic *haptic)
>> +{
>> +	int ret;
>> +
>> +	if (!haptic->enabled)
>> +		return;
>> +
>> +	ret = max77693_haptic_configure(haptic, 0);
>> +	if (ret < 0)
> Why sometimes you test for negative errors and sometimes for != 0 from the same
> MFD core? Can you settle on one, preferably 0/!0, in which case please also call
> local local variables holding the result 'error' so that you have sequences:
>
> 	error = action();
> 	if (error)
> 		handle_error;
Ok, i will settle on.
>
>> +		return;
>> +
>> +	ret = max77693_haptic_lowsys(haptic, 0);
>> +	if (ret)
>> +		goto err_disable_lowsys;
>> +
>> +	ret = regulator_disable(haptic->motor_reg);
>> +	if (ret) {
>> +		dev_err(haptic->dev, "cannot disable haptic regulator\n");
>> +		goto err_reg_disable;
>> +	}
>> +
>> +	pwm_disable(haptic->pwm_dev);
>> +	haptic->enabled = false;
>> +
>> +	return;
>> +
>> +err_reg_disable:
>> +	max77693_haptic_lowsys(haptic, 1);
>> +err_disable_lowsys:
>> +	max77693_haptic_configure(haptic, 1);
>> +}
>> +
>> +static void max77693_haptic_play_work(struct work_struct *work)
>> +{
>> +	struct max77693_haptic *haptic =
>> +			container_of(work, struct max77693_haptic, work);
>> +
>> +	mutex_lock(&haptic->mutex);
> Workqueues are not reentrant by default, you do not need this mutex.
I will remove them.
>
>> +	if (haptic->magnitude)
>> +		max77693_haptic_enable(haptic);
>> +	else
>> +		max77693_haptic_disable(haptic);
> Hmm, do you really want to bounce regulator on and off on every buzz? I guess
> it may save some power...
Yes, You are right.

>
>> +	mutex_unlock(&haptic->mutex);
>> +}
>> +
>> +static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
>> +				struct ff_effect *effect)
>> +{
>> +	struct max77693_haptic *haptic = input_get_drvdata(dev);
>> +	uint64_t period_mag_multi;
>> +	unsigned int pwm_duty;
>> +	int ret;
>> +
>> +	haptic->magnitude = effect->u.rumble.strong_magnitude;
>> +	if (!haptic->magnitude)
>> +		haptic->magnitude = effect->u.rumble.weak_magnitude;
>> +
>> +	/*
>> +	 * The magnitude comes from force-feedback interface.
>> +	 * The formula convert magnitude to pwm_duty as following:
>> +	 * - pwm_duty = (magnitude * pwm_period) / MAX_MAGNITUDE(0xFFFF)
>> +	 */
>> +	period_mag_multi = (int64_t)(haptic->pwm_dev->period *
>> +						haptic->magnitude);
>> +	pwm_duty = (unsigned int)(period_mag_multi >> MAX_MAGNITUDE_SHIFT);
>> +	ret = max77693_haptic_set_duty_cycle(haptic, pwm_duty);
> Why is this done here and not in max77693_haptic_play_work? Is it even safe to
> access the device here (you are running under a spinlock with interrupts off).
I miss that is in spinlock.
max77693_haptic_set_duty_cycle() will move in workqueue.

>
>> +	if (ret)
>> +		return ret;
>> +
>> +	schedule_work(&haptic->work);
>> +
>> +	return 0;
>> +}
>> +
>> +static void max77693_haptic_close(struct input_dev *dev)
>> +{
>> +	struct max77693_haptic *haptic = input_get_drvdata(dev);
>> +
>> +	cancel_work_sync(&haptic->work);
>> +	max77693_haptic_disable(haptic);
>> +}
>> +
>> +static int max77693_haptic_probe(struct platform_device *pdev)
>> +{
>> +	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
>> +	struct max77693_haptic *haptic;
>> +	int ret = 0;
>> +
>> +	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
>> +	if (!haptic)
>> +		return -ENOMEM;
>> +
>> +	haptic->regmap_pmic = max77693->regmap;
>> +	haptic->regmap_haptic = max77693->regmap_haptic;
>> +	haptic->dev = &pdev->dev;
>> +	haptic->type = MAX77693_HAPTIC_LRA;
>> +	haptic->mode = MAX77693_HAPTIC_EXTERNAL_MODE;
>> +	haptic->pwm_divisor = MAX77693_HAPTIC_PWM_DIVISOR_128;
>> +	mutex_init(&haptic->mutex);
>> +
>> +	/* Get pwm and regulatot for haptic device */
>> +	haptic->pwm_dev = devm_pwm_get(&pdev->dev, NULL);
>> +	if (IS_ERR(haptic->pwm_dev)) {
>> +		dev_err(&pdev->dev, "failed to get pwm device\n");
>> +		return PTR_ERR(haptic->pwm_dev);
>> +	}
>> +
>> +	haptic->motor_reg = devm_regulator_get(&pdev->dev, "haptic");
>> +	if (IS_ERR(haptic->motor_reg)) {
>> +		dev_err(&pdev->dev, "failed to get regulator\n");
>> +		return PTR_ERR(haptic->motor_reg);
>> +	}
>> +
>> +	/* Initialize input device for haptic device */
>> +	haptic->input_dev = devm_input_allocate_device(&pdev->dev);
>> +	if (!haptic->input_dev) {
>> +		dev_err(&pdev->dev, "failed to allocate input device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	haptic->input_dev->name = "max77693-haptic";
>> +	haptic->input_dev->id.version = 1;
>> +	haptic->input_dev->dev.parent = &pdev->dev;
>> +	haptic->input_dev->close = max77693_haptic_close;
>> +	input_set_drvdata(haptic->input_dev, haptic);
>> +	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
>> +
>> +	ret = input_ff_create_memless(haptic->input_dev, NULL,
>> +				max77693_haptic_play_effect);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "failed to create force-feedback\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = input_register_device(haptic->input_dev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "failed to register input device\n");
>> +		goto err_input_device;
>> +	}
>> +
>> +	INIT_WORK(&haptic->work, max77693_haptic_play_work);
>> +
>> +	platform_set_drvdata(pdev, haptic);
>> +
>> +	return 0;
>> +
>> +err_input_device:
>> +	input_ff_destroy(haptic->input_dev);
> No need to call, will be done automatically.
>
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77693_haptic_remove(struct platform_device *pdev)
>> +{
>> +	struct max77693_haptic *haptic = platform_get_drvdata(pdev);
>> +
>> +	max77693_haptic_disable(haptic);
> It is done in close() so no need to cal here.
>
>> +	input_unregister_device(haptic->input_dev);
> You are using devm so no need to call it either. Just remove
> max77693_haptic_remove() altogether.
Ok. i will remove unnecessary unregister functions.

>
> What you need I think is suspend/resume to make sure the device is shut off
> when system is suspending.

If haptic motor buzzing when device entening suspend state, i turn off 
motor.
but, i think resume code not necessary in this driver.
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver max77693_haptic_driver = {
>> +	.driver		= {
>> +		.name	= "max77693-haptic",
>> +		.owner	= THIS_MODULE,
>> +	},
>> +	.probe		= max77693_haptic_probe,
>> +	.remove		= max77693_haptic_remove,
>> +};
>> +module_platform_driver(max77693_haptic_driver);
>> +
>> +MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
>> +MODULE_DESCRIPTION("MAXIM MAX77693 Haptic driver");
>> +MODULE_ALIAS("platform:max77693-haptic");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
>> index c466ff3..d0e578f 100644
>> --- a/include/linux/mfd/max77693-private.h
>> +++ b/include/linux/mfd/max77693-private.h
>> @@ -251,6 +251,15 @@ enum max77693_haptic_reg {
>>   	MAX77693_HAPTIC_REG_END,
>>   };
>>   
>> +/* max77693-pmic LSCNFG configuraton register */
>> +#define MAX77693_PMIC_LOW_SYS_MASK      0x80
>> +#define MAX77693_PMIC_LOW_SYS_SHIFT     7
>> +
>> +/* max77693-haptic configuration register */
>> +#define MAX77693_CONFIG2_MODE           7
>> +#define MAX77693_CONFIG2_MEN            6
>> +#define MAX77693_CONFIG2_HTYP           5
>> +
>>   enum max77693_irq_source {
>>   	LED_INT = 0,
>>   	TOPSYS_INT,
>> -- 
>> 1.7.9.5
>>
> Thanks.
>

Thanks
Jaewon Kim.
