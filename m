Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaGKJLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:11:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27452 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaGKJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:47 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-e6-53bfaa10e541
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: [PATCH 2/4] Documentation: dt-bindings: move exynos-adc.txt to more
 iio/adc/
Date: Fri, 11 Jul 2014 14:36:27 +0530
Message-id: <1405069589-10388-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSpSu4an+wwa6NjBYvD2laXP/ynNVi
	/pFzrBbNi9ezWbw68oPJYsnk+awW8468Y7G4vGsOm8WM8/uYLBZt+8/swOUxu+Eii8fOWXfZ
	PfbPXcPuseTNIVaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyrjZfYel4L5RxYF/F1gaGGdr
	djFyckgImEi0znnFDmGLSVy4t56ti5GLQ0hgKaPEl8mPGWGKOntWs0IkpjNKdPydzgjh9DNJ
	bD4+mQmkik3ATOLgotVgo0QE4iQ+XO5nByliFljLKNG27SpYQlggXGLZlufMIDaLgKrEyucd
	YCt4BVwl+tfsB4pzAK1TkJgzyQYkzCngJvHtXyNYuRBQyZZb3SwgMyUEdrFL/Lo8mx1ijoDE
	t8mHWCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiM
	h9P/nk3cwXj/gPUhxmSgcROZpUST84HxlFcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjDJzEixlbvu0zfLh+C0/dYqgrnKHZeNal4DdKx3Z9i3d
	8K/xdrOrx7HDFS9LeP7Nmmcg8Oz1+bPb9+Y71tmvP1HyoI9ZxXPChcX8TheN62Obokvup4sf
	XbpKc/3XwM3/Ag5KJL/LY1yWeqTru+pSGSaxN1y8J1U9jE4rrKxSiAjnbpeYIXfCXImlOCPR
	UIu5qDgRAGFfXZudAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd2vK/cHG7Rd5rB4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mBy6P2Q0XWTx2zrrL
	7rF/7hp2jyVvDrF69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtBpSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMm913WAruG1Uc+HeBpYFxtmYXIyeHhICJRGfPalYIW0ziwr31bF2MXBxCAtMZJTr+
	TmeEcPqZJDYfn8wEUsUmYCZxcNFqdhBbRCBO4sPlfnaQImaBtYwSbduugiWEBcIllm15zgxi
	swioSqx83sEIYvMKuEr0r9kPFOcAWqcgMWeSDUiYU8BN4tu/RrByIaCSLbe6WSYw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxtz6R3MK5qsDjEKMDBqMTDe2LNvmAh1sSy4src
	Q4wSHMxKIrxP6vcHC/GmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MBHklcQbGpuYmxqbWppY
	mJhZKonzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgbJlc/3/517Q17tZbhcLvxHjY6pcJHnm0
	9YYwP2/OrP3Z9z5WZKhtX+L9V/BAjFZMxK+K4KVez5+7dG89a9P+fPeCydL7Oo3uJq+02/1j
	74Ggjz46FioTrV33xHMLnM9777DjQ13jnXdNLuv1uZrje4+werz6eP/Yg6Da2u4plkv0XI5v
	KzOXU2Ipzkg01GIuKk4EAGV3MPPMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT bindings in exynos-adc.txt applies to the ADC
driver (exynos-adc.c) developed based on IIO framework.

