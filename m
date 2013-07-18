Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab3GRIyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:54:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54632 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3GRIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:53:58 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <benoit.cousson@linaro.org>
CC: <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 6/6] ARM: dts: omap3-beagle: Make USB host pin naming consistent
Date: Thu, 18 Jul 2013 11:53:10 +0300
Message-ID: <1374137590-17865-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1374137590-17865-1-git-send-email-rogerq@ti.com>
References: <1374137590-17865-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common naming scheme "mode0name.modename flags" for the
USB host pins to be consistent.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 01fbad6..27aed65 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -100,18 +100,18 @@
 
 	hsusbb2_pins: pinmux_hsusbb2_pins {
 		pinctrl-single,pins = <
-			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* usbb2_ulpitll_clk.usbb1_ulpiphy_clk */
-			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* usbb2_ulpitll_clk.usbb1_ulpiphy_stp */
-			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dir */
-			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_nxt */
-			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat0 */
-			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat1 */
-			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat2 */
-			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat3 */
-			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat4 */
-			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat5 */
-			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat6 */
-			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* usbb2_ulpitll_clk.usbb1_ulpiphy_dat7 */
+			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
 		>;
 	};
 
-- 
1.7.4.1

