Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaGUVGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:06:07 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59442 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaGUVGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:06:03 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 4/7] arm: dts: omap3-gta04: Move spi gpio pins to pmx_core2
Date: Mon, 21 Jul 2014 23:05:24 +0200
Message-Id: <1405976727-15166-5-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976727-15166-1-git-send-email-marek@goldelico.com>
References: <1405976727-15166-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 5b08d93..4ca1277 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -141,12 +141,15 @@
                        0x0da (PIN_OUTPUT | MUX_MODE0)   /* dss_data23.dss_data23 */
                >;
        };
+};
 
+&omap3_pmx_core2 {
 	spi_gpio_pins: spi_gpio_pinmux {
-		pinctrl-single,pins = <0x5a8 (PIN_OUTPUT | MUX_MODE4) /* clk */
-			0x5b6 (PIN_OUTPUT | MUX_MODE4) /* cs */
-			0x5b8 (PIN_OUTPUT | MUX_MODE4) /* tx */
-			0x5b4 (PIN_INPUT | MUX_MODE4) /* rx */
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25d8, PIN_OUTPUT | MUX_MODE4) /* clk */
+			OMAP3630_CORE2_IOPAD(0x25e6, PIN_OUTPUT | MUX_MODE4) /* cs */
+			OMAP3630_CORE2_IOPAD(0x25e8, PIN_OUTPUT | MUX_MODE4) /* tx */
+			OMAP3630_CORE2_IOPAD(0x25e4, PIN_INPUT | MUX_MODE4) /* rx */
 		>;
 	};
 };
-- 
1.9.1

