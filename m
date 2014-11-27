Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaK0HiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:38:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaK0Hf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:29 -0500
X-AuditID: cbfee68d-f79296d000004278-d9-5476d438b2b3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/19] arm64: dts: exynos: Add SPI/PDMA dt node for Exynos5433
Date: Thu, 27 Nov 2014 16:35:15 +0900
Message-id: <1417073716-22997-19-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkRNfiSlmIQfsPY4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtM+bOcyWLT
	42usFpd3zWGzmHF+H5PF0usXmSxOXf/MZnH4TTurxYzJL9ksjs1YwmixatcfRouXH0+wOIh5
	rJm3htHj969JjB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABHFJdNSmpOZllqkb5d
	AlfGswkpBdNVKxaebWNuYLwi08XIySEhYCIx5+cqNghbTOLCvfVANheHkMBSRolv98+wwxSt
	m7SGCSIxnVFi4aUdrBBOE5PElytbmECq2AS0JPa/uAE2SkTAWaJhaiNYB7PAR2aJhmkXWUES
	wgJ+Eo+bTwON5eBgEVCVmHJcHiTMK+Am0X97OyPENgWJZctngpVzAsX3fz0IZgsJuEos+nYF
	bKaEwFwOifXzLoAtYxEQkPg2+RALyEwJAVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ
	6UWGesWJucWleel6yfm5mxiBcXn637PeHYy3D1gfYhTgYFTi4bU4UBYixJpYVlyZe4jRFGjD
	RGYp0eR8YPTnlcQbGpsZWZiamBobmVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXA6Pl49Zq/J95mCK891JSqVh+odMl0S19sK7tqqPVx67xNh7ZectZdsWvJ4TiD5OZVeTpv
	YzfdCIlvPH3Y9tPZuUa6ViYFLQ//VuzJ31HHYNRfam7Ntft14hxeGz7JPsmWyds3ulyeeHr6
	U+PInY9eJdyx3njxOKuOQeu+N2zOb/hSatYuE+hxUWIpzkg01GIuKk4EAAiMTgPGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBv96tSwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w24x5c9yJotN
	j6+xWlzeNYfNYsb5fUwWS69fZLI4df0zm8XhN+2sFjMmv2SzODZjCaPFql1/GC1efjzB4iDm
	sWbeGkaP378mMXrsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgEcUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA/ykplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM55NSCmYrlqx8GwbcwPjFZkuRk4OCQETiXWT1jBB
	2GISF+6tZ+ti5OIQEpjOKLHw0g5WCKeJSeLLlS1gVWwCWhL7X9xgA7FFBJwlGqY2MoEUMQt8
	ZJZomHaRFSQhLOAn8bj5NHsXIwcHi4CqxJTj8iBhXgE3if7b2xkhtilILFs+E6ycEyi+/+tB
	MFtIwFVi0bcrTBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI76Z9I7GFc1WBxi
	FOBgVOLhtThQFiLEmlhWXJl7iFGCg1lJhFdqEVCINyWxsiq1KD++qDQntfgQoynQUROZpUST
	84EJKa8k3tDYxMzI0sjc0MLI2FxJnPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBkb23lKjvbpZ
	6jde/vIP5d1xVUdKRcHncpfe6xiPjU2PHk7ZfW7VHTHtbzv/7rg4UVlvp0bM1YZI13X/Nlt2
	7AxlYTpsffqG4UcjDZ/fH+cb6s9vOyn5PPzK+YglPsEnT4lftKnV+iqT8X2VoROb7x7bE8u1
	n6vK2115KhB/3W3l0kkr+ITPWlQpsRRnJBpqMRcVJwIAF8c9sBADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SPI (Serial Peripheral Interface) dt node for Exynos5433 SoC.
SPI transfers serial data by using various peripherals. SPI includes
8-bit/16-bit/32-bit shift registers to transmit and receive data. PDMA is used
for SPI communication.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 119 +++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index cfe3de8..a3093d4 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -56,6 +56,11 @@
 		mshc0 = &mshc_0;
 		mshc1 = &mshc_1;
 		mshc2 = &mshc_2;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
