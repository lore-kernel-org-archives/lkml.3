Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaHNOiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:38:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43281 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaHNOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:37:59 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-08-53ecc9c53d5f
Message-id: <34FCC3B2EE8F481198CEF3037F168FB3@sisodomain.com>
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, b.zolnierkie@samsung.com
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
 <1408026327-31437-4-git-send-email-b.zolnierkie@samsung.com>
In-reply-to: <1408026327-31437-4-git-send-email-b.zolnierkie@samsung.com>
Subject: Re: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver
Date: Thu, 14 Aug 2014 20:07:40 +0530
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1; reply-type=original
Content-transfer-encoding: 7bit
X-Priority: 3
X-MSMail-priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MIMEOLE: Produced By Microsoft MimeOLE V14.0.8117.416
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsWyRsSkWvfoyTfBBktOi1hsnLGe1eLg/XqL
	Tdevs1r8eH2BzaJ3wVU2iwtPe9gszja9Ybe4vGsOm8WM8/uYLBYta2V24PK4c20Pm0ffllWM
	HsdvbGfy+LxJLoAlissmJTUnsyy1SN8ugStjf+dJ9oJZUxgr1r/fx9rA+Leii5GTQ0LAROLu
	1ofMELaYxIV769m6GLk4hASWMkpsP/OMGabo4Mv3jBCJ6YwS53v+MUM43xklDu9/yAhSxStg
	K3Fh5l4mEJtNQFei6e0usLiIQIXExsNXwLqZBbYxSZxf+QtqVDtQ95s+sA5OAU+J5zv+sIDY
	wkD29kV3weIsAqoS/w61Q20QlPgx+R5YDbNAgMTKibMZIWx5ic1r3kLdyisxo/0pC4QtKbG6
	5xY7xHwhiY6rnawQcWOJKf+WQtWbS1zcvpkJ5CAJgVYOicffp0EtFpD4NvkQ0CAOoISsxKYD
	zDAzD664wTKBUWoWkpNmITlpFpKTFjAyr2IUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIjPjT
	/5717WC8ecD6EGMy0MqJzFKiyfnAhJFXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhnXPORs1/Zb/kygDtc+UxK9Z0t92XE10e+4n5zJ0f+7YWN
	ovfdS5jfPvifdlxV7s0OC5fs0gVmhpeDjrFk9BdqWlYqM80x5F62JecMzxfLVWn7Htl4VF5e
	XSfd2sUh+T5xSzvbaZ13r0w9trveKL8Xof6msvfpj+Ul/l/3cE1ZuMD6eFVUd5USS3FGoqEW
	c1FxIgD9IWrADgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd2jJ98EGxxdwmmxccZ6VouD9+st
	Nl2/zmrx4/UFNoveBVfZLC487WGzONv0ht3i8q45bBYzzu9jsli0rJXZgcvjzrU9bB59W1Yx
	ehy/sZ3J4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGfs7T7IX
	zJrCWLH+/T7WBsa/FV2MnBwSAiYSB1++Z4SwxSQu3FvP1sXIxSEkMJ1R4nzPP2YI5zujxOH9
	D8GqeAVsJS7M3MsEYrMJ6Eo0vd0FFhcRqJDYePgKI0gDs8A2JonzK38xQnS3A3W/6QPr4BTw
	lHi+4w8LiC0MZG9fdBcsziKgKvHvUDvUBkGJH5PvgdUwCwRIrJw4mxHClpfYvOYtM8StvBIz
	2p+yQNiSEqt7brFDzBeS6LjayQoRN5aY8m8pVL25xMXtm5kmMIrMQrJiFpIVs5CsWMDIvIpR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJ08k9rBuLLB4hCjAAejEg9vw/Y3wUKsiWXFlbmH
	GCU4mJVEeKfvBgrxpiRWVqUW5ccXleakFh9iNAX6dCKzlGhyPjDV5ZXEGxqbmJsam1qaWJiY
	WSqJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYMxhtL/Mv539x7Tvvz3uTH2gpKdRkTmvcE+n
	GfsiRYuw1cmtUs2x9j4XlR313646tN/e6FyBuubRGO1pb6NZf7Nkbny4JOBTd9HxZdvWyDb8
	dC7W85ZdaTF//adg9dBUftsz/3rn99t8PCOdcml+1ux7FkafYk8/NMneulH1Lm/RojVC/zda
	MymxFGckGmoxFxUnAgD+rIw+PQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej Zolnierkiewicz,


