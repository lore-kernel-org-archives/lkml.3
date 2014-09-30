Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaI3K0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:26:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40002 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaI3K0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:26:21 -0400
X-AuditID: cbfee68e-f79b46d000002b74-1b-542a85492cbc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v8 2/2] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Tue, 30 Sep 2014 15:51:21 +0530
Message-id: <1412072481-22370-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
References: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkTtezVSvE4MlUBYveBVfZLDY9vsZq
	cXnXHDaLGef3MVncvsxr8enof1aLRVu/sFt0LGO0WLXrD6PFzWfbmRy4PFqae9g8ds66y+6x
	eUm9R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGX87NjKXHBMvmLyxL0sDYwrpLoYOTkkBEwk
	9q5bwA5hi0lcuLeeDcQWEljKKHH+ZwJMzZfj3YxdjFxA8emMEo8/LmOGcCYwSbw70wbWzSag
	K/Hk/VxmEFtEIFvix7fJLCA2s8BuRom3n8VAbGGBAIk9dw+DbWARUJV49+EBaxcjBwevgIfE
	9H8JIKaEgILEnEk2IBWcAp4S/x+9Yoe4x0Piz8abrCBrJQTWsUvMeL6ZHWKMgMS3yYdYIHpl
	JTYdYIa4WVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAz90/+e9e1g
	vHnA+hCjAAejEg8vh7xWiBBrYllxZe4hRlOgDROZpUST84ERllcSb2hsZmRhamJqbGRuaaYk
	zpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OM058PJxY2/NouWM3x9eKG+4tK30+9
	HBhz6ucmwy2qXj1dtnvbf66X3Vne+JP7RODx12vt//autBRYx31Qc6XYvv3JMm3RvCuebM4x
	SdVzmaUtu+R7nPPPJZs2VVVvcVv1LeLP9sQtTou+FETJzFspINb3d3U3944dl1YfWG6uH8nT
	+0zw+KI8JZbijERDLeai4kQArfaK6XgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jQV3PVq0Qg6dN4ha9C66yWWx6fI3V
	4vKuOWwWM87vY7K4fZnX4tPR/6wWi7Z+YbfoWMZosWrXH0aLm8+2MzlwebQ097B57Jx1l91j
	85J6j74tqxg9Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvM
	TbVVcvEJ0HXLzAG6SUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8bNj
	K3PBMfmKyRP3sjQwrpDqYuTkkBAwkfhyvJsRwhaTuHBvPVsXIxeHkMB0RonHH5cxQzgTmCTe
	nWljB6liE9CVePJ+LjOILSKQLfHj22QWEJtZYDejxNvPYiC2sECAxJ67h9lAbBYBVYl3Hx6w
	djFycPAKeEhM/5cAYkoIKEjMmWQDUsEp4Cnx/9ErsOlCQBV/Nt5kncDIu4CRYRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcGw9k97BuKrB4hCjAAejEg8vh7xWiBBrYllxZe4hRgkOZiUR
	3q/1QCHelMTKqtSi/Pii0pzU4kOMpkA3TWSWEk3OB8Z9Xkm8obGJuamxqaWJhYmZpZI478FW
	60AhgfTEktTs1NSC1CKYPiYOTqkGxgTjoDvdNUrpRx+JfDwX9LiNbfItzRmzN0/lKl99o7fx
	uNRpNjHnG/ISk+/O93X2dIpYeKygRuIA16xzqkJXr4TmNfCysZYklV1b7KY4L9+t0EJE/5Xp
	jvTbmybx18xzy4ne6hk0wfb59NDZ5bUTNCw2ZkSmmLaGCebUxL86cn1nkd/ur+I1SizFGYmG
	WsxFxYkAtV2kBsMCAAA=
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
 arch/arm/mach-exynos/suspend.c    |    1 +
 5 files changed, 45 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index d4d09bc..431be1b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -139,23 +139,6 @@ extern void exynos_cpu_resume_ns(void);
 
 extern struct smp_operations exynos_smp_ops;
 
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
index 4f10fa6..86f3ecd 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -26,6 +26,7 @@
 #include <plat/pm-common.h>
 
 #include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 1f5aaa7..87613e0 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -13,9 +13,16 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
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
@@ -29,8 +36,19 @@ struct exynos_pmu_context {
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
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f5d9773..079d999 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -33,6 +33,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
+#include "exynos-pmu.h"
 
 #define S5P_CHECK_SLEEP 0x00000BAD
 
-- 
1.7.9.5

