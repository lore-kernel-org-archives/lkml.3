Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaKMIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:51:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52956 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbaKMIvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:51:12 -0500
X-AuditID: cbfee68d-f79296d000004278-3a-546470fe4314
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <546470FE.90008@samsung.com>
Date: Thu, 13 Nov 2014 17:51:10 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        "cpgs ." <cpgs@samsung.com>
Subject: Re: [PATCH v3 RESEND 1/2] drm/exynos: dp: Remove support for unused
 dptx-phy
References: <000001cffe5c3df5500$%han@samsung.com>
 <1415785330-28123-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1415785330-28123-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkSPdfQUqIwaW1WhYH3h9ksXh5SNPi
	ytf3bBZtVw6yW/QuuMpmcXnXHDaLGef3MVnMPZjrwOGxYFOpx/3u40wefVtWMXp83iQXwBLF
	ZZOSmpNZllqkb5fAlfHiZAtTwX3FitPNJ1kaGF9LdTFycEgImEhcflnSxcgJZIpJXLi3nq2L
	kYtDSGApo8SXv5tYIRImEv0zX0MlpgMlrt4HS/AKCEr8mHyPBcRmFlCXmDRvETOELSJxZF8r
	O4StLbFs4WtmiOZXjBI9K08wQzRrSPxeeIcJxGYRUJWYt/sYmM0GZE9ccZ8NxBYVCJN48WoX
	WL0I0KDtcyexggxiFjjNKDGj5ShYkbBAuMSRDdvALhISKJS403WXEcTmFPCU2Pj5ERNIg4TA
	KXaJt78Ws0FsE5D4NvkQC8T/shKbDjBDvCkpcXDFDZYJjOKzkDw3C8lzs5A8NwvJcwsYWVYx
	iqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBMbo6X/Pencw3j5gfYhRgINRiYf3BUtKiBBrYllx
	Ze4hRlOgiyYyS4km5wMTQV5JvKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYwnP2k2X7+twHP+5TSP1yFOG6tCGzj+aKh8YDyU2pfXLyjTFzJtZnfB4vrN
	tlVHXPtrWQJtgxTaP33VSRfN+nztikGU6+M2D/ci+ccqa789uLbC48Kkqt2WK9n0Va9c+ymY
	eabH92HH80MBW2VcDKSaW7/8/aW8aEn3Url5X/g+HbVc/3HK6SolluKMREMt5qLiRAB15v0I
	zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd1/BSkhBiemKVsceH+QxeLlIU2L
	K1/fs1m0XTnIbtG74CqbxeVdc9gsZpzfx2Qx92CuA4fHgk2lHve7jzN59G1ZxejxeZNcAEtU
	A6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMH6vPsRQsVqxoa8tvYFwv1cXI
	ySEhYCLRP/M1G4QtJnHh3nogm4tDSGA6o8SXq/dZQRK8AoISPybfY+li5OBgFpCXOHIpGyTM
	LKAuMWneImaI+leMEj0rTzBD1GtI/F54hwnEZhFQlZi3+xiYzQZkT1xxH2yZqECYxItXu8Dq
	RQS0JbbPncQKMohZ4DSjxIyWo2BFwgLhEkc2bAM7QkigUOJO111GEJtTwFNi4+dHTBMYBWYh
	uW8Wwn2zkNy3gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwND+T2sG4ssHiEKMAB6MS
	D+8LlpQQIdbEsuLK3EOMEhzMSiK8TTpAId6UxMqq1KL8+KLSnNTiQ4ymQN9NZJYSTc4HJpq8
	knhDYxMzI0sjc0MLI2NzJXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2MZhVKrMFaEz7f6/x/
	Pb2x5t+2XU61c9mUpq28Ju4saxW97NqB5sOswZ/Kp1kezbT7elv50xTOpaq6FseqXqvwHzzx
	ne9BmEUan8iFl7IK73LzU5auFvko73JF0Oj9du1fUgXzAqaZCSc+4FgxK9P625cTDPNMvqdd
	/lgn5B7Es4uLvz8i/ImvEktxRqKhFnNRcSIA3RkOqfwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 12일 18:42, Vivek Gautam wrote:
> Now that we have moved to generic phy based bindings,
> we don't need to have any code related to older dptx-phy.
> Nobody is using this dptx-phy anymore, so removing the
> same.

Applied.

Thanks,
Inki Dae

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> ---
> 
> Problem with my mail client caused change in author's mail id.
> So resending it with authorship under my Samsung id.
> 
>  drivers/gpu/drm/exynos/exynos_dp_core.c |   74 +++++++------------------------
>  drivers/gpu/drm/exynos/exynos_dp_core.h |    2 -
>  2 files changed, 17 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
> index cd50ece..dbe9add 100644
> --- a/drivers/gpu/drm/exynos/exynos_dp_core.c
> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
> @@ -1052,28 +1052,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
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
> @@ -1210,44 +1196,6 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
>  	return dp_video_config;
>  }
>  
> -static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
> -{
> -	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
> -	u32 phy_base;
> -	int ret = 0;
> -
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
> -	}
> -
> -err:
> -	of_node_put(dp_phy_node);
> -
> -	return ret;
> -}
> -
>  static int exynos_dp_dt_parse_panel(struct exynos_dp_device *dp)
>  {
>  	int ret;
> @@ -1277,9 +1225,21 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
>  	if (IS_ERR(dp->video_info))
>  		return PTR_ERR(dp->video_info);
>  
> -	ret = exynos_dp_dt_parse_phydata(dp);
> -	if (ret)
> -		return ret;
> +	dp->phy = devm_phy_get(dp->dev, "dp");
> +	if (IS_ERR(dp->phy)) {
> +		dev_err(dp->dev, "no DP phy configured\n");
> +		ret = PTR_ERR(dp->phy);
> +		if (ret) {
> +			/*
> +			 * phy itself is not enabled, so we can move forward
> +			 * assigning NULL to phy pointer.
> +			 */
> +			if (ret == -ENOSYS || ret == -ENODEV)
> +				dp->phy = NULL;
> +			else
> +				return ret;
> +		}
> +	}
>  
>  	if (!dp->panel) {
>  		ret = exynos_dp_dt_parse_panel(dp);
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

