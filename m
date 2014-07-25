Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaGYEEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:04:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12085 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGYEEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:04:41 -0400
X-AuditID: cbfee68f-b7fef6d000003970-ee-53d1d7576379
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
 <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com>
Subject: RE: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Fri, 25 Jul 2014 13:04:39 +0900
Message-id: <067501cfa7bd$8e6cb460$ab461d20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC8Xg2wTqZTg6oaD/ugBpVTcwknCgI5HA+5ncT16gA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zA93w6xeDDX7OMbdYNukum8X3XV/Y
	LTY9vsZqcXnXHDaLGef3MVncvsxr8enof1aLRVuBkutnvGax6FjGaHHz2XYmB26PluYeNo/N
	S+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PlvBPsBTudK96e/czUwPjDrIuRk0NCwETi
	/vMdzBC2mMSFe+vZuhi5OIQEljFKzOm+yg5TtGH/NSaIxHRGiR+LZjJCOH8ZJXbNegnWziag
	IXH4/TN2kISIwAxGickfnrCCOMwCCxklnt09ywLR0s4ocWbrZzaQFk4BT4m991eCLREWCJWY
	tfMcE4jNIqAq8bbnE9hYXgFLiYPzJjFC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zFuoLBYkd
	Z1+D1YsIWEmc3r2JEaJGRGLfi3dgd0sINHJIvJ3SCbVMQOLb5ENAQzmAErISmw5AzZGUOLji
	BssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJL77dzDe
	PWB9iDEZaP1EZinR5HxgesgriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYyLinZktbW9T958UrOkZvMa7a8J/ovM9Oy379vr8/JVq5HN04TTH7Jz
	p4mlmV9mWrVph2ae4GVrFZnvZW4WgpxKIqF5xoe92ZffyBFsPl4etv3igak79KPF+ifcuqOm
	Z76tasXbFB57LaPNLAc2tFXxX477NfNw599Wz8LzH4S+Wzw1WfXM31uJpTgj0VCLuag4EQCP
	rTxkBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd3w6xeDDf43G1ksm3SXzeL7ri/s
	FpseX2O1uLxrDpvFjPP7mCxuX+a1+HT0P6vFoq1AyfUzXrNYdCxjtLj5bDuTA7dHS3MPm8fm
	JfUefVtWMXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA3STkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj5bwT
	7AU7nSvenv3M1MD4w6yLkZNDQsBEYsP+a0wQtpjEhXvr2boYuTiEBKYzSvxYNJMRwvnLKLFr
	1ktmkCo2AQ2Jw++fsYMkRARmMEpM/vCEFcRhFljIKPHs7lkWiJZ2RokzWz+zgbRwCnhK7L2/
	kh3EFhYIlZi18xzYQhYBVYm3PZ/AxvIKWEocnDeJEcIWlPgx+R4LiM0soCWxfudxJghbXmLz
	mrfMEMcqSOw4+xqsXkTASuL07k2MEDUiEvtevGOcwCg0C8moWUhGzUIyahaSlgWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgpPHM6kdjCsbLA4xCnAwKvHwdtRfDBZiTSwrrsw9xCjB
	wawkwnvrMFCINyWxsiq1KD++qDQntfgQoynQpxOZpUST84GJLa8k3tDYxMzI0sjMwsjE3FxJ
	nPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA6PZxjdyLtobDKe92JvI0CT4pDCkxl4k8/wC6we3
	El1bxV7NyFL7obyk9qjSK/G5N1MzXvPdbpjidK/WZvGpybZm01+3bvFcdTu8evfl0zfWxjS/
	Vfu5V33OjAD78jnRC3denXplyVrPR1vEN52fqbHK9a2u2uxPoXxevDW/b5xKStx790RGgXOM
	EktxRqKhFnNRcSIAr6VdxDQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pankaj Dubey wrote:
