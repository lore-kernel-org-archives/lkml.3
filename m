Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaJXVmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:42:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50620 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaJXVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:42:33 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>,
        Alexandru M Stan <amstan@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add SPI DMA into rk3288.dtsi
Date: Fri, 24 Oct 2014 14:42:06 -0700
Message-Id: <1414186926-25986-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that SPI DMA has been fixed on rk3288 we can enable it.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Alexandru M Stan <amstan@chromium.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..e0b99f7 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -177,6 +177,8 @@
 		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
 		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
 		clock-names = "spiclk", "apb_pclk";
+		dmas = <&dmac_peri 11>, <&dmac_peri 12>;
+		dma-names = "tx", "rx";
 		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi0_clk &spi0_tx &spi0_rx &spi0_cs0>;
@@ -190,6 +192,8 @@
 		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
 		clocks = <&cru SCLK_SPI1>, <&cru PCLK_SPI1>;
 		clock-names = "spiclk", "apb_pclk";
+		dmas = <&dmac_peri 13>, <&dmac_peri 14>;
+		dma-names = "tx", "rx";
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
@@ -203,6 +207,8 @@
 		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
 		clocks = <&cru SCLK_SPI2>, <&cru PCLK_SPI2>;
 		clock-names = "spiclk", "apb_pclk";
+		dmas = <&dmac_peri 15>, <&dmac_peri 16>;
+		dma-names = "tx", "rx";
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi2_clk &spi2_tx &spi2_rx &spi2_cs0>;
-- 
2.1.0.rc2.206.gedb03e5

