Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKJHT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:19:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKJHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:19:52 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2c-5460671509bd
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 5/5] Documentation: Add documentation for rt5033
 multifunction device
Date: Mon, 10 Nov 2014 16:19:47 +0900
Message-id: <1415603987-32475-6-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
References: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkUFc0PSHEoPuuuMXpT9vYLa5/ec5q
	Mf/IOVaL/jcLWS3+TGhlszj3aiWjxaT7E1gsLu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF
	jMkv2Rx4PdbMW8Pocbmvl8lj5fIvbB6bVnWyefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfG
	vvuL2ApOq1Vs74xrYNwj38XIySEhYCKxaulKNghbTOLCvfVANheHkMBSRolDv3sZYYo2vX7M
	ApFYxCjx/8wyVginjUni86XLTCBVbAKaEu+nXGEBsUUEIiTOLpsF1sEscIxJ4uKThewgCWGB
	KInr+88AJTg4WARUJU4uVwUJ8wq4Seyfc4ARJCwhoCAxZ5INSJhTwF3i9swdYNcJAZVcnfkT
	7DoJgXPsEv/3TWMGSbAICEh8m3yIBaJXVmLTAWaIoyUlDq64wTKBUXgBI8MqRtHUguSC4qT0
	IiO94sTc4tK8dL3k/NxNjMBYOf3vWd8OxpsHrA8xCnAwKvHwOryNDxFiTSwrrsw9xGgKtGEi
	s5Rocj4wIvNK4g2NzYwsTE1MjY3MLc2UxHkTpH4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amBczuvkmMPIyPTI48ctvVsuce9n7bQNXmb6Q+LIn6ItHdaWbHsKY35Eq34rZXT/JDajw2BC
	/t9bxmzMO7QnLs/eocF/f2p8rcuvNOXHh+e8fXjoZN11ASaGll7px2GG/tF9jR3Od580J81w
	dq2NU1yaa8GdnPFult/JwLZ1f6bJaxtUFdXLHFRiKc5INNRiLipOBACBx2XWkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAV3R9IQQg1Pr+CxOf9rGbnH9y3NW
	i/lHzrFa9L9ZyGrxZ0Irm8W5VysZLSbdn8BicXnXHDaLz71HGC2WXr/IZDFh+loWi9a9R9gt
	Zkx+yebA67Fm3hpGj8t9vUweK5d/YfPYtKqTzaNvyypGj8+b5ALYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYwZuy7v4it4LRaxfbOuAbGPfJdjJwcEgImEpteP2aBsMUk
	Ltxbz9bFyMUhJLCIUeL/mWWsEE4bk8TnS5eZQKrYBDQl3k+5AtYhIhAhcXbZLBaQImaBY0wS
	F58sZAdJCAtESVzffwYowcHBIqAqcXK5KkiYV8BNYv+cA4wgYQkBBYk5k2xAwpwC7hK3Z+5g
	A7GFgEquzvzJNoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Eh8Jr2DcVWDxSFG
	AQ5GJR5eh7fxIUKsiWXFlbmHGCU4mJVEeGv/A4V4UxIrq1KL8uOLSnNSiw8xmgLdNJFZSjQ5
	H5gk8kriDY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MEqdFm+90/pz
	cYjId8kE10l7Zknen9cova/dvuli/T3NAL2ikNOFT1YpcM8vllmUVCCy5qv6k9ePVXeKcjbn
	Hhf76PhrxtTldaoW7G4/G3P3l817daR9usqiR6Ur9/R2d10OZW2TLFPe3JGx2NG5fqLdd4nL
	R3K+fJ1423vTZwGzTyUtNxyt25VYijMSDbWYi4oTAblQg1baAgAA
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
Changes in v2:
- Revise binding documentation.
---
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

