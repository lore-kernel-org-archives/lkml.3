Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaKLEIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:08:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30746 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaKLEIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:08:12 -0500
X-AuditID: cbfee68e-f79b46d000002b74-6f-5462dd29eb74
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v2 1/2] drm/exynos: dp: Remove support for unused dptx-phy
Date: Wed, 12 Nov 2014 13:08:53 +0900
Message-id: <000001cffe2e$5f83fd30$1e8bf790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/0RMsilL+Zfp5HRleDa1hcgYiJ6gJ6E1lg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY13Nu0khBl/uSFkceH+QxWL+kXOs
	Fle+vmezaLtykN1i0v0JLBaXF15itbi8aw6bxYzz+5gs5h7MdeD0WLCp1ON+93Emj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4MroWvWAueCocsWTv7wNjBtluhg5OCQETCTuT/LtYuQEMsUk
	Ltxbz9bFyMUhJLCMUeLVyb2sEAkTiXs77kAlpjNKnJk9jREkISTwi1Hi3N8KEJtNQE3iy5fD
	7CC2iICuRM/EjywgDcwCfxglps67BdXgLtE1dR0LiM0p4CGx4msbM4gtLOAn8efYMrA4i4Cq
	xL3lP8HivAK2Ek03l0PZghI/Jt8Dq2EW0JJYv/M4E4QtL7F5zVtmiG/UJR791QUxRQSMJGau
	dYOoEJHY9+IdI8g5EgJv2SV6fk9lhFglIPFt8iEWiFZZiU0HmCH+lZQ4uOIGywRGiVlIFs9C
	sngWksWzkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkfvt2MN48YH2IUYCDUYmH
	N2NzUogQa2JZcWXuIUZToIsmMkuJJucDk0ReSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2M2vJrDup//2we+rJMzPjsakeHn0mrz8oam759dYhBJ3Rp
	qWPczS02y/8sFIvxzvOTCwnKCjqh6Rvqyvb8R9WC7relfFv2Jy34fUhL73XLVrve7XyyrBcW
	bUitrLj1alZo5i3+g4feae2SPOlW97DqY4VuRx3vw/1izCfvvf1zWUdw4duwq5NuK7EUZyQa
	ajEXFScCAFZ7J/zaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV3Nu0khBj/uiloceH+QxWL+kXOs
	Fle+vmezaLtykN1i0v0JLBaXF15itbi8aw6bxYzz+5gs5h7MdeD0WLCp1ON+93Emj74tqxg9
	Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0bXqAXPBUeWKJ395
	Gxg3ynQxcnJICJhI3Ntxhw3CFpO4cG89kM3FISQwnVHizOxpjCAJIYFfjBLn/laA2GwCahJf
	vhxmB7FFBHQleiZ+ZAFpYBb4wygxdd4tqAZ3ia6p61hAbE4BD4kVX9uYQWxhAT+JP8eWgcVZ
	BFQl7i3/CRbnFbCVaLq5HMoWlPgx+R5YDbOAlsT6nceZIGx5ic1r3gLVcABdqi7x6K8uiCki
	YCQxc60bRIWIxL4X7xgnMArNQjJoFpJBs5AMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4PTwTHoH46oGi0OMAhyMSjy8GZuTQoRYE8uKK3MPMUpwMCuJ8D5YChTiTUmsrEot
	yo8vKs1JLT7EaAr050RmKdHkfGDqyiuJNzQ2MTOyNDKzMDIxN1cS5z3Yah0oJJCeWJKanZpa
	kFoE08fEwSnVwLiwUkHsvdpqbuFcqcZWpS33LdrEHEzOnVnfW/7BIub3wuq1P3eKhS5ce0NM
	8WrljGZ/LqYJPw/JtNqLFMU0mfYUHiiwCFvo8+ziMubdIc/3ft4WuuKUmfkEQ7ZDX3/Xfz+b
	uET5sae9ZeLlBcJHfx1f6+h4Q1B4lfi27ar8KVnHD8pWnd1T7qTEUpyRaKjFXFScCAAMtML3
	JQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 30, 2014 10:24 PM, Vivek Gautam wrote:
> 
> Now that we have moved to generic phy based bindings,
> we don't need to have any code related to older dptx-phy.
> Nobody is using this dptx-phy anymore, so removing the
> same.

Right, older dptx-phy was replaced long time ago.
However, it was not removed for DT compatibility.
I think that now these old DT properties can be removed.

I added some comments below.

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> ---
> 
> Changes from V1:
>  - Reworked error handling in exynos_dp_dt_parse_phydata() as commented
>    by Inki.
> 
>  drivers/gpu/drm/exynos/exynos_dp_core.c |   67 ++++++++-----------------------
>  drivers/gpu/drm/exynos/exynos_dp_core.h |    2 -
>  2 files changed, 17 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
> index cd50ece..206163b 100644
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
> @@ -1212,40 +1198,13 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
> 
>  static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
>  {
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
> +	dp->phy = devm_phy_get(dp->dev, "dp");
> +	if (IS_ERR(dp->phy)) {
> +		dev_err(dp->dev, "no DP phy configured\n");
> +		return PTR_ERR(dp->phy);
>  	}
> 
> -err:
> -	of_node_put(dp_phy_node);
> -
> -	return ret;
> +	return 0;
>  }
> 
>  static int exynos_dp_dt_parse_panel(struct exynos_dp_device *dp)
> @@ -1278,8 +1237,16 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
>  		return PTR_ERR(dp->video_info);
> 
>  	ret = exynos_dp_dt_parse_phydata(dp);

In your patch, exynos_dp_dt_parse_phydata() calls only devm_phy_get().
Then, how about calling devm_phy_get() directly and removing
exynos_dp_dt_parse_phydata()? It looks simpler.

Best regards,
Jingoo Han

> -	if (ret)
> -		return ret;
> +	if (ret) {
> +		/*
> +		 * phy itself is not enabled, so we can move forward
> +		 * assigning NULL to phy pointer.
> +		 */
> +		if (ret == -ENOSYS || ret == -ENODEV)
> +			dp->phy = NULL;
> +		else
> +			return ret;
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
> --
> 1.7.10.4

