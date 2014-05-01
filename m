Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaEADkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:40:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31081 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEADkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:40:12 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-23-5361c2191672
Message-id: <5361C652.3080603@samsung.com>
Date: Thu, 01 May 2014 12:58:10 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Vikas Sajjan <sajjan.linux@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        Vikas Sajjan <vikas.sajjan@samsung.com>
Subject: Re: [PATCH v3 11/12] ARM: EXYNOS: Add platform driver support for
 Exynos PMU.
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
 <1398835057-3860-12-git-send-email-pankaj.dubey@samsung.com>
 <CAGm_ybjPGDe7ARPs7vfe+LJ2pmxD-HU6cNa9ePaWobDFeOP46Q@mail.gmail.com>
In-reply-to: <CAGm_ybjPGDe7ARPs7vfe+LJ2pmxD-HU6cNa9ePaWobDFeOP46Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfV3JQ4nBBj+PSlosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaPDn8kdVi/YzXLBY3n21nstjRsprFgcujpbmHzWPnrLvs
	HpuX1Hv0bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxr9dC1kKFjczVpya/Ym1gfFpTBcjJ4eE
	gInE9+a5zBC2mMSFe+vZuhi5OIQEljFKbN86iQmmaP7s91CJRYwS+2/eZ4FwXjNKTHz4Bayd
	V0BL4v/jY2wgNouAqsTGifPZQWw2AV2JJ+8hVogKhElsmt7HClEvKPFj8j2gQRwcIgKaEg8/
	2oDMZBb4ySTx+9cGsF5hgQiJe+0XWSGWnWWUWPplNQtIglMgWOLuh21gNrOAmcSjlnXMELa8
	xOY1b6H+ecQusXyOMMRBAhLfJh8CWyYhICux6QBUiaTEwRU3WCYwis1CctIsJFNnIZm6gJF5
	FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIVPbvYLx7wPoQYzLQyonMUqLJ+cCoziuJNzQ2
	M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEvmGWdEfAmK
	ucR04uODVobDX2cx/Ja8ddyo0uxUzBTf5Mi/rW5f40TM3Pa0OR9L/PFq85+DxnlXuPa9fDz7
	SMz/KzVXzM7fdGTk35F2L1jX8f6NXScyJvc/KcyR+/1c+IjWuiJhhYTXH783vGg5fvHvvkO1
	S4oMC6xeL9Xd9Ojemou7RRIPKGxWYinOSDTUYi4qTgQAif5S8eACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV3JQ4nBBp1zhCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktnhz+yGqxfsZrFoubz7YzWexoWc3iwOXR0tzD5rFz1l12
	j81L6j36tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8a/
	XQtZChY3M1acmv2JtYHxaUwXIyeHhICJxPzZ79kgbDGJC/fWA9lcHEICixgl9t+8zwLhvGaU
	mPjwCzNIFa+AlsT/x8fAOlgEVCU2TpzPDmKzCehKPHk/F6xGVCBMYtP0PlaIekGJH5PvAQ3i
	4BAR0JR4+NEGZCazwE8mid+/NoD1CgtESNxrv8gKsewso8TSL6tZQBKcAsESdz9sA7OZBcwk
	HrWsY4aw5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnDUP5PewbiqweIQowAHoxIP7wS2xGAh1sSy4srcQ4wSHMxKIrzBa4BCvCmJlVWpRfnxRaU5
	qcWHGJOBQTCRWUo0OR+YkPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgVFT78z0Fr75nm2iPhZfq1K8Alrq9u88Ffbk7tYL7yIDFH6taIyf9iTk+DzTpesa
	Z5zzaTou6+s162/wie/FiQLPU7lsCnn4qzTVpqpFHfUWZtlaZhLx325T7uJpOkufGFr+4I+9
	uJjHXNWiIK02ZPsljRjuE/3L9ysd3h6QevaK+zWptKJ+byWW4oxEQy3mouJEALieXgE+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 03:05 PM, Vikas Sajjan wrote:
