Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaKSEx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:53:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16513 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaKSEwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:52:47 -0500
X-AuditID: cbfee691-f79b86d000004a5a-38-546c221cfce9
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
Subject: [PATCH v5 4/4] Documentation: Add documentation for rt5033
 multifunction device
Date: Wed, 19 Nov 2014 13:52:40 +0900
Message-id: <1416372760-2090-5-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416372760-2090-1-git-send-email-beomho.seo@samsung.com>
References: <1416372760-2090-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkSFdGKSfEYOMLY4vTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq8XElZOZLfrfLGS1+DOhlc3i3KuVjBaT7k9gsXi/5wyjxbcrHUwW
	l3fNYbP43HuE0WLp9YtMFhOmr2WxaN17hN3idDerxendJRYzJr9kcxDxWDNvDaPH5b5eJo+d
	s+6ye6xc/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwRXHZpKTmZJalFunbJXBl
	TJn2m7GgTb3iw5cVrA2Mz+S7GDk5JARMJF5cmsUMYYtJXLi3nq2LkYtDSGApo8SFrmeMMEUL
	nnQzQiSmM0pMvf2dGcJpY5LYfamTFaSKTUBT4v2UKywgtohAhMTZZbNYQIqYBSYxS9x82wM2
	SlggSuLLtM9g+1gEVCUunFwEZvMKuEo8v/oAaDcH0DoFiTmTbEDCnAJuEt8b7jCDhIWASnav
	ZQUZKSEwk0Ni0cyLTBBjBCS+TT7EAtEqK7HpANQ3khIHV9xgmcAovICRYRWjaGpBckFxUnqR
	qV5xYm5xaV66XnJ+7iZGYEye/vds4g7G+wesDzEKcDAq8fC+fJsdIsSaWFZcmXuI0RRow0Rm
	KdHkfGDk55XEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wGiW6jaz9+qxhftFtDZIr1n8YNfSO+91olK8bzfzXv8t73qscObqfFFNY5HCMwfEeaepHD+5
	glnk+iMV/XtC53L388en7uWfu9HqXb4/T0BWx1bnQ3fzvH6nCGn4rmkuyt9gNm+J3u1dCleV
	sq/f7M+fIrmxRcki6lJ48RuPydY9vgc+3ZlpOV2JpTgj0VCLuag4EQCQK4mJxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV0ZpZwQg8MnNS1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFdXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9J2SQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMWPKtN+MBW3qFR++rGBtYHwm38XIySEhYCKx4Ek3I4Qt
	JnHh3nq2LkYuDiGB6YwSU29/Z4Zw2pgkdl/qZAWpYhPQlHg/5QoLiC0iECFxdtksFpAiZoFJ
	zBI33/aAjRIWiJL4Mu0zM4jNIqAqceHkIjCbV8BV4vnVB0ArOIDWKUjMmWQDEuYUcJP43nCH
	GSQsBFSyey3rBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/6Z1A7GlQ0WhxgF
	OBiVeHhfvM0OEWJNLCuuzD3EKMHBrCTCK9gNFOJNSaysSi3Kjy8qzUktPsRoCnTTRGYp0eR8
	YDLKK4k3NDYxM7I0Mje0MDI2VxLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuOjUgbWWzDsW
	811ZdMMsUznkTP0a65aW2KO8hzadO5S2yJC/xX0Ds/abpkbL8Gc5BYt/PO378am+89b5XVLL
	XXQmLWK8raj9V9OkzvrU93Z/jsRWeY/7/Vdqf2g2JZxz+SXSM9lxorW6LfuVDDE5id8PV23s
	eG0mf1eU6bULY6332+/n1076rMRSnJFoqMVcVJwIAOOhcGMOAwAA
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
Changes in v5:
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

