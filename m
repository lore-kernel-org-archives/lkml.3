Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaGGFWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:22:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31499 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaGGFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:22:26 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-08-53ba2e8c84cd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 4/4] ARM: EXYNOS: Move PMU specific definitions from common.h
Date: Mon, 07 Jul 2014 10:49:36 +0530
Message-id: <1404710376-16448-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSpdujtyvY4PsaK4tlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV8enrb5aCnZIVVy7/YGpgnC3axcjJ
	ISFgInGq8QUzhC0mceHeerYuRi4OIYGljBIzb81h7GLkACuaNU8HIr6IUWL1vv3MEM4EJokP
	XXvZQLrZBHQlnryfCzZJRCBbov/2ahaQImaBx4wSb1YeZQRJCAsESFz6uokFxGYRUJWY9eQE
	E4jNK+Ah8XnJFnaIbQoScybZgIQ5BTwlJr/eDzZfCKjk7dI/TBCX7mKXaFnACjFGQOLb5EMs
	EK2yEpsOQD0jKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIExsHpf896
	dzDePmB9iDEZaNxEZinR5HxgHOWVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA+OeexImQZEM20qjVp/IjF1RuSFqVmh6YtLDyL3PLxYc855jcUnI
	ruTVxhseZ9dGlJ8vdbvUb7XwjciZdIPOgp2zdiR4xh94tuDmGXF32VfMMfIMNa//n9uoEyIq
	fFetv6hMnH3yla+VW+XOXZ7qYM5pvuG1Zf2tklmik5pDBQuXb1Zrky/Te6fEUpyRaKjFXFSc
	CABf3SMlmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd0evV3BBpP2G1ssm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsWiYxmjxc1n25kceDxa
	mnvYPDYvqffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoMOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBmfvv5mKdgpWXHl8g+mBsbZol2MHBwSAiYSs+bpdDFyApliEhfurWfrYuTiEBJYxCixet9+
	ZghnApPEh669bCBVbAK6Ek/ez2UGsUUEsiX6b69mASliFnjMKPFm5VFGkISwQIDEpa+bWEBs
	FgFViVlPTjCB2LwCHhKfl2xhh9isIDFnkg1ImFPAU2Ly6/1g84WASt4u/cM0gZF3ASPDKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgOHsmvYNxVYPFIUYBDkYlHt4Dq3YGC7EmlhVX5h5i
	lOBgVhLhPeMGFOJNSaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YArIK4k3NDYxNzU2tTSxMDGz
	VBLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAyLjv0aybIpmdvj5vd0kv0Ff78+JW8i2hjo7v
	9a5vN8vU+VzPPGHrdeyfunjUq3SnG7sMHy7ec0fjGWvJSu4tMknfr/648/nA+a8XHp3IlI/6
	4XFz9ZquRW3NQrI+CnnJv2ctnXLL8kP2NeHXH1/a+PfwrLzin3hvLu+Er3WruU5rPnn49/z3
	lk1KLMUZiYZazEXFiQCTUkidyQIAAA==
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
 arch/arm/mach-exynos/exynos-pmu.h |   24 ++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c         |    1 +
 arch/arm/mach-exynos/pmu.c        |   10 +++++++++-
 4 files changed, 34 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/mach-exynos/exynos-pmu.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9bf9198..38334bf 100644
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
index ff96fcd..ba75171 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -34,6 +34,7 @@
 #include <mach/map.h>
 
 #include "common.h"
+#include "exynos-pmu.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 2b16a2d..a4ede73 100644
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
@@ -31,6 +38,7 @@ struct exynos_pmu_context {
 	const struct exynos_pmu_data *pmu_data;
 };
 
+static void __iomem *pmu_base_addr;
 static struct exynos_pmu_context *pmu_context;
 
 static inline void pmu_raw_writel(u32 val, u32 offset)
-- 
1.7.9.5