> 
> This patch modifies Exynos Power Management Unit (PMU) initialization
> implementation in following way:
> 
> - Added platform driver support and probe function where Exynos PMU
>   driver will register itself as syscon provider with syscon framework.
> - Added platform struct exynos_pmu_data to hold platform specific data.
> - For each SoC's PMU support now we can add platform data and statically
>   bind PMU configuration and SoC specific initialization function.
> - Separate each SoC's PMU initialization function and make it as part of
>   platform data.
> - It also removes uses of soc_is_exynosXYZ().
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/Kconfig |    1 +
>  arch/arm/mach-exynos/pmu.c   |  185 +++++++++++++++++++++++++++++++++---------
>  2 files changed, 146 insertions(+), 40 deletions(-)
> 
Looks good to me, will apply this and 4/4.

Thanks,
Kukjin

> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 8f9b66c..a2944ac 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -24,6 +24,7 @@ menuconfig ARCH_EXYNOS
>  	select PM_GENERIC_DOMAINS if PM_RUNTIME
>  	select S5P_DEV_MFC
>  	select SRAM
> +	select MFD_SYSCON
>  	help
>  	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
> 
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index ff9d23f..5b76728 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
> + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
>   *		http://www.samsung.com/
>   *
>   * EXYNOS - CPU PMU(Power Management Unit) support
> @@ -10,12 +10,28 @@
>   */
> 
>  #include <linux/io.h>
> -#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> 
>  #include "common.h"
>  #include "regs-pmu.h"
> 
> -static const struct exynos_pmu_conf *exynos_pmu_config;
> +struct exynos_pmu_data {
> +	const struct exynos_pmu_conf *pmu_config;
> +	const struct exynos_pmu_conf *pmu_config_extra;
> +
> +	void (*pmu_init)(void);
> +	void (*powerdown_conf)(enum sys_powerdown);
> +};
> +
> +struct exynos_pmu_context {
> +	struct device *dev;
> +	const struct exynos_pmu_data *pmu_data;
> +};
> +
> +static struct exynos_pmu_context *pmu_context;
> 
>  static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>  	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
> @@ -335,7 +351,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>  	EXYNOS5_ISP_ARM_OPTION,
>  };
> 
> -static void exynos5_init_pmu(void)
> +static void exynos5_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
>  	unsigned int tmp;
> @@ -372,51 +388,140 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>  {
>  	unsigned int i;
> 
> -	if (soc_is_exynos5250())
> -		exynos5_init_pmu();
> +	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> 
> -	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> -		pmu_raw_writel(exynos_pmu_config[i].val[mode],
> -				exynos_pmu_config[i].offset);
> +	if (pmu_data->powerdown_conf)
> +		pmu_data->powerdown_conf(mode);
> 
> -	if (soc_is_exynos4412()) {
> -		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END ; i++)
> -			pmu_raw_writel(exynos4412_pmu_config[i].val[mode],
> -					exynos4412_pmu_config[i].offset);
> +	if (pmu_data->pmu_config) {
> +		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
> +			pmu_raw_writel(pmu_data->pmu_config[i].val[mode],
> +					pmu_data->pmu_config[i].offset);
> +	}
> +
> +	if (pmu_data->pmu_config_extra) {
> +		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
> +			pmu_raw_writel(pmu_data->pmu_config_extra[i].val[mode],
> +					pmu_data->pmu_config_extra[i].offset);
>  	}
>  }
> 
> -static int __init exynos_pmu_init(void)
> +static void exynos5250_pmu_init(void)
>  {
>  	unsigned int value;
> +	/*
> +	 * When SYS_WDTRESET is set, watchdog timer reset request
> +	 * is ignored by power management unit.
> +	 */
> +	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
> +
> +	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
> +	value &= ~EXYNOS5_SYS_WDTRESET;
> +	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
> +}
> +
> +static const struct exynos_pmu_data exynos4210_pmu_data = {
> +	.pmu_config	= exynos4210_pmu_config,
> +};
> +
> +static const struct exynos_pmu_data exynos4212_pmu_data = {
> +	.pmu_config	= exynos4x12_pmu_config,
> +};
> +
> +static const struct exynos_pmu_data exynos4412_pmu_data = {
> +	.pmu_config		= exynos4x12_pmu_config,
> +	.pmu_config_extra	= exynos4412_pmu_config,
> +};
> +
> +static const struct exynos_pmu_data exynos5250_pmu_data = {
> +	.pmu_config	= exynos5250_pmu_config,
> +	.pmu_init	= exynos5250_pmu_init,
> +	.powerdown_conf	= exynos5_powerdown_conf,
> +};
> +
> +static const struct regmap_config pmu_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +};
> 
> -	exynos_pmu_config = exynos4210_pmu_config;
> -
> -	if (soc_is_exynos4210()) {
> -		exynos_pmu_config = exynos4210_pmu_config;
> -		pr_info("EXYNOS4210 PMU Initialize\n");
> -	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> -		exynos_pmu_config = exynos4x12_pmu_config;
> -		pr_info("EXYNOS4x12 PMU Initialize\n");
> -	} else if (soc_is_exynos5250()) {
> -		/*
> -		 * When SYS_WDTRESET is set, watchdog timer reset request
> -		 * is ignored by power management unit.
> -		 */
> -		value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
> -		value &= ~EXYNOS5_SYS_WDTRESET;
> -		pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
> -
> -		value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
> -		value &= ~EXYNOS5_SYS_WDTRESET;
> -		pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
> -
> -		exynos_pmu_config = exynos5250_pmu_config;
> -		pr_info("EXYNOS5250 PMU Initialize\n");
> -	} else {
> -		pr_info("EXYNOS: PMU not supported\n");
> +/*
> + * PMU platform driver and devicetree bindings.
> + */
> +static const struct of_device_id exynos_pmu_of_device_ids[] = {
> +	{
> +		.compatible = "samsung,exynos4210-pmu",
> +		.data = &exynos4210_pmu_data,
> +	}, {
> +		.compatible = "samsung,exynos4212-pmu",
> +		.data = &exynos4212_pmu_data,
> +	}, {
> +		.compatible = "samsung,exynos4412-pmu",
> +		.data = &exynos4412_pmu_data,
> +	}, {
> +		.compatible = "samsung,exynos5250-pmu",
> +		.data = &exynos5250_pmu_data,
> +	},
> +	{ /*sentinel*/ },
> +};
> +
> +static int exynos_pmu_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct device *dev = &pdev->dev;
> +	struct regmap *regmap;
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pmu_base_addr = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(pmu_base_addr))
> +		return PTR_ERR(pmu_base_addr);
> +
> +	pmu_context = devm_kzalloc(&pdev->dev,
> +			sizeof(struct exynos_pmu_context),
> +			GFP_KERNEL);
> +	if (!pmu_context) {
> +		dev_err(dev, "Cannot allocate memory.\n");
> +		return -ENOMEM;
> +	}
> +	pmu_context->dev = dev;
> +
> +	regmap = devm_regmap_init_mmio(dev, pmu_base_addr,
> +					&pmu_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_err(dev, "regmap init failed\n");
> +		return PTR_ERR(regmap);
>  	}
> 
> +	devm_syscon_register(dev, regmap);
> +
> +	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
> +
> +	pmu_context->pmu_data = match->data;
> +
> +	if (pmu_context->pmu_data->pmu_init)
> +		pmu_context->pmu_data->pmu_init();
> +
> +	platform_set_drvdata(pdev, pmu_context);
> +
> +	dev_dbg(dev, "Exynos PMU Driver probe done\n");
>  	return 0;
>  }
> -arch_initcall(exynos_pmu_init);
> +
> +static struct platform_driver exynos_pmu_driver = {
> +	.driver  = {
> +		.name   = "exynos-pmu",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = exynos_pmu_of_device_ids,
> +	},
> +	.probe = exynos_pmu_probe,
> +};
> +
> +static int __init exynos_pmu_init(void)
> +{
> +	return platform_driver_register(&exynos_pmu_driver);
> +
> +}
> +postcore_initcall(exynos_pmu_init);
> --
> 1.7.9.5

