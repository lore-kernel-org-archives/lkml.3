Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaDRBQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61231 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaDRBP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:29 -0400
X-AuditID: cbfee690-b7f266d00000287c-f7-53507cae2a85
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv3 1/7] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Fri, 18 Apr 2014 10:15:22 +0900
Message-id: <1397783728-6193-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSHddTUCwQcNGc4u/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7V4vOHFnaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxd87
	/9gsTl3/zGZx8k8vo8WTwx9ZLWZMfslmsX7GaxaLYzOWMFq0/93LZrF352RGB1GPNfPWMHq0
	NPewefz+NYnR4++qF8weO2fdZfe4c20Pm8fmJfUeV040sXr0bVnF6PF5k1wAVxSXTUpqTmZZ
	apG+XQJXxsXeZawFJ6QqOi+tZW9g3C/WxcjJISFgIjHh0g0WCFtM4sK99WxdjFwcQgJLGSW+
	3zjKAlM068NlVojEIkaJA82XWSCcJiaJC7cOgFWxCWhJ7H9xgw3EFhFQkNjc+wysg1ngF7PE
	z+fN7CAJYQFLif/zp7OC2CwCqhLbV08Fs3kFXCR+fH/HCrFOTuLDnkdg9ZwCrhLnHx8BWyAE
	VPPw+3SwzRICSzkkdm55ADVIQOLb5ENACQ6ghKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILk
	guKk9CITveLE3OLSvHS95PzcTYzAGD3979mEHYz3DlgfYkwGGjeRWUo0OR8Y43kl8YbGZkYW
	piamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBgtKLk11/zWyxZ1
	XtNtq/8ETXk5c4nQh1jVwqC/L203VO4t68w3Ovuyhl+8288w2fnQ1JcdLkwJXtdKmt5esDDs
	T3pbEVwdnHdJ6d5ihq1Fe9k99xW4x07WD+jNWXW/zzDq2oXd/M7sMdeEL51YPSvsztrr2TLb
	Zlz/N9HLafOZwLczdPnlzyqxFGckGmoxFxUnAgD3/Enk5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd11NQHBBqua9Cz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M5vFyT+9jBZPDn9ktZgx+SWbxfoZr1ksjs1YwmjR/ncvm8XenZMZHUQ91sxbw+jR
	0tzD5vH71yRGj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UVo8fnTXIBXFENjDYZqYkp
	qUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QD8qKZQl5pQChQIS
	i4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMu9i5jLTghVdF5aS17A+N+sS5GTg4JAROJ
	WR8us0LYYhIX7q1n62Lk4hASWMQocaD5MguE08QkceHWARaQKjYBLYn9L26wgdgiAgoSm3uf
	sYIUMQv8Ypb4+byZHSQhLGAp8X/+dLCxLAKqEttXTwWzeQVcJH58fwe1Tk7iw55HYPWcAq4S
	5x8fAVsgBFTz8Pt0lgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeAZ9I7GFc1
	WBxiFOBgVOLhvfDVP1iINbGsuDL3EKMEB7OSCK9yaUCwEG9KYmVValF+fFFpTmrxIcZkoKsm
	MkuJJucDk1NeSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBq
	6netSf8r/Msh9cZSiXtJLWd/2SXwX5wmtdjrEKfqjdWb7t+/aB3Te58xbP89mSnmrDefiH48
	UuwTrFD47WBI5LN1odolvtb8Pd2mS9UO31WUyBX+tDbRK1/9q/7yNv3LC1Vnv925fvrZLPMm
	6UsmnOyiUn1LvpazJayZlnBE7uXvvmirE+FKLMUZiYZazEXFiQCuoq3URAMAAA==
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

