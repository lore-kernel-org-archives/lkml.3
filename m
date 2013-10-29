Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3J2QNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:13:20 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63361 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3J2QNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:13:19 -0400
Date: Tue, 29 Oct 2013 09:13:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Watchdog patches - overview.
Message-ID: <20131029161317.GC9266@roeck-us.net>
References: <20131029090458.GN19704@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029090458.GN19704@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:04:58AM +0100, Wim Van Sebroeck wrote:
> Hi All,
> 
> Just to give you an update on where we are:
> 1) following patches are linux-watchdog-next:
> watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
> watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
> imx2_wdt: expose module alias for loading from device-tree
> watchdog: use dev_get_platdata()
> watchdog: dw_wdt: Add __user annotation
> watchdog: kempld_wdt: Add __user annotation
> watchdog: Add MOXA ART watchdog driver
> watchdog: add ralink watchdog driver
> documentation/devicetree: Move DT bindigns from gpio to watchdog
> watchdog: ts72xx_wdt: cleanup return codes in ioctl
> watchdog: Remove redundant of_match_ptr
> watchdog: sirf: add watchdog driver of CSR SiRFprimaII and SiRFatlasVI
> watchdog: sp805_wdt: Remove unnecessary amba_set_drvdata()
> watchdog: at91sam9_wdt: better watchdog support
> watchdog: at91sam9_wdt: update device tree doc
> ARM: at91/dt: add sam9 watchdog default options to SoCs
> ARM: at91/dt: add watchdog properties to kizbox board
> watchdog: pcwd_usb: Use allocated buffer for usb_control_msg
> watchdog: ts72xx_wdt: Propagate return value from timeout_to_regval
> watchdog: Get rid of MODULE_ALIAS_MISCDEV statements
> watchdog: dw: Enable OF support for DW watchdog timer
> watchdog: watchdog_core: Fix a trivial typo
> 
> 2) patches that I am reviewing or are on my radar:
> w83627hf-patches
> Orion-patches
> f81865_gpio.c
> [PATCH V2 0/4] Add watchdog DT nodes and parse it to read PMU registers addresses (Exynos+s3c2410_wdt)
> [PATCH v4 4/4] ARM: bcm4760: Add restart hook
> [PATCH] Documentation/watchdog: Update node name in samsung-wdt example
> 
> So if something is still missing: please let it know.
> 
Hi Wim,

thanks a lot for getting this all done.

There is also
	http://patchwork.roeck-us.net/patch/503/
	Move and rename HP watchdog timer driver

[ Not sure if that is a good idea. For hwmon, I noticed that out-of-directory
  hwmon drivers are not reviewed by hwmon maintainers, often resulting in bad
  or even broken code ]

and
	http://patchwork.roeck-us.net/patch/264/
	watchdog: Sysfs interface for MEN A21 watchdog

[ It might make more sense to add common sysfs attributes to the
  watchdog code ]

Thanks,
Guenter

> Kind regards,
> Wim.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
