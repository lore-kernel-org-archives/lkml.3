Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaEJHCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:02:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27970 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbaEJHCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:02:07 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-e0-536dceee9f79
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3 2/6] ARM: EXYNOS: Remove i2c sys configuration related code
Date: Sat, 10 May 2014 16:20:15 +0900
Message-id: <1399706419-13976-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t8zA91353KDDZrusVv8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLA4cHi3NPWwev39NYvTYvKTeo2/LKkaP
	z5vkAlijuGxSUnMyy1KL9O0SuDIali5lLNigVbF152umBsY1Sl2MnBwSAiYSx6+3s0DYYhIX
	7q1nA7GFBJYxSqxaWgBTs/rPZqYuRi6g+CJGiU/rl0I5bUwSzU3HmUGq2AR0JZ68nwtmiwhk
	S1xpvM8MUsQs0Mco0fnmF9hYYQE/ib4Vz9hBbBYBVYkth7+BxXkFPCRWXbnM2MXIAbROQWLO
	JBuQMKeAp8SOH11QF9VILG94wQgyU0JgFbvE7B2/mCHmCEh8m3yIBaJXVmLTAWaIqyUlDq64
	wTKBUXgBI8MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJBg79/BePeA9SHGZKBxE5mlRJPz
	gdGSVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	ReYJrZQSbLDqUrvsHLPhnUiteaySQolk5W4R05eHFwu/mtWZ8qbM2OdR2MVCkZoZf5RlAje1
	RLxYrO7GwlddbyUnuadBLV7M8h1j3xuFRA3uoNjjbNcWFxj9+CsSsiv/dcr3jlu9fQvzTtxs
	yswK+NzlVDX35tqqpR9j8/UldO9860r6sluJpTgj0VCLuag4EQAnh6vbjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAd1353KDDW6/YrL4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vF+hmvWRw4PFqae9g8fv+axOixeUm9R9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaFi6lLFgg1bF1p2v
	mRoY1yh1MXJySAiYSKz+s5kJwhaTuHBvPVsXIxeHkMAiRolP65cyQThtTBLNTceZQarYBHQl
	nryfC2aLCGRLXGm8zwxSxCzQxyjR+eYXG0hCWMBPom/FM3YQm0VAVWLL4W9gcV4BD4lVVy4z
	djFyAK1TkJgzyQYkzCngKbHjRxdYiZBAjcTyhheMExh5FzAyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIjqZn0jsYVzVYHGIU4GBU4uEtfJsTLMSaWFZcmXuIUYKDWUmEd8XB3GAh3pTE
	yqrUovz4otKc1OJDjMlAR01klhJNzgdGel5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNIT
	S1KzU1MLUotgtjBxcEo1ME7QZ5mh9HXRG9dT6wOnP16xWaCDU57jt52nnwRH3mGjml8H83jM
	nzVtT7z5cs1dnTM1qzwvrpC/fWSK5pQaCZ1Y/plNTJfC37/5Zh1Y9fPvyoqP2zdx54Qp5yz7
	dEeCYV+Jx8wdBkt1dGqEkkzMD95ft1Hvn8rGP3obtaasrGWvnyizmHdm9HQlluKMREMt5qLi
	RAA9dODg6gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all these code has been moved into i2c driver, now we can
safely remove them from machine files.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c           |   38 +------------------------------
 arch/arm/mach-exynos/include/mach/map.h |    3 ---
 arch/arm/mach-exynos/pm.c               |   10 --------
 arch/arm/mach-exynos/regs-sys.h         |   22 ------------------
 4 files changed, 1 insertion(+), 72 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 59eb1f1..09063ee 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -29,11 +29,11 @@
 #include <asm/memory.h>
 
 #include <plat/cpu.h>
+#include <mach/map.h>
 
 #include "common.h"
 #include "mfc.h"
 #include "regs-pmu.h"
-#include "regs-sys.h"
 
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
@@ -42,11 +42,6 @@ static struct regmap *exynos_pmu_regmap;
 
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
-		.virtual	= (unsigned long)S3C_VA_SYS,
-		.pfn		= __phys_to_pfn(EXYNOS4_PA_SYSCON),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= (unsigned long)S3C_VA_TIMER,
 		.pfn		= __phys_to_pfn(EXYNOS4_PA_TIMER),
 		.length		= SZ_16K,
