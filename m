Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3CSLz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:55:28 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42462 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3CSLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:55:27 -0400
Date: Tue, 19 Mar 2013 12:55:18 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: ux500: select WATCHDOG and MUSB for ux500
Message-ID: <20130319115518.GA1558@balto.lan>
References: <1363604457-17112-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363604457-17112-1-git-send-email-fabio.baltieri@linaro.org>
X-Operating-System: Linux balto 3.8.0-09633-g2a7d2b9 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Mar 18, 2013 at 12:00:57PM +0100, Fabio Baltieri wrote:
> Enable ux500 specific USB and watchdog drivers by default on
> u8500_defconfig.

Please ignore this patch, some new Kconfig menus are being added in
-next so ab8500 USB will need additional options.  I'll send a v2 soon.

Thanks,
Fabio

> diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
> index 426270f..92b1347 100644
> --- a/arch/arm/configs/u8500_defconfig
> +++ b/arch/arm/configs/u8500_defconfig
> @@ -71,6 +71,7 @@ CONFIG_GPIO_TC3589X=y
>  # CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL is not set
>  CONFIG_THERMAL=y
>  CONFIG_CPU_THERMAL=y
> +CONFIG_WATCHDOG=y
>  CONFIG_MFD_STMPE=y
>  CONFIG_MFD_TC3589X=y
>  CONFIG_AB5500_CORE=y
> @@ -80,7 +81,12 @@ CONFIG_REGULATOR_AB8500=y
>  CONFIG_REGULATOR_FIXED_VOLTAGE=y
>  CONFIG_REGULATOR_GPIO=y
>  # CONFIG_HID_SUPPORT is not set
> +CONFIG_USB=y
> +CONFIG_USB_MUSB_HDRC=y
> +CONFIG_USB_MUSB_UX500=y
>  CONFIG_USB_GADGET=y
> +CONFIG_USB_GADGET_MUSB_HDRC=y
> +CONFIG_USB_ETH=m
>  CONFIG_AB8500_USB=y
>  CONFIG_MMC=y
>  CONFIG_MMC_CLKGATE=y
> -- 
> 1.8.1.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Fabio Baltieri
