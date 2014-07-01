Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaGAAkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:40:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22489 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaGAAkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:40:14 -0400
X-AuditID: cbfee68f-b7fef6d000003970-fa-53b2036b0adf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, ben-linux@fluff.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: dts: Add TMU dt node to monitor the temperature for
 Exynos3250
Date: Tue, 01 Jul 2014 09:40:10 +0900
Message-id: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkQDebeVOwwYSn1haT1h1gsrj+5Tmr
	xfwj51gt+t8sZLU492olo0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi6fWLTBYT
	pq9lsWjde4TdYv2M1ywO/B5r5q1h9Ghp7mHzuNzXy+Txd9ULZo+Vy7+weWxa1cnmsXlJvUff
	llWMHp83yQVwRnHZpKTmZJalFunbJXBlzPp7hrFgKkfF7B+zGBsYL7N1MXJySAiYSFz5dYQF
	whaTuHBvPVCci0NIYCmjxKeDj9lhimYd/cMOkVjEKNFzbzojhNPEJDHtz2OwdjYBLYn9L26A
	jRURkJRoavjDDFLELNDCLPG45TBTFyMHh7BAmETjawWQGhYBVYn1vQ1MIDavgIvEshnPWCG2
	yUl82PMIbJuEwDV2iY/bpzNBNAhIfJt8iAVkjoSArMSmA8wQ9ZISB1fcYJnAKLiAkWEVo2hq
	QXJBcVJ6kbFecWJucWleul5yfu4mRmC0nP73rH8H490D1ocYk4HGTWSWEk3OB0ZbXkm8obGZ
	kYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg9Nx0kl3kqFm3
	T3ajFY+Yf8yshg3ef37cPrL29iVp1R0fUvIsGLmiXZM/NzZVpMvPNf149H91TEbwCaGYO5eK
	dTSqXLwNbp9yzD9ics/K+16WuiC/HJd7oYP+tns2s3ITbTyUGiqXtYUkXNiskR8tNttYK+7B
	eZ198hPWivzbsPLbr6MZqx2VWIozEg21mIuKEwE8pur4rAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd1s5k3BBmeXmlhMWneAyeL6l+es
	FvOPnGO16H+zkNXi3KuVjBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6LpdcvMllM
	mL6WxaJ17xF2i/UzXrM48HusmbeG0aOluYfN43JfL5PH31UvmD1WLv/C5rFpVSebx+Yl9R59
	W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkD9IGSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPW3zOMBVM5
	Kmb/mMXYwHiZrYuRk0NCwERi1tE/7BC2mMSFe+uB4lwcQgKLGCV67k1nhHCamCSm/XnMAlLF
	JqAlsf/FDbBuEQFJiaaGP8wgRcwCLcwSj1sOM3UxcnAIC4RJNL5WAKlhEVCVWN/bwARi8wq4
	SCyb8YwVYpucxIc9j9gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREci8+kdzCu
	arA4xCjAwajEw3uidmOwEGtiWXFl7iFGCQ5mJRHe/B9AId6UxMqq1KL8+KLSnNTiQ4ymQNsn
	MkuJJucD00ReSbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG9oNu
	Loyxt4/fu+UeNPvwoWmZunXTzjnMOb9cRbloQt2xpPcqKfdyH32IlVnqf3J1f9SXrw5Lte4c
	/3FfI3S2v55vfZCm2iznMtMadYbAKZdePkiMjZsXs/zagf/zmacUv2qS2Bn94M1ifZEts+Kr
	vTNZW4Vlbgft/izc/dWx4lmILsPejG99SizFGYmGWsxFxYkAqU73q9sCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add TMU (Thermal Management Unit) dt node to monitor the high
temperature for Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch has a dependency on following patch [1]:
 [1] https://lkml.org/lkml/2014/6/30/805

 arch/arm/boot/dts/exynos3250.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3660cab..1e566af 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -192,6 +192,16 @@
 			status = "disabled";
 		};
 
+		tmu: tmu@100C0000 {
+			compatible = "samsung,exynos3250-tmu";
+			interrupt-parent = <&gic>;
+			reg = <0x100C0000 0x100>;
+			interrupts = <0 216 0>;
+			clocks = <&cmu CLK_TMU_APBIF>;
+			clock-names = "tmu_apbif";
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@10481000 {
 			compatible = "arm,cortex-a15-gic";
 			#interrupt-cells = <3>;
-- 
1.8.0

