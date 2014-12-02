Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaLBIxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:53:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLBIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:09 -0500
X-AuditID: cbfee68d-f79296d000004278-0d-547d7d376041
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/19] arm64: dts: exynos: Add SPI/PDMA dt node for Exynos5433
Date: Tue, 02 Dec 2014 17:49:53 +0900
Message-id: <1417510196-6714-17-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkSNeitjbEYMFLRovHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGWsmDaf
	uWCFasWGyZ/YGxifynQxcnJICJhIzG77zQhhi0lcuLeerYuRi0NIYCmjRP+JtewwRadnfWAC
	sYUEpjNKvJvOAlHUxCTx4MYGsG42AS2J/S9usIHYIgLOEg1TG5lAipgF3jBL7Lm/G6iDg0NY
	wE9iwwtNkBoWAVWJ6587WUFsXgFXidvb7zBDLFOQWLZ8JlicEyjedaaPHWKxi8Sv1o/sIDMl
	BKZySOzY2MwOMUhA4tvkQ2DzJQRkJTYdgJojKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn
	5haX5qXrJefnbmIERuPpf896dzDePmB9iFGAg1GJh/fk+ZoQIdbEsuLK3EOMpkAbJjJLiSbn
	A2M+ryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxm3O
	6b5v52Xu/n8j4pn0q/+KCtOyJn0z7Z2V6XxH+5aPyoncX6nHHU7/YZt2Sfdlj6G6xtHctf6N
	jxg3uW20PyxV/+KIy6rT+fO7tlzZulkv7ItStbBz/F/2RzpM/PXHLdgLHoqdDBOrrV4TWqDT
	Vhycx6v/9PDdLYznjmhXvor8J2M4Nas8XImlOCPRUIu5qDgRAIoSma3BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg4XTTCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY8W0+cwFK1QrNkz+xN7A+FSmi5GTQ0LAROL0rA9MELaYxIV7
	69lAbCGB6YwS76azdDFyAdlNTBIPbmxgBEmwCWhJ7H9xA6xIRMBZomFqIxNIEbPAG2aJPfd3
	A3VwcAgL+ElseKEJUsMioCpx/XMnK4jNK+AqcXv7HWaIZQoSy5bPBItzAsW7zvSxQyx2kfjV
	+pF9AiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBsf5MagfjygaLQ4wCHIxKPLwn
	zteECLEmlhVX5h5ilOBgVhLh/WVcGyLEm5JYWZValB9fVJqTWnyI0RToqonMUqLJ+cA0lFcS
	b2hsYmZkaWRuaGFkbK4kznvjZm6IkEB6YklqdmpqQWoRTB8TB6dUA+OGHafNMjkPum+V+pHu
	1BUZxuW7/NLGK0cFVwl0LrX/6HZmp93mRRH/Pjfsn7PPbsGE7/NPzc3nvVSxa74Uy3QmyYj3
	RqHhxxsOOc+f+/CG/r9jPY/2u61UZk9c8DJ4PUO7/trt3ikZqSIHPmxWKTo4v8FxS6bekitn
	9323X7lC9f6/E2f4+j6aKbEUZyQaajEXFScCAGgBeNQLAwAA
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 118 +++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index fef9bbc..22f2df8 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -55,6 +55,11 @@
 		mshc0 = &mshc_0;
 		mshc1 = &mshc_1;
 		mshc2 = &mshc_2;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
+		spi2 = &spi_2;
+		spi3 = &spi_3;
+		spi4 = &spi_4;
 	};
 
 	cpus {
@@ -249,6 +254,34 @@
 			interrupts = <1 9 0xf04>;
 		};
 
+		amba {
+			compatible = "arm,amba-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
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
 		serial_0: serial@14c10000 {
 			compatible = "samsung,exynos5433-uart";
 			reg = <0x14c10000 0x100>;
@@ -349,6 +382,91 @@
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

