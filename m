Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbaLLHqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:46:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45149 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbaLLHqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:46:05 -0500
X-AuditID: cbfee68f-f791c6d000004834-69-548a9d39b1bb
Message-id: <548A9D27.1000504@samsung.com>
Date: Fri, 12 Dec 2014 13:15:43 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
 <1418285264-21763-2-git-send-email-pankaj.dubey@samsung.com>
 <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com>
In-reply-to: <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkStdybleIwYOVJhZ/Jx1jtzjwZwej
	xf9Hr1ktehdcZbOY8mc5k8Wmx9dYLS7vmsNmMeP8PiaL25d5LVr3HmG3+P7tG5tFxzJGi1W7
	/jA68Hq0NPewefz+NYnRY+esu+wem1Z1snncubaHzWPzknqPvi2rGD22X5vH7PF5k1wAZxSX
	TUpqTmZZapG+XQJXxo1bVxgLfmdWbDl1g72BscG/i5GTQ0LARGJS43wmCFtM4sK99WxdjFwc
	QgJLGSUO9T9lhynatrCLGSIxnVFix6dJUE4rk8SM9nWMIFW8AloSfy82MYPYLAKqEjMa77KB
	2GwCuhJP3s8Fi4sKREhcWTMHql5Q4sfkeywgtoiAusS35cfBVjMLXGORmDj7A1iDsICXxI3N
	t1hBbCGBc4wS526ngdicAsESy6d2gjUzC5hJfHl5mBXClpfYvOYt2HUSAhM5JE7tfcQEcZGA
	xLfJh4AaOIASshKbDjBDvCYpcXDFDZYJjGKzkNw0C8nYWUjGLmBkXsUomlqQXFCclF5krFec
	mFtcmpeul5yfu4kRGNmn/z3r38F494D1IUYBDkYlHt4XqV0hQqyJZcWVuYcYTYGumMgsJZqc
	D0wfeSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCy8
	ffR/F/vdp0Wb5qzMS5PYUTIlZLKIkfV00W/qegcMXM6tFm4/cijj7JQeY/Efb5flPCl8s1h5
	qVl6kKKfi9ekg0/T14Qbhl0+F7lWobNgtUBaIHPTbGFb/tufTx9ZHypz1TDjsxZP1Wk5q5o/
	0xvWr+g91rewROd4R3TypeyHDXaNkxet1lNiKc5INNRiLipOBABvGxkH5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV3LuV0hBt2vNCz+TjrGbnHgzw5G
	i/+PXrNa9C64ymYx5c9yJotNj6+xWlzeNYfNYsb5fUwWty/zWrTuPcJu8f3bNzaLjmWMFqt2
	/WF04PVoae5h8/j9axKjx85Zd9k9Nq3qZPO4c20Pm8fmJfUefVtWMXpsvzaP2ePzJrkAzqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBk3bl1hLPidWbHl1A32BsYG/y5G
	Tg4JAROJbQu7mCFsMYkL99azdTFycQgJTGeU2PFpEjOE08okMaN9HSNIFa+AlsTfi01gHSwC
	qhIzGu+ygdhsAroST97PBYuLCkRIXFkzB6peUOLH5HssILaIgLrEt+XHwTYwC1xjkZg4+wNY
	g7CAl8SNzbdYQWwhgXOMEudup4HYnALBEsundoI1MwuYSXx5eZgVwpaX2LzmLfMERoFZSHbM
	QlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeOZ9A7GVQ0WhxgFOBiVeHhf
	pHaFCLEmlhVX5h5ilOBgVhLh/RsFFOJNSaysSi3Kjy8qzUktPsRoCgyCicxSosn5wJSWVxJv
	aGxibmpsamliYWJmqSTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA6KiS4KFhafOj+PzOlr02
	hz5fux1x+4lxyrOqarO90Q1Zp4LE1t789Mz6mUKtYd/XSwdjstt+2goFRk7e4cX8RF0yap5L
	cc3CWw9+inZEPGNjzLB5N0GML+Gl73eWhQvW7JJmKS7PyJWTrmB2Vg/fcWbxFe1bnEYajHty
	mDI+uHdIZL/cW56hxFKckWioxVxUnAgABMnckjEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Thursday 11 December 2014 11:00 PM, Rob Herring wrote:
> On Thu, Dec 11, 2014 at 2:07 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> Exynos SoCs have Chipid, for identification of product IDs
>> and SoC revisions. This patch intendes to provide initialization
>> code for all these functionalites.
>>
>> This driver usese existing binding for exnos-chipid.
>
> s/usese/uses/
> s/exnos/exynos/
>

