Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3ERFXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 01:23:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25837 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3ERFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 01:23:23 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f436d000000f81-ae-51971049b9c5
Content-transfer-encoding: 8BIT
Message-id: <51971046.3080201@samsung.com>
Date: Sat, 18 May 2013 14:23:18 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 22/30] thermal: exynos: Add support for exynos5440 TMU
 sensor.
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
 <1368525540-15034-23-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1368525540-15034-23-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSNdTYHqgwcvzWhYNV0Msfr2byW6x
	Zv9PJoveBVfZLC7vmsNm8bn3CKPFjPP7mCyePOxjc+Dw2DnrLrvH4j0vmTz6tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZh+bPZi4471TxtMmogXGzaRcjJ4eEgIlEx5P5LBC2mMSF
	e+vZuhi5OIQEljJKPNh4ihGmaN+pj+wQiemMEn+a9zGDJHgFBCV+TL4H1M3BwSwgL3HkUjZI
	mFlAXWLSvEXMEPUvGSUe7u1hB6nhFdCSeLJZFaSGRUBVYtGBNawgNpuAnMTbpm9gu0QFwiSu
	TjgOdpCIgKHE8QNLwQ5iFnjDKLHzyCw2kDnCAuES7+/qQcxvY5R42d4C1sAp4ClxfPEPVpCE
	hMA9dompZ+4zQmwTkPg2+RDYoRICshKbDjBDPCYpcXDFDZYJjGKzkLwzC+GdWUjeWcDIvIpR
	NLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMPZO/3vWv4Px7gHrQ4zJQBsnMkuJJucDYzevJN7Q
	2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx7A9Z4v56u
	aJu69OtKDSG5p4ccfRN+Ogclbw/o+CdkemWREE9Kz6aY3WuXTzC5d+laXd/PaX+MbnnosXr+
	O7DisGKBxI51RyPNF0c2bNvhaZ/wJf3Cwh/F/aU/C88ZRglsy+Dp1Jt6+F3A+sdaF1ve7zob
	8cc4ePq13IIJbDOEIjbccBF4eGySEktxRqKhFnNRcSIAnhyaV9MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV1PgemBBs/fKlg0XA2x+PVuJrvF
	mv0/mSx6F1xls7i8aw6bxefeI4wWM87vY7J48rCPzYHDY+esu+wei/e8ZPLo27KK0eP4je1M
	Hp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDg0fzZzwXmniqdN
	Rg2Mm027GDk5JARMJPad+sgOYYtJXLi3nq2LkYtDSGA6o8Sf5n3MIAleAUGJH5PvsXQxcnAw
	C8hLHLmUDRJmFlCXmDRvETNE/UtGiYd7e9hBangFtCSebFYFqWERUJVYdGANK4jNJiAn8bbp
	GyOILSoQJnF1wnEWEFtEwFDi+IGlYHuZBd4wSuw8MosNZI6wQLjE+7t6EPPbGCVetreANXAK
	eEocX/yDdQKjwCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7GdS
	OxhXNlgcYhTgYFTi4f3gOi1QiDWxrLgy9xCjBAezkgjv82KgEG9KYmVValF+fFFpTmrxIcZk
	oO8mMkuJJucDk05eSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBK
	NTCu95uy+rbRhWvaybO53867pPvVcXFalff9M6Znp/ae4Z3T+2n3yrdhqVZz9j4/ukxnkWhG
	YtDH9ZaV9jtv/N1acceRTVNG2cq3yfBDw773+2wsDfL0a43u567fxbDGcQLjGyPFhEWrH+3c
	vOfU4cT95e90n1uWtt4QYzn4+LQuo43G1oD/+ws5lFiKMxINtZiLihMBvg1SbDADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 05월 14일 18:58, Amit Daniel Kachhap wrote:

