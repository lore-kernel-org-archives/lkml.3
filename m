Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKLJk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:40:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49952 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaKLJkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:40:21 -0500
X-AuditID: cbfee68d-f79296d000004278-88-54632b03707c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@google.com, ajaykumar.rs@samsung.com,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAFp+6iEZDdFp14LfPWRM7QXxbYV=LrVChsj5gj_BBHR1rBX+QA@mail.gmail.com>
 <1415784480-20435-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1415784480-20435-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v3 1/2] drm/exynos: dp: Remove support for unused dptx-phy
Date: Wed, 12 Nov 2014 18:41:03 +0900
Message-id: <000001cffe5c$c69fc700$53df5500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/+WvZQObDSlGyhQJyz/zYZ8S2SagAAaD1Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zY11m7eQQg57tIhYH3h9ksZh/5Byr
	xZWv79ks2q4cZLd4+30Lu8Wk+xNYLC4vvMRqcXnXHDaLGef3MVnMPZjrwOWxc9Zddo8Fm0o9
	7ncfZ/Lo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujDfPjjMWbFauuPH+HVsDY49MFyMHh4SA
	icTytuQuRk4gU0ziwr31bF2MXBxCAssYJc7Mfs0CkTCR2LFzLztEYjqjxKn9j5ghnF+MEntP
	TGYFqWITUJP48uUwO4gtIqAnMa15HiNIEbPAciaJ51MboNonMkosXX6CEaSKU8BT4vSlD2A7
	hAX8JFp3T2AEuYlFQFWifUUmSJhXwFbi0u12JghbUOLH5Htg5cwCWhLrdx5ngrDlJTavecsM
	8Y66xKO/uiCmiICRxJMbRhAVIhL7XrwDO0dCoJFDomV9IxtIgkVAQOLb5EMsEK2yEpsOMEM8
	LClxcMUNlgmMErOQLJ6FZPEsJItnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZI
	XPfuYLx9wPoQowAHoxIPb8KapBAh1sSy4srcQ4ymQBdNZJYSTc4HJo+8knhDYzMjC1MTU2Mj
	c0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYDS5Pf6w5P1K87L4ye9jzZ63u
	X0XsT//lfFnyXmy35El/m1qXqTeZQ+xldauO7Qk9eHnvt343d62IszOWe4R8Ur3veOlFB2PW
	854CK7eZf0+6rOgpquWKmnb/SPAHRi6ztRaPfLsnFi11kTN2nVl/oERhN8v9V33CLu/P8t1N
	99CbW/xOurRHiaU4I9FQi7moOBEAMVD1SOYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV1m7eQQg44z/BYH3h9ksZh/5Byr
	xZWv79ks2q4cZLd4+30Lu8Wk+xNYLC4vvMRqcXnXHDaLGef3MVnMPZjrwOWxc9Zddo8Fm0o9
	7ncfZ/Lo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlv
	nh1nLNisXHHj/Tu2BsYemS5GTg4JAROJHTv3skPYYhIX7q1n62Lk4hASmM4ocWr/I2YI5xej
	xN4Tk1lBqtgE1CS+fDkM1iEioCcxrXkeI0gRs8ByJonnUxvYITomMkosXX6CEaSKU8BT4vSl
	DywgtrCAn0Tr7glAcQ4OFgFVifYVmSBhXgFbiUu325kgbEGJH5PvgZUzC2hJrN95nAnClpfY
	vOYtM0irhIC6xKO/uiCmiICRxJMbRhAVIhL7XrxjnMAoNAvJoFlIBs1CMmgWkpYFjCyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYLTxjOpHYwrGywOMQpwMCrx8CauSQoRYk0sK67MPcQo
	wcGsJML76StQiDclsbIqtSg/vqg0J7X4EKMp0JsTmaVEk/OBKS2vJN7Q2MTMyNLIzMLIxNxc
	SZz3QKt1oJBAemJJanZqakFqEUwfEwenVAPjuTktiyT4S37MbRQ52VRUFvFDb5Gu0+SO+l3x
	GVYu8ta377gFF197y2l4JNspyiZyxXXnZx/WzRWduOfLIrbNJvmlF6431d3Z8zkopeZgY579
	H+5rPkc4ok/xRW2LXnu1/273sS0MJaf/52+t7Ih8/PK4bar107JZb5+5snp1tK+xeHC/VNBC
	iaU4I9FQi7moOBEANNuEnDEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2014 6:28 PM, Vivek Gautam wrote:
> 
> Now that we have moved to generic phy based bindings,
> we don't need to have any code related to older dptx-phy.
> Nobody is using this dptx-phy anymore, so removing the
> same.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Changes from V2:
>  - Moved devm_phy_get() call out of exynos_dp_dt_parse_phydata() to
>    exynos_dp_bind() function and,
>    removed exynos_dp_dt_parse_phydata() function, since it was only
>    getting the PHY.
> 
> Changes from V1:
>  - Reworked error handling in exynos_dp_dt_parse_phydata() as commented
>    by Inki.
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
> --
> 1.7.10.4

