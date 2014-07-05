Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbaGEHJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 03:09:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60590 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbaGEHJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 03:09:02 -0400
X-AuditID: cbfee68f-b7fef6d000003970-4e-53b7a48baa34
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-5-git-send-email-pankaj.dubey@samsung.com>
 <53B198EB.80502@samsung.com>
In-reply-to: <53B198EB.80502@samsung.com>
Subject: RE: [PATCH v5 4/5] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Sat, 05 Jul 2014 12:39:41 +0530
Message-id: <001e01cf9820$18f29440$4ad7bcc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9JhWRh3pvFez7a+k3zuvbSuvV7QIDPskAAtcgSVWZjxeRsA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkTrd7yfZgg0ONJhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8X6Ga9ZLDqWMVrcfLadyYHbo6W5h81j
	85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4+mMda8EHz4p9tyYzNjAetexi5OSQEDCR
	mNXfyw5hi0lcuLeerYuRi0NIYCmjxKpnM4ESHGBFx2+wQ8QXMUqc2/2TFcL5yyix78xNVpBu
	NgFdiSfv5zKDJEQE+hklZjeeAxvFLLCEUWLPjFOMEC3LGCWeT17JBtLCKaAp8XP6dLDlwgKh
	Elf3nAQbxSKgKrGucyFYnFfAUuLbsWNQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZYZ4QkFi
	x9nXjCC2iICTxIzXE6FqxCUmPXgI9oSEQCOHxIvfH9gglglIfJt8iAXiUVmJTQeg5khKHFxx
	g2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGN2n/z3r
	38F494D1IcZkoPUTmaVEk/OBySGvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKASN8Qvga9RmX35xuZ58aG/725MQb5cd+NVWk3BcJeZmS8q02tPJ5
	cdymjzULSy3uPVj7y1vzc0pXpN4s30yzw95hx62W8CxR2fObf+XZN5NtFv5fWX8wIHTV06gX
	M3I+Md9rbtusEXDrk14J9+O+9fw1mbfFcxYvX9XJrbG7/sxjxpj+Mz/5c5crsRRnJBpqMRcV
	JwIADs9jwwQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd3uJduDDc51a1ksm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsehYxmhx89l2Jgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtEf
	61gLPnhW7Ls1mbGB8ahlFyMHh4SAicTxG+xdjJxAppjEhXvr2boYuTiEBBYxSpzb/ZMVwvnL
	KLHvzE1WkCo2AV2JJ+/nMoMkRAT6GSVmN54Da2EWWMIosWfGKUaIlmWMEs8nr2QDaeEU0JT4
	OX062BJhgVCJq3tOgo1iEVCVWNe5ECzOK2Ap8e3YMShbUOLH5HssIDazgJbE+p3HmSBseYnN
	a94yQxyrILHj7GtGEFtEwElixuuJUDXiEpMePGSfwCg0C8moWUhGzUIyahaSlgWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxglPHM6kdjCsbLA4xCnAwKvHwVpzYFizEmlhWXJl7iFGC
	g1lJhLd08fZgId6UxMqq1KL8+KLSnNTiQ4ymQJ9OZJYSTc4HprW8knhDYxNzU2NTSxMLEzNL
	JXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2M4k477187GJ61ZjN71xNhkas28Td0v7bY+Jfn
	/pmxT3GZvVbMYq/PH5kOTnR/6q5t2qv/+FnjDrmW7RdTTWN9Zz84dVJac9W1ZwKrYxJ7O16n
	Pdj9OnG3ztM3X1pnPV29zbYzqr0xw1sk1Oiz5MKk/UobDzOY/dETMKi947nsZ39Xm9PZ9Umx
	SizFGYmGWsxFxYkArGpQNzMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Monday, June 30, 2014 Tomasz Figa wrote:
