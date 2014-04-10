Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965979AbaDJKOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:14:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaDJKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:56 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-bb-53466d249c8c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 22/27] ARM: dts: exynos3250: Add amba and pdma dt node
Date: Thu, 10 Apr 2014 19:06:12 +0900
Message-id: <1397124377-16969-14-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkRFcl1y3YYP8zS4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mr433ObrWAKd8WDC+UNjK85uhg5OSQETCQeTmxm
	gbDFJC7cW8/WxcjFISSwlFGi69xNZpiixgN9zBCJRYwSryZeZYRwmpgkOl+vYwWpYhPQktj/
	4gYbiC0iECDx4/g7MJtZ4CajxLH3YSC2sICbRNvNvWBTWQRUJU49ngG2mhco/n71Iagz5CQ+
	7HnEDmJzAsVnLjoJNkdIwFWi59FFsCskBFaxS+zZ/IsFYpCAxLfJIM0cQAlZiU0HoK6WlDi4
	4gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECA//0v2e9OxhvH7A+xJgMNG4i
	s5Rocj4wcvJK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgfFWu2vJ+5bd6Wp3T+WVHHErtlL0Olxb90JncpZxeLO8cdfHyzpmUndeGU7KK/VJlOox
	tRY//+lp+x4P3cuPko0EJqx4wHPMuHC1+ZT/lwSaVA6l/Zlpa8Lb4sWnNq+a1/u7ZYeeRKn3
	Cje/E1wn+Jp22F15whJb3yrw+J7N6kUpqq37DqosVGIpzkg01GIuKk4EANkZTrSSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2VXLdggxvzDC2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxv+e22wF
	U7grHlwob2B8zdHFyMkhIWAi0XigjxnCFpO4cG89WxcjF4eQwCJGiVcTrzJCOE1MEp2v17GC
	VLEJaEnsf3GDDcQWEQiQ+HH8HZjNLHCTUeLY+zAQW1jATaLt5l6wqSwCqhKnHs9gAbF5geLv
	Vx9igdgmJ/FhzyN2EJsTKD5z0UmwOUICrhI9jy4yT2DkXcDIsIpRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOK6eSe1gXNlgcYhRgINRiYf3wDLXYCHWxLLiytxDjBIczEoivLsz3YKFeFMS
	K6tSi/Lji0pzUosPMSYDXTWRWUo0OR8Y83kl8YbGJmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwOjvuVfsWu6DB/f3rLbX7D68tiG8rjLmtZJb1fTu7ZHXH3CfsJWM
	7dZr46wOmG0suarw/tmrHg0mPrcW1Yod+vK6QP3+g4TFGWXnVGKt9fW3/X+x5O7jgsyXa7c5
	Prr81XIt45vfJXdPVr/feVGK68x7+Wvtz/f8q0ve+jX+5OldFq/lVP/ZyzIpsRRnJBpqMRcV
	JwIAsqdwgO8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add amba and pdma dt node to support bus on Exynos3250.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2f0ca32..b8e5ae13 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -148,6 +148,36 @@
 		status = "disabled";
 	};
 
+	amba {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "arm,amba-bus";
+		interrupt-parent = <&gic>;
+		ranges;
+
+		pdma0: pdma@12680000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0x12680000 0x1000>;
+			interrupts = <0 138 0>;
+			clocks = <&cmu CLK_PDMA0>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+
+		pdma1: pdma@12690000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0x12690000 0x1000>;
+			interrupts = <0 139 0>;
+			clocks = <&cmu CLK_PDMA1>;
+			clock-names = "apb_pclk";
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <32>;
+		};
+	};
+
 	adc: adc@126C0000 {
 		compatible = "samsung,exynos-adc-v2";
 		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
-- 
1.8.0

