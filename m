Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3KENQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:16:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52294 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab3KENP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:15:26 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <galak@codeaurora.org>,
        <r.sricharan@ti.com>
CC: Benoit Cousson <bcousson@baylibre.com>
Subject: [PATCH V3 4/7] ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar inputs
Date: Tue, 5 Nov 2013 18:44:14 +0530
Message-ID: <1383657257-3458-5-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383657257-3458-1-git-send-email-r.sricharan@ti.com>
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with the crossbar IP in picture, the peripherals do not have the
fixed interrupt lines. Instead they rely on the crossbar irqchip to
allocate and map a free interrupt line to its crossbar input. So replacing
all the peripheral interrupt numbers with its fixed crossbar input lines.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   86 +++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index cf0d6ca..8b93b7a 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -122,10 +122,10 @@
 		sdma: dma-controller@4a056000 {
 			compatible = "ti,omap4430-sdma";
 			reg = <0x4a056000 0x1000>;
-			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			#dma-channels = <32>;
 			#dma-requests = <127>;
@@ -134,7 +134,7 @@
 		gpio1: gpio@4ae10000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4ae10000 0x200>;
-			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio1";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -145,7 +145,7 @@
 		gpio2: gpio@48055000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48055000 0x200>;
-			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio2";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -156,7 +156,7 @@
 		gpio3: gpio@48057000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48057000 0x200>;
-			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio3";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -167,7 +167,7 @@
 		gpio4: gpio@48059000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48059000 0x200>;
-			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio4";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -178,7 +178,7 @@
 		gpio5: gpio@4805b000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805b000 0x200>;
-			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio5";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -189,7 +189,7 @@
 		gpio6: gpio@4805d000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805d000 0x200>;
-			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio6";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -200,7 +200,7 @@
 		gpio7: gpio@48051000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48051000 0x200>;
-			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio7";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -211,7 +211,7 @@
 		gpio8: gpio@48053000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48053000 0x200>;
-			interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "gpio8";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -222,7 +222,7 @@
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -231,7 +231,7 @@
 		uart2: serial@4806c000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806c000 0x100>;
-			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -240,7 +240,7 @@
 		uart3: serial@48020000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48020000 0x100>;
-			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -249,7 +249,7 @@
 		uart4: serial@4806e000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806e000 0x100>;
-			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
                         status = "disabled";
@@ -258,7 +258,7 @@
 		uart5: serial@48066000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48066000 0x100>;
-			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -267,7 +267,7 @@
 		uart6: serial@48068000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48068000 0x100>;
-			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -308,7 +308,7 @@
 		timer1: timer@4ae18000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4ae18000 0x80>;
-			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer1";
 			ti,timer-alwon;
 		};
@@ -316,28 +316,28 @@
 		timer2: timer@48032000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48032000 0x80>;
-			interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer2";
 		};
 
 		timer3: timer@48034000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48034000 0x80>;
-			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer3";
 		};
 
 		timer4: timer@48036000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48036000 0x80>;
-			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer4";
 		};
 
 		timer5: timer@48820000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48820000 0x80>;
-			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer5";
 			ti,timer-dsp;
 		};
@@ -345,7 +345,7 @@
 		timer6: timer@48822000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48822000 0x80>;
-			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer6";
 			ti,timer-dsp;
 			ti,timer-pwm;
@@ -354,7 +354,7 @@
 		timer7: timer@48824000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48824000 0x80>;
-			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer7";
 			ti,timer-dsp;
 		};
@@ -362,7 +362,7 @@
 		timer8: timer@48826000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48826000 0x80>;
-			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer8";
 			ti,timer-dsp;
 			ti,timer-pwm;
@@ -371,21 +371,21 @@
 		timer9: timer@4803e000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4803e000 0x80>;
-			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer9";
 		};
 
 		timer10: timer@48086000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48086000 0x80>;
-			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer10";
 		};
 
 		timer11: timer@48088000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48088000 0x80>;
-			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "timer11";
 			ti,timer-pwm;
 		};
@@ -421,14 +421,14 @@
 		wdt2: wdt@4ae14000 {
 			compatible = "ti,omap4-wdt";
 			reg = <0x4ae14000 0x80>;
-			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "wd_timer2";
 		};
 
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48070000 0x100>;
-			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c1";
@@ -438,7 +438,7 @@
 		i2c2: i2c@48072000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48072000 0x100>;
-			interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c2";
@@ -448,7 +448,7 @@
 		i2c3: i2c@48060000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48060000 0x100>;
-			interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c3";
@@ -458,7 +458,7 @@
 		i2c4: i2c@4807a000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807a000 0x100>;
-			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c4";
@@ -468,7 +468,7 @@
 		i2c5: i2c@4807c000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807c000 0x100>;
-			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c5";
@@ -478,7 +478,7 @@
 		mmc1: mmc@4809c000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x4809c000 0x400>;
-			interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc1";
 			ti,dual-volt;
 			ti,needs-special-reset;
@@ -490,7 +490,7 @@
 		mmc2: mmc@480b4000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480b4000 0x400>;
-			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc2";
 			ti,needs-special-reset;
 			dmas = <&sdma 47>, <&sdma 48>;
@@ -501,7 +501,7 @@
 		mmc3: mmc@480ad000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480ad000 0x400>;
-			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc3";
 			ti,needs-special-reset;
 			dmas = <&sdma 77>, <&sdma 78>;
@@ -512,7 +512,7 @@
 		mmc4: mmc@480d1000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480d1000 0x400>;
-			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc4";
 			ti,needs-special-reset;
 			dmas = <&sdma 57>, <&sdma 58>;
@@ -523,7 +523,7 @@
 		mcspi1: spi@48098000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x48098000 0x200>;
-			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi1";
@@ -544,7 +544,7 @@
 		mcspi2: spi@4809a000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x4809a000 0x200>;
-			interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi2";
@@ -560,7 +560,7 @@
 		mcspi3: spi@480b8000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480b8000 0x200>;
-			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi3";
@@ -573,7 +573,7 @@
 		mcspi4: spi@480ba000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480ba000 0x200>;
-			interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi4";
-- 
1.7.9.5

