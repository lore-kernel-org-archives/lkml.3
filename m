Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaEJG2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:28:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25093 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaEJG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:28:11 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-e6-536dc6fac949
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 1/3] ARM: dts: Add PMU node to exynos4210
Date: Sat, 10 May 2014 15:46:23 +0900
Message-id: <1399704385-12508-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zI91fx3KDDbauk7JYNukum8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLFo6xd2i9a9R9gt1s94zWKxo2U1iwOXx6ZVnWwem5fU
	e/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG+r1nGQsa2Cqarkk0MP5m6WLk5JAQMJFYtvwI
	O4QtJnHh3nq2LkYuDiGBZYwSV+afY4YputmzhxkisYhRYuHk62DdQgJtTBLtl31AbDYBXYkn
	7+eCFYkItDNK/Lv6EGwUs8BcRonm9gtgO4QFbCQmNnWB2SwCqhJfv3xlArF5BTwkpl5+CRTn
	AFqnIDFnkg1ImFPAU2Ljx8VQyzwkdrQcYgWZKSGwjl2io+0PK8QcAYlvkw+xQPTKSmw6AHW1
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqFecmFtcmpeul5yfu4kREvi9OxhvH7A+xJgMNG4i
	s5Rocj4wcvJK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgXH9MY872W+PTM30973TOZXnt9A//ebE55Mf5Z25rTdtD8vkpamN5TOSY07v9b1VPF02
	KMrd7q8Ec/+tuOXMr09OX3L0qNY/xkeVnYaKDoHa5SltT2ZcO/efM8LnVYPvrqj/Mff0pT6o
	eR2V3Of9yXmWmsrNR3tZfFUlntS4ah4Xc4z73FG587kSS3FGoqEWc1FxIgAhAN1UkgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd1fx3KDDVq2ilksm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvq9ZxkL
	Gtgqmq5JNDD+Zuli5OSQEDCRuNmzhxnCFpO4cG89WxcjF4eQwCJGiYWTr4MVCQm0MUm0X/YB
	sdkEdCWevJ/LDFIkItDOKPHv6kOwDmaBuYwSze0X2EGqhAVsJCY2dYHZLAKqEl+/fGUCsXkF
	PCSmXn4JFOcAWqcgMWeSDUiYU8BTYuPHxVDLPCR2tBxincDIu4CRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcFw9k97BuKrB4hCjAAejEg9v4ducYCHWxLLiytxDjBIczEoivCsO5gYL
	8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4w5vNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0o
	JJCeWJKanZpakFoEs4WJg1OqgdEn61X9ms8Mr0pSvS+fmHiNZfPZK+J5Pbq+JW/vx9c0hNZY
	v//KtbVA0mrn9qSQKwLbAx+8D//IOuvqzP+NxcfP8xzTcGp5JL7HaB6XAmPhzwmavw8u+idy
	bJ7YuqDM5pS+mdmrLUyl96lfSGQz1zo/NXllM5/cpmtTX3aGxLdsiJXfGSKsHajEUpyRaKjF
	XFScCADzGkxy7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pmu regnode to exynos4210 dtsi to handle
PMU register access via DT.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index d3d727b..d23d3f0 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -99,6 +99,11 @@
 		interrupts = <2 2>, <3 2>;
 	};
 
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4210-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+	};
+
 	pinctrl_0: pinctrl@11400000 {
 		compatible = "samsung,exynos4210-pinctrl";
 		reg = <0x11400000 0x1000>;
-- 
1.7.10.4

