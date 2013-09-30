Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3I3OAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:00:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37477 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab3I3OAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:00:34 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <r.sricharan@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: [RFC PATCH 4/6] ARM: DTS: DRA: Replace peripheral interrupt numbers with crossbar inputs.
Date: Mon, 30 Sep 2013 19:29:22 +0530
Message-ID: <1380549564-31045-5-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
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
 arch/arm/boot/dts/dra7.dtsi |   88 +++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 799b7be..bef1c99 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -104,10 +104,10 @@
 		sdma: dma-controller@4a056000 {
 			compatible = "ti,omap4430-sdma";
 			reg = <0x4a056000 0x1000>;
-			interrupts = <0 12 0x4>,
-				     <0 13 0x4>,
-				     <0 14 0x4>,
-				     <0 15 0x4>;
+			interrupts = <0 7 0x4>,
+				     <0 8 0x4>,
+				     <0 9 0x4>,
+				     <0 10 0x4>;
 			#dma-cells = <1>;
 			#dma-channels = <32>;
 			#dma-requests = <127>;
@@ -116,7 +116,7 @@
 		gpio1: gpio@4ae10000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4ae10000 0x200>;
-			interrupts = <0 29 0x4>;
+			interrupts = <0 24 0x4>;
 			ti,hwmods = "gpio1";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -127,7 +127,7 @@
 		gpio2: gpio@48055000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48055000 0x200>;
-			interrupts = <0 30 0x4>;
+			interrupts = <0 25 0x4>;
 			ti,hwmods = "gpio2";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -138,7 +138,7 @@
 		gpio3: gpio@48057000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48057000 0x200>;
-			interrupts = <0 31 0x4>;
+			interrupts = <0 26 0x4>;
 			ti,hwmods = "gpio3";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -149,7 +149,7 @@
 		gpio4: gpio@48059000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48059000 0x200>;
-			interrupts = <0 32 0x4>;
+			interrupts = <0 27 0x4>;
 			ti,hwmods = "gpio4";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -160,7 +160,7 @@
 		gpio5: gpio@4805b000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805b000 0x200>;
-			interrupts = <0 33 0x4>;
+			interrupts = <0 28 0x4>;
 			ti,hwmods = "gpio5";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -171,7 +171,7 @@
 		gpio6: gpio@4805d000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4805d000 0x200>;
-			interrupts = <0 34 0x4>;
+			interrupts = <0 29 0x4>;
 			ti,hwmods = "gpio6";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -182,7 +182,7 @@
 		gpio7: gpio@48051000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48051000 0x200>;
-			interrupts = <0 35 0x4>;
+			interrupts = <0 30 0x4>;
 			ti,hwmods = "gpio7";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -193,7 +193,7 @@
 		gpio8: gpio@48053000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x48053000 0x200>;
-			interrupts = <0 121 0x4>;
+			interrupts = <0 116 0x4>;
 			ti,hwmods = "gpio8";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -204,7 +204,7 @@
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-			interrupts = <0 72 0x4>;
+			interrupts = <0 67 0x4>;
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 		};
@@ -212,7 +212,7 @@
 		uart2: serial@4806c000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806c000 0x100>;
-			interrupts = <0 73 0x4>;
+			interrupts = <0 68 0x4>;
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 		};
@@ -220,7 +220,7 @@
 		uart3: serial@48020000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48020000 0x100>;
-			interrupts = <0 74 0x4>;
+			interrupts = <0 69 0x4>;
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 		};
@@ -228,7 +228,7 @@
 		uart4: serial@4806e000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806e000 0x100>;
-			interrupts = <0 70 0x4>;
+			interrupts = <0 65 0x4>;
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
 		};
@@ -236,7 +236,7 @@
 		uart5: serial@48066000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48066000 0x100>;
-			interrupts = <0 105 0x4>;
+			interrupts = <0 100 0x4>;
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 		};
@@ -244,7 +244,7 @@
 		uart6: serial@48068000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48068000 0x100>;
-			interrupts = <0 106 0x4>;
+			interrupts = <0 101 0x4>;
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 		};
@@ -252,7 +252,7 @@
 		timer1: timer@4ae18000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4ae18000 0x80>;
-			interrupts = <0 37 0x4>;
+			interrupts = <0 32 0x4>;
 			ti,hwmods = "timer1";
 			ti,timer-alwon;
 		};
@@ -260,28 +260,28 @@
 		timer2: timer@48032000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48032000 0x80>;
-			interrupts = <0 38 0x4>;
+			interrupts = <0 33 0x4>;
 			ti,hwmods = "timer2";
 		};
 
 		timer3: timer@48034000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48034000 0x80>;
-			interrupts = <0 39 0x4>;
+			interrupts = <0 34 0x4>;
 			ti,hwmods = "timer3";
 		};
 
 		timer4: timer@48036000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48036000 0x80>;
-			interrupts = <0 40 0x4>;
+			interrupts = <0 35 0x4>;
 			ti,hwmods = "timer4";
 		};
 
 		timer5: timer@48820000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48820000 0x80>;
-			interrupts = <0 41 0x4>;
+			interrupts = <0 36 0x4>;
 			ti,hwmods = "timer5";
 			ti,timer-dsp;
 		};
@@ -289,7 +289,7 @@
 		timer6: timer@48822000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48822000 0x80>;
