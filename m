Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaDKFnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:43:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59132 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaDKFnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:43:07 -0400
X-AuditID: cbfee68e-b7f566d000002344-72-534780e80c70
Message-id: <534784FE.6090107@samsung.com>
Date: Fri, 11 Apr 2014 15:00:30 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Younggun Jang <yg1004.jang@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] drivers: mfd: Add support of exynos-pmu driver
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1396427085-4696-2-git-send-email-pankaj.dubey@samsung.com>
 <4187440.t3CeqIPlpy@amdc1032>
In-reply-to: <4187440.t3CeqIPlpy@amdc1032>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zfd0XDe7BBjcb5Cw2zljParFs0l02
	i/lHzrFaHPizg9Gid8FVNov7X48yWmx6fI3V4vKuOWwWM87vY7K4fZnXonXvEXaL092sFhdX
	fGGy2NGymsWBz6OluYfNY9OqTjaPO9f2sHnMOxnosXlJvUffllWMHp83yQWwR3HZpKTmZJal
	FunbJXBlTNwhWrDWtOLmp0OsDYyLtbsYOTgkBEwk1k3R62LkBDLFJC7cW8/WxcjFISSwjFFi
	atttNoiEicTOpvWMEInpjBJLGo5BOa8ZJXZv+McIUsUroCWxec5LVhCbRUBVYsvDGWDdbAK6
	Ek/ez2UGsUUFwiQ2Te9jhagXlPgx+R4LiC0iYCGxdsVbFpChzAJbmSWeTG1hAjlPWMBb4lu3
	EMSypYwSH+9NBGvmBFr29vd5dhCbWcBaYuWkbYwQtrzE5jVvmUEaJAQmckgseP+TBeIiAYlv
	kw+xQPwsK7HpADPEa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJucWl
	eel6yfm5mxghkdy3g/HmAetDjMlAKycyS4km5wMTQV5JvKGxmZGFqYmpsZG5pRlpwkrivIse
	JgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYHTd8NPRdO+io+kGXBebPjkprDjl32D/aO4U
	15r20pnVO39PXfI054+AtOQSRwNz97QTzxOmtnhxqe7Ws6zMyP3zfZa82+KWXUY+mhOvlXbO
	6LiXf6do1u4L8lbi0YHusRrG3TF5cwRuLnlUzGPXksTzQuhCupmRX+w3m/c3qy2TVizyY5rw
	UomlOCPRUIu5qDgRABVhiaD6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd0XDe7BBmdniFtsnLGe1WLZpLts
	FvOPnGO1OPBnB6NF74KrbBb3vx5ltNj0+BqrxeVdc9gsZpzfx2Rx+zKvReveI+wWp7tZLS6u
	+MJksaNlNYsDn0dLcw+bx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgj2pgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlhJoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDFxh2jBWtOKm58OsTYwLtbuYuTkkBAwkdjZ
	tJ4RwhaTuHBvPVsXIxeHkMB0RoklDccYIZzXjBK7N/wDq+IV0JLYPOclK4jNIqAqseXhDDYQ
	m01AV+LJ+7nMILaoQJjEpul9rBD1ghI/Jt9jAbFFBCwk1q54ywIylFlgK7PEk6ktTF2MHBzC
	At4S37qFIJYtZZT4eG8iWDMn0LK3v8+zg9jMAtYSKydtY4Sw5SU2r3nLPIFRYBaSHbOQlM1C
	UraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCieCa9g3FVg8UhRgEORiUe3gOX3IKF
	WBPLiitzDzFKcDArifCa+bsHC/GmJFZWpRblxxeV5qQWH2JMBgbBRGYp0eR8YBLLK4k3NDYx
	M7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGoO71My97MGy7H3hS6uuD
	xJWCN3s2TDeXPrHl54PWLdrHzyle6NipG3u+vfL4zi9nHvOLyHB098b3vHS5ZescZLbgwqZr
	umcPys2T4bymEc0TYbJ+sufjhkN1M/PVRSe9DJLQWBA8/1cb+yov6T4PzRt3JTSnHn610ozf
	TkXL7fIu3jmnE5K3KrEUZyQaajEXFScCAOPrzoZYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

Thanks for review.

On 04/03/2014 08:56 PM, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> On Wednesday, April 02, 2014 05:24:44 PM Pankaj Dubey wrote:
>> From: Younggun Jang <yg1004.jang@samsung.com>
>>
>> This driver is mainly used for setting misc bits of register from PMU IP
>> of Exynos SoC which will be required to configure before Suspend/Resume.
>> Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
>> moving ahead for ARM64 based SoC support, there is a need of DT based
>> implementation of PMU driver.
> PMU support for ARM32 EXYNOS SoCs is heavily SoC dependent and there
> is very little code shared between diffirent SoCs.  Unless PMU setup
> for Samsung ARM64 SoCs is similar to some existing ARM32 EXYNOS SoCs
> it may be better to just add a separate PMU driver for Samsung ARM64
> SoCs. IOW it would be best to show that this patch series is really
> useful before merging it.

We think it will be useful, but I will consider your point of making driver
which should have common piece of code to address various EXYNOS SoCs.
We are working on it, once it takes some proper shape I will post details here.

>
> When it comes to the current patches it would be better to do changes
> converting PMU support to be a platform driver first for the existing
> arch/arm/mach-exynos/pmu.c file and then move+rename this file in
> the separate patch.  Currently the code changes are done at the same
> time as the code movement which makes them difficult to review/verify.

OK, will do as you suggested in next version.

