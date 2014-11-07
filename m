Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaKGGXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:23:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48121 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaKGGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:23:43 -0500
X-AuditID: cbfee68d-f79296d000004278-ab-545c656c4f57
Message-id: <545C656C.2040306@samsung.com>
Date: Fri, 07 Nov 2014 15:23:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: linus.walleij@linaro.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, tomasz.figa@gmail.com,
        thomas.abraham@linaro.org, kgene.kim@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] pinctrl: exynos: Add support for Exynos4415
References: <1414372878-3737-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414372878-3737-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkUDcnNSbEYMcPVYvrX56zWvQuuMpm
	cbbpDbvFlD/LmSw2Pb7GanF51xw2ixnn9zFZzJj8ks3i2IwljBardv1hdODy2DnrLrvHnWt7
	2Dw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroyfq9QL3hhW7Lw0ma2BcZJWFyMnh4SA
	icTzj1+ZIGwxiQv31rN1MXJxCAksZZSY2rufHaZo+qKTUIlFjBLvDlxkhHBeM0ps+bKfEaSK
	V0BLYmXrbWYQm0VAVeLTsV+sIDYbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIyEhcnv2H
	HWQos8BEJoldfz+CDRUWcJJ4sf4Q2BlCAi4Sj392gcU5BVwltv5fDGYzC+hI7G+dxgZhy0ts
	XvOWGWSQhMA9dokP63vZIC4SkPg2+RDQNg6ghKzEpgPMEK9JShxccYNlAqPYLCQ3zUIydhaS
	sQsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBEbl6X/Pencw3j5gfYhRgINRiYf3Bm9M
	iBBrYllxZe4hRlOgKyYyS4km5wNjP68k3tDYzMjC1MTU2Mjc0kxJnFdR6mewkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsbics1C1iNHpwc3P2RInCUrLMW6/cAEF/v9G72LbFj5PlgUsOmu
	KTJi8uuP3Kaomh6s9Jrf23lG/c+bgb94DlRu/lZkKvelc47sdtbZIm69BY4zlFoF2p492qi2
	v35jIMPNTTVdGblJsRu2Bz5+83SKy5Ge5XdCH6f6KB/bNL1mgnig2bfUt0osxRmJhlrMRcWJ
	AFxeg2DFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd2c1JgQg/On5C2uf3nOatG74Cqb
	xdmmN+wWU/4sZ7LY9Pgaq8XlXXPYLGac38dkMWPySzaLYzOWMFqs2vWH0YHLY+esu+wed67t
	YfPYvKTeo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	/FylXvDGsGLnpclsDYyTtLoYOTkkBEwkpi86yQZhi0lcuLceyObiEBJYxCjx7sBFRgjnNaPE
	li/7GUGqeAW0JFa23mYGsVkEVCU+HfvFCmKzAcX3v7gBNklUIExi5fQrLBD1ghI/Jt8Ds0UE
	ZCQuz/7DDjKUWWAik8Suvx/BhgoLOEm8WH+IHcQWEnCRePyzCyzOKeAqsfX/YjCbWUBHYn/r
	NDYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH
	/DOpHYwrGywOMQpwMCrx8N7kjQkRYk0sK67MPcQowcGsJMIrFQQU4k1JrKxKLcqPLyrNSS0+
	xGgKDIKJzFKiyfnAdJRXEm9obGJmZGlkbmhhZGyuJM57oNU6UEggPbEkNTs1tSC1CKaPiYNT
	qoExyflxvtMPLssUHa9dbDMP1hk4izf8vTvD9OnRZ8nuvJH7jx0qC/m4xPiys2mxuFfLqqV7
	7DfMeM/l+/aWnpnO6bC5HW0qhWcPHWdPuGSqYdnQLNxfs2KpWNus3f31CZNOPBCdO3lNPFte
	3qTHK6PWtTTe7F/Dd4bD5MvysHXxpZeeGucKZd5RYinOSDTUYi4qTgQAQYZ2oA8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Could you please review this patch?

Best Regards,
Chanwoo Choi

