Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaKTFqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:46:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKTFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:46:49 -0500
X-AuditID: cbfee691-f79b86d000004a5a-5d-546d80474002
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        pankaj.dubey@samsung.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v3 1/5] ARM: EXYNOS: Move pmu specific header files under
 "linux/soc/samsung"
Date: Thu, 20 Nov 2014 11:09:24 +0530
Message-id: <1416461968-2057-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkTtejITfEYO8zRouGqyEWvQuuslls
	enyN1eLyrjlsFjPO72OyWLT1C7sDm8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFn
	4grGgleqFW8uL2VpYLwv38XIySEhYCKxqv0fO4QtJnHh3nq2LkYuDiGBpYwSr5+8Y4cpOvRr
	HztEYhGjxIkJ35hAEkICE5gkDnzLArHZBIwlfu7cD1TEwSEi4C2x/JoiSD2zQBOjxLl5l1lB
	aoQF4iU6/s9mAbFZBFQlNq/dAFbPK+AmcbfXEcSUEFCQmDPJBqSCU8Bd4vmnPYwQm9wkTq1Y
	zAQyUkKgmV1i58TnUGMEJL5NPsQC0SsrsekAM8TJkhIHV9xgmcAovICRYRWjaGpBckFxUnqR
	qV5xYm5xaV66XnJ+7iZGYACf/vds4g7G+wesDzEKcDAq8fAmWOSGCLEmlhVX5h5iNAXaMJFZ
	SjQ5HxgneSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MAowOO/OjuQ33qLks/l1ctskvn8VEjr92+/LyXbvTfaXP50zf73qrSUR/YGSqx6rff0b+VJw
	4USblKoAy8vVu46ZCemet+3veK0ffJGdr1NH/cayj5opj56wnapOTvqRXLjuFPfHy+VppnVG
	XnquMytjXAN6vLt/dwkpFReUnY6d9iVuh8d9JZbijERDLeai4kQAhIjjy1sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV33htwQg83rzCwaroZY9C64ymax
	6fE1VovLu+awWcw4v4/JYtHWL+wObB6bl9R79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhDWPGnYkrGAteqVa8ubyUpYHxvnwXIyeHhICJxKFf+9ghbDGJ
	C/fWs3UxcnEICSxilDgx4RsTSEJIYAKTxIFvWSA2m4CxxM+d+4EaODhEBLwlll9TBKlnFmhi
	lDg37zIrSI2wQLxEx//ZLCA2i4CqxOa1G8DqeQXcJO72OoKYEgIKEnMm2YBUcAq4Szz/tIcR
	YpObxKkVi5kmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcH8+kdzCuarA4xCjA
	wajEw5tgkRsixJpYVlyZe4hRgoNZSYT3UyVQiDclsbIqtSg/vqg0J7X4EKMp0E0TmaVEk/OB
	sZtXEm9obGJuamxqaWJhYmapJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoFxs82O5Jc/rjE/
	mDxfwuHVB/53lkt0Hrg/6p37Y4bd6mprptlyNtbR/LtEkoUrbi43eHT35PuAT72LMt67/unJ
	/Cl+9dJcyU8P3JWnrP5buDo35wjHJylhz78Oq3Wy7gqfNRW/+MG7bFnOp88OMz4mZrit0Vg7
	789HE7mzU/49Lug8vWutvGPYByWW4oxEQy3mouJEALXpY/KlAgAA
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
index 8f638ad..63d0450 100644
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
index 6c8a76d..aa43e04 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -13,10 +13,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
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

