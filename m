Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaFXL1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:27:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10484 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaFXL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:27:32 -0400
X-AuditID: cbfee690-b7fb56d000003439-16-53a960a19a0c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        vikas.sajjan@samsung.com
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-11-git-send-email-pankaj.dubey@samsung.com>
 <53A07719.7050206@samsung.com>
In-reply-to: <53A07719.7050206@samsung.com>
Subject: RE: [PATCH v4 10/11] ARM: EXYNOS: Add platform driver support for
 Exynos PMU.
Date: Tue, 24 Jun 2014 16:58:47 +0530
Message-id: <007a01cf8f9f$7909c850$6b1d58f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFbr3MzJH2VQYc81U++V3sC+P5mXwHxSbcIAc57yfWcSdtvkA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkVndhwspgg/a1hhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wW62e8ZrG4+Ww7kwOHR0tzD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJXx/8cKloJVJRXnmkobGB9FdzFyckgImEg8+NvLDmGLSVy4t56ti5GL
	Q0hgKaPEo3db2WCK5l/dxwSRWMQo8XHiX1aQhJDAX0aJhgl+IDabgK7Ek/dzmUGKRAT6GSVe
	bv0BVsQskCzx6dwPZojulYwSV3f8A0twCmhL3F26BGy3sECExOZPp1hAbBYBVYmz72aC2bwC
	lhLb2w8wQtiCEj8m32OBGKolsX7ncSYIW15i85q3zBCnKkjsOPsarF5EwEnizqeJjBA14hKT
	HjxkBzlCQuAlu8Tf+V+YIJYJSHybfAhoKAdQQlZi0wGoOZISB1fcYJnAKDELyepZSFbPQrJ6
	FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIERu/pf88m7GC8d8D6EGMy0PqJzFKi
	yfnA6M8riTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	Bka25T1fjy9gOxX5+ld7nGB7WO+t3FdcDu5aXsVMH2Lf2C3o4XZ50L2Hs/XDpERO24Yv0V2P
	H7+5PJ170eo4fdXC/XVSZy7PCbTeKpo2RyzkbpdO2QIpmVyHn3sz4zf3SR1+Fbnp5ym+NrsU
	NvviN2VSMYFfvY5yHQtYp61jH7BrvvKEqU/4JiixFGckGmoxFxUnAgCiH1o39AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd2FCSuDDU6cU7dYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WD/jNYvFzWfbmRw4PFqae9g8Ni+p9+jbsorR4/MmuQCW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGf9/rGApWFVSca6ptIHxUXQX
	IyeHhICJxPyr+5ggbDGJC/fWs3UxcnEICSxilPg48S8rSEJI4C+jRMMEPxCbTUBX4sn7ucwg
	RSIC/YwSL7f+ACtiFkiW+HTuBzNE90pGias7/oElOAW0Je4uXcIOYgsLREhs/nSKBcRmEVCV
	OPtuJpjNK2Apsb39ACOELSjxY/I9FoihWhLrdx5ngrDlJTavecsMcaqCxI6zr8HqRQScJO58
	msgIUSMuMenBQ/YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjODU8k97BuKrB4hCjAAejEg9vROCKYCHWxLLiytxDjBIczEoivF/iVgYL8aYkVlalFuXH
	F5XmpBYfYjQF+nQis5Rocj4wbeWVxBsam5ibGptamliYmFkqifMebLUOFBJITyxJzU5NLUgt
	gulj4uCUamB0+PFr05XObc9vxjQ4Pg3vu/AnwC1x8cvZ11g45Co/Lyi3vaqvYrjwwAPmaQld
	WbnbGqdffn1i4+f/Vz9Jzjsqajj9UVjGi+liYi6iXGHTJRgzLPczNTxwutN/Wntz/rPJZ67u
	Cw2uia+O2pHO/6jz/KIQmcZLU/RZvJk68m6taXq9cDb7tteOSizFGYmGWsxFxYkAYfEm2yMD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Tuesday, June 17 2014, Tomasz Figa wrote:
> Hi Pankaj,
> 
> [dropping Young-Gun Jang <yg1004.jang@samsung.com>, as my mailer denies to
> send to this address]
> 

Yes, we can drop Young-Gun Jang's email id as it's no more valid.

