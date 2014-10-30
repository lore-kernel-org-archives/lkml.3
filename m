Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbaJ3MUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:20:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbaJ3MUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:20:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f791c6d000004834-a9-54522cf75c5d
Content-transfer-encoding: 8BIT
Message-id: <54522CF7.6030302@samsung.com>
Date: Thu, 30 Oct 2014 21:20:07 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, kishon@ti.com, ajaykumar.rs@samsung.com,
        Jingoo Han <jg1.han@samsung.com>, "cpgs ." <cpgs@samsung.com>
Subject: Re: [PATCH 2/3] drm/exynos: dp: Remove support for unused dptx-phy
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
 <1410786785-9838-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1410786785-9838-3-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkRPe7TlCIweFTahYH3h9ksXh5SNNi
	/pFzrBZXvr5ns2i7cpDd4vLCS6wWF572sFlc3jWHzWLG+X1MFnMP5jpweSzYVOpxv/s4k0ff
	llWMHsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugStj0hGWgk75imeXV7I1MF6V6GLk5JAQMJG4
	OG8xM4QtJnHh3nq2LkYuDiGBpYwSV2+vZ4UpevHpDStEYhGjxJp/ZxhBErwCghI/Jt9j6WLk
	4GAWkJc4cikbJMwsoC4xad4iZoj6V4wS1/5cgKrXklh2vYcFxGYRUJV4sfUu2AI2IHviivts
	ILaoQJjEi1e7wC4SEdCW2D53EivE0GYmia39giC7hAW8JV7c4wMJCwm0Mkos+OgLYnMKeEi8
	fb+OCWSvhMAjdomH6x4zQewSkPg2+RDYnRICshKbDkA9LClxcMUNlgmMYrOQfDML4ZtZSL5Z
	wMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwEk//e9a/g/HuAetDjAIcjEo8vBonAkOE
	WBPLiitzDzGaAh0xkVlKNDkfGO95JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgPKYqu0Y0ojHY6Zkph86jw6HJ97sDtgrkFFye3dii1HzCbEbNc8fY
	+7f/B52ueP6+MV3f9c4csxU/GzWUS36u7NpgvumfepX9VjY5IZ2Fs2b15f2LWyAmuO26bQar
	+K3SUG7pCXkyuRdWnXOcF3zpec435VNP72d/efHIX1O3dirjPOeTd+4sVmIpzkg01GIuKk4E
	AF+Z6vO/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAd3vOkEhBjeOy1oceH+QxeLlIU2L
	+UfOsVpc+fqezaLtykF2i8sLL7FaXHjaw2ZxedccNosZ5/cxWcw9mOvA5bFgU6nH/e7jTB59
	W1Yxehy/sZ3J4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGZOO
	sBR0ylc8u7ySrYHxqkQXIyeHhICJxItPb1ghbDGJC/fWs3UxcnEICSxilFjz7wwjSIJXQFDi
	x+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR/4pR4tqfC1D1WhLLrvewgNgsAqoSL7beBVvA
	BmRPXHGfDcQWFQiTePFqFzOILSKgLbF97iRWiKHNTBJb+wVBdgkLeEu8uMcHEhYSaGWUWPDR
	F8TmFPCQePt+HdMERoFZSK6bhXDdLCTXLWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HOfPpHYwrmywOMQowMGoxMOrcSIwRIg1say4MvcQowQHs5IIr6BCUIgQb0piZVVqUX58UWlO
	avEhRlOg3yYyS4km5wNTUF5JvKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQimD4m
	Dk6pBsajRdc3fpdgX+a3WHH6W3+F/dHdjzd5frjHa61re4vPc32U3Yrlbre/Re0zXrjEvEOY
	XT4wtWqx57GIvIn/j5h9vRHh8uziX1cvnqxLK34miNXInJzJG+yuFNtaNCfiBZfWosnXq2Vn
	uFnG+E5sFTkvZZiQl/ln34a+337O73i3WUrOPsr56qwSS3FGoqEWc1FxIgAufD43CQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for late. I missed this patch a little bit for long time.


