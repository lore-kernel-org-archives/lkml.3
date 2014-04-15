Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaDOCDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:03:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28212 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaDOB7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:53 -0400
X-AuditID: cbfee690-b7f266d00000287c-4e-534c92970b0c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 1/8] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Tue, 15 Apr 2014 10:59:45 +0900
Message-id: <1397527192-21988-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkWHf6JJ9ggzN/dS3+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M1Bo8ks2i/UzXrNYHJuxhNFi787JjA5CHmvmrWH0aGnuYfP4/WsSo8ffVS+YPe5c
	28PmsXlJvceVE02sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJVx+eMy9oITUhUdz38xNzDu
	F+ti5OSQEDCRePtjNxOELSZx4d56ti5GLg4hgaWMEo0ndrDAFP2a3cUEkVjEKLF9wiFmCKeJ
	SeLlualg7WwCWhL7X9xgA7FFBBQkNvc+YwUpYhZYyyxxcVIjWEJYwFLi344DjCA2i4CqxOSH
	n8FsXgFXiU89F6HWyUl82POIHcTmFHCT2Hv/LzOILQRUs37/bKhbWzkkjl+QhZgjIPFt8iGg
	Xg6guKzEpgPMECWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZg5J3+
	92zCDsZ7B6wPMSYDjZvILCWanA+M3LySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYIx27vh3kJHl3mfRGvnOCJ+Lkoxp81Kefz1jcaWu7+0+kd9z
	s9/rn1jVm1pzY99/7/SgixOFJlxqXs91ZrnGdKMlj5RmvXe5u3nilsu6O9XST8yvmeF8WUjy
	M/u6rmi7lk2Od/ar8gacWRTqPWHyFwnrgw/fnGZeNFGjRu7Qn1dzTjXPNhW5zztJiaU4I9FQ
	i7moOBEABWudrdICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3pk3yCDbaeVLL4O+kYu8WkdQeY
	LC7v17a4/uU5q8X8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy9
	84/N4tT1z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeayZt4bRo6W5h83j969JjB5/V71g9rhz
	bQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QP0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjMsfl7EXnJCq6Hj+i7mBcb9YFyMnh4SAicSv2V1MELaYxIV769m6GLk4hAQWMUps
	n3CIGcJpYpJ4eW4qWBWbgJbE/hc32EBsEQEFic29z1hBipgF1jJLXJzUCJYQFrCU+LfjACOI
	zSKgKjH54Wcwm1fAVeJTz0UWiHVyEh/2PGIHsTkF3CT23v/LDGILAdWs3z+baQIj7wJGhlWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZH9THoH46oGi0OMAhyMSjy8E955BwuxJpYVV+Ye
	YpTgYFYS4X2d7BMsxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnApJNXEm9obGJmZGlkbmhh
	ZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzK07ZKmR6ZI2ntq6oUu8K9o/qyc+3F
	ezuOJ2vcclVz3HblcaJyTtm+ieJFIp8Lg5t7+s588Zy+LyrohrJR5oPjqj+1Mle2hQYUaRua
	XX+mXfDdsrfqyjWGuk3qejq8xbPFEpYLu6c/S9AxfHFDOy6169LBV7froiyS+o44pgnufuqg
	Ys/gp8RSnJFoqMVcVJwIAAl4s/0wAwAA
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
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
 arch/arm/mach-exynos/exynos.c            |  2 ++
 arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
 3 files changed, 34 insertions(+)

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
index b32a907..a603dfa 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -370,6 +370,8 @@ static void __init exynos_dt_machine_init(void)
 }
 
 static char const *exynos_dt_compat[] __initconst = {
+	"samsung,exynos3",
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

