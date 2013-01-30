Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3A3GCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:02:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46631 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A3GCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:02:01 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-fd-5108b75831d9
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
References: <1358168377-22919-3-git-send-email-gautam.vivek@samsung.com>
 <1359368782-30224-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1359368782-30224-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v4 2/2] usb: phy: samsung: Add PHY support for USB 3.0
 controller
Date: Tue, 29 Jan 2013 22:01:52 -0800
Message-id: <077f01cdfeaf$4f7b8780$ee729680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHaYwXf/4EqYMa2BA0FVEJKxMCRjAOPYObSmCwcNAA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zA92I7RyBBndPiltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlfFv4Q3WgpkSFevnajUwzhHuYuTkkBAwkfi6
	4S0rhC0mceHeerYuRi4OIYFljBJzPyxkgyu62MwIYgsJTGeUePW+GqLoL6PE0x3TmUESbAIa
	EoffP2MHsUUEPCTuHlvODlLELLCJSeL75A5WiI52Ronjr46AjeUU8JQ40n0drFtYIFzizsVT
	QCs4OFgEVCVerowACfMKWEoc2XqEGcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMEJcqSOw4
	+5oR4ggriYmHWtkhasQlJj14CHaQhMAmdonjH/eC/cwiICDxbfIhFpC9EgKyEpsOQM2RlDi4
	4gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTepHcw
	rmqwOMQowMGoxMO74AV7oBBrYllxZe4hRgkOZiURXgU1jkAh3pTEyqrUovz4otKc1OJDjMlA
	x05klhJNzgemgrySeENjYxMzE1MTc0tTc1PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnV
	wLh+9u/uLbet4xd/qWEuVHxXJXnz5wvJPZ6b7P/nsRpUbPd9vnnmzFcacos4Frw7OmOfYXu/
	YfSM6YnbXb59etV+3ulTtg2PcpOsS3YHx5/52/88tS9Ub1M8/DvnvUVOcrdny5f8tqNJ9xed
	bC8r0ev4kpNoe2Jvg+jPzc7Nx5R7LndWL8k10VJiKc5INNRiLipOBADhaSmP+wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd2I7RyBBo8mCFlc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jxb+EN
	1oKZEhXr52o1MM4R7mLk5JAQMJH4erGZEcIWk7hwbz0biC0kMJ1R4tX76i5GLiD7L6PE0x3T
	mUESbAIaEoffP2MHsUUEPCTuHlvODlLELLCJSeL75A5WiI52Ronjr46AjeIU8JQ40n0drFtY
	IFzizsVTQOs4OFgEVCVerowACfMKWEoc2XqEGcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfM
	EJcqSOw4+5oR4ggriYmHWtkhasQlJj14yD6BUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIER/Mz6R2MqxosDjEKcDAq8fAueMEeKMSaWFZcmXuIUYKDWUmE
	V0GNI1CINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84GJJq8k3tDYxMzI0sjMwsjE3Jw0YSVx
	XsZTTwKEBNITS1KzU1MLUotgtjBxcEo1MDpettf0n9u802hCy+EdFhwHFRbluP0y1Z3O8unh
	+1tqf5nnSJhovXh//1Mo4/z+sDlSt2bOD45+u1s6Kdrr8Ow+Dx9bTjdfpYxYnpAVOxlcuRa/
	YN766MFipx27k1JzQpQmNy/svLdb5ri8/KGvgjGLGisk0tUYtPrD9ARymYOnK6zUK9D9qMRS
	nJFoqMVcVJwIANNAP6AqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Adding PHY driver support for USB 3.0 controller for Samsung's
> SoCs.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
> Changes from v3:
>  - Making SAMSUNG_USB3PHY dependent on SAMSUNG_USBPHY.
>  - Adding USB_DWC3 to dependencies of SAMSUNG_USB2PHY since
>    dwc3 controller also looks for USB2 type PHY.
> 
>  drivers/usb/phy/Kconfig          |   11 +-
>  drivers/usb/phy/Makefile         |    1 +
>  drivers/usb/phy/samsung-usb3.c   |  349
> ++++++++++++++++++++++++++++++++++++++
>  drivers/usb/phy/samsung-usbphy.h |   81 +++++++++
>  4 files changed, 441 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/usb/phy/samsung-usb3.c
> 
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index cc0d230..9325a95 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -52,14 +52,23 @@ config SAMSUNG_USBPHY
>  	help
>  	  Enable this to support Samsung USB phy controllers for Samsung
>  	  SoCs.
> +	  Further enable USB 2.0 type PHY or USB 3.0 type PHY as required
> +	  for USB controllers in use.
> 
>  if SAMSUNG_USBPHY
> 
>  config SAMSUNG_USB2PHY
>  	bool "Samsung USB 2.0 PHY controller Driver"
> -	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> USB_OHCI_EXYNOS
> +	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> USB_OHCI_EXYNOS || USB_DWC3
>  	help
>  	  Enable this to support Samsung USB 2.0 (High Speed) phy controller
>  	  for Samsung SoCs.
> 
> +config SAMSUNG_USB3PHY
> +	bool "Samsung USB 3.0 PHY controller Driver"
> +	depends on USB_DWC3
> +	help
> +	  Enable this to support Samsung USB 3.0 (Super Speed) phy
> controller
> +	  for samsung SoCs.
> +
>  endif

It mean, when USB_DWC3 is selected, we can select only one USB2PHY or
USB3PHY?

[...]

> +#ifdef CONFIG_OF
> +static const struct of_device_id samsung_usbphy_dt_match[] = {
> +	{
> +		.compatible = "samsung,exynos5250-usb3-phy",
> +		.data = &usb3_phy_exynos5
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
> +#endif
> +
> +static struct platform_device_id samsung_usbphy_driver_ids[] = {
> +	{
> +		.name		= "exynos5250-usb3-phy",

According to the name of file, exynos5250-usb3phy? Just it is imho...

> +		.driver_data	= (unsigned long)&usb3_phy_exynos5,
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
> +
> +static struct platform_driver samsung_usb3_phy_driver = {
> +	.probe		= samsung_usb3_phy_probe,
> +	.remove		= samsung_usb3_phy_remove,
> +	.id_table	= samsung_usbphy_driver_ids,
> +	.driver		= {
> +		.name	= "samsung-usb3-phy",
> +		.owner	= THIS_MODULE,
> +		.of_match_table =
> of_match_ptr(samsung_usbphy_dt_match),
> +	},
> +};
> +
> +module_platform_driver(samsung_usb3_phy_driver);
> +
> +MODULE_DESCRIPTION("Samsung USB 3.0 phy controller");
> +MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:samsung-usb3-phy");

I want you to use same naming rule.

Thanks.

- Kukjin

