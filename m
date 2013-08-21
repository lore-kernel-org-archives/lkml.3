Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3HUMxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:53:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48480 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3HUMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:53:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zyrZtz+wbYao+NCJXRAuX
Date: Wed, 21 Aug 2013 05:53:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 5/5] arm: omap2plus_defconfig: enable dwc3 and
 dependencies
Message-ID: <20130821125341.GK7656@atomide.com>
References: <1373979037-27587-1-git-send-email-balbi@ti.com>
 <1373979037-27587-6-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373979037-27587-6-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130716 05:57]:
> DWC3 enables USB3 functionality for OMAP5 boards,
> it's safe to enable those drivers in omap2plus_defconfig.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Looks like Benoit will take this, so:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/configs/omap2plus_defconfig | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index 5339e6a..aed3cce 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -81,6 +81,7 @@ CONFIG_CMA=y
>  CONFIG_CONNECTOR=y
>  CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
> +CONFIG_OMAP_OCP2SCP=y
>  CONFIG_MTD=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_CHAR=y
> @@ -167,9 +168,11 @@ CONFIG_THERMAL_GOV_USER_SPACE=y
>  CONFIG_CPU_THERMAL=y
>  CONFIG_OMAP_WATCHDOG=y
>  CONFIG_TWL4030_WATCHDOG=y
> +CONFIG_MFD_PALMAS=y
>  CONFIG_MFD_TPS65217=y
>  CONFIG_MFD_TPS65910=y
>  CONFIG_TWL6040_CORE=y
> +CONFIG_REGULATOR_PALMAS=y
>  CONFIG_REGULATOR_TWL4030=y
>  CONFIG_REGULATOR_TPS65023=y
>  CONFIG_REGULATOR_TPS6507X=y
> @@ -222,10 +225,14 @@ CONFIG_USB_MON=y
>  CONFIG_USB_WDM=y
>  CONFIG_USB_STORAGE=y
>  CONFIG_USB_LIBUSUAL=y
> +CONFIG_USB_DWC3=m
> +CONFIG_USB_DWC3_OMAP=m
>  CONFIG_USB_TEST=y
>  CONFIG_USB_PHY=y
>  CONFIG_NOP_USB_XCEIV=y
>  CONFIG_USB_GADGET=y
> +CONFIG_OMAP_USB2=y
> +CONFIG_OMAP_USB3=y
>  CONFIG_USB_GADGET_DEBUG=y
>  CONFIG_USB_GADGET_DEBUG_FILES=y
>  CONFIG_USB_GADGET_DEBUG_FS=y
> @@ -258,6 +265,8 @@ CONFIG_TI_THERMAL=y
>  CONFIG_OMAP4_THERMAL=y
>  CONFIG_OMAP5_THERMAL=y
>  CONFIG_DRA752_THERMAL=y
> +CONFIG_EXTCON=y
> +CONFIG_EXTCON_PALMAS=y
>  CONFIG_EXT2_FS=y
>  CONFIG_EXT3_FS=y
>  # CONFIG_EXT3_FS_XATTR is not set
> -- 
> 1.8.3.3.754.g9c3c367
> 
