Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaCLGU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:20:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbaCLGTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:24 -0400
X-AuditID: cbfee68f-b7f156d00000276c-e2-531ffc6a79fb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/5] ARM: dts: exynos: Move common dt data for interrupt
 combiner controller
Date: Wed, 12 Mar 2014 15:19:15 +0900
Message-id: <1394605156-7768-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkWDf7j3ywwdUORovrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi1cE2Fov1
	M16zOPB6rJm3htGjpbmHzWPl8i9sHpuX1Hv0bVnF6PF5k5zHxrmhAexRXDYpqTmZZalF+nYJ
	XBnr1y5mLbglUbHl0BLmBsa1wl2MHBwSAiYSMycadTFyApliEhfurWfrYuTiEBJYyijx5txF
	ZoiEicSx1qvMEInpjBIPzpxggnAamSQW/DrCAlLFJqAlsf/FDTYQW0RAV2LKzDusIDazwDEm
	iRNTHUBsYYEEiZs3z4BNZRFQlThzZTpYL6+Ai8T6ljWMENvkJD7secQOch2ngKvEhnnJIGEh
	oJLjH4+ygOyVELjELjG97yMbxBwBiW+TD7FAfCMrsekA1NGSEgdX3GCZwCi8gJFhFaNoakFy
	QXFSepGxXnFibnFpXrpecn7uJkZgvJz+96x/B+PdA9aHGJOBxk1klhJNzgfGW15JvKGxmZGF
	qYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDRa0Hbx2Dyt3jg2
	r9RXTD/SK4Mauu8+UrjiPXmnvZ5cmFncU17DOQIT1BaUfAi4y1MR2i3LvOK0Yjj7hkOn1D74
	3GEUYQ09yNkzn1fixuKbs8592/avunr9snuXsvwnpBi2i/BOOGInrXzI/vWby7JXVu46e/fz
	cuvna7mPbF/BFtvlp/+77LISS3FGoqEWc1FxIgA9GFkprQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd2sP/LBBsdumlpc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWrw62sVis
	n/GaxYHXY828NYweLc09bB4rl39h89i8pN6jb8sqRo/Pm+Q8Ns4NDWCPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsX7tYtaCWxIVWw4tYW5gXCvcxcjJISFgInGs9Soz
	hC0mceHeerYuRi4OIYHpjBIPzpxggnAamSQW/DrCAlLFJqAlsf/FDTYQW0RAV2LKzDusIDaz
	wDEmiRNTHUBsYYEEiZs3z4BNZRFQlThzZTpYL6+Ai8T6ljWMENvkJD7secTexcjBwSngKrFh
	XjJIWAio5PjHoywTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOx2dSOxhXNlgc
	YhTgYFTi4V2gKR8sxJpYVlyZe4hRgoNZSYT3I0iINyWxsiq1KD++qDQntfgQYzLQUROZpUST
	84GpIq8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGDd2FU/t
	lb0fb/xCieuLvvTGJQ8ks+/Wtfe5tT9IP3mO/bPrzWcRW7w+f7w9o9QzwfUe++Z3E72M6n/n
	hS18dVbxkMqJkhcWZXU8TCZapUm+xwNEuqq5tv1S54/YsWG1x+6yN095qqLtr5SVK3ClRmq1
	d2VMPPliSfbxiftvdUoEyCxneTJFXYmlOCPRUIu5qDgRACZVBXsLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move common dt data of interrupt combiner controller to
exynos4x12.dtsi. Each Exynos4x12 SoC has different number of interrput combiner
as following:
- Exynos4212 : interrput combiner 18(0 ~ 17)
- Exynos4412 : interrput combiner 20(0 ~ 19)

The exynos combiner driver initialize interrupt according to specific number
of interrput combiner.
- samsung,combiner-nr : The number of interrput combiners supported.

Also,
This patch arrange again the dt data according to register address
in exynos4212/exynos4412.dtsi.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi | 13 ++++---------
 arch/arm/boot/dts/exynos4412.dtsi | 14 ++++----------
 arch/arm/boot/dts/exynos4x12.dtsi |  8 ++++++++
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 94a43f9..ceefc71 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -22,16 +22,11 @@
 / {
 	compatible = "samsung,exynos4212";
 
-	gic: interrupt-controller@10490000 {
-		cpu-offset = <0x8000>;
+	combiner: interrupt-controller@10440000 {
+		samsung,combiner-nr = <18>;
 	};
 
-	interrupt-controller@10440000 {
-		samsung,combiner-nr = <18>;
-		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
-			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
-			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
-			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
-			     <0 107 0>, <0 108 0>;
+	gic: interrupt-controller@10490000 {
+		cpu-offset = <0x8000>;
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 87b339c..a40b6e2 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -22,17 +22,11 @@
 / {
 	compatible = "samsung,exynos4412";
 
-	gic: interrupt-controller@10490000 {
-		cpu-offset = <0x4000>;
-	};
-
-	interrupt-controller@10440000 {
+	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <20>;
-		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
-			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
-			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
-			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
-			     <0 107 0>, <0 108 0>, <0 48 0>, <0 42 0>;
 	};
 
+	gic: interrupt-controller@10490000 {
+		cpu-offset = <0x4000>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index a1e76ec..c4a9306 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -68,6 +68,14 @@
 		};
 	};
 
+	combiner: interrupt-controller@10440000 {
+		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
+			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
+			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
+			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
+			     <0 107 0>, <0 108 0>, <0 48 0>, <0 42 0>;
+	};
+
 	pinctrl_0: pinctrl@11400000 {
 		compatible = "samsung,exynos4x12-pinctrl";
 		reg = <0x11400000 0x1000>;
-- 
1.8.0

