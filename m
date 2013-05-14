Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3ENKBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:01:43 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:60846 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3ENKBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:01:38 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 30/30] arm: exynos: enable ARCH_HAS_TMU
Date: Tue, 14 May 2013 15:29:00 +0530
Message-Id: <1368525540-15034-31-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
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
index 70f94c8..919a2f2 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -31,6 +31,7 @@ config CPU_EXYNOS4210
 	bool "SAMSUNG EXYNOS4210"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select ARM_CPU_SUSPEND if PM
 	select PM_GENERIC_DOMAINS
 	select S5P_PM if PM
@@ -43,6 +44,7 @@ config SOC_EXYNOS4212
 	bool "SAMSUNG EXYNOS4212"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
@@ -53,6 +55,7 @@ config SOC_EXYNOS4412
 	bool "SAMSUNG EXYNOS4412"
 	default y
 	depends on ARCH_EXYNOS4
+	select ARCH_HAS_TMU
 	select SAMSUNG_DMADEV
 	help
 	  Enable EXYNOS4412 SoC support
@@ -61,6 +64,7 @@ config SOC_EXYNOS5250
 	bool "SAMSUNG EXYNOS5250"
 	default y
 	depends on ARCH_EXYNOS5
+	select ARCH_HAS_TMU
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select S5P_DEV_MFC
@@ -72,6 +76,7 @@ config SOC_EXYNOS5440
 	bool "SAMSUNG EXYNOS5440"
 	default y
 	depends on ARCH_EXYNOS5
+	select ARCH_HAS_TMU
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
 	select PINCTRL
-- 
1.7.1