@@ -116,11 +111,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
 
 static struct map_desc exynos5_iodesc[] __initdata = {
 	{
-		.virtual	= (unsigned long)S3C_VA_SYS,
-		.pfn		= __phys_to_pfn(EXYNOS5_PA_SYSCON),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= (unsigned long)S3C_VA_TIMER,
 		.pfn		= __phys_to_pfn(EXYNOS5_PA_TIMER),
 		.length		= SZ_16K,
@@ -293,32 +283,6 @@ void __init exynos_map_pmu(void)
 
 static void __init exynos_dt_machine_init(void)
 {
-	struct device_node *i2c_np;
-	const char *i2c_compat = "samsung,s3c2440-i2c";
-	unsigned int tmp;
-	int id;
-
-	/*
-	 * Exynos5's legacy i2c controller and new high speed i2c
-	 * controller have muxed interrupt sources. By default the
-	 * interrupts for 4-channel HS-I2C controller are enabled.
-	 * If node for first four channels of legacy i2c controller
-	 * are available then re-configure the interrupts via the
-	 * system register.
-	 */
-	if (soc_is_exynos5()) {
-		for_each_compatible_node(i2c_np, NULL, i2c_compat) {
-			if (of_device_is_available(i2c_np)) {
-				id = of_alias_get_id(i2c_np, "i2c");
-				if (id < 4) {
-					tmp = readl(EXYNOS5_SYS_I2C_CFG);
-					writel(tmp & ~(0x1 << id),
-							EXYNOS5_SYS_I2C_CFG);
-				}
-			}
-		}
-	}
-
 	exynos_map_pmu();
 
 	if (!soc_is_exynos5440())
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 34eee6e..bd4a320 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -25,9 +25,6 @@
 
 #define EXYNOS_PA_CHIPID		0x10000000
 
-#define EXYNOS4_PA_SYSCON		0x10010000
-#define EXYNOS5_PA_SYSCON		0x10050100
-
 #define EXYNOS4_PA_CMU			0x10030000
 #define EXYNOS5_PA_CMU			0x10010000
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index a7a1b7f..59e5604 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -37,7 +37,6 @@
 
 #include "common.h"
 #include "regs-pmu.h"
-#include "regs-sys.h"
 #include "exynos-pmu.h"
 
 static struct regmap *pmu_regmap;
@@ -52,10 +51,6 @@ struct exynos_wkup_irq {
 	u32 mask;
 };
 
-static struct sleep_save exynos5_sys_save[] = {
-	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
-};
-
 static struct sleep_save exynos_core_save[] = {
 	/* SROM side */
 	SAVE_ITEM(S5P_SROM_BW),
@@ -211,7 +206,6 @@ static void exynos_pm_prepare(void)
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (soc_is_exynos5250()) {
-		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
 		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
 		regmap_read(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, &tmp);
 		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
@@ -296,10 +290,6 @@ static void exynos_pm_resume(void)
 	regmap_write(pmu_regmap, S5P_PAD_RET_EBIA_OPTION, (1 << 28));
 	regmap_write(pmu_regmap, S5P_PAD_RET_EBIB_OPTION, (1 << 28));
 
-	if (soc_is_exynos5250())
-		s3c_pm_do_restore(exynos5_sys_save,
-			ARRAY_SIZE(exynos5_sys_save));
-
 	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (!soc_is_exynos5250())
diff --git a/arch/arm/mach-exynos/regs-sys.h b/arch/arm/mach-exynos/regs-sys.h
deleted file mode 100644
index 84332b0..0000000
--- a/arch/arm/mach-exynos/regs-sys.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (c) 2014 Samsung Electronics Co., Ltd.
- *             http://www.samsung.com
- *
- * EXYNOS - system register definition
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_REGS_SYS_H
-#define __ASM_ARCH_REGS_SYS_H __FILE__
-
-#include <mach/map.h>
-
-#define S5P_SYSREG(x)                          (S3C_VA_SYS + (x))
-
-/* For EXYNOS5 */
-#define EXYNOS5_SYS_I2C_CFG                    S5P_SYSREG(0x0234)
-
-#endif /* __ASM_ARCH_REGS_SYS_H */
-- 
1.7.10.4

