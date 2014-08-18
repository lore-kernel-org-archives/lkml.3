Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaHRBhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:37:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29840 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaHRBg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:36:59 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-6a-53f158b87109
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        s.nawrocki@samsung.com, k.debski@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
 <1408026240-28365-8-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1408026240-28365-8-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH RFC 7/7] usb: host: ohci-exynos: Remove unnecessary usb-phy
 support
Date: Mon, 18 Aug 2014 10:36:56 +0900
Message-id: <00a001cfba84$e57cbb40$b07631c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+3y4Elg+gbQy2jRu+e9jr/BEZC7wCuUnDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zA92dER+DDe5uYLQ4eL/eYv6Rc6wW
	bVcOslsc+LOD0aJ58Xo2i8sLL7Fa/Hh9AcjaNYfNYtGyVmaLw2/aWS0m/L7A5sDtcefaHjaP
	/XPXsHvMvvuD0aNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXxa1YjS8FzrYonradY
	GxjnK3UxcnBICJhI9Cz06WLkBDLFJC7cW88GYgsJLGOUmLy/BiJuIjHx7WamLkYuoPh0Rokj
	fUuZIZzfjBLLt5xiAqliE1CT+PLlMDuILSKgK9Ez8SMLiM0s0MskcXWqDkRDO6PEj1NPwFZw
	CnhK/O+ZCtYgLBAp0btgFSuIzSKgKtG3Yx0TyHW8ArYSU7fJgoR5BQQlfky+BzVTS2L9zuNM
	ELa8xOY1b5khnlGXePRXF+IEI4m2P7dYIUpEJPa9eMcIcoKEQC+HRPPFZywQqwQkvk0+xALR
	Kyux6QAzxMOSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525ihMR63w7GmwesDzEmA62fyCwlmpwPTBV5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx2YJrZu/O+yf/TNfSOlRQ/jD6vbfowmkHzf/z
	RKg23i1cKb/nnUjBxIv2Mo2zph9QWldd+NdB9OnBT+r53jydPD5XH61YuE+jyeyGTYDbfn2B
	j7dWTZu+pOaWwLP+1Ofse65lP9f68vZz64d9XjFqsxx7H86cvDH1gcKJ4NTkSf7PJnVyHkvZ
	osRSnJFoqMVcVJwIAADEdiQLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd0dER+DDQ4dsrQ4eL/eYv6Rc6wW
	bVcOslsc+LOD0aJ58Xo2i8sLL7Fa/Hh9AcjaNYfNYtGyVmaLw2/aWS0m/L7A5sDtcefaHjaP
	/XPXsHvMvvuD0aNvyypGj+M3tjN5fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0n5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsI4x49esRpaC51oVT1pPsTYwzlfqYuTkkBAwkZj4djMThC0mceHeerYuRi4OIYHp
	jBJH+pYyQzi/GSWWbzkFVsUmoCbx5cthdhBbREBXomfiRxYQm1mgl0ni6lQdiIZ2Rokfp56w
	gSQ4BTwl/vdMBWsQFoiU6F2wihXEZhFQlejbsQ5oKAcHr4CtxNRtsiBhXgFBiR+T70HN1JJY
	v/M4E4QtL7F5zVtmkHIJAXWJR391IU4wkmj7c4sVokREYt+Ld4wTGIVmIZk0C8mkWUgmzULS
	soCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDJ5JrWDcWWDxSFGAQ5GJR5ej9cfgoVY
	E8uKK3MPMUpwMCuJ8F4KAArxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjDR5ZXEGxqbmBlZ
	GplZGJmYmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYNxdPpGxYe6WYLEbm8SNPrX02iUI
	iOm9edf469QxPTfxmwunSb+Yf1Caca6LVcez+8X2j7RaX76TXjcx4sC5/QXHi9cab72oeD5P
	oofF7J3PrRzJarvZEn/7L3O9vP/ti+3kzr17XW1Mlnn2Hkx6U/XH1YKF0Yvl8PzJ6htdar8s
	635zWP7AzVglluKMREMt5qLiRABQOlVwPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 14, 2014 11:24 PM, Vivek Gautam wrote:
