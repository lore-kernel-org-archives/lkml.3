Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaIYQbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:31:21 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:38536 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaIYQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:54 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 13/13] ARM: shmobile: r8a7740 dtsi: Add preliminary PM QoS device latencies
Date: Thu, 25 Sep 2014 18:28:40 +0200
Message-Id: <1411662520-22795-14-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now use 250 µs, just like the legacy platform code does.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - No changes
v2:
  - New

 arch/arm/boot/dts/r8a7740.dtsi | 136 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index ed0adeb61a1ad8ec..713170442b7bd4b2 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -26,6 +26,10 @@
 			reg = <0x0>;
 			clock-frequency = <800000000>;
 			power-domains = <&pd_a3sm>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 		};
 	};
 
@@ -49,6 +53,10 @@
 		clocks = <&mstp3_clks R8A7740_CLK_CMT1>;
 		clock-names = "fck";
 		power-domains = <&pd_c5>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 
 		renesas,channels-mask = <0x3f>;
 
@@ -75,6 +83,10 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 		power-domains = <&pd_a4s>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 	};
 
 	/* irqpin1: IRQ8 - IRQ15 */
@@ -97,6 +109,10 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 		power-domains = <&pd_a4s>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 	};
 
 	/* irqpin2: IRQ16 - IRQ23 */
@@ -119,6 +135,10 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 		power-domains = <&pd_a4s>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 	};
 
 	/* irqpin3: IRQ24 - IRQ31 */
@@ -141,6 +161,10 @@
 			      0 149 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks R8A7740_CLK_INTCA>;
 		power-domains = <&pd_a4s>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 	};
 
 	ether: ethernet@e9a00000 {
@@ -150,6 +174,10 @@
 		interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_GETHER>;
 		power-domains = <&pd_a4s>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		phy-mode = "mii";
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -167,6 +195,10 @@
 			      0 204 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7740_CLK_IIC0>;
 		power-domains = <&pd_a4r>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -181,6 +213,10 @@
 			      0 73 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_IIC1>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -191,6 +227,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA0>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -201,6 +241,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA1>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -211,6 +255,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA0>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -221,6 +269,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA3>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -231,6 +283,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA4>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -241,6 +297,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA5>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -251,6 +311,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA6>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -261,6 +325,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFA7>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -271,6 +339,10 @@
 		clocks = <&mstp2_clks R8A7740_CLK_SCIFB>;
 		clock-names = "sci_ick";
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -290,6 +362,10 @@
 			<&irqpin3 0 0>, <&irqpin3 1 0>, <&irqpin3 2 0>, <&irqpin3 3 0>,
 			<&irqpin3 4 0>, <&irqpin3 5 0>, <&irqpin3 6 0>, <&irqpin3 7 0>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 	};
 
 	tpu: pwm@e6600000 {
@@ -297,6 +373,10 @@
 		reg = <0xe6600000 0x100>;
 		clocks = <&mstp3_clks R8A7740_CLK_TPU0>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 		#pwm-cells = <3>;
 	};
@@ -308,6 +388,10 @@
 			      0 57 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_MMC>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -319,6 +403,10 @@
 			      0 119 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_SDHI0>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -332,6 +420,10 @@
 			      0 123 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A7740_CLK_SDHI1>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -345,6 +437,10 @@
 			      0 127 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp4_clks R8A7740_CLK_SDHI2>;
 		power-domains = <&pd_a3sp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		cap-sd-highspeed;
 		cap-sdio-irq;
 		status = "disabled";
@@ -357,6 +453,10 @@
 		interrupts = <0 9 0x4>;
 		clocks = <&mstp3_clks R8A7740_CLK_FSI>;
 		power-domains = <&pd_a4mp>;
+		stop-latency = <250000>;
+		start-latency = <250000>;
+		save-state-latency = <250000>;
+		restore-state-latency = <250000>;
 		status = "disabled";
 	};
 
@@ -409,6 +509,10 @@
 			reg = <0xe6150000 0x10000>;
 			clocks = <&extal1_clk>, <&extalr_clk>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			clock-output-names = "system", "pllc0", "pllc1",
 					     "pllc2", "r",
@@ -424,6 +528,10 @@
 			reg = <0xe6150080 4>;
 			clocks = <&pllc1_div2_clk>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <0>;
 			clock-output-names = "sub";
 		};
@@ -433,6 +541,10 @@
 			compatible = "fixed-factor-clock";
 			clocks = <&cpg_clocks R8A7740_CLK_PLLC1>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <0>;
 			clock-div = <2>;
 			clock-mult = <1>;
@@ -442,6 +554,10 @@
 			compatible = "fixed-factor-clock";
 			clocks = <&extal1_clk>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <0>;
 			clock-div = <2>;
 			clock-mult = <1>;
@@ -454,6 +570,10 @@
 			reg = <0xe6150080 4>;
 			clocks = <&sub_clk>, <&sub_clk>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_SUBCK R8A7740_CLK_SUBCK2
@@ -470,6 +590,10 @@
 				 <&sub_clk>, <&sub_clk>,
 				 <&cpg_clocks R8A7740_CLK_B>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_CEU21 R8A7740_CLK_CEU20 R8A7740_CLK_TMU0
@@ -492,6 +616,10 @@
 				 <&sub_clk>, <&sub_clk>, <&sub_clk>,
 				 <&sub_clk>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_SCIFA6 R8A7740_CLK_INTCA
@@ -522,6 +650,10 @@
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_CMT1 R8A7740_CLK_FSI R8A7740_CLK_IIC1
@@ -540,6 +672,10 @@
 				 <&cpg_clocks R8A7740_CLK_HP>,
 				 <&cpg_clocks R8A7740_CLK_HP>;
 			power-domains = <&pd_c5>;
+			stop-latency = <250000>;
+			start-latency = <250000>;
+			save-state-latency = <250000>;
+			restore-state-latency = <250000>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
 				R8A7740_CLK_USBH R8A7740_CLK_SDHI2
-- 
1.9.1

