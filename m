Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaGIDAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:00:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48469 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaGIDAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:00:47 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-88-53bcb05dbae8
Message-id: <53BCB05C.4080605@samsung.com>
Date: Wed, 09 Jul 2014 12:00:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rui.zhang@intel.com, eduardo.valentin@ti.com, kgene.kim@samsung.com,
        amit.daniel@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH] thermal: samsung: Add TMU support for Exynos3250 SoC
References: <1404174799-8969-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1404174799-8969-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkQDd2w55gg/e3FCwaroZYXP/ynNVi
	/pFzrBZr9v9ksug8+4TZonfBVTaLs01v2C0u75rDZvG59wijxYzz+5gsnjzsY7NYP+M1iwOP
	x+I9L5k8+rasYvQ4fmM7k8fnTXIBLFFcNimpOZllqUX6dglcGQ+v72EuuG9V8XXreZYGxu8G
	XYycHBICJhJvny1lhLDFJC7cW8/WxcjFISSwlFHi/v9uNpiiX7d7mSES0xkl/t9tZYVwXjNK
	/Hu+hRmkildAS2JS91FWEJtFQFXi9o4ZYGPZgOL7X9wAmyQqECaxcvoVFoh6QYkfk++B2SIC
	GhIz/15hBBnKLLCNSWLBnW4mkISwgKfE/jW7wAYJCbhI7Hr/CqyBU8BV4vKBCWDLmAV0JPa3
	TmODsOUlNq95C3aqhMBbdomujf+YIC4SkPg2+RBQMwdQQlZi0wFmiNckJQ6uuMEygVFsFpKb
	ZiEZOwvJ2AWMzKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAiP09L9nfTsYbx6wPsSYDLRy
	IrOUaHI+MMLzSuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANjyoOTrP/KeM+lBZx923nkwJczLFytV9ey//mSMu/kMe1lhWp3Kq6drP/6bxufgBHL
	39xEv945jgvF9+o6GWuGO5zLU/7/YJ9Yi1p6EsOXj099u3z5d1/0nfb40lKFq005Yq9mbrMV
	fuRZ1s//T6f00kwhth3VhgvXyh6asyjSQ+mT5LMyxmdMSizFGYmGWsxFxYkAOV/HmuYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG7shj3BBvMeiFk0XA2xuP7lOavF
	/CPnWC3W7P/JZNF59gmzRe+Cq2wWZ5vesFtc3jWHzeJz7xFGixnn9zFZPHnYx2axfsZrFgce
	j8V7XjJ59G1Zxehx/MZ2Jo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgE5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SA
	BhLWMGY8vL6HueC+VcXXredZGhi/G3QxcnJICJhI/Lrdywxhi0lcuLeerYuRi0NIYDqjxP+7
	rawQzmtGiX/Pt4BV8QpoSUzqPsoKYrMIqErc3jGDEcRmA4rvf3GDDcQWFQiTWDn9CgtEvaDE
	j8n3wGwRAQ2JmX+vMIIMZRbYxiSx4E43E0hCWMBTYv+aXWCDhARcJHa9fwXWwCngKnH5wASw
	ZcwCOhL7W6exQdjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOP6fSe1gXNlgcYhRgINRiYdXgWdPsBBrYllxZe4hRgkOZiUR3m9uQCHelMTKqtSi
	/Pii0pzU4kOMpsAgmMgsJZqcD0xNeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1ML
	Uotg+pg4OKUaGIubuC4v0eE+FrNKxe/9lvdy5iGXbkydUyveUXBh5YQVR+3C57zdemhveOfu
	hQU+gTFXt02pVGtaeUapYcbmI5OzzDwfrHnMbyn6ueNZXvj7zZNF7LZEfe1kevzdVfbJy86S
	dUufXp88pbpstv5srrWnYvbtMtdZsJ3VVYvTbsmjCz/yCh8b3LVWYinOSDTUYi4qTgQAgzEv
	SBUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 09:33 AM, Chanwoo Choi wrote:
