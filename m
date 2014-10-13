Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaJMOKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:10:15 -0400
Received: from 19.mo6.mail-out.ovh.net ([188.165.56.177]:41666 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779AbaJMOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:10:13 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 10:10:13 EDT
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] ARM: dts: rockchip: add I2S controllers for rk3066 and rk3188
Date: Mon, 13 Oct 2014 15:51:04 +0200
Message-Id: <1413208265-20372-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 1.9.1
X-Ovh-Tracer-Id: 15631712833288274145
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the I2S/PCM controller nodes and pin controls for rk3066 and rk3188.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3066a.dtsi | 51 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/rk3188.dtsi  | 16 +++++++++++++
 arch/arm/boot/dts/rk3xxx.dtsi  | 39 ++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index ad9c2db..7c4cd86 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -405,6 +405,42 @@
 						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_default>;
 			};
 		};
+
+		i2s0 {
+			i2s0_bus: i2s0-bus {
+				rockchip,pins = <RK_GPIO0 7 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 8 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 9 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 10 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 11 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 12 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 13 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 14 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 15 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
+
+		i2s1 {
+			i2s1_bus: i2s1-bus {
+				rockchip,pins = <RK_GPIO0 16 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 17 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 18 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 19 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 20 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 21 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
+
+		i2s2 {
+			i2s2_bus: i2s2-bus {
+				rockchip,pins = <RK_GPIO0 24 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 25 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 26 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 27 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 28 RK_FUNC_1 &pcfg_pull_default>,
+						<RK_GPIO0 29 RK_FUNC_1 &pcfg_pull_default>;
+			};
+		};
 	};
 };
 
@@ -473,6 +509,21 @@
 	pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
 };
 
+&i2s0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s0_bus>;
+};
+
+&i2s1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s1_bus>;
+};
+
+&i2s2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s2_bus>;
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_xfer>;
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index ddaada7..04ef487 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -395,6 +395,17 @@
 						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_none>;
 			};
 		};
+
+		i2s1 {
+			i2s1_bus: i2s1-bus {
+				rockchip,pins = <RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>,
+						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
 	};
 };
 
@@ -472,6 +483,11 @@
 	pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
 };
 
+&i2s1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s1_bus>;
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_xfer>;
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 499468d..75b7982 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -112,6 +112,45 @@
 		      <0x1013c100 0x0100>;
 	};
 
+	i2s0: i2s@10118000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x10118000 0x2000>;
+		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		dmas = <&dmac1_s 4>, <&dmac1_s 5>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+		status = "disabled";
+	};
+
+	i2s1: i2s@1011a000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x1011a000 0x2000>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S1>, <&cru SCLK_I2S1>;
+		status = "disabled";
+	};
+
+	i2s2: i2s@1011c000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x1011c000 0x2000>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		dmas = <&dmac1_s 9>, <&dmac1_s 10>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S2>, <&cru SCLK_I2S2>;
+		status = "disabled";
+	};
+
 	uart0: serial@10124000 {
 		compatible = "snps,dw-apb-uart";
 		reg = <0x10124000 0x400>;
-- 
1.9.1

