Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaDJJxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:53:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45458 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDJJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:50 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-c8-534664505ff9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Thu, 10 Apr 2014 18:28:18 +0900
Message-id: <1397122124-15690-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkUDcwxS3Y4O11RovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq4tkavYJtUxdzLq1gaGDeIdTFyckgImEjcXnaP
	HcIWk7hwbz0biC0ksJRR4vWrepianzNesXQxcgHFpzNK3Drxgx3CaWKSaP51mBGkik1AS2L/
	ixtg3SICARI/jr8Ds5kFbjJKHHsfBmILC1hKnD7zGKyeRUBV4tbtdjCbV8BVYmfHfBaIbXIS
	H/Y8AruIU8BN4tP3VlaIi1wlmj7sYwNZLCGwil1i95qdbBCDBCS+TT4E1MwBlJCV2HSAGWKO
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGPan/z2buIPx/gHrQ4zJ
	QOMmMkuJJucD4yavJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhhFjdIecSS6uWoH9px7rG56vITTvG7/5/qdFvuuvDEoWPvE0N2F1dt+k7/IU92g
	6osvaydeE1nfwr7nfUv3QV19OU+B/njnTy89rdWkrH13bJibmb1rdyTXTsd5a/SfsGzvcd4S
	IVVTvKH5pdKnp9b5itdfP1apexmc53TLQ/1xgaQu+xcWRSWW4oxEQy3mouJEABjOjpyRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2AFLdggx37TC2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrU1egXb
	pCrmXl7F0sC4QayLkZNDQsBE4ueMVywQtpjEhXvr2boYuTiEBKYzStw68YMdwmlikmj+dZgR
	pIpNQEti/4sbbCC2iECAxI/j78BsZoGbjBLH3oeB2MIClhKnzzwGq2cRUJW4dbsdzOYVcJXY
	2TEfapucxIc9j9hBbE4BN4lP31tZQWwhoJqmD/vYJjDyLmBkWMUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRHFfPpHYwrmywOMQowMGoxMN7YJlrsBBrYllxZe4hRgkOZiUR3mvBbsFCvCmJ
	lVWpRfnxRaU5qcWHGJOBrprILCWanA+M+bySeENjEzMjSyNzQwsjY3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYIycc/+JwpeHDceezatflzlrv8WykpN/12+s9Cj8dXxjacEr5psJ
	5eu0/8mlh5ioS3XfMCxbt3D9KSd/frkFOXf/3U1mPchkdzN3bdlJlb4l7So2rhPbDjm/nSQV
	mMstHib1+3LQNKkdE/Xns+TxrphV9LWgY11YV9zLraunHk2eUp4/K73+kLQSS3FGoqEWc1Fx
	IgA13vOT7wIAAA==
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

