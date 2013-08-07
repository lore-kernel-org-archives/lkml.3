Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3HGOra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:47:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57016 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab3HGOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:47:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, swarren@nvidia.com
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/6] ARM: Tegra: Enable OPP library
Date: Wed,  7 Aug 2013 20:16:45 +0530
Message-Id: <bfa34bd91e0fa4c6e215517e10c93ab271486418.1375886595.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375886595.git.viresh.kumar@linaro.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375886595.git.viresh.kumar@linaro.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-cpu0 driver is dependent on OPP library and hence we need to enable it
for Tegra as we are going to use cpufreq-cpu0.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-tegra/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index ef3a8da..63875c5 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -1,6 +1,8 @@
 config ARCH_TEGRA
 	bool "NVIDIA Tegra" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
+	select PM_OPP if PM
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
-- 
1.7.12.rc2.18.g61b472e