On Thursday, August 14, 2014 7:55 PM, Bartlomiej Zolnierkiewicz 
<b.zolnierkie@samsung.com> wrote

Subject: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver

I would say it co-incidence that both of us sent the patch-series for 
similar cleanup at the same time. ;)

There's one thing that I would want to comment here, since we don't have any 
new usb-phy driver for S3C64XX,
so we can't simply remove this entire driver.
I have posted my patch-series [1], which does cleanup while keeping the 
support for S3C64XX.

Please let me know what you think of that series.

[1] [PATCH 0/7] usb-phy: samsung: Cleanup the unused drivers
      https://lkml.org/lkml/2014/8/14/235

> drivers/usb/phy/phy-samsung-usb2 driver got replaced by
> drivers/phy/phy-samsung-usb2 one and is no longer used.
>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Vivek Gautam <gautam.vivek@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> drivers/usb/phy/Kconfig            |   8 -
> drivers/usb/phy/Makefile           |   1 -
> drivers/usb/phy/phy-samsung-usb2.c | 
> 541 -------------------------------------
> 3 files changed, 550 deletions(-)
> delete mode 100644 drivers/usb/phy/phy-samsung-usb2.c
>
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index e253fa0..452e252 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -78,14 +78,6 @@ config SAMSUNG_USBPHY
>    This driver provides common interface to interact, for Samsung USB 2.0 
> PHY
>    driver and later for Samsung USB 3.0 PHY driver.
>
> -config SAMSUNG_USB2PHY
> - tristate "Samsung USB 2.0 PHY controller Driver"
> - select SAMSUNG_USBPHY
> - select USB_PHY
> - help
> -   Enable this to support Samsung USB 2.0 (High Speed) PHY controller
> -   driver for Samsung SoCs.
> -
> config SAMSUNG_USB3PHY
>  tristate "Samsung USB 3.0 PHY controller Driver"
>  select SAMSUNG_USBPHY
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 24a9133..c651005 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -15,7 +15,6 @@ obj-$(CONFIG_AM335X_CONTROL_USB) += phy-am335x-control.o
> obj-$(CONFIG_AM335X_PHY_USB) += phy-am335x.o
> obj-$(CONFIG_OMAP_OTG) += phy-omap-otg.o
> obj-$(CONFIG_SAMSUNG_USBPHY) += phy-samsung-usb.o
> -obj-$(CONFIG_SAMSUNG_USB2PHY) += phy-samsung-usb2.o
> obj-$(CONFIG_SAMSUNG_USB3PHY) += phy-samsung-usb3.o
> obj-$(CONFIG_TWL6030_USB) += phy-twl6030-usb.o
> obj-$(CONFIG_USB_EHCI_TEGRA) += phy-tegra-usb.o
> diff --git a/drivers/usb/phy/phy-samsung-usb2.c 
> b/drivers/usb/phy/phy-samsung-usb2.c
> deleted file mode 100644
> index b3ba866..0000000
> --- a/drivers/usb/phy/phy-samsung-usb2.c
> +++ /dev/null
> @@ -1,541 +0,0 @@
> -/* linux/drivers/usb/phy/phy-samsung-usb2.c
> - *
> - * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> - *              http://www.samsung.com
> - *
> - * Author: Praveen Paneri <p.paneri@samsung.com>
> - *
> - * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller, 
> EHCI-S5P and
> - * OHCI-EXYNOS controllers.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/clk.h>
> -#include <linux/delay.h>
> -#include <linux/device.h>
> -#include <linux/err.h>
> -#include <linux/io.h>
> -#include <linux/of.h>
> -#include <linux/usb/otg.h>
> -#include <linux/usb/samsung_usb_phy.h>
> -#include <linux/platform_data/samsung-usbphy.h>
> -
> -#include "phy-samsung-usb.h"
> -
> -static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus 
> *host)
> -{
> - if (!otg)
> - return -ENODEV;
> -
> - if (!otg->host)
> - otg->host = host;
> -
> - return 0;
> -}
> -
> -static bool exynos5_phyhost_is_on(void __iomem *regs)
> -{
> - u32 reg;
> -
> - reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
> -
> - return !(reg & HOST_CTRL0_SIDDQ);
> -}
> -
> -static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
> -{
> - void __iomem *regs = sphy->regs;
> - u32 phyclk = sphy->ref_clk_freq;
> - u32 phyhost;
> - u32 phyotg;
> - u32 phyhsic;
> - u32 ehcictrl;
> - u32 ohcictrl;
> -
> - /*
> - * phy_usage helps in keeping usage count for phy
> - * so that the first consumer enabling the phy is also
> - * the last consumer to disable it.
> - */
> -
> - atomic_inc(&sphy->phy_usage);
> -
> - if (exynos5_phyhost_is_on(regs)) {
> - dev_info(sphy->dev, "Already power on PHY\n");
> - return;
> - }
> -
> - /* Host configuration */
> - phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
> -
> - /* phy reference clock configuration */
> - phyhost &= ~HOST_CTRL0_FSEL_MASK;
> - phyhost |= HOST_CTRL0_FSEL(phyclk);
> -
> - /* host phy reset */
> - phyhost &= ~(HOST_CTRL0_PHYSWRST |
> - HOST_CTRL0_PHYSWRSTALL |
> - HOST_CTRL0_SIDDQ |
> - /* Enable normal mode of operation */
> - HOST_CTRL0_FORCESUSPEND |
> - HOST_CTRL0_FORCESLEEP);
> -
> - /* Link reset */
> - phyhost |= (HOST_CTRL0_LINKSWRST |
> - HOST_CTRL0_UTMISWRST |
> - /* COMMON Block configuration during suspend */
> - HOST_CTRL0_COMMONON_N);
> - writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
> - udelay(10);
> - phyhost &= ~(HOST_CTRL0_LINKSWRST |
> - HOST_CTRL0_UTMISWRST);
> - writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
> -
> - /* OTG configuration */
> - phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
> -
> - /* phy reference clock configuration */
> - phyotg &= ~OTG_SYS_FSEL_MASK;
> - phyotg |= OTG_SYS_FSEL(phyclk);
> -
> - /* Enable normal mode of operation */
> - phyotg &= ~(OTG_SYS_FORCESUSPEND |
> - OTG_SYS_SIDDQ_UOTG |
> - OTG_SYS_FORCESLEEP |
> - OTG_SYS_REFCLKSEL_MASK |
> - /* COMMON Block configuration during suspend */
> - OTG_SYS_COMMON_ON);
> -
> - /* OTG phy & link reset */
> - phyotg |= (OTG_SYS_PHY0_SWRST |
> - OTG_SYS_LINKSWRST_UOTG |
> - OTG_SYS_PHYLINK_SWRESET |
> - OTG_SYS_OTGDISABLE |
> - /* Set phy refclk */
> - OTG_SYS_REFCLKSEL_CLKCORE);
> -
> - writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> - udelay(10);
> - phyotg &= ~(OTG_SYS_PHY0_SWRST |
> - OTG_SYS_LINKSWRST_UOTG |
> - OTG_SYS_PHYLINK_SWRESET);
> - writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> -
> - /* HSIC phy configuration */
> - phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
> - HSIC_CTRL_REFCLKSEL |
> - HSIC_CTRL_PHYSWRST);
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
> - udelay(10);
> - phyhsic &= ~HSIC_CTRL_PHYSWRST;
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
> -
> - udelay(80);
> -
> - /* enable EHCI DMA burst */
> - ehcictrl = readl(regs + EXYNOS5_PHY_HOST_EHCICTRL);
> - ehcictrl |= (HOST_EHCICTRL_ENAINCRXALIGN |
> - HOST_EHCICTRL_ENAINCR4 |
> - HOST_EHCICTRL_ENAINCR8 |
> - HOST_EHCICTRL_ENAINCR16);
> - writel(ehcictrl, regs + EXYNOS5_PHY_HOST_EHCICTRL);
> -
> - /* set ohci_suspend_on_n */
> - ohcictrl = readl(regs + EXYNOS5_PHY_HOST_OHCICTRL);
> - ohcictrl |= HOST_OHCICTRL_SUSPLGCY;
> - writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
> -}
> -
> -static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
> -{
> - void __iomem *regs = sphy->regs;
> - u32 phypwr;
> - u32 phyclk;
> - u32 rstcon;
> -
> - /* set clock frequency for PLL */
> - phyclk = sphy->ref_clk_freq;
> - phypwr = readl(regs + SAMSUNG_PHYPWR);
> - rstcon = readl(regs + SAMSUNG_RSTCON);
> -
> - switch (sphy->drv_data->cpu_type) {
> - case TYPE_S3C64XX:
> - phyclk &= ~PHYCLK_COMMON_ON_N;
> - phypwr &= ~PHYPWR_NORMAL_MASK;
> - rstcon |= RSTCON_SWRST;
> - break;
> - case TYPE_EXYNOS4X12:
> - phypwr &= ~(PHYPWR_NORMAL_MASK_HSIC0 |
> - PHYPWR_NORMAL_MASK_HSIC1 |
> - PHYPWR_NORMAL_MASK_PHY1);
> - rstcon |= RSTCON_HOSTPHY_SWRST;
> - case TYPE_EXYNOS4210:
> - phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
> - rstcon |= RSTCON_SWRST;
> - default:
> - break;
> - }
> -
> - writel(phyclk, regs + SAMSUNG_PHYCLK);
> - /* Configure PHY0 for normal operation*/
> - writel(phypwr, regs + SAMSUNG_PHYPWR);
> - /* reset all ports of PHY and Link */
> - writel(rstcon, regs + SAMSUNG_RSTCON);
> - udelay(10);
> - if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12)
> - rstcon &= ~RSTCON_HOSTPHY_SWRST;
> - rstcon &= ~RSTCON_SWRST;
> - writel(rstcon, regs + SAMSUNG_RSTCON);
> -}
> -
> -static void samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)
> -{
> - void __iomem *regs = sphy->regs;
> - u32 phyhost;
> - u32 phyotg;
> - u32 phyhsic;
> -
> - if (atomic_dec_return(&sphy->phy_usage) > 0) {
> - dev_info(sphy->dev, "still being used\n");
> - return;
> - }
> -
> - phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
> - HSIC_CTRL_REFCLKSEL |
> - HSIC_CTRL_SIDDQ |
> - HSIC_CTRL_FORCESLEEP |
> - HSIC_CTRL_FORCESUSPEND);
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
> - writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
> -
> - phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
> - phyhost |= (HOST_CTRL0_SIDDQ |
> - HOST_CTRL0_FORCESUSPEND |
> - HOST_CTRL0_FORCESLEEP |
> - HOST_CTRL0_PHYSWRST |
> - HOST_CTRL0_PHYSWRSTALL);
> - writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
> -
> - phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
> - phyotg |= (OTG_SYS_FORCESUSPEND |
> - OTG_SYS_SIDDQ_UOTG |
> - OTG_SYS_FORCESLEEP);
> - writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> -}
> -
> -static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
> -{
> - void __iomem *regs = sphy->regs;
> - u32 phypwr;
> -
> - phypwr = readl(regs + SAMSUNG_PHYPWR);
> -
> - switch (sphy->drv_data->cpu_type) {
> - case TYPE_S3C64XX:
> - phypwr |= PHYPWR_NORMAL_MASK;
> - break;
> - case TYPE_EXYNOS4X12:
> - phypwr |= (PHYPWR_NORMAL_MASK_HSIC0 |
> - PHYPWR_NORMAL_MASK_HSIC1 |
> - PHYPWR_NORMAL_MASK_PHY1);
> - case TYPE_EXYNOS4210:
> - phypwr |= PHYPWR_NORMAL_MASK_PHY0;
> - default:
> - break;
> - }
> -
> - /* Disable analog and otg block power */
> - writel(phypwr, regs + SAMSUNG_PHYPWR);
> -}
> -
> -/*
> - * The function passed to the usb driver for phy initialization
> - */
> -static int samsung_usb2phy_init(struct usb_phy *phy)
> -{
> - struct samsung_usbphy *sphy;
> - struct usb_bus *host = NULL;
> - unsigned long flags;
> - int ret = 0;
> -
> - sphy = phy_to_sphy(phy);
> -
> - host = phy->otg->host;
> -
> - /* Enable the phy clock */
> - ret = clk_prepare_enable(sphy->clk);
> - if (ret) {
> - dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
> - return ret;
> - }
> -
> - spin_lock_irqsave(&sphy->lock, flags);
> -
> - if (host) {
> - /* setting default phy-type for USB 2.0 */
> - if (!strstr(dev_name(host->controller), "ehci") ||
> - !strstr(dev_name(host->controller), "ohci"))
> - samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
> - } else {
> - samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
> - }
> -
> - /* Disable phy isolation */
> - if (sphy->plat && sphy->plat->pmu_isolation)
> - sphy->plat->pmu_isolation(false);
> - else if (sphy->drv_data->set_isolation)
> - sphy->drv_data->set_isolation(sphy, false);
> -
> - /* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
> - samsung_usbphy_cfg_sel(sphy);
> -
> - /* Initialize usb phy registers */
> - sphy->drv_data->phy_enable(sphy);
> -
> - spin_unlock_irqrestore(&sphy->lock, flags);
> -
> - /* Disable the phy clock */
> - clk_disable_unprepare(sphy->clk);
> -
> - return ret;
> -}
> -
> -/*
> - * The function passed to the usb driver for phy shutdown
> - */
> -static void samsung_usb2phy_shutdown(struct usb_phy *phy)
> -{
> - struct samsung_usbphy *sphy;
> - struct usb_bus *host = NULL;
> - unsigned long flags;
> -
> - sphy = phy_to_sphy(phy);
> -
> - host = phy->otg->host;
> -
> - if (clk_prepare_enable(sphy->clk)) {
> - dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
> - return;
> - }
> -
> - spin_lock_irqsave(&sphy->lock, flags);
> -
> - if (host) {
> - /* setting default phy-type for USB 2.0 */
> - if (!strstr(dev_name(host->controller), "ehci") ||
> - !strstr(dev_name(host->controller), "ohci"))
> - samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
> - } else {
> - samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
> - }
> -
> - /* De-initialize usb phy registers */
> - sphy->drv_data->phy_disable(sphy);
> -
> - /* Enable phy isolation */
> - if (sphy->plat && sphy->plat->pmu_isolation)
> - sphy->plat->pmu_isolation(true);
> - else if (sphy->drv_data->set_isolation)
> - sphy->drv_data->set_isolation(sphy, true);
> -
> - spin_unlock_irqrestore(&sphy->lock, flags);
> -
> - clk_disable_unprepare(sphy->clk);
> -}
> -
> -static int samsung_usb2phy_probe(struct platform_device *pdev)
> -{
> - struct samsung_usbphy *sphy;
> - struct usb_otg *otg;
> - struct samsung_usbphy_data *pdata = dev_get_platdata(&pdev->dev);
> - const struct samsung_usbphy_drvdata *drv_data;
> - struct device *dev = &pdev->dev;
> - struct resource *phy_mem;
> - void __iomem *phy_base;
> - struct clk *clk;
> - int ret;
> -
> - phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> - phy_base = devm_ioremap_resource(dev, phy_mem);
> - if (IS_ERR(phy_base))
> - return PTR_ERR(phy_base);
> -
> - sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
> - if (!sphy)
> - return -ENOMEM;
> -
> - otg = devm_kzalloc(dev, sizeof(*otg), GFP_KERNEL);
> - if (!otg)
> - return -ENOMEM;
> -
> - drv_data = samsung_usbphy_get_driver_data(pdev);
> -
> - if (drv_data->cpu_type == TYPE_EXYNOS5250)
> - clk = devm_clk_get(dev, "usbhost");
> - else
> - clk = devm_clk_get(dev, "otg");
> -
> - if (IS_ERR(clk)) {
> - dev_err(dev, "Failed to get usbhost/otg clock\n");
> - return PTR_ERR(clk);
> - }
> -
> - sphy->dev = dev;
> -
> - if (dev->of_node) {
> - ret = samsung_usbphy_parse_dt(sphy);
> - if (ret < 0)
> - return ret;
> - } else {
> - if (!pdata) {
> - dev_err(dev, "no platform data specified\n");
> - return -EINVAL;
> - }
> - }
> -
> - sphy->plat = pdata;
> - sphy->regs = phy_base;
> - sphy->clk = clk;
> - sphy->drv_data = drv_data;
> - sphy->phy.dev = sphy->dev;
> - sphy->phy.label = "samsung-usb2phy";
> - sphy->phy.type = USB_PHY_TYPE_USB2;
> - sphy->phy.init = samsung_usb2phy_init;
> - sphy->phy.shutdown = samsung_usb2phy_shutdown;
> -
> - sphy->ref_clk_freq = samsung_usbphy_get_refclk_freq(sphy);
> - if (sphy->ref_clk_freq < 0)
> - return -EINVAL;
> -
> - sphy->phy.otg = otg;
> - sphy->phy.otg->phy = &sphy->phy;
> - sphy->phy.otg->set_host = samsung_usbphy_set_host;
> -
> - spin_lock_init(&sphy->lock);
> -
> - platform_set_drvdata(pdev, sphy);
> -
> - return usb_add_phy_dev(&sphy->phy);
> -}
> -
> -static int samsung_usb2phy_remove(struct platform_device *pdev)
> -{
> - struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
> -
> - usb_remove_phy(&sphy->phy);
> -
> - if (sphy->pmuregs)
> - iounmap(sphy->pmuregs);
> - if (sphy->sysreg)
> - iounmap(sphy->sysreg);
> -
> - return 0;
> -}
> -
> -static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
> - .cpu_type = TYPE_S3C64XX,
> - .devphy_en_mask = S3C64XX_USBPHY_ENABLE,
> - .rate_to_clksel = samsung_usbphy_rate_to_clksel_64xx,
> - .set_isolation = NULL, /* TODO */
> - .phy_enable = samsung_usb2phy_enable,
> - .phy_disable = samsung_usb2phy_disable,
> -};
> -
> -static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
> - .cpu_type = TYPE_EXYNOS4210,
> - .devphy_en_mask = EXYNOS_USBPHY_ENABLE,
> - .hostphy_en_mask = EXYNOS_USBPHY_ENABLE,
> - .rate_to_clksel = samsung_usbphy_rate_to_clksel_64xx,
> - .set_isolation = samsung_usbphy_set_isolation_4210,
> - .phy_enable = samsung_usb2phy_enable,
> - .phy_disable = samsung_usb2phy_disable,
> -};
> -
> -static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
> - .cpu_type = TYPE_EXYNOS4X12,
> - .devphy_en_mask = EXYNOS_USBPHY_ENABLE,
> - .hostphy_en_mask = EXYNOS_USBPHY_ENABLE,
> - .rate_to_clksel = samsung_usbphy_rate_to_clksel_4x12,
> - .set_isolation = samsung_usbphy_set_isolation_4210,
> - .phy_enable = samsung_usb2phy_enable,
> - .phy_disable = samsung_usb2phy_disable,
> -};
> -
> -static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
> - .cpu_type = TYPE_EXYNOS5250,
> - .hostphy_en_mask = EXYNOS_USBPHY_ENABLE,
> - .hostphy_reg_offset = EXYNOS_USBHOST_PHY_CTRL_OFFSET,
> - .rate_to_clksel = samsung_usbphy_rate_to_clksel_4x12,
> - .set_isolation = samsung_usbphy_set_isolation_4210,
> - .phy_enable = samsung_exynos5_usb2phy_enable,
> - .phy_disable = samsung_exynos5_usb2phy_disable,
> -};
> -
> -#ifdef CONFIG_OF
> -static const struct of_device_id samsung_usbphy_dt_match[] = {
> - {
> - .compatible = "samsung,s3c64xx-usb2phy",
> - .data = &usb2phy_s3c64xx,
> - }, {
> - .compatible = "samsung,exynos4210-usb2phy",
> - .data = &usb2phy_exynos4,
> - }, {
> - .compatible = "samsung,exynos4x12-usb2phy",
> - .data = &usb2phy_exynos4x12,
> - }, {
> - .compatible = "samsung,exynos5250-usb2phy",
> - .data = &usb2phy_exynos5
> - },
> - {},
> -};
> -MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
> -#endif
> -
> -static struct platform_device_id samsung_usbphy_driver_ids[] = {
> - {
> - .name = "s3c64xx-usb2phy",
> - .driver_data = (unsigned long)&usb2phy_s3c64xx,
> - }, {
> - .name = "exynos4210-usb2phy",
> - .driver_data = (unsigned long)&usb2phy_exynos4,
> - }, {
> - .name = "exynos4x12-usb2phy",
> - .driver_data = (unsigned long)&usb2phy_exynos4x12,
> - }, {
> - .name = "exynos5250-usb2phy",
> - .driver_data = (unsigned long)&usb2phy_exynos5,
> - },
> - {},
> -};
> -
> -MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
> -
> -static struct platform_driver samsung_usb2phy_driver = {
> - .probe = samsung_usb2phy_probe,
> - .remove = samsung_usb2phy_remove,
> - .id_table = samsung_usbphy_driver_ids,
> - .driver = {
> - .name = "samsung-usb2phy",
> - .owner = THIS_MODULE,
> - .of_match_table = of_match_ptr(samsung_usbphy_dt_match),
> - },
> -};
> -
> -module_platform_driver(samsung_usb2phy_driver);
> -
> -MODULE_DESCRIPTION("Samsung USB 2.0 phy controller");
> -MODULE_AUTHOR("Praveen Paneri <p.paneri@samsung.com>");
> -MODULE_LICENSE("GPL");
> -MODULE_ALIAS("platform:samsung-usb2phy");
> -- 
> 1.8.2.3
> 
