Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbaH0MOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:14:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40991 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaH0MOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:14:05 -0400
X-AuditID: cbfee68f-f797f6d000001173-27-53fdcb8a59e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <2141307.zYQLjP6V6U@amdc1032>
In-reply-to: <2141307.zYQLjP6V6U@amdc1032>
Subject: Re: [PATCH] usb: dwc3: exynos: remove usb_phy_generic support
Date: Wed, 27 Aug 2014 21:14:02 +0900
Message-id: <005501cfc1f0$63bf7fc0$2b3e7f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BzAWwRmtwr28iTS2ZcWueAKahswAI60Yg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA92u03+DDea9M7fYOGM9q8XB+/UW
	bVcOsltcXniJ1aJ3wVU2i7NNb4DcXXPYLGac38dksWhZK7PFqeuf2Ry4PK6caGL16NuyitHj
	+I3tTB6fN8kFsERx2aSk5mSWpRbp2yVwZSxq7WAqmKtW8W7HZOYGxm75LkZODgkBE4kL/VOY
	IGwxiQv31rN1MXJxCAksY5Q4uGQtK0zRlVNnWEBsIYFFjBJrGrwhin4zStyZtYINJMEmoCbx
	5cthdhBbRCBaYt7aTnaQImaB1UwSyx79YILo1pT437sfbBKngJbE6wmPwOLCAm4S3devgG1j
	EVCV6Dr6krGLkYODV8BW4vFLZ5Awr4CgxI/J98BamYFa1+88zgRhy0tsXvOWGaRcQkBd4tFf
	XYgTjCRuvN3MDlEiIrHvxTtGkHMkBH6ySxx91sgMsUpA4tvkQywQvbISmw4wQ/wrKXFwxQ2W
	CYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkg89+9gvHvA
	+hCjAAejEg/vhwV/goVYE8uKK3MPMZoCXTSRWUo0OR+YNPJK4g2NzYwsTE1MjY3MLc2UxHkX
	Sv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC48G38Grmol/9CXwtMYGc/u2vNypgnKyvF
	dUo0bm41jSoyaGYxnt0cfzie9alC3JGXG0Q6hDy1tN0Tr0tE1L+9v29Rx1p+285cHufIUGmD
	47aLO+27bbg2SrId+XTT+d987r2mUzm+vd44YVYOr0QH/xpjPcbqV3eMLv8vaznsb9T2bcot
	wQVKLMUZiYZazEXFiQAz4rei4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd2u03+DDfZMNrLYOGM9q8XB+/UW
	bVcOsltcXniJ1aJ3wVU2i7NNb4DcXXPYLGac38dksWhZK7PFqeuf2Ry4PK6caGL16NuyitHj
	+I3tTB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAB2kpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xY1NrBVDBX
	reLdjsnMDYzd8l2MnBwSAiYSV06dYYGwxSQu3FvPBmILCSxilFjT4N3FyAVk/2aUuDNrBViC
	TUBN4suXw+wgtohAtMS8tZ3sIEXMAquZJJY9+sEE0a0p8b93P9hUTgEtidcTHoHFhQXcJLqv
	X2EFsVkEVCW6jr5k7GLk4OAVsJV4/NIZJMwrICjxY/I9sFZmoNb1O48zQdjyEpvXvGUGKZcQ
	UJd49FcX4gQjiRtvN7NDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIThbPpHcwrmqwOMQowMGoxMP7YcGfYCHWxLLiytxDjBIczEoivGUH
	/gYL8aYkVlalFuXHF5XmpBYfYjQF+nMis5Rocj4wkeWVxBsam5gZWRqZWRiZmJsrifMebLUO
	FBJITyxJzU5NLUgtgulj4uCUamBctSPs0cU5ginpYdJnvmsVH753avvuy4kPBZ9OiNvP2Pd/
	jWdDz9RtPIz3yid4HL/My7Aw/OMh81eehov7Q9vsfXJu7ZGYcvlDXwsPa9+sw9VXN8xa23By
	y9OSQuual9O/Tpg8p0Z5iX9vyO52HbW/jCZBvo4Gpxf0xewLDzhUV1IRHKz/3KRTiaU4I9FQ
	i7moOBEArU307SwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 4:53 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
