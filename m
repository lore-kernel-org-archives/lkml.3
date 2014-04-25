Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaDYMsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:48:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12287 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaDYMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:48:08 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-55-535a5986ccfd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [RFC PATCH v2 2/3] ARM: EXYNOS: Move pmu specific header files under
 "linux/mfd/samsung"
Date: Fri, 25 Apr 2014 22:05:30 +0900
Message-id: <1398431131-5946-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zA922yKhgg9uPTS02zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXotFW7+wW5zuZrW4uOILk8X6Ga9ZLG4+
	285ksaNlNYsDn0dLcw+bx51re9g85p0M9Ni8pN6jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4
	MvYcOclScLuRqaJzZwtrA+OnO4xdjJwcEgImEtO3HGWDsMUkLtxbD2RzcQgJLGOUmLvzMTNM
	0aydk1ghEosYJTo2PYOqamOSuNq/jRWkik1AV+LJ+7lgHSIC2RJXGu8zgxQxCxxlkjja/hFs
	n7BAssTTM1PBilgEVCXunvgBFucVcJd4uPIfexcjB9A6BYk5k2xAwpwCHhK/mmYzQSxrZZT4
	+68LzJEQuMYusWbJXkaIQQIS3yYfYoFolpXYdADqbEmJgytusExgFF7AyLCKUTS1ILmgOCm9
	yFivODG3uDQvXS85P3cTIyRu+ncw3j1gfYgxGWjcRGYp0eR8YNzllcQbGpsZWZiamBobmVua
	kSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGvL1ih170s19onhatZ5T2y8OZ
	hfWOjuzLvnWddlFOSzTT9Xcylc+6p5ObKMvQWyodrBuTcKZN/vLiE/GNqkxuxX2Lol53bzZ7
	KmqfftQr+cAPZ7PLrT4xb+bsNZ+TWNo1e3lR3yOZz082z9nG+rKPpfGyzNGQnsTHT561O/Je
	ue+e0dS95IsSS3FGoqEWc1FxIgDrhRf9sQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd22yKhgg1t7tS02zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXotFW7+wW5zuZrW4uOILk8X6Ga9ZLG4+
	285ksaNlNYsDn0dLcw+bx51re9g85p0M9Ni8pN6jb8sqRo/Pm+QC2KIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5VUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWbsOXKSpeB2I1NF584W1gbGT3cYuxg5OSQETCRm7ZzE
	CmGLSVy4t56ti5GLQ0hgEaNEx6ZnUE4bk8TV/m1gVWwCuhJP3s9lBrFFBLIlrjTeZwYpYhY4
	yiRxtP0j2FhhgWSJp2emghWxCKhK3D3xAyzOK+Au8XDlP/YuRg6gdQoScybZgIQ5BTwkfjXN
	ZoJY1soo8fdfF9MERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj8pn0DsZVDRaH
	GAU4GJV4eCfIRgYLsSaWFVfmHmKU4GBWEuH94BcVLMSbklhZlVqUH19UmpNafIgxGeiqicxS
	osn5wISRVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M4skP
	q2Z+eRvW7arStPXh4f+OfdMzo65n/py5tXb13s3RWZU2S9nXpSoo/b6Uw7j2t4/DU65pJivN
	/06LW7dlc15t3AEh3sxnG9bPZfj29ervfU9t5jCx7D9kJZwbuMC6R9L5yxe+Hc8uy7D0cJj/
	fXe/wXvRnE/aFgJ9jle+Lo1Il/H2cf24XomlOCPRUIu5qDgRAO7R1jAOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving Exynos PMU specific header file into "include/linux/mfd/samsung"
thus updated affected files under "mach-exynos" to use new location of
these header files.

CC: Sangbeom Kim <sbkim73@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/cpuidle.c              |    4 +-
 arch/arm/mach-exynos/exynos-pmu.h           |   31 ---
 arch/arm/mach-exynos/exynos.c               |    2 +-
 arch/arm/mach-exynos/hotplug.c              |    2 +-
 arch/arm/mach-exynos/platsmp.c              |    2 +-
 arch/arm/mach-exynos/pm.c                   |    4 +-
 arch/arm/mach-exynos/pmu.c                  |    5 +-
 arch/arm/mach-exynos/regs-pmu.h             |  308 ---------------------------
 include/linux/mfd/samsung/exynos-pmu.h      |   31 +++
 include/linux/mfd/samsung/exynos-regs-pmu.h |  308 +++++++++++++++++++++++++++
 10 files changed, 348 insertions(+), 349 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/exynos-pmu.h
 delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
 create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
 create mode 100644 include/linux/mfd/samsung/exynos-regs-pmu.h

diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index ff3be9c..4c18087 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -18,6 +18,8 @@
 #include <linux/time.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
+#include <linux/mfd/samsung/exynos-pmu.h>
 
 #include <asm/proc-fns.h>
 #include <asm/smp_scu.h>
@@ -31,8 +33,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
-#include "exynos-pmu.h"
 
 #define REG_DIRECTGO_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/arch/arm/mach-exynos/exynos-pmu.h
