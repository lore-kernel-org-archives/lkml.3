Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaFRCWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:22:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28627 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaFRCVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:21:14 -0400
X-AuditID: cbfee68f-b7fef6d000003970-2f-53a0f796af7b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Wed, 18 Jun 2014 11:21:00 +0900
Message-id: <1403058061-24271-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQHfa9wXBBgtv8VrcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmsbBtCYvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKK4bFJSczLLUov07RK4Mv7+2MVS8Eug4siPn6wNjF94uxg5OSQE
	TCQmz5vNBmGLSVy4tx7MFhJYyijR8ZYVpuZy4xsgmwsoPp1RYve+pewQThOTxPytO5lBqtgE
	tCT2v7gB1i0iECExf/MOJpAiZoEXTBKP7j5gBEkIC0RKbOq6DzaWRUBVorX1NAuIzSvgKnHi
	3WMmiHVyEh/2PGIHsTkF3CR+bpjBAnGSq8S0B3NYQIZKCPxll5h79AsTxCABiW+TDwElOIAS
	shKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQIj7fS/Z/07
	GO8esD7EmAw0biKzlGhyPjBS80riDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QDY+APpWT1VTr3feu1tVrN4l+nmqZN31Qbu+Wgwe11pjzpYZOL1373
	zlStyUze5rnbtalx3Q/Otl8btcy6y3bkvpt769c2t9rL283+Sc6uMhDvP3Iv59BTBuGN5uI9
	ebEmR1vFJlqsXHxY96SkVJjI9smzc5bu/jzdxaHWTdX/RNoG3dkT99y8pMRSnJFoqMVcVJwI
	AF4oUpLKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd1p3xcEGzTPZrW4+/wwo8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXNYmHbEhaLeUfesVhc3jWHzWLG+X1MFkuvX2Sy
	mDB9LYvF2zvTWSxa9x5htzj5p5fRYv2M1ywOgh5r5q1h9Ljc18vksXL5FzaPzSu0PDat6mTz
	uHNtD5tH35ZVjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAP2hpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz4
	+2MXS8EvgYojP36yNjB+4e1i5OSQEDCRuNz4hhXCFpO4cG89WxcjF4eQwHRGid37lrJDOE1M
	EvO37mQGqWIT0JLY/+IGG4gtIhAhMX/zDiaQImaBF0wSj+4+YARJCAtESmzqug82lkVAVaK1
	9TQLiM0r4Cpx4t1jJoh1chIf9jxiB7E5Bdwkfm6YAVYjBFQz7cEclgmMvAsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBEfyM6kdjCsbLA4xCnAwKvHwcuQuCBZiTSwrrsw9xCjBwawk
	wqtyDijEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cAkk1cSb2hsYmZkaWRuaGFkbE6asJI4
	74FW60AhgfTEktTs1NSC1CKYLUwcnFLAqA98kh+i6PyN/5bi5Meb1ML2enLuSJrh+sajR/fU
	ywBXFdFoqf1qCdmCR/VPfdUxLnuocmXrnpmiDOFX2N6HTq7aGxbyZd1vzcZU+/R/W2fwFaT2
	p4UbXO99kMSaqceScE3w+v8DnLnMnntd7GJKJJwf313XsHCj48bOUD+2t/sagjQY529TYinO
	SDTUYi4qTgQAiJalBigDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 5d49f2b..3a5af82 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,6 +14,8 @@ Required properties:
 				for exynos4412/5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos3250-adc-v2" for
+				for exynos3250 controllers.
 - reg:			Contains ADC register address range (base address and
 			length) and the address of the phy enable register.
 - interrupts: 		Contains the interrupt information for the timer. The
@@ -21,7 +23,11 @@ Required properties:
 			the Samsung device uses.
 - #io-channel-cells = <1>; As ADC has multiple outputs
 - clocks		From common clock binding: handle to adc clock.
+			From common clock binding: handle to sclk_tsadc clock
+			if using Exynos3250.
 - clock-names		From common clock binding: Shall be "adc".
+			From common clock binding: Shall be "sclk_tsadc"
+			if using Exynos3250.
 - vdd-supply		VDD input supply.
 
 Note: child nodes can be added for auto probing from device tree.
@@ -41,6 +47,20 @@ adc: adc@12D10000 {
 	vdd-supply = <&buck5_reg>;
 };
 
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
 
 Example: Adding child nodes in dts file
 
-- 
1.8.0

