Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3GPWen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:34:43 -0400
Received: from mout.web.de ([212.227.15.4]:64781 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab3GPWel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:34:41 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kernel@vger.kernel.org
Subject: [kconfig] results of some syntactical checks
Date: Wed, 17 Jul 2013 00:34:38 +0200
Message-ID: <7121962.G9xfZAqBSy@tacticalops>
User-Agent: KMail/4.10.5 (Linux/3.9.9-gentoo-gnu; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1403344.zgUQRAtCLa"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:PNsMoFrydMtuud6VpS5L1Hdlm6Q89xAMhxC4IU2LGM1jYLnpi0N
 pZgczWj+RbD/6VL4Z1qpCPBMlfhHIgCI9HVK9ud8MyKYDs+cwOaZn9UHCmuayuXp8uZRa/D
 w+rAnTRcQ8zjmRLNrKI/Ad4S3eTToQk1bYZuEIvRb/nkQzMNCulj6bz3NB6O99RzQEj8hOk
 iYYes2kCeYENz5Mw+0bvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1403344.zgUQRAtCLa
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

As I am working on yet another project for analyzing LKC's input files, I have 
some intermediate results from simple syntactical checks.

The results below are an excerpt from a run against tche current master. If 
anyone is interested in the code (it's written in Java), please contact me. I 
plan on releasing my program under a FLOSS license later this year. If you find 
the results interesting or even useful, I can post updates on a regular basis.

Actually defined symbols with dangerous names: 2
  8260 at
    arch/powerpc/platforms/82xx/Kconfig:55:0
  8272 at
    arch/powerpc/platforms/82xx/Kconfig:64:0

Symbols used, but not defined: 31
  Symbol: ARCH_EFM32 at
    drivers/tty/serial/Kconfig:1427:0
  Symbol: ARCH_MULTI_V4 at
    arch/arm/Kconfig:914:0
  Symbol: ARM_S3C24XX at
    arch/arm/mach-s3c24xx/Kconfig:210:0
  Symbol: ATHEROS_AR231X at
    drivers/net/wireless/ath/ath5k/Kconfig:2:0
    drivers/net/wireless/ath/ath5k/Kconfig:8:0
    drivers/net/wireless/ath/ath5k/Kconfig:9:0
    drivers/net/wireless/ath/ath5k/Kconfig:56:0
    drivers/net/wireless/ath/ath5k/Kconfig:63:0
  Symbol: CPU_MMP3 at
    drivers/video/mmp/Kconfig:2:0
    drivers/video/mmp/hw/Kconfig:4:0
    drivers/usb/phy/Kconfig:53:0
  Symbol: CPU_PXA988 at
    drivers/video/mmp/Kconfig:2:0
    drivers/video/mmp/hw/Kconfig:4:0
  Symbol: CPU_SUBTYPE_SH7764 at
    arch/sh/drivers/dma/Kconfig:14:0
  Symbol: DEPRECATED at
    arch/mn10300/Kconfig.debug:34:0
  Symbol: EXYNOS_DEV_SYSMMU at
    drivers/iommu/Kconfig:170:0
  Symbol: GENERIC_HAS_IOMAP at
    arch/score/Kconfig:27:0
    arch/score/Kconfig:33:0
    arch/score/Kconfig:39:0
  Symbol: GENERIC_TIME at
    arch/arm/mach-bcm/Kconfig:11:0
  Symbol: GPIO_BCM at
    arch/arm/mach-bcm/Kconfig:12:0
  Symbol: HAVE_SCHED_CLOCK at
    arch/arm/mach-keystone/Kconfig:10:0
  Symbol: HOTPLUG at
    arch/powerpc/platforms/pseries/Kconfig:22:0
  Symbol: M at
    drivers/usb/host/Kconfig:568:0
    drivers/usb/misc/Kconfig:130:0
  Symbol: MACH_NOKIA_RM696 at
    arch/arm/mach-omap2/Kconfig:314:0
  Symbol: MACH_OMAP_H4_OTG at
    drivers/usb/gadget/Kconfig:208:0
  Symbol: MACH_SMDKC210 at
    sound/soc/samsung/Kconfig:138:0
  Symbol: MACH_SMDKV310 at
    sound/soc/samsung/Kconfig:138:0
  Symbol: MN10300_PROC_MN2WS0038 at
    arch/mn10300/Kconfig:185:0
  Symbol: MPILIB_EXTRA at
    crypto/asymmetric_keys/Kconfig:24:0
  Symbol: MTD_JEDEC at
    drivers/mtd/maps/Kconfig:161:0
    drivers/mtd/maps/Kconfig:170:0
  Symbol: MV64360 at
    arch/powerpc/Kconfig:400:0
  Symbol: N at
    drivers/usb/core/Kconfig:12:0
    drivers/usb/host/Kconfig:336:0
    drivers/usb/host/Kconfig:348:0
    drivers/staging/usbip/Kconfig:3:0
    drivers/staging/usbip/Kconfig:20:0
    drivers/staging/usbip/Kconfig:31:0
    drivers/staging/usbip/Kconfig:42:0
    drivers/staging/asus_oled/Kconfig:3:0
    drivers/staging/rtl8187se/Kconfig:8:0
    drivers/staging/rtl8192u/Kconfig:7:0
    drivers/staging/rtl8192e/rtl8192e/Kconfig:7:0
    drivers/staging/rtl8712/Kconfig:6:0
    drivers/staging/rtl8712/Kconfig:14:0
    drivers/staging/frontier/Kconfig:3:0
    drivers/staging/bcm/Kconfig:3:0
    drivers/staging/media/go7007/Kconfig:15:0
    drivers/staging/media/go7007/Kconfig:26:0
    drivers/staging/media/go7007/Kconfig:48:0
    drivers/staging/android/Kconfig:4:0
    drivers/staging/android/Kconfig:61:0
    arch/cris/arch-v32/drivers/Kconfig:13:0
    arch/cris/arch-v32/drivers/Kconfig:413:0
    arch/arc/Kconfig:357:0
  Symbol: OF_VIDEOMODE at
    drivers/staging/imx-drm/Kconfig:36:0
  Symbol: OMAP_PM_SRF at
    drivers/staging/tidspbridge/Kconfig:19:0
  Symbol: PICOXCELL_PC3X3 at
    drivers/char/hw_random/Kconfig:242:0
  Symbol: PLATFORM_MICROBLAZE_AUTO at
    arch/microblaze/platform/Kconfig.platform:10:0
  Symbol: PLAT_SPEAR_SINGLE at
    arch/arm/mach-spear/Kconfig:6:0
    arch/arm/mach-spear/Kconfig:19:0
    arch/arm/mach-spear/Kconfig:51:0
    arch/arm/mach-spear/Kconfig:84:0
    arch/arm/mach-spear/Kconfig:99:0
  Symbol: SOC_DRA7XX at
    drivers/thermal/ti-soc-thermal/Kconfig:52:0
  Symbol: false at
    drivers/staging/lustre/lustre/Kconfig:45:0
-- 

--nextPart1403344.zgUQRAtCLa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEABECAAYFAlHlyn4ACgkQM6S4K8IXn9c2sQCgoXIBAXJ1hm6GruHKGhTUqq73
SqUAnAj4sFU/VxXRMR9ngsdM6fDrWhFu
=cbvp
-----END PGP SIGNATURE-----

--nextPart1403344.zgUQRAtCLa--

