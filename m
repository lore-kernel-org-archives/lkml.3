Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaLRQZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:25:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58505 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaLRQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:25:04 -0500
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
Subject: [PATCH 5/5] ARM: dts: am437x-gp-evm: add VPFE device tree data
Date: Thu, 18 Dec 2014 21:54:14 +0530
Message-Id: <1418919854-16164-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

Add device tree nodes and pinmux entries for Video Processing
Front End (VPFE) on am437x gp evm.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/boot/dts/am437x-gp-evm.dts | 106 ++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index e7ac47f..be2d285 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -254,6 +254,78 @@
 			0x238 (PIN_OUTPUT_PULLUP | MUX_MODE7)
 		>;
 	};
+
+	vpfe0_pins_default: vpfe0_pins_default {
+		pinctrl-single,pins = <
+			0x1B0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_hd mode 0*/
+			0x1B4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_vd mode 0*/
+			0x1C0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_pclk mode 0*/
+			0x1C4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data8 mode 0*/
+			0x1C8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data9 mode 0*/
+			0x208 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data0 mode 0*/
+			0x20C (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data1 mode 0*/
+			0x210 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data2 mode 0*/
+			0x214 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data3 mode 0*/
+			0x218 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data4 mode 0*/
+			0x21C (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data5 mode 0*/
+			0x220 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data6 mode 0*/
+			0x224 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam0_data7 mode 0*/
+		>;
+	};
+
+	vpfe0_pins_sleep: vpfe0_pins_sleep {
+		pinctrl-single,pins = <
+			0x1B0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_hd mode 0*/
+			0x1B4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_vd mode 0*/
+			0x1C0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_pclk mode 0*/
+			0x1C4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data8 mode 0*/
+			0x1C8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data9 mode 0*/
+			0x208 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data0 mode 0*/
+			0x20C (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data1 mode 0*/
+			0x210 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data2 mode 0*/
+			0x214 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data3 mode 0*/
+			0x218 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data4 mode 0*/
+			0x21C (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data5 mode 0*/
+			0x220 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data6 mode 0*/
+			0x224 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam0_data7 mode 0*/
+		>;
+	};
+
+	vpfe1_pins_default: vpfe1_pins_default {
+		pinctrl-single,pins = <
+			0x1CC (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data9 mode 0*/
+			0x1D0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data8 mode 0*/
+			0x1D4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_hd mode 0*/
+			0x1D8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_vd mode 0*/
+			0x1DC (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_pclk mode 0*/
+			0x1E8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data0 mode 0*/
+			0x1EC (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data1 mode 0*/
+			0x1F0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data2 mode 0*/
+			0x1F4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data3 mode 0*/
+			0x1F8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data4 mode 0*/
+			0x1FC (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data5 mode 0*/
+			0x200 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data6 mode 0*/
+			0x204 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data7 mode 0*/
+		>;
+	};
+
+	vpfe1_pins_sleep: vpfe1_pins_sleep {
+		pinctrl-single,pins = <
+			0x1CC (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data9 mode 0*/
+			0x1D0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data8 mode 0*/
+			0x1D4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_hd mode 0*/
+			0x1D8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_vd mode 0*/
+			0x1DC (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_pclk mode 0*/
+			0x1E8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data0 mode 0*/
+			0x1EC (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data1 mode 0*/
+			0x1F0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data2 mode 0*/
+			0x1F4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data3 mode 0*/
+			0x1F8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data4 mode 0*/
+			0x1FC (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data5 mode 0*/
+			0x200 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data6 mode 0*/
+			0x204 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)  /* cam1_data7 mode 0*/
+		>;
+	};
 };
 
 &i2c0 {
@@ -511,3 +583,37 @@
 		};
 	};
 };
+
+&vpfe0 {
+	status = "okay";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&vpfe0_pins_default>;
+	pinctrl-1 = <&vpfe0_pins_sleep>;
+
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

