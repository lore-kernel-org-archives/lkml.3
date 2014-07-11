Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaGKJLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:11:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27452 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaGKJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:42 -0400
X-AuditID: cbfee690-b7fb56d000003439-2b-53bfaa0f978b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: [PATCH 3/4] Documentation: dt-bindings: update exynos-adc.txt with
 syscon handle
Date: Fri, 11 Jul 2014 14:36:28 +0530
Message-id: <1405069589-10388-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSq8u/an+wwYfJ1hYvD2laXP/ynNVi
	/pFzrBbNi9ezWbw68oPJYsnk+awW8468Y7G4vGsOm8WM8/uYLBZt+8/swOUxu+Eii8fOWXfZ
	PfbPXcPuseTNIVaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyrgzuZu9YK14xatDa1gbGN8I
	dTFyckgImEj0Pn/FBGGLSVy4t56ti5GLQ0hgKaPE64bLzDBFr7deYYRITGeUOHXqIguE088k
	0b3oIDtIFZuAmcTBRavBbBGBOIkPl/vZQYqYBdYySrRtuwqWEBaIlvh3ahPYWBYBVYl/258A
	jeXg4BVwlbj41wnElBBQkJgzyQakglPATeLbv0awaiGgii23usH2SgjsYpc4dWEfO8QYAYlv
	kw+xQPTKSmw6AHW0pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGA2n
	/z2bsIPx3gHrQ4zJQOMmMkuJJucDoymvJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhjFfBLzErye3HCs3OA7je3P/fTlHgw3N0yt3jLVM7mb+1PE
	IUXdvuSrpsZnLNc0sF2fppborCaTeOdus8VsgzPc/Ql3Ork2+zb4blws3Dkj+IbsCXf2KapP
	nsz/fcN6g7iv6drnOqonXq5eP7t6n6L/2SqeGfWvhI9N/60gs3MO+8qtm96tNIhQYinOSDTU
	Yi4qTgQAynKXtpwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd2fK/cHGzQu4bd4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mBy6P2Q0XWTx2zrrL
	7rF/7hp2jyVvDrF69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtBpSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMO5O72QvWile8OrSGtYHxjVAXIyeHhICJxOutVxghbDGJC/fWs3UxcnEICUxnlDh1
	6iILhNPPJNG96CA7SBWbgJnEwUWrwWwRgTiJD5f72UGKmAXWMkq0bbsKlhAWiJb4d2oTM4jN
	IqAq8W/7E6AVHBy8Aq4SF/86gZgSAgoScybZgFRwCrhJfPvXCFYtBFSx5VY3ywRG3gWMDKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmPtmdQOxpUNFocYBTgYlXh4FdbvCxZiTSwrrsw9
	xCjBwawkwvukfn+wEG9KYmVValF+fFFpTmrxIUZToJsmMkuJJucD00BeSbyhsYm5qbGppYmF
	iZmlkjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZGa0fFI/IRilKX9r9d2PnhyYFHZ498Mg6P
	OPmG45dFW9AMNt02bveP9nUvu5wd1/yb/fTgs59TQz8GPeZd+OqgZ6plqUz7zmezrdQ+v1we
	Irp71k0vu39hhkwTrf++KTrV6pzGuDj39o/lXZs6Cr+nPCmUrTXuExFfLC5m9OJtSOG7OycX
	NRtsVmIpzkg01GIuKk4EAM+CbNDLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the DT bindings in exynos-adc.txt with the
syscon phandle to the ADC nodes.

Also removes the 2nd "reg" property, which used to carry the
ADC_PHY regiser base from PMU.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: devicetree@vger.kernel.org
---
 .../devicetree/bindings/iio/adc/exynos-adc.txt     |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
index b87749a..808bbfa 100644
--- a/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
@@ -1,10 +1,11 @@
 Samsung Exynos Analog to Digital Converter bindings
 
 The devicetree bindings are for the new ADC driver written for
-Exynos4 and upward SoCs from Samsung.
+Exynos4 and Exynos5 series SoCs from Samsung.
+Now supports Exynos3250 too.
 
 New driver handles the following
-1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
+1. Supports ADC IF found on Exynos3250/EXYNOS4412/EXYNOS5 series
    and future SoCs from Samsung
 2. Add ADC driver under iio/adc framework
 3. Also adds the Documentation for device tree bindings
@@ -18,7 +19,7 @@ Required properties:
 				for controllers compatible with ADC of
 				Exynos3250.
 - reg:			Contains ADC register address range (base address and
-			length) and the address of the phy enable register.
+			length)
 - interrupts: 		Contains the interrupt information for the timer. The
 			format is being dependent on which interrupt controller
 			the Samsung device uses.
@@ -31,6 +32,8 @@ Required properties:
 			- "sclk_adc" : ADC special clock (only for Exynos3250
 				       and compatible ADC block)
 - vdd-supply		VDD input supply.
+- samsung,syscon-phandle Contains the PMU system controller node
+			(To access the ADC_PHY register)
 
 Note: child nodes can be added for auto probing from device tree.
 
@@ -38,7 +41,7 @@ Example: adding device info in dtsi file
 
 adc: adc@12D10000 {
 	compatible = "samsung,exynos-adc-v1";
-	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+	reg = <0x12D10000 0x100>;
 	interrupts = <0 106 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
@@ -47,13 +50,14 @@ adc: adc@12D10000 {
 	clock-names = "adc";
 
 	vdd-supply = <&buck5_reg>;
+	samsung,syscon-phandle = <&pmu_system_controller>;
 };
 
 Example: adding device info in dtsi file for Exynos3250 with additional sclk
 
 adc: adc@126C0000 {
 	compatible = "samsung,exynos3250-adc-v2";
-	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	reg = <0x126C0000 0x100>;
 	interrupts = <0 137 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
@@ -62,6 +66,7 @@ adc: adc@126C0000 {
 	clock-names = "adc", "sclk_adc";
 
 	vdd-supply = <&buck5_reg>;
+	samsung,syscon-phandle = <&pmu_system_controller>;
 };
 
 Example: Adding child nodes in dts file
-- 
1.7.9.5

