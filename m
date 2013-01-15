Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3AONuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:50:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47229 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab3AONuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:50:18 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] ARM: dts: AM33XX: Add am335x-evmsk lcdc pincontrol info
Date: Tue, 15 Jan 2013 19:21:10 +0530
Message-ID: <b107ecb6ed8a1cb8650cf771499bf011b0d3074e.1358252955.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358252955.git.afzal@ti.com>
References: <cover.1358252955.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update pin mux information for lcd panel on AM335X-EVMSK.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: add comment on pinmux entries

 arch/arm/boot/dts/am335x-evmsk.dts |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index a7e017b..24dde1d 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -32,7 +32,7 @@
 
 	am33xx_pinmux: pinmux@44e10800 {
 		pinctrl-names = "default";
-		pinctrl-0 = <&user_leds_s0 &gpio_keys_s0>;
+		pinctrl-0 = <&user_leds_s0 &gpio_keys_s0 &lcd_pins_s0>;
 
 		user_leds_s0: user_leds_s0 {
 			pinctrl-single,pins = <
@@ -51,6 +51,39 @@
 				0x9c 0x27	/* gpmc_ben0_cle.gpio2_5, INPUT | MODE7 */
 			>;
 		};
+
+		lcd_pins_s0: lcd_pins_s0 {
+			pinctrl-single,pins = <
+				0x20 0x01	/* gpmc_ad8.lcd_data16, OUTPUT | MODE1 */
+				0x24 0x01	/* gpmc_ad9.lcd_data17, OUTPUT | MODE1 */
+				0x28 0x01	/* gpmc_ad10.lcd_data18, OUTPUT | MODE1 */
+				0x2c 0x01	/* gpmc_ad11.lcd_data19, OUTPUT | MODE1 */
+				0x30 0x01	/* gpmc_ad12.lcd_data20, OUTPUT | MODE1 */
+				0x34 0x01	/* gpmc_ad13.lcd_data21, OUTPUT | MODE1 */
+				0x38 0x01	/* gpmc_ad14.lcd_data22, OUTPUT | MODE1 */
+				0x3c 0x01	/* gpmc_ad15.lcd_data23, OUTPUT | MODE1 */
+				0xa0 0x00	/* lcd_data0.lcd_data0, OUTPUT | MODE0 */
+				0xa4 0x00	/* lcd_data1.lcd_data1, OUTPUT | MODE0 */
+				0xa8 0x00	/* lcd_data2.lcd_data2, OUTPUT | MODE0 */
+				0xac 0x00	/* lcd_data3.lcd_data3, OUTPUT | MODE0 */
+				0xb0 0x00	/* lcd_data4.lcd_data4, OUTPUT | MODE0 */
+				0xb4 0x00	/* lcd_data5.lcd_data5, OUTPUT | MODE0 */
+				0xb8 0x00	/* lcd_data6.lcd_data6, OUTPUT | MODE0 */
+				0xbc 0x00	/* lcd_data7.lcd_data7, OUTPUT | MODE0 */
+				0xc0 0x00	/* lcd_data8.lcd_data8, OUTPUT | MODE0 */
+				0xc4 0x00	/* lcd_data9.lcd_data9, OUTPUT | MODE0 */
+				0xc8 0x00	/* lcd_data10.lcd_data10, OUTPUT | MODE0 */
+				0xcc 0x00	/* lcd_data11.lcd_data11, OUTPUT | MODE0 */
+				0xd0 0x00	/* lcd_data12.lcd_data12, OUTPUT | MODE0 */
+				0xd4 0x00	/* lcd_data13.lcd_data13, OUTPUT | MODE0 */
+				0xd8 0x00	/* lcd_data14.lcd_data14, OUTPUT | MODE0 */
+				0xdc 0x00	/* lcd_data15.lcd_data15, OUTPUT | MODE0 */
+				0xe0 0x00	/* lcd_vsync.lcd_vsync, OUTPUT | MODE0 */
+				0xe4 0x00	/* lcd_hsync.lcd_hsync, OUTPUT | MODE0 */
+				0xe8 0x00	/* lcd_pclk.lcd_pclk, OUTPUT | MODE0 */
+				0xec 0x00	/* lcd_ac_bias_en.lcd_ac_bias_en, OUTPUT | MODE0 */
+			>;
+		};
 	};
 
 	ocp {
-- 
1.7.9.5

