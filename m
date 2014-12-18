Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaLRQYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:24:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64055 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaLRQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:24:49 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        OMAP <linux-omap@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/5] ARM: dts: am43x-epos-evm: add VPFE device tree data
Date: Thu, 18 Dec 2014 21:54:12 +0530
Message-Id: <1418919854-16164-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

Add device tree nodes and pinmux entries for Video Processing
Front End (VPFE) on am43x epos evm.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 53 ++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index ac3e485..6a43801 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -243,6 +243,42 @@
 				0x08C (PIN_OUTPUT_PULLUP | MUX_MODE7)
 			>;
 		};
+
+		vpfe1_pins_default: vpfe1_pins_default {
+			pinctrl-single,pins = <
+				0x1cc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data9 mode 0 */
+				0x1d0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data8 mode 0 */
+				0x1d4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_hd mode 0 */
+				0x1d8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_vd mode 0 */
+				0x1dc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_pclk mode 0 */
+				0x1e8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data0 mode 0 */
+				0x1ec (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data1 mode 0 */
+				0x1f0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data2 mode 0 */
+				0x1f4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data3 mode 0 */
+				0x1f8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data4 mode 0 */
+				0x1fc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data5 mode 0 */
+				0x200 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data6 mode 0 */
+				0x204 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data7 mode 0 */
+			>;
+		};
+
+		vpfe1_pins_sleep: vpfe1_pins_sleep {
+			pinctrl-single,pins = <
+				0x1cc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1dc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1e8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1ec (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1fc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x200 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x204 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			>;
+		};
 	};
 
 	matrix_keypad: matrix_keypad@0 {
@@ -626,3 +662,20 @@
 		};
 	};
 };
+
+&vpfe1 {
+	status = "okay";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&vpfe1_pins_default>;
+	pinctrl-1 = <&vpfe1_pins_sleep>;
+
+	port {
+		vpfe1_ep: endpoint {
+			/* remote-endpoint = <&sensor>; add once we have it */
+			ti,am437x-vpfe-interface = <0>;
+			bus-width = <8>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+		};
+	};
+};
-- 
1.9.1

