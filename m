Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3HKJRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 05:17:42 -0400
Received: from f418.i.mail.ru ([185.5.136.89]:35661 "EHLO f418.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3HKJRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 05:17:39 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?Tm9uLWV4aXN0ZW50IEtjb25maWcgc3ltYm9scyBpbiBsaW51eC1uZXh0LTEw?=
 =?UTF-8?B?LjA4?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sun, 11 Aug 2013 13:17:36 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1376212656.781632253@f418.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7B9IHlb017642

Hello.

Just for information,
this is list of non-existent Kconfig symbols in the linux-next tree:

/home/git/linux-aug10/arch/arm/mach-bcm/Kconfig:11 Bad =select= reference to GENERIC_TIME.
/home/git/linux-aug10/arch/arm/mach-bcm/Kconfig:12 Bad =select= reference to GPIO_BCM.
/home/git/linux-aug10/arch/arm/mach-omap2/Kconfig:60 Bad =if= reference to LOCAL_TIMERS.
/home/git/linux-aug10/arch/arm/mach-rockchip/Kconfig:8 Bad =if= reference to LOCAL_TIMERS.
/home/git/linux-aug10/arch/arm/mach-rockchip/Kconfig:10 Bad =select= reference to LOCAL_TIMERS.
/home/git/linux-aug10/arch/arm/mach-shmobile/Kconfig:7 Bad =if= reference to LOCAL_TIMERS.
/home/git/linux-aug10/arch/arm/mach-spear/Kconfig:20 Bad =on= reference to PLAT_SPEAR_SINGLE.
/home/git/linux-aug10/arch/arm/mach-spear/Kconfig:52 Bad =on= reference to PLAT_SPEAR_SINGLE.
/home/git/linux-aug10/arch/arm/mach-spear/Kconfig:85 Bad =on= reference to PLAT_SPEAR_SINGLE.
/home/git/linux-aug10/arch/arm/mach-vexpress/Kconfig:72 Bad =select= reference to VEXPRESS_SPC.
/home/git/linux-aug10/arch/metag/Kconfig.soc:20 Bad =select= reference to IMGPDC_IRQ.
/home/git/linux-aug10/arch/mn10300/Kconfig:186 Bad =on= reference to MN10300_PROC_MN2WS0038.
/home/git/linux-aug10/arch/mn10300/Kconfig.debug:35 Bad =on= reference to DEPRECATED.
/home/git/linux-aug10/arch/powerpc/Kconfig:401 Bad =on= reference to MV64360.
/home/git/linux-aug10/arch/score/Kconfig:27 Bad =select= reference to GENERIC_HAS_IOMAP.
/home/git/linux-aug10/arch/score/Kconfig:33 Bad =select= reference to GENERIC_HAS_IOMAP.
/home/git/linux-aug10/arch/score/Kconfig:39 Bad =select= reference to GENERIC_HAS_IOMAP.
/home/git/linux-aug10/arch/sh/drivers/dma/Kconfig:15 Bad =if= reference to CPU_SUBTYPE_SH7764.
/home/git/linux-aug10/crypto/asymmetric_keys/Kconfig:24 Bad =select= reference to MPILIB_EXTRA.
/home/git/linux-aug10/drivers/char/hw_random/Kconfig:243 Bad =on= reference to PICOXCELL_PC3X3.
/home/git/linux-aug10/drivers/iommu/Kconfig:171 Bad =on= reference to EXYNOS_DEV_SYSMMU.
/home/git/linux-aug10/drivers/net/wireless/ath/ath5k/Kconfig:3 Bad =on= reference to ATHEROS_AR231X.
/home/git/linux-aug10/drivers/net/wireless/ath/ath5k/Kconfig:9 Bad =if= reference to ATHEROS_AR231X.
/home/git/linux-aug10/drivers/net/wireless/ath/ath5k/Kconfig:10 Bad =if= reference to ATHEROS_AR231X.
/home/git/linux-aug10/drivers/net/wireless/ath/ath5k/Kconfig:57 Bad =on= reference to ATHEROS_AR231X.
/home/git/linux-aug10/drivers/net/wireless/ath/ath5k/Kconfig:64 Bad =on= reference to ATHEROS_AR231X.
/home/git/linux-aug10/drivers/staging/tidspbridge/Kconfig:20 Bad =on= reference to OMAP_PM_SRF.
/home/git/linux-aug10/drivers/thermal/ti-soc-thermal/Kconfig:53 Bad =on= reference to SOC_DRA7XX.
/home/git/linux-aug10/drivers/tty/serial/Kconfig:1428 Bad =on= reference to ARCH_EFM32.
/home/git/linux-aug10/drivers/usb/gadget/Kconfig:208 Bad =if= reference to MACH_OMAP_H4_OTG.
/home/git/linux-aug10/drivers/usb/phy/Kconfig:45 Bad =on= reference to CPU_MMP3.
/home/git/linux-aug10/drivers/video/mmp/hw/Kconfig:5 Bad =on= reference to CPU_MMP3.
/home/git/linux-aug10/drivers/video/mmp/hw/Kconfig:5 Bad =on= reference to CPU_PXA988.
/home/git/linux-aug10/drivers/video/mmp/Kconfig:3 Bad =on= reference to CPU_MMP3.
/home/git/linux-aug10/drivers/video/mmp/Kconfig:3 Bad =on= reference to CPU_PXA988.
/home/git/linux-aug10/sound/soc/omap/Kconfig:3 Bad =on= reference to ARCH_ARM.
/home/git/linux-aug10/sound/soc/omap/Kconfig:29 Bad =on= reference to ARCH_ARM.
/home/git/linux-aug10/sound/soc/sh/Kconfig:40 Bad =select= reference to RCAR_CLK_ADG.

---
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
