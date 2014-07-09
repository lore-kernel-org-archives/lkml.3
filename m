Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaGIEDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:03:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaGIEDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:03:45 -0400
X-AuditID: cbfee690-b7fb56d000003439-de-53bcbf1e24cd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v7 4/4] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Wed, 09 Jul 2014 09:30:55 +0530
Message-id: <1404878455-31518-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSqyu/f0+wQXMXk8WySXfZLL7v+sJu
	0bvgKpvFpsfXWC0u75rDZjHj/D4mi9uXeS0+Hf3ParFoK1DF+hmvWSw6ljFa3Hy2ncmBx6Ol
	uYfNY/OSeo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKWDppDkvBQZmKR4vOsTYw3hbvYuTk
	kBAwkfg0+w8rhC0mceHeerYuRi4OIYGljBLPFp5jhim6/HIVO0RiEaPEpp83WCGcCUwSs5bt
	YQGpYhPQlXjyfi5Yh4hAtkT/7dUsIEXMAo8ZJd6sPMoIkhAWCJBoPLKYHcRmEVCVOPtkJ1ic
	V8BDYuJ0kEEcQOsUJOZMsgEJcwp4SrRMX84GYgsBlZxZtwFssYTAJnaJw227GCHmCEh8m3wI
	qldWYtMBqKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAWDj979mE
	HYz3DlgfYkwGGjeRWUo0OR8YS3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwMgvNrfq3JVDCdJceU4yxhYimqKRSffZlHMl5V4Z1s2adKxORkqv
	xXtpytvyncH+ug0vX19Nf3TzTVnoa+OirzsfGh5sXbdx+p9MtdJFGp03+QI0zVfqGHBr7qlW
	+5Atq6ky/489q2jk/LU8Nyez1PeVh8g+i9653PTMWY/FR5nPNJ8++qs0RImlOCPRUIu5qDgR
	AB9C0NKbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV25/XuCDfZNN7dYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDOWTprDUnBQpuLRonOsDYy3xbsYOTkkBEwkLr9cxQ5hi0lcuLeerYuRi0NIYBGjxKafN1gh
	nAlMErOW7WEBqWIT0JV48n4uM4gtIpAt0X97NQtIEbPAY0aJNyuPMoIkhAUCJBqPLAYbyyKg
	KnH2yU6wOK+Ah8TE6SCDOIDWKUjMmWQDEuYU8JRomb6cDcQWAio5s24D6wRG3gWMDKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgiPtmdQOxpUNFocYBTgYlXh4FXj2BAuxJpYVV+YeYpTg
	YFYS4f3mBhTiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGASyCuJNzQ2MTc1NrU0sTAxs1QS
	5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwLj/2ewS8acS3+Ivffy4wb1E0MCrONirbmK2nugh
	5ZUfk5+tVqlqvXnZpPb/3UDlBVZzdPonvUm+9zeuuKPXpL5n78NY96gJpvIr9cOfpvV5zdZT
	mvKD4c3WN+IXDTP0ZRTDpJJVp6jd5vEL/5i8q+CDp33ulCs6mxT6XJS2sse5r1+98/UsLiWW
	4oxEQy3mouJEAKPhJA/KAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves PMU specific definitions into a new file
as exynos-pmu.h.
This will help in reducing dependency of common.h in pmu.c.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h     |   17 -----------------
 arch/arm/mach-exynos/exynos-pmu.h |   24 ++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |   20 +++++++++++++++++++-
 4 files changed, 44 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 47b904b..9019d86 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -132,23 +132,6 @@ extern struct smp_operations exynos_smp_ops;
 
 extern void exynos_cpu_die(unsigned int cpu);
 
-/* PMU(Power Management Unit) support */
-
-#define PMU_TABLE_END	(-1U)
-
-enum sys_powerdown {
-	SYS_AFTR,
-	SYS_LPA,
-	SYS_SLEEP,
-	NUM_SYS_POWERDOWN,
-};
-
-struct exynos_pmu_conf {
-	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
-};
-
-extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_cpu_power_down(int cpu);
 extern void exynos_cpu_power_up(int cpu);
 extern int  exynos_cpu_power_state(int cpu);
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
new file mode 100644
index 0000000..a2ab0d5
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Header for EXYNOS PMU Driver support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_PMU_H
+#define __EXYNOS_PMU_H
+
+enum sys_powerdown {
+	SYS_AFTR,
+	SYS_LPA,
+	SYS_SLEEP,
+	NUM_SYS_POWERDOWN,
+};
+
+extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+
+#endif /* __EXYNOS_PMU_H */
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index bcb96be..b2efe8c 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -34,6 +34,7 @@
 #include <mach/map.h>
 
 #include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 5b76728..117f333 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -15,9 +15,16 @@
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
 
-#include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 
+#define PMU_TABLE_END	(-1U)
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	unsigned int val[NUM_SYS_POWERDOWN];
+};
+
 struct exynos_pmu_data {
 	const struct exynos_pmu_conf *pmu_config;
 	const struct exynos_pmu_conf *pmu_config_extra;
@@ -31,8 +38,19 @@ struct exynos_pmu_context {
 	const struct exynos_pmu_data *pmu_data;
 };
 
+static void __iomem *pmu_base_addr;
 static struct exynos_pmu_context *pmu_context;
 
+static inline void pmu_raw_writel(u32 val, u32 offset)
+{
+	__raw_writel(val, pmu_base_addr + offset);
+}
+
+static inline u32 pmu_raw_readl(u32 offset)
+{
+	return __raw_readl(pmu_base_addr + offset);
+}
+
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
-- 
1.7.9.5