> This patch add registers, bit fields and compatible strings for Exynos3250 TMU
> (Thermal Management Unit). Exynos3250 uses the Cortex-A7 dual cores and has
> a target speed of 1.0 GHz.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> [Add MUX address setting bits by Jonghwa Lee]
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |  1 +
>  drivers/thermal/samsung/exynos_tmu.c               |  7 +-
>  drivers/thermal/samsung/exynos_tmu.h               |  3 +-
>  drivers/thermal/samsung/exynos_tmu_data.c          | 89 ++++++++++++++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |  7 ++
>  5 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index c949092..ae738f5 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -3,6 +3,7 @@
>  ** Required properties:
>  
>  - compatible : One of the following:
> +	       "samsung,exynos3250-tmu"
>  	       "samsung,exynos4412-tmu"
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 2412090..97ebc1e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -501,6 +501,10 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
>  
>  static const struct of_device_id exynos_tmu_match[] = {
>  	{
> +		.compatible = "samsung,exynos3250-tmu",
> +		.data = (void *)EXYNOS3250_TMU_DRV_DATA,
> +	},
> +	{
>  		.compatible = "samsung,exynos4210-tmu",
>  		.data = (void *)EXYNOS4210_TMU_DRV_DATA,
>  	},
> @@ -675,7 +679,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>  		goto err_clk_sec;
>  	}
>  
> -	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
> +	if (pdata->type == SOC_ARCH_EXYNOS3250 ||
> +	    pdata->type == SOC_ARCH_EXYNOS4210 ||
>  	    pdata->type == SOC_ARCH_EXYNOS4412 ||
>  	    pdata->type == SOC_ARCH_EXYNOS5250 ||
>  	    pdata->type == SOC_ARCH_EXYNOS5260 ||
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index edd08cf..1b4a644 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -40,7 +40,8 @@ enum calibration_mode {
>  };
>  
>  enum soc_type {
> -	SOC_ARCH_EXYNOS4210 = 1,
> +	SOC_ARCH_EXYNOS3250 = 1,
> +	SOC_ARCH_EXYNOS4210,
>  	SOC_ARCH_EXYNOS4412,
>  	SOC_ARCH_EXYNOS5250,
>  	SOC_ARCH_EXYNOS5260,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index c1d81dc..aa8e0de 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -90,6 +90,95 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
>  };
>  #endif
>  
> +#if defined(CONFIG_SOC_EXYNOS3250)
> +static const struct exynos_tmu_registers exynos3250_tmu_registers = {
> +	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> +	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> +	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> +	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> +	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
> +	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> +	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
> +	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
> +	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
> +	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> +	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> +	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
> +	.tmu_status = EXYNOS_TMU_REG_STATUS,
> +	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
> +	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
> +	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
> +	.tmu_inten = EXYNOS_TMU_REG_INTEN,
> +	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
> +	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
> +	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
> +	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
> +	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
> +	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> +	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
> +	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> +	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> +	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
> +	.emul_con = EXYNOS_EMUL_CON,
> +	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> +	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> +	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
> +};
> +
> +#define EXYNOS3250_TMU_DATA \
> +	.threshold_falling = 10, \
> +	.trigger_levels[0] = 70, \
> +	.trigger_levels[1] = 95, \
> +	.trigger_levels[2] = 110, \
> +	.trigger_levels[3] = 120, \
> +	.trigger_enable[0] = true, \
> +	.trigger_enable[1] = true, \
> +	.trigger_enable[2] = true, \
> +	.trigger_enable[3] = false, \
> +	.trigger_type[0] = THROTTLE_ACTIVE, \
> +	.trigger_type[1] = THROTTLE_ACTIVE, \
> +	.trigger_type[2] = SW_TRIP, \
> +	.trigger_type[3] = HW_TRIP, \
> +	.max_trigger_level = 4, \
> +	.gain = 8, \
> +	.reference_voltage = 16, \
> +	.noise_cancel_mode = 4, \
> +	.cal_type = TYPE_TWO_POINT_TRIMMING, \
> +	.efuse_value = 55, \
> +	.min_efuse_value = 40, \
> +	.max_efuse_value = 100, \
> +	.first_point_trim = 25, \
> +	.second_point_trim = 85, \
> +	.default_temp_offset = 50, \
> +	.freq_tab[0] = { \
> +		.freq_clip_max = 800 * 1000, \
> +		.temp_level = 70, \
> +	}, \
> +	.freq_tab[1] = { \
> +		.freq_clip_max = 400 * 1000, \
> +		.temp_level = 95, \
> +	}, \
> +	.freq_tab_count = 2, \
> +	.registers = &exynos3250_tmu_registers, \
> +	.features = (TMU_SUPPORT_EMULATION | \
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> +			TMU_SUPPORT_EMUL_TIME)
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS3250)
> +struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
> +	.tmu_data = {
> +		{
> +			EXYNOS3250_TMU_DATA,
> +			.type = SOC_ARCH_EXYNOS3250,
> +			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
> +		},
> +	},
> +	.tmu_count = 1,
> +};
> +#endif
> +
>  #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
>  static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>  	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index d268981..f0979e5 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -148,6 +148,13 @@
>  #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
>  #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
>  
> +#if defined(CONFIG_SOC_EXYNOS3250)
> +extern struct exynos_tmu_init_data const exynos3250_default_tmu_data;
> +#define EXYNOS3250_TMU_DRV_DATA (&exynos3250_default_tmu_data)
> +#else
> +#define EXYNOS3250_TMU_DRV_DATA (NULL)
> +#endif
> +
>  #if defined(CONFIG_CPU_EXYNOS4210)
>  extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
> 

Ping.

Best Regards,
Chanwoo Choi
