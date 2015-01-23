Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbbAWFDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:03:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11832 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbAWFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:05 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-b7-54c1d6067b3c
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 6/6] Documentation: Add device tree bindings document for
 max77843
Date: Fri, 23 Jan 2015 14:02:47 +0900
Message-id: <1421989367-32721-7-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSoMt27WCIwaNXChanP21jt5j68Amb
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLSbdn8BisaPhCKvF/a9HGS0u75rDZvG59wijxdLrF5ks
	Jkxfy2LRuvcIu8Xp3SUO/B5r5q1h9Ljc18vksXL5FzaPTas62TzuXNvD5tG3ZRWjx+dNcgHs
	UVw2Kak5mWWpRfp2CVwZj463shecka34MnM5SwPjZIkuRk4OCQETicsNXxghbDGJC/fWs3Ux
	cnEICSxllFh47QE7TNGCx9fYIRLTGSXmTWpngXDamCQ6PiwEq2IT0Jb4vn4xK4gtIhAh8fzj
	SmaQImaBg8wSHRdPgxUJC4RIzL09jQ3EZhFQlfi77QZYnFfAQ+LT8yNAUzmA1ilIzJlkAxLm
	FPCUeLfnBVi5EFDJ6gknwRZLCDxil/h3cj8LxBwBiW+TD0H1ykpsOsAMcbWkxMEVN1gmMAov
	YGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYS6f/PZuwg/HeAetDjAIcjEo8vA1bDoYI
	sSaWFVfmHmI0BdowkVlKNDkfGLF5JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgFPxwt+WgW0uo3Cw/sf9Tz0tNadqRqXf5ysvC/wrvAla6SmRedFzW
	E6yjErxPfEKQ0SbLmdvVbnx5lZtZ0bTvQs8K1qwJP6fmZl024Ll+7c/Kl6c0hUx+9lSl3c5d
	yalzQ9L9c6JLX2/XVGMpjXrlFSWPddeFehkyxhaJTFn5pOogC1/tO4sWJZbijERDLeai4kQA
	IjTn9aACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jQV22awdDDH7dE7c4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWix0NR1gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj5XLv7B5bFrVyeZx59oeNo++LasYPT5vkgtg
	j2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlxJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPHoeCt7wRnZii8zl7M0ME6W
	6GLk5JAQMJFY8PgaO4QtJnHh3nq2LkYuDiGB6YwS8ya1s0A4bUwSHR8WglWxCWhLfF+/mBXE
	FhGIkHj+cSUzSBGzwEFmiY6Lp8GKhAVCJObensYGYrMIqEr83XYDLM4r4CHx6fkRoKkcQOsU
	JOZMsgEJcwp4Srzb8wKsXAioZPWEkywTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAiO1GfSOxhXNVgcYhTgYFTi4W3YcjBEiDWxrLgy9xCjBAezkgjvkwNAId6UxMqq1KL8+KLS
	nNTiQ4ymQEdNZJYSTc4HJpG8knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+
	Jg5OqQZGQatHWRfzw89udU8/nSEwq8/dwMucNS3xvfyO+Mz/W54uK5jM+EXpAPeTpNcnKnj4
	rKLv7fWYwfH569bX/5qc/qrOru2v+Bnw97rEy5c1DGtiOQy4vcNWzzJmdlJZ/zO7dGbw1yWf
	1e+IP3acf6ra+7OYx7q7b/fbPOt8zrC5sDXn5t6lWRbySizFGYmGWsxFxYkAcGs5lOoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add document describing device tree bindings for max77843 MFD.
Drivers: MFD core, regulator, extcon, charger and fuelgauge.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77843.txt |   87 ++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77843.txt

diff --git a/Documentation/devicetree/bindings/mfd/max77843.txt b/Documentation/devicetree/bindings/mfd/max77843.txt
new file mode 100644
index 0000000..6895604
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max77843.txt
@@ -0,0 +1,87 @@
+Maxim MAX77843 multi-function device
+
+MAX77843 is a Multi-Function Device with the following submodules:
+- PMIC	  : 2 SAFEOUT LDOs for USB device
+- CHARGER : Li+ battery charger with Fuel Gauge
+- MUIC	  : Micro USB Interface Circuit
+- HAPTIC  : motor control driver for haptics
+- LED	  : 4 channel RGBW LED
+
+It is interfaced to host controller using I2C.
+
+Required properties:
+- compatible : Must be "maxim,max77843".
+- reg : I2C slave address of PMIC block.
+- interrupts : I2C line for main SoCs.
+- interrupt-parent : The parent of interrupt controller.
+
+Optional properties:
+- regulators : The regulators of max77843 have to be instantiated under subnode
+	named "regulators" using the following format.
+
+	[*]refer : Documentation/devicetree/bindings/regulator/regulator.txt
+
+	regulators {
+		SAFEOUT {
+			regulator-name = "SAFEOUT";
+		};
+	}
+
+	List of valid regulator names:
+	- SAFEOUT1, SAFEOUT2, CHARGER.
+
+- max77843-muic : This properties used by extcon consumers.
+	Required properties:
+		- compatible : Must be "maxim,max77842-muic".
+
+- max77843-charger : There battery charger of MAX77843 have to be instantiated
+	under sub-node named "max77843-charger" using the following format.
+	Required properties:
+		- compatible : Must be "maxim,max77842-charger".
+		- maxim,fast-charge-uamp : Fast charge current levels are
+			100 mA to 3150 mA programmed by I2C per 100 mA.
+		- maxim,top-off-uamp : Top off current threshold levels are
+			125 mA to 650 mA programmed by I2C per 75 mA.
+		- maxim,input-uamp-limit : Input current limit levels are
+			100 mA to 3533 mA programmed by I2C per 33 mA.
+- max77843-fuelgauge : There fuelgauge of MAX77843 have to be instantiated
+	under sub-node named "max77843-fuelgauge" using the following format.
+	Required properties:
+		- compatible : Must be "maxim,max77842-fuelgauge".
+
+Example:
+	max77843@66 {
+		compatible = "samsung,max77843";
+		reg = <0x66>;
+		interrupt-parent = <&gpa1>;
+		interrupts = <5 2>;
+
+		regulators {
+			SAFEOUT1 {
+				regulator-name = "SAFEOUT1";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <4950000>;
+			};
+			SAFEOUT2 {
+				regulator-name = "SAFEOUT2";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <4950000>;
+			};
+		};
+
+		max77843-muic {
+			compatible = "maxim,max77843-muic";
+		};
+
+		max77843-charger {
+			compatible = "maxim,max77843-charger";
+			maxim,fast-charge-uamp = <450000>;
+			maxim,top-off-uamp = <125000>;
+			maxim,input-uamp-limit = <500000>;
+		};
+
+		max77843-fuelgauge {
+			compatible = "maxim,max77843-fuelgauge";
+		};
+
+	};
-- 
1.7.9.5

