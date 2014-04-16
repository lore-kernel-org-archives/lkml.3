Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaDPKPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:15:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35460 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaDPKPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:15:08 -0400
X-AuditID: cbfee690-b7f266d00000287c-fb-534e582a84c3
Message-id: <534E582E.2030108@samsung.com>
Date: Wed, 16 Apr 2014 19:15:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCHv2] pinctrl: exynos: Add driver data for Exynos3250
References: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkUFcrwi/YYMY3U4vrX56zWvQuuMpm
	cbbpDbvFlD/LmSw2Pb7GanF51xw2ixnn9zFZrJ/xmsXi2IwljA6cHneu7WHz2Lyk3qNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgyNh89xVywXbvi0/2brA2M+1W6GDk5JARMJCb8/s4EYYtJ
	XLi3nq2LkYtDSGApo8SE5jfsMEW7H/QwQiQWMUpsXDKJCcJ5zShx5+45sCpeAS2J77//sIHY
	LAKqEp0XnoLF2YDi+1/cAIuLCoRJrJx+hQWiXlDix+R7YLaIQJnEq58NLCBDmQVuAG04tJC1
	i5GDQ1jATeJpjyxIjZCAq8T6v68YQWxOoPDR/r9g85kFdCT2t05jg7DlJTavecsMMkdC4Bq7
	xKvGblaIgwQkvk0+xAIyU0JAVmLTAWaIzyQlDq64wTKBUWwWkpNmIRk7C8nYBYzMqxhFUwuS
	C4qT0otM9IoTc4tL89L1kvNzNzECI/D0v2cTdjDeO2B9iDEZaOVEZinR5HxgBOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Oxyf9HLnfbjnv8
	ifi/wOFccHWHpVfLwaSv+yOOCnQwfupdcaN8bXv4yf6USZ/u+AkXFb7f8nrqvzei2c9SLhxW
	+cNVvs3Q9OWD8m8iQktXtKR8u35Z90rX9iV+7U2VZhtSXs3hefs/VzZxTrijvatMokmzj/6D
	M3N/HD/PfcI0P6Mp81tXj4sSS3FGoqEWc1FxIgAwtbFb1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAV2tCL9gg3UPdCyuf3nOatG74Cqb
	xdmmN+wWU/4sZ7LY9Pgaq8XlXXPYLGac38dksX7GaxaLYzOWMDpwety5tofNY/OSeo++LasY
	PT5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLH56Cnmgu3aFZ/u
	32RtYNyv0sXIySEhYCKx+0EPI4QtJnHh3nq2LkYuDiGBRYwSG5dMYoJwXjNK3Ll7jh2kildA
	S+L77z9sIDaLgKpE54WnYHE2oPj+FzfA4qICYRIrp19hgagXlPgx+R6YLSJQJvHqZwMLyFBm
	gRtAGw4tZO1i5OAQFnCTeNojC1IjJOAqsf7vK7CLOIHCR/v/gs1nFtCR2N86jQ3ClpfYvOYt
	8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx/Ux6B+OqBotD
	jAIcjEo8vDNzfIOFWBPLiitzDzFKcDArifD+CfULFuJNSaysSi3Kjy8qzUktPsSYDAyBicxS
	osn5wNSTVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M60Ru
	hfQb/WOLPrZj6aYjb59y9K2edmrZw+P/eNRVjq972qJrar2okClkSpK46JOpRjbeyULTcmrz
	zKMffKmrKFxie/K449PCVeXXZHQ8FwVMWT1n+bSoE4qHv7PwM1/6v/Vle0pRh5qq7oFnZzKf
	crgXmYRecvY6+yzt0opwc+bmD1kuc6fqKrEUZyQaajEXFScCADdr9DwzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus Walleij,

I sent this patch with minor modification.
Any comment of this patch?

Best Regards,
Chanwoo Choi