> Hi Pankaj,
> 
> Please see my comments inline.
> 
> On 25.06.2014 16:03, Pankaj Dubey wrote:
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
> 
> [snip]
> 
> > @@ -93,7 +112,7 @@ static const struct exynos_pmu_conf
> exynos4210_pmu_config[] = {
> >  	{ PMU_TABLE_END,},
> >  };
> >
> > -static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
> > +static const struct exynos_pmu_conf exynos4212_pmu_config[] = {
> 
> Why the name change?

OK, looks like by mistake I replaced all exynos4x12 with exynos4212, I will
correct this.

> 
> >  	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
> >  	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
> >  	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
> > @@ -335,7 +354,7 @@ static unsigned int const
exynos5_list_diable_wfi_wfe[] =
> {
> >  	EXYNOS5_ISP_ARM_OPTION,
> >  };
> >
> > -static void exynos5_init_pmu(void)
> > +static void exynos5_powerdown_conf(enum sys_powerdown mode)
> >  {
> >  	unsigned int i;
> >  	unsigned int tmp;
> > @@ -372,51 +391,151 @@ void exynos_sys_powerdown_conf(enum
> > sys_powerdown mode)  {
> >  	unsigned int i;
> >
> > -	if (soc_is_exynos5250())
> > -		exynos5_init_pmu();
> > +	struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
> > +
> > +	if (!pmu_data)
> > +		return;
> >
> > -	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
> > -		__raw_writel(exynos_pmu_config[i].val[mode],
> > -				pmu_base_addr +
exynos_pmu_config[i].offset);
> > +	if (pmu_data->powerdown_conf)
> > +		pmu_data->powerdown_conf(mode);
> >
> > -	if (soc_is_exynos4412()) {
> > -		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END
;
> i++)
> > -			__raw_writel(exynos4412_pmu_config[i].val[mode],
> > -				pmu_base_addr +
exynos4412_pmu_config[i].offset);
> > +	if (pmu_data->pmu_config) {
> > +		for (i = 0; (pmu_data->pmu_config[i].offset !=
PMU_TABLE_END)
> ; i++)
> > +			__raw_writel(pmu_data->pmu_config[i].val[mode],
> > +					pmu_base_addr + pmu_data-
> >pmu_config[i].offset);
> 
> Analogically to patch 2/5, you could add static inline accessors and use
them instead
> of adding pmu_base_addr every time.
> 

OK. 

> > +	}
> > +
> > +	if (pmu_data->pmu_config_extra) {
> > +		for (i = 0; pmu_data->pmu_config_extra[i].offset !=
> PMU_TABLE_END; i++)
> > +
__raw_writel(pmu_data->pmu_config_extra[i].val[mode],
> > +					pmu_base_addr + pmu_data-
> >pmu_config_extra[i].offset);
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
> > +	value = __raw_readl(pmu_base_addr +
> EXYNOS5_AUTO_WDTRESET_DISABLE);
> > +	value &= ~EXYNOS5_SYS_WDTRESET;
> > +	__raw_writel(value, pmu_base_addr +
> EXYNOS5_AUTO_WDTRESET_DISABLE);
> > +
> > +	value = __raw_readl(pmu_base_addr +
> EXYNOS5_MASK_WDTRESET_REQUEST);
> > +	value &= ~EXYNOS5_SYS_WDTRESET;
> > +	__raw_writel(value, pmu_base_addr +
> EXYNOS5_MASK_WDTRESET_REQUEST);
> > +}
> > +
> > +static struct exynos_pmu_data exynos4210_pmu_data = {
> 
> static const struct
> 
> > +	.pmu_config	= exynos4210_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos4212_pmu_data = {
> 
> static const struct
> 
> > +	.pmu_config	= exynos4212_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos4412_pmu_data = {
> 
> static const struct
> 
> > +	.pmu_config		= exynos4212_pmu_config,
> > +	.pmu_config_extra	= exynos4412_pmu_config,
> > +};
> > +
> > +static struct exynos_pmu_data exynos5250_pmu_data = {
> 
> static const struct
>

Ok, will make all of them const.
 
> > +	.pmu_config	= exynos5250_pmu_config,
> > +	.pmu_init	= exynos5250_pmu_init,
> > +	.powerdown_conf	= exynos5_powerdown_conf,
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
> > -		value = __raw_readl(pmu_base_addr +
> EXYNOS5_AUTO_WDTRESET_DISABLE);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		__raw_writel(value, pmu_base_addr +
> EXYNOS5_AUTO_WDTRESET_DISABLE);
> > -
> > -		value = __raw_readl(pmu_base_addr +
> EXYNOS5_MASK_WDTRESET_REQUEST);
> > -		value &= ~EXYNOS5_SYS_WDTRESET;
> > -		__raw_writel(value, pmu_base_addr +
> EXYNOS5_MASK_WDTRESET_REQUEST);
> > -
> > -		exynos_pmu_config = exynos5250_pmu_config;
> > -		pr_info("EXYNOS5250 PMU Initialize\n");
> > -	} else {
> > -		pr_info("EXYNOS: PMU not supported\n");
> > +static struct regmap_config pmu_regmap_config = {
> 
> static const struct
> 
> > +	.reg_bits = 32,
> > +	.val_bits = 32,
> > +	.reg_stride = 4,
> > +};
> > +
> > +/*
> > + * PMU platform driver and devicetree bindings.
> > + */
> > +static struct of_device_id exynos_pmu_of_device_ids[] = {
> 
> static const struct
> 
> > +	{
> > +		.compatible = "samsung,exynos4210-pmu",
> > +		.data = (void *)&exynos4210_pmu_data,
> 
> No need for the cast.
> 
> > +	},
> > +	{
> 
> nit: You could place both parentheses in the same line, i.e.
> 
> 	}, {
> 
> > +		.compatible = "samsung,exynos4212-pmu",
> > +		.data = (void *)&exynos4212_pmu_data,
> 
> Ditto.
> 
> > +	},
> > +	{
> > +		.compatible = "samsung,exynos4412-pmu",
> > +		.data = (void *)&exynos4412_pmu_data,
> 
> Ditto.
> 
> > +	},
> > +	{
> > +		.compatible = "samsung,exynos5250-pmu",
> > +		.data = (void *)&exynos5250_pmu_data,
> 
> Ditto.
> 

Ok, will remove these.

> > +	},
> > +	{},
> 
> It is a good practice to put a comment inside the sentinel, e.g.
> 
> 	{ /* sentinel */ }
> 
> > +};
> > +
> > +static int exynos_pmu_probe(struct platform_device *pdev) {
> > +	const struct of_device_id *match;
> > +	struct device *dev = &pdev->dev;
> > +	struct regmap *regmap;
> > +	struct resource *res;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENOENT;
> 
> No need to check this here, if you use devm_ioremap_resource() instead.
> 
> > +
> > +	pmu_base_addr = devm_ioremap(dev, res->start, resource_size(res));
> 
> You could use devm_ioremap_resource() instead. In addition to handling the
resource
> directly without the need to access its internals here, it also checks the
validity of the
> resource pointer.
> 
> > +	if (IS_ERR(pmu_base_addr))
> > +		return PTR_ERR(pmu_base_addr);
> > +
> > +	pmu_context = devm_kzalloc(&pdev->dev,
> > +			sizeof(struct exynos_pmu_context),
> > +			GFP_KERNEL);
> > +
> > +	if (pmu_context == NULL) {
> 
> nit: Extraneous blank line.
> nit: Inconsistent pointer check (!res above, but == NULL here), just use
!ptr
> everywhere, please.

OK.

> 
> > +		dev_err(dev, "Cannot allocate memory.\n");
> > +		return -ENOMEM;
> > +	}
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
> > +	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
> 
> No need to cast if you change all affected pointers to const.
> 

OK.

> > +
> > +	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_init)
> 
> In what conditions pmu_data will be NULL?
>

What if we want driver to be probed but no data has been given?
If driver gets probed it still can act as syscon provider, and other IPs can
access
PMU registers, but PMU functionality itself will not be available, for same
reason
I have put a check for pmu_data in powerdown_conf also.

 
> > +		pmu_context->pmu_data->pmu_init();
> > +
> > +	pmu_context->dev = dev;
> 
> I believe this should be set before calling pmu_init().
> 

OK.

> > +
> > +	platform_set_drvdata(pdev, pmu_context);
> > +
> > +	pr_info("Exynos PMU Driver probe done!!!\n");
> 
> Hurrah, the driver probed! The users won't care, though, and they might
find those
> exclamation marks scary. ;)
> 
> dev_dbg() without those exclamation marks would be more appropriate.
> 

OK.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

