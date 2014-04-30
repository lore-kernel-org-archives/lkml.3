Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaD3E74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:59:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbaD3E7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:51 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-d9-5360833f7422
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 08/12] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
Date: Wed, 30 Apr 2014 14:17:33 +0900
Message-id: <1398835057-3860-9-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t8zQ1375oRggxNtqhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mr7+eclasIWl4tTFkywNjNeZuxg5OSQETCS23l/N
	BGGLSVy4t56ti5GLQ0hgGaPEkRsnGWGK7nQcYIJILGKUuDP5EDtIQkigjUli2zo2EJtNQFfi
	yfu5YFNFBLIlrjTeZwZpYBbYzSjR2DgPrEhYwE1i3tdGoKkcHCwCqhI/5nqChHkF3CUWvzvG
	BhKWEFCQmDPJBiTMKeAhsfD2b1aIVe4SDQ09jCAjJQTWsUu8b3kKdgOLgIDEt8mHWCB6ZSU2
	HYB6TFLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAn6vh2MNw9YH2JM
	Bho3kVlKNDkfGDV5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoExOLd1vnPZCs3EuVa7Iy7+vVm4Svo8/3U5hu8b9T42xv+QlHtzY29VtP0MniIB
	t9fZ2np9OQc8pEwiNFYkfLgreD7EJpuP2e9btuB3fsGDlxgnZc0sf+gs1bC4TWfaZt2uNpa6
	1dPcjz3aEPtjhkX44ak/KqoWcG3s90xs9bobziEj0tCxgV2JpTgj0VCLuag4EQDRfC7DkAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV375oRgg5cTFS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z4+ucla8EW
	lopTF0+yNDBeZ+5i5OSQEDCRuNNxgAnCFpO4cG89WxcjF4eQwCJGiTuTD7GDJIQE2pgktq1j
	A7HZBHQlnryfC9YsIpAtcaXxPjNIA7PAbkaJxsZ5YEXCAm4S8742MnYxcnCwCKhK/JjrCRLm
	FXCXWPzuGBtIWEJAQWLOJBuQMKeAh8TC279ZIVa5SzQ09DBOYORdwMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4pp5J72Bc1WBxiFGAg1GJh1dga3ywEGtiWXFl7iFGCQ5mJRHe85UJ
	wUK8KYmVValF+fFFpTmpxYcYk4FumsgsJZqcD4z3vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7Za
	BwoJpCeWpGanphakFsFsYeLglGpgjHhs+fuh1pe7d/cLbDTheXwvks9ihWDDds+t77czJc5g
	XvImzzxH6O6HTI2HypO89C8vmvncN80tyLCyNGnnChn78DXTF2p8K99wodjMP6OaLaPP5aPb
	9hVVrF/e5b/L+Sn5Mmrtm8c/CgwjP0Wv4N9csYib333mXsWr+d7L57pdeNGyRbjjjBJLcUai
	oRZzUXEiADa47fftAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary header file inclusion from pmu.c.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 05c7ce1..4c3453a 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -11,7 +11,6 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/bug.h>
 
 #include <plat/cpu.h>
 
-- 
1.7.10.4

