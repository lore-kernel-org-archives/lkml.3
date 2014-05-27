Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaE0Mxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:53:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42763 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaE0Mxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:53:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, olof@lixom.net,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com
Subject: [PATCH] ARM: STi: DT: STiH41x: Convert all uppercase non-defines to lowercase
Date: Tue, 27 May 2014 13:53:08 +0100
Message-Id: <1401195188-23677-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi   | 340 +++++++++++++++---------------
 arch/arm/boot/dts/stih416-b2020-revE.dts |   6 +-
 arch/arm/boot/dts/stih416-pinctrl.dtsi   | 342 +++++++++++++++----------------
 arch/arm/boot/dts/stih41x-b2000.dtsi     |   6 +-
 arch/arm/boot/dts/stih41x-b2020.dtsi     |   6 +-
 5 files changed, 350 insertions(+), 350 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index caeac7e..1e0255d 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -11,33 +11,33 @@
 / {
 
 	aliases {
-		gpio0	= &PIO0;
-		gpio1	= &PIO1;
-		gpio2	= &PIO2;
-		gpio3	= &PIO3;
-		gpio4	= &PIO4;
-		gpio5	= &PIO5;
-		gpio6	= &PIO6;
-		gpio7	= &PIO7;
-		gpio8	= &PIO8;
-		gpio9	= &PIO9;
-		gpio10	= &PIO10;
-		gpio11	= &PIO11;
-		gpio12	= &PIO12;
-		gpio13	= &PIO13;
-		gpio14	= &PIO14;
-		gpio15	= &PIO15;
-		gpio16	= &PIO16;
-		gpio17	= &PIO17;
-		gpio18	= &PIO18;
-		gpio19	= &PIO100;
-		gpio20	= &PIO101;
-		gpio21	= &PIO102;
-		gpio22	= &PIO103;
-		gpio23	= &PIO104;
-		gpio24	= &PIO105;
-		gpio25	= &PIO106;
-		gpio26	= &PIO107;
+		gpio0	= &pio0;
+		gpio1	= &pio1;
+		gpio2	= &pio2;
+		gpio3	= &pio3;
+		gpio4	= &pio4;
+		gpio5	= &pio5;
+		gpio6	= &pio6;
+		gpio7	= &pio7;
+		gpio8	= &pio8;
+		gpio9	= &pio9;
+		gpio10	= &pio10;
+		gpio11	= &pio11;
+		gpio12	= &pio12;
+		gpio13	= &pio13;
+		gpio14	= &pio14;
+		gpio15	= &pio15;
+		gpio16	= &pio16;
+		gpio17	= &pio17;
+		gpio18	= &pio18;
+		gpio19	= &pio100;
+		gpio20	= &pio101;
+		gpio21	= &pio102;
+		gpio22	= &pio103;
+		gpio23	= &pio104;
+		gpio24	= &pio105;
+		gpio25	= &pio106;
+		gpio26	= &pio107;
 	};
 
 	soc {
@@ -52,7 +52,7 @@
 			interrupts-names = "irqmux";
 			ranges 		= <0 0xfe610000 0x5000>;
 
-			PIO0: gpio@fe610000 {
+			pio0: gpio@fe610000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -60,7 +60,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO0";
 			};
-			PIO1: gpio@fe611000 {
+			pio1: gpio@fe611000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -68,7 +68,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO1";
 			};
-			PIO2: gpio@fe612000 {
+			pio2: gpio@fe612000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -76,7 +76,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO2";
 			};
-			PIO3: gpio@fe613000 {
+			pio3: gpio@fe613000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -84,7 +84,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO3";
 			};
-			PIO4: gpio@fe614000 {
+			pio4: gpio@fe614000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -96,8 +96,8 @@
 			sbc_serial1 {
 				pinctrl_sbc_serial1:sbc_serial1 {
 					st,pins {
-						tx	= <&PIO2 6 ALT3 OUT>;
-						rx	= <&PIO2 7 ALT3 IN>;
+						tx	= <&pio2 6 ALT3 OUT>;
+						rx	= <&pio2 7 ALT3 IN>;
 					};
 				};
 			};
@@ -105,15 +105,15 @@
 			keyscan {
 				pinctrl_keyscan: keyscan {
 					st,pins {
-						keyin0 = <&PIO0 2 ALT2 IN>;
-						keyin1 = <&PIO0 3 ALT2 IN>;
-						keyin2 = <&PIO0 4 ALT2 IN>;
-						keyin3 = <&PIO2 6 ALT2 IN>;
-
-						keyout0 = <&PIO1 6 ALT2 OUT>;
-						keyout1 = <&PIO1 7 ALT2 OUT>;
-						keyout2 = <&PIO0 6 ALT2 OUT>;
-						keyout3 = <&PIO2 7 ALT2 OUT>;
+						keyin0 = <&pio0 2 ALT2 IN>;
+						keyin1 = <&pio0 3 ALT2 IN>;
+						keyin2 = <&pio0 4 ALT2 IN>;
+						keyin3 = <&pio2 6 ALT2 IN>;
+
+						keyout0 = <&pio1 6 ALT2 OUT>;
+						keyout1 = <&pio1 7 ALT2 OUT>;
+						keyout2 = <&pio0 6 ALT2 OUT>;
+						keyout3 = <&pio2 7 ALT2 OUT>;
 					};
 				};
 			};
@@ -121,8 +121,8 @@
 			sbc_i2c0 {
 				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
 					st,pins {
-						sda = <&PIO4 6 ALT1 BIDIR>;
-						scl = <&PIO4 5 ALT1 BIDIR>;
+						sda = <&pio4 6 ALT1 BIDIR>;
+						scl = <&pio4 5 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -130,8 +130,8 @@
 			sbc_i2c1 {
 				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
 					st,pins {
-						sda = <&PIO3 2 ALT2 BIDIR>;
-						scl = <&PIO3 1 ALT2 BIDIR>;
+						sda = <&pio3 2 ALT2 BIDIR>;
+						scl = <&pio3 1 ALT2 BIDIR>;
 					};
 				};
 			};
@@ -139,7 +139,7 @@
 			rc{
 				pinctrl_ir: ir0 {
 					st,pins {
-						ir = <&PIO4 0 ALT2 IN>;
+						ir = <&pio4 0 ALT2 IN>;
 					};
 				};
 			};
@@ -147,49 +147,49 @@
 			gmac1 {
 				pinctrl_mii1: mii1 {
 						st,pins {
-						 txd0   = <&PIO0 0 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txd1   = <&PIO0 1 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txd2   = <&PIO0 2 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txd3   = <&PIO0 3 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txer   = <&PIO0 4 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txen   = <&PIO0 5 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
-						 txclk  = <&PIO0 6 ALT1 IN   NICLK	0	CLK_A>;
-						 col    = <&PIO0 7 ALT1 IN   BYPASS	1000>;
-						 mdio   = <&PIO1 0 ALT1 OUT  BYPASS	0>;
-						 mdc    = <&PIO1 1 ALT1 OUT  NICLK	0	CLK_A>;
-						 crs    = <&PIO1 2 ALT1 IN   BYPASS	1000>;
-						 mdint  = <&PIO1 3 ALT1 IN   BYPASS	0>;
-						 rxd0   = <&PIO1 4 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rxd1   = <&PIO1 5 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rxd2   = <&PIO1 6 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rxd3   = <&PIO1 7 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rxdv   = <&PIO2 0 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rx_er  = <&PIO2 1 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
-						 rxclk  = <&PIO2 2 ALT1 IN   NICLK	0	CLK_A>;
-						 phyclk = <&PIO2 3 ALT1 IN   NICLK	1000	CLK_A>;
+						 txd0   = <&pio0 0 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd1   = <&pio0 1 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd2   = <&pio0 2 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd3   = <&pio0 3 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txer   = <&pio0 4 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txen   = <&pio0 5 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txclk  = <&pio0 6 ALT1 IN   NICLK	0	CLK_A>;
+						 col    = <&pio0 7 ALT1 IN   BYPASS	1000>;
+						 mdio   = <&pio1 0 ALT1 OUT  BYPASS	0>;
+						 mdc    = <&pio1 1 ALT1 OUT  NICLK	0	CLK_A>;
+						 crs    = <&pio1 2 ALT1 IN   BYPASS	1000>;
+						 mdint  = <&pio1 3 ALT1 IN   BYPASS	0>;
+						 rxd0   = <&pio1 4 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd1   = <&pio1 5 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd2   = <&pio1 6 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd3   = <&pio1 7 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxdv   = <&pio2 0 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rx_er  = <&pio2 1 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxclk  = <&pio2 2 ALT1 IN   NICLK	0	CLK_A>;
+						 phyclk = <&pio2 3 ALT1 IN   NICLK	1000	CLK_A>;
 					};
 				};
 
 				pinctrl_rgmii1: rgmii1-0 {
 					st,pins {
-						 txd0 =	 <&PIO0 0 ALT1 OUT DE_IO	1000	CLK_A>;
-						 txd1 =	 <&PIO0 1 ALT1 OUT DE_IO	1000	CLK_A>;
-						 txd2 =	 <&PIO0 2 ALT1 OUT DE_IO	1000	CLK_A>;
-						 txd3 =	 <&PIO0 3 ALT1 OUT DE_IO	1000	CLK_A>;
-						 txen =	 <&PIO0 5 ALT1 OUT DE_IO	0	CLK_A>;
-						 txclk = <&PIO0 6 ALT1 IN	NICLK	0	CLK_A>;
-						 mdio =	 <&PIO1 0 ALT1 OUT	BYPASS	0>;
-						 mdc =	 <&PIO1 1 ALT1 OUT	NICLK	0	CLK_A>;
-						 rxd0 =	 <&PIO1 4 ALT1 IN DE_IO	0	CLK_A>;
-						 rxd1 =	 <&PIO1 5 ALT1 IN DE_IO	0	CLK_A>;
-						 rxd2 =	 <&PIO1 6 ALT1 IN DE_IO	0	CLK_A>;
-						 rxd3 =	 <&PIO1 7 ALT1 IN DE_IO	0	CLK_A>;
-
-						 rxdv =	  <&PIO2 0 ALT1 IN DE_IO	500	CLK_A>;
-						 rxclk =  <&PIO2 2 ALT1 IN	NICLK	0	CLK_A>;
-						 phyclk = <&PIO2 3 ALT4 OUT	NICLK	0	CLK_B>;
-
-						 clk125= <&PIO3 7 ALT4 IN 	NICLK	0	CLK_A>;
+						 txd0 =	 <&pio0 0 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd1 =	 <&pio0 1 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd2 =	 <&pio0 2 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd3 =	 <&pio0 3 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txen =	 <&pio0 5 ALT1 OUT DE_IO	0	CLK_A>;
+						 txclk = <&pio0 6 ALT1 IN	NICLK	0	CLK_A>;
+						 mdio =	 <&pio1 0 ALT1 OUT	BYPASS	0>;
+						 mdc =	 <&pio1 1 ALT1 OUT	NICLK	0	CLK_A>;
+						 rxd0 =	 <&pio1 4 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd1 =	 <&pio1 5 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd2 =	 <&pio1 6 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd3 =	 <&pio1 7 ALT1 IN DE_IO	0	CLK_A>;
+
+						 rxdv =	  <&pio2 0 ALT1 IN DE_IO	500	CLK_A>;
+						 rxclk =  <&pio2 2 ALT1 IN	NICLK	0	CLK_A>;
+						 phyclk = <&pio2 3 ALT4 OUT	NICLK	0	CLK_B>;
+
+						 clk125= <&pio3 7 ALT4 IN 	NICLK	0	CLK_A>;
 					};
 				};
 			};
@@ -206,7 +206,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfee00000 0x8000>;
 
-			PIO5: gpio@fee00000 {
+			pio5: gpio@fee00000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -214,7 +214,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO5";
 			};
-			PIO6: gpio@fee01000 {
+			pio6: gpio@fee01000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -222,7 +222,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO6";
 			};
-			PIO7: gpio@fee02000 {
+			pio7: gpio@fee02000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -230,7 +230,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO7";
 			};
-			PIO8: gpio@fee03000 {
+			pio8: gpio@fee03000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -238,7 +238,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO8";
 			};
-			PIO9: gpio@fee04000 {
+			pio9: gpio@fee04000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -246,7 +246,7 @@
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO9";
 			};
-			PIO10: gpio@fee05000 {
+			pio10: gpio@fee05000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -254,7 +254,7 @@
 				reg		= <0x5000 0x100>;
 				st,bank-name	= "PIO10";
 			};
-			PIO11: gpio@fee06000 {
+			pio11: gpio@fee06000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -262,7 +262,7 @@
 				reg		= <0x6000 0x100>;
 				st,bank-name	= "PIO11";
 			};
-			PIO12: gpio@fee07000 {
+			pio12: gpio@fee07000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -274,8 +274,8 @@
 			i2c0 {
 				pinctrl_i2c0_default: i2c0-default {
 					st,pins {
-						sda = <&PIO9 3 ALT1 BIDIR>;
-						scl = <&PIO9 2 ALT1 BIDIR>;
+						sda = <&pio9 3 ALT1 BIDIR>;
+						scl = <&pio9 2 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -283,8 +283,8 @@
 			i2c1 {
 				pinctrl_i2c1_default: i2c1-default {
 					st,pins {
-						sda = <&PIO12 1 ALT1 BIDIR>;
-						scl = <&PIO12 0 ALT1 BIDIR>;
+						sda = <&pio12 1 ALT1 BIDIR>;
+						scl = <&pio12 0 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -301,7 +301,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfe820000 0x8000>;
 
-			PIO13: gpio@fe820000 {
+			pio13: gpio@fe820000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -309,7 +309,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO13";
 			};
-			PIO14: gpio@fe821000 {
+			pio14: gpio@fe821000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -317,7 +317,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO14";
 			};
-			PIO15: gpio@fe822000 {
+			pio15: gpio@fe822000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -325,7 +325,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO15";
 			};
-			PIO16: gpio@fe823000 {
+			pio16: gpio@fe823000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -333,7 +333,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO16";
 			};
-			PIO17: gpio@fe824000 {
+			pio17: gpio@fe824000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -341,7 +341,7 @@
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO17";
 			};
-			PIO18: gpio@fe825000 {
+			pio18: gpio@fe825000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -353,8 +353,8 @@
 			serial2 {
 				pinctrl_serial2: serial2-0 {
 					st,pins {
-						tx	= <&PIO17 4 ALT2 OUT>;
-						rx	= <&PIO17 5 ALT2 IN>;
+						tx	= <&pio17 4 ALT2 OUT>;
+						rx	= <&pio17 5 ALT2 IN>;
 					};
 				};
 			};
@@ -362,68 +362,68 @@
 			gmac0{
 				pinctrl_mii0: mii0 {
 					st,pins {
-					 mdint =	<&PIO13 6 ALT2	IN	BYPASS		0>;
-					 txen =		<&PIO13 7 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
-
-					 txd0 =		<&PIO14 0 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
-					 txd1 =		<&PIO14 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
-					 txd2 =		<&PIO14 2 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
-					 txd3 =		<&PIO14 3 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
-
-					 txclk =	<&PIO15 0 ALT2	IN	NICLK		0	CLK_A>;
-					 txer =		<&PIO15 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
-					 crs =		<&PIO15 2 ALT2	IN	BYPASS		1000>;
-					 col =		<&PIO15 3 ALT2	IN	BYPASS		1000>;
-					 mdio  =        <&PIO15 4 ALT2	OUT	BYPASS 	3000>;
-					 mdc   =        <&PIO15 5 ALT2	OUT     NICLK  	0    	CLK_B>;
-
-					 rxd0 =		<&PIO16 0 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rxd1 =		<&PIO16 1 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rxd2 =		<&PIO16 2 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rxd3 =		<&PIO16 3 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rxdv =		<&PIO15 6 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rx_er =	<&PIO15 7 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
-					 rxclk =	<&PIO17 0 ALT2	IN	NICLK		0	CLK_A>;
-					 phyclk =	<&PIO13 5 ALT2	OUT	NICLK	1000	CLK_A>;
+					 mdint =	<&pio13 6 ALT2	IN	BYPASS		0>;
+					 txen =		<&pio13 7 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+
+					 txd0 =		<&pio14 0 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 txd1 =		<&pio14 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 txd2 =		<&pio14 2 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
+					 txd3 =		<&pio14 3 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
+
+					 txclk =	<&pio15 0 ALT2	IN	NICLK		0	CLK_A>;
+					 txer =		<&pio15 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 crs =		<&pio15 2 ALT2	IN	BYPASS		1000>;
+					 col =		<&pio15 3 ALT2	IN	BYPASS		1000>;
+					 mdio  =        <&pio15 4 ALT2	OUT	BYPASS 	3000>;
+					 mdc   =        <&pio15 5 ALT2	OUT     NICLK  	0    	CLK_B>;
+
+					 rxd0 =		<&pio16 0 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd1 =		<&pio16 1 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd2 =		<&pio16 2 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd3 =		<&pio16 3 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxdv =		<&pio15 6 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rx_er =	<&pio15 7 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxclk =	<&pio17 0 ALT2	IN	NICLK		0	CLK_A>;
+					 phyclk =	<&pio13 5 ALT2	OUT	NICLK	1000	CLK_A>;
 
 					};
 				};
 
 			pinctrl_gmii0: gmii0 {
 				st,pins {
-					 mdint =	<&PIO13 6	ALT2 IN		BYPASS	0>;
-					 mdio  =        <&PIO15 4 	ALT2 OUT	BYPASS 	3000>;
-					 mdc   =        <&PIO15 5 	ALT2 OUT    	NICLK  	0    	CLK_B>;
-					 txen =		<&PIO13 7	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
-
-					 txd0 =		<&PIO14 0	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
-					 txd1 =		<&PIO14 1	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
-					 txd2 =		<&PIO14 2	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-					 txd3 =		<&PIO14 3	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-					 txd4 =		<&PIO14 4	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-					 txd5 =		<&PIO14 5	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-					 txd6 =		<&PIO14 6	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-					 txd7 =		<&PIO14 7	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
-
-					 txclk =	<&PIO15 0	ALT2 IN		NICLK	0	CLK_A>;
-					 txer =		<&PIO15 1	ALT2 OUT 	SE_NICLK_IO	3000	CLK_A>;
-					 crs =		<&PIO15 2	ALT2 IN		BYPASS	1000>;
-					 col =		<&PIO15 3	ALT2 IN		BYPASS	1000>;
-					 rxdv =		<&PIO15 6	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rx_er =	<&PIO15 7	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-
-					 rxd0 =		<&PIO16 0	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd1 =		<&PIO16 1	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd2 =		<&PIO16 2	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd3 =		<&PIO16 3	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd4 =		<&PIO16 4	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd5 =		<&PIO16 5	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd6 =		<&PIO16 6	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-					 rxd7 =		<&PIO16 7	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
-
-					 rxclk =	<&PIO17 0	ALT2 IN	NICLK	0	CLK_A>;
-					 clk125 =	<&PIO17 6	ALT1 IN	NICLK	0	CLK_A>;
-                                         phyclk =       <&PIO13 5       ALT4 OUT NICLK   0       CLK_B>;
+					 mdint =	<&pio13 6	ALT2 IN		BYPASS	0>;
+					 mdio  =        <&pio15 4 	ALT2 OUT	BYPASS 	3000>;
+					 mdc   =        <&pio15 5 	ALT2 OUT    	NICLK  	0    	CLK_B>;
+					 txen =		<&pio13 7	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
+
+					 txd0 =		<&pio14 0	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
+					 txd1 =		<&pio14 1	ALT2 OUT	SE_NICLK_IO	3000	CLK_A>;
+					 txd2 =		<&pio14 2	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+					 txd3 =		<&pio14 3	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+					 txd4 =		<&pio14 4	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+					 txd5 =		<&pio14 5	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+					 txd6 =		<&pio14 6	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+					 txd7 =		<&pio14 7	ALT2 OUT	SE_NICLK_IO	3000	CLK_B>;
+
+					 txclk =	<&pio15 0	ALT2 IN		NICLK	0	CLK_A>;
+					 txer =		<&pio15 1	ALT2 OUT 	SE_NICLK_IO	3000	CLK_A>;
+					 crs =		<&pio15 2	ALT2 IN		BYPASS	1000>;
+					 col =		<&pio15 3	ALT2 IN		BYPASS	1000>;
+					 rxdv =		<&pio15 6	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rx_er =	<&pio15 7	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+
+					 rxd0 =		<&pio16 0	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd1 =		<&pio16 1	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd2 =		<&pio16 2	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd3 =		<&pio16 3	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd4 =		<&pio16 4	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd5 =		<&pio16 5	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd6 =		<&pio16 6	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+					 rxd7 =		<&pio16 7	ALT2 IN		SE_NICLK_IO	1500	CLK_A>;
+
+					 rxclk =	<&pio17 0	ALT2 IN	NICLK	0	CLK_A>;
+					 clk125 =	<&pio17 6	ALT1 IN	NICLK	0	CLK_A>;
+                                         phyclk =       <&pio13 5       ALT4 OUT NICLK   0       CLK_B>;
 
 
 					};
@@ -442,7 +442,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfd6b0000 0x3000>;
 
-			PIO100: gpio@fd6b0000 {
+			pio100: gpio@fd6b0000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -450,7 +450,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO100";
 			};
-			PIO101: gpio@fd6b1000 {
+			pio101: gpio@fd6b1000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -458,7 +458,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO101";
 			};
-			PIO102: gpio@fd6b2000 {
+			pio102: gpio@fd6b2000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -479,7 +479,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfd330000 0x5000>;
 
-			PIO103: gpio@fd330000 {
+			pio103: gpio@fd330000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -487,7 +487,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO103";
 			};
-			PIO104: gpio@fd331000 {
+			pio104: gpio@fd331000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -495,7 +495,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO104";
 			};
-			PIO105: gpio@fd332000 {
+			pio105: gpio@fd332000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -503,7 +503,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO105";
 			};
-			PIO106: gpio@fd333000 {
+			pio106: gpio@fd333000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -511,7 +511,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO106";
 			};
-			PIO107: gpio@fd334000 {
+			pio107: gpio@fd334000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index ba0fa2c..d72e5c7 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -19,17 +19,17 @@
 			red {
 				#gpio-cells		= <1>;
 				label			= "Front Panel LED";
-				gpios			= <&PIO4 1>;
+				gpios			= <&pio4 1>;
 				linux,default-trigger	= "heartbeat";
 			};
 			green {
-				gpios			= <&PIO1 3>;
+				gpios			= <&pio1 3>;
 				default-state 		= "off";
 			};
 		};
 
 		ethernet1: dwmac@fef08000 {
-			snps,reset-gpio = <&PIO0 7>;
+			snps,reset-gpio = <&pio0 7>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 6252188..3e06d7f 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -12,36 +12,36 @@
 / {
 
 	aliases {
-		gpio0	= &PIO0;
-		gpio1	= &PIO1;
-		gpio2	= &PIO2;
-		gpio3	= &PIO3;
-		gpio4	= &PIO4;
-		gpio5	= &PIO40;
-		gpio6	= &PIO5;
-		gpio7	= &PIO6;
-		gpio8	= &PIO7;
-		gpio9	= &PIO8;
-		gpio10	= &PIO9;
-		gpio11	= &PIO10;
-		gpio12	= &PIO11;
-		gpio13	= &PIO12;
-		gpio14	= &PIO30;
-		gpio15	= &PIO31;
-		gpio16	= &PIO13;
-		gpio17	= &PIO14;
-		gpio18	= &PIO15;
-		gpio19	= &PIO16;
-		gpio20	= &PIO17;
-		gpio21	= &PIO18;
-		gpio22	= &PIO100;
-		gpio23	= &PIO101;
-		gpio24	= &PIO102;
-		gpio25	= &PIO103;
-		gpio26	= &PIO104;
-		gpio27	= &PIO105;
-		gpio28	= &PIO106;
-		gpio29	= &PIO107;
+		gpio0	= &pio0;
+		gpio1	= &pio1;
+		gpio2	= &pio2;
+		gpio3	= &pio3;
+		gpio4	= &pio4;
+		gpio5	= &pio40;
+		gpio6	= &pio5;
+		gpio7	= &pio6;
+		gpio8	= &pio7;
+		gpio9	= &pio8;
+		gpio10	= &pio9;
+		gpio11	= &pio10;
+		gpio12	= &pio11;
+		gpio13	= &pio12;
+		gpio14	= &pio30;
+		gpio15	= &pio31;
+		gpio16	= &pio13;
+		gpio17	= &pio14;
+		gpio18	= &pio15;
+		gpio19	= &pio16;
+		gpio20	= &pio17;
+		gpio21	= &pio18;
+		gpio22	= &pio100;
+		gpio23	= &pio101;
+		gpio24	= &pio102;
+		gpio25	= &pio103;
+		gpio26	= &pio104;
+		gpio27	= &pio105;
+		gpio28	= &pio106;
+		gpio29	= &pio107;
 	};
 
 	soc {
@@ -56,7 +56,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfe610000 0x6000>;
 
-			PIO0: gpio@fe610000 {
+			pio0: gpio@fe610000 {
 				gpio-controller;
 				#gpio-cells = <1>;
 				interrupt-controller;
@@ -64,7 +64,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO0";
 			};
-			PIO1: gpio@fe611000 {
+			pio1: gpio@fe611000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -72,7 +72,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO1";
 			};
-			PIO2: gpio@fe612000 {
+			pio2: gpio@fe612000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -80,7 +80,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO2";
 			};
-			PIO3: gpio@fe613000 {
+			pio3: gpio@fe613000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -88,7 +88,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO3";
 			};
-			PIO4: gpio@fe614000 {
+			pio4: gpio@fe614000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -96,7 +96,7 @@
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO4";
 			};
-			PIO40: gpio@fe615000 {
+			pio40: gpio@fe615000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -109,15 +109,15 @@
 			rc{
 				pinctrl_ir: ir0 {
 					st,pins {
-						ir = <&PIO4 0 ALT2 IN>;
+						ir = <&pio4 0 ALT2 IN>;
 					};
 				};
 			};
 			sbc_serial1 {
 				pinctrl_sbc_serial1: sbc_serial1 {
 					st,pins {
-						tx	= <&PIO2 6 ALT3 OUT>;
-						rx	= <&PIO2 7 ALT3 IN>;
+						tx	= <&pio2 6 ALT3 OUT>;
+						rx	= <&pio2 7 ALT3 IN>;
 					};
 				};
 			};
@@ -125,15 +125,15 @@
 			keyscan {
 				pinctrl_keyscan: keyscan {
 					st,pins {
-						keyin0 = <&PIO0 2 ALT2 IN>;
-						keyin1 = <&PIO0 3 ALT2 IN>;
-						keyin2 = <&PIO0 4 ALT2 IN>;
-						keyin3 = <&PIO2 6 ALT2 IN>;
-
-						keyout0 = <&PIO1 6 ALT2 OUT>;
-						keyout1 = <&PIO1 7 ALT2 OUT>;
-						keyout2 = <&PIO0 6 ALT2 OUT>;
-						keyout3 = <&PIO2 7 ALT2 OUT>;
+						keyin0 = <&pio0 2 ALT2 IN>;
+						keyin1 = <&pio0 3 ALT2 IN>;
+						keyin2 = <&pio0 4 ALT2 IN>;
+						keyin3 = <&pio2 6 ALT2 IN>;
+
+						keyout0 = <&pio1 6 ALT2 OUT>;
+						keyout1 = <&pio1 7 ALT2 OUT>;
+						keyout2 = <&pio0 6 ALT2 OUT>;
+						keyout3 = <&pio2 7 ALT2 OUT>;
 					};
 				};
 			};
@@ -141,8 +141,8 @@
 			sbc_i2c0 {
 				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
 					st,pins {
-						sda = <&PIO4 6 ALT1 BIDIR>;
-						scl = <&PIO4 5 ALT1 BIDIR>;
+						sda = <&pio4 6 ALT1 BIDIR>;
+						scl = <&pio4 5 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -150,8 +150,8 @@
 			sbc_i2c1 {
 				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
 					st,pins {
-						sda = <&PIO3 2 ALT2 BIDIR>;
-						scl = <&PIO3 1 ALT2 BIDIR>;
+						sda = <&pio3 2 ALT2 BIDIR>;
+						scl = <&pio3 1 ALT2 BIDIR>;
 					};
 				};
 			};
@@ -159,51 +159,51 @@
 			gmac1 {
 				pinctrl_mii1: mii1 {
 					st,pins {
-						txd0 = <&PIO0 0 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txd1 = <&PIO0 1 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txd2 = <&PIO0 2 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txd3 = <&PIO0 3 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txer = <&PIO0 4 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txen = <&PIO0 5 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
-						txclk = <&PIO0 6 ALT1 IN NICLK 0 CLK_A>;
-						col =   <&PIO0 7 ALT1 IN BYPASS 1000>;
-
-						mdio =  <&PIO1 0 ALT1 OUT BYPASS 1500>;
-						mdc =   <&PIO1 1 ALT1 OUT NICLK 0 CLK_A>;
-						crs =   <&PIO1 2 ALT1 IN BYPASS 1000>;
-						mdint = <&PIO1 3 ALT1 IN BYPASS 0>;
-						rxd0 =  <&PIO1 4 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-						rxd1 =  <&PIO1 5 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-						rxd2 =  <&PIO1 6 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-						rxd3 =  <&PIO1 7 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-
-						rxdv =  <&PIO2 0 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-						rx_er = <&PIO2 1 ALT1 IN SE_NICLK_IO 0 CLK_A>;
-						rxclk = <&PIO2 2 ALT1 IN NICLK 0 CLK_A>;
-						phyclk = <&PIO2 3 ALT1 OUT NICLK 0 CLK_A>;
+						txd0 = <&pio0 0 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd1 = <&pio0 1 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd2 = <&pio0 2 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd3 = <&pio0 3 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txer = <&pio0 4 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txen = <&pio0 5 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txclk = <&pio0 6 ALT1 IN NICLK 0 CLK_A>;
+						col =   <&pio0 7 ALT1 IN BYPASS 1000>;
+
+						mdio =  <&pio1 0 ALT1 OUT BYPASS 1500>;
+						mdc =   <&pio1 1 ALT1 OUT NICLK 0 CLK_A>;
+						crs =   <&pio1 2 ALT1 IN BYPASS 1000>;
+						mdint = <&pio1 3 ALT1 IN BYPASS 0>;
+						rxd0 =  <&pio1 4 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd1 =  <&pio1 5 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd2 =  <&pio1 6 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd3 =  <&pio1 7 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+
+						rxdv =  <&pio2 0 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rx_er = <&pio2 1 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxclk = <&pio2 2 ALT1 IN NICLK 0 CLK_A>;
+						phyclk = <&pio2 3 ALT1 OUT NICLK 0 CLK_A>;
 					};
 				};
 				pinctrl_rgmii1: rgmii1-0 {
 					st,pins {
-						txd0 =  <&PIO0 0 ALT1 OUT DE_IO 500 CLK_A>;
-						txd1 =  <&PIO0 1 ALT1 OUT DE_IO 500 CLK_A>;
-						txd2 =  <&PIO0 2 ALT1 OUT DE_IO 500 CLK_A>;
-						txd3 =  <&PIO0 3 ALT1 OUT DE_IO 500 CLK_A>;
-						txen =  <&PIO0 5 ALT1 OUT DE_IO 0   CLK_A>;
-						txclk = <&PIO0 6 ALT1 IN  NICLK 0   CLK_A>;
-
-						mdio = <&PIO1 0 ALT1 OUT BYPASS 0>;
-						mdc  = <&PIO1 1 ALT1 OUT NICLK  0 CLK_A>;
-						rxd0 = <&PIO1 4 ALT1 IN DE_IO 500 CLK_A>;
-						rxd1 = <&PIO1 5 ALT1 IN DE_IO 500 CLK_A>;
-						rxd2 = <&PIO1 6 ALT1 IN DE_IO 500 CLK_A>;
-						rxd3 = <&PIO1 7 ALT1 IN DE_IO 500 CLK_A>;
-
-						rxdv   = <&PIO2 0 ALT1 IN  DE_IO 500 CLK_A>;
-						rxclk  = <&PIO2 2 ALT1 IN  NICLK 0   CLK_A>;
-						phyclk = <&PIO2 3 ALT4 OUT NICLK 0   CLK_B>;
-
-						clk125= <&PIO3 7 ALT4 IN NICLK 0 CLK_A>;
+						txd0 =  <&pio0 0 ALT1 OUT DE_IO 500 CLK_A>;
+						txd1 =  <&pio0 1 ALT1 OUT DE_IO 500 CLK_A>;
+						txd2 =  <&pio0 2 ALT1 OUT DE_IO 500 CLK_A>;
+						txd3 =  <&pio0 3 ALT1 OUT DE_IO 500 CLK_A>;
+						txen =  <&pio0 5 ALT1 OUT DE_IO 0   CLK_A>;
+						txclk = <&pio0 6 ALT1 IN  NICLK 0   CLK_A>;
+
+						mdio = <&pio1 0 ALT1 OUT BYPASS 0>;
+						mdc  = <&pio1 1 ALT1 OUT NICLK  0 CLK_A>;
+						rxd0 = <&pio1 4 ALT1 IN DE_IO 500 CLK_A>;
+						rxd1 = <&pio1 5 ALT1 IN DE_IO 500 CLK_A>;
+						rxd2 = <&pio1 6 ALT1 IN DE_IO 500 CLK_A>;
+						rxd3 = <&pio1 7 ALT1 IN DE_IO 500 CLK_A>;
+
+						rxdv   = <&pio2 0 ALT1 IN  DE_IO 500 CLK_A>;
+						rxclk  = <&pio2 2 ALT1 IN  NICLK 0   CLK_A>;
+						phyclk = <&pio2 3 ALT4 OUT NICLK 0   CLK_B>;
+
+						clk125= <&pio3 7 ALT4 IN NICLK 0 CLK_A>;
 					};
 				};
 			};
@@ -220,7 +220,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfee00000 0x10000>;
 
-			PIO5: gpio@fee00000 {
+			pio5: gpio@fee00000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -228,7 +228,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO5";
 			};
-			PIO6: gpio@fee01000 {
+			pio6: gpio@fee01000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -236,7 +236,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO6";
 			};
-			PIO7: gpio@fee02000 {
+			pio7: gpio@fee02000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -244,7 +244,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO7";
 			};
-			PIO8: gpio@fee03000 {
+			pio8: gpio@fee03000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -252,7 +252,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO8";
 			};
-			PIO9: gpio@fee04000 {
+			pio9: gpio@fee04000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -260,7 +260,7 @@
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO9";
 			};
-			PIO10: gpio@fee05000 {
+			pio10: gpio@fee05000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -268,7 +268,7 @@
 				reg		= <0x5000 0x100>;
 				st,bank-name	= "PIO10";
 			};
-			PIO11: gpio@fee06000 {
+			pio11: gpio@fee06000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -276,7 +276,7 @@
 				reg		= <0x6000 0x100>;
 				st,bank-name	= "PIO11";
 			};
-			PIO12: gpio@fee07000 {
+			pio12: gpio@fee07000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -284,7 +284,7 @@
 				reg		= <0x7000 0x100>;
 				st,bank-name	= "PIO12";
 			};
-			PIO30: gpio@fee08000 {
+			pio30: gpio@fee08000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -292,7 +292,7 @@
 				reg		= <0x8000 0x100>;
 				st,bank-name	= "PIO30";
 			};
-			PIO31: gpio@fee09000 {
+			pio31: gpio@fee09000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -304,7 +304,7 @@
 			serial2-oe {
 				pinctrl_serial2_oe: serial2-1 {
 					st,pins {
-						output-enable	= <&PIO11 3 ALT2 OUT>;
+						output-enable	= <&pio11 3 ALT2 OUT>;
 					};
 				};
 			};
@@ -312,8 +312,8 @@
 			i2c0 {
 				pinctrl_i2c0_default: i2c0-default {
 					st,pins {
-						sda = <&PIO9 3 ALT1 BIDIR>;
-						scl = <&PIO9 2 ALT1 BIDIR>;
+						sda = <&pio9 3 ALT1 BIDIR>;
+						scl = <&pio9 2 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -321,8 +321,8 @@
 			i2c1 {
 				pinctrl_i2c1_default: i2c1-default {
 					st,pins {
-						sda = <&PIO12 1 ALT1 BIDIR>;
-						scl = <&PIO12 0 ALT1 BIDIR>;
+						sda = <&pio12 1 ALT1 BIDIR>;
+						scl = <&pio12 0 ALT1 BIDIR>;
 					};
 				};
 			};
@@ -330,12 +330,12 @@
 			fsm {
 				pinctrl_fsm: fsm {
 					st,pins {
-						spi-fsm-clk  = <&PIO12 2 ALT1 OUT>;
-						spi-fsm-cs   = <&PIO12 3 ALT1 OUT>;
-						spi-fsm-mosi = <&PIO12 4 ALT1 OUT>;
-						spi-fsm-miso = <&PIO12 5 ALT1 IN>;
-						spi-fsm-hol  = <&PIO12 6 ALT1 OUT>;
-						spi-fsm-wp   = <&PIO12 7 ALT1 OUT>;
+						spi-fsm-clk  = <&pio12 2 ALT1 OUT>;
+						spi-fsm-cs   = <&pio12 3 ALT1 OUT>;
+						spi-fsm-mosi = <&pio12 4 ALT1 OUT>;
+						spi-fsm-miso = <&pio12 5 ALT1 IN>;
+						spi-fsm-hol  = <&pio12 6 ALT1 OUT>;
+						spi-fsm-wp   = <&pio12 7 ALT1 OUT>;
 					};
 				};
 			};
@@ -352,7 +352,7 @@
 			interrupts-names = "irqmux";
 			ranges 		= <0 0xfe820000 0x6000>;
 
-			PIO13: gpio@fe820000 {
+			pio13: gpio@fe820000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -360,7 +360,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO13";
 			};
-			PIO14: gpio@fe821000 {
+			pio14: gpio@fe821000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -368,7 +368,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO14";
 			};
-			PIO15: gpio@fe822000 {
+			pio15: gpio@fe822000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -376,7 +376,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO15";
 			};
-			PIO16: gpio@fe823000 {
+			pio16: gpio@fe823000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -384,7 +384,7 @@
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO16";
 			};
-			PIO17: gpio@fe824000 {
+			pio17: gpio@fe824000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -392,7 +392,7 @@
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO17";
 			};
-			PIO18: gpio@fe825000 {
+			pio18: gpio@fe825000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -405,8 +405,8 @@
 			serial2 {
 				pinctrl_serial2: serial2-0 {
 					st,pins {
-						tx	= <&PIO17 4 ALT2 OUT>;
-						rx	= <&PIO17 5 ALT2 IN>;
+						tx	= <&pio17 4 ALT2 OUT>;
+						rx	= <&pio17 5 ALT2 IN>;
 					};
 				};
 			};
@@ -414,28 +414,28 @@
 			gmac0 {
 				pinctrl_mii0: mii0 {
 					st,pins {
-						mdint = <&PIO13 6 ALT2 IN  BYPASS      0>;
-						txen =  <&PIO13 7 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
-						txd0 =  <&PIO14 0 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
-						txd1 =  <&PIO14 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
-						txd2 =  <&PIO14 2 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
-						txd3 =  <&PIO14 3 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
-
-						txclk = <&PIO15 0 ALT2 IN  NICLK       0 CLK_A>;
-						txer =  <&PIO15 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
-						crs = <&PIO15 2 ALT2 IN  BYPASS 1000>;
-						col = <&PIO15 3 ALT2 IN  BYPASS 1000>;
-						mdio= <&PIO15 4 ALT2 OUT BYPASS 1500>;
-						mdc = <&PIO15 5 ALT2 OUT NICLK  0    CLK_B>;
-
-						rxd0 =  <&PIO16 0 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rxd1 =  <&PIO16 1 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rxd2 =  <&PIO16 2 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rxd3 =  <&PIO16 3 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rxdv =  <&PIO15 6 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rx_er = <&PIO15 7 ALT2 IN SE_NICLK_IO 0 CLK_A>;
-						rxclk = <&PIO17 0 ALT2 IN NICLK 0 CLK_A>;
-						phyclk = <&PIO13 5 ALT2 OUT NICLK 0 CLK_B>;
+						mdint = <&pio13 6 ALT2 IN  BYPASS      0>;
+						txen =  <&pio13 7 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd0 =  <&pio14 0 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd1 =  <&pio14 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd2 =  <&pio14 2 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
+						txd3 =  <&pio14 3 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
+
+						txclk = <&pio15 0 ALT2 IN  NICLK       0 CLK_A>;
+						txer =  <&pio15 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						crs = <&pio15 2 ALT2 IN  BYPASS 1000>;
+						col = <&pio15 3 ALT2 IN  BYPASS 1000>;
+						mdio= <&pio15 4 ALT2 OUT BYPASS 1500>;
+						mdc = <&pio15 5 ALT2 OUT NICLK  0    CLK_B>;
+
+						rxd0 =  <&pio16 0 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd1 =  <&pio16 1 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd2 =  <&pio16 2 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd3 =  <&pio16 3 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxdv =  <&pio15 6 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rx_er = <&pio15 7 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxclk = <&pio17 0 ALT2 IN NICLK 0 CLK_A>;
+						phyclk = <&pio13 5 ALT2 OUT NICLK 0 CLK_B>;
 					};
 				};
 
@@ -445,25 +445,25 @@
 				};
 				pinctrl_rgmii0: rgmii0 {
 					st,pins {
-						 phyclk = <&PIO13  5 ALT4 OUT NICLK 0 CLK_B>;
-						 txen = <&PIO13 7 ALT2 OUT DE_IO 0 CLK_A>;
-						 txd0  = <&PIO14 0 ALT2 OUT DE_IO 500 CLK_A>;
-						 txd1  = <&PIO14 1 ALT2 OUT DE_IO 500 CLK_A>;
-						 txd2  = <&PIO14 2 ALT2 OUT DE_IO 500 CLK_B>;
-						 txd3  = <&PIO14 3 ALT2 OUT DE_IO 500 CLK_B>;
-						 txclk = <&PIO15 0 ALT2 IN NICLK 0 CLK_A>;
-
-						 mdio = <&PIO15 4 ALT2 OUT BYPASS 0>;
-						 mdc = <&PIO15 5 ALT2 OUT NICLK 0 CLK_B>;
-
-						 rxdv = <&PIO15 6 ALT2 IN DE_IO 500 CLK_A>;
-						 rxd0 =<&PIO16 0 ALT2 IN DE_IO	500 CLK_A>;
-						 rxd1 =<&PIO16 1 ALT2 IN DE_IO	500 CLK_A>;
-						 rxd2 =<&PIO16 2 ALT2 IN DE_IO	500 CLK_A>;
-						 rxd3  =<&PIO16 3 ALT2 IN DE_IO 500 CLK_A>;
-						 rxclk =<&PIO17 0 ALT2 IN NICLK 0 CLK_A>;
-
-						 clk125=<&PIO17 6 ALT1 IN NICLK 0 CLK_A>;
+						 phyclk = <&pio13  5 ALT4 OUT NICLK 0 CLK_B>;
+						 txen = <&pio13 7 ALT2 OUT DE_IO 0 CLK_A>;
+						 txd0  = <&pio14 0 ALT2 OUT DE_IO 500 CLK_A>;
+						 txd1  = <&pio14 1 ALT2 OUT DE_IO 500 CLK_A>;
+						 txd2  = <&pio14 2 ALT2 OUT DE_IO 500 CLK_B>;
+						 txd3  = <&pio14 3 ALT2 OUT DE_IO 500 CLK_B>;
+						 txclk = <&pio15 0 ALT2 IN NICLK 0 CLK_A>;
+
+						 mdio = <&pio15 4 ALT2 OUT BYPASS 0>;
+						 mdc = <&pio15 5 ALT2 OUT NICLK 0 CLK_B>;
+
+						 rxdv = <&pio15 6 ALT2 IN DE_IO 500 CLK_A>;
+						 rxd0 =<&pio16 0 ALT2 IN DE_IO	500 CLK_A>;
+						 rxd1 =<&pio16 1 ALT2 IN DE_IO	500 CLK_A>;
+						 rxd2 =<&pio16 2 ALT2 IN DE_IO	500 CLK_A>;
+						 rxd3  =<&pio16 3 ALT2 IN DE_IO 500 CLK_A>;
+						 rxclk =<&pio17 0 ALT2 IN NICLK 0 CLK_A>;
+
+						 clk125=<&pio17 6 ALT1 IN NICLK 0 CLK_A>;
 					};
 				};
 			};
@@ -480,7 +480,7 @@
 			interrupts-names = "irqmux";
 			ranges		= <0 0xfd6b0000 0x3000>;
 
-			PIO100: gpio@fd6b0000 {
+			pio100: gpio@fd6b0000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -488,7 +488,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO100";
 			};
-			PIO101: gpio@fd6b1000 {
+			pio101: gpio@fd6b1000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -496,7 +496,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO101";
 			};
-			PIO102: gpio@fd6b2000 {
+			pio102: gpio@fd6b2000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -517,7 +517,7 @@
 			interrupts-names = "irqmux";
 			ranges			= <0 0xfd330000 0x5000>;
 
-			PIO103: gpio@fd330000 {
+			pio103: gpio@fd330000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -525,7 +525,7 @@
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO103";
 			};
-			PIO104: gpio@fd331000 {
+			pio104: gpio@fd331000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -533,7 +533,7 @@
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO104";
 			};
-			PIO105: gpio@fd332000 {
+			pio105: gpio@fd332000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -541,7 +541,7 @@
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO105";
 			};
-			PIO106: gpio@fd333000 {
+			pio106: gpio@fd333000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
@@ -550,7 +550,7 @@
 				st,bank-name	= "PIO106";
 			};
 
-			PIO107: gpio@fd334000 {
+			pio107: gpio@fd334000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
 				interrupt-controller;
diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
index b3dd6ca..5f91f45 100644
--- a/arch/arm/boot/dts/stih41x-b2000.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -35,7 +35,7 @@
 			fp_led {
 				#gpio-cells = <1>;
 				label	= "Front Panel LED";
-				gpios	= <&PIO105 7>;
+				gpios	= <&pio105 7>;
 				linux,default-trigger	= "heartbeat";
 			};
 		};
@@ -55,7 +55,7 @@
 			phy-mode		= "mii";
 			pinctrl-0		= <&pinctrl_mii0>;
 
-			snps,reset-gpio 	= <&PIO106 2>;
+			snps,reset-gpio 	= <&pio106 2>;
 			snps,reset-active-low;
 			snps,reset-delays-us 	= <0 10000 10000>;
 		};
@@ -65,7 +65,7 @@
 			phy-mode		= "mii";
 			st,tx-retime-src	= "txclk";
 
-			snps,reset-gpio 	= <&PIO4 7>;
+			snps,reset-gpio 	= <&pio4 7>;
 			snps,reset-active-low;
 			snps,reset-delays-us 	= <0 10000 10000>;
 		};
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index d8a8429..c0f50e9 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -32,11 +32,11 @@
 			red {
 				#gpio-cells = <1>;
 				label	= "Front Panel LED";
-				gpios	= <&PIO4 1>;
+				gpios	= <&pio4 1>;
 				linux,default-trigger	= "heartbeat";
 			};
 			green {
-				gpios	= <&PIO4 7>;
+				gpios	= <&pio4 7>;
 				default-state = "off";
 			};
 		};
@@ -68,7 +68,7 @@
 			phy-mode		= "rgmii-id";
 			max-speed		= <1000>;
 			st,tx-retime-src	= "clk_125";
-			snps,reset-gpio 	= <&PIO3 0>;
+			snps,reset-gpio 	= <&pio3 0>;
 			snps,reset-active-low;
 			snps,reset-delays-us 	= <0 10000 10000>;
 
-- 
1.8.3.2