> Hi Pankaj,
>
> On Wed, Apr 30, 2014 at 10:47 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> This patch modifies Exynos Power Management Unit (PMU) initialization
>> implementation in following way:
>>
>> - Added platform_device support by registering static platform device.
>> - Added platform struct exynos_pmu_data to hold platform specific data.
>> - For each SoC's PMU support now we can add platform data and statically
>>    bind PMU configuration and SoC specific initialization function.
>> - Probe function will scan DT and based on matching PMU compatibility
>>    string initialize pmu_context which will be platform_data for driver.
>> - Obtain PMU regmap handle using "syscon_regmap_lookup_by_phandle" so
>>    that we can reduce dependency over machine header files.
>> - Separate each SoC's PMU initialization function and make it as part of
>>    platform data.
>> - It also removes uses of soc_is_exynosXXXX() thus making PMU implementation
>>    independent of "plat/cpu.h".
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> ---
>>   arch/arm/mach-exynos/pmu.c |  280 +++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 224 insertions(+), 56 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
>> index 67116a5..030df96 100644
>> --- a/arch/arm/mach-exynos/pmu.c
>> +++ b/arch/arm/mach-exynos/pmu.c
>> @@ -1,5 +1,5 @@
>>   /*
>> - * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
>> + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
>>    *             http://www.samsung.com/
>>    *
>>    * EXYNOS - CPU PMU(Power Management Unit) support
>> @@ -9,20 +9,33 @@
>>    * published by the Free Software Foundation.
>>    */
>>
>> -#include <linux/io.h>
>> -#include <linux/kernel.h>
>> +#include <linux/module.h>
>>   #include <linux/regmap.h>
>> -
>> -#include <plat/cpu.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/mfd/syscon.h>
>>
>>   #include "common.h"
>>   #include "regs-pmu.h"
>>
>> -static const struct exynos_pmu_conf *exynos_pmu_config;
>> -static struct regmap *pmu_regmap;
>> +struct exynos_pmu_data {
>> +       const struct exynos_pmu_conf *pmu_config;
>> +       const struct exynos_pmu_conf *pmu_config_extra;
>> +       void (*pmu_init)(void);
>> +       void (*powerdown_conf)(enum sys_powerdown);
>> +};
>> +
>> +struct exynos_pmu_context {
>> +       struct device *dev;
>> +       struct exynos_pmu_data *pmu_data;
>> +       struct regmap   *pmu_regmap;
>> +};
>> +
>> +static struct exynos_pmu_context       *pmu_context;
>>
>>   static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>> -       /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
>> +       /* { .offset = address, .val = { AFTR, LPA, SLEEP } */
>>          { S5P_ARM_CORE0_LOWPWR,                 { 0x0, 0x0, 0x2 } },
>>          { S5P_DIS_IRQ_CORE0,                    { 0x0, 0x0, 0x0 } },
>>          { S5P_DIS_IRQ_CENTRAL0,                 { 0x0, 0x0, 0x0 } },
>> @@ -216,7 +229,7 @@ static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
>>   };
>>
>>   static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
>> -       /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
>> +       /* { .offset = address, .val = { AFTR, LPA, SLEEP } */
>>          { EXYNOS5_ARM_CORE0_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
>>          { EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
>>          { EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,        { 0x0, 0x0, 0x0} },
>> @@ -339,7 +352,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>>          EXYNOS5_ISP_ARM_OPTION,
>>   };
>>
>> -static void exynos5_init_pmu(void)
>> +void exynos5_powerdown_conf(enum sys_powerdown mode)
>>   {
>>          unsigned int i;
>>          unsigned int tmp;
>> @@ -348,81 +361,236 @@ static void exynos5_init_pmu(void)
>>           * Enable both SC_FEEDBACK and SC_COUNTER
>>           */
>>          for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
>> -               regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i], &tmp);
>> +               regmap_read(pmu_context->pmu_regmap,
>> +                               exynos5_list_both_cnt_feed[i], &tmp);
>>                  tmp |= (EXYNOS5_USE_SC_FEEDBACK |
>>                          EXYNOS5_USE_SC_COUNTER);
>> -               regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i], tmp);
>> +               regmap_write(pmu_context->pmu_regmap,
>> +                               exynos5_list_both_cnt_feed[i], tmp);
>>          }
>>
>>          /*
>>           * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
>>           */
>> -       regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
>> +       regmap_read(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
>>          tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
>> -       regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
>> +       regmap_write(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
>>
>>          /*
>>           * Disable WFI/WFE on XXX_OPTION
>>           */
>>          for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
>> -               tmp = regmap_read(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
>> -                               &tmp);
>> +               tmp = regmap_read(pmu_context->pmu_regmap,
>> +                               exynos5_list_diable_wfi_wfe[i], &tmp);
>>                  tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
>>                           EXYNOS5_OPTION_USE_STANDBYWFI);
>> -               regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i], tmp);
>> +               regmap_write(pmu_context->pmu_regmap,
>> +                               exynos5_list_diable_wfi_wfe[i], tmp);
>>          }
>>   }
>>
>>   void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>>   {
>>          unsigned int i;
>> +       struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
>>
>> -       if (soc_is_exynos5250())
>> -               exynos5_init_pmu();
>> +       if (pmu_data->powerdown_conf)
>> +               pmu_data->powerdown_conf(mode);
>>
>> -       for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
>> -               regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
>> -                               exynos_pmu_config[i].val[mode]);
>> +       if (pmu_data->pmu_config) {
>> +               for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
>> +                       regmap_write(pmu_context->pmu_regmap,
>> +                                       pmu_data->pmu_config[i].offset,
>> +                                       pmu_data->pmu_config[i].val[mode]);
>> +       }
>>
>> -       if (soc_is_exynos4412()) {
>> -               for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
>> -                       regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
>> -                                       exynos4412_pmu_config[i].val[mode]);
>> +       if (pmu_data->pmu_config_extra) {
>> +               for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
>> +                       regmap_write(pmu_context->pmu_regmap,
>> +                                       pmu_data->pmu_config_extra[i].offset,
>> +                                       pmu_data->pmu_config_extra[i].val[mode]);
>>          }
>>   }
>>
>> -static int __init exynos_pmu_init(void)
>> +static void exynos5250_pmu_init(void)
>> +{
>> +       unsigned int tmp;
>> +       struct regmap *pmu_regmap = pmu_context->pmu_regmap;
>> +       /*
>> +        * When SYS_WDTRESET is set, watchdog timer reset request
>> +        * is ignored by power management unit.
>> +        */
>> +       regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &tmp);
>> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
>> +       regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, tmp);
>> +
>> +       regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &tmp);
>> +       tmp &= ~EXYNOS5_SYS_WDTRESET;
>> +       regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, tmp);
>> +}
>> +
>> +static struct exynos_pmu_data exynos4210_pmu_data = {
>> +       .pmu_config     = exynos4210_pmu_config,
>> +};
>> +
>> +static struct exynos_pmu_data exynos4x12_pmu_data = {
>> +       .pmu_config     = exynos4x12_pmu_config,
>> +};
>> +
>> +static struct exynos_pmu_data exynos4412_pmu_data = {
>> +       .pmu_config             = exynos4x12_pmu_config,
>> +       .pmu_config_extra       = exynos4412_pmu_config,
>> +};
>> +
>> +static struct exynos_pmu_data exynos5250_pmu_data = {
>> +       .pmu_config     = exynos5250_pmu_config,
>> +       .pmu_init       = exynos5250_pmu_init,
>> +       .powerdown_conf = exynos5_powerdown_conf,
>> +};
>> +
>> +/*
>> + * PMU platform driver and devicetree bindings.
>> + */
>> +static struct of_device_id exynos_pmu_of_device_ids[] = {
>> +       {
>> +               .compatible = "samsung,exynos4210-pmu",
>> +               .data = (void *)&exynos4210_pmu_data,
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos4212-pmu",
>> +               .data = (void *)&exynos4x12_pmu_data,
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos4412-pmu",
>> +               .data = (void *)&exynos4412_pmu_data,
>> +       },
>> +       {
>> +               .compatible = "samsung,exynos5250-pmu",
>> +               .data = (void *)&exynos5250_pmu_data,
>> +       },
>> +       {},
>> +};
>> +
>> +static int exynos_pmu_data_init(struct device_node *np)
>>   {
>> -       unsigned int value;
>> -
>> -       exynos_pmu_config = exynos4210_pmu_config;
>> -       pmu_regmap = get_exynos_pmuregmap();
>> -
>> -       if (soc_is_exynos4210()) {
>> -               exynos_pmu_config = exynos4210_pmu_config;
>> -               pr_info("EXYNOS4210 PMU Initialize\n");
>> -       } else if (soc_is_exynos4212() || soc_is_exynos4412()) {
>> -               exynos_pmu_config = exynos4x12_pmu_config;
>> -               pr_info("EXYNOS4x12 PMU Initialize\n");
>> -       } else if (soc_is_exynos5250()) {
>> -               /*
>> -                * When SYS_WDTRESET is set, watchdog timer reset request
>> -                * is ignored by power management unit.
>> -                */
>> -               regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
>> -               value &= ~EXYNOS5_SYS_WDTRESET;
>> -               regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, value);
>> -
>> -               regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &value);
>> -               value &= ~EXYNOS5_SYS_WDTRESET;
>> -               regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, value);
>> -
>> -               exynos_pmu_config = exynos5250_pmu_config;
>> -               pr_info("EXYNOS5250 PMU Initialize\n");
>> -       } else {
>> -               pr_info("EXYNOS: PMU not supported\n");
>> +       const struct of_device_id *match;
>> +
>> +       match = of_match_node(exynos_pmu_of_device_ids, np);
>> +       if (!match) {
>> +               pr_err("fail to get matching of_match struct\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
>> +       pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
>> +                       "samsung,syscon-phandle");
>> +
>> +       if (IS_ERR(pmu_context->pmu_regmap)) {
>> +               pr_err("failed to find exynos_pmu_regmap\n");
>> +               return PTR_ERR(pmu_context->pmu_regmap);
>>          }
>>
>> +       if (pmu_context->pmu_data->pmu_init)
>> +               pmu_context->pmu_data->pmu_init();
>> +
>> +       return 0;
>> +};
>> +
>> +static int exynos_pmu_probe(struct platform_device *pdev)
>> +{
>> +       int ret;
>> +       struct device_node *np;
>> +       struct device *dev = &pdev->dev;
>> +
>> +       pmu_context = devm_kzalloc(&pdev->dev,
>> +                       sizeof(struct exynos_pmu_context),
>> +                       GFP_KERNEL);
>> +       if (pmu_context == NULL) {
>> +               dev_err(dev, "Cannot allocate memory.\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, NULL) {
>> +               ret = exynos_pmu_data_init(np);
>> +               if (ret < 0)
>> +                       return ret;
>> +               break;
>> +       }
> Ca we optmize further as below, there by avoiding one more call to
> exynos_pmu_data_init()
>
> =============================================================
>    const struct of_device_id *match;
>        for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, &match) {
>
>        pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
>         pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
>                         "samsung,syscon-phandle");
>
>         if (IS_ERR(pmu_context->pmu_regmap)) {
>                pr_err("failed to find exynos_pmu_regmap\n");
>                 return PTR_ERR(pmu_context->pmu_regmap);
>          }
>
>         if (pmu_context->pmu_data->pmu_init)
>                 pmu_context->pmu_data->pmu_init();
>
>          break;
>      }
> ============================================================

Okay. Let me wait for one or two more days for more review on this,
then in next version I will improve/optimize it further.

In addition to above, since my syscon change has been accepted [1],
I will change function call "syscon_regmap_lookup_by_phandle
passing second parameter as NULL, this will also help us not to add
a property in PMU device node which is pointing back to itself. So I will
also update DT patch series, along with next revision of this patch series.

[1]: https://lkml.org/lkml/2014/4/30/349


>> +
>> +       pmu_context->dev = dev;
>> +
>> +       platform_set_drvdata(pdev, pmu_context);
>> +
>> +       pr_info("Exynos PMU Driver probe done!!!\n");
>> +       return 0;
>> +}
>> +
>> +static int exynos_pmu_suspend(struct device *dev)
>> +{
>> +       /* ToDo: */
>>          return 0;
>>   }
>> -arch_initcall(exynos_pmu_init);
>> +
>> +static int exynos_pmu_resume(struct device *dev)
>> +{
>> +       /* ToDo: */
>> +       return 0;
>> +}
>> +
>> +static const struct dev_pm_ops exynos_pmu_pm = {
>> +       .suspend = exynos_pmu_suspend,
>> +       .resume = exynos_pmu_resume,
>> +};
>> +
>> +static int exynos_pmu_remove(struct platform_device *pdev)
>> +{
>> +       /* nothing to do here */
>> +       return 0;
>> +}
>> +
>> +static struct platform_device *exynos_pmu_pdev;
>> +
>> +static struct platform_driver exynos_pmu_driver = {
>> +       .driver  = {
>> +               .name   = "exynos-pmu",
>> +               .owner  = THIS_MODULE,
>> +               .pm     = &exynos_pmu_pm,
>> +       },
>> +       .probe = exynos_pmu_probe,
>> +       .remove = exynos_pmu_remove,
>> +};
>> +
>> +static int __init exynos_pmu_of_init(void)
>> +{
>> +       int ret;
>> +
>> +       ret = platform_driver_register(&exynos_pmu_driver);
>> +       if (ret < 0)
>> +               goto out;
>> +
>> +       exynos_pmu_pdev = platform_device_register_simple("exynos-pmu", -1,
>> +                       NULL, 0);
>> +
>> +       if (IS_ERR(exynos_pmu_pdev)) {
>> +               ret = PTR_ERR(exynos_pmu_pdev);
>> +               goto out1;
>> +       }
>> +
>> +       return 0;
>> +out1:
>> +       platform_driver_unregister(&exynos_pmu_driver);
>> +out:
>> +       return ret;
>> +}
>> +arch_initcall(exynos_pmu_of_init);
>> +
>> +static void __exit exynos_pmu_exit(void)
>> +{
>> +       platform_device_unregister(exynos_pmu_pdev);
>> +       platform_driver_unregister(&exynos_pmu_driver);
>> +}
>> +module_exit(exynos_pmu_exit);
>> +
>> +MODULE_AUTHOR("Pankaj Dubey <pankaj.dubey@samsung.com");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("EXYNOS Power Management Unit Driver");
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best Regards,
Pankaj Dubey

