Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbbAFFp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:45:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22701 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbAFFp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:45:26 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f4-54ab766f8094
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND 3/3] Documentation: Add documentation for rt5033
 multifunction device
Date: Tue, 06 Jan 2015 14:45:17 +0900
Message-id: <1420523117-6814-4-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420523117-6814-1-git-send-email-beomho.seo@samsung.com>
References: <1420523117-6814-1-git-send-email-beomho.seo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkQDe/bHWIQcthU4vTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq0X/m4WsFuderWS0mHR/AovF+z1nGC3ufz3KaHF51xw2i8+9Rxgt
	ll6/yGQxYfpaFovWvUfYLU7vLrGYMfklm4Ogx5p5axg9Lvf1MnnsnHWX3WPl8i9sHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKK4bFJSczLLUov07RK4Mq73t7AWdKhXHH75gamB8at8FyMnh4SA
	icS1iz2MELaYxIV769m6GLk4hASWMkpM3/qFFabo9NKf7BCJ6UCJOT1MEE4bk8TGhkUsIFVs
	ApoS76dcAbNFBCIkzi6bxQJSxCxwg0li29XX7CAJYYE4iZaFT5hAbBYBVYntVy6DxXkFXCVa
	Px8AuoMDaJ2CxJxJNiBhTgE3iYlrNoGdJwRU8vL4OmaQmRICf9klZr9fzAoxR0Di2+RDLBC9
	shKbDjBDXC0pcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgRG2ul/zybu
	YLx/wPoQowAHoxIPr8eJlSFCrIllxZW5hxhNgTZMZJYSTc4HxnNeSbyhsZmRhamJqbGRuaWZ
	kjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MLKGspY/s7Sre9Ov3m88P9j+V0xEd
	URvs9pcxYPMP85j1Tkf+6kVqv8otfr7t/gHhxTY87Nou619kB3jvtrmmIpKxLkosULboqPHG
	uOZJ6nemhczb9P/Sx1s/Gz3ubFERb5nYdckt8atpaHxM0sWyaJZXV35wTDF38eIV0Pm5yd1q
	z4XZXnOUWIozEg21mIuKEwHO1C6XrwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd38stUhBh3HdSxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBb9bxayWpx7tZLRYtL9CSwW7/ecYbS4//Uoo8XlXXPYLD73HmG0
	WHr9IpPFhOlrWSxa9x5htzi9u8RixuSXbA6CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxa1cnm
	cefaHjaPvi2rGD0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx
	vb+FtaBDveLwyw9MDYxf5bsYOTkkBEwkTi/9yQ5hi0lcuLeerYuRi0NIYDqjxPQ5PUwQThuT
	xMaGRSwgVWwCmhLvp1wBs0UEIiTOLpvFAlLELHCDSWLb1ddgo4QF4iRaFj5hArFZBFQltl+5
	DBbnFXCVaP18gLGLkQNonYLEnEk2IGFOATeJiWs2MYLYQkAlL4+vY57AyLuAkWEVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnAcP5PewbiqweIQowAHoxIPr8eJlSFCrIllxZW5hxglOJiV
	RHh3fF4VIsSbklhZlVqUH19UmpNafIjRFOioicxSosn5wBSTVxJvaGxiZmRpZG5oYWRsriTO
	q2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAuNVPoP2/j320p+efhiVTT56/4sXlnvd5uXW/5sxD
	TVw6C1a+l9vfpPCL06tMML+ojbE5tKDz23vDrD//8jacDn5pw6N3d/v2lnNH7G4fvWy9dl/t
	ooysxwmVlXbmVrt++ETPls45mcc4raHWb/p/M+tbLKoepkKBJcyBXSt596SbWt6RaM9WYinO
	SDTUYi4qTgQAp32Y9fkCAAA=
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

