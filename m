Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbaDBHeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:34:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbaDBHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:15 -0400
X-AuditID: cbfee68e-b7f566d000002344-ba-533bbd6bf88b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base address
 via DT
Date: Wed, 02 Apr 2014 16:50:57 +0900
Message-id: <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t8zA93svdbBBou62C2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xo2U1iwOHR0tzD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJUxa9IEtoIfYhUdu/4yNjBOFe5i5OSQEDCRuLPgAyuELSZx4d56ti5G
	Lg4hgWWMEv1nWhlhim7uWM0OkVjEKHFh9WYmCKeNSaL58yY2kCo2AV2JJ+/nMoPYIgLZEpdm
	3WIBKWIWmMcosetsJ1iRsECoxN6Ta4G6OThYBFQlNn91BAnzCrhLbN64lwUkLCGgIDFnkg1I
	mFPAQ+J+Sws7iC0EVDL3xk6oS+exS5x7wgFiswgISHybfAiqVVZi0wFmiBJJiYMrbrBMYBRe
	wMiwilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkwPt2MN48YH2IMRlo3ERmKdHkfGCE5JXE
	GxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRv/56jV7
	557tnHqYUU3GJXOWndWCKpE1dSflPlvszhA5MHeL32ana2q2F3201/CxKhRxqrmtezfj8wzh
	7WoLK54vbV1VZTnnauyO6QFC2QFqqpenzntV97tfvappZ7vls0Dvkv1Ngs2Nna0lL1cc0bZ1
	Kl737YHNbte40Ml3j83z+fxZ4c+/20osxRmJhlrMRcWJAN2me2KGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd3svdbBBsf2M1ksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1iR8tqFgcOj5bmHjaPzUvqPfq2rGL0+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqxJE9gKfohVdOz6y9jAOFW4
	i5GTQ0LAROLmjtXsELaYxIV769m6GLk4hAQWMUpcWL2ZCcJpY5Jo/ryJDaSKTUBX4sn7ucwg
	tohAtsSlWbdYQIqYBeYxSuw62wlWJCwQKrH35Fqgbg4OFgFVic1fHUHCvALuEps37mUBCUsI
	KEjMmWQDEuYU8JC439ICdoQQUMncGztZJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHEHPpHYwrmywOMQowMGoxMN74LxVsBBrYllxZe4hRgkOZiURXs5J1sFCvCmJlVWpRfnx
	RaU5qcWHGJOBbprILCWanA+M7rySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYJzboX9vTkfbWYeEFKmYlqIGPfW3N3teG/sX1n42Mb02bd073+9pQvUS07am
	T8z5deoww7SdR31fPSx9rzRZ+oOamJ1NddLjsz8Nw5N07HnunBds5Is/bmGh0tnVfFItrGNn
	o8Rr6a1HrMzV+8rTdeJTEkWYm7ZO/Pe/onmlxIkV+czLdxYsVmIpzkg01GIuKk4EAFS/gQ3k	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

Add support for mapping Exynos Power Management Unit (PMU) base address
from device tree. Code will use existing samsung pmu binding information.
This patch also adds "get_exynos_pmubase" a helper function to return mapped base
address to various other files under "mach-exynos".

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    2 ++
 arch/arm/mach-exynos/exynos.c |   44 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index ff28334..9a55cf6 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -61,4 +61,6 @@ struct exynos_pmu_conf {
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 
+extern void __iomem *get_exynos_pmubase(void);
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a5e1349..a5127fb 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -35,6 +35,8 @@
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
 
+static void __iomem *exynos_pmu_base __initdata;
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -245,6 +247,47 @@ void __init exynos_init_late(void)
 	exynos_pm_init();
 }
 
+static char const *exynos_dt_pmu_match[] __initconst = {
+	"samsung,exynos4210-pmu",
+	"samsung,exynos4212-pmu",
+	"samsung,exynos4412-pmu",
+	"samsung,exynos5250-pmu",
+	NULL
+};
+
+static int __init exynos_fdt_map_pmu(unsigned long node,
+		const char *uname, int depth, void *data)
+{
+	struct map_desc iodesc;
+	__be32 *reg;
+	unsigned long len;
+
+	if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
+		phys_addr_t phys_addr;
+		reg = of_get_flat_dt_prop(node, "reg", &len);
+		if (reg == NULL || len != (sizeof(unsigned long) * 2))
+			return 0;
+
+		phys_addr = be32_to_cpu(reg[0]);
+		iodesc.pfn = __phys_to_pfn(phys_addr);
+		iodesc.length = be32_to_cpu(reg[1]) - 1;
+		iodesc.virtual = (unsigned long)S5P_VA_PMU;
+		iodesc.type = MT_DEVICE;
+		iotable_init(&iodesc, 1);
+
+		exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
+		if (WARN_ON(!exynos_pmu_base))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+inline void __iomem *get_exynos_pmubase()
+{
+	return exynos_pmu_base;
+}
+
 static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 					int depth, void *data)
 {
@@ -301,6 +344,7 @@ void __init exynos_init_io(void)
 	debug_ll_io_init();
 
 	of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
+	of_scan_flat_dt(exynos_fdt_map_pmu, NULL);
 
 	/* detect cpu id and rev. */
 	s5p_init_cpu(S5P_VA_CHIPID);
-- 
1.7.10.4

