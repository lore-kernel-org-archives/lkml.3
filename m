Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbaDJJh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:37:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47541 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbaDJJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:52 -0400
X-AuditID: cbfee68f-b7f156d00000276c-af-5346666e4ea2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Thu, 10 Apr 2014 18:37:12 +0900
Message-id: <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRDc/zS3YYOs6FovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq4tkavYJtUxdzLq1gaGDeIdTFyckgImEh0X1/K
	CGGLSVy4t56ti5GLQ0hgKaPEyYcrgRwOsKKugxwgNUIC0xklpu8Vg6hpYpK4v7sXrJlNQEti
	/4sbbCC2iECAxI/j78BsZoGbjBLH3oeB2MIClhKnzzwGq2cRUJWYcXoFWA2vgKvEwovnWCGO
	kJP4sOcRO4jNKeAmMXPRSTaIxa4SPY8uMoMslhBYxi6x48hOJohBAhLfJh9igThUVmLTAWaI
	OZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmDQn/73rH8H490D1ocY
	k4HGTWSWEk3OB0ZNXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgFDi5Siw/f65LQ4/4qgTp63LbGkxU0vcl5G0s/yruuOCY7X8zLuZX0W4t/2Yp
	vz0b8171m3xpS9aVUP262leM6+bl7U492n6Hz35bzQH2tE8MsXxnd7vHz5vxxO6IjUlFyo1d
	2Xl7Jq29LLk+NOqBpZnHa9mFZRtXHdjnulanx7sszNNY+t0tJZbijERDLeai4kQA7U/SYJAC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd28NLdgg+u3LSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrU1egXb
	pCrmXl7F0sC4QayLkYNDQsBEousgRxcjJ5ApJnHh3no2EFtIYDqjxPS9QCVcQHYTk8T93b2M
	IAk2AS2J/S9ugBWJCARI/Dj+DsxmFrjJKHHsfRiILSxgKXH6zGOwehYBVYkZp1eA1fAKuEos
	vHiOFWKZnMSHPY/YQWxOATeJmYtOQi12leh5dJF5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBMfVMegfjqgaLQ4wCHIxKPLwHlrkGC7EmlhVX5h5ilOBgVhLhvRbsFizEm5JY
	WZValB9fVJqTWnyIMRnoqonMUqLJ+cB4zyuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQQHpi
	SWp2ampBahHMFiYOTqkGRiY5Vo6H55yPxT25v2nTDIY7a5q2HP3apSDuwTojd0Wuk6xqxHLm
	Hy9+blJhmubSpt/QMPOmyWefvQKvJ/ly7Jsr47Bhe7QYl17K5heXvdtZlpuv1y+o1rqfqtJS
	4X/5x6aJ9v5Ws3ZHukxlEdVvluJtP6DrZH+pd/vitR6lew9EF29jrjA7psRSnJFoqMVcVJwI
	AKJlzuftAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
dual cores and has a target speed of 1.0GHz.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
 arch/arm/mach-exynos/exynos.c            |  1 +
 arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
 3 files changed, 33 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index fc8bf18..6da8a68 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -11,6 +11,17 @@ if ARCH_EXYNOS
 
 menu "SAMSUNG EXYNOS SoCs Support"
 
+config ARCH_EXYNOS3
+	bool "SAMSUNG EXYNOS3"
+	select ARM_AMBA
+	select CLKSRC_OF
+	select HAVE_ARM_SCU if SMP
+	select HAVE_SMP
+	select PINCTRL
+	select PM_GENERIC_DOMAINS if PM_RUNTIME
+	help
+	  Samsung EXYNOS3 SoCs based systems
+
 config ARCH_EXYNOS4
 	bool "SAMSUNG EXYNOS4"
 	default y
@@ -41,6 +52,17 @@ config ARCH_EXYNOS5
 
 comment "EXYNOS SoCs"
 
+config SOC_EXYNOS3250
+	bool "SAMSUNG EXYNOS3250"
+	default y
+	depends on ARCH_EXYNOS3
+	select ARCH_HAS_BANDGAP
+	select ARM_CPU_SUSPEND if PM
+	select PINCTRL_EXYNOS
+	select SAMSUNG_DMADEV
+	help
+	  Enable EXYNOS3250 CPU support
+
 config CPU_EXYNOS4210
 	bool "SAMSUNG EXYNOS4210"
 	default y
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b32a907..b134868 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
 }
 
 static char const *exynos_dt_compat[] __initconst = {
+	"samsung,exynos3250",
 	"samsung,exynos4",
 	"samsung,exynos4210",
 	"samsung,exynos4212",
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 5992b8d..3d808f6b 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
 #define S5PV210_CPU_ID		0x43110000
 #define S5PV210_CPU_MASK	0xFFFFF000
 
+#define EXYNOS3250_SOC_ID       0xE3472000
+#define EXYNOS3_SOC_MASK        0xFFFFF000
+
 #define EXYNOS4210_CPU_ID	0x43210000
 #define EXYNOS4212_CPU_ID	0x43220000
 #define EXYNOS4412_CPU_ID	0xE4412200
@@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
 IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
 IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
 IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
+IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
 IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
@@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_s5pv210()	0
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS3250)
+# define soc_is_exynos3250()    is_samsung_exynos3250()
+#else
+# define soc_is_exynos3250()    0
+#endif
+
 #if defined(CONFIG_CPU_EXYNOS4210)
 # define soc_is_exynos4210()	is_samsung_exynos4210()
 #else
-- 
1.8.0

