Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaIPJDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:03:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12691 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaIPJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:03:46 -0400
X-AuditID: cbfee68d-f79c46d000000b84-56-5417fceb0f6b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH v2 3/3] ARM: dts: exynos: Add sysreg phandle to ADC node
Date: Tue, 16 Sep 2014 14:28:51 +0530
Message-id: <1410857931-4980-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWvf1H/EQgw3TTCxeHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ5+YVFjRJ
	VLza0crYwHhGuIuRg0NCwETi5EmuLkZOIFNM4sK99WxdjFwcQgJLGSWOXVzADJEwkfjz8hsj
	RGI6o8Tbj/NZIJx+JokZXyawg1SxCZhJHFy0GswWEYiT+HC5nx2kiFlgP6PE69f7wRLCAh4S
	D9tnM4LYLAKqEk0vO9hAbF4BF4mDBx+zQZykIDFnkg1ImFPAVWL+js9gJUJAJbc6X4FdISFw
	iF3i1dIjLBBzBCS+TT7EAtErK7HpANTVkhIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5x
	aV66XnJ+7iZGYHyc/vesdwfj7QPWhxgFOBiVeHg9HomHCLEmlhVX5h5iNAXaMJFZSjQ5HxiF
	eSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MApHzX+7
	cY5JHtf3WzV3BPqkQjl1JIP1Tc32//G0vjahJ2F541o3lo3rHvkybTiqc4fjmd2xsyxT698t
	edZgzVUgYJfO9vHEBo+Hd3KMbJTb7V6cypfzUlqXaiEU8mRyV/7uzP2SjW1X67SYxN6zdUQ/
	SXFjfepkPs3hxf4bvk0iW5fFexuoKbEUZyQaajEXFScCANC2F86KAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQd3Xf8RDDDav17Z4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzDg3r7CgSaLi1Y5WxgbGM8JdjJwcEgImEn9efmOEsMUkLtxbz9bF
	yMUhJDCdUeLtx/ksEE4/k8SMLxPYQarYBMwkDi5aDWaLCMRJfLjczw5SxCywn1Hi9ev9YAlh
	AQ+Jh+2zwcayCKhKNL3sYAOxeQVcJA4efAxkcwCtU5CYM8kGJMwp4Coxf8dnsBIhoJJbna8Y
	JzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHH/PpHcwrmqwOMQowMGoxMPr8Ug8
	RIg1say4MvcQowQHs5II74NPQCHelMTKqtSi/Pii0pzU4kOMpkBHTWSWEk3OB6aGvJJ4Q2MT
	c1NjU0sTCxMzSyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjBUueq3v+/QFP3d7S3g6W09e
	5Ch2jy9slcxpnfWKc1xzjl2ss9WytJsWELlBltNQiKtrVrr+arP5E9hKb6fseuX6bv3pxVr7
	BRreqK2+7Gc1z0nG/AXjPuHAJzGLtW23bzpp55+/5N/j2W48TU+zv5mV7Dz+QuvFlY13irQT
	1XOKni0RDhMxUmIpzkg01GIuKk4EADZbU9bVAgAA
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
index 1d52de6..b997a4c 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -272,12 +272,13 @@
 		adc: adc@126C0000 {
 			compatible = "samsung,exynos3250-adc",
 				     "samsung,exynos-adc-v2";
-			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+			reg = <0x126C0000 0x100>;
 			interrupts = <0 137 0>;
 			clock-names = "adc", "sclk";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
+			samsung,syscon-phandle = <&pmu_system_controller>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 861bb91..9ee77d3 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -108,13 +108,14 @@
 
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
index 492e1ef..108adc5 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -765,12 +765,13 @@
 
 	adc: adc@12D10000 {
 		compatible = "samsung,exynos-adc-v1";
-		reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+		reg = <0x12D10000 0x100>;
 		interrupts = <0 106 0>;
 		clocks = <&clock CLK_ADC>;
 		clock-names = "adc";
 		#io-channel-cells = <1>;
 		io-channel-ranges;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index bfe056d..5fd587a 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -541,12 +541,13 @@
 
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