On 04/14/2014 10:45 AM, Chanwoo Choi wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch adds driver data (bank list and EINT layout) for Exynos3250
> to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
> ports. There are 23 general port groups.
> 
> Changes from v1:
> - Add signed-off of sender
> - Post only separated patch for pinctrl from following patchset(v1)
>   : https://lkml.org/lkml/2014/4/10/286
> 
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/pinctrl/pinctrl-exynos.c  | 67 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinctrl-samsung.c |  2 ++
>  drivers/pinctrl/pinctrl-samsung.h |  1 +
>  3 files changed, 70 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
> index 07c8130..9609c23 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -718,6 +718,73 @@ struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
>  	},
>  };
>  
> +/* pin banks of exynos3250 pin-controller 0 */
> +static struct samsung_pin_bank exynos3250_pin_banks0[] = {
> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb",  0x08),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0a0, "gpd0", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpd1", 0x18),
> +};
> +
> +/* pin banks of exynos3250 pin-controller 1 */
> +static struct samsung_pin_bank exynos3250_pin_banks1[] = {
> +	EXYNOS_PIN_BANK_EINTN(8, 0x120, "gpe0"),
> +	EXYNOS_PIN_BANK_EINTN(8, 0x140, "gpe1"),
> +	EXYNOS_PIN_BANK_EINTN(3, 0x180, "gpe2"),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpk0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x060, "gpk1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x080, "gpk2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpl0", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x260, "gpm0", 0x24),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x280, "gpm1", 0x28),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x2a0, "gpm2", 0x2c),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x2c0, "gpm3", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x2e0, "gpm4", 0x34),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xc00, "gpx0", 0x00),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xc20, "gpx1", 0x04),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xc40, "gpx2", 0x08),
> +	EXYNOS_PIN_BANK_EINTW(8, 0xc60, "gpx3", 0x0c),
> +};
> +
> +/*
> + * Samsung pinctrl driver data for Exynos3250 SoC. Exynos3250 SoC includes
> + * two gpio/pin-mux/pinconfig controllers.
> + */
> +struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
> +	{
> +		/* pin-controller instance 0 data */
> +		.pin_banks	= exynos3250_pin_banks0,
> +		.nr_banks	= ARRAY_SIZE(exynos3250_pin_banks0),
> +		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
> +		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
> +		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
> +		.svc		= EXYNOS_SVC_OFFSET,
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos3250-gpio-ctrl0",
> +	}, {
> +		/* pin-controller instance 1 data */
> +		.pin_banks	= exynos3250_pin_banks1,
> +		.nr_banks	= ARRAY_SIZE(exynos3250_pin_banks1),
> +		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
> +		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
> +		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
> +		.weint_con	= EXYNOS_WKUP_ECON_OFFSET,
> +		.weint_mask	= EXYNOS_WKUP_EMASK_OFFSET,
> +		.weint_pend	= EXYNOS_WKUP_EPEND_OFFSET,
> +		.svc		= EXYNOS_SVC_OFFSET,
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.eint_wkup_init = exynos_eint_wkup_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos3250-gpio-ctrl1",
> +	},
> +};
> +
>  /* pin banks of exynos4210 pin-controller 0 */
>  static struct samsung_pin_bank exynos4210_pin_banks0[] = {
>  	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index 0324d4c..3e61d0f 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -1114,6 +1114,8 @@ static struct syscore_ops samsung_pinctrl_syscore_ops = {
>  
>  static const struct of_device_id samsung_pinctrl_dt_match[] = {
>  #ifdef CONFIG_PINCTRL_EXYNOS
> +	{ .compatible = "samsung,exynos3250-pinctrl",
> +		.data = (void *)exynos3250_pin_ctrl },
>  	{ .compatible = "samsung,exynos4210-pinctrl",
>  		.data = (void *)exynos4210_pin_ctrl },
>  	{ .compatible = "samsung,exynos4x12-pinctrl",
> diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
> index bab9c21..b3e41fa 100644
> --- a/drivers/pinctrl/pinctrl-samsung.h
> +++ b/drivers/pinctrl/pinctrl-samsung.h
> @@ -251,6 +251,7 @@ struct samsung_pmx_func {
>  };
>  
>  /* list of all exported SoC specific data */
> +extern struct samsung_pin_ctrl exynos3250_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
>  extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
> 

