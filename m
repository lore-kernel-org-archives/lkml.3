Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaJQUcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:32:20 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44488 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:32:18 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH] ARM: dts: omap3-gta04: Use omap specific pinctrl defines
Date: Fri, 17 Oct 2014 22:32:03 +0200
Message-Id: <1413577923-23526-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use omap specific pinctrl defines (OMAP3_CORE1_IOPAD) to configure
the padconf register offset.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 82 +++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index fd34f91..16490c2 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -104,67 +104,67 @@
 
 	uart1_pins: pinmux_uart1_pins {
 		pinctrl-single,pins = <
-			0x152 (PIN_INPUT | MUX_MODE0)		/* uart1_rx.uart1_rx */
-			0x14c (PIN_OUTPUT |MUX_MODE0)		/* uart1_tx.uart1_tx */
+			OMAP3_CORE1_IOPAD(0x2182, PIN_INPUT | MUX_MODE0)		/* uart1_rx.uart1_rx */
+			OMAP3_CORE1_IOPAD(0x217c, PIN_OUTPUT | MUX_MODE0)		/* uart1_tx.uart1_tx */
 		>;
 	};
 
 	uart2_pins: pinmux_uart2_pins {
 		pinctrl-single,pins = <
-			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_rx.uart2_rx */
-			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
+			OMAP3_CORE1_IOPAD(0x217a, PIN_INPUT | MUX_MODE0)		/* uart2_rx.uart2_rx */
+			OMAP3_CORE1_IOPAD(0x2178, PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
 		>;
 	};
 
 	uart3_pins: pinmux_uart3_pins {
 		pinctrl-single,pins = <
-			0x16e (PIN_INPUT | MUX_MODE0)		/* uart3_rx.uart3_rx */
-			0x170 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx.uart3_tx */
+			OMAP3_CORE1_IOPAD(0x219e, PIN_INPUT | MUX_MODE0)		/* uart3_rx.uart3_rx */
+			OMAP3_CORE1_IOPAD(0x21a0, PIN_OUTPUT | MUX_MODE0)		/* uart3_tx.uart3_tx */
 		>;
 	};
 
 	mmc1_pins: pinmux_mmc1_pins {
 		pinctrl-single,pins = <
-			0x114 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_clk.sdmmc1_clk */
-			0x116 (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_cmd.sdmmc1_cmd */
-			0x118 (PIN_INPUT_PULLUP | MUX_MODE0) 	/* sdmmc1_dat0.sdmmc1_dat0 */
-			0x11a (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat1.sdmmc1_dat1 */
-			0x11c (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat2.sdmmc1_dat2 */
-			0x11e (PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_dat3.sdmmc1_dat3 */
+			OMAP3_CORE1_IOPAD(0x2144, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_clk.sdmmc1_clk */
+			OMAP3_CORE1_IOPAD(0x2146, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_cmd.sdmmc1_cmd */
+			OMAP3_CORE1_IOPAD(0x2148, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_dat0.sdmmc1_dat0 */
+			OMAP3_CORE1_IOPAD(0x214a, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_dat1.sdmmc1_dat1 */
+			OMAP3_CORE1_IOPAD(0x214c, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_dat2.sdmmc1_dat2 */
+			OMAP3_CORE1_IOPAD(0x214e, PIN_INPUT_PULLUP | MUX_MODE0)		/* sdmmc1_dat3.sdmmc1_dat3 */
 		>;
 	};
 
 	dss_dpi_pins: pinmux_dss_dpi_pins {
                pinctrl-single,pins = <
-                       0x0a4 (PIN_OUTPUT | MUX_MODE0)   /* dss_pclk.dss_pclk */
-                       0x0a6 (PIN_OUTPUT | MUX_MODE0)   /* dss_hsync.dss_hsync */
-                       0x0a8 (PIN_OUTPUT | MUX_MODE0)   /* dss_vsync.dss_vsync */
-                       0x0aa (PIN_OUTPUT | MUX_MODE0)   /* dss_acbias.dss_acbias */
-                       0x0ac (PIN_OUTPUT | MUX_MODE0)   /* dss_data0.dss_data0 */
-                       0x0ae (PIN_OUTPUT | MUX_MODE0)   /* dss_data1.dss_data1 */
-                       0x0b0 (PIN_OUTPUT | MUX_MODE0)   /* dss_data2.dss_data2 */
-                       0x0b2 (PIN_OUTPUT | MUX_MODE0)   /* dss_data3.dss_data3 */
-                       0x0b4 (PIN_OUTPUT | MUX_MODE0)   /* dss_data4.dss_data4 */
-                       0x0b6 (PIN_OUTPUT | MUX_MODE0)   /* dss_data5.dss_data5 */
-                       0x0b8 (PIN_OUTPUT | MUX_MODE0)   /* dss_data6.dss_data6 */
-                       0x0ba (PIN_OUTPUT | MUX_MODE0)   /* dss_data7.dss_data7 */
-                       0x0bc (PIN_OUTPUT | MUX_MODE0)   /* dss_data8.dss_data8 */
-                       0x0be (PIN_OUTPUT | MUX_MODE0)   /* dss_data9.dss_data9 */
-                       0x0c0 (PIN_OUTPUT | MUX_MODE0)   /* dss_data10.dss_data10 */
-                       0x0c2 (PIN_OUTPUT | MUX_MODE0)   /* dss_data11.dss_data11 */
-                       0x0c4 (PIN_OUTPUT | MUX_MODE0)   /* dss_data12.dss_data12 */
-                       0x0c6 (PIN_OUTPUT | MUX_MODE0)   /* dss_data13.dss_data13 */
-                       0x0c8 (PIN_OUTPUT | MUX_MODE0)   /* dss_data14.dss_data14 */
-                       0x0ca (PIN_OUTPUT | MUX_MODE0)   /* dss_data15.dss_data15 */
-                       0x0cc (PIN_OUTPUT | MUX_MODE0)   /* dss_data16.dss_data16 */
-                       0x0ce (PIN_OUTPUT | MUX_MODE0)   /* dss_data17.dss_data17 */
-                       0x0d0 (PIN_OUTPUT | MUX_MODE0)   /* dss_data18.dss_data18 */
-                       0x0d2 (PIN_OUTPUT | MUX_MODE0)   /* dss_data19.dss_data19 */
-                       0x0d4 (PIN_OUTPUT | MUX_MODE0)   /* dss_data20.dss_data20 */
-                       0x0d6 (PIN_OUTPUT | MUX_MODE0)   /* dss_data21.dss_data21 */
-                       0x0d8 (PIN_OUTPUT | MUX_MODE0)   /* dss_data22.dss_data22 */
-                       0x0da (PIN_OUTPUT | MUX_MODE0)   /* dss_data23.dss_data23 */
-               >;
+			OMAP3_CORE1_IOPAD(0x20d4, PIN_OUTPUT | MUX_MODE0)   /* dss_pclk.dss_pclk */
+			OMAP3_CORE1_IOPAD(0x20d6, PIN_OUTPUT | MUX_MODE0)   /* dss_hsync.dss_hsync */
+			OMAP3_CORE1_IOPAD(0x20d8, PIN_OUTPUT | MUX_MODE0)   /* dss_vsync.dss_vsync */
+			OMAP3_CORE1_IOPAD(0x20da, PIN_OUTPUT | MUX_MODE0)   /* dss_acbias.dss_acbias */
+			OMAP3_CORE1_IOPAD(0x20dc, PIN_OUTPUT | MUX_MODE0)   /* dss_data0.dss_data0 */
+			OMAP3_CORE1_IOPAD(0x20de, PIN_OUTPUT | MUX_MODE0)   /* dss_data1.dss_data1 */
+			OMAP3_CORE1_IOPAD(0x20e0, PIN_OUTPUT | MUX_MODE0)   /* dss_data2.dss_data2 */
+			OMAP3_CORE1_IOPAD(0x20e2, PIN_OUTPUT | MUX_MODE0)   /* dss_data3.dss_data3 */
+			OMAP3_CORE1_IOPAD(0x20e4, PIN_OUTPUT | MUX_MODE0)   /* dss_data4.dss_data4 */
+			OMAP3_CORE1_IOPAD(0x20e6, PIN_OUTPUT | MUX_MODE0)   /* dss_data5.dss_data5 */
+			OMAP3_CORE1_IOPAD(0x20e8, PIN_OUTPUT | MUX_MODE0)   /* dss_data6.dss_data6 */
+			OMAP3_CORE1_IOPAD(0x20ea, PIN_OUTPUT | MUX_MODE0)   /* dss_data7.dss_data7 */
+			OMAP3_CORE1_IOPAD(0x20ec, PIN_OUTPUT | MUX_MODE0)   /* dss_data8.dss_data8 */
+			OMAP3_CORE1_IOPAD(0x20ee, PIN_OUTPUT | MUX_MODE0)   /* dss_data9.dss_data9 */
+			OMAP3_CORE1_IOPAD(0x20f0, PIN_OUTPUT | MUX_MODE0)   /* dss_data10.dss_data10 */
+			OMAP3_CORE1_IOPAD(0x20f2, PIN_OUTPUT | MUX_MODE0)   /* dss_data11.dss_data11 */
+			OMAP3_CORE1_IOPAD(0x20f4, PIN_OUTPUT | MUX_MODE0)   /* dss_data12.dss_data12 */
+			OMAP3_CORE1_IOPAD(0x20f6, PIN_OUTPUT | MUX_MODE0)   /* dss_data13.dss_data13 */
+			OMAP3_CORE1_IOPAD(0x20f8, PIN_OUTPUT | MUX_MODE0)   /* dss_data14.dss_data14 */
+			OMAP3_CORE1_IOPAD(0x20fa, PIN_OUTPUT | MUX_MODE0)   /* dss_data15.dss_data15 */
+			OMAP3_CORE1_IOPAD(0x20fc, PIN_OUTPUT | MUX_MODE0)   /* dss_data16.dss_data16 */
+			OMAP3_CORE1_IOPAD(0x20fe, PIN_OUTPUT | MUX_MODE0)   /* dss_data17.dss_data17 */
+			OMAP3_CORE1_IOPAD(0x2100, PIN_OUTPUT | MUX_MODE0)   /* dss_data18.dss_data18 */
+			OMAP3_CORE1_IOPAD(0x2102, PIN_OUTPUT | MUX_MODE0)   /* dss_data19.dss_data19 */
+			OMAP3_CORE1_IOPAD(0x2104, PIN_OUTPUT | MUX_MODE0)   /* dss_data20.dss_data20 */
+			OMAP3_CORE1_IOPAD(0x2106, PIN_OUTPUT | MUX_MODE0)   /* dss_data21.dss_data21 */
+			OMAP3_CORE1_IOPAD(0x2108, PIN_OUTPUT | MUX_MODE0)   /* dss_data22.dss_data22 */
+			OMAP3_CORE1_IOPAD(0x210a, PIN_OUTPUT | MUX_MODE0)   /* dss_data23.dss_data23 */
+		>;
        };
 };
 
-- 
1.9.1

