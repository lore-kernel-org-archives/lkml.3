Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3FKM4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:56:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65280 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3FKM4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:56:14 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V5 30/30] arm: exynos: enable ARCH_HAS_TMU
Date: Tue, 11 Jun 2013 18:23:40 +0530
Message-Id: <1370955220-2949-31-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables ARCH_HAS_TMU config for exynos4210, 4212, 4412, 5250
and 5440 SOC.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index d19edff..2aceaa4 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -33,6 +33,7 @@ config CPU_EXYNOS4210
 	bool "SAMSUNG EXYNOS4210"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select ARM_CPU_SUSPEND if PM
 	select PM_GENERIC_DOMAINS
 	select S5P_PM if PM
@@ -45,6 +46,7 @@ config SOC_EXYNOS4212
 	bool "SAMSUNG EXYNOS4212"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
@@ -55,6 +57,7 @@ config SOC_EXYNOS4412
 	bool "SAMSUNG EXYNOS4412"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select SAMSUNG_DMADEV
 	help
 	  Enable EXYNOS4412 SoC support
@@ -63,6 +66,7 @@ config SOC_EXYNOS5250
 	bool "SAMSUNG EXYNOS5250"
 	default y
 	depends on ARCH_EXYNOS5
+	select ARCH_HAS_TMU
 	select PM_GENERIC_DOMAINS if PM
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
@@ -76,6 +80,7 @@ config SOC_EXYNOS5440
 	default y
 	depends on ARCH_EXYNOS5
 	select ARCH_HAS_OPP
+	select ARCH_HAS_TMU
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
 	select PINCTRL
-- 
1.7.1

