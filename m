Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaHQDyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:54:54 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58661 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHQDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:30 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] ARM: dts: sun8i: Add i2c controller nodes
Date: Sun, 17 Aug 2014 11:52:17 +0800
Message-Id: <1408247538-16950-12-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the 3 i2c controllers found on A23 SoCs to the sun8i DTSI.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23.dtsi | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index 4658998..53ef350 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -387,6 +387,42 @@
 			status = "disabled";
 		};
 
+		i2c0: i2c@01c2ac00 {
+			compatible = "allwinner,sun6i-a31-i2c";
+			reg = <0x01c2ac00 0x400>;
+			interrupts = <0 6 4>;
+			clocks = <&apb2_gates 0>;
+			clock-frequency = <100000>;
+			resets = <&apb2_rst 0>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c1: i2c@01c2b000 {
+			compatible = "allwinner,sun6i-a31-i2c";
+			reg = <0x01c2b000 0x400>;
+			interrupts = <0 7 4>;
+			clocks = <&apb2_gates 1>;
+			clock-frequency = <100000>;
+			resets = <&apb2_rst 1>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c2: i2c@01c2b400 {
+			compatible = "allwinner,sun6i-a31-i2c";
+			reg = <0x01c2b400 0x400>;
+			interrupts = <0 8 4>;
+			clocks = <&apb2_gates 2>;
+			clock-frequency = <100000>;
+			resets = <&apb2_rst 2>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-- 
2.1.0

