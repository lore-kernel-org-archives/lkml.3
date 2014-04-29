Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaD2Bhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:37:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33107 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaD2Bhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:37:53 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-61-535f026c334b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux@arm.linux.org.uk, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv5] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Tue, 29 Apr 2014 10:37:42 +0900
Message-id: <1398735462-1938-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkSDeXKT7Y4PQydovL+7Utrn95zmrx
	+UMLu8Wk+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3LvBYzJr9ks1g/4zWLxd6d
	kxkdeD1amnvYPDYvqffo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujHm777IXXOOpmLect4Fx
	E1cXIyeHhICJxKsls1kgbDGJC/fWs3UxcnEICSxllLg67SM7TNH3SxeYIBKLGCUeHXgO5TQx
	SSw5OYERpIpNQEti/4sbbCC2iICuxJSZd1hBipgFNjNJvF25nBkkISzgIfH1/i6wBhYBVYkv
	ez6wgti8Ai4S3w52MUOsk5P4sOcR1Opl7BKr7lpA1AtIfJt8COhWDqC4rMSmA1DlkhIHV9xg
	mcAouICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYIif/vesdwfj7QPWhxiTgcZNZJYS
	Tc4HxkheSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTCWlf2L/77S5FrvAyPfJXrmi6Yp3cu5Wbjqa57oo70MU7OkDVkvXVjgZNBpdMzwi+Vr1sgZ
	+8zftEkvYLukK3Nyxoopx0RVHz3d+Xsib5zhpthuuZLWaxy6wX4TmrRKN5rsmtfc56nJMmlF
	5TlXp9vV1zYz1+xOkZynHLF+zw31jrzdIcsMUxcosRRnJBpqMRcVJwIAHv9gfocCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd0cpvhgg/m7LS0u79e2uP7lOavF
	5w8t7BaT7k9gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81rMmPySzWL9jNcsFnt3
	TmZ04PVoae5h89i8pN6jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMGbM232XveAaT8W85bwNjJu4uhg5OSQETCS+X7rABGGLSVy4t56ti5GLQ0hgEaPE
	owPPmSCcJiaJJScnMIJUsQloSex/cYMNxBYR0JWYMvMOK0gRs8BmJom3K5czgySEBTwkvt7f
	BdbAIqAq8WXPB1YQm1fAReLbwS5miHVyEh/2PGKfwMi9gJFhFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZwDD2T3sG4qsHiEKMAB6MSD29HTFywEGtiWXFl7iFGCQ5mJRFe21agEG9KYmVV
	alF+fFFpTmrxIcZkoO0TmaVEk/OB8Z1XEm9obGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU
	7NTUgtQimC1MHJxSDYzd24NmxLDL7Lvyc7Hg2776/aZpp25yF6adLF7/ft/B6IK+f5kBIe07
	09aIPn3VqHPcw0wsTqe85nlu3sqy7mhdjrlqe3TXbnhhfWrVhNjFkiybMhiYV00/s806MZzt
	yrEdSS9exk3wfiDDKXruZa3t/gslp2etXDCB1zp1T86du7NktFh6jRYrsRRnJBpqMRcVJwIA
	HRLXjeUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

This patch fix the offset of CPU boot address and change parameter of smc call
of SMC_CMD_CPU1BOOT command for Exynos4212.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes from v4:
- Post only this patch separated from following patchset[1]
[1] https://lkml.org/lkml/2014/4/24/873

 arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 932129e..aa01c42 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -18,6 +18,8 @@
 
 #include <mach/map.h>
 
+#include <plat/cpu.h>
+
 #include "smc.h"
 
 static int exynos_do_idle(void)
@@ -28,13 +30,24 @@ static int exynos_do_idle(void)
 
 static int exynos_cpu_boot(int cpu)
 {
+	/*
+	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
+	 * But, Exynos4212 has only one secondary CPU so second parameter
+	 * isn't used for informing secure firmware about CPU id.
+	 */
+	if (soc_is_exynos4212())
+		cpu = 0;
+
 	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
 	return 0;
 }
 
 static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
-	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
+	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
+
+	if (!soc_is_exynos4212())
+		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
 	return 0;
-- 
1.8.0

