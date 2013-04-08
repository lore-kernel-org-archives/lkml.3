Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab3DHOzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:55:14 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:63745 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965359Ab3DHOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:55:12 -0400
Message-ID: <1365432910.1830.105.camel@x61.thuisdomein>
Subject: [PATCH] ARM: EXYNOS: remove "config EXYNOS_DEV_DRM"
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rahul Sharma <rahul.sharma@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 16:55:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 14:55:10.0405 (UTC) FILETIME=[11232750:01CE3469]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of Kconfig symbol EXYNOS_DEV_DRM was removed in commit
0a9d5ac307aefbb2c772537d3fe7f75046d563ac ("ARM: EXYNOS: removing
exynos-drm device registration from non-dt platforms"). It is safe to
remove this symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Only "git grep" tested.

 arch/arm/mach-exynos/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 70f94c8..99e7142 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -95,11 +95,6 @@ config EXYNOS4_DEV_AHCI
 	help
 	  Compile in platform device definitions for AHCI
 
-config EXYNOS_DEV_DRM
-	bool
-	help
-	  Compile in platform device definitions for core DRM device
-
 config EXYNOS4_SETUP_FIMD0
 	bool
 	help
@@ -199,7 +194,6 @@ config MACH_SMDKV310
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
-	select EXYNOS_DEV_DRM
 	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC
@@ -253,7 +247,6 @@ config MACH_UNIVERSAL_C210
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
-	select EXYNOS_DEV_DRM
 	select EXYNOS_DEV_SYSMMU
 	select HAVE_SCHED_CLOCK
 	select S3C_DEV_HSMMC
@@ -294,7 +287,6 @@ config MACH_NURI
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
-	select EXYNOS_DEV_DRM
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_HSMMC3
@@ -330,7 +322,6 @@ config MACH_ORIGEN
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
-	select EXYNOS_DEV_DRM
 	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC
@@ -366,7 +357,6 @@ config MACH_SMDK4212
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select EXYNOS_DEV_DMA
-	select EXYNOS_DEV_DRM
 	select EXYNOS_DEV_SYSMMU
 	select S3C24XX_PWM
 	select S3C_DEV_HSMMC2
-- 
1.7.11.7

