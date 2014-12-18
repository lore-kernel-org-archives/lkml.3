Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaLRNP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:15:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40876 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaLRNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:15:51 -0500
X-AuditID: cbfee68d-f79296d000004278-59-5492d38575ca
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 3/3] Documentation: Add documentation for rt5033 multifunction
 device
Date: Thu, 18 Dec 2014 22:15:47 +0900
Message-id: <1418908547-10241-4-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418908547-10241-1-git-send-email-beomho.seo@samsung.com>
References: <1418908547-10241-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkRLf18qQQg3nPpCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4tyrlYwWk+5PYLF4v+cMo8W3Kx1MFpd3zWGz
	+Nx7hNFi6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUWMya/ZHMQ9lgzbw2jx+W+XiaPnbPusnus
	XP6FzWPzCi2PTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFcEVx2aSk5mSWpRbp2yVwZVx5cY65
	YKpaxZVDf9kbGCfKdzFyckgImEhsWDeDDcIWk7hwbz2QzcUhJLCUUWJhy0VGmKLdB64zQiQW
	MUos6j/PDuG0MUnsOXKAFaSKTUBT4v2UKywgtohAhMTZZbPAbGaBn0wSNy9ldzFycAgLhEs8
	/2EBEmYRUJXYdqYZrIRXwE1i+tsLrCAlEgIKEnMm2YCEOQXcJa5/PMEOYgsBlSx4dI0ZZK2E
	wFQOiX/3HzBCzBGQ+Db5EAtEr6zEpgPMEDdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJ
	ucWleel6yfm5mxiBcXj637PeHYy3D1gfYhTgYFTi4ZXUmxQixJpYVlyZe4jRFGjDRGYp0eR8
	YLTnlcQbGpsZWZiamBobmVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqK60
	waVgiW3xev2Vdn4PpSeK+RwJfxNYaCKxeVFQLGPSzrvtvVvZ2VOnJTBHR91f+cqDjfeo1qlz
	6stu7yrq+Pu1cefp2jXsl1t+JP66/SjnhlfI+S0M3z5373nLbeT3TjpRIDyYia9d8n7SLkuH
	hZY/5wZzvbbUZXgoH+8sVnrS5NK3AL6/SizFGYmGWsxFxYkArrwW4L4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd3Wy5NCDJ7NF7Q4/Wkbu8XUh0/Y
	LK5/ec5qMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJaTLo/gcXi/Z4zjBbfrnQwWVzeNYfN
	4nPvEUaLpdcvMllMmL6WxaJ17xF2i9PdrBand5dYzJj8ks1B2GPNvDWMHpf7epk8ds66y+6x
	cvkXNo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SYkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjHjyotzzAVT1SquHPrL3sA4Ub6LkZNDQsBEYveB64wQtpjEhXvr
	2boYuTiEBBYxSizqP88O4bQxSew5coAVpIpNQFPi/ZQrLCC2iECExNlls8BsZoGfTBI3L2V3
	MXJwCAuESzz/YQESZhFQldh2phmshFfATWL62wusICUSAgoScybZgIQ5Bdwlrn88wQ5iCwGV
	LHh0jXkCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR/kxqB+PKBotDjAIcjEo8
	vBJ6k0KEWBPLiitzDzFKcDArifBG5wCFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YgPJK
	4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhgV/i3SLNU8zZPhGPl7
	1/GW4tK0ZuWUaXm/vXkONvw41sqW9Lm1/9KFK7Y8xuoPJ01lCj/sZVW+VYbv+YWerKVnb/xz
	4DuoJvdCduW5eIP78ku2WOga2p9iSdH+/HDzhV8qUXwnlV/N7FbLb076+GFRzmblaXUn63I0
	2lM5WUTW9fv9z8iOi1JiKc5INNRiLipOBAClCU6JCAMAAA==
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