On 2014년 09월 15일 22:13, Vivek Gautam wrote:
> Now that we have moved to generic phy based bindings,
> we don't need to have any code related to older dptx-phy.
> Nobody is using this dptx-phy anymore, so removing the
> same.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_dp_core.c |   58 +++++++------------------------
>  drivers/gpu/drm/exynos/exynos_dp_core.h |    2 --
>  2 files changed, 13 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
> index 4f3c7eb..5ffc1b2 100644
> --- a/drivers/gpu/drm/exynos/exynos_dp_core.c
> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
> @@ -1050,28 +1050,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
>  
>  static void exynos_dp_phy_init(struct exynos_dp_device *dp)
>  {
> -	if (dp->phy) {
> +	if (dp->phy)
>  		phy_power_on(dp->phy);
> -	} else if (dp->phy_addr) {
> -		u32 reg;
> -
> -		reg = __raw_readl(dp->phy_addr);
> -		reg |= dp->enable_mask;
> -		__raw_writel(reg, dp->phy_addr);
> -	}
>  }
>  
>  static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
>  {
> -	if (dp->phy) {
> +	if (dp->phy)
>  		phy_power_off(dp->phy);
> -	} else if (dp->phy_addr) {
> -		u32 reg;
> -
> -		reg = __raw_readl(dp->phy_addr);
> -		reg &= ~(dp->enable_mask);
> -		__raw_writel(reg, dp->phy_addr);
> -	}
>  }
>  
>  static void exynos_dp_poweron(struct exynos_drm_display *display)
> @@ -1210,39 +1196,21 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
>  
>  static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
>  {
> -	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
> -	u32 phy_base;
>  	int ret = 0;
>  
> -	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
> -	if (!dp_phy_node) {
> -		dp->phy = devm_phy_get(dp->dev, "dp");
> -		return PTR_ERR_OR_ZERO(dp->phy);
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> -		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
> -				&dp->enable_mask)) {
> -		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
> -	dp->phy_addr = ioremap(phy_base, SZ_4);
> -	if (!dp->phy_addr) {
> -		dev_err(dp->dev, "failed to ioremap dp-phy\n");
> -		ret = -ENOMEM;
> -		goto err;
> +	dp->phy = devm_phy_get(dp->dev, "dp");
> +	if (IS_ERR(dp->phy)) {
> +		ret = PTR_ERR(dp->phy);
> +		if (ret == -ENOSYS || ret == -ENODEV) {
> +			dp->phy = NULL;
> +		} else if (ret == -EPROBE_DEFER) {
> +			return ret;
> +		} else {

WARNING: else is not generally useful after a break or return
#146: FILE: drivers/gpu/drm/exynos/exynos_dp_core.c:1208:
+			return ret;
+		} else {

How about just returning ret like below?
		if (IS_ERR(dp->phy)) {
			dev_err(dp->dev, "no DP phy configured\n");
			return PTR_ERR(ret);
		}

And then you can handle the error at probe function properly.

Thanks,
Inki Dae


> +			dev_err(dp->dev, "no DP phy configured\n");
> +			return ret;
> +		}
>  	}
>  
> -err:
> -	of_node_put(dp_phy_node);
> -
>  	return ret;
>  }
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.h b/drivers/gpu/drm/exynos/exynos_dp_core.h
> index a1aee69..6426201 100644
> --- a/drivers/gpu/drm/exynos/exynos_dp_core.h
> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.h
> @@ -153,8 +153,6 @@ struct exynos_dp_device {
>  	struct clk		*clock;
>  	unsigned int		irq;
>  	void __iomem		*reg_base;
> -	void __iomem		*phy_addr;
> -	unsigned int		enable_mask;
>  
>  	struct video_info	*video_info;
>  	struct link_train	link_train;
> 

