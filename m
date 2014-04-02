Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbaDBHhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:37:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14709 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbaDBHeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:02 -0400
X-AuditID: cbfee690-b7f266d00000287c-07-533bbd691fcc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: [PATCH 04/10] ARM: EXYNOS: Remove regs-pmu.h file dependency from
 pm_domain
Date: Wed, 02 Apr 2014 16:50:55 +0900
Message-id: <1396425058-4012-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t8zI93MvdbBBis+a1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/Na7GhZzeLA7tHS3MPmsXlJvUffllWMHp83yQWwRHHZpKTm
	ZJalFunbJXBlvDyzmq3gNnfFt99nmBsYP3N2MXJySAiYSLya8YMFwhaTuHBvPVsXIxeHkMAy
	Ronne1azwxQdefObHSKxiFFiSstnKKeNSeLr04usIFVsAroST97PZQaxRQSyJS7NugU2llmg
	WOLb6z6wGmGBMIlLu+YwgtgsAqoS62Y+BdvAK+Au8W3bVqB6DqBtChJzJtmAhDkFPCTut7SA
	lQgBlcy9sZMVZK+EwGR2ib0z+pkh5ghIfJt8CKpXVmLTAWaIoyUlDq64wTKBUXgBI8MqRtHU
	guSC4qT0IhO94sTc4tK8dL3k/NxNjJDAnrCD8d4B60OMyUDjJjJLiSbnAyMjryTe0NjMyMLU
	xNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYQ3a2iSxcxNLOo9GZ
	q2g2+fZ2xeaa3VLfmJ7WdcVOLQz23jLxUmiU25n49zd5nkRVrrwWleX+qc65oq0n45x07bXk
	L+nbul47FPj6Sa5cyKRoO+nEmd8fsw/X2rjPrHLd9CFzorrxl63s6vbyLI/+dLyZkqJ8Zs+9
	KsanFedfn4qRCt6uKzJdiaU4I9FQi7moOBEAYxjNf4ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jAd3MvdbBBu+XqFosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/Na7GhZzeLA7tHS3MPmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHh5ZjVbwW3uim+/zzA3MH7m7GLk5JAQ
	MJE48uY3O4QtJnHh3nq2LkYuDiGBRYwSU1o+s0M4bUwSX59eZAWpYhPQlXjyfi4ziC0ikC1x
	adYtFhCbWaBY4tvrPrAaYYEwiUu75jCC2CwCqhLrZj4F28Ar4C7xbdtWoHoOoG0KEnMm2YCE
	OQU8JO63tICVCAGVzL2xk3UCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx80xq
	B+PKBotDjAIcjEo8vAfOWwULsSaWFVfmHmKU4GBWEuHlnGQdLMSbklhZlVqUH19UmpNafIgx
	GeioicxSosn5wJjOK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5O
	qQbGzdOsFK5tVfCJ+1Zxvamu3sa3Pi1n4uN3B/55cEb+6/N/atkT3eHAf2yX2pMdd4/uvfh/
	m/PVVWHSKzmfXOlfu4Jbwi77+dWUGxubGG+szS/P1+qLvXwzxnzWmtw/iV5i/LbqnzS5K9nt
	zdg3B8Z0LWZL3apyoWHCv3qW3SamW1W2XKkP+KSkxFKckWioxVxUnAgA0o3nPN8CAAA=
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

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |    2 +-
 arch/arm/mach-exynos/regs-pmu.h   |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fe6570e..f676b0a 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -22,7 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/sched.h>
 
-#include "regs-pmu.h"
+#define S5P_INT_LOCAL_PWR_EN 0x7
 
 /*
  * Exynos specific wrapper around the generic power domain
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4ee706d..bfebe84 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -116,7 +116,6 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
-#define S5P_INT_LOCAL_PWR_EN			0x7
 
 #define S5P_CHECK_SLEEP				0x00000BAD
 
-- 
1.7.10.4

