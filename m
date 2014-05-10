Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaEJGiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25984 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaEJGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:30 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-07-536dc965ea14
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 11/11] ARM: EXYNOS: Move PMU specific definitions from
 common.h
Date: Sat, 10 May 2014 15:56:38 +0900
Message-id: <1399704998-13321-12-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zI93Uk7nBBnc6BC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZdyYvZyx4JF4Ref11YwNjG+Fuxg5OSQETCQ2f+5n
	hrDFJC7cW8/WxcjFISSwjFFiyt4udpiil10XoRLTGSWWzdvGAuG0MUl8eHqLCaSKTUBX4sn7
	uWCjRASyJa403mcGKWIW2M0o0dg4jw0kISwQInFg2kRWEJtFQFWia+kSsAZeAU+Jpd1HgaZy
	AK1TkJgzyQYkzAkU/vp1Mdh8IQEPiQfdS8FmSgisYpf4fKqJHWKOgMS3yYegemUlNh2AekdS
	4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgJ/N4djLcPWB9iTAYaN5FZ
	SjQ5Hxg5eSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAaP7VoGnudoNdfL84VMtOdWquny3KN6fjx4SvN+y8zua7R/jUWnxN5V3MWO00TXGr/5TP
	4uEKBr2XZ5okeW5QFp1Z18Tebnxk1Tmb360HGDUn/Mx46sptEs6/tPGV4RqOLwvP3Nl9tLvy
	Gc8ByUM1Wglzlv+XVegWXWNzsHvHvG0Lf2zbZHc4S4mlOCPRUIu5qDgRAHDZG0CSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd3Uk7nBBqtn8Vgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hxY/ZyxoJH
	4hWd11czNjC+Fe5i5OSQEDCReNl1kQ3CFpO4cG89kM3FISQwnVFi2bxtLBBOG5PEh6e3mECq
	2AR0JZ68n8sMYosIZEtcabzPDFLELLCbUaKxcR7YKGGBEIkD0yaygtgsAqoSXUuXgDXwCnhK
	LO0+CjSVA2idgsScSTYgYU6g8Nevi8HmCwl4SDzoXso8gZF3ASPDKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzguHomtYNxZYPFIUYBDkYlHt6CtznBQqyJZcWVuYcYJTiYlUR4VxzMDRbi
	TUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDM55XEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QD42yePw3MSkLvCqPTqp7O+3hKlOnl/02OS0x79n2V39a+9cm6
	aT+Vo1TUn30MqLszJcpN85pi0bm0qfp525nZTjM3si+dWDp53dodEb8y2g908s175Nh6rezq
	L//tBy5VXdIyW7Hi17efN1n6HXjT2Uuqmk8V6mn/3ljikeo1ba728bz/mcUy15RYijMSDbWY
	i4oTASjW5zfvAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

This patch moves PMU specific definitions into a new file
as exynos-pmu.h. This will help in making PMU implementation
independent of common.h header.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h     |   17 -----------------
 arch/arm/mach-exynos/exynos-pmu.h |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |    2 +-
 4 files changed, 33 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 58b2b5d..abcb074 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -37,24 +37,7 @@ extern struct smp_operations exynos_smp_ops;
 
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
 extern unsigned long l2x0_regs_phys;
-struct exynos_pmu_conf {
-	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
-};
-
-extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 extern void exynos_enter_aftr(void);
 
 extern struct regmap *get_exynos_pmuregmap(void);
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
index ee427d7..a7a1b7f 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -38,6 +38,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
+#include "exynos-pmu.h"
 
 static struct regmap *pmu_regmap;
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 6a7fa8e..50c33c9 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/mfd/syscon.h>
 
-#include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 
 struct exynos_pmu_data {
-- 
1.7.10.4