> 
> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
> This should fix the issue on ohci-exynos, wherein in the absence of
> SAMSUNG_USB2PHY config symbol, we ended up getting the NOP_USB_XCEIV phy
> when the same is enabled. And thus the PHYs are not configured properly.
> 
> Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/ohci-exynos.c |   64 ++++++----------------------------------
>  1 file changed, 9 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index a72ab8f..0199a8b 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -19,11 +19,8 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/phy/phy.h>
> -#include <linux/usb/phy.h>
> -#include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> -#include <linux/usb/otg.h>
> 
>  #include "ohci.h"
> 
> @@ -38,9 +35,7 @@ static struct hc_driver __read_mostly exynos_ohci_hc_driver;
> 
>  struct exynos_ohci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> -	struct usb_otg *otg;
> -	struct phy *phy_g[PHY_NUMBER];
> +	struct phy *phy[PHY_NUMBER];
>  };
> 
>  static int exynos_ohci_get_phy(struct device *dev,
> @@ -51,28 +46,7 @@ static int exynos_ohci_get_phy(struct device *dev,
>  	int phy_number;
>  	int ret = 0;
> 
> -	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(exynos_ohci->phy)) {
> -		ret = PTR_ERR(exynos_ohci->phy);
> -		if (ret != -ENXIO && ret != -ENODEV) {
> -			dev_err(dev, "no usb2 phy configured\n");
> -			return ret;
> -		}
> -		dev_dbg(dev, "Failed to get usb2 phy\n");
> -	} else {
> -		exynos_ohci->otg = exynos_ohci->phy->otg;
> -	}
> -
> -	/*
> -	 * Getting generic phy:
> -	 * We are keeping both types of phys as a part of transiting OHCI
> -	 * to generic phy framework, so as to maintain backward compatibilty
> -	 * with old DTB.
> -	 * If there are existing devices using DTB files built from them,
> -	 * to remove the support for old bindings in this driver,
> -	 * we need to make sure that such devices have their DTBs
> -	 * updated to ones built from new DTS.
> -	 */
> +	/* Get the generic phys */
>  	for_each_available_child_of_node(dev->of_node, child) {
>  		ret = of_property_read_u32(child, "reg", &phy_number);
>  		if (ret) {
> @@ -97,7 +71,7 @@ static int exynos_ohci_get_phy(struct device *dev,
>  			}
>  			dev_dbg(dev, "Failed to get usb2 phy\n");
>  		}
> -		exynos_ohci->phy_g[phy_number] = phy;
> +		exynos_ohci->phy[phy_number] = phy;
>  	}
> 
>  	return ret;
> @@ -110,16 +84,13 @@ static int exynos_ohci_phy_enable(struct device *dev)
>  	int i;
>  	int ret = 0;
> 
> -	if (!IS_ERR(exynos_ohci->phy))
> -		return usb_phy_init(exynos_ohci->phy);
> -
>  	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ohci->phy_g[i]))
> -			ret = phy_power_on(exynos_ohci->phy_g[i]);
> +		if (!IS_ERR(exynos_ohci->phy[i]))
> +			ret = phy_power_on(exynos_ohci->phy[i]);
>  	if (ret)
>  		for (i--; i >= 0; i--)
> -			if (!IS_ERR(exynos_ohci->phy_g[i]))
> -				phy_power_off(exynos_ohci->phy_g[i]);
> +			if (!IS_ERR(exynos_ohci->phy[i]))
> +				phy_power_off(exynos_ohci->phy[i]);
> 
>  	return ret;
>  }
> @@ -130,14 +101,9 @@ static void exynos_ohci_phy_disable(struct device *dev)
>  	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
>  	int i;
> 
> -	if (!IS_ERR(exynos_ohci->phy)) {
> -		usb_phy_shutdown(exynos_ohci->phy);
> -		return;
> -	}
> -
>  	for (i = 0; i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ohci->phy_g[i]))
> -			phy_power_off(exynos_ohci->phy_g[i]);
> +		if (!IS_ERR(exynos_ohci->phy[i]))
> +			phy_power_off(exynos_ohci->phy[i]);
>  }
> 
>  static int exynos_ohci_probe(struct platform_device *pdev)
> @@ -209,9 +175,6 @@ skip_phy:
>  		goto fail_io;
>  	}
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	platform_set_drvdata(pdev, hcd);
> 
>  	err = exynos_ohci_phy_enable(&pdev->dev);
> @@ -244,9 +207,6 @@ static int exynos_ohci_remove(struct platform_device *pdev)
> 
>  	usb_remove_hcd(hcd);
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	exynos_ohci_phy_disable(&pdev->dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> @@ -275,9 +235,6 @@ static int exynos_ohci_suspend(struct device *dev)
>  	if (rc)
>  		return rc;
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	exynos_ohci_phy_disable(dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> @@ -293,9 +250,6 @@ static int exynos_ohci_resume(struct device *dev)
> 
>  	clk_prepare_enable(exynos_ohci->clk);
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	ret = exynos_ohci_phy_enable(dev);
>  	if (ret) {
>  		dev_err(dev, "Failed to enable USB phy\n");
> --
> 1.7.10.4

