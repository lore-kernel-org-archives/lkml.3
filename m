Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaKHNYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:24:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41176 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKHNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:41 -0500
X-AuditID: cbfee68f-f791c6d000004834-d6-545e191f7ed6
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 1/6] ARM: EXYNOS: Move pmu specific header files under
 "linux/soc/samsung"
Date: Sat, 08 Nov 2014 18:46:36 +0530
Message-id: <1415452601-13078-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkWldeMi7EYM4jIYuGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PFoq1f2C0Ov2lndeDwuHNtD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJXRseojc8E61YqJ/3rZGxhXy3cxcnJICJhI3H+0lh3CFpO4cG89Wxcj
	F4eQwFJGia5z61lgiu58/sUKkZjOKHFvwmYWCGcCk8T6S//ZQKrYBIwlfu7cDzSKg0NEwFti
	+TVFkBpmgcOMEpOOPGYGqREWiJdYdq4DzGYRUJW4fO8rK4jNK+AusWz1FDaQXgkBBYk5k2xA
	wpwCHhIL9naDHSEEVLLp4T9GkJkSAtPZJX5u72eFmCMg8W3yIRaIXlmJTQeYIY6WlDi44gbL
	BEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECQ/z0v2f9OxjvHrA+xCjAwajEw3uj
	JTZEiDWxrLgy9xCjKdCGicxSosn5wEjKK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDY0NDlonqvtxku+xJy35V/xaLSG9dl3v35gY38WMlOrL+AYuK
	VKVnCngu/bZQN+dC90H3skAxk/wd7l/KnY7dN+p6OzPgG6OAnor1lTcOX77WyZwWu2kbojBx
	1sxwjedcqz5vdTyluUrA8qBBtOR9ttjcXJMV8h1K96ew7epKnd1R57GwvvSNEktxRqKhFnNR
	cSIA+zP10GwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQV15ybgQg5YWDouGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PFoq1f2C0Ov2lndeDwuHNtD5vH5iX1Hn1bVjF6fN4kF8AS
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo2PVR+aCdaoVE//1sjcwrpbv
	YuTkkBAwkbjz+RcrhC0mceHeerYuRi4OIYHpjBL3JmxmgXAmMEmsv/SfDaSKTcBY4ufO/exd
	jBwcIgLeEsuvKYLUMAscZpSYdOQxM0iNsEC8xLJzHWA2i4CqxOV7X8E28Aq4SyxbPYUNpFdC
	QEFiziQbkDCngIfEgr3dLCC2EFDJpof/GCcw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERxBz6R2MK5ssDjEKMDBqMTDe6MlNkSINbGsuDL3EKMEB7OSCG/veaAQb0piZVVqUX58
	UWlOavEhRlOgoyYyS4km5wOjO68k3tDYxNzU2NTSxMLEzFJJnPdAq3WgkEB6YklqdmpqQWoR
	TB8TB6dUA2OlmcXvx5m/7mqd0PoQVFjzd+u0twnOuSyNmbEviyavZlTdxSq243ikeuId+bw+
	iXy2Q2H6sQqLGWc576mcFe4mz1czLVhL5oJqVu/9eKeebefaSni8zQKevs8rd5zI8X2+pGr7
	3E3Zu/UmJk7p77BgXelUatCz846d5YZDpQc0pZb5Tg4yVmIpzkg01GIuKk4EALVrj6K2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving Exynos PMU specific header file into "include/linux/soc/samsung"
thus updated affected files under "mach-exynos" to use new location of
these header files.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    4 ++--
 arch/arm/mach-exynos/pmu.c                         |    5 ++---
 arch/arm/mach-exynos/suspend.c                     |    3 ++-
 .../linux/soc/samsung}/exynos-pmu.h                |    0
 .../linux/soc/samsung/exynos-regs-pmu.h            |    0
 8 files changed, 9 insertions(+), 9 deletions(-)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (100%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (100%)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a487e59..1be9e82 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/irqchip.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -29,7 +30,6 @@
 
 #include "common.h"
 #include "mfc.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 void __iomem *pmu_base_addr;
diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index dc9a764..f283bfd 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -15,12 +15,12 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cputype.h>
 #include <asm/cp15.h>
 #include <asm/mcpm.h>
 
-#include "regs-pmu.h"
 #include "common.h"
 
 #define EXYNOS5420_CPUS_PER_CLUSTER	4
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index adb36a8..a4c9d39 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -20,6 +20,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -30,7 +31,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 extern void exynos4_secondary_startup(void);
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 86f3ecd..1a981e0 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -18,6 +18,8 @@
 #include <linux/cpu_pm.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #include <asm/firmware.h>
 #include <asm/smp_scu.h>
@@ -26,8 +28,6 @@
 #include <plat/pm-common.h>
 
 #include "common.h"
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 static inline void __iomem *exynos_boot_vector_addr(void)
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 1993e08..35774e8 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -12,9 +12,8 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #define PMU_TABLE_END	(-1U)
 
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f5d9773..6dba9bf 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -20,6 +20,8 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -31,7 +33,6 @@
 #include <plat/regs-srom.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 #define S5P_CHECK_SLEEP 0x00000BAD
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/include/linux/soc/samsung/exynos-pmu.h
similarity index 100%
rename from arch/arm/mach-exynos/exynos-pmu.h
rename to include/linux/soc/samsung/exynos-pmu.h
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/include/linux/soc/samsung/exynos-regs-pmu.h
similarity index 100%
rename from arch/arm/mach-exynos/regs-pmu.h
rename to include/linux/soc/samsung/exynos-regs-pmu.h
-- 
1.7.9.5

