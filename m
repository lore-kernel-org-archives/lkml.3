Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaFPK04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:26:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51119 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbaFPK0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:26:52 -0400
From: Chander Kashyap <k.chander@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
        lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        tomasz.figa@gmail.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v7 3/6] cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little driver
Date: Mon, 16 Jun 2014 15:56:20 +0530
Message-Id: <1402914383-20471-4-git-send-email-k.chander@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
References: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <chander.kashyap@linaro.org>

Add support to select generic big-little cpuidle driver for Samsung Exynos
series SoC's. This is required for Exynos big-llittle SoC's eg, Exynos5420.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
Changes in v4:
	1. Typo fixed from SOC_EXYNOS5420 to ARCH_EXYNOS
	2. Commit message updated
Changes in v3: None
Changes in v2:
	1. Changed config macro from SOC_EXYNOS5420 to ARCH_EXYNOS
 drivers/cpuidle/Kconfig.arm |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index b6d69e8..2f6b33e 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -9,7 +9,7 @@ config ARM_ARMADA_370_XP_CPUIDLE
 
 config ARM_BIG_LITTLE_CPUIDLE
 	bool "Support for ARM big.LITTLE processors"
-	depends on ARCH_VEXPRESS_TC2_PM
+	depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
 	select ARM_CPU_SUSPEND
 	select CPU_IDLE_MULTIPLE_DRIVERS
 	help
-- 
1.7.9.5

