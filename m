Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3DWC5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:57:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42253 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3DWC5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:57:53 -0400
X-AuditID: cbfee68f-b7feb6d000003f6c-60-5175f8b0e921
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] perf: Fix error return code
Date: Tue, 23 Apr 2013 11:57:51 +0900
Message-id: <007001ce3fce$58768be0$0963a3a0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA5ig4A==
Content-language: ko
x-cr-hashedpuzzle: DxeC OECB Olmy PPpE TYHK ThrQ Tq85 Y8Am dwj7 gz86 hDnQ kcdw
 mXJ/ oLnR s4ME
 s/52;5;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGoAaABiAGkAcgBkAC4AYwBoAG8AaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAeQBvAG4AZwBqAHUAbgBfAHcAZQBpAEAAdAByAGUAbgBkAG0AaQBjAHIAbwAuAGMAbwBtAC4AYwBuAA==;Sosha1_v1;7;{917AEF4B-56D4-4052-BE63-EFC09F31CF9E};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Tue,
 23 Apr 2013 02:57:43
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOAAtAHMAdABhAGIAbABlAF0AIABwAGUAcgBmADoAIABGAGkAeAAgAGUAcgByAG8AcgAgAHIAZQB0AHUAcgBuACAAYwBvAGQAZQA=
x-cr-puzzleid: {917AEF4B-56D4-4052-BE63-EFC09F31CF9E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zY90NP0oDDW4fEbC42HaRzWJJM7fF
	5V1z2CwWbHzEaLFzXSe7A6vHlaccHn1bVjF6LL13lNHj8ya5AJYoLpuU1JzMstQifbsEroy2
	ld0sBcc4K9bsP83cwNjD0cXIySEhYCJxo/cHM4QtJnHh3nq2LkYuDiGBZYwSc44tZYIpmn3+
	EgtEYjqjxIxdX1khnL+MEvPmzGADqWIT0JU4tn4LK4gtIuAtcWrKL6CxHBzMAmUSDfuzQEwh
	AW6J1c1BIBWcAjwS6/50gi0WFjCXaN53hB3EZhFQldjW+RpsIq+AncSsqdOhbEGJH5PvsYDY
	zAJaEut3HmeCsOUlNq95C7ZJQkBd4tFfXYgDnCTOrXzEClEiIrHvxTtGkIslBK6wSuz5coQN
	4i9Tibub2lkgEh/ZJc4/a2aGOEJA4tvkQywQQ2UlNh2ABpCkxMEVN1gmMErNQnLSLCQnzUJy
	0iwkuxcwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECInl/h2Mdw9YH2JMBlo/kVlKNDkf
	mArySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAo
	unJT0QSfO8LczPbHF7v4BiV39D688ezvwj9OvmInNq7Ks43pF4q//3ORoeXN+8ImCu1vYm0u
	GNuvUvyZxf/Hj2Ey9zfFCyyTAze73fv+5OaivIY2zf6fzNdiBL4zZ9gkBEdGdYneVPCXb7mc
	eqNEqHnemlnz46bLnPm871bJpimXP+cnry1SYinOSDTUYi4qTgQAtFBEmvsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd0NP0oDDd6v57G42HaRzWJJM7fF
	5V1z2CwWbHzEaLFzXSe7A6vHlaccHn1bVjF6LL13lNHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMtpXdLAXHOCvW7D/N3MDYw9HFyMkhIWAiMfv8JRYIW0zi
	wr31bF2MXBxCAtMZJWbs+soK4fxllJg3ZwYbSBWbgK7EsfVbWEFsEQFviVNTfjF3MXJwMAuU
	STTszwIxhQS4JVY3B4FUcArwSKz708kMYgsLmEs07zvCDmKzCKhKbOt8DTaRV8BOYtbU6VC2
	oMSPyffA7mEW0JJYv/M4E4QtL7F5zVuwTRIC6hKP/upCHOAkcW7lI1aIEhGJfS/eMYJcLCFw
	hVViz5cjbBB/mUrc3dTOMoFRZBaSFbOQrJiFZMUsJLMWMLKsYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAhOFM+kdjCubLA4xCjAwajEwyvgXhooxJpYVlyZe4hRgoNZSYRXNB8oxJuSWFmV
	WpQfX1Sak1p8iDEZGAITmaVEk/OBSSyvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp
	2ampBalFMFuYODilGhhXrbnPNeN0sDUDr2mF/PcYT+Oniam++3dLFvT8PKF6WqRvVw97VEL3
	9cQO/7Vqfx4nbogQMzH4siX4hae3kODWO5E/Dk96erlW9ilzIrtIUHjJrC8qoQtSXgv2P5Ju
	PhllJjzB/LOUcI+fuPAOR94nsRqWW2+em+8x32ujy6Z3B0UC5s6JWafEUpyRaKjFXFScCAC6
	UP3kWAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"

commit c481420248c6730246d2a1b1773d5d7007ae0835 upstream.

Fix to return -ENOMEM in the allocation error case instead of 0
(if pmu_bus_running == 1), as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link:
http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DNTPU08
c2w1tngQ@mail.gmail.com
[ Tweaked the error code setting placement and the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 kernel/events/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b6646a..f6eba58 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5988,6 +5988,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
-- 
1.7.9.5

