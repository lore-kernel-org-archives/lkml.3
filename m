Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbaFYOIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:08:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56409 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbaFYOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:08:34 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-65-53aad7e06d6f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 5/5] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Wed, 25 Jun 2014 19:33:52 +0530
Message-id: <1403705032-14835-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSrfvw+qpgg9NTGS2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VotFW4Eq1s94zWLRsYzR4uaz7UwOPB4t
	zT1sHpuX1Hv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqVzH9gKHolV/D2zkLGB8a9QFyMn
	h4SAicSSU/dYIGwxiQv31rN1MXJxCAksZZQ4s3kBM0zR+huPWUFsIYHpjBI7V8hD2BOYJH42
	s4PYbAK6Ek/ezwWrFxHIlui/vZoFZBCzwGNGiTcrjzKCJIQFAiRWPPoA1sAioCqx/NIksKG8
	Ah4Sd07tAYpzAC1TkJgzyQYkzCngKfFp5nd2iF0eEl9n7mcGmSkhsI1dYtLMJ6wQcwQkvk0+
	xALRKyux6QDUzZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmAcnP73
	bOIOxvsHrA8xJgONm8gsJZqcD4yjvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGan
	phakFsUXleakFh9iZOLglGpgtJ1XV/SYb0rs4Umt8R2Pea8utZcNyZ/Y8el9bcf8o3miBQJW
	hqsPOrQ9dZjWVXvn8pfmpwflePc5c0VnK3BtWdJ1tNveaemm+Y0TF733mzw3uWOPT5v5BTtL
	zu7Fghm//mg92R6i46PSt9HqqZLt0+BLp5KiGsR/Mr2WnHPi4MlfBpxx7avzlViKMxINtZiL
	ihMBmYFCq5kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQd0H11cFGyx+Z2KxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpUsX7GaxaLjmWMFjefbWdy4PFo
	ae5h89i8pN6jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgA5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGZcOveBreCRWMXfMwsZGxj/CnUxcnJICJhIrL/xmBXCFpO4cG89G4gtJDCdUWLnCnkIewKT
	xM9mdhCbTUBX4sn7ucwgtohAtkT/7dUsXYxcHMwCjxkl3qw8ygiSEBYIkFjx6ANYA4uAqsTy
	S5PAFvAKeEjcObUHKM4BtExBYs4kG5Awp4CnxKeZ39khdnlIfJ25n3kCI+8CRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFR9kx6B+OqBotDjAIcjEo8vBdmrwwWYk0sK67MPcQowcGs
	JMLrvn9VsBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnAxNAXkm8obGJuamxqaWJhYmZpZI4
	78FW60AhgfTEktTs1NSC1CKYPiYOTqkGRvbOOLenp6dfUlvP5/7Y+EZOXo3+MdUyoUWavMsO
	Tl35xTd6at/J6WfPlSnrdM6qqfHJ6drZNHP6C+ZnV/bdUbqZWae2+Ob7nnAtzc6cSbJfmz0/
	i+3cffrz25scUvf2KFTe+3bu7imuA8XPpL7eerNJvdeeUe38MV8p1stF7uu7/32v2tc4ZZYS
	S3FGoqEWc1FxIgChJfS2yAIAAA==
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
---
 arch/arm/mach-exynos/common.h     |   17 -----------------
 arch/arm/mach-exynos/exynos-pmu.h |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |    2 +-
 4 files changed, 33 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 296c6e1..0326ca2 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -135,23 +135,6 @@ extern struct smp_operations exynos_smp_ops;
 
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
index 0000000..16ff036
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos-pmu.h
@@ -0,0 +1,31 @@
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
+#define PMU_TABLE_END	(-1U)
+
+enum sys_powerdown {
+	SYS_AFTR,
+	SYS_LPA,
+	SYS_SLEEP,
+	NUM_SYS_POWERDOWN,
+};
+
+struct exynos_pmu_conf {
+	unsigned int offset;
+	unsigned int val[NUM_SYS_POWERDOWN];
+};
+
+extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+
+#endif /* __EXYNOS_PMU_H */
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 519aefe..de61d48 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -34,6 +34,7 @@
 #include <mach/map.h>
 
 #include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index c80a648..ca57a54 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -17,7 +17,7 @@
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
 
-#include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 
 struct exynos_pmu_data {
-- 
1.7.9.5

