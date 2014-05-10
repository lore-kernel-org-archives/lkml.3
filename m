Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaEJDdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:33:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20248 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaEJDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:33:12 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-d3-536d9df64371
Message-id: <536DA243.6000600@samsung.com>
Date: Sat, 10 May 2014 12:51:31 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        t.figa@samsung.com, kgene.kim@samsung.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH 1/4] clk: samsung: out: Add infrastructure to register
 CLKOUT
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
 <1399640410-30957-2-git-send-email-tushar.behera@linaro.org>
In-reply-to: <1399640410-30957-2-git-send-email-tushar.behera@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zI91vc3ODDTZ0ylnMP3KO1aL/zUJW
	i3OvVjJa9C64ymax6fE1VovLu+awWcw4v4/JYun1i0wWTydcZLOYMH0ti0Xr3iPsFutnvGax
	aP+7l82B12PNvDWMHpf7epk8Vi7/wuaxaVUnm8eda3vYPDYvqffo27KK0ePzJrkAjigum5TU
	nMyy1CJ9uwSujJ3L/jEXTPCp2LZ9PWMDY4dtFyMnh4SAicT3OQfYIWwxiQv31rN1MXJxCAks
	Y5RoW/2MBaZo2o717BCJ6YwSJ+5/YgVJCAm8ZpS4M18TxOYV0JI4tXA92CQWAVWJC/NBJnFy
	sAnoSjx5P5cZxBYVCJPYNL2PFaJeUOLH5HtgC0QEdCQeLNoLZjMLHGKS6F5iAmILCwRLHNgH
	0guyuJ1R4v+nO2BDOQU8JV71H2OCaLCWWDlpGyOELS+xec1bsAYJgYkcEjc2vWKEuEhA4tvk
	Q0AbOIASshKbDjBDfCYpcXDFDZYJjGKzkNw0C8nYWUjGLmBkXsUomlqQXFCclF5krFecmFtc
	mpeul5yfu4kREtH9OxjvHrA+xJgMtHIis5Rocj4wIeSVxBsamxlZmJqYGhuZW5qRJqwkznv/
	YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZeo3ncn3hKtjNOP/dB1mfj3uk14euePpFj
	+WzrvG6N/wa+U/OOsc26xx4z/eaCmO5b0ZeEjJ5Mti31+mR17vjVVzvSknQMVganzPRm55y0
	peXH7rW+hkfk4iVv1H6oS6g+ekLt2QwXWYWK/sVB6pU73y93yTk7LzF5sUjXoq+hU5fMPHvs
	P9cpJZbijERDLeai4kQAJzdZpv4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQd1vc3ODDWYsEbeYf+Qcq0X/m4Ws
	FuderWS06F1wlc1i0+NrrBaXd81hs5hxfh+TxdLrF5ksnk64yGYxYfpaFovWvUfYLdbPeM1i
	0f53L5sDr8eaeWsYPS739TJ5rFz+hc1j06pONo871/aweWxeUu/Rt2UVo8fnTXIBHFENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDN2LvvHXDDBp2Lb9vWMDYwdtl2MnBwS
	AiYS03asZ4ewxSQu3FvP1sXIxSEkMJ1R4sT9T6wgCSGB14wSd+Zrgti8AloSpxZCNLAIqEpc
	mA/SwMnBJqAr8eT9XGYQW1QgTGLT9D5WiHpBiR+T77GA2CICOhIPFu0Fs5kFDjFJdC8xAbGF
	BYIlDuwD6QVZ3M4o8f/THbChnAKeEq/6jzFBNFhLrJy0jRHClpfYvOYt8wRGgVlIdsxCUjYL
	SdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHp4pnUDsaVDRaHGAU4GJV4eAve5gQL
	sSaWFVfmHmKU4GBWEuHdXp8bLMSbklhZlVqUH19UmpNafIgxGRgEE5mlRJPzgaksryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYL9zVvXF1eW0Ru3GBn1i3
	y5fXHeJM+xbwWx7aylM8L8j+4oUKr6ibHSoXC7PjV1g6WvEfFVHRtFHQLSlOO5nC/voTw8eG
	mtCHN8P3Ha30kp9f2DSx8eP+x48uXRR4zb7hoKDRVMmlz+LVZzanlljNP71lStu92Cvy5ScF
	pMvPLjq56r9CUckEJZbijERDLeai4kQAHPEv71sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 10:00 PM, Tushar Behera wrote:
