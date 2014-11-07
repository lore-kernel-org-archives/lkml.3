Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKGCw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:52:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27654 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaKGCwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:52:17 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-28-545c33da1b1b
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        jonghwa3.lee@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 5/5] Documentation: Add documentation for rt5033 multifunction
 device
Date: Fri, 07 Nov 2014 11:52:07 +0900
Message-id: <1415328727-16245-6-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
References: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkUPeWcUyIwccJChanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYtF59gmzxdmmN+wW
	978eZbT4dqWDyeLyrjlsFp97jzBaLL1+kcliwvS1LBate4+wW5zuZrU4vbvEYsbkl2wOYh5r
	5q1h9Ljc18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DzmnQz06NuyitHj8ya5AK4oLpuU
	1JzMstQifbsErozXJ/cxFxxSr+i9/5+tgXGJQhcjJ4eEgIlE78sr7BC2mMSFe+vZQGwhgaWM
	EueWVMLUbDl/hbmLkQsoPp1R4t3RPkYIp41J4ui8d2AdbAKaEu+nXGEBsUUEIiTOLpvFAlLE
	LHCKWWL96T9gCWGBcIkpM86CNbAIqEr0zt4HFucVcJO4dWknaxcjB9A6BYk5k2xAwpwC7hLP
	H29jhrjITWLv2oNgMyUEVnJInDh0lglijoDEt8mHWCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKs
	YhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiM09P/nk3YwXjvgPUhRgEORiUe3hu8MSFCrIll
	xZW5hxhNgTZMZJYSTc4HJoO8knhDYzMjC1MTU2Mjc0szJXHe11I/g4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwCngV3Mo6rbKmZXLK5jkaxRz9M94Zv6m98ky9oa5nM+PDB9sWOTkv1G3e
	nC9721buVc4Upd5dK7ll00wW7Zt53XCuKs8LmbmXVx1nfLfq6BP7744hbTMj+X5yTpgQHtm7
	ur9adOup/sanqnuFoz8H+RV1rWYonquT/1XLXV+vKJtdc47PvKWVSizFGYmGWsxFxYkAxsiq
	hc4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoO4t45gQg8VXRS1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxaLz7BNmi7NNb9gt
	7n89ymjx7UoHk8XlXXPYLD73HmG0WHr9IpPFhOlrWSxa9x5htzjdzWpxeneJxYzJL9kcxDzW
	zFvD6HG5r5fJY+esu+weK5d/YfPYvELLY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAVxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB/KimUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzXp/cx1xwSL2i9/5/tgbGJQpdjJwc
	EgImElvOX2GGsMUkLtxbz9bFyMUhJDCdUeLd0T5GCKeNSeLovHdsIFVsApoS76dcYQGxRQQi
	JM4um8UCUsQscIpZYv3pP2AJYYFwiSkzzoI1sAioSvTO3gcW5xVwk7h1aSdrFyMH0DoFiTmT
	bEDCnALuEs8fbwO7QgioZO/agywTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhO
	A8+kdjCubLA4xCjAwajEw3uTNyZEiDWxrLgy9xCjBAezkgivDTtQiDclsbIqtSg/vqg0J7X4
	EKMp0FETmaVEk/OBKSqvJN7Q2MTMyNLI3NDCyNhcSZz3QKt1oJBAemJJanZqakFqEUwfEwen
	VAOjPB9bh2jS4j717k5mk69/nPeyHj25wrni1McUb+ayQ7bHpDNl+J9Veab+VItV3TzfQOJE
	xrUHU1WMIuadj2d2NVZ6cvTMopC/PDu6PsyKCzrAOiH6AZtGynatM03lEov/H+fdulWaTcbl
	Z93MzmD2/9WnqjZEPhTLeZ1zfuW+p1pxe36l7tmkxFKckWioxVxUnAgATopClRkDAAA=
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
 Documentation/devicetree/bindings/mfd/rt5033.txt   |  115 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 2 files changed, 116 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt

diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
new file mode 100644
index 0000000..8b55a79
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
@@ -0,0 +1,115 @@
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
+Required properties:
+- compatible = Must be "richtek,rt5033-regulator"
+
+	regulators {
+		compatible = "richtek,rt5033-regulator";
+
+		regulator-name {
+			regulator-name = LDO/BUCK
+			standard regulator constraints...
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
+				compatible = "richtek,rt5033-regulator";
+
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