The bindings are more appropriate to be under
Documentation/devicetree/bindings/iio/adc/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: devicetree@vger.kernel.org
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   82 --------------------
 .../devicetree/bindings/iio/adc/exynos-adc.txt     |   82 ++++++++++++++++++++
 2 files changed, 82 insertions(+), 82 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/exynos-adc.txt

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
deleted file mode 100644
index b87749a..0000000
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ /dev/null
@@ -1,82 +0,0 @@
-Samsung Exynos Analog to Digital Converter bindings
-
-The devicetree bindings are for the new ADC driver written for
-Exynos4 and upward SoCs from Samsung.
-
-New driver handles the following
-1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
-   and future SoCs from Samsung
-2. Add ADC driver under iio/adc framework
-3. Also adds the Documentation for device tree bindings
-
-Required properties:
-- compatible:		Must be "samsung,exynos-adc-v1"
-				for exynos4412/5250 controllers.
-			Must be "samsung,exynos-adc-v2" for
-				future controllers.
-			Must be "samsung,exynos3250-adc-v2" for
-				for controllers compatible with ADC of
-				Exynos3250.
-- reg:			Contains ADC register address range (base address and
-			length) and the address of the phy enable register.
-- interrupts: 		Contains the interrupt information for the timer. The
-			format is being dependent on which interrupt controller
-			the Samsung device uses.
-- #io-channel-cells = <1>; As ADC has multiple outputs
-- clocks		From common clock bindings: handles to clocks specified
-			in "clock-names" property, in the same order.
-- clock-names		From common clock bindings: list of clock input names
-			used by ADC block:
-			- "adc" : ADC bus clock
-			- "sclk_adc" : ADC special clock (only for Exynos3250
-				       and compatible ADC block)
-- vdd-supply		VDD input supply.
-
-Note: child nodes can be added for auto probing from device tree.
-
-Example: adding device info in dtsi file
-
-adc: adc@12D10000 {
-	compatible = "samsung,exynos-adc-v1";
-	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
-	interrupts = <0 106 0>;
-	#io-channel-cells = <1>;
-	io-channel-ranges;
-
-	clocks = <&clock 303>;
-	clock-names = "adc";
-
-	vdd-supply = <&buck5_reg>;
-};
-
-Example: adding device info in dtsi file for Exynos3250 with additional sclk
-
-adc: adc@126C0000 {
-	compatible = "samsung,exynos3250-adc-v2";
-	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
-	interrupts = <0 137 0>;
-	#io-channel-cells = <1>;
-	io-channel-ranges;
-
-	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
-	clock-names = "adc", "sclk_adc";
-
-	vdd-supply = <&buck5_reg>;
-};
-
-Example: Adding child nodes in dts file
-
-adc@12D10000 {
-
-	/* NTC thermistor is a hwmon device */
-	ncp15wb473@0 {
-		compatible = "ntc,ncp15wb473";
-		pullup-uv = <1800000>;
-		pullup-ohm = <47000>;
-		pulldown-ohm = <0>;
-		io-channels = <&adc 4>;
-	};
-};
-
-Note: Does not apply to ADC driver under arch/arm/plat-samsung/
-Note: The child node can be added under the adc node or separately.
diff --git a/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
new file mode 100644
index 0000000..b87749a
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
@@ -0,0 +1,82 @@
+Samsung Exynos Analog to Digital Converter bindings
+
+The devicetree bindings are for the new ADC driver written for
+Exynos4 and upward SoCs from Samsung.
+
+New driver handles the following
+1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
+   and future SoCs from Samsung
+2. Add ADC driver under iio/adc framework
+3. Also adds the Documentation for device tree bindings
+
+Required properties:
+- compatible:		Must be "samsung,exynos-adc-v1"
+				for exynos4412/5250 controllers.
+			Must be "samsung,exynos-adc-v2" for
+				future controllers.
+			Must be "samsung,exynos3250-adc-v2" for
+				for controllers compatible with ADC of
+				Exynos3250.
+- reg:			Contains ADC register address range (base address and
+			length) and the address of the phy enable register.
+- interrupts: 		Contains the interrupt information for the timer. The
+			format is being dependent on which interrupt controller
+			the Samsung device uses.
+- #io-channel-cells = <1>; As ADC has multiple outputs
+- clocks		From common clock bindings: handles to clocks specified
+			in "clock-names" property, in the same order.
+- clock-names		From common clock bindings: list of clock input names
+			used by ADC block:
+			- "adc" : ADC bus clock
+			- "sclk_adc" : ADC special clock (only for Exynos3250
+				       and compatible ADC block)
+- vdd-supply		VDD input supply.
+
+Note: child nodes can be added for auto probing from device tree.
+
+Example: adding device info in dtsi file
+
+adc: adc@12D10000 {
+	compatible = "samsung,exynos-adc-v1";
+	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+	interrupts = <0 106 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+
+	clocks = <&clock 303>;
+	clock-names = "adc";
+
+	vdd-supply = <&buck5_reg>;
+};
+
+Example: adding device info in dtsi file for Exynos3250 with additional sclk
+
+adc: adc@126C0000 {
+	compatible = "samsung,exynos3250-adc-v2";
+	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	interrupts = <0 137 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+
+	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+	clock-names = "adc", "sclk_adc";
+
+	vdd-supply = <&buck5_reg>;
+};
+
+Example: Adding child nodes in dts file
+
+adc@12D10000 {
+
+	/* NTC thermistor is a hwmon device */
+	ncp15wb473@0 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 4>;
+	};
+};
+
+Note: Does not apply to ADC driver under arch/arm/plat-samsung/
+Note: The child node can be added under the adc node or separately.
-- 
1.7.9.5

