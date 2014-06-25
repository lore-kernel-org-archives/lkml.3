Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaFYMuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:50:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47843 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaFYMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:50:09 -0400
X-AuditID: cbfee68f-b7fef6d000003970-da-53aac57fb2c3
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 5/6] ARM: EXYNOS: Remove regs-pmu.h header dependency from
 pm_domain
Date: Wed, 25 Jun 2014 18:15:41 +0530
Message-id: <1403700342-9678-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403700342-9678-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSrVt/dFWwwesDphbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXRe/wyU8ES4YrH0/QaGH/zdzFyckgImEgs
	eXOMDcIWk7hwbz2QzcUhJLCUUeJry0tmmKLTb+YwQiSmM0rc3befBcKZwCRxedFssHY2AV2J
	J+/ngnWICGRL9N9eDVbELHCKUWL25mnsIAlhgUiJ/o4lYDaLgKrEtHt7WEBsXgF3iYu79wEN
	4gBapyAxZ5INSJhTwEPi0aIbYCVCQCUdDX/ZQWZKCKxjl5i1+hYbxBwBiW+TD7FA9MpKbDoA
	dbWkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREYAaf/PevfwXj3gPUh
	xmSgcROZpUST84ERlFcSb2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGIN5XbZELFq54m780q/biy5NK/l5kFf360zlaa4pBpru757OiGFmU3tZXrUi
	xzh+QbgmW8SRL9fD/ny/tOaRE1NW/9Vkxm1tL/kD/287VrL90dYdDsV8Apu3XFtp7iBRk3qS
	9/pd27rXrRc7k+0/Xgl7uGBlUPcJuR3S26KOfWEKdJGx37lb1liJpTgj0VCLuag4EQBboQsV
	lgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd36o6uCDb5M1bVYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGb3H
	LzMVLBGueDxNr4HxN38XIyeHhICJxOk3cxghbDGJC/fWs3UxcnEICUxnlLi7bz8LhDOBSeLy
	otlsIFVsAroST97PZQaxRQSyJfpvrwYrYhY4xSgxe/M0dpCEsECkRH/HEjCbRUBVYtq9PSwg
	Nq+Au8TF3fuABnEArVOQmDPJBiTMKeAh8WjRDbASIaCSjoa/7BMYeRcwMqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECI6vZ1I7GFc2WBxiFOBgVOLhvTB7ZbAQa2JZcWXuIUYJDmYlEV73
	/auChXhTEiurUovy44tKc1KLDzGaAh01kVlKNDkfGPt5JfGGxibmpsamliYWJmaWSuK8B1qt
	A4UE0hNLUrNTUwtSi2D6mDg4pRoYJTlE//+XjM41WzlTrvvUl87bJ3butil6uydBaDnTd6n4
	i4GnPG6yB7XLRDHNPxAfeZp7pYnstSPTKqwvfzrmnJb21/ar1Jmgg6EO1Zo51s72pW6BYWec
	UkL23bh+7J/UgYgZGXuucx9SKshsXh22PuXpnEtec/XN62PXMvKIu7fzqr4QFdytxFKckWio
	xVxUnAgApuR3rcUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current "pm_domain.c" file uses "S5P_INT_LOCAL_PWR_EN" definition from
"regs-pmu.h" and hence needs to include this header file. As there is
no other user of "S5P_INT_LOCAL_PWR_EN" definition other than pm_domain,
to remove "regs-pmu.h" header file dependency from "pm_domain.c"  it's
better we define this definition in "pm_domain.c" file itself and thus it
will help in removing header file inclusion from "pm_domain.c".
Also removing "S5P_" prefix from macro.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |    8 ++++----
 arch/arm/mach-exynos/regs-pmu.h   |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fe6570e..bcd8dcf 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -22,7 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/sched.h>
 
-#include "regs-pmu.h"
+#define INT_LOCAL_PWR_EN       0x7
 
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
+	while ((__raw_readl(base + 0x4) & INT_LOCAL_PWR_EN) != pwr) {
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
index 790af14..1993e6b 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -126,7 +126,6 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
-#define S5P_INT_LOCAL_PWR_EN			0x7
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
-- 
1.7.9.5

