Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLRQY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:24:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49552 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaLRQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:24:57 -0500
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
Subject: [PATCH 4/5] ARM: dts: am437x-sk-evm: add VPFE device tree data
Date: Thu, 18 Dec 2014 21:54:13 +0530
Message-Id: <1418919854-16164-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Etheridge <detheridge@ti.com>

Add device tree nodes and pinmux entries for Video Processing
Front End (VPFE) on am437x sk evm.

Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/boot/dts/am437x-sk-evm.dts | 58 +++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am437x-sk-evm.dts
index 859ff3d..2f4898b 100644
--- a/arch/arm/boot/dts/am437x-sk-evm.dts
+++ b/arch/arm/boot/dts/am437x-sk-evm.dts
@@ -184,6 +184,46 @@
 		>;
 	};
 
+	vpfe0_pins_default: vpfe0_pins_default {
+		pinctrl-single,pins = <
+			0x1b0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_hd mode 0*/
+			0x1b4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_vd mode 0*/
+			0x1b8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_field mode 0*/
+			0x1bc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_wen mode 0*/
+			0x1c0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_pclk mode 0*/
+			0x1c4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data8 mode 0*/
+			0x1c8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data9 mode 0*/
+			0x208 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data0 mode 0*/
+			0x20c (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data1 mode 0*/
+			0x210 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data2 mode 0*/
+			0x214 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data3 mode 0*/
+			0x218 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data4 mode 0*/
+			0x21c (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data5 mode 0*/
+			0x220 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data6 mode 0*/
+			0x224 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data7 mode 0*/
+		>;
+	};
+
+	vpfe0_pins_sleep: vpfe0_pins_sleep {
+		pinctrl-single,pins = <
+			0x1b0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1b4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1b8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1bc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1c0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1c4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x1c8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x208 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x20c (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x210 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x214 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x218 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x21c (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x220 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			0x224 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+		>;
+	};
+
 	cpsw_default: cpsw_default {
 		pinctrl-single,pins = <
 			/* Slave 1 */
@@ -611,3 +651,21 @@
 &wdt {
 	status = "okay";
 };
+
+&vpfe0 {
+	status = "okay";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&vpfe0_pins_default>;
+	pinctrl-1 = <&vpfe0_pins_sleep>;
+
+	/* Camera port */
+	port {
+		vpfe0_ep: endpoint {
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

