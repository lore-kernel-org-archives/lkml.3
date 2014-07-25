Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaGYFb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:31:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29593 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGYFbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:31:24 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-dd-53d1ebaaf62d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
 <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com>
 <067501cfa7bd$8e6cb460$ab461d20$@samsung.com>
In-reply-to: <067501cfa7bd$8e6cb460$ab461d20$@samsung.com>
Subject: RE: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Fri, 25 Jul 2014 11:02:57 +0530
Message-id: <000501cfa7c9$e59f4840$b0ddd8c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC8Xg2wTqZTg6oaD/ugBpVTcwknCgI5HA+5AVmN/+KdukEf0A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWnfV64vBBs2rpS2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/Vov1M16zWHQsY7S4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXRfX4ea8Eur4qHu46wNDCusO5i5OSQEDCR
	OL2phxHCFpO4cG89WxcjF4eQwFJGiU27dzLCFO29c5MdIjGdUeLKs9NQVX8ZJV43XmEBqWIT
	0JV48n4uM0hCRGAio8TzSR/AWpgFFjJKPLt7lgWiZTujxJ1Tj9lBWjgFrCQ23bnKCmILC4RK
	zNp5jgnEZhFQldi4r40NxOYVsJTY9+UKE4QtKPFj8j2wdcwCWhLrdx5ngrDlJTavecsMcayC
	xI6zr8EOFxFwklh0ZB8zRI24xKQHD8EukhBo5JA49/wXC8QyAYlvkw8B2RxACVmJTQeg5khK
	HFxxg2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRGN+n
	/z3r3cF4+4D1IcZkoPUTmaVEk/OB6SGvJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhnBvZpPPPWru/i5a9I8d5YMzVh2vxlxxh/FwhKvXY3/13u
	yccX9nFxzWPxZWGF0/3LkqfMiv7SY/7rn9cq42m3t2s8U4iN/tOwpamyVlb4SeN/1p/aU85b
	Tzp/JSw49cwKvp1bz/YL5q3/nj7v5DujdZvsLDdv6as52dR5j6f349E+179mTxcpsRRnJBpq
	MRcVJwIAE4gUEwUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd1Vry8GGyw9ImSxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1qsn/GaxaJjGaPFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGd3n
	57EW7PKqeLjrCEsD4wrrLkZODgkBE4m9d26yQ9hiEhfurWfrYuTiEBKYzihx5dlpKOcvo8Tr
	xissIFVsAroST97PZQZJiAhMZJR4PukDO4jDLLCQUeLZ3bMsEC3bGSXunHoMNphTwEpi052r
	rCC2sECoxKyd55hAbBYBVYmN+9rYQGxeAUuJfV+uMEHYghI/Jt8DW8csoCWxfudxJghbXmLz
	mrfMEMcqSOw4+5oRxBYRcJJYdGQfM0SNuMSkBw/ZJzAKzUIyahaSUbOQjJqFpGUBI8sqRtHU
	guSC4qT0XEO94sTc4tK8dL3k/NxNjODk8UxqB+PKBotDjAIcjEo8vB31F4OFWBPLiitzDzFK
	cDArifDKPAAK8aYkVlalFuXHF5XmpBYfYjQF+nQis5Rocj4wseWVxBsam5ibGptamliYmFkq
	ifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamDMtNZWEGKZq/1je7uUE0NHdUjJDmmFE6bm221q
	Dz/ZuOsX49md8lO+WMnlt24z7hZa0D6z/mbTm10JhcZlpsdWXynpzK5arb3ebEWAkVbs32kW
	/+JPvu7m2vqPoaT+WOyJA2y//l58Idmkf+pWjvtztW7Nhun9yV83zLsl8WHd5/U7Z/o5GHxS
	YinOSDTUYi4qTgQASFq+UzQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Friday, July 25, 2014 Kukjin Kim wrote:
> Subject: RE: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for
> Exynos PMU
> 
> Pankaj Dubey wrote:
> >
> > This patch modifies Exynos Power Management Unit (PMU) initialization
> > implementation in following way:
> >
> > - Added platform driver support and probe function where Exynos PMU
> >   driver will register itself as syscon provider with syscon framework.
> > - Added platform struct exynos_pmu_data to hold platform specific data.
> > - For each SoC's PMU support now we can add platform data and statically
> >   bind PMU configuration and SoC specific initialization function.
> > - Separate each SoC's PMU initialization function and make it as part of
> >   platform data.
> > - It also removes uses of soc_is_exynosXYZ().
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  arch/arm/mach-exynos/Kconfig |    1 +
> >  arch/arm/mach-exynos/pmu.c   |  185
> +++++++++++++++++++++++++++++++++---------
> >  2 files changed, 146 insertions(+), 40 deletions(-)
> >
> Looks good to me, will apply this and 4/4.
> 

