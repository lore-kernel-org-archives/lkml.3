Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaEMNIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:08:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15888 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756AbaEMNGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:06:36 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f2-537218dacde1
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
Subject: [PATCHv5 1/5] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Tue, 13 May 2014 22:05:04 +0900
Message-id: <1399986308-23744-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkQPeWRFGwwdQ5KhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBn7Hp9mLzgsWbF720GmBsYzol2MnBwSAiYSMz6uZ4GwxSQu3FvP1sXIxSEk
	sJRR4s+stSwwRT9eTYJKLGKU2HBtJyOE08Qk0X5oHRtIFZuAlsT+FzfAbBEBXYkpM++wgtjM
	Aq0sEn1baroYOTiEBSwlVnwoAQmzCKhKzPv0hBnE5hVwlVj6eS4TxDI5iQ97HrGD2JwCbhK/
	breA2UJANcvO3mUC2SshsJJD4snhR8wQgwQkvk0+xAIyX0JAVmLTAWaIOZISB1fcYJnAKLyA
	kWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmCknv73rHcH4+0D1ocYk4HGTWSWEk3OB0Z6
	Xkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwzlFX
	28EmWmDWq88obKUkLfrIqWnfq9stlp8SClQ5PoRu41VIzpxzmTtaqEr1j+p3/a9p2wQPiT2a
	Py/57nSpKevuzP7Vv6Tb6T+P8f2/t/bNn/W8st2z9P580ciTTQJF99Ieha1kNGu8vpBPzWde
	qOrL63OXLYz4a5CuueauRbGHNuPehYzTlViKMxINtZiLihMBZCHxNeoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1bEkXBBrsfSFn8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2Pf4NHvBYcmK3dsOMjUwnhHtYuTk
	kBAwkfjxahIbhC0mceHeeiCbi0NIYBGjxIZrOxkhnCYmifZD68Cq2AS0JPa/uAFmiwjoSkyZ
	eYcVxGYWaGWR6NtS08XIwSEsYCmx4kMJSJhFQFVi3qcnzCA2r4CrxNLPc5kglslJfNjziB3E
	5hRwk/h1uwXMFgKqWXb2LtMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLTwDPp
	HYyrGiwOMQpwMCrx8C54VhAsxJpYVlyZe4hRgoNZSYTX/VNhsBBvSmJlVWpRfnxRaU5q8SHG
	ZKCrJjJLiSbnA1NUXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwBvDUHLz6ydhkk9Elpr+3Az3F9veu0f8duFky1+yqvLIK965594+vZozZs3WXsFG/7J25
	i9b05vsmP/3k/D5kkrD6u21/M/8stLAvMdCx3KgiwCuWdpptRpDmgzjnK1uuezxc//fV9CXL
	V/SseNv47XGve+7dn4r558/e37bL0qf26J7XfMG6p5VYijMSDbWYi4oTASnciPpHAwAA
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  | 22 ++++++++++++++++++++++
 arch/arm/mach-exynos/common.h | 10 ++++++++++
 arch/arm/mach-exynos/exynos.c |  2 ++
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
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 278b573..fb43ff4 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -15,6 +15,9 @@
 #include <linux/reboot.h>
 #include <linux/of.h>
 
+#define EXYNOS3250_SOC_ID       0xE3472000
+#define EXYNOS3_SOC_MASK        0xFFFFF000
+
 #define EXYNOS4210_CPU_ID	0x43210000
 #define EXYNOS4212_CPU_ID	0x43220000
 #define EXYNOS4412_CPU_ID	0xE4412200
@@ -33,6 +36,7 @@ static inline int is_samsung_##name(void)	\
 	return ((samsung_cpu_id & mask) == (id & mask));	\
 }
 
+IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
 IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
@@ -40,6 +44,12 @@ IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 
+#if defined(CONFIG_SOC_EXYNOS3250)
+# define soc_is_exynos3250()    is_samsung_exynos3250()
+#else
+# define soc_is_exynos3250()    0
+#endif
+
 #if defined(CONFIG_CPU_EXYNOS4210)
 # define soc_is_exynos4210()	is_samsung_exynos4210()
 #else
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 4df3452..f2b8e80 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -293,6 +293,8 @@ static void __init exynos_dt_machine_init(void)
 }
 
 static char const *exynos_dt_compat[] __initconst = {
+	"samsung,exynos3",
+	"samsung,exynos3250",
 	"samsung,exynos4",
 	"samsung,exynos4210",
 	"samsung,exynos4212",
-- 
1.8.0