On 10/27/2014 10:21 AM, Chanwoo Choi wrote:
> From: Tomasz Figa <tomasz.figa@gmail.com>
> 
> The pin controllers of Exynos4415 are similar to Exynos4412, but certain
> differences cause the need to create separate driver data for it. This
> patch adds pin controller and bank descriptor arrays to the driver to
> support the new SoC.
> 
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> [cw00.choi: Rebase it on mainline kernel]
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes from v1:
> - Separate only pinctrl patch from Exynos4415 patchset[1]
>  [1] [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
>   : https://lkml.org/lkml/2014/10/19/253
> 
> drivers/pinctrl/samsung/pinctrl-exynos.c  | 78 +++++++++++++++++++++++++++++++
>  drivers/pinctrl/samsung/pinctrl-samsung.c |  2 +
>  drivers/pinctrl/samsung/pinctrl-samsung.h |  1 +
>  3 files changed, 81 insertions(+)
> 
> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
> index d7154ed..065eee0 100644
> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
> @@ -920,6 +920,84 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
>  	},
>  };
>  
> +/* pin banks of exynos4415 pin-controller 0 */
> +static struct samsung_pin_bank exynos4415_pin_banks0[] = {
> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf0", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x1A0, "gpf1", 0x34),
> +	EXYNOS_PIN_BANK_EINTG(1, 0x1C0, "gpf2", 0x38),
> +};
> +
> +/* pin banks of exynos4415 pin-controller 1 */
> +static struct samsung_pin_bank exynos4415_pin_banks1[] = {
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpk0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x060, "gpk1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x080, "gpk2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x0A0, "gpk3", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpl0", 0x18),
> +	EXYNOS_PIN_BANK_EINTN(6, 0x120, "mp00"),
> +	EXYNOS_PIN_BANK_EINTN(4, 0x140, "mp01"),
> +	EXYNOS_PIN_BANK_EINTN(6, 0x160, "mp02"),
> +	EXYNOS_PIN_BANK_EINTN(8, 0x180, "mp03"),
> +	EXYNOS_PIN_BANK_EINTN(8, 0x1A0, "mp04"),
> +	EXYNOS_PIN_BANK_EINTN(8, 0x1C0, "mp05"),
> +	EXYNOS_PIN_BANK_EINTN(8, 0x1E0, "mp06"),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x260, "gpm0", 0x24),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x280, "gpm1", 0x28),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x2A0, "gpm2", 0x2c),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x2C0, "gpm3", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x2E0, "gpm4", 0x34),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
> +};
> +
> +/* pin banks of exynos4415 pin-controller 2 */
> +static struct samsung_pin_bank exynos4415_pin_banks2[] = {
> +	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
> +	EXYNOS_PIN_BANK_EINTN(2, 0x000, "etc1"),
> +};
> +
> +/*
> + * Samsung pinctrl driver data for Exynos4415 SoC. Exynos4415 SoC includes
> + * three gpio/pin-mux/pinconfig controllers.
> + */
> +struct samsung_pin_ctrl exynos4415_pin_ctrl[] = {
> +	{
> +		/* pin-controller instance 0 data */
> +		.pin_banks	= exynos4415_pin_banks0,
> +		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks0),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos4415-gpio-ctrl0",
> +	}, {
> +		/* pin-controller instance 1 data */
> +		.pin_banks	= exynos4415_pin_banks1,
> +		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks1),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.eint_wkup_init = exynos_eint_wkup_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos4415-gpio-ctrl1",
> +	}, {
> +		/* pin-controller instance 2 data */
> +		.pin_banks	= exynos4415_pin_banks2,
> +		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks2),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos4415-gpio-ctrl2",
> +	},
> +};
> +
>  /* pin banks of exynos5250 pin-controller 0 */
>  static struct samsung_pin_bank exynos5250_pin_banks0[] = {
>  	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
> index 2d37c8f..d9b3e0c 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
> @@ -1218,6 +1218,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
>  		.data = (void *)exynos4210_pin_ctrl },
>  	{ .compatible = "samsung,exynos4x12-pinctrl",
>  		.data = (void *)exynos4x12_pin_ctrl },
> +	{ .compatible = "samsung,exynos4415-pinctrl",
> +		.data = (void *)exynos4415_pin_ctrl },
>  	{ .compatible = "samsung,exynos5250-pinctrl",
>  		.data = (void *)exynos5250_pin_ctrl },
>  	{ .compatible = "samsung,exynos5260-pinctrl",
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
> index 5cedc9d..10b720d 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.h
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
> @@ -239,6 +239,7 @@ struct samsung_pmx_func {
>  extern struct samsung_pin_ctrl exynos3250_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
> +extern struct samsung_pin_ctrl exynos4415_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
> 

