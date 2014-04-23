Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaDWMoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:44:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62541 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDWMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:44:38 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-50-5357b5b489f8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <1398082604-3013-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1398082604-3013-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 2/3] usb: ehci-exynos: Make provision for vdd regulators
Date: Wed, 23 Apr 2014 21:44:36 +0900
Message-id: <000b01cf5ef1$c8d5ae50$5a810af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW58eK2gL/imURc27avXugSxevgBlgpuQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ90tW8ODDZ7MN7E4eL/eou3KQXaL
	5sXr2SwuL7zEatG74CqbxabH11gtLu+aw2Yxe0k/i8WM8/uYLBYta2W2mPD7ApsDt8f+uWvY
	PTYvqfeYffcHo0ffllWMHsdvbGfy+LxJLoAtissmJTUnsyy1SN8ugStj7rSnbAX9chWr7vs2
	MO6R6GLk5JAQMJE4NqGBBcIWk7hwbz1bFyMXh5DAMkaJrqetzDBF/1ZvYoFILGKU6Hs8ix3C
	+c0ocXlVL1gVm4CaxJcvh9lBbBEBXYmeiR/BOpgFVjBJbHy4Cqq9lVHi29lusIWcAh4StyZ8
	BesQFvCROPf8NZjNIqAq0bN4MhuIzStgK3Gh4TsrhC0o8WPyPbBeZgEtifU7jzNB2PISm9e8
	BbqCA+hWdYlHf3UhjjCSuN40GapcRGLfi3eMIDdICPRySPzesI8NYpeAxLfJh1ggemUlNh2A
	ellS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	kHifsIPx3gHrQ4zJQOsnMkuJJucD00VeSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTBO1P9XfOPBx+Vzcj4bF7pFTrMSbGoUX6Pq1PtihdevlpRt
	qpfv6zCVW+VGJv1PWXSuXOPwSuFqB/ef7t4MN6ZU1YSnZk2+tUD2tfm34y0ekxJOPWorOCnz
	dOZcae6tq0tuRgkmfKr5t10+cubFr1zl0rwGyedXsi30PLJK/tDRmtrlZ+Pi2NuVWIozEg21
	mIuKEwEo5FogDQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd0tW8ODDd791bM4eL/eou3KQXaL
	5sXr2SwuL7zEatG74CqbxabH11gtLu+aw2Yxe0k/i8WM8/uYLBYta2W2mPD7ApsDt8f+uWvY
	PTYvqfeYffcHo0ffllWMHsdvbGfy+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jxtxpT9kK+uUqVt33bWDcI9HFyMkhIWAi8W/1JhYIW0ziwr31bF2MXBxCAosY
	Jfoez2KHcH4zSlxe1csMUsUmoCbx5cthdhBbREBXomfiRxaQImaBFUwSGx+uYoHoaGWU+Ha2
	G2wup4CHxK0JX8E6hAV8JM49fw1mswioSvQsnswGYvMK2EpcaPjOCmELSvyYfA+sl1lAS2L9
	zuNMELa8xOY1b4Gu4AC6VV3i0V9diCOMJK43TYYqF5HY9+Id4wRGoVlIJs1CMmkWkkmzkLQs
	YGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcTJ5J7WBc2WBxiFGAg1GJh7dgZViwEGti
	WXFl7iFGCQ5mJRHeJYvCg4V4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jo8kriDY1NzIws
	jcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB8eDRQ5XaMz6vfHbxnSDrvcoZ
	sQnFytNtrzeGzi947VR21UUmcOLsv3UHV7cWHNwq4Gj5ivGDrKe97ImbV3TZn6h01V15UG7B
	0a5YnbZcyzpS9qCrcY2NqLzMqY9SXou3S1bUsDreK2llEpEvSzkf+VDrqLWI7+eupI6/nwVf
	mG0S1Wf/eXqxEktxRqKhFnNRcSIAlnQU3WoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
> 
> Facilitate getting required 3.3V and 1.0V VDD supply for
> EHCI controller on Exynos.
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
>  drivers/usb/host/ehci-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index d1d8c47..a3ca8cc 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -20,6 +20,7 @@
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/usb/phy.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <linux/usb.h>
> @@ -46,6 +47,8 @@ struct exynos_ehci_hcd {
>  	struct clk *clk;
>  	struct usb_phy *phy;
>  	struct usb_otg *otg;
> +	struct regulator *vdd33;
> +	struct regulator *vdd10;
>  };
> 
>  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
> @@ -112,6 +115,28 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  		exynos_ehci->otg = phy->otg;
>  	}
> 
> +	exynos_ehci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> +	if (IS_ERR(exynos_ehci->vdd33)) {
> +		err = PTR_ERR(exynos_ehci->vdd33);
> +		goto fail_regulator1;
> +	}
> +	err = regulator_enable(exynos_ehci->vdd33);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
> +		goto fail_regulator1;
> +	}
> +
> +	exynos_ehci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
> +	if (IS_ERR(exynos_ehci->vdd10)) {
> +		err = PTR_ERR(exynos_ehci->vdd10);
> +		goto fail_regulator2;
> +	}
> +	err = regulator_enable(exynos_ehci->vdd10);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
> +		goto fail_regulator2;
> +	}
> +
>  skip_phy:
> 
>  	exynos_ehci->clk = devm_clk_get(&pdev->dev, "usbhost");
> @@ -178,6 +203,10 @@ fail_add_hcd:
>  fail_io:
>  	clk_disable_unprepare(exynos_ehci->clk);
>  fail_clk:
> +	regulator_disable(exynos_ehci->vdd10);
> +fail_regulator2:
> +	regulator_disable(exynos_ehci->vdd33);
> +fail_regulator1:
>  	usb_put_hcd(hcd);
>  	return err;
>  }
> @@ -197,6 +226,9 @@ static int exynos_ehci_remove(struct platform_device *pdev)
> 
>  	clk_disable_unprepare(exynos_ehci->clk);
> 
> +	regulator_disable(exynos_ehci->vdd10);
> +	regulator_disable(exynos_ehci->vdd33);
> +
>  	usb_put_hcd(hcd);
> 
>  	return 0;
> @@ -221,6 +253,9 @@ static int exynos_ehci_suspend(struct device *dev)
> 
>  	clk_disable_unprepare(exynos_ehci->clk);
> 
> +	regulator_disable(exynos_ehci->vdd10);
> +	regulator_disable(exynos_ehci->vdd33);
> +
>  	return rc;
>  }
> 
> @@ -228,6 +263,18 @@ static int exynos_ehci_resume(struct device *dev)
>  {
>  	struct usb_hcd *hcd = dev_get_drvdata(dev);
>  	struct exynos_ehci_hcd *exynos_ehci = to_exynos_ehci(hcd);
> +	int ret;
> +
> +	ret = regulator_enable(exynos_ehci->vdd33);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable VDD33 supply\n");
> +		return ret;
> +	}
> +	ret = regulator_enable(exynos_ehci->vdd10);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable VDD10 supply\n");
> +		return ret;
> +	}
> 
>  	clk_prepare_enable(exynos_ehci->clk);
> 
> --
> 1.7.10.4