+		spi2 = &spi_2;
+		spi3 = &spi_3;
+		spi4 = &spi_4;
 	};
 
 	chipid@10000000 {
@@ -254,6 +259,35 @@
 			interrupts = <1 9 0xf04>;
 		};
 
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			pdma0: pdma@15610000 {
+				compatible = "arm,pl330", "arm,primecell";
+				reg = <0x15610000 0x1000>;
+				interrupts = <0 228 0>;
+				clocks = <&cmu_fsys CLK_PDMA0>;
+				clock-names = "apb_pclk";
+				#dma-cells = <1>;
+				#dma-channels = <8>;
+				#dma-requests = <32>;
+			};
+
+			pdma1: pdma@15600000 {
+				compatible = "arm,pl330", "arm,primecell";
+				reg = <0x15600000 0x1000>;
+				interrupts = <0 246 0>;
+				clocks = <&cmu_fsys CLK_PDMA1>;
+				clock-names = "apb_pclk";
+				#dma-cells = <1>;
+				#dma-channels = <8>;
+				#dma-requests = <32>;
+			};
+		};
+
 		serial_0: serial@14C10000 {
 			compatible = "samsung,exynos5433-uart";
 			reg = <0x14C10000 0x100>;
@@ -354,6 +388,91 @@
 			interrupts = <0 442 0>;
 		};
 
+		spi_0: spi@14d20000 {
+			compatible = "samsung,exynos7-spi";
+			reg = <0x14d20000 0x100>;
+			interrupts = <0 432 0>;
+			dmas = <&pdma0 9>, <&pdma0 8>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu_peric CLK_PCLK_SPI0>,
+				 <&cmu_top CLK_SCLK_SPI0_PERIC>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi0_bus>;
+			status = "disabled";
+		};
+
+		spi_1: spi@14d30000 {
+			compatible = "samsung,exynos7-spi";
+			reg = <0x14d30000 0x100>;
+			interrupts = <0 433 0>;
+			dmas = <&pdma0 11>, <&pdma0 10>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu_peric CLK_PCLK_SPI1>,
+				 <&cmu_top CLK_SCLK_SPI1_PERIC>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi1_bus>;
+			status = "disabled";
+		};
+
+		spi_2: spi@14d40000 {
+			compatible = "samsung,exynos7-spi";
+			reg = <0x14d40000 0x100>;
+			interrupts = <0 434 0>;
+			dmas = <&pdma0 13>, <&pdma0 12>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu_peric CLK_PCLK_SPI2>,
+				 <&cmu_top CLK_SCLK_SPI2_PERIC>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi2_bus>;
+			status = "disabled";
+		};
+
+		spi_3: spi@14d50000 {
+			compatible = "samsung,exynos7-spi";
+			reg = <0x14d50000 0x100>;
+			interrupts = <0 447 0>;
+			dmas = <&pdma0 23>, <&pdma0 22>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu_peric CLK_PCLK_SPI3>,
+				 <&cmu_top CLK_SCLK_SPI3_PERIC>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi3_bus>;
+			status = "disabled";
+		};
+
+		spi_4: spi@14d00000 {
+			compatible = "samsung,exynos7-spi";
+			reg = <0x14d00000 0x100>;
+			interrupts = <0 412 0>;
+			dmas = <&pdma0 25>, <&pdma0 24>;
+			dma-names = "tx", "rx";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&cmu_peric CLK_PCLK_SPI4>,
+				 <&cmu_top CLK_SCLK_SPI4_PERIC>;
+			clock-names = "spi", "spi_busclk0";
+			samsung,spi-src-clk = <0>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi4_bus>;
+			status = "disabled";
+		};
+
 		hsi2c_0: hsi2c@14e40000 {
 			compatible = "samsung,exynos7-hsi2c";
 			reg = <0x14e40000 0x1000>;
-- 
1.8.5.5

