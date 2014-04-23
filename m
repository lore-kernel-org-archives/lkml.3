Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaDWMnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:43:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49954 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaDWMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:43:35 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-dc-5357b57534f7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
Date: Wed, 23 Apr 2014 21:43:33 +0900
Message-id: <000a01cf5ef1$a3111a10$e9334e30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW5pZQjqvGcUATj+zeP3Unp+51QBlcoJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zfd3SreHBBh8ny1scvF9v0XblILtF
	8+L1bBaXF15itehdcJXNYtPja6wWl3fNYbOYvaSfxWLG+X1MFouWtTJbTPh9gc2B22P/3DXs
	HpuX1HvMvvuD0aNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJWx4d01xoLHchVXHi5j
	bGBsk+xi5OSQEDCR6Fq3mBnCFpO4cG89WxcjF4eQwDJGiSUXHzDDFL07MpMJIjGdUWJ501pW
	COc3o8SZ/n+MIFVsAmoSX74cZgexRQR0JXomfmQBKWIWWMEksfHhKhaQhJCAu8S5xTOYQGxO
	AQ+JI6eWsILYwgI+EhPu3wAbxCKgKjFzVQdYDa+ArcTef5fYIGxBiR+T74HNYRbQkli/8zgT
	hC0vsXnNW6BTOYBOVZd49FcX4gYjifuHzzNDlIhI7HvxjhHkHgmBqRwSOza1MEHsEpD4NvkQ
	C0SvrMSmA1AfS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRES7xN2MN47YH2IMRlo/URmKdHkfGC6yCuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1R
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxuwlMvtbjzCzH5BwmVd1w2T+lW9V/Q+7bCo+
	rtBsXpzwijl/cvrePV/mzmP59fJ75nw/Wf1n0ze+3WlvckCBz2n1+QVZi59kC6uqKtl533CT
	2NTUWuvheHzhcsZ9/REcv48u1+Tkac84+/eYwUWjc1WzNEWSBMMudd7a++5/3rew7M2Tbs6Q
	2KjEUpyRaKjFXFScCAD/9RBQDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd3SreHBBqvPS1ocvF9v0XblILtF
	8+L1bBaXF15itehdcJXNYtPja6wWl3fNYbOYvaSfxWLG+X1MFouWtTJbTPh9gc2B22P/3DXs
	HpuX1HvMvvuD0aNvyypGj+M3tjN5fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsI4xY8O7a4wFj+UqrjxcxtjA2CbZxcjJISFgIvHuyEwmCFtM4sK99WxdjFwcQgLT
	GSWWN61lhXB+M0qc6f/HCFLFJqAm8eXLYXYQW0RAV6Jn4kcWkCJmgRVMEhsfrmIBSQgJuEuc
	WzwDbCyngIfEkVNLWEFsYQEfiQn3b4ANYhFQlZi5qgOshlfAVmLvv0tsELagxI/J98DmMAto
	SazfeZwJwpaX2LzmLXMXIwfQqeoSj/7qQtxgJHH/8HlmiBIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwcnkmdQOxpUNFocYBTgYlXh4C1aG
	BQuxJpYVV+YeYpTgYFYS4V2yKDxYiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBiS6vJN7Q
	2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhXmbCEFc68rOX/ROnc
	VO0+kXT181XL/eZ8995T+fi8YMz9vRN9n1Qaf7pe52sVb2xe/M7R+UGGmU6t4/Hyl0fWLDkQ
	49297SHbJF2tmbqVNVE/VvazpEtLXnQ7FH2Cq5PpZqHk3q3lxyu5/s1pyo/m+PP8oITu/9Iz
	5Z/ON+symW34oauSfF2JpTgj0VCLuag4EQCnK27yagMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> 
> Facilitate getting required 3.3V and 1.0V VDD supply for
> OHCI controller on Exynos.
> 
> With patches for regulators' nodes merged in 3.15:
> c8c253f ARM: dts: Add regulator entries to smdk5420
> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> 
> certain perripherals will now need to ensure that,
> they request VDD regulators in their drivers, and enable
> them so as to make them working.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> 
> Based on 'usb-next' branch of Greg's usb tree.
> 
>  drivers/usb/host/ohci-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 68588d8..e2e72a8 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -18,6 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/usb/phy.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
> @@ -37,6 +38,8 @@ struct exynos_ohci_hcd {
>  	struct clk *clk;
>  	struct usb_phy *phy;
>  	struct usb_otg *otg;
> +	struct regulator *vdd33;
> +	struct regulator *vdd10;
>  };
> 
>  static void exynos_ohci_phy_enable(struct platform_device *pdev)
> @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>  		exynos_ohci->otg = phy->otg;
>  	}
> 
> +	exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> +	if (IS_ERR(exynos_ohci->vdd33)) {
> +		err = PTR_ERR(exynos_ohci->vdd33);
> +		goto fail_regulator1;
> +	}
> +	err = regulator_enable(exynos_ohci->vdd33);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
> +		goto fail_regulator1;
> +	}
> +
> +	exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
> +	if (IS_ERR(exynos_ohci->vdd10)) {
> +		err = PTR_ERR(exynos_ohci->vdd10);
> +		goto fail_regulator2;
> +	}
> +	err = regulator_enable(exynos_ohci->vdd10);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
> +		goto fail_regulator2;
> +	}
> +
>  skip_phy:
>  	exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
> 
> @@ -154,6 +179,10 @@ fail_add_hcd:
>  fail_io:
>  	clk_disable_unprepare(exynos_ohci->clk);
>  fail_clk:
> +	regulator_disable(exynos_ohci->vdd10);
> +fail_regulator2:
> +	regulator_disable(exynos_ohci->vdd33);
> +fail_regulator1:
>  	usb_put_hcd(hcd);
>  	return err;
>  }
> @@ -172,6 +201,9 @@ static int exynos_ohci_remove(struct platform_device *pdev)
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> 
> +	regulator_disable(exynos_ohci->vdd10);
> +	regulator_disable(exynos_ohci->vdd33);
> +
>  	usb_put_hcd(hcd);
> 
>  	return 0;
> @@ -208,6 +240,9 @@ static int exynos_ohci_suspend(struct device *dev)
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> 
> +	regulator_disable(exynos_ohci->vdd10);
> +	regulator_disable(exynos_ohci->vdd33);
> +
>  	spin_unlock_irqrestore(&ohci->lock, flags);
> 
>  	return 0;
> @@ -218,6 +253,18 @@ static int exynos_ohci_resume(struct device *dev)
>  	struct usb_hcd *hcd			= dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
>  	struct platform_device *pdev		= to_platform_device(dev);
> +	int ret;
> +
> +	ret = regulator_enable(exynos_ohci->vdd33);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable VDD33 supply\n");
> +		return ret;
> +	}
> +	ret = regulator_enable(exynos_ohci->vdd10);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable VDD10 supply\n");
> +		return ret;
> +	}
> 
>  	clk_prepare_enable(exynos_ohci->clk);
> 
> --
> 1.7.10.4

