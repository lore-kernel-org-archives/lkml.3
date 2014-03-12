Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaCLGT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:19:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10898 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaCLGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:25 -0400
X-AuditID: cbfee68e-b7f566d000002344-dd-531ffc6bb279
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 5/5] ARM: dts: exynos4412-trats2: Add ADC/themistor dt data
 to get temperature of SoC/battery
Date: Wed, 12 Mar 2014 15:19:16 +0900
Message-id: <1394605156-7768-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkQDfnj3ywwfxWRovrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi1cE2Fov1
	M16zOPB6rJm3htGjpbmHzWPl8i9sHpuX1Hv0bVnF6PF5k5zHxrmhAexRXDYpqTmZZalF+nYJ
	XBldR2wK9nFVvOp6wNbAuI6ji5GDQ0LARGL5lLguRk4gU0ziwr31bF2MXBxCAksZJfb8eMgK
	kTCRuPDzEytEYjqjxI2Dy1kgnEYmiXkXP4FVsQloSex/cYMNxBYR0JWYMvMOWJxZ4BiTxImp
	DiDbhAUKJeYuDwIJswioSnTNuckEYvMKuEg0HvrABLFMTuLDnkfsIOWcAq4SG+Ylg4SFgEqO
	fzzKAnHzOXaJ7ToQUwQkvk0+BBWWldh0gBliiKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRX
	nJhbXJqXrpecn7uJERgnp/8969vBePOA9SHGZKBxE5mlRJPzgXGWVxJvaGxmZGFqYmpsZG5p
	RpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYS5Ws9nNZsu08ODfFkeG38tRb
	mzfsY/pzlbf2RXkj44ZApaOciqs7dy7qUAg3vjrhjnbURZ4K8/O+Oza4PVtfPU/l+PbQ1+tZ
	JsVaeL0V4V29V6JtTmr61slfPooyuzdkhUYtu/JA0UVg9jylYPsJT9oXXL7haiP9Rins2S7z
	O19viXTXZjHIKrEUZyQaajEXFScCAEuxyaSpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd3sP/LBBm+Xmllc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWrw62sVis
	n/GaxYHXY828NYweLc09bB4rl39h89i8pN6jb8sqRo/Pm+Q8Ns4NDWCPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0XXEpmAfV8WrrgdsDYzrOLoYOTkkBEwkLvz8xAph
	i0lcuLeerYuRi0NIYDqjxI2Dy1kgnEYmiXkXIarYBLQk9r+4wQZiiwjoSkyZeQcszixwjEni
	xFSHLkYODmGBQom5y4NAwiwCqhJdc24ygdi8Ai4SjYc+MEEsk5P4sOcRO0g5p4CrxIZ5ySBh
	IaCS4x+Pskxg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgWn0nvYFzVYHGIUYCD
	UYmHd6GmfLAQa2JZcWXuIUYJDmYlEd6PICHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB6aJ
	vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgLHCq8mD6n3Tl
	QtqbglkqPCylYtuzW2fsDLi05lmzfAmX9kzPtccuiizjNpn1+U1qZ63dUr9H9gc3FXbPzGMQ
	mR97WT5kapBL1P7rZ5+KT1L5usabRVDF9WSMUCvb7E4xodgTzuGVM7nurji/YUuJ2XU9N7vf
	q4Smpavc36/3dJfp9Q/Hf4RlKLEUZyQaajEXFScCAM9xS38JAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use ADC to get the temperature of SoC/battery by using NTC thermistor
driver in hwmon. NTC thermistor driver covnvert ADC's raw data to temperature
by using following variables:

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 4f851cc..3228506 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -106,6 +106,11 @@
 		};
 	};
 
+	adc: adc@126C0000 {
+		vdd-supply = <&ldo3_reg>;
+		status = "okay";
+	};
+
 	i2c@13890000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -589,4 +594,20 @@
 			};
 		};
 	};
+
+	thermistor-ap@0 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+		pullup-ohm = <100000>;	 /* 100K */
+		pulldown-ohm = <100000>; /* 100K */
+		io-channels = <&adc 1>;  /* AP temperature */
+	};
+
+	thermistor-battery@1 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+		pullup-ohm = <100000>;	 /* 100K */
+		pulldown-ohm = <100000>; /* 100K */
+		io-channels = <&adc 2>;  /* Battery temperature */
+	};
 };
-- 
1.8.0

