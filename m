Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3DSJ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:57:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35887 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3DSJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:57:51 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <paul@pwsan.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 2/4] ARM: dts: omap3-beagle: Make USB host pin naming consistent
Date: Fri, 19 Apr 2013 12:57:35 +0300
Message-ID: <1366365457-28972-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366365457-28972-1-git-send-email-rogerq@ti.com>
References: <1366365457-28972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common naming scheme "mode0name.modename flags" for the
USB host pins to be consistent.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 6eec699..ce7a7be 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -81,18 +81,19 @@
 
 	hsusbb2_pins: pinmux_hsusbb2_pins {
 		pinctrl-single,pins = <
-			0x5c0 0x3  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_clk OUTPUT */
-			0x5c2 0x3  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_stp OUTPUT */
-			0x5c4 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dir INPUT | PULLDOWN */
-			0x5c6 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_nxt INPUT | PULLDOWN */
-			0x5c8 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat0 INPUT | PULLDOWN */
-			0x5cA 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat1 INPUT | PULLDOWN */
-			0x1a4 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat2 INPUT | PULLDOWN */
-			0x1a6 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat3 INPUT | PULLDOWN */
-			0x1a8 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat4 INPUT | PULLDOWN */
-			0x1aa 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat5 INPUT | PULLDOWN */
-			0x1ac 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat6 INPUT | PULLDOWN */
-			0x1ae 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat7 INPUT | PULLDOWN */
+			0x5c0 0x3	/* etk_d10.hsusb2_clk OUTPUT | MODE3 */
+			0x5c2 0x3	/* etk_d11.hsusb2_stp OUTPUT | MODE3 */
+			0x5c4 0x10b	/* etk_d12.hsusb2_dir INPUT_PULLDOWN | MODE3 */
+			0x5c6 0x10b	/* etk_d13.hsusb2_nxt INPUT_PULLDOWN | MODE3 */
+			0x5c8 0x10b	/* etk_d14.hsusb2_data0 INPUT_PULLDOWN | MODE3*/
+			0x5cA 0x10b	/* etk_d15.hsusb2_data1 INPUT_PULLDOWN | MODE3 */
+			0x1a4 0x10b	/* mcspi1_cs3.hsusb2_data2 INPUT_PULLDOWN | MODE3 */
+			0x1a6 0x10b	/* mcspi2_cs1.hsusb2_data3 INPUT_PULLDOWN | MODE3 */
+			0x1a8 0x10b	/* mcspi2_simo.hsusb2_data4 INPUT_PULLDOWN | MODE3 */
+			0x1aa 0x10b	/* mcspi2_somi.hsusb2_data5 INPUT_PULLDOWN | MODE3 */
+			0x1ac 0x10b	/* mcspi2_cs0.hsusb2_data6 INPUT_PULLDOWN | MODE3 */
+			0x1ae 0x10b	/* mcspi2_clk.hsusb2_data7 INPUT_PULLDOWN | MODE3 */
+
 		>;
 	};
 };
-- 
1.7.4.1

