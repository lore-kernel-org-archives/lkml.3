Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaIQMGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:06:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22618 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:06:08 -0400
X-AuditID: cbfee68d-f79c46d000000b84-8e-5419792d14b7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1410952662-4297-1-git-send-email-gautam.vivek@samsung.com>
 <1410952662-4297-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1410952662-4297-3-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH v3 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy
 support
Date: Wed, 17 Sep 2014 21:06:05 +0900
Message-id: <001501cfd26f$c1c32bf0$454983d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/SaQobCBgcXouATFqRzBh9g3YOTgABnrAg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ13dSskQg4YNQhZtVw6yWzQvXs9m
	cXnhJVaL3gVXgaxdc9gsZpzfx2SxaFkrs8WE3xfYHDg89s9dw+4x++4PRo++LasYPT5vkgtg
	ieKySUnNySxLLdK3S+DKePVvGXPBUv2KVW3f2BsYV6p2MXJySAiYSOx938UOYYtJXLi3nq2L
	kYtDSGAZo8T7y9MZuxg5wIq2d0tBxKczSlz++Y4RwvnNKDHlzERmkG42ATWJL18Og00SEfCQ
	uHtsOTtIEbPATkaJq49+QHW0MkrsXXSNCaSKE6hq3o+drCC2sECExMUZk5lB1rEIqEo0/I8A
	MXkFbCVufkoHqeAVEJT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBCHqks8+qsLcYKRxMndDewQ
	JSIS+15A3Cwh8JZdYufqu2AJFgEBiW+TD7FA9MpKbDrADAkISYmDK26wTGCUmIVk8ywkm2ch
	2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKit3cH4+0D1ocYBTgYlXh4N1yW
	CBFiTSwrrsw9xGgKdNFEZinR5HxgisgriTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoHRhcd7oYKO9uGdy31W95pNTOzwXccz5bxu/PQ5jMI9cU8Oem5W
	mp+uteZV3MmDtrdWHS1Nfinjx6Ey4dLEs6KzxT9ekmpLrg4xCOR8ofjuzLMwh2cTb0yKCO88
	t7dlQnV57OYtFz3/Oxn/ftR17ZbKOqaDiQu/ie1Uz83PfnnqainTtHvh2w8/UGIpzkg01GIu
	Kk4EAAkV3XXZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQV3dSskQg5fHeS3arhxkt2hevJ7N
	4vLCS6wWvQuuAlm75rBZzDi/j8li0bJWZosJvy+wOXB47J+7ht1j9t0fjB59W1YxenzeJBfA
	EtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdIeS
	QlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePVv2XMBUv1K1a1fWNvYFyp
	2sXIwSEhYCKxvVuqi5ETyBSTuHBvPVsXIxeHkMB0RonLP98xQji/GSWmnJnIDFLFJqAm8eXL
	YXYQW0TAQ+LuseXsIEXMAjsZJa4++gHV0coosXfRNSaQKk6gqnk/drKC2MICERIXZ0xmBlnN
	IqAq0fA/AsTkFbCVuPkpHaSCV0BQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jJDHK0u8eivLsQJ
	RhIndzewQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECE4Nz6R3MK5qsDjEKMDBqMTDu+GyRIgQa2JZcWXuIUYJDmYlEd6+YMkQId6UxMqq
	1KL8+KLSnNTiQ4ymQG9OZJYSTc4Hpq28knhDYxMzI0sjMwsjE3NzJXHeg63WgUIC6Yklqdmp
	qQWpRTB9TBycUg2MfnaXp9U3nWFRODFN61RDoWhDQ+09vu5V5TYByRc2zI8IT+/8d/eK4YwP
	Lv+L2U65hp1nXOarFvA8mXPFx6eab+oi3mxnmXpWLKOh+/mel8phxY4vO25eXH1qxx226wa7
	7+hMlfwe9f6qssmraxvdgzY/y3FS7Pt67P7evZODc5Q/HyuT144MV2Ipzkg01GIuKk4EAHq5
	N1gjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 8:18 PM, Vivek Gautam wrote:
