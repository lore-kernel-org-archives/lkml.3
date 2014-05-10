Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaEJHCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:02:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35653 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbaEJHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:02:08 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-72-536dceef9f06
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v3 3/6] ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
Date: Sat, 10 May 2014 16:20:16 +0900
Message-id: <1399706419-13976-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+Zse77c7nBBs+/cFr8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBbHZixhdOD0aGnuYfP4/WsSo8eda3vY
	PDYvqffo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujHfzJ7IXrJGveLN1OVMD4zGpLkZODgkB
	E4l5j78wQdhiEhfurWfrYuTiEBJYxijRMLebEabo3sy1rBCJRYwSM18dhnLamCTaF79mBali
	E9CVePJ+LjOILSKQLXGl8T4zSBGzwD6gjvapLCAJYQEvie3vb4AVsQioSqx7+htsBa+Ah8TO
	OxOA4hxA6xQk5kyyAQlzCnhK7PjRxQZiCwnUSCxveMEIMlNCYBu7xNo3b9kg5ghIfJt8iAWi
	V1Zi0wFmiKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQGJi4g/H+
	AetDjMlA4yYyS4km5wNjKK8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGP1DP15hu/nC+1n/1fvrg/Z5Ci5WykrUKZks9jAgdNe0k0lLNF8fEHP2
	+WiwcqZ9pdNEDn8V4YjPT5edyD/fd8E/V+1M7kWLQ522Pxfx/tjMbvSl8flNjv15WxRPt7+/
	/VriZUFhbh6fvF6i4+kaNks79gqXqqsvHKsnZx4JtWNS6dA4MSXBRYmlOCPRUIu5qDgRACdn
	AteXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd3353KDDRbdZ7H4O+kYu0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vF+hmvWSyOzVjC6MDp0dLcw+bx+9ckRo871/aw
	eWxeUu/Rt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDPe
	zZ/IXrBGvuLN1uVMDYzHpLoYOTkkBEwk7s1cywphi0lcuLeerYuRi0NIYBGjxMxXh1khnDYm
	ifbFr8Gq2AR0JZ68n8sMYosIZEtcabzPDFLELLAPqKN9KgtIQljAS2L7+xtgRSwCqhLrnv5m
	BLF5BTwkdt6ZABTnAFqnIDFnkg1ImFPAU2LHjy42EFtIoEZiecMLxgmMvAsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBEfYM6kdjCsbLA4xCnAwKvHwFrzNCRZiTSwrrsw9xCjBwawk
	wrviYG6wEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDoz+vJN7Q2MTMyNLIzMLIxNycNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhiVjNcxzFh2QKPpSPwGmYcJ9SkaTttcvd1yQy01
	LpzhPCs51ftaus5HRqUXU12qzrqc8In7fquvI3LD1pCXqv/FVHL+lPDNED0ckty74nHYNL6y
	lXJ/Xyb12rDcTL7AOLnTXyk0szRu9a0ln5bdleF2NHeJ/uB575f65paXaz/G3dgkmmIaLabE
	UpyRaKjFXFScCADZoVst9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes usage of soc_is_exynos4/5 from exynos.c.
For this we need to separate machine descriptors for exynos4
and exynos5. While doing this patch does some consolidation also.

CC: Russell King <linux@arm.linux.org.uk>
CC: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c            |   52 +++++++++++++++++++-----------
 arch/arm/plat-samsung/include/plat/cpu.h |    3 --
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 09063ee..9902e52 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -202,20 +202,6 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
 	{},
 };
 
-/*
- * exynos_map_io
- *
- * register the standard cpu IO areas
- */
-static void __init exynos_map_io(void)
-{
-	if (soc_is_exynos4())
-		iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
-
-	if (soc_is_exynos5())
-		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
-}
-
 static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
@@ -224,8 +210,18 @@ static void __init exynos_init_io(void)
 
 	/* detect cpu id and rev. */
 	s5p_init_cpu(S5P_VA_CHIPID);
+}
+
+static void __init exynos5_init_io(void)
+{
+	exynos_init_io();
+	iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
+}
 
-	exynos_map_io();
+static void __init exynos4_init_io(void)
+{
+	exynos_init_io();
+	iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 }
 
 struct bus_type exynos_subsys = {
@@ -293,11 +289,15 @@ static void __init exynos_dt_machine_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static char const *exynos_dt_compat[] __initconst = {
+static char const *exynos4_dt_compat[] __initconst = {
 	"samsung,exynos4",
 	"samsung,exynos4210",
 	"samsung,exynos4212",
 	"samsung,exynos4412",
+	NULL
+};
+
+static char const *exynos5_dt_compat[] __initconst = {
 	"samsung,exynos5",
 	"samsung,exynos5250",
 	"samsung,exynos5420",
@@ -321,15 +321,29 @@ static void __init exynos_reserve(void)
 #endif
 }
 
-DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
+DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
+	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
+	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
+	.smp		= smp_ops(exynos_smp_ops),
+	.map_io		= exynos5_init_io,
+	.init_early	= exynos_firmware_init,
+	.init_machine	= exynos_dt_machine_init,
+	.init_late	= exynos_init_late,
+	.dt_compat	= exynos5_dt_compat,
+	.restart	= exynos_restart,
+	.reserve	= exynos_reserve,
+MACHINE_END
+
+
+DT_MACHINE_START(EXYNOS4_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	/* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
 	.smp		= smp_ops(exynos_smp_ops),
-	.map_io		= exynos_init_io,
+	.map_io		= exynos4_init_io,
 	.init_early	= exynos_firmware_init,
 	.init_machine	= exynos_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.dt_compat	= exynos_dt_compat,
+	.dt_compat	= exynos4_dt_compat,
 	.restart	= exynos_restart,
 	.reserve	= exynos_reserve,
 MACHINE_END
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 5992b8d..18a9a00 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -166,9 +166,6 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5440()	0
 #endif
 
-#define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
-			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
 
 #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
 
-- 
1.7.10.4

