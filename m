Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaD3FCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:02:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38443 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbaD3E7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:44 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-a7-5360833e5b09
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 06/12] ARM: EXYNOS: Remove regs-pmu.h header dependency from
 pm_domain
Date: Wed, 30 Apr 2014 14:17:31 +0900
Message-id: <1398835057-3860-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zA1275oRgg2crRS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZTz6vZC1oEuk4s27acwNjLcFuhg5OSQETCQeHFrL
	CmGLSVy4t56ti5GLQ0hgGaNE49V2Npii3t9TmSESixgllp+9zAiSEBJoY5KYskoBxGYT0JV4
	8n4uM4gtIpAtcaXxPlgDs8BuoEmN88AmCQtES5xsbQYrYhFQlXh+8CU7iM0r4C4x+dJKli5G
	DqBtChJzJtmAhDkFPCQW3v7NCrHLXaKhoYcRZKaEwDp2if+vT7BAzBGQ+Db5EFSvrMSmA8wQ
	R0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCFhP2EH470D1ocYk4HG
	TWSWEk3OB8ZNXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwCu1XzEgrDuA9eGyB+PzPtockYy+9Xj7NTeBR/gGd5ZOsOHKUhJc7yHZtMA8qCuEM
	nLgk69M19QsTA6dbp+XO8LkiOHUlw04L5Yj3dV+qpj6O/d7Xum+2sMwUtb1Mf6Kqp8f8y1p8
	YvXGBZuv19kcchfcuW+XZtktcy3DNMM1lzcGTdp2bJ6krxJLcUaioRZzUXEiANgP3geRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV275oRgg2V/+C2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8x49Hsha0GX
	SMWbd9OYGxhvC3QxcnJICJhI9P6eygxhi0lcuLeerYuRi0NIYBGjxPKzlxlBEkICbUwSU1Yp
	gNhsAroST97PBWsQEciWuNJ4nxmkgVlgN6NEY+M8NpCEsEC0xMnWZrAiFgFViecHX7KD2LwC
	7hKTL61k6WLkANqmIDFnkg1ImFPAQ2Lh7d+sELvcJRoaehgnMPIuYGRYxSiaWpBcUJyUnmuo
	V5yYW1yal66XnJ+7iREcVc+kdjCubLA4xCjAwajEwyuwNT5YiDWxrLgy9xCjBAezkgjv+cqE
	YCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB0Z8Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qt
	A4UE0hNLUrNTUwtSi2C2MHFwSjUwTijTflKZ0x93SVJg7ovc4M2bFi+fYHld/qHp4TMmMx6m
	dDVlVM/rqtE41xbdflfC8trG7t7NyVFlL023Sz1S7e9bbJDU+YLT9b71tXOJGaqdPdGmF/vv
	5EX+9OlmC2+TS5o9d//a/U+O3PucH6PeuYqfUVLCtejlq6Or7y0++6S3kmmCRGOTEktxRqKh
	FnNRcSIAwRVVGO4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

Current "pm_domain.c" file uses "S5P_INT_LOCAL_PWR_EN" definition from
"regs-pmu.h" and hence needs to include this header file. As there is
no other user of "S5P_INT_LOCAL_PWR_EN" definition other than pm_domain,
to remove "regs-pmu.h" header file dependency from "pm_domain.c"  it's
better we define this definition in "pm_domain.c" file itself and thus it
will help in removing header file inclusion from "pm_domain.c".
Also removing "S5P_" prefix from macro.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |    8 ++++----
 arch/arm/mach-exynos/regs-pmu.h   |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fe6570e..e45d288 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -22,7 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/sched.h>
 
-#include "regs-pmu.h"
+#define INT_LOCAL_PWR_EN	0x7
 
 /*
  * Exynos specific wrapper around the generic power domain
@@ -44,13 +44,13 @@ static int exynos_pd_power(struct generic_pm_domain *domain, bool power_on)
 	pd = container_of(domain, struct exynos_pm_domain, pd);
 	base = pd->base;
 
-	pwr = power_on ? S5P_INT_LOCAL_PWR_EN : 0;
+	pwr = power_on ? INT_LOCAL_PWR_EN : 0;
 	__raw_writel(pwr, base);
 
 	/* Wait max 1ms */
 	timeout = 10;
 
-	while ((__raw_readl(base + 0x4) & S5P_INT_LOCAL_PWR_EN)	!= pwr) {
+	while ((__raw_readl(base + 0x4) & INT_LOCAL_PWR_EN)	!= pwr) {
 		if (!timeout) {
 			op = (power_on) ? "enable" : "disable";
 			pr_err("Power domain %s %s failed\n", domain->name, op);
@@ -172,7 +172,7 @@ static __init int exynos4_pm_init_power_domain(void)
 
 		platform_set_drvdata(pdev, pd);
 
-		on = __raw_readl(pd->base + 0x4) & S5P_INT_LOCAL_PWR_EN;
+		on = __raw_readl(pd->base + 0x4) & INT_LOCAL_PWR_EN;
 
 		pm_genpd_init(&pd->pd, NULL, !on);
 	}
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index b68b5cc..fd8a19d 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -116,7 +116,6 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
-#define S5P_INT_LOCAL_PWR_EN			0x7
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
-- 
1.7.10.4

