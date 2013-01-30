Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3A3F4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:56:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23537 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3A3F4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:56:40 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-2c-5108b617bac8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
References: <1358168377-22919-2-git-send-email-gautam.vivek@samsung.com>
 <1359368690-30178-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1359368690-30178-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v4 1/2] usb: phy: samsung: Common out the generic stuff
Date: Tue, 29 Jan 2013 21:56:31 -0800
Message-id: <077e01cdfeae$8fbc2850$af3478f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMFL69UuKvZDijit+etR9C4t2XM2wHO+5n1leR6cPA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zY13xbRyBBmsbWS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgymhb0c5YsEq/4l2rXwPjIrUuRg4OCQETic9X
	tLsYOYFMMYkL99azdTFycQgJLGOUaNz0iQUiYSIxa+MJNhBbSGA6o8T8F6YQRX8ZJdZMOMsE
	kmAT0JA4/P4ZO4gtIuAhcffYcnaQImaBTUwS3yd3sEJ0tzNKzPzDDWJzCnhKnJ70FqxZWMBb
	4uq62UwgF7EIqEr8mW4DEuYVsJRYOPMXO4QtKPFj8j2wg5gFtCTW7zzOBGHLS2xe85YZ4lAF
	iR1nXzNC3GAlcW7ec0aIGnGJSQ8egt0jIbCOXWLm1fdgQ1kEBCS+TT7EAgkJWYlNB6DmSEoc
	XHGDZQKjxCwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESa1I7
	GFc2WBxiFOBgVOLhXfCCPVCINbGsuDL3EKMEB7OSCK+CGkegEG9KYmVValF+fFFpTmrxIcZk
	oGMnMkuJJucD00BeSbyhsbGJmYmpibmlqbkpacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCU
	amCcdLB83a3z+1JyhV7MnvFq4y/J592prbKxjRc/a01n/jHphsf1ryeWHv6i+XFGj6RFr41z
	z09R2+qn06adnloV+vNxrvzfpRs0j5u+7gxZtLJzntuDZ9rV+l2Zj5gjIxoVg/lzrD5ND9in
	HeZqycfHGaagzpUnb1zJaNcu6ZR/9apf/HxLETslluKMREMt5qLiRADWmE5U+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQV3xbRyBBotELC7vmsNmMeP8PiaL
	RctamR2YPT5vkgtgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzGhb0c5Y
	sEq/4l2rXwPjIrUuRk4OCQETiVkbT7BB2GISF+6tB7OFBKYzSsx/YdrFyAVk/2WUWDPhLBNI
	gk1AQ+Lw+2fsILaIgIfE3WPL2UGKmAU2MUl8n9zBCtHdzigx8w83iM0p4ClxetJbsGZhAW+J
	q+tmA9kcHCwCqhJ/ptuAhHkFLCUWzvzFDmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiEMV
	JHacfc0IcYOVxLl5zxkhasQlJj14yD6BUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIER/IzqR2MKxssDjEKcDAq8fAueMEeKMSaWFZcmXuIUYKDWUmEV0GN
	I1CINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84FJJq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZT
	TwKEBNITS1KzU1MLUotgtjBxcEo1MCYJZnh/f6x4v3mj1fogTbX+a2ZFIaxOeXLVi3ouT/SU
	3XjV5LxDU+72hBDu+lxp/Yux95vmnY+yvB6Qs2bWEc+gRYKb9Hwdt7MtnxMqO+XISV5W/WTP
	E1Hpi64eWzb3867fr2/p6h4peFfY38Qk++BJ3VzRxfuk5EXbJ01/29L5xTa5dH3INSWW4oxE
	Qy3mouJEADrViRwoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Moving register and structure definitions to header file,
> and keeping the generic functions to be used across
> multiple PHYs in common file "samsung-usbphy.c".
> Also renaming the usb 2.0 phy driver to "samsung-usb2.c"

Just in my opinion, Samsung-usb2phy is more clear?...In addition, I looked
at using SAMSUNG_USB2PHY as a statement.

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
> Changes from v3:
>  - Using separate config SAMSUNG_USB2PHY dependent on
>    SAMSUNG_USBPHY for samsung-usb2 type PHY controller.
> 
>  drivers/usb/phy/Kconfig          |   14 +-
>  drivers/usb/phy/Makefile         |    1 +
>  drivers/usb/phy/samsung-usb2.c   |  511 +++++++++++++++++++++++++++
>  drivers/usb/phy/samsung-usbphy.c |  714
+-------------------------------------
>  drivers/usb/phy/samsung-usbphy.h |  247 +++++++++++++
>  5 files changed, 778 insertions(+), 709 deletions(-)
>  create mode 100644 drivers/usb/phy/samsung-usb2.c
>  create mode 100644 drivers/usb/phy/samsung-usbphy.h
> 
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index fae4d08..cc0d230 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -48,8 +48,18 @@ config USB_RCAR_PHY
> 
>  config SAMSUNG_USBPHY
>  	bool "Samsung USB PHY controller Driver"
> -	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> USB_OHCI_EXYNOS

