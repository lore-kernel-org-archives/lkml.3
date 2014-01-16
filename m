Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaAPRP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:15:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51908 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753093AbaAPRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:15:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/4] ARM: sun6i: dt: Add SPI controllers to the A31 DTSI
Date: Thu, 16 Jan 2014 18:11:25 +0100
Message-Id: <1389892285-11745-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 has 4 SPI controllers. Add them in the DTSI.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index ae058eb..288cc8e 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -340,6 +340,46 @@
 			status = "disabled";
 		};
 
+		spi0: spi@01c68000 {
+			compatible = "allwinner,sun6i-a31-spi";
+			reg = <0x01c68000 0x1000>;
+			interrupts = <0 65 4>;
+			clocks = <&ahb1_gates 20>, <&spi0_clk>;
+			clock-names = "ahb", "mod";
+			resets = <&ahb1_rst 20>;
+			status = "disabled";
+		};
+
+		spi1: spi@01c69000 {
+			compatible = "allwinner,sun6i-a31-spi";
+			reg = <0x01c69000 0x1000>;
+			interrupts = <0 66 4>;
+			clocks = <&ahb1_gates 21>, <&spi1_clk>;
+			clock-names = "ahb", "mod";
+			resets = <&ahb1_rst 21>;
+			status = "disabled";
+		};
+
+		spi2: spi@01c6a000 {
+			compatible = "allwinner,sun6i-a31-spi";
+			reg = <0x01c6a000 0x1000>;
+			interrupts = <0 67 4>;
+			clocks = <&ahb1_gates 22>, <&spi2_clk>;
+			clock-names = "ahb", "mod";
+			resets = <&ahb1_rst 22>;
+			status = "disabled";
+		};
+
+		spi3: spi@01c6b000 {
+			compatible = "allwinner,sun6i-a31-spi";
+			reg = <0x01c6b000 0x1000>;
+			interrupts = <0 68 4>;
+			clocks = <&ahb1_gates 23>, <&spi3_clk>;
+			clock-names = "ahb", "mod";
+			resets = <&ahb1_rst 23>;
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-- 
1.8.4.2

