Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaFBC0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:26:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaFBC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:26:35 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-11-538be0d91b76
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/3] phy: exynos-dp-video: Use PTR_ERR_OR_ZERO
Date: Mon, 02 Jun 2014 11:26:32 +0900
Message-id: <005201cf7e0a$11d1d250$357576f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac97B940+CBpAlVlRs22rpF3J3iwggDAfrag
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY92bD7qDDTafELa4vPASq8WFpz1s
	Fpd3zWGzOPmnl9GBxePOtT1sHn1bVjF6HL+xncnj8ya5AJYoLpuU1JzMstQifbsEroxpd1vY
	Cy5zVvw70srSwPiTvYuRk0NCwERie/9DVghbTOLCvfVsXYxcHEICyxgldl9+xgpTNGnNFSaI
	xCJGiaOnZrJDOL8ZJf4/38wIUsUmoCbx5cthsLEiAhES7Usbgbo5OJgFXCSOThMBCQsJuEvc
	P7+PCcTmFPCQOP4OolxYwEni/cSjYOUsAqoSDVPNQMK8ArYSU782skHYghI/Jt9jAbGZBbQk
	1u88zgRhy0tsXvOWGaRVQkBd4tFfXYgDjCTuzZwMVSIise/FO0aQiyUEzrFLbJ26BSzBIiAg
	8W3yIRaIXlmJTQeYId6VlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEiv
	ODG3uDQvXS85P3cTIyQm+3Yw3jxgfYgxGWj9RGYp0eR8YEznlcQbGpsZWZiamBobmVuakSas
	JM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGrscXVQM/7bDRY9U7XqnCt1v3Vv82
	JvNa//8bjnz/1rLuw4udOjZvH4u9Oe3wfLmLh5nM5Ytu94I2236aYWbusl0hMG/mwjkzE64K
	ave+1jj2et32CVYHNdW4DhcUuKYuOcCb1cu/Yf6diU5zIl/PDT7B/M0m2Sw01Vh5x8c/WlbS
	Bm1POrnuKbEUZyQaajEXFScCAD1+lsjfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd2bD7qDDdY+47e4vPASq8WFpz1s
	Fpd3zWGzOPmnl9GBxePOtT1sHn1bVjF6HL+xncnj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMaXdb2Asuc1b8O9LK0sD4k72LkZNDQsBEYtKaK0wQtpjEhXvr
	2boYuTiEBBYxShw9NZMdwvnNKPH/+WZGkCo2ATWJL18Og3WLCERItC9tZO1i5OBgFnCRODpN
	BCQsJOAucf/8PrChnAIeEsffQZQLCzhJvJ94FKycRUBVomGqGUiYV8BWYurXRjYIW1Dix+R7
	LCA2s4CWxPqdx5kgbHmJzWveMoO0SgioSzz6qwtxgJHEvZmToUpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf8M+kdjKsaLA4xCnAwKvHw
	XujtChZiTSwrrsw9xCjBwawkwnv0bHewEG9KYmVValF+fFFpTmrxIcZkoD8nMkuJJucDk1Fe
	SbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDOu2Lg4qrT+93/
	gmjFFP8s/k6dM9t8FL6t26yv85VX/8dKw6vPWZU3irhGFRfs/OG3vHVn35TTugt2aAWXMy5T
	/GC699UJaR4pzfUsz1l3n/t26+x+2e1CXlFLnkaz+K+e2mhtn3Jr4waN3IX393e4au2cePfg
	2Uk+29akBjmHve2dv23RXsf9SizFGYmGWsxFxYkAvww47DwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2014 3:31 PM, Sachin Kamat wrote:
> 
> PTR_ERR_OR_ZERO simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/phy/phy-exynos-dp-video.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
> index 0786fef842e7..098f822a2fa4 100644
> --- a/drivers/phy/phy-exynos-dp-video.c
> +++ b/drivers/phy/phy-exynos-dp-video.c
> @@ -9,6 +9,7 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -84,10 +85,8 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>  	phy_set_drvdata(phy, state);
> 
>  	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> -	if (IS_ERR(phy_provider))
> -		return PTR_ERR(phy_provider);
> 
> -	return 0;
> +	return PTR_ERR_OR_ZERO(phy_provider);
>  }
> 
>  static const struct of_device_id exynos_dp_video_phy_of_match[] = {
> --
> 1.7.9.5

