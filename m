Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaFYMss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:48:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50087 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaFYMsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:48:46 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-2e-53aac52c1570
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 1/6] ARM: EXYNOS: Make exynos machine_ops as static
Date: Wed, 25 Jun 2014 18:15:37 +0530
Message-id: <1403700342-9678-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSratzdFWwwfMH2hbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx6nozc8FSwYqb/z+xNDBe5eti5OSQEDCR
	2DjtGguELSZx4d56ti5GLg4hgaWMEh8n9LPCFF3Yc5sFIjGdUeLJgZOsEM4EJokjd8+AVbEJ
	6Eo8eT+XGcQWEciW6L+9GqyDWeAUo8TszdPYQRLCAm4SjUuOg9ksAqoST2ctA2vgFXCXOHFi
	PZDNAbROQWLOJBuQMKeAh8SjRTfAzhMCKulo+MsOMlNCYBO7xJHL/1gg5ghIfJt8iAWiV1Zi
	0wFmiKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAGDj971nfDsab
	B6wPMSYDjZvILCWanA+MobySeENjMyMLUxNTYyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwCjAOkdtOnOq29x4CcGptXms06cHnQwqYa8P5bxmaLukpu+m5eGjj1MS
	T4mmq8izf4h1N+u/t6H0b7vF3M07C2fsEpw2b06s/7yLr2du57PQE2VW8dXxC5Ko3MiRlRx+
	rvI789L4mW1L8i/sPMoQ9ThS4bzgeifHKK932h56fsK3NDRuan04rsRSnJFoqMVcVJwIAMV8
	bmSXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQV2do6uCDS7OUbJYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGauu
	NzMXLBWsuPn/E0sD41W+LkZODgkBE4kLe26zQNhiEhfurWfrYuTiEBKYzijx5MBJVghnApPE
	kbtnWEGq2AR0JZ68n8sMYosIZEv0317NAlLELHCKUWL25mnsIAlhATeJxiXHwWwWAVWJp7OW
	gTXwCrhLnDixHsjmAFqnIDFnkg1ImFPAQ+LRohtgVwgBlXQ0/GWfwMi7gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwhD2T2sG4ssHiEKMAB6MSD++F2SuDhVgTy4orcw8xSnAwK4nw
	uu9fFSzEm5JYWZValB9fVJqTWnyI0RToqInMUqLJ+cDozyuJNzQ2MTc1NrU0sTAxs1QS5z3Q
	ah0oJJCeWJKanZpakFoE08fEwSnVwFjO2/F+8oQlNbeqmCPuLbv+svx8kYmGI3/YDN7/+3az
	betLtc5vbDqisKX06tU2mf9bnXhiNzQmcH+N/B6ZeJwhyGCOMGtLYq1m65H1W86sjbSYzKTk
	lX9s1qqtcfMkzgvc9leOLjvhococLFn6YM/3GW/E/uw+WFdwaE6eq/bjyz+yb//4MlWJpTgj
	0VCLuag4EQBVvJWExgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As machine function ops are used only in this file let's make
them static. Also remove unused and unwanted declarations from
common.h.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h |    8 --------
 arch/arm/mach-exynos/exynos.c |    6 +++---
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 16617bd..3f25f89 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -111,16 +111,8 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 #define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
 			  soc_is_exynos5420() || soc_is_exynos5800())
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
-void exynos_init_io(void);
-void exynos_restart(enum reboot_mode mode, const char *cmd);
-void exynos_cpuidle_init(void);
-void exynos_cpufreq_init(void);
-void exynos_init_late(void);
 
 void exynos_firmware_init(void);
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 90aab4d..6affcd9 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -143,7 +143,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 	},
 };
 
-void exynos_restart(enum reboot_mode mode, const char *cmd)
+static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
@@ -184,7 +184,7 @@ void __init exynos_cpufreq_init(void)
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 }
 
-void __init exynos_init_late(void)
+static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
 		/* to be supported later */
@@ -231,7 +231,7 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
 }
 
-void __init exynos_init_io(void)
+static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
 
-- 
1.7.9.5

