Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaDYBRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39132 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaDYBQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:20 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d8-5359b75f98e9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv4 1/7] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Fri, 25 Apr 2014 10:16:06 +0900
Message-id: <1398388572-30239-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkQDdhe2SwwdSDTBZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBkXe5exFpyQqui8tJa9gXG/WBcjJ4eEgIlE/+F7bBC2mMSFe+uBbC4OIYGl
	jBL3L59lgSm6+GcSK0RiOqPE2qU9UFVNTBLT179nB6liE9CS2P/iBtgoEQFdiSkz77CC2MwC
	rSwSfVtqQGxhAUuJ5T+XAcU5OFgEVCU63+iDhHkFXCVen+lghFgmJ/FhzyOwkZwCbhI7d71i
	AikXAqpZ+scDZK2EwFIOiS3XN4GNZxEQkPg2+RALSI2EgKzEpgPMEGMkJQ6uuMEygVF4ASPD
	KkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAOD3971nvDsbbB6wPMSYDjZvILCWanA+M87yS
	eENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMxMT264
	vE3scN5vKTU/h5L8wFX7co10dmzmuJhuefiz5mJ7kT9Tett/x/3pL6j5J5ib8977F1P8XdaI
	A2wO2w4H/9i2tOVolNLnxnjjWc3/Yxaom0Zz3JtSlDH1dMgap1bDe+eizfK+W0X/mzUl7UDi
	hU6+Zss7fk8Wn1rz1iSnfsvOIwK7fyuxFGckGmoxFxUnAgA1rwNv6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd347ZHBBruWmln8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuNi7jLXghFRF56W17A2M+8W6GDk5
	JARMJC7+mcQKYYtJXLi3nq2LkYtDSGA6o8TapT1QThOTxPT179lBqtgEtCT2v7jBBmKLCOhK
	TJl5B6ybWaCVRaJvSw2ILSxgKbH85zKgOAcHi4CqROcbfZAwr4CrxOszHYwQy+QkPux5BDaS
	U8BNYueuV0wg5UJANUv/eExg5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgJPJPa
	wbiyweIQowAHoxIP7we1yGAh1sSy4srcQ4wSHMxKIrzKq4BCvCmJlVWpRfnxRaU5qcWHGJOB
	bprILCWanA9MUHkl8YbGJmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wOh712sNF/di9d13ZJ3fq31pvpq7tFX6UeyeZ986lE13JH6wzk6b1F9WPUd+Rf7WkhdS9c2K
	ETPEZ95LWRmbJrJw0ZSp2wr905YVsDjySpTLin2z3e3ktiI8Z+1v7VzVL61xUnvPsZ31Erin
	atxVeFO85EBbzSTbptxm9TtZW1LvbM69ebjithJLcUaioRZzUXEiACbVyHZGAwAA
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
index 6a5fe18..e7dc6fd 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -346,6 +346,8 @@ static void __init exynos_dt_machine_init(void)
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