I'll fix this.

>>
>> CC: Grant Likely <grant.likely@linaro.org>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/soc/Kconfig                    |   1 +
>>   drivers/soc/Makefile                   |   1 +
>>   drivers/soc/samsung/Kconfig            |  14 +++
>>   drivers/soc/samsung/Makefile           |   1 +
>>   drivers/soc/samsung/exynos-chipid.c    | 168 +++++++++++++++++++++++++++++++++
>>   include/linux/soc/samsung/exynos-soc.h |  51 ++++++++++
>>   6 files changed, 236 insertions(+)
>>   create mode 100644 drivers/soc/samsung/Kconfig
>>   create mode 100644 drivers/soc/samsung/Makefile
>>   create mode 100644 drivers/soc/samsung/exynos-chipid.c
>>   create mode 100644 include/linux/soc/samsung/exynos-soc.h
>>
>> diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
>> index 76d6bd4..c3abfbe 100644
>> --- a/drivers/soc/Kconfig
>> +++ b/drivers/soc/Kconfig
>> @@ -1,6 +1,7 @@
>>   menu "SOC (System On Chip) specific Drivers"
>>
>>   source "drivers/soc/qcom/Kconfig"
>> +source "drivers/soc/samsung/Kconfig"
>>   source "drivers/soc/ti/Kconfig"
>>   source "drivers/soc/versatile/Kconfig"
>>
>> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
>> index 063113d..620366f 100644
>> --- a/drivers/soc/Makefile
>> +++ b/drivers/soc/Makefile
>> @@ -3,6 +3,7 @@
>>   #
>>
>>   obj-$(CONFIG_ARCH_QCOM)                += qcom/
>> +obj-$(CONFIG_SOC_SAMSUNG)      += samsung/
>>   obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>>   obj-$(CONFIG_SOC_TI)           += ti/
>>   obj-$(CONFIG_PLAT_VERSATILE)   += versatile/
>> diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
>> new file mode 100644
>> index 0000000..2d83652
>> --- /dev/null
>> +++ b/drivers/soc/samsung/Kconfig
>> @@ -0,0 +1,14 @@
>> +#
>> +# SAMSUNG SoC drivers
>> +#
>> +menu "Samsung SOC driver support"
>> +
>> +config SOC_SAMSUNG
>> +       bool
>> +
>> +config EXYNOS_CHIPID
>> +       bool
>> +       depends on ARCH_EXYNOS
>> +       select SOC_BUS
>
> This is going to show an empty menu when ARCH_EXYNOS is not enabled.
> The whole menu should probably have "if ARCH_EXYNOS" instead.
>

OK, I can add 'depends on ARCH_EXYNOS' for menu above so that it should 
not show empty menu option if ARCH_EXNOS is not enabled.

