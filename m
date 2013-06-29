Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3GHNAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:00:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64434 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3GHNAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:00:02 -0400
X-AuditID: cbfee68e-b7f276d000002279-13-51dab7d16c29
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 6/6] mfd: s2mps11: Add device tree support
Date: Sat, 29 Jun 2013 18:21:20 +0530
Message-id: <1372510280-31931-7-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSrXtx+61Ag8sHRC2mPnzCZnHgzw5G
	i29XOpgsLu+aw2ZxeMUBJouTf3oZLU53s1pcXPGFyWLu70ZWiznT3zE5cHks+HyF3WPnrLvs
	HptWdbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mq4tq6duaBBoaLt3WSm
	BsZ7kl2MnBwSAiYSh78eZYawxSQu3FvP1sXIxSEksJRR4vvTy8wwRcf2PWKESCxilGjb+JcJ
	wmljkrj4dTZ7FyMHB5uAkcSrY3YgDSICChKbe5+xgtQwC7xllFi69AYLSEJYwFZi0drVjCA2
	i4CqxLn+Z2A2r4CrxMsHj9ghtilItC47BGZzCrhJdE2+zgRiCwHVfNzTDrZYQuAQu0TH9s/M
	EIMEJL5NPsQCcoSEgKzEpgNQV0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ
	+bmbGIFxcfrfs74djDcPWB9iTAYaN5FZSjQ5HxhXeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgXHnV/5vF50uFZ4RsWO5Xznzz69Shz+pbzQS3
	7GSXl2E7bvFxBrfCZ/fYiJ7WjfwCnlHqPF5vm+qE514ufqZttuXOkUOqS326es71aLBe/CBR
	f2zn3mc/k55fU23asOB0xzfmx/krfM0KX16vLc8xD+Y3vnXioYxzY7KPQFTDcuOzHyfazHNd
	rsRSnJFoqMVcVJwIABgSyyWhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd2L228FGpzpY7SY+vAJm8WBPzsY
	Lb5d6WCyuLxrDpvF4RUHmCxO/ulltDjdzWpxccUXJou5vxtZLeZMf8fkwOWx4PMVdo+ds+6y
	e2xa1cnmcefaHjaPeScDPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxrV17cwFDQoVbe8mMzUw3pPsYuTkkBAwkTi27xEjhC0mceHeerYuRi4OIYFF
	jBJtG/8yQThtTBIXv85m72Lk4GATMJJ4dcwOpEFEQEFic+8zVpAaZoG3jBJLl95gAUkIC9hK
	LFq7Gmwqi4CqxLn+Z2A2r4CrxMsHj9ghtilItC47BGZzCrhJdE2+zgRiCwHVfNzTzjSBkXcB
	I8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCoeya1g3Flg8UhRgEORiUeXonTNwOFWBPL
	iitzDzFKcDArifCKs94KFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YELIK4k3NDYxNzU2
	tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZG5bYVZ96X2/6PabHcdWJb1cp+
	dknVo5fihGx3MxwxWCDSeSytxt6H+dAyUU0Rq/WrT78pb//xZ3r39eBvZ401rtfw7n+WdU/g
	T9/UXrXwYvusbQt3zv156dnDMon3cy2nuPuvK08vup37vdjYT8hnkk1mcerUu8qCu/l8V3Hn
	cAV8TNme2L1diaU4I9FQi7moOBEAvxzZc/4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT compatible string for s2mps11 and binding documentation.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |   89 +++++++++++++++++++++
 drivers/mfd/sec-core.c                            |    3 +
 2 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
new file mode 100644
index 0000000..36269c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -0,0 +1,89 @@
+
+* Samsung S2MPS11 Voltage and Current Regulator
+
+The Samsung S2MP211 is a multi-function device which includes voltage and
+current regulators, RTC, charger controller and other sub-blocks. It is
+interfaced to the host controller using a I2C interface. Each sub-block is
+addressed by the host system using different I2C slave address.
+
+Required properties:
+- compatible: Should be "samsung,s2mps11-pmic".
+- reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
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
+	};
+
+ regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
+
+ BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
+ regulator-ramp-delay = <0> can be used for them to disable ramp delay.
+ In absence of regulator-ramp-delay property, default ramp delay will be used.
+
+NOTE: Some BUCKs share the ramp rate setting i.e. same ramp value will be set
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

