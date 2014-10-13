Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaJMEzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 00:55:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28185 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaJMEzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 00:55:02 -0400
X-AuditID: cbfee691-f79b86d000004a5a-dd-543b5b234667
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on
 Exynos7
Date: Mon, 13 Oct 2014 13:54:59 +0900
Message-id: <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/iGHNjpMmHE+GbT1qjmK1Xm3ylNwEh0/yg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI13laOsQg3X7jC0O3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWS69fZLKYMH0ti0Xr
	3iPsDrwea+atYfTYtKqTzWP/3DXsHn1bVjF6HL+xncnj8ya5ALYoLpuU1JzMstQifbsErowv
	1x6zF7wSrdhwOaWBcZ9gFyMnh4SAicSfs//ZIGwxiQv31oPZQgLLGCXurbCAq1l0l7mLkQso
	vohRYuPlpSwQzj9GiRcL17ODVLEJGEm8PLiRGcQWEfCQuHtsOTtIEbNAP5PE5d1LmCA6Whkl
	3rTNAuvgBKrqO/8ebJ+wQLDElc6lYN0sAqoSN589ZwSxeQVcJG5v6WKBsAUlfky+B2YzCxhI
	vJ/Vxwphy0tsXvMWqJcD6FZ1iUd/dSGOMJI4f+8mVLm4xKQHD8EOkhCYySHR8vMt1C4BiW+T
	D7FA9MpKbDrADPGypMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5
	xaV56XrJ+bmbGCEpYOIOxvsHrA8xCnAwKvHwWvyxChFiTSwrrsw9xGgKdNFEZinR5Hxgoskr
	iTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGR5SFTqWHf
	RfZoR5ed3loizNYM5itnSD0ISnXdIn9JS+XCqVmu9euUhE3jj9/1ujYl3v1r+91dZ5T7J8cs
	WFEX6RSzaN/FjT1++4wEZpx1CuAo83r6zP7uAsMqZrFOS3ZBkbTpNUYNnXa3JXnXHeRYJvrs
	U9q7m9oSr9Rln7x43JfFJXbp+RclluKMREMt5qLiRAA0J5Kt/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3laOsQg7WPdS0O3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWS69fZLKYMH0ti0Xr
	3iPsDrwea+atYfTYtKqTzWP/3DXsHn1bVjF6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBLlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZX649Zi94JVqx4XJKA+M+wS5GTg4JAROJP4vuMkPYYhIX
	7q1n62Lk4hASWMQosfHyUhYI5x+jxIuF69lBqtgEjCReHtwI1iEi4CFx99hydpAiZoF+JonL
	u5cwQXS0Mkq8aZsF1sEJVNV3/j0biC0sECxxpXMpWDeLgKrEzWfPGUFsXgEXidtbulggbEGJ
	H5PvgdnMAgYS72f1sULY8hKb17wF6uUAulVd4tFfXYgjjCTO37sJVS4uMenBQ/YJjEKzkEya
	hWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOMU8k97BuKrB4hCjAAej
	Eg+vxR+rECHWxLLiytxDjBIczEoivG9trEOEeFMSK6tSi/Lji0pzUosPMZoCPTqRWUo0OR+Y
	/vJK4g2NTcyMLI3MLIxMzM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTA6qM5wermVt/YV
	34Hu1Jg/DzRszy5fIruWzdOVmYnreLRH1BatIO3C814T26Z1V7ztmCXatV70yOlpt2Sv209a
	/WTi5QPulr+rdDcJmr78/1RVZefxa4XXT/V25m3S/rFI6m3pxRkrE0qERL+9ODmDbfrqMKn5
	l/qi5Ov78oK37X63ZoP3j8R4JZbijERDLeai4kQAa9z9k0cDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> Exynos7 also has a separate special gate clock going to the IP
> apart from the usual AHB clock. So add support for the same.

As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
by the driver. Adding only sclk is not enough. 

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> exynos.c
> index 3951a65..7dc6a98 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -35,6 +35,7 @@ struct dwc3_exynos {
>  	struct device		*dev;
> 
>  	struct clk		*clk;

The clock "clk" in Exynos5 just gated all that above 7 clocks, which
we should control separately now in Exynos7.

> +	struct clk		*sclk;
>  	struct regulator	*vdd33;
>  	struct regulator	*vdd10;
>  };
> @@ -139,10 +140,21 @@ static int dwc3_exynos_probe(struct
> platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	/*
> +	 * Exynos7 has a special gate clock going to this IP,
> +	 * which in earlier SoCs was probably concealed.
> +	 */
> +	exynos->sclk = devm_clk_get(dev, "usbdrd30_sclk");
> +	if (IS_ERR(exynos->sclk)) {
> +		dev_info(dev, "no sclk specified\n");
> +		exynos->sclk = NULL;
> +	}
> +
>  	exynos->dev	= dev;
>  	exynos->clk	= clk;
> 
>  	clk_prepare_enable(exynos->clk);
> +	clk_prepare_enable(exynos->sclk);
> 
>  	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
>  	if (IS_ERR(exynos->vdd33)) {
> @@ -185,6 +197,7 @@ err4:
>  err3:
>  	regulator_disable(exynos->vdd33);
>  err2:
> +	clk_disable_unprepare(exynos->sclk);
>  	clk_disable_unprepare(clk);
>  	return ret;
>  }
> @@ -197,6 +210,7 @@ static int dwc3_exynos_remove(struct
> platform_device *pdev)
>  	platform_device_unregister(exynos->usb2_phy);
>  	platform_device_unregister(exynos->usb3_phy);
> 
> +	clk_disable_unprepare(exynos->sclk);
>  	clk_disable_unprepare(exynos->clk);
> 
>  	regulator_disable(exynos->vdd33);
> @@ -218,6 +232,7 @@ static int dwc3_exynos_suspend(struct device *dev)
>  {
>  	struct dwc3_exynos *exynos = dev_get_drvdata(dev);
> 
> +	clk_disable(exynos->sclk);
>  	clk_disable(exynos->clk);
> 
>  	regulator_disable(exynos->vdd33);
> @@ -243,6 +258,7 @@ static int dwc3_exynos_resume(struct device *dev)
>  	}
> 
>  	clk_enable(exynos->clk);
> +	clk_enable(exynos->sclk);
> 
>  	/* runtime set active to reflect active state. */
>  	pm_runtime_disable(dev);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