-			interrupts = <0 42 0x4>;
+			interrupts = <0 37 0x4>;
 			ti,hwmods = "timer6";
 			ti,timer-dsp;
 			ti,timer-pwm;
@@ -298,7 +298,7 @@
 		timer7: timer@48824000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48824000 0x80>;
-			interrupts = <0 43 0x4>;
+			interrupts = <0 38 0x4>;
 			ti,hwmods = "timer7";
 			ti,timer-dsp;
 		};
@@ -306,7 +306,7 @@
 		timer8: timer@48826000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48826000 0x80>;
-			interrupts = <0 44 0x4>;
+			interrupts = <0 39 0x4>;
 			ti,hwmods = "timer8";
 			ti,timer-dsp;
 			ti,timer-pwm;
@@ -315,21 +315,21 @@
 		timer9: timer@4803e000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x4803e000 0x80>;
-			interrupts = <0 45 0x4>;
+			interrupts = <0 40 0x4>;
 			ti,hwmods = "timer9";
 		};
 
 		timer10: timer@48086000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48086000 0x80>;
-			interrupts = <0 46 0x4>;
+			interrupts = <0 41 0x4>;
 			ti,hwmods = "timer10";
 		};
 
 		timer11: timer@48088000 {
 			compatible = "ti,omap5430-timer";
 			reg = <0x48088000 0x80>;
-			interrupts = <0 47 0x4>;
+			interrupts = <0 42 0x4>;
 			ti,hwmods = "timer11";
 			ti,timer-pwm;
 		};
@@ -337,21 +337,21 @@
 		wdt2: wdt@4ae14000 {
 			compatible = "ti,omap4-wdt";
 			reg = <0x4ae14000 0x80>;
-			interrupts = <0 80 0x4>;
+			interrupts = <0 75 0x4>;
 			ti,hwmods = "wd_timer2";
 		};
 
 		dmm: dmm@4e000000 {
 			compatible = "ti,omap5-dmm";
 			reg = <0x4e000000 0x800>;
-			interrupts = <0 113 0x4>;
+			interrupts = <0 108 0x4>;
 			ti,hwmods = "dmm";
 		};
 
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48070000 0x100>;
-			interrupts = <0 56 0x4>;
+			interrupts = <0 51 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c1";
@@ -360,7 +360,7 @@
 		i2c2: i2c@48072000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48072000 0x100>;
-			interrupts = <0 57 0x4>;
+			interrupts = <0 52 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c2";
@@ -369,7 +369,7 @@
 		i2c3: i2c@48060000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x48060000 0x100>;
-			interrupts = <0 61 0x4>;
+			interrupts = <0 56 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c3";
@@ -378,7 +378,7 @@
 		i2c4: i2c@4807a000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807a000 0x100>;
-			interrupts = <0 62 0x4>;
+			interrupts = <0 57 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c4";
@@ -387,7 +387,7 @@
 		i2c5: i2c@4807c000 {
 			compatible = "ti,omap4-i2c";
 			reg = <0x4807c000 0x100>;
-			interrupts = <0 60 0x4>;
+			interrupts = <0 55 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c5";
@@ -396,7 +396,7 @@
 		mmc1: mmc@4809c000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x4809c000 0x400>;
-			interrupts = <0 83 0x4>;
+			interrupts = <0 78 0x4>;
 			ti,hwmods = "mmc1";
 			ti,dual-volt;
 			ti,needs-special-reset;
@@ -407,7 +407,7 @@
 		mmc2: mmc@480b4000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480b4000 0x400>;
-			interrupts = <0 86 0x4>;
+			interrupts = <0 81 0x4>;
 			ti,hwmods = "mmc2";
 			ti,needs-special-reset;
 			dmas = <&sdma 47>, <&sdma 48>;
@@ -417,7 +417,7 @@
 		mmc3: mmc@480ad000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480ad000 0x400>;
-			interrupts = <0 94 0x4>;
+			interrupts = <0 89 0x4>;
 			ti,hwmods = "mmc3";
 			ti,needs-special-reset;
 			dmas = <&sdma 77>, <&sdma 78>;
@@ -427,7 +427,7 @@
 		mmc4: mmc@480d1000 {
 			compatible = "ti,omap4-hsmmc";
 			reg = <0x480d1000 0x400>;
-			interrupts = <0 96 0x4>;
+			interrupts = <0 91 0x4>;
 			ti,hwmods = "mmc4";
 			ti,needs-special-reset;
 			dmas = <&sdma 57>, <&sdma 58>;
@@ -437,7 +437,7 @@
 		mcspi1: spi@48098000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x48098000 0x200>;
-			interrupts = <0 65 0x4>;
+			interrupts = <0 60 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi1";
@@ -457,7 +457,7 @@
 		mcspi2: spi@4809a000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x4809a000 0x200>;
-			interrupts = <0 66 0x4>;
+			interrupts = <0 61 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi2";
@@ -472,7 +472,7 @@
 		mcspi3: spi@480b8000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480b8000 0x200>;
-			interrupts = <0 91 0x4>;
+			interrupts = <0 86 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi3";
@@ -484,7 +484,7 @@
 		mcspi4: spi@480ba000 {
 			compatible = "ti,omap4-mcspi";
 			reg = <0x480ba000 0x200>;
-			interrupts = <0 48 0x4>;
+			interrupts = <0 43 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "mcspi4";
-- 
1.7.9.5

