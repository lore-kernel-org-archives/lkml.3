Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3GJOyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:54:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56576 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:54:49 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-62-51dd75b7f861
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-4-git-send-email-dianders@chromium.org>
In-reply-to: <1373411961-23812-4-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2 3/5] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
Date: Wed, 10 Jul 2013 23:54:47 +0900
Message-id: <002a01ce7d7d$6bd9e870$438db950$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac58+vEp4WQJXai6Riq0HDZwyU/4twAeSNTA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zY93tpXcDDTqOmVk8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurRe+Cq2wWmx5fY7W4vGsOm8WR//2MFjPO72Oy
	OHX9M5vFql1/GB34PGY3XGTx2DnrLrtHz84zjB6Hrqxl9Ni8pN7jyokmVo++LasYPT5vkgvg
	iOKySUnNySxLLdK3S+DKmP/wFGtBu2jFoWu/WRoYPwp0MXJySAiYSCy9OI8RwhaTuHBvPRuI
	LSSwjFFi6uFSmJo7rXuYuhi5gOLTGSU2Xv/NDOH8YZTYf20PC0gVm4CWxN83b5hBbBEBL4kX
	ux+A2cwCV5klWncaQDTsYZTouv8daAUHB6eAm8TK41UgNcIC8RK/991hBwmzCKhKnGiOAwnz
	CthK7Jr6lQ3CFpT4MfkeC8RIA4n3s/pYIWx5ic1r3jKDtEoIqEs8+qsLcYGRxIcpf5kgSkQk
	9r14xwhygYTAFg6Jn597wB5mERCQ+Db5EAtEr6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ
	5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJEZIcencw3j5gfYgxGWj9RGYp0eR8
	YHLJK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMj
	o+6aU99jF0/Mf/abUUbTeNd7Xl4Xi1fOB5mma971Wifh+710o3Nzxtr/B1RnVpcvnerNyHr4
	/5nWf72NqmbF2xi2lH1N5/AKqlU779C8fM7paXJLwzZc7c22/fy2ParOaGvWM3/pcxJNl4Ik
	WrrdZs/KfJyR9OzL5zKT1sOrl3zq2Z/FwDlXiaU4I9FQi7moOBEA0FPhYCQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQd3tpXcDDfYfMbR4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi94FV9ksNj2+xmpxedccNosj//sZLWac38dk
	cer6ZzaLVbv+MDrwecxuuMjisXPWXXaPnp1nGD0OXVnL6LF5Sb3HlRNNrB59W1YxenzeJBfA
	EdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLiS
	QlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP+w1OsBe2iFYeu/WZpYPwo
	0MXIySEhYCJxp3UPE4QtJnHh3nq2LkYuDiGB6YwSG6//ZoZw/jBK7L+2hwWkik1AS+LvmzfM
	ILaIgJfEi90PwGxmgavMEq07DSAa9jBKdN3/DjSKg4NTwE1i5fEqkBphgXiJ3/vusIOEWQRU
	JU40x4GEeQVsJXZN/coGYQtK/Jh8jwVipIHE+1l9rBC2vMTmNW+ZQVolBNQlHv3VhbjASOLD
	lL9MECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxgpPPM6kdjCsbLA4xCnAwKvHwNsTfDRRiTSwrrsw9xCjBwawkwqtuBRTiTUmsrEotyo8v
	Ks1JLT7EmAz050RmKdHkfGBizCuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampB
	ahHMFiYOTqkGxrNplntPLk2xLpNQNZ7fPEug2eFB2NLHhT/tLJafr9Oetyb97NvHe3Z2L782
	N41Z4WOXaqLmyhcCBgW9t88sOfJN12zaiQ+XbK/VT5W3sVr/5JZAyHMv09cHZU8Kf4veK+m4
	qsvGU/TpapUGha8zQ1dzb4tq/1x4I2nz72yLXAMTz9KoCZXdk5VYijMSDbWYi4oTAZKq7ROC	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 10, 2013, Doug Anderson wrote:
> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
> looping around forever.  This has been seen to happen on exynos5420
> silicon despite the fact that we haven't enabled any wakeup events.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Use suspend_noirq as per James Hogan.
> 
>  drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index f013e7e..36b9620 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -30,6 +30,7 @@
>  #define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
>  					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
>  					SDMMC_CLKSEL_CCLK_DIVIDER(z))
> +#define SDMMC_CLKSEL_WAKEUP_INT		BIT(11)
> 
>  #define SDMMC_CMD_USE_HOLD_REG		BIT(29)
> 
> @@ -102,6 +103,27 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>  	return 0;
>  }
> 
> +/**
> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
> + *
> + * We have seen cases (at least on the exynos5420) where turning off the INT
> + * power rail during suspend will leave the WAKEUP_INT bit in the CLKSEL
> + * register asserted.  This bit is 1 to indicate that it fired and we can
> + * clear it by writing a 1 back.  Clear it to prevent interrupts from going off
> + * constantly.
> + */
As I know this bit is auto-cleared.
Did you find the cause of this problem?
How about your GPIO setting in sleep?
Currently, we don't know why the problem is happened.
At least, we should make it clear.

Thanks,
Seungwon Jeon

> +
> +static int dw_mci_exynos_resume_noirq(struct dw_mci *host)
> +{
> +	u32 clksel;
> +
> +	clksel = mci_readl(host, CLKSEL);
> +	if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
> +		mci_writel(host, CLKSEL, clksel);
> +
> +	return 0;
> +}
> +
>  static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	/*
> @@ -165,6 +187,7 @@ static const struct dw_mci_drv_data exynos_drv_data = {
>  	.caps			= exynos_dwmmc_caps,
>  	.init			= dw_mci_exynos_priv_init,
>  	.setup_clock		= dw_mci_exynos_setup_clock,
> +	.resume_noirq		= dw_mci_exynos_resume_noirq,
>  	.prepare_command	= dw_mci_exynos_prepare_command,
>  	.set_ios		= dw_mci_exynos_set_ios,
>  	.parse_dt		= dw_mci_exynos_parse_dt,
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

