Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaD0HkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41676 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaD0Hiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:38:51 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-dd-535cb40adbc2
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 01/31] iommu/exynos: do not include removed header
Date: Sun, 27 Apr 2014 13:07:33 +0530
Message-id: <1398584283-22846-2-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkTpdrS0ywwcPZvBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8axRw1s
	BdvZK062SzQwzmfrYuTkkBAwkVjf2ssIYYtJXLi3HijOxSEksJRR4tLaScwwRdMffWWGSCxi
	lFi57Do7hDOBSWLazRWsIFVsAoYS2+9dYQVJiAisZpTou3gGrIpZ4C6TxJxV78CWCAu4SVw+
	0cMCYrMIqEr0zJoG1s0r4C5xpfc5UJwDaJ+CxJxJNiBhTgEPiSd39oCVCwGVvD31BWyBhMBU
	DomOP38ZIeYISHybfAiqV1Zi0wGosyUlDq64wTKBUXgBI8MqRtHUguSC4qT0ImO94sTc4tK8
	dL3k/NxNjMB4PP3vWf8OxrsHrA8xJgONm8gsJZqcD4znvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	7z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyDOV793TyXYXoo6dzXc3eznLMClW58E2
	pX+3p+vMuXuhXu3izFMRhz93MX1YxDUnf67Zsgevm17Ol7mRxXXQl8G6I+7k9ha9zcK75Z51
	VRSblOZbee+XjrJNjazbM8MkxnzeR80LHUUT/XoFC8zf9a7ct7Q0NFE4fk1iovWt8v0bPnRF
	TtpcrMRSnJFoqMVcVJwIADstLtjdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV2uLTHBBvukLe7cPcdqMf8IkHh1
	5AeTxYL91hadszewW3zf9YXdonfBVTaLTY+vsVpc3jWHzWLG+X1MFhdWbGS3+Nd7kNFiyqLD
	rBaH37SzWpz808to0XK9l8li/YzXLBardv1htJh5aw2Lg7DHk4PzmDxmN1xk8fh3uJ/JY+es
	u+wed67tYfPYvKTeY/KN5YwefVtWMXp83iTnceXoGaYArqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoM+UFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYQ1jBnHHjWwFWxnrzjZLtHAOJ+ti5GTQ0LARGL6o6/MELaYxIV764Hi
	XBxCAosYJVYuu84O4Uxgkph2cwUrSBWbgKHE9ntXWEESIgKrGSX6Lp4Bq2IWuMskMWfVO0aQ
	KmEBN4nLJ3pYQGwWAVWJnlnTwLp5BdwlrvQ+B4pzAO1TkJgzyQYkzCngIfHkzh6wciGgkren
	vrBOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM41p9J72Bc1WBxiFGAg1GJh/eH
	dEywEGtiWXFl7iFGCQ5mJRFezulAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HpqG8knhD
	YxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDkdxR5dHzTst5nUj/f
	7zr8xkIra77qPslfC3xOP++aYWv/hsWRs2K3xMbUxw3sZibmMc7pIU7mZlWs2juuHp9qdHBO
	e8jMHbfPZh7cerLPcsVeqQf8VTUtNzS+Gb9iZpy09v2qhrurj1+65uZwqlG4SOTUG3HVbo81
	m4vX8R3WWuTVsSVGp3i9EktxRqKhFnNRcSIADT/KXDkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
removing remaining use of it from exynos-iommu driver, thus causing a
compilation error.

This patch fixes the error by removing respective include line
from exynos-iommu.c.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0740189..46f0ca1 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -29,8 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
-
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
-- 
1.7.9.5

