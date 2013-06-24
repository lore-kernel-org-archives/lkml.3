Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3GCLcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:32:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35997 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3GCLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:32:31 -0400
X-AuditID: cbfee68e-b7f276d000002279-98-51d40bce8e82
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar01@gmail.com, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 3/4] mfd: s2mps11: Add device tree support
Date: Mon, 24 Jun 2013 16:50:57 +0530
Message-id: <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSp3uO+0qgwa3r2hZTHz5hszjwZwej
	xbcrHUwWl3fNYbM4vOIAk8XpblaLiyu+MFnM/d3IajFn+jsmB06PBZ+vsHvsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZW+98ZCqYrVhxZ/UdlgbGy1Jd
	jJwcEgImEus3PGCDsMUkLtxbD2RzcQgJLGWUOH3wJTNM0fO5U6AS0xklVs59zAThtDFJfNz3
	HaiKg4NNwEji1TE7kAYRAQWJzb3PWEFqmAUuMUpM23uEFSQhLGAlcebta7B1LAKqEp+/vGAB
	6eUVcJF4+CcAYpmCROuyQ+wgNqeAq0Trywtg44WASpo/soCMlBDYxS7x7dhZdogxAhLfJh8C
	GyMhICux6QDUzZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmAknP73
	rG8H480D1ocYk4HGTWSWEk3OB0ZSXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoY415yadwwK7ono8JivXSTyhSpnL+SPdonSlPqNPgvLONia8xl
	eRvy7qOoVc6eqX09ZeLtl486z9onVCzhoLLa2D44e7HUxg+xv16/T2O1mq5u8PnmrQPXDq3t
	DvMW/RuxLTfmxoNrmxPkbd88nhp/w+pB8bqdq3QsGW4rfbO3WPzviHuupXmTEktxRqKhFnNR
	cSIA3fNTeJoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd1z3FcCDRofKVpMffiEzeLAnx2M
	Ft+udDBZXN41h83i8IoDTBanu1ktLq74wmQx93cjq8Wc6e+YHDg9Fny+wu6xc9Zddo9NqzrZ
	PO5c28PmMe9koEffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzNh65yNTwWzFijur77A0MF6W6mLk5JAQMJF4PncKG4QtJnHh3nogm4tDSGA6o8TKuY+Z
	IJw2JomP+74zdzFycLAJGEm8OmYH0iAioCCxufcZK0gNs8AlRolpe4+wgiSEBawkzrx9DTaV
	RUBV4vOXFywgvbwCLhIP/wRALFOQaF12iB3E5hRwlWh9eQFsvBBQSfNHlgmMvAsYGVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBMfZM+kdjKsaLA4xCnAwKvHwOjy7FCjEmlhWXJl7iFGC
	g1lJhHfin8uBQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPTAF5JfGGxibmpsamliYWJmaW
	pAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDoG/V6bchaDq2I2z8DVLcmKig+ZLRRkNjv
	qpi++G7Nku5Xi864eGxuejR1v8Dx/zPPnJzi2OWkJtdwaJ+Ay+rHC3eaSh7Zb7uZYdvHdV9P
	JLRd2/bwCRPb87SzXF7/NlS6s8qITMi+XOA6f+7+7XdSOyWkXYqyJqlwlyvLFURPTRNZIWTt
	r6mmxFKckWioxVxUnAgAwkyUpvcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT compatible string for s2mps11 and binding documentation.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |   98 +++++++++++++++++++++
 drivers/mfd/sec-core.c                            |    3 +
 2 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
new file mode 100644
index 0000000..7984625
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -0,0 +1,98 @@
+
+* Samsung S2MPS11 Voltage and Current Regulator
+
+The Samsung S2MP211 is a multi-function device which includes volatage and
+current regulators, rtc, charger controller and other sub-blocks. It is
+interfaced to the host controller using a i2c interface. Each sub-block is
+addressed by the host system using different i2c slave address.
+
+Required properties:
+- compatible: Should be "samsung,s2mps11-pmic".
+- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
+
+Optional properties:
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from s2mps11 are delivered to.
+- interrupts: Interrupt specifiers for interrupt sources.
+
+Optional nodes:
+- regulators: The regulators of s2mps11 that have to be instantiated should be
+included in a sub-node named 'regulators'. Regulator nodes included in this
+sub-node should be of the format as listed below.
+
+	regulator_name {
+		[standard regulator constraints....];
+		[regulator-ramp-disable];
+	};
+
+ regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
+
+ Optional property for BUCK[2/3/4/6] only:
+ regulator-ramp-disable: boolean, disables ramp delay on hardware.
+
+NOTE: Some BUCKs shares the ramp rate setting i.e. same ramp value will be set
+for a particular group of BUCKs. So provide same regulator-ramp-delay<value>.
+Grouping of BUCKs sharing ramp rate setting is as follow : BUCK[1, 6],
+BUCK[3, 4], and BUCK[7, 8, 10]
+
+The regulator constraints inside the regulator nodes use the standard regulator
+bindings which are documented elsewhere.
+
+The following are the names of the regulators that the s2mps11 pmic block
+supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
+as per the datasheet of s2mps11.
+
+	- LDOn
+		  - valid values for n are 1 to 28
+		  - Example: LDO0, LD01, LDO28
+	- BUCKn
+		  - valid values for n are 1 to 9.
+		  - Example: BUCK1, BUCK2, BUCK9
+
+Example:
+
+	s2mps11_pmic@66 {
+		compatible = "samsung,s2mps11-pmic";
+		reg = <0x66>;
+
+		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "VDD_ABB_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "VDD_ALIVE_1.1V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck2_reg: BUCK2 {
+				regulator-name = "vdd_arm";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <50000>;
+			};
+
+			buck3_reg: BUCK3 {
+				regulator-name = "vdd_xxx";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-disable;
+			};
+		};
+	};
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 77ee26e..760da8a 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -66,6 +66,9 @@ static struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
 		.data = (void *)S5M8767X,
 	},
+	{	.compatible = "samsung,s2mps11-pmic",
+		.data = (void *)S2MPS11X,
+	},
 	{},
 };
 #endif
-- 
1.7.0.4

