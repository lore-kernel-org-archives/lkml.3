Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaKRN33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:29:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21646 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaKRN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:29:22 -0500
X-AuditID: cbfee68d-f79296d000004278-9f-546b49b0b1ab
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
Subject: [PATCH v4 4/4] Documentation: Add documentation for rt5033
 multifunction device
Date: Tue, 18 Nov 2014 22:29:17 +0900
Message-id: <1416317357-7538-5-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416317357-7538-1-git-send-email-beomho.seo@samsung.com>
References: <1416317357-7538-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkSHeDZ3aIwf+3EhanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	+PzgEWvBV7WKvY86GBsYb8l3MXJySAiYSHyfdosJwhaTuHBvPVsXIxeHkMBSRomTv0+ywxSd
	2XedGSIxnVHi5q137BBOG5PEoeYPjCBVbAKaEu+nXGEBsUUEIiTOLpvFAlLELDCJWeLm2x6w
	ImGBKIn5Zx+CjWURUJVYeqAFzOYVcJVo3vMLqIEDaJ2CxJxJNiBhTgE3idN3/zKD2EJAJf/3
	T2IEmSkhMJND4mL7cUaIOQIS3yYfguqVldh0gBniakmJgytusExgFF7AyLCKUTS1ILmgOCm9
	yFCvODG3uDQvXS85P3cTIzAqT/971ruD8fYB60OMAhyMSjy8CVOzQoRYE8uKK3MPMZoCbZjI
	LCWanA+M/bySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghgn/HCbb9ssdIfN6EXrIklbB853W40UNDbdbveJ2WEkK3xTds3p9/f6Js36+Khre8rtH2H/
	Trh33O16W76J746f8Lzbx61OFtfv/bRt9cqgG9x33ESjDk99y3+k317ukDznTMdgxTm37unL
	zND7IP1R6JiwrdyZKpuMi4khW7oCSqSPeC51kc5XYinOSDTUYi4qTgQA8XtGJMUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd0NntkhBi+v8Fmc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY8bnB49YC76qVex91MHYwHhLvouRk0NCwETizL7rzBC2
	mMSFe+vZuhi5OIQEpjNK3Lz1jh3CaWOSONT8gRGkik1AU+L9lCssILaIQITE2WWzWECKmAUm
	MUvcfNsDViQsECUx/+xDdhCbRUBVYumBFjCbV8BVonnPL6AGDqB1ChJzJtmAhDkF3CRO3/0L
	doUQUMn//ZMYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPPPpHYwrmywOMQo
	wMGoxMObMDUrRIg1say4MvcQowQHs5II77luoBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbn
	A9NRXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTilgXHII+1VLbTlY
	aDvz39V77HuDWtg91wiviyyPcnzrUrKsX5v55s09pj0swc4ySm8+d8ZtkrLfHM/waidLxrmN
	qSd+ZX/ll/qu5GLJvyTnE5vNYucjkWtZj7FsOi9ckfP1Q6h1+cIZ4RI277aGlXhdm5l8+5vC
	And/16fGlxN6RJ7yfdxlZPJBiaU4I9FQi7moOBEAhhY90Q8DAAA=
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
Changes in v4:
Changes in v3:
- none.

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

