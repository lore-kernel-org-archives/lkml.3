Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaD3FAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:00:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbaD3E7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:51 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d7-5360834233cb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 12/12] ARM: EXYNOS: Move PMU specific definitions from
 common.h
Date: Wed, 30 Apr 2014 14:17:37 +0900
Message-id: <1398835057-3860-13-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t8zA12n5oRgg5WT5C2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZTx9cIi94JF4xa/2y2wNjG+Fuxg5OSQETCTOPV7E
	BGGLSVy4t56ti5GLQ0hgGaPE+W23mWGKjp3dxApiCwksYpSYvMUWoqiNSWLbgTvsIAk2AV2J
	J+/ngjWICGRLXGm8zwxSxCywm1GisXEe0FgODmGBEInZb9xBTBYBVYm1KwVAynkFPCQWfXnC
	BBKWEFCQmDPJBiTMCRReePs31Fp3iYaGHkaQiRICq9glPnSvA0uwCAhIfJt8iAWiV1Zi0wGo
	kyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJCQn7iD8f4B60OMyUDj
	JjJLiSbnA2MmryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYW6SndOvdOvigTcrrk391ZOu5VTzm7uX8zhm9Jzu4z7Hnv9skcKLtPUtGuZ+6VtTJ
	5roN/2dM5bhZ6bLsW/LFG+fdmIv239Vx/5jlHLZPuXCJd7fTlY7Pe8VPXWjpmTI5qfqhUN8Z
	o3BpaU79q642UzOO2e2WM9Tjcviz+aFW/pX9BYqfL7kosRRnJBpqMRcVJwIAplIxto8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAV2n5oRggyvbpCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8x4+uAQe8Ej
	8Ypf7ZfZGhjfCncxcnJICJhIHDu7iRXCFpO4cG89G4gtJLCIUWLyFtsuRi4gu41JYtuBO+wg
	CTYBXYkn7+cyg9giAtkSVxrvM4MUMQvsZpRobJwH1M3BISwQIjH7jTuIySKgKrF2pQBIOa+A
	h8SiL0+YQMISAgoScybZgIQ5gcILb/9mhVjrLtHQ0MM4gZF3ASPDKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgiHomvYNxVYPFIUYBDkYlHl6BrfHBQqyJZcWVuYcYJTiYlUR4z1cmBAvx
	piRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjDa80riDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBceY9nR5uoUtVvw9U/67nXbh1atZPP+NDvSmFfJPC98x1ZGxu
	+fGqtfBDktWz730aeq3s+Tadj/9sfXtZdPNPe16X38vmsl8oE9gRuDX7l4flTBdv5f1sLMzH
	326xOHLy08mHz6TsHdMEJmjPNZ568/ZumyxWG1buvJ5ipmfh8xRvioZsTDgspsRSnJFoqMVc
	VJwIALNPL6rsAgAA
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
index 2922f20..8f45a35 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -35,24 +35,7 @@ extern struct smp_operations exynos_smp_ops;
 
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
index 030df96..1570761 100644
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

