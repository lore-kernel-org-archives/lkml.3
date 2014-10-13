Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaJMFCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:02:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26647 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMFCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:02:31 -0400
X-AuditID: cbfee68d-f79296d000004278-ef-543b5ce400f3
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1412677176-3850-3-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 2/4] phy: exynos5-usbdrd: Add pipe-clk and utmi-clk
 support
Date: Mon, 13 Oct 2014 14:02:27 +0900
Message-id: <00f201cfe6a2$e2e829b0$a8b87d10$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/iGHePpvlUOOFsQTiepu8izdFQsQEiWrnA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zY90nMdYhBhsnqVscvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktll6/yGQxYfpaFovW
	vUfYHXg91sxbw+ixaVUnm8f+uWvYPfq2rGL0OH5jO5PH501yAWxRXDYpqTmZZalF+nYJXBkv
	XxxlKZiiVHF9zi3GBsZN0l2MnBwSAiYSW/5sZ4ewxSQu3FvP1sXIxSEksIxR4uGBwywwRacn
	LWAEsYUEpjNKLH0YBlH0j1Fi8++ZbCAJNgEjiZcHNzKD2CICHhJ3jy1nByliFuhnkri8ewkT
	REcro0TD7qlgYzmBqg5O3MraxcjBISwQIvH4nRVImEVAVWJq10qwQbwCLhLrl9xggbAFJX5M
	vgdmMwsYSLyf1ccKYctLbF7zlhlkjISAusSjv7oQNxhJXLrxjhGiRFxi0oOHYPdICMzlkLh/
	6gYrxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckF
	xUnpRYZ6xYm5xaV56XrJ+bmbGCEpoHcH4+0D1ocYBTgYlXh4Lf5YhQixJpYVV+YeYjQFumgi
	s5Rocj4w0eSVxBsamxlZmJqYGhuZW5opifMqSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cAYyFMf9eTJUp7jezOjdAzatm1++OZ17M3MU28buM7sufHww2GNx5puJ16+TFP4diHRZK6Z
	1CQJrrnHaqri//Xdcl3X9LZrybp24YviBh+mChREnL4o9lJAYs9DJ+GXTSL8h7ve3PYpuOa8
	TMVx69JHM2a22q5f677iUfm5YzKLtid+mOp1LPV5mBJLcUaioRZzUXEiABouxpP8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd0nMdYhBv+eK1ocvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktll6/yGQxYfpaFovW
	vUfYHXg91sxbw+ixaVUnm8f+uWvYPfq2rGL0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCXKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgzXr44ylIwRani+pxbjA2Mm6S7GDk5JARMJE5PWsAIYYtJ
	XLi3ng3EFhKYziix9GFYFyMXkP2PUWLz75lgCTYBI4mXBzcyg9giAh4Sd48tZwcpYhboZ5K4
	vHsJE0RHK6NEw+6pLCBVnEBVByduZe1i5OAQFgiRePzOCiTMIqAqMbVrJdggXgEXifVLbrBA
	2IISPybfA7OZBQwk3s/qY4Ww5SU2r3nLDDJGQkBd4tFfXYgbjCQu3XjHCFEiLjHpwUP2CYxC
	s5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjBPJPewbiqweIQ
	owAHoxIPr8UfqxAh1sSy4srcQ4wSHMxKIrxvbaxDhHhTEiurUovy44tKc1KLDzGaAj06kVlK
	NDkfmPzySuINjU3MjCyNzCyMTMzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwbt4iKH7/
	22G9YP7lF2abyhw7oPbWnc+kZfu7b4lWl3MehmwNt5s163t4f0aY2q4jp2TWzLepYkrTlz+T
	rijVcanw/hbRfTwXT2p2iefEFLxe0bZb6lN+57fZ22TaNVW1daw/5/WJHONm67gyKcSZwe9J
	SEzN//wZgrHXeF3eC2yN+Zi15egfJZbijERDLeai4kQAr1mvTUYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> Exynos7 SoC has now separate gate control for 125MHz pipe3 phy
> clock, as well as 60MHz utmi phy clock.
> So get the same and control in the phy-exynos5-usbdrd driver.

