Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3GEQWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3GEQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 8/8] ARM: exynos: select PM_GENERIC_DOMAINS only when used
Date: Fri,  5 Jul 2013 18:23:37 +0200
Message-Id: <1373041417-217728-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1EnkPMnun0OpmpcdS1XbSLceMxeqJqBIDDU6lnrh+TZ
 fpniv3ArBTolGu/78+iFsnEMUeqodeCv74Wc+fNXu6hdLVtEzH
 wBb1Am3xYzF2Zn2EY7eof01ZLlUlTdy74cbvRvGqCT6t6N+/q9
 4I1r4JftgNEGSv4KPcivLJTmNGqAlRMIMDtIlXRtuJ8oJO+OiA
 PrkeSXb7jPPStokozmuab0u4CY7rkws0Tf9tOsLXdZIWciLI6A
 7rwKEfgrH1JUzQs+oO81OzozuSNq96Aci8zcKNVy92aXDoerUp
 C0RcyU1QYv/dzTwjfk2o/nUb1+uiO0rUwu7sEQD7aszZssN8O9
 0cSnJJ72Ad46IKOkxvSXkVTVooyiZhZW/85rPtJey
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes building exynos kernels with CONFIG_PM disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 2d503b3..ba70a84 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -38,7 +38,7 @@ config CPU_EXYNOS4210
 	depends on ARCH_EXYNOS4
 	select ARM_CPU_SUSPEND if PM
 	select PINCTRL_EXYNOS
-	select PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
-- 
1.8.3.1

