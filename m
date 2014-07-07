Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaGGDx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35216 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaGGDxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:44 -0400
X-AuditID: cbfee690-b7fb56d000003439-cc-53ba19c62ed2
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 5/6] ARM: EXYNOS: Remove regs-pmu.h header dependency from
 pm_domain
Date: Mon, 07 Jul 2014 09:20:55 +0530
Message-id: <1404705056-11965-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSq3tMclewwbW7BhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx9ftKtoIlwhWLZ79jaWD8zd/FyMkhIWAi
	cffEZjYIW0ziwr31QDYXh5DAUkaJ9RNmMcEU/Z9zHKxISGA6o8TDpYkQRROYJBZeec8IkmAT
	0JV48n4uM4gtIpAt0X97NQtIEbPAKUaJ2ZunsYMkhAUiJfa37wSzWQRUJV439YNt4BXwkDiw
	dhbQBg6gbQoScybZgIQ5BTwllnyYxAyx2EPi7rlDjCAzJQTWsUs8mLIKao6AxLfJh1ggemUl
	Nh1ghjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjIDT/55N2MF4
	74D1IcZkoHETmaVEk/OBEZRXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYz8zHxifG+rnJ4dKO8wn8VkLvZm54U7j3jj3oa/ZNr/9VbxLH1T5XUf
	S9nuGHy3XLIm97Rzful3PuVbeca/S15v3zPp4Y5kM+k7HCE2z+ZpZHsyqsw+Y3TqZ6Tm1hg+
	iz+1eler3s6evSFx0+xZHPzhf1ev9vt/svHJtfSw9Z4WS8vrspfVzVdXYinOSDTUYi4qTgQA
	TOJp5pYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd1jkruCDQ4eV7dYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGVO/
	r2QrWCJcsXj2O5YGxt/8XYycHBICJhL/5xxng7DFJC7cWw9mCwlMZ5R4uDSxi5ELyJ7AJLHw
	yntGkASbgK7Ek/dzmUFsEYFsif7bq1lAipgFTjFKzN48jR0kISwQKbG/fSeYzSKgKvG6qZ8J
	xOYV8JA4sHYW0AYOoG0KEnMm2YCEOQU8JZZ8mMQMsdhD4u65Q4wTGHkXMDKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAiOr2fSOxhXNVgcYhTgYFTi4T2wamewEGtiWXFl7iFGCQ5mJRHe
	M25AId6UxMqq1KL8+KLSnNTiQ4ymQEdNZJYSTc4Hxn5eSbyhsYm5qbGppYmFiZmlkjjvwVbr
	QCGB9MSS1OzU1ILUIpg+Jg5OqQZGvtLM38/meAR8VPHM2L1hgiQ3U/wf3YgY/TNncu83f80T
	nWu4pUWmOG+i0+qXUt9s37Sem6Y7R+dDiMVhy8nTPxxbeXyfgmZWl4h13+tX0w0WbrOTy0ou
	CZAoEJ6svttl82rOOLNnPWtZmXbe37uVzeTb3t9n396ROvNALCBqoWPD2r0eqimvlViKMxIN
	tZiLihMBCQUiAcUCAAA=
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
index e6fa6cf..e5e298c 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -128,7 +128,6 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
-#define S5P_INT_LOCAL_PWR_EN			0x7
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
-- 
1.7.9.5