> Please see my comments inline. I have skipped comments for changed related
to
> regmap, as according to our previous discussion they will be dropped in
next version.
> 
> On 10.05.2014 08:56, Pankaj Dubey wrote:
> > This patch modifies Exynos Power Management Unit (PMU) initialization
> > implementation in following way:
> >
> > - Added platform_device support by registering static platform device.
> > - Added platform struct exynos_pmu_data to hold platform specific data.
> > - For each SoC's PMU support now we can add platform data and statically
> >   bind PMU configuration and SoC specific initialization function.
> > - Probe function will scan DT and based on matching PMU compatibility
> >   string initialize pmu_context which will be platform_data for driver.
> > - Obtain PMU regmap handle using "syscon_regmap_lookup_by_phandle" so
> >   that we can reduce dependency over machine header files.
> > - Separate each SoC's PMU initialization function and make it as part of
> >   platform data.
> > - It also removes uses of soc_is_exynosXYZ() thus making PMU
implementation
> >   independent of "plat/cpu.h".
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> > ---
> >  arch/arm/mach-exynos/pmu.c |  266
> > ++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 210 insertions(+), 56 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> > index 67116a5..6a7fa8e 100644
> > --- a/arch/arm/mach-exynos/pmu.c
> > +++ b/arch/arm/mach-exynos/pmu.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
> > + * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
> >   *		http://www.samsung.com/
> >   *
> >   * EXYNOS - CPU PMU(Power Management Unit) support @@ -9,20 +9,33
> @@
> >   * published by the Free Software Foundation.
> >   */
> >
> > -#include <linux/io.h>
> > -#include <linux/kernel.h>
> > +#include <linux/module.h>
> >  #include <linux/regmap.h>
> > -
> > -#include <plat/cpu.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/slab.h>
> > +#include <linux/mfd/syscon.h>
> >
> >  #include "common.h"
> >  #include "regs-pmu.h"
> >
> > -static const struct exynos_pmu_conf *exynos_pmu_config; -static
> > struct regmap *pmu_regmap;
> > +struct exynos_pmu_data {
> > +	const struct exynos_pmu_conf *pmu_config;
> > +	const struct exynos_pmu_conf *pmu_config_extra;
> > +	void (*pmu_init)(void);
> > +	void (*powerdown_conf)(enum sys_powerdown); };
> > +
> > +struct exynos_pmu_context {
> > +	struct device *dev;
> > +	struct exynos_pmu_data *pmu_data;
> > +	struct regmap	*pmu_regmap;
> > +};
> > +
> > +static struct exynos_pmu_context	*pmu_context;
> >
> >  static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
> > -	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
> > +	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
> 
> AFAICT those have changed already in patch 08/11.
>

Will correct this.
 
> >  	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
> >  	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
> >  	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
> > @@ -216,7 +229,7 @@ static const struct exynos_pmu_conf
> > exynos4412_pmu_config[] = {  };
> >
> >  static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
> > -	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
> > +	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
> 
> Ditto.
> 
> >  	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2}
> },
> >  	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{
> 0x0, 0x0, 0x0} },
> >  	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{
> 0x0, 0x0, 0x0} },
> > @@ -339,7 +352,7 @@ static unsigned int const
exynos5_list_diable_wfi_wfe[] =
> {
> >  	EXYNOS5_ISP_ARM_OPTION,
> >  };
> >
> > -static void exynos5_init_pmu(void)
> > +void exynos5_powerdown_conf(enum sys_powerdown mode)
> 
> static
> 


OK.

