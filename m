Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaKXCMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:12:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaKXCMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:44 -0500
X-AuditID: cbfee68d-f79296d000004278-b5-5472941a2331
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 1/5] ARM: EXYNOS: Move pmu specific headers under
 "linux/soc/samsung"
Date: Mon, 24 Nov 2014 07:36:11 +0530
Message-id: <1416794775-1605-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
References: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWyRsSkVldqSlGIwbp3ChYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dkcfsyr8WirV/YHdg9Wpp72Dw2L6n36NuyitHj8ya5AJYoLpuU1JzM
	stQifbsErowbj5ezFzxXrfj8dBl7A+Md+S5GTg4JAROJeyv+s0PYYhIX7q1n62Lk4hASWMoo
	sf5iKztM0bfuDcwgtpDAdEaJhRtjIewJTBJbTiWB2GwCxhI/d+4HqufgEBHwllh+TRFkDrPA
	akaJPxe2MoHUCAtESVy/MYURxGYRUJVY2byfFcTmFXCT2PDmOitIr4SAgsScSTYgYU4Bd4nm
	o/MZIVa5Sez53sEEMlNCoJ9dYsHE5UwQcwQkvk0+xALRKyux6QAzxMmSEgdX3GCZwCi8gJFh
	FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgSJ/+96x3B+PtA9aHGAU4GJV4eD+0FoYIsSaW
	FVfmHmI0BdowkVlKNDkfGDl5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwyn7ltRVfIbLo48WfslO3ipilHptxlVEnnTXtWFH0y+Y5s17aezLzvX5+
	rtyz7nevRdmP2wIzA6dciTuceoOj/t7ulT2SYQKtzOkrly38veVy5vmq6eki9pKb+FYZyO6w
	d4vt53XLUjDWWZLX8fPTh1knbftjdUW3xe9enOzr5mc494KZcOB9JZbijERDLeai4kQAl8CU
	bWQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jQV2pKUUhBituiFs0XA2x6F1wlc1i
	0+NrrBaXd81hs5hxfh+Txe3LvBaLtn5hd2D3aGnuYfPYvKTeo2/LKkaPz5vkAliiGhhtMlIT
	U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D2KymUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzbjxezl7wXLXi89Nl7A2Md+S7GDk5JARM
	JL51b2CGsMUkLtxbzwZiCwlMZ5RYuDEWwp7AJLHlVBKIzSZgLPFz5372LkYODhEBb4nl1xS7
	GLk4mAVWM0r8ubCVCaRGWCBK4vqNKYwgNouAqsTK5v2sIDavgJvEhjfXWUF6JQQUJOZMsgEJ
	cwq4SzQfnc8IscpNYs/3DqYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRHzDOp
	HYwrGywOMQpwMCrx8Hp0FIYIsSaWFVfmHmKU4GBWEuE9+w8oxJuSWFmVWpQfX1Sak1p8iNEU
	6KiJzFKiyfnAaM4riTc0NjE3NTa1NLEwMbNUEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoHR
	6s1hH8be6k7LWZEqsjsuWHDucDZWW5DKl33WeYvEf0l+KVfOJJOoHbtPHHz92+j65Yu7zsS3
	fH5801dWmafJeW/O4ewrL08eebTPV/fiE/8dXurxJxoVVUsqN8lqf5sXbD71bKfZ25APNYGf
	7RdJrJi/edr5xtdXmDpzXsvfveV9U6aiyua7EktxRqKhFnNRcSIAD646zq4CAAA=
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
 arch/arm/mach-exynos/pmu.c                         |    6 ++----
 arch/arm/mach-exynos/suspend.c                     |    4 ++--
 .../linux/soc/samsung}/exynos-pmu.h                |    0
 .../linux/soc/samsung/exynos-regs-pmu.h            |    0
 8 files changed, 9 insertions(+), 11 deletions(-)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (100%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (100%)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index c13d083..18cec1a 100644
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
index b0d3c2e..c5e17b0 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -16,12 +16,12 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cputype.h>
 #include <asm/cp15.h>
 #include <asm/mcpm.h>
 
-#include "regs-pmu.h"
 #include "common.h"
 
 #define EXYNOS5420_CPUS_PER_CLUSTER	4
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 7a1ebfe..d6e7f49 100644
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
index e4c3512..2965c3b 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -16,10 +16,8 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-
-
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
+#include <linux/soc/samsung/exynos-regs-pmu.h>
+#include <linux/soc/samsung/exynos-pmu.h>
 
 #define PMU_TABLE_END	(-1U)
 
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f8e7dcd..80cf7ac 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -21,6 +21,8 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
 #include <linux/regulator/machine.h>
+#include <linux/soc/samsung/exynos-pmu.h>
+#include <linux/soc/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -33,9 +35,7 @@
 #include <plat/regs-srom.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
-#include "exynos-pmu.h"
 
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

