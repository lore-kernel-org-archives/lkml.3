Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbbAVEHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:07:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52113 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbbAVEGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:06:45 -0500
X-AuditID: cbfee68f-f791c6d000004834-d2-54c07753b813
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, robh+dt@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v4 2/2] Documentation: Add documentation for rt5033
 multifunction device
Date: Thu, 22 Jan 2015 13:06:40 +0900
Message-id: <1421899601-19327-3-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
References: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkWDe4/ECIwaFZnBanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5Vov+NwtZLc69WsloMen+BBaL93vOMFrc/3qU0eLyrjlsFp97jzBa
	LL1+kcliwvS1LBate4+wW5zeXWIxY/JLNgdBjzXz1jB6XO7rZfLYOesuu8fK5V/YPDat6mTz
	uHNtD5tH35ZVjB6fN8kFcERx2aSk5mSWpRbp2yVwZczZ/4Cp4J96xcG5/1kaGB8odDFyckgI
	mEi0nlvMCmGLSVy4t56ti5GLQ0hgKaPEkvMfmGCKbv/YCpVYxCixZ819sISQQBuTxIY9lSA2
	m4CmxPspV1hAbBGBGolJZ96zgdjMAluYJF73GIDYwgJREk3Lm8B6WQRUJTY1T2cHsXkF3CQO
	tmwGuoIDaJmCxJxJNiBhTgF3icP/HjJDrHKT+Nl1GuwGCYGf7BIdrzrYIeYISHybfIgFoldW
	YtMBZoibJSUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwCg7/e9Z/w7G
	uwesDzEKcDAq8fBmFB8IEWJNLCuuzD3EaAq0YSKzlGhyPjCW80riDY3NjCxMTUyNjcwtzZTE
	eRdK/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFhpzZlcfmPTflU37a1quzZXv1l7m2Fr
	lae+aveV9UrrL5daFcjJn3lx4/9sdgFd1qq30nPjhVx49ksVrf6t0t6zzH6ja2yamEMvj7OA
	yszUhV3d+5n6pAzlp++OL2MXjdwSmzNjHU/5Tr3FCWJqTc9ObL3yZmWrefPXHR8uv5ndzNcV
	5KZ5XImlOCPRUIu5qDgRAOXe752tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd2g8gMhBp++Wluc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC363yxktTj3aiWjxaT7E1gs3u85w2hx/+tRRovLu+awWXzuPcJo
	sfT6RSaLCdPXsli07j3CbnF6d4nFjMkv2RwEPdbMW8Pocbmvl8lj56y77B4rl39h89i0qpPN
	4861PWwefVtWMXp83iQXwBHVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQ
	l5ibaqvk4hOg65aZA/SHkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj
	zv4HTAX/1CsOzv3P0sD4QKGLkZNDQsBE4vaPrWwQtpjEhXvrgWwuDiGBRYwSe9bcZwJJCAm0
	MUls2FMJYrMJaEq8n3KFBcQWEaiRmHTmPVgzs8AWJonXPQYgtrBAlETT8iawXhYBVYlNzdPZ
	QWxeATeJgy2bWbsYOYCWKUjMmWQDEuYUcJc4/O8hM8QqN4mfXafZJjDyLmBkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHMPPpHcwrmqwOMQowMGoxMObUXwgRIg1say4MvcQowQHs5II
	r4cGUIg3JbGyKrUoP76oNCe1+BCjKdBRE5mlRJPzgeklryTe0NjEzMjSyNzQwsjYXEmcV8m+
	LURIID2xJDU7NbUgtQimj4mDU6qBsW1x8f6I6E1nF7B/u6PcFdaSdYdBZ0dAeUSbF8Pqmtov
	CfFxVmsOl2ZdY//mksi4xC2DWeqa+D+dvXIcAc9Fkv/vi7u7PfVwsZDU+aJEm+3vdsQ/DuJW
	tZaUDIiVu1Z1yf9glkpE/kGPMNdv/o9cvn+KLJnAcf24R0rg3S/3y/fdCe07VaeuxFKckWio
	xVxUnAgAF1dtZ/cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch device tree binding documentation for rt5033 multifunction device.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
Changes in v4
- none.
Changes in v3
- Add Acked-by
Changes in v2
- Fix incorrect typo.
- Align -uamp and -uvolt names with regulator binding suffixes.
- Drop incorrect phandle.
- Fix incorrect example.
---

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 2 files changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt

diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
new file mode 100644
index 0000000..64b23e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
@@ -0,0 +1,101 @@
+Richtek RT5033 Power management Integrated Circuit
+
+RT5033 is a Multifunction device which includes battery charger, fuel gauge,
+flash LED current source, LDO and synchronous Buck converter for portable
+applications. It is interfaced to host controller using i2c interface.
+
+Required properties:
+- compatible : Must be "richtek,rt5033"
+- reg : Specifies the i2c slave address of general part.
+- interrupts : This i2c devices has an IRQ line connected to the main SoC.
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+Regulators: The regulators of RT5033 have to be instantiated under sub-node
+named "regulators" using the following format.
+
+	regulators {
+		regulator-name {
+			regulator-name = LDO/BUCK
+			regulator subnodes called X, Y and Z
+		};
+	};
+	refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+
+Battery charger: There battery charger of RT5033 have to be instantiated under
+sub-node named "charger" using the following format.
+
+Required properties:
+- compatible : Must be "richtek,rt5033-charger".
+- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
+  are 350 mA to 650 mA programmed by I2C per 100 mA.
+- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
+  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
+- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
+  to 200 mA.
+- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
+  voltage is below pre-charge threshold voltage, the charger is in pre-charge
+  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
+  by I2C per 0.1 V.
+- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
+  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
+
+	charger {
+		compatible = "richtek,rt5033-charger";
+		richtek,pre-uamp = <350000>;
+		richtek,fast-uamp = <2000000>;
+		richtek,eoc-uamp = <250000>;
+		richtek,pre-threshold-uvolt = <3400000>;
+		richtek,const-uvolt = <4350000>;
+
+	};
+
+
+Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
+using the following format.
+
+Required properties:
+- compatible = Must be "richtek,rt5033-battery".
+
+	rt5033@35 {
+		compatible = "richtek,rt5033-battery";
+		interrupt-parent = <&gpx2>;
+		interrupts = <3 0>;
+		reg = <0x35>;
+	};
+
+Example:
+
+		rt5033@34 {
+			compatible = "richtek,rt5033";
+			reg = <0x34>;
+			interrupt-parent = <&gpx1>;
+			interrupts = <5 0>;
+
+			regulators {
+				buck_reg: BUCK {
+					regulator-name = "BUCK";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+			};
+
+			charger {
+				compatible = "richtek,rt5033-charger";
+				richtek,pre-uamp = <350000>;
+				richtek,fast-uamp = <2000000>;
+				richtek,eoc-uamp = <250000>;
+				richtek,pre-threshold-uvolt = <3400000>;
+				richtek,const-uvolt = <4350000>;
+			};
+
+		};
+
+		rt5033@35 {
+				compatible = "richtek,rt5033-battery";
+				interrupt-parent = <&gpx2>;
+				interrupts = <3 0>;
+				reg = <0x35>;
+		};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b1df0ad..b6a2ca1 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -134,6 +134,7 @@ ralink	Mediatek/Ralink Technology Corp.
 ramtron	Ramtron International
 realtek Realtek Semiconductor Corp.
 renesas	Renesas Electronics Corporation
+richtek	Richtek Technology Corporation
 ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
-- 
1.7.9.5