So this can be selected without any dependency?

>  	select USB_OTG_UTILS
>  	help
> -	  Enable this to support Samsung USB phy controller for samsung
> +	  Enable this to support Samsung USB phy controllers for Samsung
>  	  SoCs.

Hmm, according to above comments, this should be enabled under Samsung SoC?

> +
> +if SAMSUNG_USBPHY

Why is this needed here?

> +
> +config SAMSUNG_USB2PHY
> +	bool "Samsung USB 2.0 PHY controller Driver"
> +	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> USB_OHCI_EXYNOS
> +	help
> +	  Enable this to support Samsung USB 2.0 (High Speed) phy controller
> +	  for Samsung SoCs.
> +
> +endif
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index ec304f6..7ba9862 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_MV_U3D_PHY)		+=
> mv_u3d_phy.o
>  obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
>  obj-$(CONFIG_USB_RCAR_PHY)		+= rcar-phy.o
>  obj-$(CONFIG_SAMSUNG_USBPHY)		+= samsung-usbphy.o
> +obj-$(CONFIG_SAMSUNG_USB2PHY)		+= samsung-usb2.o
> diff --git a/drivers/usb/phy/samsung-usb2.c b/drivers/usb/phy/samsung-
> usb2.c
> new file mode 100644
> index 0000000..9a9d1d0
> --- /dev/null
> +++ b/drivers/usb/phy/samsung-usb2.c
> @@ -0,0 +1,511 @@
> +/* linux/drivers/usb/phy/samsung-usb2.c
> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *              http://www.samsung.com
> + *
> + * Author: Praveen Paneri <p.paneri@samsung.com>
> + *
> + * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller,
EHCI-S5P
> and
> + * OHCI-EXYNOS controllers.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/usb/otg.h>
> +#include <linux/usb/samsung_usb_phy.h>
> +#include <linux/platform_data/samsung-usbphy.h>
> +
> +#include "samsung-usbphy.h"
> +
> +int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)

For naming, if you want to support usb 2.0 phy here, the name of fuction
should be changed to more clear name such as usb2phy or whatever.

As I'm understanding, the samsung-usbphy.c can be used for common stuff and
this is for only usb 2.0 phy.

[...]

> +#ifdef CONFIG_OF
> +static const struct of_device_id samsung_usbphy_dt_match[] = {
> +	{
> +		.compatible = "samsung,s3c64xx-usbphy",
> +		.data = &usbphy_s3c64xx,
> +	}, {
> +		.compatible = "samsung,exynos4210-usbphy",
> +		.data = &usbphy_exynos4,
> +	}, {
> +		.compatible = "samsung,exynos5250-usbphy",
> +		.data = &usbphy_exynos5
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
> +#endif
> +
> +static struct platform_device_id samsung_usbphy_driver_ids[] = {
> +	{
> +		.name		= "s3c64xx-usbphy",
> +		.driver_data	= (unsigned long)&usbphy_s3c64xx,
> +	}, {
> +		.name		= "exynos4210-usbphy",
> +		.driver_data	= (unsigned long)&usbphy_exynos4,
> +	}, {
> +		.name		= "exynos5250-usbphy",
> +		.driver_data	= (unsigned long)&usbphy_exynos5,
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
> +
> +static struct platform_driver samsung_usbphy_driver = {
> +	.probe		= samsung_usbphy_probe,
> +	.remove		= samsung_usbphy_remove,
> +	.id_table	= samsung_usbphy_driver_ids,
> +	.driver		= {
> +		.name	= "samsung-usbphy",
> +		.owner	= THIS_MODULE,
> +		.of_match_table =
> of_match_ptr(samsung_usbphy_dt_match),
> +	},
> +};
> +
> +module_platform_driver(samsung_usbphy_driver);
> +
> +MODULE_DESCRIPTION("Samsung USB phy controller");

USB 2.0 Phy?

> +MODULE_AUTHOR("Praveen Paneri <p.paneri@samsung.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:samsung-usbphy");

Is this for samsung-usbphy or samsung-usb2/samsung-usb2phy?

[...]

I know why you create separated phy file samsung-usbphy.c and samsung-usb2.c
here, but I think for that, would be better if you could consider the name
and so on.

Thanks.

- Kukjin

