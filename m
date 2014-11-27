Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaK0Lo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:44:27 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48221 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaK0LoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:44:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 3/4] ARM: sti: Provide DT nodes for SSC[0..4]
Date: Thu, 27 Nov 2014 11:43:55 +0000
Message-Id: <1417088636-11994-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synchronous Serial Controller is used to provide SPI.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 54 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 50637f5..245aa31 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -275,5 +275,59 @@
 
 			status = "disabled";
 		};
+
+		spi@9840000 {
+			compatible = "st,comms-ssc-spi";
+			reg = <0x9840000 0x110>;
+			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			pinctrl-0 = <&pinctrl_spi0_default>;
+			pinctrl-names = "default";
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			status = "disabled";
+		};
+
+		spi@9841000 {
+			compatible = "st,comms-ssc-spi";
+			reg = <0x9841000 0x110>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
+
+		spi@9842000 {
+			compatible = "st,comms-ssc-spi";
+			reg = <0x9842000 0x110>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
+
+		spi@9843000 {
+			compatible = "st,comms-ssc-spi";
+			reg = <0x9843000 0x110>;
+			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
+
+		spi@9844000 {
+			compatible = "st,comms-ssc-spi";
+			reg = <0x9844000 0x110>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+
+			status = "disabled";
+		};
 	};
 };
-- 
1.9.1

