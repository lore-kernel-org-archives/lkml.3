Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaEJGij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaEJGi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:27 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-b5-536dc962acdc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 05/11] ARM: EXYNOS: Remove regs-pmu.h header dependency from
 pm_domain
Date: Sat, 10 May 2014 15:56:32 +0900
Message-id: <1399704998-13321-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zI92kk7nBBn8uC1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgynj0eyFrQZdIxZt305gbGG8LdDFyckgImEgcuDmR
	FcIWk7hwbz1bFyMXh5DAMkaJP3tmsMIU/e5bA5WYziixsusEC4TTxiTRfmcyM0gVm4CuxJP3
	c8FsEYFsiSuN95lBipgFdjNKNDbOA2rn4BAWiJboXVQOUsMioCpxY/UuJhCbV8BD4uy7VhaQ
	EgkBBYk5k2xAwpwCnhJfvy4GKxECKnnQvRRspITAKnaJnzO72CHmCEh8m3wIqldWYtMBZoij
	JSUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkLDv38F494D1IcZkoHET
	maVEk/OBcZNXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhhTvD/2XG+f9C7P8IYJz8Vjty0lO978WDJdTl3yzg37AEWztv36dlyf+5bMX6XZODUq
	+KHryU/u+S8vr4ybP5WztITf4PmE8B0Ptu9KFXk4n0uic7m+YcUTVgFjkQV7/JvT36z0+VOQ
	//wr1xUPkbm3Z/x96CklGVZ38v06t9AF0cfe8/Kf2/xFiaU4I9FQi7moOBEAzI/DjpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd2kk7nBBp29PBbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgO5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWY8+r2QtaBL
	pOLNu2nMDYy3BboYOTkkBEwkfvetYYOwxSQu3FsPZHNxCAlMZ5RY2XWCBcJpY5JovzOZGaSK
	TUBX4sn7uWC2iEC2xJXG+8wgRcwCuxklGhvnAbVzcAgLREv0LioHqWERUJW4sXoXE4jNK+Ah
	cfZdKwtIiYSAgsScSTYgYU4BT4mvXxeDlQgBlTzoXso8gZF3ASPDKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgqHomvYNxVYPFIUYBDkYlHt7CtznBQqyJZcWVuYcYJTiYlUR4VxzMDRbi
	TUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDE55XEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QD46Jb1Q520W84Fr3/uWR2naOhwosluqkNBivOsJk1c74pLHku
	5Ff8wnib+87D56REb9zQZYgS4eaMurrQfMc3BS6hPQr3F0sIKD2zLUk1eDbr+x/hNw+98t3r
	LThe77znU3x9i51zOs8XAx1eZlMrNvNLVrm1rr2XAl0mBh9X+82tkOo+2VRdiaU4I9FQi7mo
	OBEAw3Otru4CAAA=
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