> This patch modifies TMU controller to add changes needed to work with
> exynos5440 platform. This sensor registers 3 instance of the tmu controller
> with the thermal zone and hence reports 3 temperature output. This controller
> supports upto five trip points. For critical threshold the driver uses the
> core driver thermal framework for shutdown.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   28 ++++++++++++-
>  drivers/thermal/samsung/exynos_tmu.c               |   43 +++++++++++++++++--
>  drivers/thermal/samsung/exynos_tmu.h               |    6 +++
>  drivers/thermal/samsung/exynos_tmu_data.h          |    2 +
>  4 files changed, 72 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 535fd0e..970eeba 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -6,13 +6,16 @@
>  	       "samsung,exynos4412-tmu"
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
> +	       "samsung,exynos5440-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
> -- reg : Address range of the thermal registers
> +- reg : Address range of the thermal registers. For exynos5440-tmu which has 3
> +	instances of TMU, 2 set of register has to supplied. First set belongs
> +	to each instance of TMU and second set belongs to common TMU registers.
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
>  
> -Example:
> +Example 1):
>  
>  	tmu@100C0000 {
>  		compatible = "samsung,exynos4412-tmu";
> @@ -23,3 +26,24 @@ Example:
>  		clock-names = "tmu_apbif";
>  		status = "disabled";
>  	};
> +
> +Example 2):
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible = "samsung,exynos5440-tmu";
> +		reg = <0x160118 0x230>, <0x160368 0x10>;
> +		interrupts = <0 58 0>;
> +		clocks = <&clock 21>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +Note: For multi-instance tmu each instance should have an alias correctly
> +numbered in "aliases" node.
> +
> +Example:
> +
> +aliases {
> +	tmuctrl0 = &tmuctrl_0;
> +	tmuctrl1 = &tmuctrl_1;
> +	tmuctrl2 = &tmuctrl_2;
> +};
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 7f7b1cf..7ca9c4d 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -185,9 +185,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
>  
>  		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> -	} else if (data->soc == SOC_ARCH_EXYNOS) {
> +	} else if (data->soc == SOC_ARCH_EXYNOS ||
> +			data->soc == SOC_ARCH_EXYNOS5440) {
>  		/* Write temperature code for rising and falling threshold */
> -		for (i = 0; i < trigger_levs; i++) {
> +		for (i = 0;
> +		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
>  			if (threshold_code < 0) {
> @@ -218,7 +220,30 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>  			(reg->inten_fall_mask << reg->inten_fall_shift),
>  				data->base + reg->tmu_intclear);
> +
> +		/* if 5th threshold limit is also present, use TH2 register */
> +		i = EXYNOS_MAX_TRIGGER_PER_REG;
> +		if (pdata->trigger_levels[i]) {
> +			threshold_code = temp_to_code(data,
> +						pdata->trigger_levels[i]);
> +			if (threshold_code < 0) {
> +				ret = threshold_code;
> +				goto out;
> +			}
> +			rising_threshold =
> +				threshold_code << reg->threshold_th3_l0_shift;
> +			writel(rising_threshold,
> +				data->base + reg->threshold_th2);
> +			if (pdata->trigger_type[i] == HW_TRIP) {
> +				con = readl(data->base + reg->tmu_ctrl);
> +				con |= (1 << reg->therm_trip_en_shift);
> +				writel(con, data->base + reg->tmu_ctrl);
> +			}
> +		}
>  	}
> +	/*Clear the PMIN in the common TMU register*/
> +	if (reg->tmu_pmin && !data->id)
> +		writel(0, data->base_common + reg->tmu_pmin);
>  out:
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -345,7 +370,14 @@ static void exynos_tmu_work(struct work_struct *work)
>  			struct exynos_tmu_data, irq_work);
>  	struct exynos_tmu_platform_data *pdata = data->pdata;
>  	const struct exynos_tmu_registers *reg = pdata->registers;
> -	unsigned int val_irq;
> +	unsigned int val_irq, val_type;
> +
> +	/* Find which sensor generated this interrupt */
> +	if (reg->tmu_irqstatus) {
> +		val_type = readl(data->base_common + reg->tmu_irqstatus);
> +		if (!((val_type >> data->id) & 0x1))
> +			goto out;


I have a question about your implementation for supporting EXYNOS5440.
I don't know exactly how EXYNO5440's tmu is working, but just guess it would be
similar with other EXYNOS series's without number of thermal sensors. (exclusive
register map and threshold level). Due to the multiple number of thermal sensor
in EXYNOS5440, it have multiple thermal zone devices and that's why it just
leave interrupt pin in pending if interrupt is not its, right?

So, my curious is, why we make all platform devices for each of thermal zone
devices? Why don't you just handle all thermal zone devices with one platform
device?

Yes, It's probably right to make multiple devices node to support them, because
it has different physical hardware(sensors). But we have one TMU , don't we?
(Maybe my assumption is wrong, I assume that it has one TMU because it looks
like it has only one irq line.). If I'm right, I think it is better to manage
all thermal zone devices with one platform device. Then, we don't need to leave
irq handler with leaving it pendded like above and also we may not need other
your patches like adding base_common iomem variable.

I'd like to listen your opinion about this.

Thanks,
Jonghwa

> +	}
>  
>  	exynos_report_trigger(data->reg_conf);
>  	mutex_lock(&data->lock);
> @@ -358,7 +390,7 @@ static void exynos_tmu_work(struct work_struct *work)
>  
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> -
> +out:
>  	enable_irq(data->irq);
>  }
>  
> @@ -520,7 +552,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>  		return ret;
>  
>  	if (pdata->type == SOC_ARCH_EXYNOS ||
> -				pdata->type == SOC_ARCH_EXYNOS4210)
> +		pdata->type == SOC_ARCH_EXYNOS4210 ||
> +				pdata->type == SOC_ARCH_EXYNOS5440)
>  		data->soc = pdata->type;
>  	else {
>  		ret = -EINVAL;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index 65443d7..9151a30 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -44,6 +44,7 @@ enum trigger_type {
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 = 1,
>  	SOC_ARCH_EXYNOS,
> +	SOC_ARCH_EXYNOS5440,
>  };
>  
>  /**
> @@ -132,6 +133,8 @@ enum soc_type {
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
>   * @emul_time_mask: mask bits of emulation time.
> + * @tmu_irqstatus: register to find which TMU generated interrupts.
> + * @tmu_pmin: register to get/set the Pmin value.
>   */
>  struct exynos_tmu_registers {
>  	u32	triminfo_data;
> @@ -199,6 +202,9 @@ struct exynos_tmu_registers {
>  	u32	emul_temp_shift;
>  	u32	emul_time_shift;
>  	u32	emul_time_mask;
> +
> +	u32	tmu_irqstatus;
> +	u32	tmu_pmin;
>  };
>  
>  /**
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index 0e2244f..4acf070 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -91,6 +91,8 @@
>  #define EXYNOS_EMUL_DATA_MASK	0xFF
>  #define EXYNOS_EMUL_ENABLE	0x1
>  
> +#define EXYNOS_MAX_TRIGGER_PER_REG	4
> +
>  #if defined(CONFIG_CPU_EXYNOS4210)
>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)


