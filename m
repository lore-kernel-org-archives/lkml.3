Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaGKJLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:11:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16778 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGKJKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:45 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-e7-53bfaa1015be
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: [PATCH 4/4] ARM: dts: exynos: Add sysreg phandle to ADC node
Date: Fri, 11 Jul 2014 14:36:29 +0530
Message-id: <1405069589-10388-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSoyu4an+wwbwmNouXhzQtrn95zmox
	/8g5VovmxevZLF4d+cFksWTyfFaLeUfesVhc3jWHzWLG+X1MFou2/Wd24PKY3XCRxWPnrLvs
	HvvnrmH3WPLmEKtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZUz4YFrwXLxi+a5HjA2Mu4S7
	GDk5JARMJJo+LGCFsMUkLtxbz9bFyMUhJLCUUWLt8j4mmKK3Fz+yQySmM0rseziTEcLpZ5L4
	cGMxWDubgJnEwUWr2UFsEYE4iQ+X+8E6mAXWMkq0bbsKlhAWcJU4MOkC2FgWAVWJhqMPwJp5
	geJfHn4C2s0BtE5BYs4kG5Awp4CbxLd/jcwgthBQyZZb3SwgMyUEdrFLPDrynB1ijoDEt8mH
	WCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMhtP/
	nk3cwXj/gPUhxmSgcROZpUST84HRlFcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjJE6S63LmTKW/Zxisr/FKiFG6eSiHP8yzw+dYtIvj3X+u/vQ
	fB2vsklalOXdP21uJh1L3FnmcQi+5OF+/35t7J3F/16tN+pZ7JX+YZpLy6FQVrYPVg9bZtmZ
	vepKt/i7/6vYw8ZFsVZnrH4faPnRzb45qkJ0gdDjwyubKzm2ntv8gvXKz/ZOViWW4oxEQy3m
	ouJEAHy/ogecAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd2/K/cHG1z+rGHx8pCmxfUvz1kt
	5h85x2rRvHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MDlwesxsusnjsnHWX
	3WP/3DXsHkveHGL16NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKDTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZEz6YFjwXr1i+6xFjA+Mu4S5GTg4JAROJtxc/skPYYhIX7q1n62Lk4hASmM4ose/h
	TEYIp59J4sONxawgVWwCZhIHF60G6xARiJP4cLmfHaSIWWAto0TbtqtgCWEBV4kDky4wgdgs
	AqoSDUcfgDXzAsW/PPwEtIIDaJ2CxJxJNiBhTgE3iW//GplBbCGgki23ulkmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREca8+kdzCuarA4xCjAwajEw3tizb5gIdbEsuLK3EOM
	EhzMSiK8T+r3BwvxpiRWVqUW5ccXleakFh9iNAU6aiKzlGhyPjAN5JXEGxqbmJsam1qaWJiY
	WSqJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYFxy/fC0zj7z1BOhN038vj6a9u3lLGerysLJ
	ezwShWexFC/8UHli4Q6lNSUN7zs3SxnM6dvBe3Qtj4NJqFug+k7eMtWkq6fmN1encnhc2zrD
	aFdpGI/Z1tzTHdaaBq3vDvA8yyzMP1po+nXCFd2oF/bs+/c3baqdovNx2ebp835kL9zRU9zM
	rq7EUpyRaKjFXFScCABYzRk9ywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the ADC_PHY register base address, use sysreg phandle
in ADC node to control ADC_PHY configuration register.

This patch adds syscon node for Exynos3250, Exynos4x12, Exynos5250,
and Exynos5420, Exynos5800.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org
---
 arch/arm/boot/dts/exynos3250.dtsi |    3 ++-
 arch/arm/boot/dts/exynos4x12.dtsi |    3 ++-
 arch/arm/boot/dts/exynos5250.dtsi |    3 ++-
 arch/arm/boot/dts/exynos5420.dtsi |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c5e15db..51c9b0d 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -262,12 +262,13 @@
 
 		adc: adc@126C0000 {
 			compatible = "samsung,exynos3250-adc-v2";
-			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+			reg = <0x126C0000 0x100>;
 			interrupts = <0 137 0>;
 			clock-names = "adc", "sclk_adc";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
+			samsung,syscon-phandle = <&pmu_system_controller>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index c5a943d..9a18d9b 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -114,13 +114,14 @@
 
 	adc: adc@126C0000 {
 		compatible = "samsung,exynos-adc-v1";
-		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+		reg = <0x126C0000 0x100>;
 		interrupt-parent = <&combiner>;
 		interrupts = <10 3>;
 		clocks = <&clock CLK_TSADC>;
 		clock-names = "adc";
 		#io-channel-cells = <1>;
 		io-channel-ranges;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 834fb5a..6003777 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -762,12 +762,13 @@
 
 	adc: adc@12D10000 {
 		compatible = "samsung,exynos-adc-v1";
-		reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+		reg = <0x12D10000 0x100>
 		interrupts = <0 106 0>;
 		clocks = <&clock CLK_ADC>;
 		clock-names = "adc";
 		#io-channel-cells = <1>;
 		io-channel-ranges;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e385322..6979da8 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -525,12 +525,13 @@
 
 	adc: adc@12D10000 {
 		compatible = "samsung,exynos-adc-v2";
-		reg = <0x12D10000 0x100>, <0x10040720 0x4>;
+		reg = <0x12D10000 0x100>;
 		interrupts = <0 106 0>;
 		clocks = <&clock CLK_TSADC>;
 		clock-names = "adc";
 		#io-channel-cells = <1>;
 		io-channel-ranges;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 		status = "disabled";
 	};
 
-- 
1.7.9.5