> All SoC in Exynos-series have a clock with name XCLKOUT to provide
> debug information about various clocks available in the SoC. The register
> controlling the MUX and GATE of this clock is provided within PMU domain.
> Since PMU domain can't be dedicatedly mapped by every driver, the register
> needs to be handled through a regmap handle provided by PMU syscon
> controller. Right now, CCF doesn't allow regmap based MUX and GATE clocks,
> hence a dedicated clock provider for XCLKOUT is added here.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: Tomasz Figa <t.figa@samsung.com>
> ---
>   drivers/clk/samsung/Makefile  |    2 +-
>   drivers/clk/samsung/clk-out.c |  181 +++++++++++++++++++++++++++++++++++++++++
>   drivers/clk/samsung/clk.h     |   33 ++++++++
>   3 files changed, 215 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/samsung/clk-out.c
>
> diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
> index 8eb4799..d23ad4f 100644
> --- a/drivers/clk/samsung/Makefile
> +++ b/drivers/clk/samsung/Makefile
> @@ -2,7 +2,7 @@
>   # Samsung Clock specific Makefile
>   #
>   
> -obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o
> +obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o clk-out.o
>   obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
>   obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
>   obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
> diff --git a/drivers/clk/samsung/clk-out.c b/drivers/clk/samsung/clk-out.c
> new file mode 100644
> index 0000000..76489b6
> --- /dev/null
> +++ b/drivers/clk/samsung/clk-out.c
> @@ -0,0 +1,181 @@
> +/*
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This file contains the utility functions to register the clkout clocks.
> +*/
> +
> +/**
> + * All SoC in Exynos-series have a clock with name XCLKOUT to provide
> + * debug information about various clocks available in the SoC. The register
> + * controlling the MUX and GATE of this clock is provided within PMU domain.
> + * Since PMU domain can't be dedicatedly mapped every driver, the register
> + * needs to be handled through a regmap handle provided by PMU syscon
> + * controller. Right now, CCF doesn't allow regmap based MUX and GATE clocks,
> + * hence a dedicated clock provider for XCLKOUT is added here.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +
> +#include "clk.h"
> +
> +/**
> + * struct samsung_clkout_soc_data: SoC specific register details
> + * @reg: Offset of CLKOUT register from PMU base

how about naming this variable as "offset" instead of "reg".

> + * @mux_shift: Start-bit of MUX bit-field
> + * @mux_width: Width of MUX bit-field
> + * @enable_bit: The bit corresponding to gating of this clock
> + */
> +struct samsung_clkout_soc_data {
> +	unsigned int reg;
> +	u8 mux_shift;
> +	u8 mux_width;
> +	u8 enable_bit;
> +};
> +
> +/**
> + * struct samsung_clkout: Structure to store driver specific clock context
> + * @hw: Handle to CCF clock
> + * @soc_data: SoC specific register details
> + * @regmap: Regmap handle of the PMU
> + */
> +struct samsung_clkout {
> +	struct clk_hw hw;
> +	const struct samsung_clkout_soc_data *soc_data;
> +	struct regmap *regmap;
> +};
> +
> +#define to_clk_out(_hw) container_of(_hw, struct samsung_clkout, hw)
> +
> +int samsung_clkout_enable(struct clk_hw *hw)
> +{
> +	struct samsung_clkout *clkout = to_clk_out(hw);
> +	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
> +	unsigned int enable_mask = BIT(soc_data->enable_bit);
> +
> +	/* clkout is enabled if enable bit is low */
> +	regmap_update_bits(clkout->regmap, soc_data->reg, enable_mask, 0);
> +
> +	return 0;
> +}
> +
> +void samsung_clkout_disable(struct clk_hw *hw)
> +{
> +	struct samsung_clkout *clkout = to_clk_out(hw);
> +	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
> +	unsigned int enable_mask = BIT(soc_data->enable_bit);
> +
> +	/* clkout is gated if enable bit is high */
> +	regmap_update_bits(clkout->regmap, soc_data->reg,
> +			enable_mask, enable_mask);
> +
> +	return;
> +}
> +
> +int samsung_clkout_set_parent(struct clk_hw *hw, u8 index)
> +{
> +	struct samsung_clkout *clkout = to_clk_out(hw);
> +	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
> +	unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
> +
> +	regmap_update_bits(clkout->regmap, soc_data->reg,
> +			parent_mask << soc_data->mux_shift,
> +			index << soc_data->mux_shift);
> +
> +	return 0;
> +}
> +
> +u8 samsung_clkout_get_parent(struct clk_hw *hw)
> +{
> +	struct samsung_clkout *clkout = to_clk_out(hw);
> +	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
> +	unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
> +	unsigned int val;
> +	int ret;
> +
> +	ret = regmap_read(clkout->regmap, soc_data->reg, &val);

Do we really need to keep return value in "ret" as I can't see you are 
using it anywhere?

> +
> +	return (val >> soc_data->mux_shift) & parent_mask;
> +}
> +
> +static const struct clk_ops samsung_clkout_clk_ops = {
> +	.enable = samsung_clkout_enable,
> +	.disable = samsung_clkout_disable,
> +	.set_parent = samsung_clkout_set_parent,
> +	.get_parent = samsung_clkout_get_parent,
> +};
> +
> +static void __init _samsung_clk_register_clkout(
> +		struct samsung_out_clock *out,
> +		const struct samsung_clkout_soc_data *soc_data,
> +		struct regmap *regmap)
> +{
> +	struct samsung_clkout *clkout;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +	int ret;
> +
> +	clkout = kzalloc(sizeof(*clkout), GFP_KERNEL);
> +	if (!clkout) {
> +		pr_err("%s: could not allocate out clk %s\n",
> +			__func__, out->name);
> +		return;
> +	}
> +
> +	init.name = out->name;
> +	init.parent_names = out->parent_names;
> +	init.num_parents = out->num_parents;
> +	init.ops = &samsung_clkout_clk_ops;
> +
> +	clkout->hw.init = &init;
> +	clkout->regmap = regmap;
> +	clkout->soc_data = soc_data;
> +
> +	clk = clk_register(NULL, &clkout->hw);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: failed to register out clock %s : %ld\n",
> +			__func__, out->name, PTR_ERR(clk));
> +		kfree(clkout);
> +		return;
> +	}
> +
> +	samsung_clk_add_lookup(clk, out->id);
> +
> +	if (!out->alias)
> +		return;
> +
> +	ret = clk_register_clkdev(clk, out->alias, out->dev_name);
> +	if (ret)
> +		pr_err("%s: failed to register lookup for %s : %d",
> +			__func__, out->name, ret);
> +}
> +
> +/* All existing Exynos serial of SoCs have common values for this offsets. */
typo: serial/series/
> +static const struct samsung_clkout_soc_data exynos_clkout_soc_data = {
> +	.reg = 0xa00,
> +	.mux_shift = 8,
> +	.mux_width = 5,
> +	.enable_bit = 0,
> +};
> +
> +void __init samsung_clk_register_clkout(struct device_node *np,
> +		struct samsung_out_clock *out_clk_list, unsigned int nr_out_clk)
> +{
> +	int cnt;
> +	struct regmap *reg;
> +	const struct samsung_clkout_soc_data *priv = &exynos_clkout_soc_data;
> +
> +	reg = syscon_early_regmap_lookup_by_phandle(np, "samsung,pmu-syscon");
> +	if (IS_ERR(reg)) {
> +		pr_err("Failed to get pmu-syscon handle for clkout\n");
> +		return;
> +	}
> +
> +	for (cnt = 0; cnt < nr_out_clk; cnt++)
> +		_samsung_clk_register_clkout(&out_clk_list[cnt], priv, reg);
> +}
> diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
> index c7141ba..b4b2122 100644
> --- a/drivers/clk/samsung/clk.h
> +++ b/drivers/clk/samsung/clk.h
> @@ -312,6 +312,37 @@ struct samsung_pll_clock {
>   	__PLL(_typ, _id, NULL, _name, _pname, CLK_GET_RATE_NOCACHE,	\
>   		_lock, _con, _rtable, _alias)
>   
> +/**
> + * struct samsung_out_clock: information about CLKOUT clock
> + * @id: platform specific id of the clock.
> + * @dev_name: name of the device to which this clock belongs.
> + * @name: name of this mux clock.
> + * @parent_names: array of pointer to parent clock names.
> + * @num_parents: number of parents listed in @parent_names.
> + * @alias: optional clock alias name to be assigned to this clock.
> + */
> +struct samsung_out_clock {
> +	unsigned int		id;
> +	const char		*dev_name;
> +	const char		*name;
> +	const char		**parent_names;
> +	unsigned int		num_parents;
> +	const char		*alias;
> +};
> +
> +#define __CLKOUT(_id, dname, cname, pnames, a)		\
> +	{							\
> +		.id		= _id,				\
> +		.dev_name	= dname,			\
> +		.name		= cname,			\
> +		.parent_names	= pnames,			\
> +		.num_parents	= ARRAY_SIZE(pnames),		\
> +		.alias		= a,				\
> +	}
> +
> +#define CLKOUT(_id, cname, pnames) \
> +	__CLKOUT(_id, NULL, cname, pnames, NULL)
> +
>   extern void __init samsung_clk_init(struct device_node *np, void __iomem *base,
>   				    unsigned long nr_clks);
>   extern void __init samsung_clk_of_register_fixed_ext(
> @@ -335,6 +366,8 @@ extern void __init samsung_clk_register_gate(
>   		struct samsung_gate_clock *clk_list, unsigned int nr_clk);
>   extern void __init samsung_clk_register_pll(struct samsung_pll_clock *pll_list,
>   		unsigned int nr_clk, void __iomem *base);
> +extern void __init samsung_clk_register_clkout(struct device_node *np,
> +	struct samsung_out_clock *out_clk_list, unsigned int nr_out_clk);
>   
>   extern unsigned long _get_rate(const char *clk_name);
>   


-- 
Best Regards,
Pankaj Dubey

