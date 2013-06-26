Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3FZPDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:03:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:15242 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3FZPDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:03:08 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] ARC: [TB10x] Updates for irqchip driver
Date: Wed, 26 Jun 2013 16:01:28 +0200
Message-Id: <1372255288-19901-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <51CA6B6D.3080706@synopsys.com>
References: <51CA6B6D.3080706@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree and Kconfig updates for irqchip driver.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/arc/boot/dts/abilis_tb100.dtsi |   32 ++++++++++++++------------------
 arch/arc/boot/dts/abilis_tb101.dtsi |   32 ++++++++++++++------------------
 arch/arc/boot/dts/abilis_tb10x.dtsi |   32 ++++++++++++++------------------
 arch/arc/plat-tb10x/Kconfig         |    1 +
 4 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/arch/arc/boot/dts/abilis_tb100.dtsi b/arch/arc/boot/dts/abilis_tb100.dtsi
index 941ad11..d9f8249 100644
--- a/arch/arc/boot/dts/abilis_tb100.dtsi
+++ b/arch/arc/boot/dts/abilis_tb100.dtsi
@@ -21,10 +21,6 @@
 
 /include/ "abilis_tb10x.dtsi"
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	clock-frequency		= <500000000>;	/* 500 MHZ */
@@ -173,7 +169,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -185,7 +181,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -197,7 +193,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -209,7 +205,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -221,7 +217,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -233,7 +229,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -245,7 +241,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -257,7 +253,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -269,7 +265,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -281,7 +277,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -293,7 +289,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -305,7 +301,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -317,7 +313,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -329,7 +325,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
diff --git a/arch/arc/boot/dts/abilis_tb101.dtsi b/arch/arc/boot/dts/abilis_tb101.dtsi
index fd25c21..da8ca79 100644
--- a/arch/arc/boot/dts/abilis_tb101.dtsi
+++ b/arch/arc/boot/dts/abilis_tb101.dtsi
@@ -21,10 +21,6 @@
 
 /include/ "abilis_tb10x.dtsi"
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	clock-frequency		= <500000000>;	/* 500 MHZ */
@@ -182,7 +178,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -194,7 +190,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -206,7 +202,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -218,7 +214,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -230,7 +226,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -242,7 +238,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -254,7 +250,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -266,7 +262,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -278,7 +274,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -290,7 +286,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -302,7 +298,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -314,7 +310,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -326,7 +322,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -338,7 +334,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
diff --git a/arch/arc/boot/dts/abilis_tb10x.dtsi b/arch/arc/boot/dts/abilis_tb10x.dtsi
index b97e305..edf56f4 100644
--- a/arch/arc/boot/dts/abilis_tb10x.dtsi
+++ b/arch/arc/boot/dts/abilis_tb10x.dtsi
@@ -19,10 +19,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	compatible		= "abilis,arc-tb10x";
@@ -78,7 +74,7 @@
 			#interrupt-cells = <1>;
 		};
 		tb10x_ictl: pic@fe002000 {
-			compatible = "abilis,tb10x_ictl";
+			compatible = "abilis,tb10x-ictl";
 			reg = <0xFE002000 0x20>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
@@ -91,7 +87,7 @@
 			compatible = "snps,dw-apb-uart";
 			reg = <0xFF100000 0x100>;
 			clock-frequency = <166666666>;
-			interrupts = <25 1>;
+			interrupts = <25 8>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			interrupt-parent = <&tb10x_ictl>;
@@ -100,7 +96,7 @@
 			compatible = "snps,dwmac-3.70a","snps,dwmac";
 			reg = <0xFE100000 0x1058>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <6 1>;
+			interrupts = <6 8>;
 			interrupt-names = "macirq";
 			clocks = <&ahb_clk>;
 			clock-names = "stmmaceth";
@@ -109,7 +105,7 @@
 			compatible = "snps,dma-spear1340";
 			reg = <0xFE000000 0x400>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <14 1>;
+			interrupts = <14 8>;
 			dma-channels = <6>;
 			dma-requests = <0>;
 			dma-masters = <1>;
@@ -128,7 +124,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF120000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c1: i2c@FF121000 {
@@ -137,7 +133,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF121000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c2: i2c@FF122000 {
@@ -146,7 +142,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF122000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c3: i2c@FF123000 {
@@ -155,7 +151,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF123000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c4: i2c@FF124000 {
@@ -164,7 +160,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF124000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 
@@ -176,7 +172,7 @@
 			num-cs = <1>;
 			reg = <0xFE010000 0x20>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <26 1>;
+			interrupts = <26 8>;
 			clocks = <&ahb_clk>;
 		};
 		spi1: spi@0xFE011000 {
@@ -187,7 +183,7 @@
 			num-cs = <2>;
 			reg = <0xFE011000 0x20>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <10 1>;
+			interrupts = <10 8>;
 			clocks = <&ahb_clk>;
 		};
 
@@ -195,7 +191,7 @@
 			compatible = "abilis,tb100-tsm";
 			reg = <0xff316000 0x400>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <17 1>;
+			interrupts = <17 8>;
 			output-clkdiv = <4>;
 			global-packet-delay = <0x21>;
 			port-packet-delay = <0>;
@@ -213,7 +209,7 @@
 					"cpuctrl",
 					"a6it_int_force";
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <20 1>, <19 1>;
+			interrupts = <20 2>, <19 2>;
 			interrupt-names = "cmd_irq", "event_irq";
 		};
 		tb10x_mdsc0: tb10x-mdscr@FF300000 {
@@ -239,7 +235,7 @@
 			compatible = "abilis,tb100-wfb";
 			reg = <0xff319000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <16 1>;
+			interrupts = <16 8>;
 		};
 	};
 };
diff --git a/arch/arc/plat-tb10x/Kconfig b/arch/arc/plat-tb10x/Kconfig
index 1d34521..1ab386b 100644
--- a/arch/arc/plat-tb10x/Kconfig
+++ b/arch/arc/plat-tb10x/Kconfig
@@ -22,6 +22,7 @@ menuconfig ARC_PLAT_TB10X
 	select PINCTRL
 	select PINMUX
 	select ARCH_REQUIRE_GPIOLIB
+	select TB10X_IRQC
 	help
 	  Support for platforms based on the TB10x home media gateway SOC by
 	  Abilis Systems. TB10x is based on the ARC700 CPU architecture.
-- 
1.7.1

