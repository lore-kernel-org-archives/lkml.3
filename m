Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaHRBgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:36:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17901 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaHRBgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:36:11 -0400
X-AuditID: cbfee690-b7f526d000003627-2f-53f1588992ce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        s.nawrocki@samsung.com, k.debski@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
 <1408026240-28365-7-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1408026240-28365-7-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH RFC 6/7] usb: host: ehci-exynos: Remove unnecessary usb-phy
 support
Date: Mon, 18 Aug 2014 10:36:08 +0900
Message-id: <009f01cfba84$c8ebf4f0$5ac3ded0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+3y37D2Xo/nRV0TcCnGn5ixyfM/ACuRyVg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zY93OiI/BBqeeMVscvF9vMf/IOVaL
	tisH2S0O/NnBaNG8eD2bxeWFl1gtfry+AGTtmsNmsWhZK7PF4TftrBYTfl9gc+D2uHNtD5vH
	/rlr2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC2CL4rJJSc3JLEst0rdL4Mr4caeLpWCvesW6OTfZ
	GhhfyXcxcnJICJhIvGi8zQJhi0lcuLeeDcQWEljGKLHysjdMzfUl/9i7GLmA4osYJRa0LGCE
	cH4zSmw9cJgVpIpNQE3iy5fD7CC2iICuRM/Ej2BTmQV6mSSuTtWBaGhnlGjaNBVsBaeAp8Ss
	Y6sYQWxhgUiJY3sugDWzCKhKnH99Cmwor4CtxLQnB9kgbEGJH5PvQQ3Vkli/8zgThC0vsXnN
	W+YuRg6gU9UlHv3VhbjBSOLTt1lQJSIS+168AztaQqCTQ+LV4vtMELsEJL5NPsQC0SsrsekA
	M8THkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+du
	YoTE+4QdjPcOWB9iTAZaP5FZSjQ5H5gu8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBsaRU91yhyuzuUvV1v0p5vQryNXWbJTlu261OCo3Xl+aq
	quTQ57hafMhO5/Q2w/tmW3i/8Bh66ds9uRtccyL9qkRP3fcF0bla4hezT2YacV75+PWxqYWs
	sIHnz5+fP/xb9Lr8opf82utaN95Nsbqz4jjrG9VpxVePezzu1sqcnXBk4pbPflIXlViKMxIN
	tZiLihMBqVoCNw0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd2OiI/BBlPPW1scvF9vMf/IOVaL
	tisH2S0O/NnBaNG8eD2bxeWFl1gtfry+AGTtmsNmsWhZK7PF4TftrBYTfl9gc+D2uHNtD5vH
	/rlr2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeY8eNOF0vBXvWKdXNusjUwvpLvYuTkkBAwkbi+5B87hC0mceHeerYuRi4OIYFF
	jBILWhYwQji/GSW2HjjMClLFJqAm8eXLYbAOEQFdiZ6JH1lAbGaBXiaJq1N1IBraGSWaNk1l
	A0lwCnhKzDq2ihHEFhaIlDi25wJYM4uAqsT516fAhvIK2EpMe3KQDcIWlPgx+R7UUC2J9TuP
	M0HY8hKb17xl7mLkADpVXeLRX12IG4wkPn2bBVUiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnA
	yLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzidPJPawbiyweIQowAHoxIPr8frD8FCrIll
	xZW5hxglOJiVRHgvBQCFeFMSK6tSi/Lji0pzUosPMZoCPTqRWUo0OR+Y6vJK4g2NTcyMLI3M
	LIxMzM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTAeWvDkxoyNlsnvD7/ZNO3PrIr5BwSn
	Hes7NC1DYhHXMcng7Q36HE+/7VeaFPp6nv0fTsVXR8/vsg59GvL+6Oa33pKibfYGL+5mxTW1
	i27R3FPfLVd6n7fY96fAnL0PN83d3H8nMCjHq+170/l508Qd77+fzRmo6TiVTaI7dsOM3Kra
	C39v9TBdVGIpzkg01GIuKk4EANQ7kXc9AwAA
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
> This should fix the issue on ehci-exynos, wherein in the absence of
> SAMSUNG_USB2PHY config symbol, we ended up getting the NOP_USB_XCEIV phy
> when the same is enabled. And thus the PHYs are not configured properly.
> 
> Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/ehci-exynos.c |   53 ++++++----------------------------------
>  1 file changed, 8 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index cda0a2f..54944cc 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -21,11 +21,8 @@
>  #include <linux/of_gpio.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> -#include <linux/usb/phy.h>
> -#include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> -#include <linux/usb/otg.h>
> 
>  #include "ehci.h"
> 
> @@ -47,9 +44,7 @@ static struct hc_driver __read_mostly exynos_ehci_hc_driver;
> 
>  struct exynos_ehci_hcd {
>  	struct clk *clk;
> -	struct usb_phy *phy;
> -	struct usb_otg *otg;
> -	struct phy *phy_g[PHY_NUMBER];
> +	struct phy *phy[PHY_NUMBER];
>  };
> 
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> @@ -62,18 +57,6 @@ static int exynos_ehci_get_phy(struct device *dev,
>  	int phy_number;
>  	int ret = 0;
> 
> -	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(exynos_ehci->phy)) {
> -		ret = PTR_ERR(exynos_ehci->phy);
> -		if (ret != -ENXIO && ret != -ENODEV) {
> -			dev_err(dev, "no usb2 phy configured\n");
> -			return ret;
> -		}
> -		dev_dbg(dev, "Failed to get usb2 phy\n");
> -	} else {
> -		exynos_ehci->otg = exynos_ehci->phy->otg;
> -	}
> -
>  	for_each_available_child_of_node(dev->of_node, child) {
>  		ret = of_property_read_u32(child, "reg", &phy_number);
>  		if (ret) {
> @@ -98,7 +81,7 @@ static int exynos_ehci_get_phy(struct device *dev,
>  			}
>  			dev_dbg(dev, "Failed to get usb2 phy\n");
>  		}
> -		exynos_ehci->phy_g[phy_number] = phy;
> +		exynos_ehci->phy[phy_number] = phy;
>  	}
> 
>  	return ret;
> @@ -111,16 +94,13 @@ static int exynos_ehci_phy_enable(struct device *dev)
>  	int i;
>  	int ret = 0;
> 
> -	if (!IS_ERR(exynos_ehci->phy))
> -		return usb_phy_init(exynos_ehci->phy);
> -
>  	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ehci->phy_g[i]))
> -			ret = phy_power_on(exynos_ehci->phy_g[i]);
> +		if (!IS_ERR(exynos_ehci->phy[i]))
> +			ret = phy_power_on(exynos_ehci->phy[i]);
>  	if (ret)
>  		for (i--; i >= 0; i--)
> -			if (!IS_ERR(exynos_ehci->phy_g[i]))
> -				phy_power_off(exynos_ehci->phy_g[i]);
> +			if (!IS_ERR(exynos_ehci->phy[i]))
> +				phy_power_off(exynos_ehci->phy[i]);
> 
>  	return ret;
>  }
> @@ -131,14 +111,9 @@ static void exynos_ehci_phy_disable(struct device *dev)
>  	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
>  	int i;
> 
> -	if (!IS_ERR(exynos_ehci->phy)) {
> -		usb_phy_shutdown(exynos_ehci->phy);
> -		return;
> -	}
> -
>  	for (i = 0; i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ehci->phy_g[i]))
> -			phy_power_off(exynos_ehci->phy_g[i]);
> +		if (!IS_ERR(exynos_ehci->phy[i]))
> +			phy_power_off(exynos_ehci->phy[i]);
>  }
> 
>  static void exynos_setup_vbus_gpio(struct device *dev)
> @@ -231,9 +206,6 @@ skip_phy:
>  		goto fail_io;
>  	}
> 
> -	if (exynos_ehci->otg)
> -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>  	err = exynos_ehci_phy_enable(&pdev->dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "Failed to enable USB phy\n");
> @@ -273,9 +245,6 @@ static int exynos_ehci_remove(struct platform_device *pdev)
> 
>  	usb_remove_hcd(hcd);
> 
> -	if (exynos_ehci->otg)
> -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>  	exynos_ehci_phy_disable(&pdev->dev);
> 
>  	clk_disable_unprepare(exynos_ehci->clk);
> @@ -298,9 +267,6 @@ static int exynos_ehci_suspend(struct device *dev)
>  	if (rc)
>  		return rc;
> 
> -	if (exynos_ehci->otg)
> -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>  	exynos_ehci_phy_disable(dev);
> 
>  	clk_disable_unprepare(exynos_ehci->clk);
> @@ -316,9 +282,6 @@ static int exynos_ehci_resume(struct device *dev)
> 
>  	clk_prepare_enable(exynos_ehci->clk);
> 
> -	if (exynos_ehci->otg)
> -		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);
> -
>  	ret = exynos_ehci_phy_enable(dev);
>  	if (ret) {
>  		dev_err(dev, "Failed to enable USB phy\n");
> --
> 1.7.10.4

