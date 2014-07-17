Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaGQLY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:24:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26629 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbaGQLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:35 -0400
X-AuditID: cbfee690-b7fb56d000003439-ec-53c7b2353526
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH 3/4 v2] Documentation: dt-bindings: update exynos-adc.txt with
 syscon handle
Date: Thu, 17 Jul 2014 16:49:52 +0530
Message-id: <1405595993-16661-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkVtd00/Fgg/u3uC1eHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZHxYdYS54
	KFHR0tXO0sDYKNLFyMkhIWAiMWP2AXYIW0ziwr31bF2MXBxCAksZJZ49uMwGU3Tm8E9miMR0
	RonDR88yQjj9TBKbti9iBqliEzCTOLhoNdgoEYE4iQ+X+9lBipgF9jNKvH69HywhDJRoOn4F
	zGYRUJXYd+wjK4jNK+Aq8engRqCpHEDrFCTmTLIBCXMKuEmsWPOHDSQsBFRy40EeyEgJgWPs
	Ep/Wr2aCGCMg8W3yIRaIVlmJTQeYIY6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL
	89L1kvNzNzECI+T0v2cTdjDeO2B9iDEZaNxEZinR5HxghOWVxBsamxlZmJqYGhuZW5qRJqwk
	zqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6P2ZHZGy2o/tu0l/p/borPEaiy69C9r
	penunlu4UMfzgv3Sk3ZWtaf/TuDar5W7sOuw2ZUqvjWf95YZiHzkqjaYnaK/KdKexWTyx7rd
	1f8cN9+6bP/ybZpoa5wKzzXL3mV8t1Kz+UN+VGdva/ootujwxh+cjRrT32QccSrZw9zn9myG
	6hE5eyWW4oxEQy3mouJEACe9KZ2mAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV3TTceDDTo+Mlu8PKRpcf3Lc1aL
	+UfOsVo0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZnxYdIS54KFERUtXO0sDY6NIFyMnh4SAicSZwz+ZIWwxiQv31rN1
	MXJxCAlMZ5Q4fPQsI4TTzySxafsisCo2ATOJg4tWs4PYIgJxEh8u97ODFDEL7GeUeP16P1hC
	GCjRdPwKmM0ioCqx79hHVhCbV8BV4tPBjUBTOYDWKUjMmWQDEuYUcJNYseYPG0hYCKjkxoO8
	CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx98z6R2MqxosDjEKcDAq8fAmtB4L
	FmJNLCuuzD3EKMHBrCTCu63reLAQb0piZVVqUX58UWlOavEhRlOgmyYyS4km5wNTQ15JvKGx
	ibmpsamliYWJmaWSOO/BVutAIYH0xJLU7NTUgtQimD4mDk6pBkY1+9yvQn9vR8yrrpo9kXPR
	+2aLKuHdi4KqPuWraPcm9b4+csF4wdfKh/N7a2x/sajLTs2pO3Dye9rimVpVry4axDzoEJD5
	fFp2750FTjOY0k9t3j6bZaOa1Zn5iY6ZitKXnyhWrZn5pLvyxK3GDTUMhqnyAVlpf1bdF54Q
	Jtl56nDKjRd/E8WVWIozEg21mIuKEwFOIggf1QIAAA==
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
Changes since v1:
rebased on top of Changwoo's v5 ADC patches for exynos3250

iio: adc: exynos_adc: Support Exynos3250 ADC and code clean
https://lkml.org/lkml/2014/6/27/16

 .../devicetree/bindings/iio/adc/exynos-adc.txt     |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
index 0b0ed85..1634df3 100644
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

