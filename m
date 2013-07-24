Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3GXELP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8540 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3GXEKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Jul 2013 21:10:18 -0700
From: Richard Zhao <rizhao@nvidia.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <broonie@kernel.org>, <gregkh@linuxfoundation.org>,
        <lgirdwood@gmail.com>, <rizhao@nvidia.com>, <linuxzsc@gmail.com>,
        <ldewangan@nvidia.com>, <dev@lynxeye.de>
Subject: [PATCH 8/9] ARM: dts: tegra: remove legacy nvidia,dma-request-selector properties
Date: Wed, 24 Jul 2013 12:10:01 +0800
Message-ID: <1374639002-16753-9-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All tegra dma client drivers have moved to generic dma binding.

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi | 14 --------------
 arch/arm/boot/dts/tegra20.dtsi  | 13 -------------
 arch/arm/boot/dts/tegra30.dtsi  | 12 ------------
 3 files changed, 39 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index b133c62..e696cbce 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -125,7 +125,6 @@
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 8>;
 		dmas = <&apbdma 8>;
 		dma-names = "rx-tx";
 		status = "disabled";
@@ -137,7 +136,6 @@
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 9>;
 		dmas = <&apbdma 9>;
 		dma-names = "rx-tx";
 		status = "disabled";
@@ -149,7 +147,6 @@
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 10>;
 		dmas = <&apbdma 10>;
 		dma-names = "rx-tx";
 		status = "disabled";
@@ -161,7 +158,6 @@
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 19>;
 		dmas = <&apbdma 19>;
 		dma-names = "rx-tx";
 		status = "disabled";
@@ -235,7 +231,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 15>;
 		dmas = <&apbdma 15>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -249,7 +244,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 16>;
 		dmas = <&apbdma 16>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -263,7 +257,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 17>;
 		dmas = <&apbdma 17>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -277,7 +270,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 18>;
 		dmas = <&apbdma 18>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -291,7 +283,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000dc00 0x200>;
 		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 27>;
 		dmas = <&apbdma 27>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -305,7 +296,6 @@
 		compatible = "nvidia,tegra114-spi";
 		reg = <0x7000de00 0x200>;
 		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 28>;
 		dmas = <&apbdma 28>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -354,10 +344,6 @@
 		      <0x70080200 0x100>,
 		      <0x70081000 0x200>;
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 1>, <&apbdma 2>,
-			<&apbdma 3>, <&apbdma 4>, <&apbdma 6>, <&apbdma 7>,
-			<&apbdma 12>, <&apbdma 13>, <&apbdma 14>,
-			<&apbdma 29>;
 		dmas = <&apbdma 1>, <&apbdma 2>, <&apbdma 3>, <&apbdma 4>,
 			<&apbdma 6>, <&apbdma 7>, <&apbdma 12>, <&apbdma 13>,
 			<&apbdma 14>, <&apbdma 29>;
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 0fe7f37..7ca0ccb 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -223,7 +223,6 @@
 		compatible = "nvidia,tegra20-ac97";
 		reg = <0x70002000 0x200>;
 		interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 12>;
 		dmas = <&apbdma 12>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_AC97>;
@@ -234,7 +233,6 @@
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002800 0x200>;
 		interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 2>;
 		dmas = <&apbdma 2>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_I2S1>;
@@ -245,7 +243,6 @@
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002a00 0x200>;
 		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 1>;
 		dmas = <&apbdma 1>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_I2S2>;
@@ -264,7 +261,6 @@
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 8>;
 		dmas = <&apbdma 8>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTA>;
@@ -276,7 +272,6 @@
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 9>;
 		dmas = <&apbdma 9>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTB>;
@@ -288,7 +283,6 @@
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 10>;
 		dmas = <&apbdma 10>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTC>;
@@ -300,7 +294,6 @@
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 19>;
 		dmas = <&apbdma 19>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTD>;
@@ -312,7 +305,6 @@
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 20>;
 		dmas = <&apbdma 20>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA20_CLK_UARTE>;
@@ -350,7 +342,6 @@
 		compatible = "nvidia,tegra20-sflash";
 		reg = <0x7000c380 0x80>;
 		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 11>;
 		dmas = <&apbdma 11>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -399,7 +390,6 @@
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 15>;
 		dmas = <&apbdma 15>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -412,7 +402,6 @@
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 16>;
 		dmas = <&apbdma 16>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -425,7 +414,6 @@
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 17>;
 		dmas = <&apbdma 17>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -438,7 +426,6 @@
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 18>;
 		dmas = <&apbdma 18>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index c266316..729c853 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -245,7 +245,6 @@
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 8>;
 		dmas = <&apbdma 8>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTA>;
@@ -257,7 +256,6 @@
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 9>;
 		dmas = <&apbdma 9>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTB>;
@@ -269,7 +267,6 @@
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 10>;
 		dmas = <&apbdma 10>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTC>;
@@ -281,7 +278,6 @@
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 19>;
 		dmas = <&apbdma 19>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTD>;
@@ -293,7 +289,6 @@
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 20>;
 		dmas = <&apbdma 20>;
 		dma-names = "rx-tx";
 		clocks = <&tegra_car TEGRA30_CLK_UARTE>;
@@ -379,7 +374,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d400 0x200>;
 		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 15>;
 		dmas = <&apbdma 15>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -392,7 +386,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d600 0x200>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 16>;
 		dmas = <&apbdma 16>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -405,7 +398,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d800 0x200>;
 		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 17>;
 		dmas = <&apbdma 17>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -418,7 +410,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000da00 0x200>;
 		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 18>;
 		dmas = <&apbdma 18>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -431,7 +422,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000dc00 0x200>;
 		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 27>;
 		dmas = <&apbdma 27>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -444,7 +434,6 @@
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000de00 0x200>;
 		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 28>;
 		dmas = <&apbdma 28>;
 		dma-names = "rx-tx";
 		#address-cells = <1>;
@@ -492,7 +481,6 @@
 		reg = <0x70080000 0x200
 		       0x70080200 0x100>;
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
-		nvidia,dma-request-selector = <&apbdma 1>;
 		dmas = <&apbdma 1>, <&apbdma 2>, <&apbdma 3>, <&apbdma 4>;
 		dma-names = "channel0", "channel1", "channel2", "channel3";
 		clocks = <&tegra_car TEGRA30_CLK_D_AUDIO>,
-- 
1.8.1.5

