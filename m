Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907AbaDJKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965761AbaDJKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:55 -0400
X-AuditID: cbfee68f-b7f156d00000276c-98-53466d25738d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 23/27] ARM: dts: exynos3250: Add spi dt node to support spi bus
Date: Thu, 10 Apr 2014 19:06:13 +0900
Message-id: <1397124377-16969-15-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkRFc11y3Y4O4/MYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mp4eOsOe0E/f8XE71dYGhibeboYOTkkBEwkll1t
	ZIOwxSQu3FsPZHNxCAksZZR48u41UxcjB1jR7fm6EPFFjBK7n00BaxASaGKSWHpTBcRmE9CS
	2P/iBlhcRCBA4sfxd2A2s8BNRolj78NA5ggL+Eu8nlwJEmYRUJW4uWEfO4jNK+Am8XDLZXaI
	G+QkPux5BGZzAsVnLjoJtcpVoufRRWaImlXsEge3akDMEZD4NvkQC8SZshKbDkCVSEocXHGD
	ZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgSF/+t+z/h2Mdw9YH2JMBho3kVlK
	NDkfGDN5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoFxH/cKCX39fxK87zZ+zjsd4izZatOo0qffJWmQecrcYOrlRysFn7vf2f7gxVzDqvrk7W+Y
	L3CKL7nUzLJf4tUu12dv5nX47fG9wORSV2Hcfd7seJKY8slznWJJOfYxNvkLpkdWdEn2l01f
	8C5j7g1hrQOnHCNrJ2hUf1ZY8E/VY//fFdOFg7OUWIozEg21mIuKEwF7SH24jwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV3VXLdggw2H+Syuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsNbd9gL
	+vkrJn6/wtLA2MzTxcjBISFgInF7vm4XIyeQKSZx4d56ti5GLg4hgUWMErufTWEDSQgJNDFJ
	LL2pAmKzCWhJ7H9xAywuIhAg8eP4OzCbWeAmo8Sx92EgM4UF/CVeT64ECbMIqErc3LCPHcTm
	FXCTeLjlMjvELjmJD3segdmcQPGZi05CrXKV6Hl0kXkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMEx9Ux6B+OqBotDjAIcjEo8vAeWuQYLsSaWFVfmHmKU4GBWEuHdnekWLMSb
	klhZlVqUH19UmpNafIgxGeiqicxSosn5wHjPK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBA
	emJJanZqakFqEcwWJg5OqQbGVT1fSx50vLpyYc2u425BOctcDAQfrs2tF5hnKcPhyp/nv/no
	Kxee39fSKn02fhNeV9rdsYGv5hLbF/t1wvLbX3Ok//qUk1XprPKeIz5q9+FC372r3r95seTe
	FzG3GRUdl7cwbfjh/Jl7qrW7TnXL7PV3Nvef5XgyZdHsz2d9uA4v9rkRF19xUYmlOCPRUIu5
	qDgRAOjqJu/tAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add spi dt node to support SPI (Serial Peripheral Interface) bus.
SPI in Exynos3250 transfers serial data by using various peripherals. Exynos3250
has two independent interface (spi0/1).

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index b8e5ae13..03e7931 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -30,6 +30,8 @@
 		pinctrl1 = &pinctrl_1;
 		mshc0 = &mshc_0;
 		mshc1 = &mshc_1;
+		spi0 = &spi_0;
+		spi1 = &spi_1;
 		i2c0 = &i2c_0;
 		i2c1 = &i2c_1;
 		i2c2 = &i2c_2;
@@ -311,6 +313,38 @@
 		status = "disabled";
 	};
 
+	spi_0: spi@13920000 {
+		compatible = "samsung,exynos4210-spi";
+		reg = <0x13920000 0x100>;
+		interrupts = <0 121 0>;
+		dmas = <&pdma0 7>, <&pdma0 6>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu CLK_SPI0>, <&cmu CLK_SCLK_SPI0>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
+		status = "disabled";
+	};
+
+	spi_1: spi@13930000 {
+		compatible = "samsung,exynos4210-spi";
+		reg = <0x13930000 0x100>;
+		interrupts = <0 122 0>;
+		dmas = <&pdma1 7>, <&pdma1 6>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu CLK_SPI1>, <&cmu CLK_SCLK_SPI1>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi1_bus>;
+		status = "disabled";
+	};
+
 	pmu {
 		compatible = "arm,cortex-a7-pmu";
 		interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
-- 
1.8.0

