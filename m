Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaCKH4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:56:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51985 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaCKHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:08 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-65-531ec1557f3e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/5] ARM: dts: exynos4x12: Add ADC's dt data to read raw data
Date: Tue, 11 Mar 2014 16:54:50 +0900
Message-id: <1394524494-30641-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkUDf0oFywQfcleYvrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgARxSX
	TUpqTmZZapG+XQJXxv5X/awF7VwV7a/WMjcwzuLoYuTkkBAwkTiwoYMNwhaTuHBvPZDNxSEk
	sJRR4tXeCywwRVentjFBJBYxSjx7uZkZwmlkklh36xgjSBWbgJbE/hc3wEaJCOhKTJl5hxWk
	iFngPpPEj+OrwBLCAr4SVzfNZAexWQRUJZbunAdm8wq4SqzrusEEsU5O4sOeR2BxTgE3iae3
	l7OC2EJANV+e3AQ7Q0LgEbvEkxkXWCEGCUh8m3wI6FYOoISsxKYDzBBzJCUOrrjBMoFReAEj
	wypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwEg6/e/ZxB2M9w9YH2JMBho3kVlKNDkfGIl5
	JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBo+2rC
	1xOcl+Ya6lxcVXuf4ULBRr79DBs2PQzv8u1i+uZp6sR4SIQh1EjrXucU0+1PEp7dj/+kvj0o
	RlRCRvVSq/N2tsxzBtt/ZufEuyv/Fbgxf9XOuFnSZ18eLsl++neL3FTeNTd3qT/orXZbWlDw
	dKXFGX4Xe7/Wv7VXp+ScM1kWNeVE7H4LJZbijERDLeai4kQAzGSmOboCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgG7oQblgg8eXxCyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDP2v+pnLWjnqmh/tZa5gXEWRxcj
	J4eEgInE1altTBC2mMSFe+vZuhi5OIQEFjFKPHu5mRnCaWSSWHfrGCNIFZuAlsT+FzfYQGwR
	AV2JKTPvsIIUMQvcZ5L4cXwVWEJYwFfi6qaZ7CA2i4CqxNKd88BsXgFXiXVdN6DWyUl82PMI
	LM4p4Cbx9PZyVhBbCKjmy5ObTBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7T
	Z1I7GFc2WBxiFOBgVOLhDfCVCxZiTSwrrsw9xCjBwawkwuu0FijEm5JYWZValB9fVJqTWnyI
	MRnoqonMUqLJ+cAUklcSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs1NSC1CKYLUwc
	nFINjAxZifsFf34uKc89tvr67nDfif8Zmh/PS9jfwbdOqCM2SDXicPpsrdvWMX9PijacvPDL
	7/VKtxvdD7IavvRnK+1fNLemjEvR/ke+9odF2Zvfu0+vq+55IhXQdF7kBV8c40e7uHnKjSJc
	m+Zce/rTeMnjLboL9BYt2aO0LOOsV8qJxzFNDCenaSixFGckGmoxFxUnAgBYNk4zFwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add ADC(Analog to Digital Converter)'s dt data to get raw data
with IIO subsystem. Usually, ADC is used to check temperature, jack type, and
so on.

Register map
- <0x126C0000 0x100> : ADC register's base address
- <0x10020718 0x4> : ADC_PHY_CONTROL, TS-ADC control register address

Clock
- <&clock 326> : ADC clock (clock name :'tsadc')

Interrupt
- INTG10[3] : ADC for General ADC

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 5c412aa..5a3e551 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -80,6 +80,18 @@
 		};
 	};
 
+	adc: adc@126C0000 {
+		compatible = "samsung,exynos-adc-v1";
+		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 3>;
+		clocks = <&clock 326>;
+		clock-names = "adc";
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
+
 	pinctrl_2: pinctrl@03860000 {
 		compatible = "samsung,exynos4x12-pinctrl";
 		reg = <0x03860000 0x1000>;
-- 
1.8.0