deleted file mode 100644
index 1cc857b..0000000
--- a/arch/arm/mach-exynos/exynos-pmu.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Copyright (c) 2014 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Header for EXYNOS PMU Driver support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __EXYNOS_PMU_H
-#define __EXYNOS_PMU_H
-
-#define PMU_TABLE_END	0xFFFF
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
-
-#endif /* __EXYNOS_PMU_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b01987e..24c774a 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -21,6 +21,7 @@
 #include <linux/pm_domain.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -32,7 +33,6 @@
 
 #include "common.h"
 #include "mfc.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 #define L2_AUX_VAL 0x7C470001
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 7831e64..1d3ad84 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/regmap.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -22,7 +23,6 @@
 #include <plat/cpu.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 static inline void cpu_enter_lowpower_a9(void)
 {
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 3831e6c..54c0df8 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -19,6 +19,7 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
@@ -29,7 +30,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 extern void exynos4_secondary_startup(void);
 static void __iomem *pmu_base;
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 103ab92..3e75565 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -21,6 +21,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/regmap.h>
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
+#include <linux/mfd/samsung/exynos-pmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -35,9 +37,7 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
-#include "exynos-pmu.h"
 
 static struct regmap *pmu_regmap;
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index d020557..a26332f 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -15,9 +15,8 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/mfd/syscon.h>
-
-#include "exynos-pmu.h"
-#include "regs-pmu.h"
+#include <linux/mfd/samsung/exynos-regs-pmu.h>
+#include <linux/mfd/samsung/exynos-pmu.h>
 
 enum exynos_pmu_id {
 	PMU_EXYNOS4210,
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
deleted file mode 100644
index bb57b62..0000000
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ /dev/null
@@ -1,308 +0,0 @@
-/*
- * Copyright (c) 2010-2012 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS - Power management unit definition
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_REGS_PMU_H
-#define __ASM_ARCH_REGS_PMU_H __FILE__
-
-#define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
-
-#define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
-
-#define S5P_CENTRAL_SEQ_OPTION			0x0208
-
-#define S5P_USE_STANDBY_WFI0			(1 << 16)
-#define S5P_USE_STANDBY_WFE0			(1 << 24)
-
-#define EXYNOS_SWRESET				0x0400
-#define EXYNOS5440_SWRESET			0x00C4
-
-#define S5P_WAKEUP_STAT				0x0600
-#define S5P_EINT_WAKEUP_MASK			0x0604
-#define S5P_WAKEUP_MASK				0x0608
-
-#define S5P_INFORM0				0x0800
-#define S5P_INFORM1				0x0804
-#define S5P_INFORM5				0x0814
-#define S5P_INFORM6				0x0818
-#define S5P_INFORM7				0x081C
-
-#define S5P_ARM_CORE0_LOWPWR			0x1000
-#define S5P_DIS_IRQ_CORE0			0x1004
-#define S5P_DIS_IRQ_CENTRAL0			0x1008
-#define S5P_ARM_CORE1_LOWPWR			0x1010
-#define S5P_DIS_IRQ_CORE1			0x1014
-#define S5P_DIS_IRQ_CENTRAL1			0x1018
-#define S5P_ARM_COMMON_LOWPWR			0x1080
-#define S5P_L2_0_LOWPWR				0x10C0
-#define S5P_L2_1_LOWPWR				0x10C4
-#define S5P_CMU_ACLKSTOP_LOWPWR			0x1100
-#define S5P_CMU_SCLKSTOP_LOWPWR			0x1104
-#define S5P_CMU_RESET_LOWPWR			0x110C
-#define S5P_APLL_SYSCLK_LOWPWR			0x1120
-#define S5P_MPLL_SYSCLK_LOWPWR			0x1124
-#define S5P_VPLL_SYSCLK_LOWPWR			0x1128
-#define S5P_EPLL_SYSCLK_LOWPWR			0x112C
-#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	0x1138
-#define S5P_CMU_RESET_GPSALIVE_LOWPWR		0x113C
-#define S5P_CMU_CLKSTOP_CAM_LOWPWR		0x1140
-#define S5P_CMU_CLKSTOP_TV_LOWPWR		0x1144
-#define S5P_CMU_CLKSTOP_MFC_LOWPWR		0x1148
-#define S5P_CMU_CLKSTOP_G3D_LOWPWR		0x114C
-#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		0x1150
-#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		0x1158
-#define S5P_CMU_CLKSTOP_GPS_LOWPWR		0x115C
-#define S5P_CMU_RESET_CAM_LOWPWR		0x1160
-#define S5P_CMU_RESET_TV_LOWPWR			0x1164
-#define S5P_CMU_RESET_MFC_LOWPWR		0x1168
-#define S5P_CMU_RESET_G3D_LOWPWR		0x116C
-#define S5P_CMU_RESET_LCD0_LOWPWR		0x1170
-#define S5P_CMU_RESET_MAUDIO_LOWPWR		0x1178
-#define S5P_CMU_RESET_GPS_LOWPWR		0x117C
-#define S5P_TOP_BUS_LOWPWR			0x1180
-#define S5P_TOP_RETENTION_LOWPWR		0x1184
-#define S5P_TOP_PWR_LOWPWR			0x1188
-#define S5P_LOGIC_RESET_LOWPWR			0x11A0
-#define S5P_ONENAND_MEM_LOWPWR			0x11C0
-#define S5P_G2D_ACP_MEM_LOWPWR			0x11C8
-#define S5P_USBOTG_MEM_LOWPWR			0x11CC
-#define S5P_HSMMC_MEM_LOWPWR			0x11D0
-#define S5P_CSSYS_MEM_LOWPWR			0x11D4
-#define S5P_SECSS_MEM_LOWPWR			0x11D8
-#define S5P_PAD_RETENTION_DRAM_LOWPWR		0x1200
-#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		0x1204
-#define S5P_PAD_RETENTION_GPIO_LOWPWR		0x1220
-#define S5P_PAD_RETENTION_UART_LOWPWR		0x1224
-#define S5P_PAD_RETENTION_MMCA_LOWPWR		0x1228
-#define S5P_PAD_RETENTION_MMCB_LOWPWR		0x122C
-#define S5P_PAD_RETENTION_EBIA_LOWPWR		0x1230
-#define S5P_PAD_RETENTION_EBIB_LOWPWR		0x1234
-#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	0x1240
-#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	0x1260
-#define S5P_XUSBXTI_LOWPWR			0x1280
-#define S5P_XXTI_LOWPWR				0x1284
-#define S5P_EXT_REGULATOR_LOWPWR		0x12C0
-#define S5P_GPIO_MODE_LOWPWR			0x1300
-#define S5P_GPIO_MODE_MAUDIO_LOWPWR		0x1340
-#define S5P_CAM_LOWPWR				0x1380
-#define S5P_TV_LOWPWR				0x1384
-#define S5P_MFC_LOWPWR				0x1388
-#define S5P_G3D_LOWPWR				0x138C
-#define S5P_LCD0_LOWPWR				0x1390
-#define S5P_MAUDIO_LOWPWR			0x1398
-#define S5P_GPS_LOWPWR				0x139C
-#define S5P_GPS_ALIVE_LOWPWR			0x13A0
-
-#define S5P_ARM_CORE1_CONFIGURATION		0x2080
-#define S5P_ARM_CORE1_STATUS			0x2084
-
-#define S5P_PAD_RET_MAUDIO_OPTION		0x3028
-#define S5P_PAD_RET_GPIO_OPTION			0x3108
-#define S5P_PAD_RET_UART_OPTION			0x3128
-#define S5P_PAD_RET_MMCA_OPTION			0x3148
-#define S5P_PAD_RET_MMCB_OPTION			0x3168
-#define S5P_PAD_RET_EBIA_OPTION			0x3188
-#define S5P_PAD_RET_EBIB_OPTION			0x31A8
-
-#define S5P_CORE_LOCAL_PWR_EN			0x3
-
-#define S5P_CHECK_SLEEP				0x00000BAD
-
-/* Only for EXYNOS4210 */
-#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
-#define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
-#define S5P_MODIMIF_MEM_LOWPWR		0x11C4
-#define S5P_PCIE_MEM_LOWPWR		0x11E0
-#define S5P_SATA_MEM_LOWPWR		0x11E4
-#define S5P_LCD1_LOWPWR			0x1394
-
-/* Only for EXYNOS4x12 */
-#define S5P_ISP_ARM_LOWPWR			0x1050
-#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	0x1054
-#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	0x1058
-#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		0x1110
-#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		0x1114
-#define S5P_CMU_RESET_COREBLK_LOWPWR		0x111C
-#define S5P_MPLLUSER_SYSCLK_LOWPWR		0x1130
-#define S5P_CMU_CLKSTOP_ISP_LOWPWR		0x1154
-#define S5P_CMU_RESET_ISP_LOWPWR		0x1174
-#define S5P_TOP_BUS_COREBLK_LOWPWR		0x1190
-#define S5P_TOP_RETENTION_COREBLK_LOWPWR	0x1194
-#define S5P_TOP_PWR_COREBLK_LOWPWR		0x1198
-#define S5P_OSCCLK_GATE_LOWPWR			0x11A4
-#define S5P_LOGIC_RESET_COREBLK_LOWPWR		0x11B0
-#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		0x11B4
-#define S5P_HSI_MEM_LOWPWR			0x11C4
-#define S5P_ROTATOR_MEM_LOWPWR			0x11DC
-#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	0x123C
-#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	0x1250
-#define S5P_GPIO_MODE_COREBLK_LOWPWR		0x1320
-#define S5P_TOP_ASB_RESET_LOWPWR		0x1344
-#define S5P_TOP_ASB_ISOLATION_LOWPWR		0x1348
-#define S5P_ISP_LOWPWR				0x1394
-#define S5P_DRAM_FREQ_DOWN_LOWPWR		0x13B0
-#define S5P_DDRPHY_DLLOFF_LOWPWR		0x13B4
-#define S5P_CMU_SYSCLK_ISP_LOWPWR		0x13B8
-#define S5P_CMU_SYSCLK_GPS_LOWPWR		0x13BC
-#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		0x13C0
-
-#define S5P_ARM_L2_0_OPTION			0x2608
-#define S5P_ARM_L2_1_OPTION			0x2628
-#define S5P_ONENAND_MEM_OPTION			0x2E08
-#define S5P_HSI_MEM_OPTION			0x2E28
-#define S5P_G2D_ACP_MEM_OPTION			0x2E48
-#define S5P_USBOTG_MEM_OPTION			0x2E68
-#define S5P_HSMMC_MEM_OPTION			0x2E88
-#define S5P_CSSYS_MEM_OPTION			0x2EA8
-#define S5P_SECSS_MEM_OPTION			0x2EC8
-#define S5P_ROTATOR_MEM_OPTION			0x2F48
-
-/* Only for EXYNOS4412 */
-#define S5P_ARM_CORE2_LOWPWR			0x1020
-#define S5P_DIS_IRQ_CORE2			0x1024
-#define S5P_DIS_IRQ_CENTRAL2			0x1028
-#define S5P_ARM_CORE3_LOWPWR			0x1030
-#define S5P_DIS_IRQ_CORE3			0x1034
-#define S5P_DIS_IRQ_CENTRAL3			0x1038
-
-/* For EXYNOS5 */
-
-#define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
-#define EXYNOS5_MASK_WDTRESET_REQUEST				0x040C
-
-#define EXYNOS5_SYS_WDTRESET					(1 << 20)
-
-#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				0x1000
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		0x1004
-#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		0x1008
-#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				0x1010
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		0x1014
-#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		0x1018
-#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				0x1040
-#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		0x1048
-#define EXYNOS5_ISP_ARM_SYS_PWR_REG				0x1050
-#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		0x1054
-#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		0x1058
-#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				0x1080
-#define EXYNOS5_ARM_L2_SYS_PWR_REG				0x10C0
-#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			0x1100
-#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			0x1104
-#define EXYNOS5_CMU_RESET_SYS_PWR_REG				0x110C
-#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			0x1120
-#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			0x1124
-#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			0x112C
-#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			0x1130
-#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			0x1134
-#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			0x1138
-#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				0x1140
-#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				0x1144
-#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				0x1148
-#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				0x114C
-#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				0x1150
-#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				0x1154
-#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			0x1164
-#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			0x1170
-#define EXYNOS5_TOP_BUS_SYS_PWR_REG				0x1180
-#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			0x1184
-#define EXYNOS5_TOP_PWR_SYS_PWR_REG				0x1188
-#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			0x1190
-#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		0x1194
-#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			0x1198
-#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				0x11A0
-#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				0x11A4
-#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			0x11B0
-#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			0x11B4
-#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				0x11C0
-#define EXYNOS5_G2D_MEM_SYS_PWR_REG				0x11C8
-#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				0x11CC
-#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				0x11D0
-#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				0x11D4
-#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				0x11D8
-#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				0x11DC
-#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				0x11E0
-#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				0x11E4
-#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				0x11E8
-#define EXYNOS5_HSI_MEM_SYS_PWR_REG				0x11EC
-#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				0x11F4
-#define EXYNOS5_SATA_MEM_SYS_PWR_REG				0x11FC
-#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			0x1200
-#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			0x1204
-#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		0x1208
-#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			0x1220
-#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			0x1224
-#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			0x1228
-#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			0x122C
-#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			0x1230
-#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			0x1234
-#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			0x1238
-#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		0x123C
-#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			0x1240
-#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		0x1250
-#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				0x1260
-#define EXYNOS5_XUSBXTI_SYS_PWR_REG				0x1280
-#define EXYNOS5_XXTI_SYS_PWR_REG				0x1284
-#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			0x12C0
-#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				0x1300
-#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			0x1320
-#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			0x1340
-#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			0x1344
-#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			0x1348
-#define EXYNOS5_GSCL_SYS_PWR_REG				0x1400
-#define EXYNOS5_ISP_SYS_PWR_REG					0x1404
-#define EXYNOS5_MFC_SYS_PWR_REG					0x1408
-#define EXYNOS5_G3D_SYS_PWR_REG					0x140C
-#define EXYNOS5_DISP1_SYS_PWR_REG				0x1414
-#define EXYNOS5_MAU_SYS_PWR_REG					0x1418
-#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			0x1480
-#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			0x1484
-#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			0x1488
-#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			0x148C
-#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			0x1494
-#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			0x1498
-#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			0x14C0
-#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			0x14C4
-#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			0x14C8
-#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			0x14CC
-#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			0x14D4
-#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			0x14D8
-#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			0x1580
-#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			0x1584
-#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			0x1588
-#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			0x158C
-#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			0x1594
-#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			0x1598
-
-#define EXYNOS5_ARM_CORE0_OPTION				0x2008
-#define EXYNOS5_ARM_CORE1_OPTION				0x2088
-#define EXYNOS5_FSYS_ARM_OPTION					0x2208
-#define EXYNOS5_ISP_ARM_OPTION					0x2288
-#define EXYNOS5_ARM_COMMON_OPTION				0x2408
-#define EXYNOS5_ARM_L2_OPTION					0x2608
-#define EXYNOS5_TOP_PWR_OPTION					0x2C48
-#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				0x2CC8
-#define EXYNOS5_JPEG_MEM_OPTION					0x2F48
-#define EXYNOS5_GSCL_OPTION					0x4008
-#define EXYNOS5_ISP_OPTION					0x4028
-#define EXYNOS5_MFC_OPTION					0x4048
-#define EXYNOS5_G3D_OPTION					0x4068
-#define EXYNOS5_DISP1_OPTION					0x40A8
-#define EXYNOS5_MAU_OPTION					0x40C8
-
-#define EXYNOS5_USE_SC_FEEDBACK					(1 << 1)
-#define EXYNOS5_USE_SC_COUNTER					(1 << 0)
-
-#define EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN			(1 << 7)
-
-#define EXYNOS5_OPTION_USE_STANDBYWFE				(1 << 24)
-#define EXYNOS5_OPTION_USE_STANDBYWFI				(1 << 16)
-
-#define EXYNOS5_OPTION_USE_RETENTION				(1 << 4)
-
-#endif /* __ASM_ARCH_REGS_PMU_H */
diff --git a/include/linux/mfd/samsung/exynos-pmu.h b/include/linux/mfd/samsung/exynos-pmu.h
new file mode 100644
index 0000000..1cc857b
--- /dev/null
+++ b/include/linux/mfd/samsung/exynos-pmu.h
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
+#define PMU_TABLE_END	0xFFFF
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
diff --git a/include/linux/mfd/samsung/exynos-regs-pmu.h b/include/linux/mfd/samsung/exynos-regs-pmu.h
new file mode 100644
index 0000000..bb57b62
--- /dev/null
+++ b/include/linux/mfd/samsung/exynos-regs-pmu.h
@@ -0,0 +1,308 @@
+/*
+ * Copyright (c) 2010-2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS - Power management unit definition
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM_ARCH_REGS_PMU_H
+#define __ASM_ARCH_REGS_PMU_H __FILE__
+
+#define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
+
+#define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
+
+#define S5P_CENTRAL_SEQ_OPTION			0x0208
+
+#define S5P_USE_STANDBY_WFI0			(1 << 16)
+#define S5P_USE_STANDBY_WFE0			(1 << 24)
+
+#define EXYNOS_SWRESET				0x0400
+#define EXYNOS5440_SWRESET			0x00C4
+
+#define S5P_WAKEUP_STAT				0x0600
+#define S5P_EINT_WAKEUP_MASK			0x0604
+#define S5P_WAKEUP_MASK				0x0608
+
+#define S5P_INFORM0				0x0800
+#define S5P_INFORM1				0x0804
+#define S5P_INFORM5				0x0814
+#define S5P_INFORM6				0x0818
+#define S5P_INFORM7				0x081C
+
+#define S5P_ARM_CORE0_LOWPWR			0x1000
+#define S5P_DIS_IRQ_CORE0			0x1004
+#define S5P_DIS_IRQ_CENTRAL0			0x1008
+#define S5P_ARM_CORE1_LOWPWR			0x1010
+#define S5P_DIS_IRQ_CORE1			0x1014
+#define S5P_DIS_IRQ_CENTRAL1			0x1018
+#define S5P_ARM_COMMON_LOWPWR			0x1080
+#define S5P_L2_0_LOWPWR				0x10C0
+#define S5P_L2_1_LOWPWR				0x10C4
+#define S5P_CMU_ACLKSTOP_LOWPWR			0x1100
+#define S5P_CMU_SCLKSTOP_LOWPWR			0x1104
+#define S5P_CMU_RESET_LOWPWR			0x110C
+#define S5P_APLL_SYSCLK_LOWPWR			0x1120
+#define S5P_MPLL_SYSCLK_LOWPWR			0x1124
+#define S5P_VPLL_SYSCLK_LOWPWR			0x1128
+#define S5P_EPLL_SYSCLK_LOWPWR			0x112C
+#define S5P_CMU_CLKSTOP_GPS_ALIVE_LOWPWR	0x1138
+#define S5P_CMU_RESET_GPSALIVE_LOWPWR		0x113C
+#define S5P_CMU_CLKSTOP_CAM_LOWPWR		0x1140
+#define S5P_CMU_CLKSTOP_TV_LOWPWR		0x1144
+#define S5P_CMU_CLKSTOP_MFC_LOWPWR		0x1148
+#define S5P_CMU_CLKSTOP_G3D_LOWPWR		0x114C
+#define S5P_CMU_CLKSTOP_LCD0_LOWPWR		0x1150
+#define S5P_CMU_CLKSTOP_MAUDIO_LOWPWR		0x1158
+#define S5P_CMU_CLKSTOP_GPS_LOWPWR		0x115C
+#define S5P_CMU_RESET_CAM_LOWPWR		0x1160
+#define S5P_CMU_RESET_TV_LOWPWR			0x1164
+#define S5P_CMU_RESET_MFC_LOWPWR		0x1168
+#define S5P_CMU_RESET_G3D_LOWPWR		0x116C
+#define S5P_CMU_RESET_LCD0_LOWPWR		0x1170
+#define S5P_CMU_RESET_MAUDIO_LOWPWR		0x1178
+#define S5P_CMU_RESET_GPS_LOWPWR		0x117C
+#define S5P_TOP_BUS_LOWPWR			0x1180
+#define S5P_TOP_RETENTION_LOWPWR		0x1184
+#define S5P_TOP_PWR_LOWPWR			0x1188
+#define S5P_LOGIC_RESET_LOWPWR			0x11A0
+#define S5P_ONENAND_MEM_LOWPWR			0x11C0
+#define S5P_G2D_ACP_MEM_LOWPWR			0x11C8
+#define S5P_USBOTG_MEM_LOWPWR			0x11CC
+#define S5P_HSMMC_MEM_LOWPWR			0x11D0
+#define S5P_CSSYS_MEM_LOWPWR			0x11D4
+#define S5P_SECSS_MEM_LOWPWR			0x11D8
+#define S5P_PAD_RETENTION_DRAM_LOWPWR		0x1200
+#define S5P_PAD_RETENTION_MAUDIO_LOWPWR		0x1204
+#define S5P_PAD_RETENTION_GPIO_LOWPWR		0x1220
+#define S5P_PAD_RETENTION_UART_LOWPWR		0x1224
+#define S5P_PAD_RETENTION_MMCA_LOWPWR		0x1228
+#define S5P_PAD_RETENTION_MMCB_LOWPWR		0x122C
+#define S5P_PAD_RETENTION_EBIA_LOWPWR		0x1230
+#define S5P_PAD_RETENTION_EBIB_LOWPWR		0x1234
+#define S5P_PAD_RETENTION_ISOLATION_LOWPWR	0x1240
+#define S5P_PAD_RETENTION_ALV_SEL_LOWPWR	0x1260
+#define S5P_XUSBXTI_LOWPWR			0x1280
+#define S5P_XXTI_LOWPWR				0x1284
+#define S5P_EXT_REGULATOR_LOWPWR		0x12C0
+#define S5P_GPIO_MODE_LOWPWR			0x1300
+#define S5P_GPIO_MODE_MAUDIO_LOWPWR		0x1340
+#define S5P_CAM_LOWPWR				0x1380
+#define S5P_TV_LOWPWR				0x1384
+#define S5P_MFC_LOWPWR				0x1388
+#define S5P_G3D_LOWPWR				0x138C
+#define S5P_LCD0_LOWPWR				0x1390
+#define S5P_MAUDIO_LOWPWR			0x1398
+#define S5P_GPS_LOWPWR				0x139C
+#define S5P_GPS_ALIVE_LOWPWR			0x13A0
+
+#define S5P_ARM_CORE1_CONFIGURATION		0x2080
+#define S5P_ARM_CORE1_STATUS			0x2084
+
+#define S5P_PAD_RET_MAUDIO_OPTION		0x3028
+#define S5P_PAD_RET_GPIO_OPTION			0x3108
+#define S5P_PAD_RET_UART_OPTION			0x3128
+#define S5P_PAD_RET_MMCA_OPTION			0x3148
+#define S5P_PAD_RET_MMCB_OPTION			0x3168
+#define S5P_PAD_RET_EBIA_OPTION			0x3188
+#define S5P_PAD_RET_EBIB_OPTION			0x31A8
+
+#define S5P_CORE_LOCAL_PWR_EN			0x3
+
+#define S5P_CHECK_SLEEP				0x00000BAD
+
+/* Only for EXYNOS4210 */
+#define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
+#define S5P_CMU_RESET_LCD1_LOWPWR	0x1174
+#define S5P_MODIMIF_MEM_LOWPWR		0x11C4
+#define S5P_PCIE_MEM_LOWPWR		0x11E0
+#define S5P_SATA_MEM_LOWPWR		0x11E4
+#define S5P_LCD1_LOWPWR			0x1394
+
+/* Only for EXYNOS4x12 */
+#define S5P_ISP_ARM_LOWPWR			0x1050
+#define S5P_DIS_IRQ_ISP_ARM_LOCAL_LOWPWR	0x1054
+#define S5P_DIS_IRQ_ISP_ARM_CENTRAL_LOWPWR	0x1058
+#define S5P_CMU_ACLKSTOP_COREBLK_LOWPWR		0x1110
+#define S5P_CMU_SCLKSTOP_COREBLK_LOWPWR		0x1114
+#define S5P_CMU_RESET_COREBLK_LOWPWR		0x111C
+#define S5P_MPLLUSER_SYSCLK_LOWPWR		0x1130
+#define S5P_CMU_CLKSTOP_ISP_LOWPWR		0x1154
+#define S5P_CMU_RESET_ISP_LOWPWR		0x1174
+#define S5P_TOP_BUS_COREBLK_LOWPWR		0x1190
+#define S5P_TOP_RETENTION_COREBLK_LOWPWR	0x1194
+#define S5P_TOP_PWR_COREBLK_LOWPWR		0x1198
+#define S5P_OSCCLK_GATE_LOWPWR			0x11A4
+#define S5P_LOGIC_RESET_COREBLK_LOWPWR		0x11B0
+#define S5P_OSCCLK_GATE_COREBLK_LOWPWR		0x11B4
+#define S5P_HSI_MEM_LOWPWR			0x11C4
+#define S5P_ROTATOR_MEM_LOWPWR			0x11DC
+#define S5P_PAD_RETENTION_GPIO_COREBLK_LOWPWR	0x123C
+#define S5P_PAD_ISOLATION_COREBLK_LOWPWR	0x1250
+#define S5P_GPIO_MODE_COREBLK_LOWPWR		0x1320
+#define S5P_TOP_ASB_RESET_LOWPWR		0x1344
+#define S5P_TOP_ASB_ISOLATION_LOWPWR		0x1348
+#define S5P_ISP_LOWPWR				0x1394
+#define S5P_DRAM_FREQ_DOWN_LOWPWR		0x13B0
+#define S5P_DDRPHY_DLLOFF_LOWPWR		0x13B4
+#define S5P_CMU_SYSCLK_ISP_LOWPWR		0x13B8
+#define S5P_CMU_SYSCLK_GPS_LOWPWR		0x13BC
+#define S5P_LPDDR_PHY_DLL_LOCK_LOWPWR		0x13C0
+
+#define S5P_ARM_L2_0_OPTION			0x2608
+#define S5P_ARM_L2_1_OPTION			0x2628
+#define S5P_ONENAND_MEM_OPTION			0x2E08
+#define S5P_HSI_MEM_OPTION			0x2E28
+#define S5P_G2D_ACP_MEM_OPTION			0x2E48
+#define S5P_USBOTG_MEM_OPTION			0x2E68
+#define S5P_HSMMC_MEM_OPTION			0x2E88
+#define S5P_CSSYS_MEM_OPTION			0x2EA8
+#define S5P_SECSS_MEM_OPTION			0x2EC8
+#define S5P_ROTATOR_MEM_OPTION			0x2F48
+
+/* Only for EXYNOS4412 */
+#define S5P_ARM_CORE2_LOWPWR			0x1020
+#define S5P_DIS_IRQ_CORE2			0x1024
+#define S5P_DIS_IRQ_CENTRAL2			0x1028
+#define S5P_ARM_CORE3_LOWPWR			0x1030
+#define S5P_DIS_IRQ_CORE3			0x1034
+#define S5P_DIS_IRQ_CENTRAL3			0x1038
+
+/* For EXYNOS5 */
+
+#define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
+#define EXYNOS5_MASK_WDTRESET_REQUEST				0x040C
+
+#define EXYNOS5_SYS_WDTRESET					(1 << 20)
+
+#define EXYNOS5_ARM_CORE0_SYS_PWR_REG				0x1000
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG		0x1004
+#define EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG		0x1008
+#define EXYNOS5_ARM_CORE1_SYS_PWR_REG				0x1010
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG		0x1014
+#define EXYNOS5_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG		0x1018
+#define EXYNOS5_FSYS_ARM_SYS_PWR_REG				0x1040
+#define EXYNOS5_DIS_IRQ_FSYS_ARM_CENTRAL_SYS_PWR_REG		0x1048
+#define EXYNOS5_ISP_ARM_SYS_PWR_REG				0x1050
+#define EXYNOS5_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG		0x1054
+#define EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG		0x1058
+#define EXYNOS5_ARM_COMMON_SYS_PWR_REG				0x1080
+#define EXYNOS5_ARM_L2_SYS_PWR_REG				0x10C0
+#define EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG			0x1100
+#define EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG			0x1104
+#define EXYNOS5_CMU_RESET_SYS_PWR_REG				0x110C
+#define EXYNOS5_CMU_ACLKSTOP_SYSMEM_SYS_PWR_REG			0x1120
+#define EXYNOS5_CMU_SCLKSTOP_SYSMEM_SYS_PWR_REG			0x1124
+#define EXYNOS5_CMU_RESET_SYSMEM_SYS_PWR_REG			0x112C
+#define EXYNOS5_DRAM_FREQ_DOWN_SYS_PWR_REG			0x1130
+#define EXYNOS5_DDRPHY_DLLOFF_SYS_PWR_REG			0x1134
+#define EXYNOS5_DDRPHY_DLLLOCK_SYS_PWR_REG			0x1138
+#define EXYNOS5_APLL_SYSCLK_SYS_PWR_REG				0x1140
+#define EXYNOS5_MPLL_SYSCLK_SYS_PWR_REG				0x1144
+#define EXYNOS5_VPLL_SYSCLK_SYS_PWR_REG				0x1148
+#define EXYNOS5_EPLL_SYSCLK_SYS_PWR_REG				0x114C
+#define EXYNOS5_BPLL_SYSCLK_SYS_PWR_REG				0x1150
+#define EXYNOS5_CPLL_SYSCLK_SYS_PWR_REG				0x1154
+#define EXYNOS5_MPLLUSER_SYSCLK_SYS_PWR_REG			0x1164
+#define EXYNOS5_BPLLUSER_SYSCLK_SYS_PWR_REG			0x1170
+#define EXYNOS5_TOP_BUS_SYS_PWR_REG				0x1180
+#define EXYNOS5_TOP_RETENTION_SYS_PWR_REG			0x1184
+#define EXYNOS5_TOP_PWR_SYS_PWR_REG				0x1188
+#define EXYNOS5_TOP_BUS_SYSMEM_SYS_PWR_REG			0x1190
+#define EXYNOS5_TOP_RETENTION_SYSMEM_SYS_PWR_REG		0x1194
+#define EXYNOS5_TOP_PWR_SYSMEM_SYS_PWR_REG			0x1198
+#define EXYNOS5_LOGIC_RESET_SYS_PWR_REG				0x11A0
+#define EXYNOS5_OSCCLK_GATE_SYS_PWR_REG				0x11A4
+#define EXYNOS5_LOGIC_RESET_SYSMEM_SYS_PWR_REG			0x11B0
+#define EXYNOS5_OSCCLK_GATE_SYSMEM_SYS_PWR_REG			0x11B4
+#define EXYNOS5_USBOTG_MEM_SYS_PWR_REG				0x11C0
+#define EXYNOS5_G2D_MEM_SYS_PWR_REG				0x11C8
+#define EXYNOS5_USBDRD_MEM_SYS_PWR_REG				0x11CC
+#define EXYNOS5_SDMMC_MEM_SYS_PWR_REG				0x11D0
+#define EXYNOS5_CSSYS_MEM_SYS_PWR_REG				0x11D4
+#define EXYNOS5_SECSS_MEM_SYS_PWR_REG				0x11D8
+#define EXYNOS5_ROTATOR_MEM_SYS_PWR_REG				0x11DC
+#define EXYNOS5_INTRAM_MEM_SYS_PWR_REG				0x11E0
+#define EXYNOS5_INTROM_MEM_SYS_PWR_REG				0x11E4
+#define EXYNOS5_JPEG_MEM_SYS_PWR_REG				0x11E8
+#define EXYNOS5_HSI_MEM_SYS_PWR_REG				0x11EC
+#define EXYNOS5_MCUIOP_MEM_SYS_PWR_REG				0x11F4
+#define EXYNOS5_SATA_MEM_SYS_PWR_REG				0x11FC
+#define EXYNOS5_PAD_RETENTION_DRAM_SYS_PWR_REG			0x1200
+#define EXYNOS5_PAD_RETENTION_MAU_SYS_PWR_REG			0x1204
+#define EXYNOS5_PAD_RETENTION_EFNAND_SYS_PWR_REG		0x1208
+#define EXYNOS5_PAD_RETENTION_GPIO_SYS_PWR_REG			0x1220
+#define EXYNOS5_PAD_RETENTION_UART_SYS_PWR_REG			0x1224
+#define EXYNOS5_PAD_RETENTION_MMCA_SYS_PWR_REG			0x1228
+#define EXYNOS5_PAD_RETENTION_MMCB_SYS_PWR_REG			0x122C
+#define EXYNOS5_PAD_RETENTION_EBIA_SYS_PWR_REG			0x1230
+#define EXYNOS5_PAD_RETENTION_EBIB_SYS_PWR_REG			0x1234
+#define EXYNOS5_PAD_RETENTION_SPI_SYS_PWR_REG			0x1238
+#define EXYNOS5_PAD_RETENTION_GPIO_SYSMEM_SYS_PWR_REG		0x123C
+#define EXYNOS5_PAD_ISOLATION_SYS_PWR_REG			0x1240
+#define EXYNOS5_PAD_ISOLATION_SYSMEM_SYS_PWR_REG		0x1250
+#define EXYNOS5_PAD_ALV_SEL_SYS_PWR_REG				0x1260
+#define EXYNOS5_XUSBXTI_SYS_PWR_REG				0x1280
+#define EXYNOS5_XXTI_SYS_PWR_REG				0x1284
+#define EXYNOS5_EXT_REGULATOR_SYS_PWR_REG			0x12C0
+#define EXYNOS5_GPIO_MODE_SYS_PWR_REG				0x1300
+#define EXYNOS5_GPIO_MODE_SYSMEM_SYS_PWR_REG			0x1320
+#define EXYNOS5_GPIO_MODE_MAU_SYS_PWR_REG			0x1340
+#define EXYNOS5_TOP_ASB_RESET_SYS_PWR_REG			0x1344
+#define EXYNOS5_TOP_ASB_ISOLATION_SYS_PWR_REG			0x1348
+#define EXYNOS5_GSCL_SYS_PWR_REG				0x1400
+#define EXYNOS5_ISP_SYS_PWR_REG					0x1404
+#define EXYNOS5_MFC_SYS_PWR_REG					0x1408
+#define EXYNOS5_G3D_SYS_PWR_REG					0x140C
+#define EXYNOS5_DISP1_SYS_PWR_REG				0x1414
+#define EXYNOS5_MAU_SYS_PWR_REG					0x1418
+#define EXYNOS5_CMU_CLKSTOP_GSCL_SYS_PWR_REG			0x1480
+#define EXYNOS5_CMU_CLKSTOP_ISP_SYS_PWR_REG			0x1484
+#define EXYNOS5_CMU_CLKSTOP_MFC_SYS_PWR_REG			0x1488
+#define EXYNOS5_CMU_CLKSTOP_G3D_SYS_PWR_REG			0x148C
+#define EXYNOS5_CMU_CLKSTOP_DISP1_SYS_PWR_REG			0x1494
+#define EXYNOS5_CMU_CLKSTOP_MAU_SYS_PWR_REG			0x1498
+#define EXYNOS5_CMU_SYSCLK_GSCL_SYS_PWR_REG			0x14C0
+#define EXYNOS5_CMU_SYSCLK_ISP_SYS_PWR_REG			0x14C4
+#define EXYNOS5_CMU_SYSCLK_MFC_SYS_PWR_REG			0x14C8
+#define EXYNOS5_CMU_SYSCLK_G3D_SYS_PWR_REG			0x14CC
+#define EXYNOS5_CMU_SYSCLK_DISP1_SYS_PWR_REG			0x14D4
+#define EXYNOS5_CMU_SYSCLK_MAU_SYS_PWR_REG			0x14D8
+#define EXYNOS5_CMU_RESET_GSCL_SYS_PWR_REG			0x1580
+#define EXYNOS5_CMU_RESET_ISP_SYS_PWR_REG			0x1584
+#define EXYNOS5_CMU_RESET_MFC_SYS_PWR_REG			0x1588
+#define EXYNOS5_CMU_RESET_G3D_SYS_PWR_REG			0x158C
+#define EXYNOS5_CMU_RESET_DISP1_SYS_PWR_REG			0x1594
+#define EXYNOS5_CMU_RESET_MAU_SYS_PWR_REG			0x1598
+
+#define EXYNOS5_ARM_CORE0_OPTION				0x2008
+#define EXYNOS5_ARM_CORE1_OPTION				0x2088
+#define EXYNOS5_FSYS_ARM_OPTION					0x2208
+#define EXYNOS5_ISP_ARM_OPTION					0x2288
+#define EXYNOS5_ARM_COMMON_OPTION				0x2408
+#define EXYNOS5_ARM_L2_OPTION					0x2608
+#define EXYNOS5_TOP_PWR_OPTION					0x2C48
+#define EXYNOS5_TOP_PWR_SYSMEM_OPTION				0x2CC8
+#define EXYNOS5_JPEG_MEM_OPTION					0x2F48
+#define EXYNOS5_GSCL_OPTION					0x4008
+#define EXYNOS5_ISP_OPTION					0x4028
+#define EXYNOS5_MFC_OPTION					0x4048
+#define EXYNOS5_G3D_OPTION					0x4068
+#define EXYNOS5_DISP1_OPTION					0x40A8
+#define EXYNOS5_MAU_OPTION					0x40C8
+
+#define EXYNOS5_USE_SC_FEEDBACK					(1 << 1)
+#define EXYNOS5_USE_SC_COUNTER					(1 << 0)
+
+#define EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN			(1 << 7)
+
+#define EXYNOS5_OPTION_USE_STANDBYWFE				(1 << 24)
+#define EXYNOS5_OPTION_USE_STANDBYWFI				(1 << 16)
+
+#define EXYNOS5_OPTION_USE_RETENTION				(1 << 4)
+
+#endif /* __ASM_ARCH_REGS_PMU_H */
-- 
1.7.10.4