>> +
>> +endmenu
>> diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
>> new file mode 100644
>> index 0000000..855ca05
>> --- /dev/null
>> +++ b/drivers/soc/samsung/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_EXYNOS_CHIPID)    += exynos-chipid.o
>> diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
>> new file mode 100644
>> index 0000000..8968f83
>> --- /dev/null
>> +++ b/drivers/soc/samsung/exynos-chipid.c
>> @@ -0,0 +1,168 @@
>> +/*
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com/
>> + *
>> + * EXYNOS - CHIP ID support
>> + * Author: Pankaj Dubey <pankaj.dubey@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/sys_soc.h>
>> +#include <linux/soc/samsung/exynos-soc.h>
>> +
>> +#define EXYNOS_SUBREV_MASK     (0xF << 4)
>> +#define EXYNOS_MAINREV_MASK    (0xF << 0)
>> +#define EXYNOS_REV_MASK                (EXYNOS_SUBREV_MASK | EXYNOS_MAINREV_MASK)
>> +
>> +static void __iomem *exynos_chipid_base;
>> +
>> +struct exynos_chipid_info exynos_soc_info;
>> +EXPORT_SYMBOL(exynos_soc_info);
>
> The soc_device already has similar data.Why is this needed? Is it
> temporary for compatibility?

struct soc_device_attribute can hold these two (product_id, and 
revision) but they are defined as char * in soc_device_atttribute, and I 
feel it's more specific for exposing via sysfs.
Also existing code in mach-exynos compares them via product_id/revision 
macros, so I can say to keep compatibility.

> For early use?

Yes, partially correct. These parameters will be required in during 
early boot, from mach-exynos/platsmp.c, by that time probe of chipid 
would not have happened. But usage of this is not limited to early 
users, even mach-exynos/pm.c will use this later any point of time.
Since there are early users I added "exynos_chipid_early_init" which 
will be called via mach-exynos.c at very early stage [1].

[1]: https://lkml.org/lkml/2014/12/11/47


> If for early use, then it
> should not be exported.

Other reason to make and expose this structure was we can see that other 
fields of chipid bank (other than product_id and revision, which is not 
part of this patch as of now) can be used by other driver such as ASV 
(which is not yet part of mainline but is there for every exynos SoC).

I do not exported this in my PATCH v4 [2] of this, and instead provided 
exposed functions to directly access product_id and revision, but 
sometime in future when we will need other fields of chipid bank, we 
will end-up adding new exported function for each new field, so decided 
to expose this structure itself.

[2]: http://www.spinics.net/lists/linux-samsung-soc/msg39913.html

>
>
>> +
>> +static const char * __init product_id_to_name(unsigned int product_id)
>> +{
>> +       const char *soc_name;
>> +       unsigned int soc_id = product_id & EXYNOS_SOC_MASK;
>> +
>> +       switch (soc_id) {
>> +       case EXYNOS3250_SOC_ID:
>> +               soc_name = "EXYNOS3250";
>> +               break;
>> +       case EXYNOS4210_SOC_ID:
>> +               soc_name = "EXYNOS4210";
>> +               break;
>> +       case EXYNOS4212_SOC_ID:
>> +               soc_name = "EXYNOS4212";
>> +               break;
>> +       case EXYNOS4412_SOC_ID:
>> +               soc_name = "EXYNOS4412";
>> +               break;
>> +       case EXYNOS4415_SOC_ID:
>> +               soc_name = "EXYNOS4415";
>> +               break;
>> +       case EXYNOS5250_SOC_ID:
>> +               soc_name = "EXYNOS5250";
>> +               break;
>> +       case EXYNOS5260_SOC_ID:
>> +               soc_name = "EXYNOS5260";
>> +               break;
>> +       case EXYNOS5420_SOC_ID:
>> +               soc_name = "EXYNOS5420";
>> +               break;
>> +       case EXYNOS5440_SOC_ID:
>> +               soc_name = "EXYNOS5440";
>> +               break;
>> +       case EXYNOS5800_SOC_ID:
>> +               soc_name = "EXYNOS5800";
>> +               break;
>> +       default:
>> +               soc_name = "UNKNOWN";
>> +       }
>> +       return soc_name;
>> +}
>> +
>> +static const struct of_device_id of_exynos_chipid_ids[] __initconst = {
>> +       {
>> +               .compatible     = "samsung,exynos4210-chipid",
>> +       },
>> +       {},
>> +};
>> +
>> +/**
>> + *  exynos_chipid_early_init: Early chipid initialization
>> + *  @dev: pointer to chipid device
>> + */
>> +void __init exynos_chipid_early_init(struct device *dev)
>> +{
>> +       struct device_node *np;
>> +       const struct of_device_id *match;
>> +
>> +       if (exynos_chipid_base)
>> +               return;
>> +
>> +       if (!dev)
>> +               np = of_find_matching_node_and_match(NULL,
>> +                       of_exynos_chipid_ids, &match);
>> +       else
>> +               np = dev->of_node;
>> +
>> +       if (!np)
>> +               panic("%s, failed to find chipid node\n", __func__);
>
> Do you really want to halt booting here?

Since some critical configuration are done in platsmp.c based on 
product_id and revision, I don't see any point moving ahead without it.
Even if we allow to continue here it will crash or lead to system 
malfunction later during system boot for existing SoC support.

Your console may not be up to
> see the panic anyway.

I feel this we can still see via earlyprintk.

>
>> +
>> +       exynos_chipid_base = of_iomap(np, 0);
>
> Once you read the rev and product_id, do you need to keep the mapping?
>

OK. I can unmap it, once all fields are read.

>> +
>> +       if (!exynos_chipid_base)
>> +               panic("%s: failed to map registers\n", __func__);
>> +
>> +       exynos_soc_info.product_id  = __raw_readl(exynos_chipid_base);
>> +       exynos_soc_info.revision = exynos_soc_info.product_id & EXYNOS_REV_MASK;
>> +}
>> +
>> +static int __init exynos_chipid_probe(struct platform_device *pdev)
>> +{
>> +       struct soc_device_attribute *soc_dev_attr;
>> +       struct soc_device *soc_dev;
>> +       struct device_node *root;
>> +       int ret;
>> +
>> +       exynos_chipid_early_init(&pdev->dev);
>> +
>> +       soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
>> +       if (!soc_dev_attr)
>> +               return -ENODEV;
>> +
>> +       soc_dev_attr->family = "Samsung Exynos";
>> +
>> +       root = of_find_node_by_path("/");
>> +       ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
>> +       of_node_put(root);
>> +       if (ret)
>> +               goto free_soc;
>
> Should a lack of model really be a reason to not load the soc_device?

No. I can make it optional and initialize machine with some default value.

>
>> +
>> +       soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d",
>> +                                       exynos_soc_info.revision);
>> +       if (!soc_dev_attr->revision)
>> +               goto free_soc;
>> +
>> +       soc_dev_attr->soc_id = product_id_to_name(exynos_soc_info.product_id);
>> +
>> +       soc_dev = soc_device_register(soc_dev_attr);
>> +       if (IS_ERR(soc_dev))
>> +               goto free_rev;
>> +
>> +       soc_device_to_device(soc_dev);
>> +
>> +       dev_info(&pdev->dev, "Exynos: CPU[%s] CPU_REV[0x%x] Detected\n",
>> +                       product_id_to_name(exynos_soc_info.product_id),
>> +                       exynos_soc_info.revision);
>> +       return 0;
>> +free_rev:
>> +       kfree(soc_dev_attr->revision);
>> +free_soc:
>> +       kfree(soc_dev_attr);
>> +       return -EINVAL;
>> +}
>> +
>> +static struct platform_driver exynos_chipid_driver __initdata = {
>> +       .driver = {
>> +               .name = "exynos-chipid",
>> +               .of_match_table = of_exynos_chipid_ids,
>> +       },
>> +       .probe = exynos_chipid_probe,
>> +};
>> +
>> +static int __init exynos_chipid_init(void)
>> +{
>> +       return platform_driver_register(&exynos_chipid_driver);
>> +}
>> +core_initcall(exynos_chipid_init);
>> +
>> diff --git a/include/linux/soc/samsung/exynos-soc.h b/include/linux/soc/samsung/exynos-soc.h
>> new file mode 100644
>> index 0000000..d2d9f05
>> --- /dev/null
>> +++ b/include/linux/soc/samsung/exynos-soc.h
>> @@ -0,0 +1,51 @@
>> +/*
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Header for EXYNOS SoC Chipid support
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __EXYNOS_SOC_H
>> +#define __EXYNOS_SOC_H
>> +
>> +#define EXYNOS3250_SOC_ID      0xE3472000
>> +#define EXYNOS4210_SOC_ID      0x43210000
>> +#define EXYNOS4212_SOC_ID      0x43220000
>> +#define EXYNOS4412_SOC_ID      0xE4412000
>> +#define EXYNOS4415_SOC_ID      0xE4415000
>> +#define EXYNOS5250_SOC_ID      0x43520000
>> +#define EXYNOS5260_SOC_ID      0xE5260000
>> +#define EXYNOS5410_SOC_ID      0xE5410000
>> +#define EXYNOS5420_SOC_ID      0xE5420000
>> +#define EXYNOS5440_SOC_ID      0xE5440000
>> +#define EXYNOS5800_SOC_ID      0xE5422000
>> +
>> +#define EXYNOS_SOC_MASK                0xFFFFF000
>> +
>> +#define EXYNOS4210_REV_0       0x0
>> +#define EXYNOS4210_REV_1_0     0x10
>> +#define EXYNOS4210_REV_1_1     0x11
>> +
>> +/**
>> + * Struct exynos_chipid_info
>> + * @soc_product_id: product id allocated to exynos SoC
>> + * @soc_revision: revision of exynos SoC
>> + */
>> +
>> +struct exynos_chipid_info {
>> +       u32 product_id;
>> +       u32 revision;
>> +};
>
> Exposing this struct kernel wide in an SOC specific way concerns me. I
> would not like to see this done on every SOC family. That would become
> a mess.
>

As of today chip-id can live up by exposing two APIs for getting 
product_id and revision, but in future when we need to access other 
fields we may end up adding new exported functions/extern functions. We 
had a discussion about it in Patch V4 [3].

[3]: https://lkml.org/lkml/2014/12/10/748


Thanks,
Pankaj Dubey
> Rob
>
