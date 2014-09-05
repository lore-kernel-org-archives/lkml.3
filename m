Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaIEEad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:30:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaIEEa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:27 -0400
X-AuditID: cbfee68e-f79536d000000fd1-4a-54093c5fda4b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 3/5] ARM: dts: Add PPMU dt node for Exynos3250
Date: Fri, 05 Sep 2014 13:30:17 +0900
Message-id: <1409891419-28560-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWDfehjPEYO4+CYvHaxYzWWycsZ7V
	4vqX56wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLN78OMtk8XjFW3aL
	Vbv+MDrweuycdZfdY/Gel0wem5fUe/RtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDKe
	3n7DXLBOtOJ490XGBsY3Al2MnBwSAiYS5zqnMkLYYhIX7q1n62Lk4hASWMoocftBC3sXIwdY
	0YqTnhDx6YwSbyZcYoVwmpgkTm15AdbNJqAlsf/FDTYQW0TATGLfjr9gRcwCO5gkrh34AVYk
	LOAksX/7dDCbRUBV4u7+n8wgG3gFXCXWT2eBuEJO4sOeR+wgNqeAm8Ta+9eYQGwhoJKLxycx
	g8yUEDjHLnHxxAZmiDkCEt8mH2KBuFRWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqR
	kV5xYm5xaV66XnJ+7iZGYKyc/vesbwfjzQPWhxgFOBiVeHgXfOYIEWJNLCuuzD3EaAq0YSKz
	lGhyPjAi80riDY3NjCxMTUyNjcwtzZTEeROkfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YMwTtnKW99r0TC5cbU6M6DdPn+RKtgfMc2+FtM0t5sibO5ft0LLN2xrdpnrIz/JOOGqpN23/
	Pv+Tqy9emNE/P2G50VaJm+vb9rVFJPqprrdRy1b0fMGRN+dVjoV9nGx0Xx5fZ3Pn7qQJKT2/
	119bacTLvyp473nnfXsEzk98GW2x/G+w6vNGCyWW4oxEQy3mouJEAGsFjCiQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jQd14G84QgyOzhSwer1nMZLFxxnpW
	i+tfnrNa9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCxuN65gs3jz4yyTxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOY8fT2G+aCdaIVx7svMjYwvhHoYuTgkBAwkVhx0rOLkRPI
	FJO4cG89WxcjF4eQwHRGiTcTLrFCOE1MEqe2vGAEqWIT0JLY/+IGG4gtImAmsW/HX7AiZoEd
	TBLXDvwAKxIWcJLYv306mM0ioCpxd/9PZpBtvAKuEuuns0Bsk5P4sOcRO4jNKeAmsfb+NSYQ
	Wwio5OLxScwTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOxGdSOxhXNlgcYhTg
	YFTi4V3wmSNEiDWxrLgy9xCjBAezkgiv1xugEG9KYmVValF+fFFpTmrxIUZToKMmMkuJJucD
	k0ReSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZG/2N/xGe2vXZm
	kLis87a39/5S9ZSJS58eXbjuVPOlA3yx7y0mKu/LPDl9nvSHU4W2RV9Xd9npTD+6+LfKK2N+
	gY0epRpLEj6laZ+x2L6eOf1BUYezSVNveJi+z/qKZ09KuUxO6QRyOXOEz7htz3Ur/bgSw6Uf
	67OSrmz+++TSm8qkMqEpGzS5lViKMxINtZiLihMBvqHkjtoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Performance Profiling Monitoring Units) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0	0x106a0000
- PPMU_DMC1	0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_3D       0x13220000
- PPMU_MFC_L    0x13660000
- PPMU_CPU	0x106c0000

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 1d52de6..20a4c59 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -465,6 +465,72 @@
 			compatible = "arm,cortex-a7-pmu";
 			interrupts = <0 18 0>, <0 19 0>;
 		};
+
+		ppmu_dmc0: ppmu_dmc0@106a0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x106a0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_dmc1: ppmu_dmc1@106b0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x106b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_cpu: ppmu_cpu@106c0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x106c0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_rightbus: ppmu_rightbus@112a0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x112a0000 0x2000>;
+			clocks = <&cmu CLK_PPMURIGHT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_leftbus: ppmu_leftbus0@116a0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x116a0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_camif: ppmu_camif@11ac0000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x11ac0000 0x2000>;
+			clocks = <&cmu CLK_PPMUCAMIF>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_lcd0: ppmu_lcd0@11e40000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x11e40000 0x2000>;
+			clocks = <&cmu CLK_PPMULCD0>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@13220000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x13220000 0x2000>;
+			clocks = <&cmu CLK_PPMUG3D>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_mfc_l: ppmu_mfc_l@13660000 {
+			compatible = "samsung,exynos4210-ppmu";
+			reg = <0x13660000 0x2000>;
+			clocks = <&cmu CLK_PPMUMFC_L>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.0

