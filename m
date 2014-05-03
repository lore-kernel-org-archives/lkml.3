Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaECFxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:53:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48667 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaECFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:53:38 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-de-5364846022bb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 2/4] ARM:  EXYNOS: remove unused header inclusion from hotplug.c
Date: Sat, 03 May 2014 15:11:38 +0900
Message-id: <1399097500-4052-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zA92ElpRgg7s3DCx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rx+zKvxaKtX9gt1s94zeLA7tHS3MPmsXlJvUffllWMHp83yQWwRHHZpKTm
	ZJalFunbJXBlbFi1gblgP0vF9A0P2RsYHzB3MXJySAiYSDw7epQdwhaTuHBvPRuILSSwjFFi
	8a14mJot7RNYuhi5gOLTGSXm7X7JCOG0MUncXrSNEaSKTUBX4sn7uWBTRQSyJa403gezmQUK
	JE7PvQJWIywQILFoCsRmFgFViZ0bjoBt4xVwl1izdiprFyMH0DYFiTmTbEDCnAIeEl8e7oI6
	yF1i9vyJYHslBPrZJb5OfsgKMUdA4tvkQywQvbISmw5APSYpcXDFDZYJjMILGBlWMYqmFiQX
	FCelFxnrFSfmFpfmpesl5+duYoSEdf8OxrsHrA8xJgONm8gsJZqcD4yLvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGOn/zurVEfNinQnWQgvV
	Jt6/86ZM1n32v9/JKsrnL20M1P2T+XZvreGOnGcei55ffv3A+4L3qmjO0++45PZXPwxZUvRD
	7P20zw5cZdIMNuFvOWcbSZ106Q3kjlZfnl9r7ux7QXSFurnbEvHNxmvZT6gJdDtOFdviq5WW
	MWXSFdsJJ62CKwx/K7EUZyQaajEXFScCANsH61SBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd2ElpRgg9l/dSx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rx+zKvxaKtX9gt1s94zeLA7tHS3MPmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNiwagNzwX6WiukbHrI3MD5g7mLk5JAQ
	MJHY0j6BBcIWk7hwbz1bFyMXh5DAdEaJebtfMkI4bUwStxdtYwSpYhPQlXjyfi5Yt4hAtsSV
	xvtgNrNAgcTpuVfAaoQFAiQWTYHYwCKgKrFzwxE2EJtXwF1izdqprF2MHEDbFCTmTLIBCXMK
	eEh8ebgLrEQIqGT2/ImMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjptnUjsY
	VzZYHGIU4GBU4uFVuJscLMSaWFZcmXuIUYKDWUmEl0UzJViINyWxsiq1KD++qDQntfgQYzLQ
	UROZpUST84ExnVcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jFOjZnz72v3Ot/iQ5B75LTPk1mRER8wMcc4ITtp8Qzphp9YzJ/HQ9zaO+6L/tYR4Mew/+quc
	bUvGf69HhUt5u9mqlEp8A8Kk7c6nhLc3zn7xyd9n4qR3vEp9D16tLerfs+PSth35bMekrZlY
	93jvcnJgu/bofy3Ls7W+H0XdX4dPe8Ygxr51qhJLcUaioRZzUXEiAH1Kb63fAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removed "plat/cpu.h" inclusion from hotplug.c as it
is not required.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 0243ef3..5e19601 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -19,8 +19,6 @@
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
 
-#include <plat/cpu.h>
-
 #include "common.h"
 #include "regs-pmu.h"
 
-- 
1.7.10.4