> There are also some minor issues with the new code:
>
> [...]
>
>> diff --git a/drivers/mfd/exynos-pmu.c b/drivers/mfd/exynos-pmu.c
>> new file mode 100644
>> index 0000000..24abd9b
>> --- /dev/null
>> +++ b/drivers/mfd/exynos-pmu.c
>> @@ -0,0 +1,534 @@
>> +/*
>> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
>> + *		http://www.samsung.com/
> 2015?

Will fix this.

> [...]
>
>> +static int __init exynos4210_pmu_init(void)
>> +{
>> +	exynos_pmu_config = exynos4210_pmu_config;
>> +	pmu_data->pmu_id = PMU_EXYNOS4210;
>> +	pr_info("EXYNOS4210 PMU Initialize\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init exynos4212_pmu_init(void)
>> +{
>> +	exynos_pmu_config = exynos4x12_pmu_config;
>> +	pmu_data->pmu_id = PMU_EXYNOS4212;
>> +	pr_info("EXYNOS4x12 PMU Initialize\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init exynos4412_pmu_init(void)
>> +{
>> +	exynos_pmu_config = exynos4x12_pmu_config;
>> +	pmu_data->pmu_id = PMU_EXYNOS4412;
>> +	pr_info("EXYNOS4412 PMU Initialize\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init exynos5250_pmu_init(void)
>> +{
>> +	unsigned int value;
>> +
>> +	/*
>> +	 * When SYS_WDTRESET is set, watchdog timer reset request
>> +	 * is ignored by power management unit.
>> +	 */
>> +	value = __raw_readl(pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
>> +	value &= ~EXYNOS5_SYS_WDTRESET;
>> +	__raw_writel(value, pmu_data->regs + EXYNOS5_AUTO_WDTRESET_DISABLE);
>> +
>> +	value = __raw_readl(pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
>> +	value &= ~EXYNOS5_SYS_WDTRESET;
>> +	__raw_writel(value, pmu_data->regs + EXYNOS5_MASK_WDTRESET_REQUEST);
>> +
>> +	exynos_pmu_config = exynos5250_pmu_config;
>> +	pmu_data->pmu_id = PMU_EXYNOS5250;
>> +	pr_info("EXYNOS5250 PMU Initialize\n");
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * PMU platform driver and devicetree bindings.
>> + */
>> +static struct of_device_id exynos_pmu_of_device_ids[] = {
>> +	{
>> +		.compatible = "samsung,exynos4210-pmu",
>> +		.data = (void *)exynos4210_pmu_init
>> +	},
>> +	{
>> +		.compatible = "samsung,exynos4212-pmu",
>> +		.data = (void *)exynos4212_pmu_init
>> +	},
>> +	{
>> +		.compatible = "samsung,exynos4412-pmu",
>> +		.data = (void *)exynos4412_pmu_init
>> +	},
>> +	{
>> +		.compatible = "samsung,exynos5250-pmu",
>> +		.data = (void *)exynos5250_pmu_init
>> +	},
>> +	{},
>> +};
>> +
>> +static int exynos_pmu_probe(struct platform_device *pdev)
>> +{
>> +	const struct of_device_id *match;
>> +	exynos_pmu_init_t exynos_pmu_init;
>> +	struct resource *res;
>> +
>> +	pmu_data = devm_kzalloc(&pdev->dev,
>> +			sizeof(struct exynos_pmu_data), GFP_KERNEL);
>> +	if (!pmu_data) {
>> +		dev_err(&pdev->dev, "exynos_pmu driver probe failed\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	pmu_data->dev = &pdev->dev;
>> +
>> +	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
>> +	exynos_pmu_init = match->data;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	pmu_data->regs = devm_ioremap_resource(&pdev->dev, res);
> devm_ioremap_resouce() return value should be checked for errors with
>
> if (IS_ERR(pmu_data->regs))
> 	return PTR_ERR(pmu_data->regs);
Will take care.
>> +
>> +	exynos_pmu_init();
> exynos*_pmu_init() methods should be void as they always return 0 and
> the return value is ignored anyway.
>
> Also they cannot be marked with __init as the driver probe function
> itself is not marked with __init (it cannot be beacuse of possibility
> of doing unbind/bind through sysfs).
Will take care.
>> +
>> +	return 0;
>> +};
>> +
>> +static int exynos_pmu_remove(struct platform_device *pdev)
>> +{
>> +	exynos_pmu_config = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver exynos_pmu_driver = {
>> +	.driver  = {
>> +		.name   = "exynos-pmu",
>> +		.of_match_table = exynos_pmu_of_device_ids,
>> +	},
>> +	.probe = exynos_pmu_probe,
>> +	.remove = exynos_pmu_remove,
>> +};
>> +
>> +static int __init exynos_pmu_driver_init(void)
>> +{
>> +	return platform_driver_register(&exynos_pmu_driver);
>> +}
>> +arch_initcall(exynos_pmu_driver_init);
>> +
>> +MODULE_AUTHOR("Younggun Jang <yg1004.jang@samsung.com");
>> +MODULE_DESCRIPTION("Exynos PMU driver");
>> +MODULE_LICENSE("GPL v2");
> This driver can be build as module now but:
> - exynos_sys_powerdown_conf() is not exported
> - there is no exynos_pmu_driver_exit()
OK, will take care.
> Also it is not clear what happens if exynos_sys_powerdown_conf() is called
> while there are no platform devices binded to a driver but driver itself is
> loaded.
>
> [...]
>
>> diff --git a/include/linux/mfd/samsung/exynos-regs-pmu.h b/include/linux/mfd/samsung/exynos-regs-pmu.h
>> new file mode 100644
>> index 0000000..ed8259d
>> --- /dev/null
>> +++ b/include/linux/mfd/samsung/exynos-regs-pmu.h
>> @@ -0,0 +1,308 @@
>> +/*
>> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
> 2015?
I will change.
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>


-- 
Best Regards,
Pankaj Dubey

