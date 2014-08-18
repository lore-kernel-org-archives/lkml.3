Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHRRpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:45:51 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35768 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaHRRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:45:50 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dt: sunxi: Remove i2c controller clock-frequency that matches default
Date: Tue, 19 Aug 2014 01:45:45 +0800
Message-Id: <1408383945-27940-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock-frequency values of the i2c controller nodes match the
defaults of the driver. Remove the properties to use the defaults,
and be consistent with sun8i.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi  | 3 ---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 3 ---
 arch/arm/boot/dts/sun5i-a13.dtsi  | 3 ---
 arch/arm/boot/dts/sun6i-a31.dtsi  | 4 ----
 arch/arm/boot/dts/sun7i-a20.dtsi  | 5 -----
 5 files changed, 18 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 14cf436..380f914 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -765,7 +765,6 @@
 			reg = <0x01c2ac00 0x400>;
 			interrupts = <7>;
 			clocks = <&apb1_gates 0>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -776,7 +775,6 @@
 			reg = <0x01c2b000 0x400>;
 			interrupts = <8>;
 			clocks = <&apb1_gates 1>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -787,7 +785,6 @@
 			reg = <0x01c2b400 0x400>;
 			interrupts = <9>;
 			clocks = <&apb1_gates 2>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 02aa41f..d73a228 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -578,7 +578,6 @@
 			reg = <0x01c2ac00 0x400>;
 			interrupts = <7>;
 			clocks = <&apb1_gates 0>;
-			clock-frequency = <100000>;
 			status = "disabled";
 		};
 
@@ -589,7 +588,6 @@
 			reg = <0x01c2b000 0x400>;
 			interrupts = <8>;
 			clocks = <&apb1_gates 1>;
-			clock-frequency = <100000>;
 			status = "disabled";
 		};
 
@@ -600,7 +598,6 @@
 			reg = <0x01c2b400 0x400>;
 			interrupts = <9>;
 			clocks = <&apb1_gates 2>;
-			clock-frequency = <100000>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index d8f02ee..c4b5d78 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -504,7 +504,6 @@
 			reg = <0x01c2ac00 0x400>;
 			interrupts = <7>;
 			clocks = <&apb1_gates 0>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -515,7 +514,6 @@
 			reg = <0x01c2b000 0x400>;
 			interrupts = <8>;
 			clocks = <&apb1_gates 1>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -526,7 +524,6 @@
 			reg = <0x01c2b400 0x400>;
 			interrupts = <9>;
 			clocks = <&apb1_gates 2>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 8fdf90d..1c2ec91 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -657,7 +657,6 @@
 			reg = <0x01c2ac00 0x400>;
 			interrupts = <0 6 4>;
 			clocks = <&apb2_gates 0>;
-			clock-frequency = <100000>;
 			resets = <&apb2_rst 0>;
 			status = "disabled";
 		};
@@ -667,7 +666,6 @@
 			reg = <0x01c2b000 0x400>;
 			interrupts = <0 7 4>;
 			clocks = <&apb2_gates 1>;
-			clock-frequency = <100000>;
 			resets = <&apb2_rst 1>;
 			status = "disabled";
 		};
@@ -677,7 +675,6 @@
 			reg = <0x01c2b400 0x400>;
 			interrupts = <0 8 4>;
 			clocks = <&apb2_gates 2>;
-			clock-frequency = <100000>;
 			resets = <&apb2_rst 2>;
 			status = "disabled";
 		};
@@ -687,7 +684,6 @@
 			reg = <0x01c2b800 0x400>;
 			interrupts = <0 9 4>;
 			clocks = <&apb2_gates 3>;
-			clock-frequency = <100000>;
 			resets = <&apb2_rst 3>;
 			status = "disabled";
 		};
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index db22ef9..c658e34 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -915,7 +915,6 @@
 			reg = <0x01c2ac00 0x400>;
 			interrupts = <0 7 4>;
 			clocks = <&apb1_gates 0>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -926,7 +925,6 @@
 			reg = <0x01c2b000 0x400>;
 			interrupts = <0 8 4>;
 			clocks = <&apb1_gates 1>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -937,7 +935,6 @@
 			reg = <0x01c2b400 0x400>;
 			interrupts = <0 9 4>;
 			clocks = <&apb1_gates 2>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -948,7 +945,6 @@
 			reg = <0x01c2b800 0x400>;
 			interrupts = <0 88 4>;
 			clocks = <&apb1_gates 3>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -959,7 +955,6 @@
 			reg = <0x01c2c000 0x400>;
 			interrupts = <0 89 4>;
 			clocks = <&apb1_gates 15>;
-			clock-frequency = <100000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.1.0

