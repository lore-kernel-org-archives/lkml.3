Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbaDJKHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965755AbaDJKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:54 -0400
X-AuditID: cbfee68e-b7f566d000002344-e5-53466d20ae31
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/27] ARM: dts: exynos3250: Add i2c dt node
Date: Thu, 10 Apr 2014 19:06:08 +0900
Message-id: <1397124377-16969-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkSFch1y3Y4NxlHYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MrYuf8mU8FH6Ypf02+yNTDeE+1i5OCQEDCRWDgh
	qIuRE8gUk7hwbz1bFyMXh5DAUkaJWyevs0MkTCQ6F85hhUgsYpSY82UVC0hCSKCJSaL9dy6I
	zSagJbH/xQ02EFtEIEDix/F3YDazwE1GiWPvw0BsYQEbid37HrOALGYRUJWY/t4FJMwr4CZx
	4ONdFohdchIf9jwC28sJFJ+56CQbxCpXiZ5HF5lBbpAQWMcusfPiMWaQBIuAgMS3yYdYIJ6R
	ldh0gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERj0p/8969vB
	ePOA9SHGZKBxE5mlRJPzgVGTVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYS/oV+zw+KH1cXywbWxrnz/B2bop6a1QXk2OD3G1Tj1an+IqOsl/M
	v25Z3V23i8Xz9If7PakSBwx4yvUM/x7653d0yv8dk3YckNSu0XPIW3VELKXnn3/wkmDuJ+9f
	iYkL/3PjWRX4oebHnPXuMT/+P91VMFshrzLk95OV+bPOnEyf+H6+9AxzJZbijERDLeai4kQA
	lFBrfZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2FXLdggw9flC2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxs79N5kK
	PkpX/Jp+k62B8Z5oFyMnh4SAiUTnwjmsELaYxIV769m6GLk4hAQWMUrM+bKKBSQhJNDEJNH+
	OxfEZhPQktj/4gYbiC0iECDx4/g7MJtZ4CajxLH3YSC2sICNxO59j4F6OThYBFQlpr93AQnz
	CrhJHPh4lwVil5zEhz2P2EFsTqD4zEUn2SBWuUr0PLrIPIGRdwEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4Kh6Jr2DcVWDxSFGAQ5GJR7eA8tcg4VYE8uKK3MPMUpwMCuJ8O7OdAsW
	4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5HxgxOeVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA+MyxYA5l2TE6mOvvv7B1dzAPOvCT4O7wpPnfPC7Wb3OS+9v
	5ZSjPnWPVvEdVNjzbvMqvt1RHy8scZ+0U+tE3fs/v495Tt561aPl1+3Q1oQl2tYdd9Z8FuXx
	yI1gkHgXprflZP62Nyr5N2IMXL/3/ylc2jZ5VcvpvYG8vVpGB45OE3u1Yf+THK81SizFGYmG
	WsxFxYkAM59beu4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inki Dae <inki.dae@samsung.com>

Add the DTS nodes for all th i2c busses in the Exynos3250 SoC.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
[Add i2c alias by Tomasz Figa]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 112 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c5e6917..a16c3ea 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -28,6 +28,14 @@
 	aliases {
 		pinctrl0 = &pinctrl_0;
 		pinctrl1 = &pinctrl_1;
+		i2c0 = &i2c_0;
+		i2c1 = &i2c_1;
+		i2c2 = &i2c_2;
+		i2c3 = &i2c_3;
+		i2c4 = &i2c_4;
+		i2c5 = &i2c_5;
+		i2c6 = &i2c_6;
+		i2c7 = &i2c_7;
 	};
 
 	chipid@10000000 {
@@ -112,4 +120,108 @@
 		clock-names = "uart", "clk_uart_baud0";
 		status = "disabled";
 	};
+
+	i2c_0: i2c@13860000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13860000 0x100>;
+		interrupts = <0 113 0>;
+		clocks = <&cmu CLK_I2C0>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c0_bus>;
+		status = "disabled";
+	};
+
+	i2c_1: i2c@13870000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13870000 0x100>;
+		interrupts = <0 114 0>;
+		clocks = <&cmu CLK_I2C1>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c1_bus>;
+		status = "disabled";
+	};
+
+	i2c_2: i2c@13880000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13880000 0x100>;
+		interrupts = <0 115 0>;
+		clocks = <&cmu CLK_I2C2>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c2_bus>;
+		status = "disabled";
+	};
+
+	i2c_3: i2c@13890000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x13890000 0x100>;
+		interrupts = <0 116 0>;
+		clocks = <&cmu CLK_I2C3>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c3_bus>;
+		status = "disabled";
+	};
+
+	i2c_4: i2c@138A0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138A0000 0x100>;
+		interrupts = <0 117 0>;
+		clocks = <&cmu CLK_I2C4>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c4_bus>;
+		status = "disabled";
+	};
+
+	i2c_5: i2c@138B0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138B0000 0x100>;
+		interrupts = <0 118 0>;
+		clocks = <&cmu CLK_I2C5>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c5_bus>;
+		status = "disabled";
+	};
+
+	i2c_6: i2c@138C0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138C0000 0x100>;
+		interrupts = <0 119 0>;
+		clocks = <&cmu CLK_I2C6>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c6_bus>;
+		status = "disabled";
+	};
+
+	i2c_7: i2c@138D0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x138D0000 0x100>;
+		interrupts = <0 120 0>;
+		clocks = <&cmu CLK_I2C7>;
+		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c7_bus>;
+		status = "disabled";
+	};
 };
-- 
1.8.0