In case of the PHY the situation is pretty much the same as with
DWC3 core. Here we should control 6 clocks to make Exynos7 USB DRD
PHY working.

By the way, the driver name phy-exynos5-usbdrd.c doesn't imply it
supports Exynos7 :)

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |    4 ++++
>  drivers/phy/phy-exynos5-usbdrd.c                   |   22
> ++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index 15e0f2c..c2bc9dc 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -138,6 +138,10 @@ Required properties:
>  	       PHY operations, associated by phy name. It is used to
>  	       determine bit values for clock settings register.
>  	       For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
> +	- optional clocks: Exynos7 SoC has now following additional
> +			   gate clocks available:
> +			   - phy_pipe: for PIPE3 phy
> +			   - phy_utmi: for UTMI+ phy
>  - samsung,pmu-syscon: phandle for PMU system controller interface,
> used to
>  		      control pmu registers for power isolation.
>  - #phy-cells : from the generic PHY bindings, must be 1;
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-
> exynos5-usbdrd.c
> index f756aca..013ee84 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -148,6 +148,8 @@ struct exynos5_usbdrd_phy_drvdata {
>   * @dev: pointer to device instance of this platform device
>   * @reg_phy: usb phy controller register memory base
>   * @clk: phy clock for register access
> + * @pipeclk: clock for pipe3 phy
> + * @utmiclk: clock for utmi+ phy
>   * @drv_data: pointer to SoC level driver data structure
>   * @phys[]: array for 'EXYNOS5_DRDPHYS_NUM' number of PHY
>   *	    instances each with its 'phy' and 'phy_cfg'.
> @@ -161,6 +163,8 @@ struct exynos5_usbdrd_phy {
>  	struct device *dev;
>  	void __iomem *reg_phy;
>  	struct clk *clk;
> +	struct clk *pipeclk;
> +	struct clk *utmiclk;
>  	const struct exynos5_usbdrd_phy_drvdata *drv_data;
>  	struct phy_usb_instance {
>  		struct phy *phy;
> @@ -446,6 +450,8 @@ static int exynos5_usbdrd_phy_power_on(struct phy
> *phy)
> 
>  	dev_dbg(phy_drd->dev, "Request to power_on usbdrd_phy phy\n");
> 
> +	clk_prepare_enable(phy_drd->utmiclk);
> +	clk_prepare_enable(phy_drd->pipeclk);
>  	clk_prepare_enable(phy_drd->ref_clk);
> 
>  	/* Enable VBUS supply */
> @@ -464,6 +470,8 @@ static int exynos5_usbdrd_phy_power_on(struct phy
> *phy)
> 
>  fail_vbus:
>  	clk_disable_unprepare(phy_drd->ref_clk);
> +	clk_disable_unprepare(phy_drd->pipeclk);
> +	clk_disable_unprepare(phy_drd->utmiclk);
> 
>  	return ret;
>  }
> @@ -483,6 +491,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy
> *phy)
>  		regulator_disable(phy_drd->vbus);
> 
>  	clk_disable_unprepare(phy_drd->ref_clk);
> +	clk_disable_unprepare(phy_drd->pipeclk);
> +	clk_disable_unprepare(phy_drd->utmiclk);
> 
>  	return 0;
>  }
> @@ -582,6 +592,18 @@ static int exynos5_usbdrd_phy_probe(struct
> platform_device *pdev)
>  		return PTR_ERR(phy_drd->clk);
>  	}
> 
> +	phy_drd->pipeclk = devm_clk_get(dev, "phy_pipe");
> +	if (IS_ERR(phy_drd->pipeclk)) {
> +		dev_info(dev, "PIPE3 phy operational clock not
> specified\n");
> +		phy_drd->pipeclk = NULL;
> +	}
> +
> +	phy_drd->utmiclk = devm_clk_get(dev, "phy_utmi");
> +	if (IS_ERR(phy_drd->utmiclk)) {
> +		dev_info(dev, "UTMI phy operational clock not specified\n");
> +		phy_drd->utmiclk = NULL;
> +	}
> +
>  	phy_drd->ref_clk = devm_clk_get(dev, "ref");
>  	if (IS_ERR(phy_drd->ref_clk)) {
>  		dev_err(dev, "Failed to get reference clock of usbdrd
> phy\n");
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

