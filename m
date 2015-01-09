Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbbAIIqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:46:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34440 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbbAIIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:45:21 -0500
X-AuditID: cbfee68d-f79296d000004278-aa-54af951c203a
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 3/3] Documentation: Add documentation for rt5033
 multifunction device
Date: Fri, 09 Jan 2015 17:45:13 +0900
Message-id: <1420793114-20586-4-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkWFdm6voQg9m7LCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4//Uoo8XlXXPYLD73HmG0
	WHr9IpPFhOlrWSxa9x5htzi9u8RixuSXbA6CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxa1cnm
	cefaHjaPvi2rGD0+b5IL4IjisklJzcksSy3St0vgynj08C1LwUz1ipUXmpgbGCcqdDFyckgI
	mEg8eLuFDcIWk7hwbz2QzcUhJLCUUeLQ8aWMMEUbzh1ghUgsYpR4evI8WEJIoI1Jom2uJ4jN
	JqAp8X7KFRYQW0QgQ2J7xxRmEJtZ4ASTxKY30iC2sECUxIc/38HiLAKqEj/eT2QFsXkF3CQ6
	zkwC2swBtExBYs4kG5Awp4C7xMstE1ghVrlJbNlwjhXinr/sEt0rqiDGCEh8m3yIBaJVVmLT
	AWaIEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzDGTv971ruD8fYB
	60OMAhyMSjy8G+TWhwixJpYVV+YeYjQF2jCRWUo0OR8YyXkl8YbGZkYWpiamxkbmlmZK4ryK
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB62CaFXNyzfXGt476lj/76iZ4zYk4JETvc
	ILRWL3rSr/ucSm0Mle9XPEqb1h3yS6C/tG4t32yXHk23s1/U+Wv4Yk+uDVYrjUkPlzu8eN3X
	PLHkiue9rSZmnJlG+h0W7ZNk5COk8r7mRn4+fGN9Ss2LuGwbtevrLA3iUtmVY532Pg+tPmql
	pMRSnJFoqMVcVJwIALlpQY+sAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAV2ZqetDDM5O1Lc4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVr0v1nIanHu1UpGi0n3J7BYvN9zhtHi/tejjBaXd81hs/jce4TR
	Yun1i0wWE6avZbFo3XuE3eL07hKLGZNfsjkIeqyZt4bR43JfL5PHzll32T1WLv/C5rFpVSeb
	x51re9g8+rasYvT4vEkugCOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+gPJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG
	o4dvWQpmqlesvNDE3MA4UaGLkZNDQsBEYsO5A6wQtpjEhXvr2boYuTiEBBYxSjw9eZ4RJCEk
	0MYk0TbXE8RmE9CUeD/lCguILSKQIbG9YwoziM0scIJJYtMbaRBbWCBK4sOf72BxFgFViR/v
	J4It4BVwk+g4MwloAQfQMgWJOZNsQMKcAu4SL7dMYIVY5SaxZcM51gmMvAsYGVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBMfwM+kdjKsaLA4xCnAwKvHwbpBbHyLEmlhWXJl7iFGCg1lJ
	hPfQBKAQb0piZVVqUX58UWlOavEhRlOgoyYyS4km5wPTS15JvKGxiZmRpZG5oYWRsbmSOK+S
	fVuIkEB6YklqdmpqQWoRTB8TB6dUA2M4v/6ZPLGXtf9//DEqe1t/e4JBpHfmMraiqZqVdqvq
	ark23RGt4f+9ZJ2/cH5izpQXsfIX/865fVZO+uTk56t53ttLZD3+9mXHrcBXxR3aFhk8927+
	VJntNFd916WFgt8Z5jxIXNKr7ZVmsNjQ+Bgbm3HvSuPgzXXzZj7d+I7DZcNvl9clKV5KLMUZ
	iYZazEXFiQB+mSsg9wIAAA==
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
---
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

