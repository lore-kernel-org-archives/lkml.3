Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaGQLXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:23:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaGQLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:36 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c6-53c7b236202d
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH 4/4 v2] ARM: dts: exynos: Add sysreg phandle to ADC node
Date: Thu, 17 Jul 2014 16:49:53 +0530
Message-id: <1405595993-16661-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkRtds0/Fgg/2HNC1eAvH1L89ZLeYf
	Ocdq0bx4PZvFqyM/mCweNK1islgyeT6rxbwj71gsLu+aw2Yx4/w+JotF2/4zO3B7zG64yOKx
	c9Zddo9NqzrZPPbPXcPuseTNIVaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgytg7cx9TQZNE
	xc/Dy5kaGM8KdzFyckgImEjcfdjMBmGLSVy4tx7I5uIQEljKKHFt71V2mKLWQ0+gEtMZJaZP
	74Vy+pkklp+bwAxSxSZgJnFw0WqwDhGBOIkPl/vZQYqYBfYzSrx+vR8sISzgIfHj+DKwfSwC
	qhJ/J/1lArF5BVwltr64CDSIA2idgsScSTYgYU4BN4kVa/6wgYSFgEpuPMgDGSkhcIxd4sKl
	5VBjBCS+TT7EAtEqK7HpADPE0ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRmCEnP73rH8H490D1ocYk4HGTWSWEk3OB0ZYXkm8obGZkYWpiamxkbmlGWnCSuK89x8m
	BQkJpCeWpGanphakFsUXleakFh9iZOLglGpg3MbKF+QvoLFCN/louVqFxOI3V0UkRTwcrvr2
	PZmjf0ZhjY+V1CsbHidzQ2Wnc1//P1Y9XW3tN+3fjtNZU++EXtN1MJX94req+5S5gu2cY5u1
	psY57Nv2Y8Wc9yslWiIEHx6v6d5wQrZAQOrqOy/hhTv6mNdOPC+dG2y17n+A8CuFFYsUnixz
	VGIpzkg01GIuKk4EAOLsySWmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV2zTceDDZ7NUbR4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzNg7cx9TQZNExc/Dy5kaGM8KdzFyckgImEi0HnrCBmGLSVy4tx7I
	5uIQEpjOKDF9ei+U088ksfzcBGaQKjYBM4mDi1azg9giAnESHy73s4MUMQvsZ5R4/Xo/WEJY
	wEPix/FlYGNZBFQl/k76ywRi8wq4Smx9cRFoEAfQOgWJOZNsQMKcAm4SK9b8YQMJCwGV3HiQ
	N4GRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ph7JrWDcWWDxSFGAQ5GJR7ehNZj
	wUKsiWXFlbmHGCU4mJVEeLd1HQ8W4k1JrKxKLcqPLyrNSS0+xGgKdNNEZinR5HxgasgriTc0
	NjE3NTa1NLEwMbNUEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cC4XfeJG9+j+3rLGR1+JahM
	Enuua3izyrLf+dL5tKcvbsQWcG13u/xX1fA6207Ot82zr9156qY+IXFBpkSMQ0f95H9KJ9f9
	zv00fUrdwR33LGzur1C5mDL/7teo2zskDNhZHsuy+qqzlxfnHkvZkHGHcdvzHqc5QhWHpLyZ
	Ji1fL+0ySWjPtf3nlViKMxINtZiLihMBy5raRtUCAAA=
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
Changes since v1:
None

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