> (PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
> looking at the following commits:
> 
>   7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
>   phy driver for exynos5250")
> 
>   f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
>   exynos5420")
> 
> Thus remove unused usb_phy_generic support from dwc3 Exynos glue
> layer.
> 
> [ The code that is being removed is harmful in the context of
>   multi_v7_defconfig and enabling "EHCI support for Samsung
>   S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
>   Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
>   support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
>   "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
>   attaches itself to usb_phy_generic platform devices created by
>   dwc3 Exynos glue layer and later causes Exynos EHCI driver to
>   fail probe and Exynos OHCI driver to hang on probe (as observed
>   on Exynos5250 Arndale board). ]

I also agree with this patch, because dwc3 IPs of all Exynos SoCs
do not use "NOP USB Transceiver Driver". So, "usb_phy_generic" can be
removed from Exynos dwc3 driver.

Is there any reason to support 'usb_phy_generic' for Exynos dwc3?
If so, please let me know. Thank you.

Best regards,
Jingoo Han

> 
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   68 -----------------------------------------
>  1 file changed, 1 insertion(+), 67 deletions(-)
> 
> Index: b/drivers/usb/dwc3/dwc3-exynos.c
> ===================================================================
> --- a/drivers/usb/dwc3/dwc3-exynos.c	2014-08-25 14:57:04.991781925 +0200
> +++ b/drivers/usb/dwc3/dwc3-exynos.c	2014-08-27 09:16:38.312617727 +0200
> @@ -23,15 +23,12 @@
>  #include <linux/platform_data/dwc3-exynos.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/clk.h>
> -#include <linux/usb/otg.h>
> -#include <linux/usb/usb_phy_generic.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/regulator/consumer.h>
> 
>  struct dwc3_exynos {
> -	struct platform_device	*usb2_phy;
> -	struct platform_device	*usb3_phy;
>  	struct device		*dev;
> 
>  	struct clk		*clk;
> @@ -39,61 +36,6 @@ struct dwc3_exynos {
>  	struct regulator	*vdd10;
>  };
> 
> -static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
> -{
> -	struct usb_phy_generic_platform_data pdata;
> -	struct platform_device	*pdev;
> -	int			ret;
> -
> -	memset(&pdata, 0x00, sizeof(pdata));
> -
> -	pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
> -	if (!pdev)
> -		return -ENOMEM;
> -
> -	exynos->usb2_phy = pdev;
> -	pdata.type = USB_PHY_TYPE_USB2;
> -	pdata.gpio_reset = -1;
> -
> -	ret = platform_device_add_data(exynos->usb2_phy, &pdata, sizeof(pdata));
> -	if (ret)
> -		goto err1;
> -
> -	pdev = platform_device_alloc("usb_phy_generic", PLATFORM_DEVID_AUTO);
> -	if (!pdev) {
> -		ret = -ENOMEM;
> -		goto err1;
> -	}
> -
> -	exynos->usb3_phy = pdev;
> -	pdata.type = USB_PHY_TYPE_USB3;
> -
> -	ret = platform_device_add_data(exynos->usb3_phy, &pdata, sizeof(pdata));
> -	if (ret)
> -		goto err2;
> -
> -	ret = platform_device_add(exynos->usb2_phy);
> -	if (ret)
> -		goto err2;
> -
> -	ret = platform_device_add(exynos->usb3_phy);
> -	if (ret)
> -		goto err3;
> -
> -	return 0;
> -
> -err3:
> -	platform_device_del(exynos->usb2_phy);
> -
> -err2:
> -	platform_device_put(exynos->usb3_phy);
> -
> -err1:
> -	platform_device_put(exynos->usb2_phy);
> -
> -	return ret;
> -}
> -
>  static int dwc3_exynos_remove_child(struct device *dev, void *unused)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> @@ -127,12 +69,6 @@ static int dwc3_exynos_probe(struct plat
> 
>  	platform_set_drvdata(pdev, exynos);
> 
> -	ret = dwc3_exynos_register_phys(exynos);
> -	if (ret) {
> -		dev_err(dev, "couldn't register PHYs\n");
> -		return ret;
> -	}
> -
>  	clk = devm_clk_get(dev, "usbdrd30");
>  	if (IS_ERR(clk)) {
>  		dev_err(dev, "couldn't get clock\n");
> @@ -194,8 +130,6 @@ static int dwc3_exynos_remove(struct pla
>  	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
> 
>  	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
> -	platform_device_unregister(exynos->usb2_phy);
> -	platform_device_unregister(exynos->usb3_phy);
> 
>  	clk_disable_unprepare(exynos->clk);
> 
> 