We need to hold these two patches until dependent patch [1] from Tomasz Figa
gets merged.

[1]: mfd: syscon: Decouple syscon interface from syscon devices
      https://lkml.org/lkml/2014/6/24/188


Thanks,
Pankaj Dubey

> Thanks,
> Kukjin
> 
> > diff --git a/arch/arm/mach-exynos/Kconfig
> > b/arch/arm/mach-exynos/Kconfig index 8f9b66c..a2944ac 100644
> > --- a/arch/arm/mach-exynos/Kconfig
> > +++ b/arch/arm/mach-exynos/Kconfig
> > @@ -24,6 +24,7 @@ menuconfig ARCH_EXYNOS
> >  	select PM_GENERIC_DOMAINS if PM_RUNTIME
> >  	select S5P_DEV_MFC
> >  	select SRAM
> > +	select MFD_SYSCON
> >  	help
> >  	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
> >
> > diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> > index ff9d23f..5b76728 100644
> > --- a/arch/arm/mach-exynos/pmu.c
> > +++ b/arch/arm/mach-exynos/pmu.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
> > + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
> >   *		http://www.samsung.com/
> >   *
> >   * EXYNOS - CPU PMU(Power Management Unit) support @@ -10,12 +10,28
> > @@
> >   */
> >
> >  #include <linux/io.h>
> > -#include <linux/kernel.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <linux/mfd/syscon.h>
> >
> >  #include "common.h"
> >  #include "regs-pmu.h"
> >
> > -static const struct exynos_pmu_conf *exynos_pmu_config;
> > +struct exynos_pmu_data {
> > +	const struct exynos_pmu_conf *pmu_config;
> > +	const struct exynos_pmu_conf *pmu_config_extra;
> > +
> > +	void (*pmu_init)(void);
> > +	void (*powerdown_conf)(enum sys_powerdown); };
> > +
> > +struct exynos_pmu_context {
> > +	struct device *dev;
> > +	const struct exynos_pmu_data *pmu_data; };
> > +
> > +static struct exynos_pmu_context *pmu_context;
> >
> >  static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
> >  	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */ @@ -335,7
> > +351,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
> >  	EXYNOS5_ISP_ARM_OPTION,
> >  };
> >
> > -static void exynos5_init_pmu(void)
> > +static void exynos5_powerdown_conf(enum sys_powerdown mode)
> >  {
> >  	unsigned int i;
> >  	unsigned int tmp;
> > @@ -372,51 +388,140 @@ void exynos_sys_powerdown_conf(enum
> > sys_powerdown mode)  {
> >  	unsigned int i;
> >
> > -	if (soc_is_exynos5250())
> > -		exynos5_init_pmu();
> > +	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> >
> > -	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> > -		pmu_raw_writel(exynos_pmu_config[i].val[mode],
> > -				exynos_pmu_config[i].offset);
> > +	if (pmu_data->powerdown_conf)
> > +		pmu_data->powerdown_conf(mode);
> >
> > -	if (soc_is_exynos4412()) {
> > -		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END
;
> i++)
> > -			pmu_raw_writel(exynos4412_pmu_config[i].val[mode],
> > -					exynos4412_pmu_config[i].offset);
> > +	if (pmu_data->pmu_config) {
> > +		for (i = 0; (pmu_data->pmu_config[i].offset !=
PMU_TABLE_END)
> ; i++)
> > +			pmu_raw_writel(pmu_data->pmu_config[i].val[mode],
> > +					pmu_data->pmu_config[i].offset);
> > +	}
> > +
> > +	if (pmu_data->pmu_config_extra) {
> > +		for (i = 0; pmu_data->pmu_config_extra[i].offset !=
> PMU_TABLE_END; i++)
> > +
pmu_raw_writel(pmu_data->pmu_config_extra[i].val[mode],
> > +
pmu_data->pmu_config_extra[i].offset);
> >  	}
> >  }
> >
> > -static int __init exynos_pmu_init(void)
> > +static void exynos5250_pmu_init(void)
> >  {
> >  	unsigned int value;
> > +	/*
> > +	 * When SYS_WDTRESET is set, watchdog timer reset request
> > +	 * is ignored by power management unit.
> > +	 */
> > +	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
> > +	value &= ~EXYNOS5_SYS_WDTRESET;
> > +	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
> > +
> > +	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
> > +	value &= ~EXYNOS5_SYS_WDTRESET;
> > +	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST); }
> > +
> > +static const struct exynos_pmu_data exynos4210_pmu_data = {
> > +	.pmu_config	= exynos4210_pmu_config,
> > +};
> > +
> > +static const struct exynos_pmu_data exynos4212_pmu_data = {
> > +	.pmu_config	= exynos4x12_pmu_config,
> > +};
> > +
> > +static const struct exynos_pmu_data exynos4412_pmu_data = {
> > +	.pmu_config		= exynos4x12_pmu_config,
> > +	.pmu_config_extra	= exynos4412_pmu_config,
> > +};
> > +
> > +static const struct exynos_pmu_data exynos5250_pmu_data = {
> > +	.pmu_config	= exynos5250_pmu_config,
> > +	.pmu_init	= exynos5250_pmu_init,
> > +	.powerdown_conf	= exynos5_powerdown_conf,
> > +};
> > +
> > +static const struct regmap_config pmu_regmap_config = {
> > +	.reg_bits = 32,
> > +	.val_bits = 32,
> > +	.reg_stride = 4,
> > +};
> >
> > -	exynos_pmu_config = exynos4210_pmu_config;
> > -
> > -	if (soc_is_exynos4210()) {
> > -		exynos_pmu_config = exynos4210_pmu_config;
> > -		pr_info("EXYNOS4210 PMU Initialize\n");
> > -	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> > -		exynos_pmu_config = exynos4x12_pmu_config;
> > -		pr_info("EXYNOS4x12 PMU Initialize\n");
> > -	} else if (soc_is_exynos5250()) {
> > -		/*
> > -		 * When SYS_WDTRESET is set, watchdog timer reset request
> > -		 * is ignored by power management unit.
> > -		 */
> > -		value =
> pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		pmu_raw_writel(value,
> EXYNOS5_AUTO_WDTRESET_DISABLE);
> > -
> > -		value =
> pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		pmu_raw_writel(value,
> EXYNOS5_MASK_WDTRESET_REQUEST);
> > -
> > -		exynos_pmu_config = exynos5250_pmu_config;
> > -		pr_info("EXYNOS5250 PMU Initialize\n");
> > -	} else {
> > -		pr_info("EXYNOS: PMU not supported\n");
> > +/*
> > + * PMU platform driver and devicetree bindings.
> > + */
> > +static const struct of_device_id exynos_pmu_of_device_ids[] = {
> > +	{
> > +		.compatible = "samsung,exynos4210-pmu",
> > +		.data = &exynos4210_pmu_data,
> > +	}, {
> > +		.compatible = "samsung,exynos4212-pmu",
> > +		.data = &exynos4212_pmu_data,
> > +	}, {
> > +		.compatible = "samsung,exynos4412-pmu",
> > +		.data = &exynos4412_pmu_data,
> > +	}, {
> > +		.compatible = "samsung,exynos5250-pmu",
> > +		.data = &exynos5250_pmu_data,
> > +	},
> > +	{ /*sentinel*/ },
> > +};
> > +
> > +static int exynos_pmu_probe(struct platform_device *pdev) {
> > +	const struct of_device_id *match;
> > +	struct device *dev = &pdev->dev;
> > +	struct regmap *regmap;
> > +	struct resource *res;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	pmu_base_addr = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(pmu_base_addr))
> > +		return PTR_ERR(pmu_base_addr);
> > +
> > +	pmu_context = devm_kzalloc(&pdev->dev,
> > +			sizeof(struct exynos_pmu_context),
> > +			GFP_KERNEL);
> > +	if (!pmu_context) {
> > +		dev_err(dev, "Cannot allocate memory.\n");
> > +		return -ENOMEM;
> > +	}
> > +	pmu_context->dev = dev;
> > +
> > +	regmap = devm_regmap_init_mmio(dev, pmu_base_addr,
> > +					&pmu_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_err(dev, "regmap init failed\n");
> > +		return PTR_ERR(regmap);
> >  	}
> >
> > +	devm_syscon_register(dev, regmap);
> > +
> > +	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
> > +
> > +	pmu_context->pmu_data = match->data;
> > +
> > +	if (pmu_context->pmu_data->pmu_init)
> > +		pmu_context->pmu_data->pmu_init();
> > +
> > +	platform_set_drvdata(pdev, pmu_context);
> > +
> > +	dev_dbg(dev, "Exynos PMU Driver probe done\n");
> >  	return 0;
> >  }
> > -arch_initcall(exynos_pmu_init);
> > +
> > +static struct platform_driver exynos_pmu_driver = {
> > +	.driver  = {
> > +		.name   = "exynos-pmu",
> > +		.owner	= THIS_MODULE,
> > +		.of_match_table = exynos_pmu_of_device_ids,
> > +	},
> > +	.probe = exynos_pmu_probe,
> > +};
> > +
> > +static int __init exynos_pmu_init(void) {
> > +	return platform_driver_register(&exynos_pmu_driver);
> > +
> > +}
> > +postcore_initcall(exynos_pmu_init);
> > --
> > 1.7.9.5

