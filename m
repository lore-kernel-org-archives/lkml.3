Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaKTNRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:17:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56922 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKTNQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:16:56 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-66-546de9c1a437
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v6 4/4] Documentation: Add documentation for rt5033
 multifunction device
Date: Thu, 20 Nov 2014 22:16:46 +0900
Message-id: <1416489406-12416-5-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416489406-12416-1-git-send-email-beomho.seo@samsung.com>
References: <1416489406-12416-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkUPfgy9wQg5v7BC1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CV
	sePMHcaCyeoVm3beYG1gfC/fxcjJISFgItHyeQEjhC0mceHeerYuRi4OIYGljBJbJy5lhina
	e2kBE0RiOqPEpi93GSGcNiaJ9oNP2UGq2AQ0Jd5PucICYosIREicXTaLBaSIWWASs8TNtz1g
	O4QFoiSmvP8ONpZFQFWiZfsuNhCbV8BNYuubWaxdjBxA6xQk5kyyAQlzCrhLnLnWwwpiCwGV
	vOr6A3XqTA6J1UsKIcYISHybfIgFolVWYtMBqKMlJQ6uuMEygVF4ASPDKkbR1ILkguKk9CIT
	veLE3OLSvHS95PzcTYzAmDz979mEHYz3DlgfYhTgYFTi4U2wyA0RYk0sK67MPcRoCrRhIrOU
	aHI+MPLzSuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WHvk3vJEnqnbar6/itkycaLY1t61dT0GT+q1OrmkFpy9cSX5z5KiVzd5Q3q/HywrZZF/U+hr
	8i3cTHSipFKOMPs1u4KcCMve+XZiAeZz3D7es747nWOjzZEXb7rv1acd5PgYc2dq7Zu7OkkH
	PhdZBDC+Mtv+/pehL/8s7lXKRjUXXzkcsun/pcRSnJFoqMVcVJwIAOdcvLzEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd2DL3NDDC59Ybc4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2aL/zUJWiz8TWtkszr1ayWgx6f4EFov3e84wWny70sFk
	cXnXHDaLz71HGC2WXr/IZDFh+loWi9a9R4CGdrNanN5dYjFj8ks2BxGPNfPWMHpc7utl8tg5
	6y67x8rlX9g8Nq/Q8ti0qpPN4861PWwe804GevRtWcXo8XmTXABXVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qd0oKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwhrGjB1n7jAWTFav2LTzBmsD43v5LkZODgkBE4m9lxYwQdhi
	EhfurWfrYuTiEBKYziix6ctdRginjUmi/eBTdpAqNgFNifdTrrCA2CICERJnl81iASliFpjE
	LHHzbQ8jSEJYIEpiyvvvzCA2i4CqRMv2XWwgNq+Am8TWN7NYuxg5gNYpSMyZZAMS5hRwlzhz
	rYcVxBYCKnnV9YdxAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBMf9MagfjygaL
	Q4wCHIxKPLwJFrkhQqyJZcWVuYcYJTiYlUR4NXYChXhTEiurUovy44tKc1KLDzGaAh01kVlK
	NDkfmI7ySuINjU3MjCyNzA0tjIzNlcR5b9wEahJITyxJzU5NLUgtgulj4uCUamDUU5uYJ5hp
	WPpmrf5ct7LXK6ct+XOwQfTAVoWD+/vywrZ6VLZs5U/Ksp3mLqPwsIZPIK53vQmbTnfp/jm2
	m4r8JCIsVdXb+DcsrU7SWXVy+VNuteXXTd39vLbkBlpF5/Hn28xY7+37Z+/j4h1fl2n7MDvN
	vRDZNSH6poiL3hp3jlnRac/L7JRYijMSDbWYi4oTAfw+dh8PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch device tree binding documentation for rt5033 multifunction device.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes in v6:
Changes in v5:
Changes in v4:
Changes in v3:
- none.

Changes in v2:
- Revise binding documentation.

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 2 files changed, 109 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt

diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
new file mode 100644
index 0000000..52a6d33
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
@@ -0,0 +1,108 @@
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
+named "regulators" usinge the following format.
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
+- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
+  voltage is below pre-charge threshold voltage, the charger is in pre-charge
+  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
+  by I2C per 0.1 V.
+- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
+  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
+- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
+  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
+- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
+  to 200 mA.
+
+	charger {
+		compatible = "richtek,rt5033-charger";
+		richtek,pre-uamp = <350000>;
+		richtek,pre-threshold-uvolt = <3400000>;
+		richtek,fast-uamp = <2000000>;
+		richtek,const-uvolt = <4350000>;
+		richtek,eoc-uamp = <250000>;
+	};
+
+
+Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
+using the following format.
+
+Required properties:
+- compatible = Must be "richtek,rt5033-battery".
+
+	i2c_fuel: i2c@1 {
+		compatible = "i2c-gpio";
+		standard i2c-gpio constraints...
+		fuelgauge {
+			compatible = "richtek,rt5033-battery".
+		};
+	};
+
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
+				richtek,pre-threshold-uvolt = <3400000>;
+				richtek,fast-uamp = <2000000>;
+				richtek,const-uvolt = <4350000>;
+				richtek,eoc-uamp = <250000>;
+			};
+
+		};
+
+		i2c_fuel: i2c@10 {
+			compatible = "i2c-gpio";
+			gpios = <&gpm3 1 0
+				&gpm3 0 0>;
+
+			fuel: rt5033-battery@35 {
+				compatible = "richtek,rt5033-battery";
+				interrupt-parent = <&gpx2>;
+				interrupts = <3 0>;
+				reg = <0x35>;
+			};
+		};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 723999d..611b543 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -124,6 +124,7 @@ ralink	Mediatek/Ralink Technology Corp.
 ramtron	Ramtron International
 realtek Realtek Semiconductor Corp.
 renesas	Renesas Electronics Corporation
+richtek	Richtek Technology Corporation
 ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
-- 
1.7.9.5

