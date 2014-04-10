Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbaDJKH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbaDJKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:55 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-61-53466d219b0f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 19/27] ARM: dts: exynos3250: Add Mobile Storage Host Card
Date: Thu, 10 Apr 2014 19:06:09 +0900
Message-id: <1397124377-16969-11-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSoKuY6xZscHSDosX1L89ZLT5/aGG3
	mHR/AovFjV9trBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLG5JdsFutnvGax2LtzMqMD
	j8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfF27162gvO8FRd+bmZrYPzC1cXIySEh
	YCIxcdEmFghbTOLCvfVsXYxcHEICSxklfh7+xA5T1LD2DTtEYhGjxLTX95hAEkICTUwSG2bH
	gNhsAloS+1/cYAOxRQQCJH4cfwc2iVmgmUli78otrCAJYQFPiSNrX4I1swioSixqWAc0lYOD
	V8BNYsNrR4hlchIf9jwCW8wJFJ656CQbxC5XiZ5HF5lBZkoIbGKXePnuH9QcAYlvkw+xgMyR
	EJCV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGAOn/z2b
	uIPx/gHrQ4zJQOMmMkuJJucDYyivJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhg12Y7telppdeYvZ57B913P72i/2vZ4kbHU3/f5LppnAh4n97oV
	c7NNK2ledyHA3vyd17MmDrbunefN120zE9jLbaeT+zdc+3H1m0MNzzj3WRzPnlg7e3/GnCW7
	LWxs1izhiZqxWMW0fMF6yR21HWe5d0fpeZtZbpRcqHd+653VGV2ZEy75rxRRYinOSDTUYi4q
	TgQA8FXuj5cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAV3FXLdgg39fJCyuf3nOavH5Qwu7
	xaT7E1gsbvxqY7XoXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBYzJr9ks1g/4zWLxd6dkxkd
	eDw2L6n36NuyitHj8ya5AOaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	b/fuZSs4z1tx4edmtgbGL1xdjJwcEgImEg1r37BD2GISF+6tZ+ti5OIQEljEKDHt9T0mkISQ
	QBOTxIbZMSA2m4CWxP4XN9hAbBGBAIkfx9+BNTALNDNJ7F25hRUkISzgKXFk7UuwZhYBVYlF
	DeuANnBw8Aq4SWx47QixTE7iw55HYIs5gcIzF51kg9jlKtHz6CLzBEbeBYwMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCI+yZ9A7GVQ0WhxgFOBiVeHgPLHMNFmJNLCuuzD3EKMHBrCTC
	uzvTLViINyWxsiq1KD++qDQntfgQYzLQUROZpUST84HRn1cSb2hsYmZkaWRuaGFkbE6asJI4
	78FW60AhgfTEktTs1NSC1CKYLUwcnFINjEK1Vu3RgV5Jc33S8+741hw+o5RyRy7uZvQ8xVP7
	rLdxFD2/I802tYN1ekfor3PPVyWtvSp7Y89Fk/jq2crfBPdJc0172jA7dkZ+w6RDXbZsOo/k
	gjanhjp2VCxa320qva9g35X1fXF2dfkXtz8sYjNlnH81cdWFe3/sa40Y7Gqj1jqt2/vwsxJL
	cUaioRZzUXEiAAMkbfz0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

This patch add MSHC (Mobile Storage Host Controller) dt node which is an
interface between the system and SD/MMC card. mshc dt node is used for dw_mmc
device driver to operate SD/MMC card.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[Modify the sdr/ddr timing for eMMC by Jaehoon Chung]
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index a16c3ea..587a124 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -28,6 +28,8 @@
 	aliases {
 		pinctrl0 = &pinctrl_0;
 		pinctrl1 = &pinctrl_1;
+		mshc0 = &mshc_0;
+		mshc1 = &mshc_1;
 		i2c0 = &i2c_0;
 		i2c1 = &i2c_1;
 		i2c2 = &i2c_2;
@@ -92,6 +94,30 @@
 		interrupts = <0 240 0>;
 	};
 
+	mshc_0: mshc@12510000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12510000 0x1000>;
+		interrupts = <0 142 0>;
+		clocks = <&cmu CLK_SDMMC0>, <&cmu CLK_SCLK_MMC0>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	mshc_1: mshc@12520000 {
+		compatible = "samsung,exynos5250-dw-mshc";
+		reg = <0x12520000 0x1000>;
+		interrupts = <0 143 0>;
+		clocks = <&cmu CLK_SDMMC1>, <&cmu CLK_SCLK_MMC1>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x80>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
 	adc: adc@126C0000 {
 		compatible = "samsung,exynos-adc-v2";
 		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
-- 
1.8.0

