Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3GPXSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:18:04 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53020 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab3GPXSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:18:02 -0400
Message-ID: <1374016680.26384.22.camel@x61.thuisdomein>
Subject: Re: [kconfig] results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 01:18:00 +0200
In-Reply-To: <7121962.G9xfZAqBSy@tacticalops>
References: <7121962.G9xfZAqBSy@tacticalops>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2013 23:18:00.0592 (UTC) FILETIME=[B6DD9900:01CE827A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 00:34 +0200, Martin Walch wrote:
> As I am working on yet another project for analyzing LKC's input files, I have 
> some intermediate results from simple syntactical checks.

Naive question: LKC?

> The results below are an excerpt from a run against tche current master.

One thing I noticed is that it is practical to be able to parse
arbitrary tags (commits) in the git tree. So you can quickly parse a
tree you don't actually have checked out in git. But perhaps your
checker also does that.

> If 
> anyone is interested in the code (it's written in Java), please contact me. I 
> plan on releasing my program under a FLOSS license later this year. If you find 
> the results interesting or even useful, I can post updates on a regular basis.
> 
> Actually defined symbols with dangerous names: 2
>   8260 at
>     arch/powerpc/platforms/82xx/Kconfig:55:0
>   8272 at
>     arch/powerpc/platforms/82xx/Kconfig:64:0

I've wondered for some time what happens when one uses either of these
numbers as the value for an "int" Kconfig symbol. I've never tried.

> Symbols used, but not defined: 31
>   Symbol: ARCH_EFM32 at
>     drivers/tty/serial/Kconfig:1427:0
>   Symbol: ARCH_MULTI_V4 at
>     arch/arm/Kconfig:914:0
>   Symbol: ARM_S3C24XX at
>     arch/arm/mach-s3c24xx/Kconfig:210:0
>   Symbol: ATHEROS_AR231X at
>     drivers/net/wireless/ath/ath5k/Kconfig:2:0
>     drivers/net/wireless/ath/ath5k/Kconfig:8:0
>     drivers/net/wireless/ath/ath5k/Kconfig:9:0
>     drivers/net/wireless/ath/ath5k/Kconfig:56:0
>     drivers/net/wireless/ath/ath5k/Kconfig:63:0
>   Symbol: CPU_MMP3 at
>     drivers/video/mmp/Kconfig:2:0
>     drivers/video/mmp/hw/Kconfig:4:0
>     drivers/usb/phy/Kconfig:53:0
>   Symbol: CPU_PXA988 at
>     drivers/video/mmp/Kconfig:2:0
>     drivers/video/mmp/hw/Kconfig:4:0
>   Symbol: CPU_SUBTYPE_SH7764 at
>     arch/sh/drivers/dma/Kconfig:14:0
>   Symbol: DEPRECATED at
>     arch/mn10300/Kconfig.debug:34:0
>   Symbol: EXYNOS_DEV_SYSMMU at
>     drivers/iommu/Kconfig:170:0
>   Symbol: GENERIC_HAS_IOMAP at
>     arch/score/Kconfig:27:0
>     arch/score/Kconfig:33:0
>     arch/score/Kconfig:39:0
>   Symbol: GENERIC_TIME at
>     arch/arm/mach-bcm/Kconfig:11:0
>   Symbol: GPIO_BCM at
>     arch/arm/mach-bcm/Kconfig:12:0
>   Symbol: HAVE_SCHED_CLOCK at
>     arch/arm/mach-keystone/Kconfig:10:0
>   Symbol: HOTPLUG at
>     arch/powerpc/platforms/pseries/Kconfig:22:0
>   Symbol: M at
>     drivers/usb/host/Kconfig:568:0
>     drivers/usb/misc/Kconfig:130:0

This looks odd. I think your checker doesn't like an uppercase M after
default. There are exactly two of those in the tree.

>   Symbol: MACH_NOKIA_RM696 at
>     arch/arm/mach-omap2/Kconfig:314:0
>   Symbol: MACH_OMAP_H4_OTG at
>     drivers/usb/gadget/Kconfig:208:0
>   Symbol: MACH_SMDKC210 at
>     sound/soc/samsung/Kconfig:138:0
>   Symbol: MACH_SMDKV310 at
>     sound/soc/samsung/Kconfig:138:0
>   Symbol: MN10300_PROC_MN2WS0038 at
>     arch/mn10300/Kconfig:185:0
>   Symbol: MPILIB_EXTRA at
>     crypto/asymmetric_keys/Kconfig:24:0
>   Symbol: MTD_JEDEC at
>     drivers/mtd/maps/Kconfig:161:0
>     drivers/mtd/maps/Kconfig:170:0
>   Symbol: MV64360 at
>     arch/powerpc/Kconfig:400:0
>   Symbol: N at
>     drivers/usb/core/Kconfig:12:0
>     drivers/usb/host/Kconfig:336:0
>     drivers/usb/host/Kconfig:348:0
>     drivers/staging/usbip/Kconfig:3:0
>     drivers/staging/usbip/Kconfig:20:0
>     drivers/staging/usbip/Kconfig:31:0
>     drivers/staging/usbip/Kconfig:42:0
>     drivers/staging/asus_oled/Kconfig:3:0
>     drivers/staging/rtl8187se/Kconfig:8:0
>     drivers/staging/rtl8192u/Kconfig:7:0
>     drivers/staging/rtl8192e/rtl8192e/Kconfig:7:0
>     drivers/staging/rtl8712/Kconfig:6:0
>     drivers/staging/rtl8712/Kconfig:14:0
>     drivers/staging/frontier/Kconfig:3:0
>     drivers/staging/bcm/Kconfig:3:0
>     drivers/staging/media/go7007/Kconfig:15:0
>     drivers/staging/media/go7007/Kconfig:26:0
>     drivers/staging/media/go7007/Kconfig:48:0
>     drivers/staging/android/Kconfig:4:0
>     drivers/staging/android/Kconfig:61:0
>     arch/cris/arch-v32/drivers/Kconfig:13:0
>     arch/cris/arch-v32/drivers/Kconfig:413:0
>     arch/arc/Kconfig:357:0

Ditto (but I haven't actually counted the occurrences of "default N").

>   Symbol: OF_VIDEOMODE at
>     drivers/staging/imx-drm/Kconfig:36:0
>   Symbol: OMAP_PM_SRF at
>     drivers/staging/tidspbridge/Kconfig:19:0
>   Symbol: PICOXCELL_PC3X3 at
>     drivers/char/hw_random/Kconfig:242:0
>   Symbol: PLATFORM_MICROBLAZE_AUTO at
>     arch/microblaze/platform/Kconfig.platform:10:0

This is a default of a "choice". There used to be quite a lot of invalid
"choice" defaults, so I stopped checking those. (But I didn't bother to
look how my local script now handles these.) In practice these are
treated as "no default", aren't they? 

>   Symbol: PLAT_SPEAR_SINGLE at
>     arch/arm/mach-spear/Kconfig:6:0
>     arch/arm/mach-spear/Kconfig:19:0
>     arch/arm/mach-spear/Kconfig:51:0
>     arch/arm/mach-spear/Kconfig:84:0
>     arch/arm/mach-spear/Kconfig:99:0
>   Symbol: SOC_DRA7XX at
>     drivers/thermal/ti-soc-thermal/Kconfig:52:0
>   Symbol: false at
>     drivers/staging/lustre/lustre/Kconfig:45:0

My script currently finds 28 undefined symbols. That equals this result
(given you have 2 false positive and 1 undefined choice default.)


Paul Bolle

