Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbaJaMrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:47:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38101 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbaJaMrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:47:18 -0400
X-AuditID: cbfee691-f79b86d000004a5a-f6-545384d4afad
Message-id: <545384D3.5050000@samsung.com>
Date: Fri, 31 Oct 2014 21:47:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-iio@vger.kernel.org, jic23@kernel.org, naveenkrishna.ch@gmail.com,
        kesavan.abhilash@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: exynos_adc: Add support for ADCv3 on exynos7
References: <1414759083-4555-1-git-send-email-a.kesavan@samsung.com>
In-reply-to: <1414759083-4555-1-git-send-email-a.kesavan@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkSPdKS3CIwYWn7BaP1yxmsnjQtIrJ
	Ys1fJYt5R96xWFzeNYfNYtG2/8wObB47Z91l99i0qpPNo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDIevxEreC1V8aB1GWMD4zPRLkZODgkBE4k3i04yQ9hiEhfurWfrYuTiEBJYyijxc/kv
	Npii0zO/MkMkFjFKtP7/AOW8ZpSYduoAWBWvgJbEqxevWUFsFgFVicNdMxhBbDag+P4XN8Bq
	RAXCJFZOv8ICUS8o8WPyPTBbREBH4vGcHrB6ZoF2Roll2wJBbGEBb4lf61aA9QoJuEismvIH
	aDEHB6eAq8T6k3wQ5ToS+1unsUHY8hKb17wFu01CYBe7xKSdt6HuEZD4NvkQC0ivhICsxKYD
	UB9LShxccYNlAqPYLCQXzUIydhaSsQsYmVcxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBMbX
	6X/PJu5gvH/A+hCjAAejEg/vguNBIUKsiWXFlbmHGE2BrpjILCWanA+M4rySeENjMyMLUxNT
	YyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhh3OEZ+cvZp39J6p9v79s4j
	hUGXNjYc/ah99Z9uQCqniVz+72DdHTyLP9wqXeJyace+xpUHss4oz599ofzuq81pmW8rr/OL
	l778dXeLlsXynV3HWT6tnWls8D34XtamBIUzdS9urGxt5OTR5/zGvM/h9RH+gA8PwhRa2IKn
	Pz2z0PjBt8Ur87+uVmIpzkg01GIuKk4EAK8uEy2qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd3LLcEhBu8X21g8XrOYyeJB0yom
	izV/lSzmHXnHYnF51xw2i0Xb/jM7sHnsnHWX3WPTqk42j74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMePxGrOC1VMWD1mWMDYzPRLsYOTkkBEwkTs/8
	ygxhi0lcuLeerYuRi0NIYBGjROv/D8wQzmtGiWmnDrCBVPEKaEm8evGaFcRmEVCVONw1gxHE
	ZgOK739xA6xGVCBMYuX0KywQ9YISPybfA7NFBHQkHs/pAatnFmhnlFi2LRDEFhbwlvi1bgVY
	r5CAi8SqKX+AFnNwcAq4Sqw/yQdRriOxv3UaG4QtL7F5zVvmCYwCs5BsmIWkbBaSsgWMzKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP3mfQOxlUNFocYBTgYlXh4FxwPChFiTSwrrsw9
	xCjBwawkwitRFhwixJuSWFmVWpQfX1Sak1p8iNEUGAATmaVEk/OBiSWvJN7Q2MTMyNLI3NDC
	yNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAOj3Zfvf1pdU5gP6l24IB1bLFKk+sMrR+Xv
	0gIbST3POyU8/TLMtTHiLlt0D/LZcDwr1ZwpUF4xLe7KoZlGlikT+htmza0/e0zONT7rud6f
	i93bOI2vbfwUYTb5z+E79VqxXE8dJnEmPJv3Ly5Xda1zUvmRu/ti57zl2dWWJOmxhHf2vzSh
	1ZOVWIozEg21mIuKEwHfcK2k9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

On 10/31/2014 09:38 PM, Abhilash Kesavan wrote:
> The ADC on exynos7 is quite similar to ADCv2. The differences are as
> follows:
> 	- v3 has 8 input channels (10 in v2).
> 	- v3 does not include an ADC PHY control register.
> 	- Some ADC_CON2 register bits being used in v2 are listed as
> 	  reserved in v3. This results in a different init_hw function
> 	  for v3.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> - Based on Naveen's "iio: exynos-adc: use syscon instead of ioremap" patchset
> http://comments.gmane.org/gmane.linux.kernel.iio/13943
> 
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |    2 ++
>  drivers/iio/adc/exynos_adc.c                       |   32 ++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index c368210..a11e32c 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -14,6 +14,8 @@ Required properties:
>  				for exynos4412/5250 and s5pv210 controllers.
>  			Must be "samsung,exynos-adc-v2" for
>  				future controllers.
> +			Must be "samsung,exynos-adc-v3" for
> +				the ADC in Exynos7 and compatibles

I prefer to use 'exynos7-adc' instead of 'exynos-adc-v3'.
Exynos7 has little different from existing ADCv2.

Also, If you want to use 'exynos-adc-v3' compatible,
Exynos7's TRM have to include the correct version(v3) infromation.

Thanks,
Chanwoo Choi



>  			Must be "samsung,exynos3250-adc" for
>  				controllers compatible with ADC of Exynos3250.
>  			Must be "samsung,s3c2410-adc" for
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index fe03177..74d0a9d 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -390,6 +390,35 @@ static const struct exynos_adc_data exynos3250_adc_data = {
>  	.start_conv	= exynos_adc_v2_start_conv,
>  };
>  
> +static void exynos_adc_v3_init_hw(struct exynos_adc *info)
> +{
> +	u32 con1, con2;
> +
> +	if (info->data->needs_adc_phy)
> +		regmap_write(info->pmu_map, info->data->phy_offset, 1);
> +
> +	con1 = ADC_V2_CON1_SOFT_RESET;
> +	writel(con1, ADC_V2_CON1(info->regs));
> +
> +	con2 = readl(ADC_V2_CON2(info->regs));
> +	con2 &= ~ADC_V2_CON2_C_TIME(7);
> +	con2 |= ADC_V2_CON2_C_TIME(0);
> +	writel(con2, ADC_V2_CON2(info->regs));
> +
> +	/* Enable interrupts */
> +	writel(1, ADC_V2_INT_EN(info->regs));
> +}
> +
> +static const struct exynos_adc_data exynos_adc_v3_data = {
> +	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
> +
> +	.init_hw	= exynos_adc_v3_init_hw,
> +	.exit_hw	= exynos_adc_v2_exit_hw,
> +	.clear_irq	= exynos_adc_v2_clear_irq,
> +	.start_conv	= exynos_adc_v2_start_conv,
> +};
> +
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
>  		.compatible = "samsung,s3c2410-adc",
> @@ -413,6 +442,9 @@ static const struct of_device_id exynos_adc_match[] = {
>  		.compatible = "samsung,exynos-adc-v2",
>  		.data = &exynos_adc_v2_data,
>  	}, {
> +		.compatible = "samsung,exynos-adc-v3",
> +		.data = &exynos_adc_v3_data,
> +	}, {
>  		.compatible = "samsung,exynos3250-adc",
>  		.data = &exynos3250_adc_data,
>  	},
> 