> 
> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/ohci-exynos.c |   89 +++++++++++-----------------------------
>  1 file changed, 24 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 7c48e3f..992b28d 100644
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
> @@ -48,56 +43,40 @@ static int exynos_ohci_get_phy(struct device *dev,
>  {
>  	struct device_node *child;
>  	struct phy *phy;
> -	int phy_number;
> -	int ret = 0;
> +	int phy_num;
> +	int ret;
> 
> -	/*
> -	 * Getting generic phy:
> -	 * We are keeping both types of phys as a part of transiting OHCI
> -	 * to generic phy framework, so as to maintain backward compatibilty
> -	 * with old DTB too.
> -	 * We fallback to older USB-PHYs when we fail to get generic PHYs.
> -	 */
> +	/* Get the generic phys */
>  	for_each_available_child_of_node(dev->of_node, child) {
> -		ret = of_property_read_u32(child, "reg", &phy_number);
> +		ret = of_property_read_u32(child, "reg", &phy_num);
>  		if (ret) {
>  			dev_err(dev, "Failed to parse device tree\n");
>  			of_node_put(child);
>  			return ret;
>  		}
> 
> -		if (phy_number >= PHY_NUMBER) {
> +		if (phy_num >= PHY_NUMBER) {
>  			dev_err(dev, "Invalid number of PHYs\n");
>  			of_node_put(child);
>  			return -EINVAL;
>  		}
> 
> -		phy = devm_of_phy_get(dev, child, NULL);
> +		exynos_ohci->phy[phy_num] = devm_of_phy_get(dev, child, NULL);
> +		phy = exynos_ohci->phy[phy_num];
>  		of_node_put(child);
> -		if (IS_ERR(phy))
> -			/* Lets fallback to older USB-PHYs */
> -			goto usb_phy_old;
> -		exynos_ohci->phy_g[phy_number] = phy;
> -		/* Make the older PHYs unavailable */
> -		exynos_ohci->phy = ERR_PTR(-ENXIO);
> -	}
> -
> -	return 0;
> -
> -usb_phy_old:
> -	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(exynos_ohci->phy)) {
> -		ret = PTR_ERR(exynos_ohci->phy);
> -		if (ret != -ENXIO && ret != -ENODEV) {
> -			dev_err(dev, "no usb2 phy configured\n");
> -			return ret;
> +		if (IS_ERR(phy)) {
> +			ret = PTR_ERR(phy);
> +			if (ret == -EPROBE_DEFER) {
> +				return ret;
> +			} else if (ret != -ENOSYS && ret != -ENODEV) {
> +				dev_err(dev,
> +					"Error retrieving usb2 phy: %d\n", ret);
> +				return PTR_ERR(phy);
> +			}
>  		}
> -		dev_dbg(dev, "Failed to get usb2 phy\n");
> -	} else {
> -		exynos_ohci->otg = exynos_ohci->phy->otg;
>  	}
> 
> -	return ret;
> +	return 0;
>  }
> 
>  static int exynos_ohci_phy_enable(struct device *dev)
> @@ -107,16 +86,13 @@ static int exynos_ohci_phy_enable(struct device *dev)
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
> @@ -127,14 +103,9 @@ static void exynos_ohci_phy_disable(struct device *dev)
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
> @@ -206,9 +177,6 @@ skip_phy:
>  		goto fail_io;
>  	}
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	platform_set_drvdata(pdev, hcd);
> 
>  	err = exynos_ohci_phy_enable(&pdev->dev);
> @@ -241,9 +209,6 @@ static int exynos_ohci_remove(struct platform_device *pdev)
> 
>  	usb_remove_hcd(hcd);
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	exynos_ohci_phy_disable(&pdev->dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> @@ -272,9 +237,6 @@ static int exynos_ohci_suspend(struct device *dev)
>  	if (rc)
>  		return rc;
> 
> -	if (exynos_ohci->otg)
> -		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> -
>  	exynos_ohci_phy_disable(dev);
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> @@ -290,9 +252,6 @@ static int exynos_ohci_resume(struct device *dev)
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