> >  {
> >  	unsigned int i;
> >  	unsigned int tmp;
> > @@ -348,81 +361,222 @@ static void exynos5_init_pmu(void)
> >  	 * Enable both SC_FEEDBACK and SC_COUNTER
> >  	 */
> >  	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
> > -		regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i],
&tmp);
> > +		regmap_read(pmu_context->pmu_regmap,
> > +				exynos5_list_both_cnt_feed[i], &tmp);
> >  		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
> >  			EXYNOS5_USE_SC_COUNTER);
> > -		regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i],
tmp);
> > +		regmap_write(pmu_context->pmu_regmap,
> > +				exynos5_list_both_cnt_feed[i], tmp);
> >  	}
> >
> >  	/*
> >  	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
> >  	 */
> > -	regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION,
> &tmp);
> > +	regmap_read(pmu_context->pmu_regmap,
> EXYNOS5_ARM_COMMON_OPTION,
> > +&tmp);
> >  	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
> > -	regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
> > +	regmap_write(pmu_context->pmu_regmap,
> EXYNOS5_ARM_COMMON_OPTION,
> > +tmp);
> >
> >  	/*
> >  	 * Disable WFI/WFE on XXX_OPTION
> >  	 */
> >  	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
> > -		tmp = regmap_read(pmu_regmap,
exynos5_list_diable_wfi_wfe[i],
> > -				&tmp);
> > +		tmp = regmap_read(pmu_context->pmu_regmap,
> > +				exynos5_list_diable_wfi_wfe[i], &tmp);
> >  		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
> >  			 EXYNOS5_OPTION_USE_STANDBYWFI);
> > -		regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
tmp);
> > +		regmap_write(pmu_context->pmu_regmap,
> > +				exynos5_list_diable_wfi_wfe[i], tmp);
> >  	}
> >  }
> >
> >  void exynos_sys_powerdown_conf(enum sys_powerdown mode)  {
> >  	unsigned int i;
> > +	struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> > +
> > +	if (pmu_data->powerdown_conf)
> > +		pmu_data->powerdown_conf(mode);
> > +
> > +	if (pmu_data->pmu_config) {
> > +		for (i = 0; (pmu_data->pmu_config[i].offset !=
PMU_TABLE_END)
> ; i++)
> > +			regmap_write(pmu_context->pmu_regmap,
> > +					pmu_data->pmu_config[i].offset,
> > +					pmu_data->pmu_config[i].val[mode]);
> > +	}
> > +
> > +	if (pmu_data->pmu_config_extra) {
> > +		for (i = 0; pmu_data->pmu_config_extra[i].offset !=
> PMU_TABLE_END; i++)
> > +			regmap_write(pmu_context->pmu_regmap,
> > +
pmu_data->pmu_config_extra[i].offset,
> > +
pmu_data->pmu_config_extra[i].val[mode]);
> > +	}
> > +}
> > +
> > +static void exynos5250_pmu_init(void) {
> > +	unsigned int tmp;
> > +	struct regmap *pmu_regmap = pmu_context->pmu_regmap;
> > +	/*
> > +	 * When SYS_WDTRESET is set, watchdog timer reset request
> > +	 * is ignored by power management unit.
> > +	 */
> > +	regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
> &tmp);
> > +	tmp &= ~EXYNOS5_SYS_WDTRESET;
> > +	regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
> tmp);
> > +
> > +	regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
> &tmp);
> > +	tmp &= ~EXYNOS5_SYS_WDTRESET;
> > +	regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
> tmp); }
> > +
> > +static struct exynos_pmu_data exynos4210_pmu_data = {
> > +	.pmu_config	= exynos4210_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos4x12_pmu_data = {
> 
> Should be probably called exynos4212_pmu_data.
> 

OK, will update this.

> > +	.pmu_config	= exynos4x12_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos4412_pmu_data = {
> > +	.pmu_config		= exynos4x12_pmu_config,
> > +	.pmu_config_extra	= exynos4412_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos5250_pmu_data = {
> > +	.pmu_config	= exynos5250_pmu_config,
> > +	.pmu_init	= exynos5250_pmu_init,
> > +	.powerdown_conf	= exynos5_powerdown_conf,
> > +};
> > +
> > +/*
> > + * PMU platform driver and devicetree bindings.
> > + */
> > +static struct of_device_id exynos_pmu_of_device_ids[] = {
> > +	{
> > +		.compatible = "samsung,exynos4210-pmu",
> > +		.data = (void *)&exynos4210_pmu_data,
> > +	},
> > +	{
> > +		.compatible = "samsung,exynos4212-pmu",
> > +		.data = (void *)&exynos4x12_pmu_data,
> > +	},
> > +	{
> > +		.compatible = "samsung,exynos4412-pmu",
> > +		.data = (void *)&exynos4412_pmu_data,
> > +	},
> > +	{
> > +		.compatible = "samsung,exynos5250-pmu",
> > +		.data = (void *)&exynos5250_pmu_data,
> > +	},
> > +	{},
> > +};
> > +
> > +static int exynos_pmu_probe(struct platform_device *pdev) {
> > +	struct device_node *np;
> > +	const struct of_device_id *match;
> > +	struct device *dev = &pdev->dev;
> >
> > -	if (soc_is_exynos5250())
> > -		exynos5_init_pmu();
> > +	pmu_context = devm_kzalloc(&pdev->dev,
> > +			sizeof(struct exynos_pmu_context),
> > +			GFP_KERNEL);
> > +	if (pmu_context == NULL) {
> > +		dev_err(dev, "Cannot allocate memory.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	np = of_find_matching_node_and_match(NULL,
> > +			exynos_pmu_of_device_ids, &match);
> > +	if (!np) {
> > +		pr_warn("%s, failed to find PMU node\n", __func__);
> > +		return -ENODEV;
> > +	}
> >
> > -	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> > -		regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
> > -				exynos_pmu_config[i].val[mode]);
> > +	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
> > +	pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
> NULL);
> >
> > -	if (soc_is_exynos4412()) {
> > -		for (i = 0; exynos4412_pmu_config[i].offset !=
PMU_TABLE_END;
> i++)
> > -			regmap_write(pmu_regmap,
exynos4412_pmu_config[i].offset,
> > -					exynos4412_pmu_config[i].val[mode]);
> > +	if (IS_ERR(pmu_context->pmu_regmap)) {
> > +		pr_err("failed to find exynos_pmu_regmap\n");
> > +		return PTR_ERR(pmu_context->pmu_regmap);
> >  	}
> > +
> > +	if (pmu_context->pmu_data->pmu_init)
> > +		pmu_context->pmu_data->pmu_init();
> > +
> > +	pmu_context->dev = dev;
> > +
> > +	platform_set_drvdata(pdev, pmu_context);
> > +
> > +	pr_info("Exynos PMU Driver probe done!!!\n");
> > +	return 0;
> > +}
> > +
> > +static int exynos_pmu_suspend(struct device *dev) {
> > +	/* ToDo: */
> > +	return 0;
> > +}
> > +
> > +static int exynos_pmu_resume(struct device *dev) {
> > +	/* ToDo: */
> > +	return 0;
> >  }
> 
> No need to add those if unused.
> 

OK, will remove this.

> >
> > -static int __init exynos_pmu_init(void)
> > +static const struct dev_pm_ops exynos_pmu_pm = {
> > +	.suspend = exynos_pmu_suspend,
> > +	.resume = exynos_pmu_resume,
> > +};
> 
> You can drop this structure too.
> 

OK.

> > +
> > +static int exynos_pmu_remove(struct platform_device *pdev) {
> > +	/* nothing to do here */
> > +	return 0;
> > +}
> 
> This function as well.

OK.

> 
> > +
> > +static struct platform_device *exynos_pmu_pdev;
> > +
> > +static struct platform_driver exynos_pmu_driver = {
> > +	.driver  = {
> > +		.name   = "exynos-pmu",
> > +		.owner	= THIS_MODULE,
> > +		.pm	= &exynos_pmu_pm,
> > +	},
> > +	.probe = exynos_pmu_probe,
> > +	.remove = exynos_pmu_remove,
> > +};
> > +
> > +static int __init exynos_pmu_of_init(void)
> >  {
> > -	unsigned int value;
> > -
> > -	exynos_pmu_config = exynos4210_pmu_config;
> > -	pmu_regmap = get_exynos_pmuregmap();
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
> > -		regmap_read(pmu_regmap,
> EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		regmap_write(pmu_regmap,
> EXYNOS5_AUTO_WDTRESET_DISABLE, value);
> > -
> > -		regmap_read(pmu_regmap,
> EXYNOS5_MASK_WDTRESET_REQUEST, &value);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		regmap_write(pmu_regmap,
> EXYNOS5_MASK_WDTRESET_REQUEST, value);
> > -
> > -		exynos_pmu_config = exynos5250_pmu_config;
> > -		pr_info("EXYNOS5250 PMU Initialize\n");
> > -	} else {
> > -		pr_info("EXYNOS: PMU not supported\n");
> > +	int ret;
> > +
> > +	ret = platform_driver_register(&exynos_pmu_driver);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	exynos_pmu_pdev = platform_device_register_simple("exynos-pmu", -1,
> > +			NULL, 0);
> 
> Hmm, I don't see the point of making this a platform driver only to
register respective
> platform device few lines below. If you take into account the patch for
syscon I
> posted as a reply to patch 06/11, you will be able to make this a normal
platform
> driver that binds to DT node directly and then register a syscon in probe
function
> above.
> 

Well I updated PMU to be a syscon provider using your patch. It worked well.
I have following two points to mention here:

1: For making PMU a normal platform driver, other than making PMU a syscon
provider we need to change PMU's DT binding. Basically we need to remove
"syscon"
as second compatibility string. I hope this should not be an issue.

2: I can see for your syscon patch Arnd has some comments, hopefully we can
address
his concern.

> > +
> > +	if (IS_ERR(exynos_pmu_pdev)) {
> > +		ret = PTR_ERR(exynos_pmu_pdev);
> > +		goto out1;
> >  	}
> >
> >  	return 0;
> > +out1:
> > +	platform_driver_unregister(&exynos_pmu_driver);
> > +out:
> > +	return ret;
> >  }
> > -arch_initcall(exynos_pmu_init);
> > +arch_initcall(exynos_pmu_of_init);
> 
> Is there a need to change the name?
>

No, I will keep same name.
 
> > +
> > +static void __exit exynos_pmu_exit(void) {
> > +	platform_device_unregister(exynos_pmu_pdev);
> > +	platform_driver_unregister(&exynos_pmu_driver);
> > +}
> > +module_exit(exynos_pmu_exit);
> 
> No need for module_exit() in case of such low level code. It will be
always built-in.
> 

OK, will remove this.

> > +
> > +MODULE_AUTHOR("Pankaj Dubey <pankaj.dubey@samsung.com");
> > +MODULE_LICENSE("GPL v2"); MODULE_DESCRIPTION("EXYNOS
> Power Management
> > +Unit Driver");
> >
> 
> This driver will never be a module, so I don't think there is any need for
those.
> 

OK.

> --
> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

