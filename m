Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab3CGEOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:14:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48952 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CGEOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:14:15 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 3/4] arm: exynos: Enable OPP library support for exynos5440
Date: Thu,  7 Mar 2013 09:43:46 +0530
Message-Id: <1362629627-10012-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
References: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OPP library support is needed for exynos5440 cpu frequency
dynamic scaling driver.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 70f94c8..d5dde07 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -72,10 +72,12 @@ config SOC_EXYNOS5440
 	bool "SAMSUNG EXYNOS5440"
 	default y
 	depends on ARCH_EXYNOS5
+	select ARCH_HAS_OPP
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
 	select PINCTRL
 	select PINCTRL_EXYNOS5440
+	select PM_OPP
 	help
 	  Enable EXYNOS5440 SoC support
 
-- 
1.7.1

