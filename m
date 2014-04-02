Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbaDBHgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:36:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36694 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbaDBHeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:03 -0400
X-AuditID: cbfee690-b7f266d00000287c-15-533bbd6adb1d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 05/10] ARM: EXYNOS: Move "regs-pmu" header inclusion in common.h
Date: Wed, 02 Apr 2014 16:50:56 +0900
Message-id: <1396425058-4012-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t8zY92svdbBBj19khbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YXdg92hp7mHz2Lyk3qNvyypGj8+b5AJYorhsUlJz
	MstSi/TtErgyll41KZgiXnH0yG/2Bsbjwl2MHBwSAiYSB3eqdjFyApliEhfurWcDsYUEljFK
	9Ox3h4ibSPTu/srSxcgFFF/EKHHqVQMrhNPGJNH8eRNYB5uArsST93OZQWwRgWyJS7NusYDY
	zAJFEm/W/QGrERYIkOh8+IsRZDGLgKrE7wlOIGFeAXeJDSuesUHcoyAxZ5INSJhTwEPifksL
	O8Q97hJzb+wEWyshMJ1dYveB92AjWQQEJL5NPsQC0SsrsekAM8TNkhIHV9xgmcAovICRYRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSEBP2MF474D1IcZkoHETmaVEk/OBEZFXEm9obGZk
	YWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYz9jzf/tP39jsf8
	r5l4c/Je0zczV+e8WJE9S4rzSYl5Tg7bwnXHjZhs7+5TPvObf6bWjZ9ND+VCfDyuOy9Tr/yW
	ZnjI8fY29vk91l8Xd/xYm2U411InzFEgZM2Gklo5oZlJNvGfjlQcbnZtv3BHRaPZszNAzOmc
	mbkMP4v+54KYza/XTuPW0lFiKc5INNRiLipOBAAEzj4tfgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jAd2svdbBBk9eiVgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLH0qknBFPGKo0d+szcwHhfuYuTkkBAw
	kejd/ZUFwhaTuHBvPVsXIxeHkMAiRolTrxpYIZw2Jonmz5vYQKrYBHQlnryfywxiiwhkS1ya
	dQusm1mgSOLNuj9gNcICARKdD38xdjFycLAIqEr8nuAEEuYVcJfYsOIZG0hYQkBBYs4kG5Aw
	p4CHxP2WFnYQWwioZO6NnawTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOmWfS
	OxhXNVgcYhTgYFTi4T1w3ipYiDWxrLgy9xCjBAezkggv5yTrYCHelMTKqtSi/Pii0pzU4kOM
	yUA3TWSWEk3OB8ZzXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwuvA8Cw2NOi/34OhMl6obS8vVdzXGL1atm6L+VFd0lTHHopd3+m//P/96/4TgS1/X6W3e
	n1D+fGb1hP1sR3pyth1Q0Tn7UX3rAtZF3Nxv/n4/q6XUFX50omPTxEyR+BMGT45OOcU+5f5b
	w0QVXc/lOouW8Ng6mvx8NmNxQMgpsbbznwtelxaalymxFGckGmoxFxUnAgBAsu0F3QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many machine files under "mach-exynos" including "regs-pmu.h"
as well as "common.h", so better we move this header inclusion in common.h.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h  |    1 +
 arch/arm/mach-exynos/cpuidle.c |    1 -
 arch/arm/mach-exynos/exynos.c  |    1 -
 arch/arm/mach-exynos/hotplug.c |    1 -
 arch/arm/mach-exynos/platsmp.c |    1 -
 arch/arm/mach-exynos/pm.c      |    1 -
 arch/arm/mach-exynos/pmu.c     |    1 -
 7 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 277a83e..ff28334 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -14,6 +14,7 @@
 
 #include <linux/reboot.h>
 #include <linux/of.h>
+#include "regs-pmu.h"
 
 void exynos_init_io(void);
 void exynos_restart(enum reboot_mode mode, const char *cmd);
diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index b530231..b9dd8c3 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -29,7 +29,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 #define REG_DIRECTGO_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 57bd1cd..a5e1349 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -30,7 +30,6 @@
 
 #include "common.h"
 #include "mfc.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 #define L2_AUX_VAL 0x7C470001
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..33db6ee 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -22,7 +22,6 @@
 #include <plat/cpu.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 static inline void cpu_enter_lowpower_a9(void)
 {
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index d8d1555..3ebb03f 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -29,7 +29,6 @@
 #include <plat/cpu.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 extern void exynos4_secondary_startup(void);
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 723c988..875151f 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -34,7 +34,6 @@
 #include <mach/map.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 #include "regs-sys.h"
 
 /**
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 05c7ce1..fb44352 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -16,7 +16,6 @@
 #include <plat/cpu.h>
 
 #include "common.h"
-#include "regs-pmu.h"
 
 static const struct exynos_pmu_conf *exynos_pmu_config;
 
-- 
1.7.10.4

