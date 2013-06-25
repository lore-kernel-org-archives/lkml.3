Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3FYBIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:08:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9604 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FYBIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:08:50 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-cd-51c8eda06c71
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        a.hajda@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2] regulator: max77693: Add max77693 regualtor driver.
Date: Tue, 25 Jun 2013 10:08:38 +0900
Message-id: <1372122518-6131-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkWHfB2xOBBvvbtCxurTvHajH14RM2
	i86zT5gtLu+aw2bxufcIo8XtxhVsDmwem1Z1snn0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJX
	xveTfewF28sqFsw8yNLA+Cehi5GTQ0LAROLB3avMELaYxIV769m6GLk4hASWMkocfruFsYuR
	A6yo95kcRHw6o0Tby32sEE4Lk8TD7m9g3WwCOhL/991kB7FFBJQlrn7fywJiMwssYZSY+8wP
	xBYWcJeYOfUCWJxFQFXiefMGNhCbFyj+7NFxqGUKEnMm2YDMlxB4zSbxdkoHG0S9gMS3yYdY
	IGpkJTYdgDpaUuLgihssExgFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIDMvT/571
	7mC8fcD6EGMy0LiJzFKiyfnAsM4riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA6N63I2js9vq6oIvHrvCEd0iOjdeQue0fbFDdIXygX4pI4nS7XbN
	LJo7NT0lpi/zUXn52mUJS+XGkqk3WxZZT04uWPMl8Pc3YQczTa3Lt8QSp/K/E/Te+nltzrcH
	Kx7N350kW3SgN2JV/rdrm/YVfH5U+88/4svFxnt/nBIFXrpf1tm/vPmA11ElluKMREMt5qLi
	RAD2rgZlYQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQd0Fb08EGixtkre4te4cq8XUh0/Y
	LDrPPmG2uLxrDpvF594jjBa3G1ewObB5bFrVyebRt2UVo8fnTXIBzFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBnfT/axF2wvq1gw8yBLA+OfhC5GDg4JAROJ3mdyXYyc
	QKaYxIV769m6GLk4hASmM0q0vdzHCuG0MEk87P7GDFLFJqAj8X/fTXYQW0RAWeLq970sIDaz
	wBJGibnP/EBsYQF3iZlTL4DFWQRUJZ43b2ADsXmB4s8eHWeEWKwgMWeSzQRG7gWMDKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxgoP+mdQOxpUNFocYBTgYlXh4I3edCBRiTSwrrsw9xCjB
	wawkwhsqAhTiTUmsrEotyo8vKs1JLT7EmAy0fCKzlGhyPjAi80riDY1NzIwsjcwNLYyMzUkT
	VhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0WKDtbXslfUfDAw8UngdzbNneqX/5j217oOt
	zLxDartEd+s48z9mn/qeo3Gxf5K43IXvV/beCbYJv5PH4KHxSE38pHTm/RlNZuevpRT5BBb9
	37v395vPL9b++bP38sJQhfftb2f7LDgrmzhjZ+58m48pVpfYS+fHu107UCxoM31OzLYE78T5
	r5RYijMSDbWYi4oTAfKoKz6+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new regulator driver to support max77693 chip's regulators.
max77693 has two linear voltage regulators and one current regulator which
can be controlled through I2C bus. This driver also supports device tree.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
chagnes in v2:
 - Add comments for charger regulator's operations.
 - Add a binding document under Documentation/devicetree/binding/mfd/

 Documentation/devicetree/bindings/mfd/max77693.txt |   55 ++++
 drivers/regulator/Kconfig                          |    9 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max77693.c                       |  324 ++++++++++++++++++++
 include/linux/mfd/max77693-private.h               |   13 +
 include/linux/mfd/max77693.h                       |   18 ++
 6 files changed, 420 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77693.txt
 create mode 100644 drivers/regulator/max77693.c

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
new file mode 100644
index 0000000..11921cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -0,0 +1,55 @@
+Maxim MAX77693 multi-function device
+
+MAX77693 is a Multifunction device with the following submodules:
+- PMIC,
+- CHARGER,
+- LED,
+- MUIC,
+- HAPTIC
+
+It is interfaced to host controller using i2c.
+This document describes the bindings for the mfd device.
+
+Required properties:
+- compatible : Must be "maxim,max77693".
+- reg : Specifies the i2c slave address of PMIC block.
+- interrupts : This i2c device has an IRQ line connected to the main SoC.
+- interrupt-parent :  The parent interrupt controller.
+
+Optional properties:
+- regulators : The regulators of max77693 have to be instantiated under subnod
+  named "regulators" using the following format.
+
+	regulators {
+		regualtor-compatible = ESAFEOUT1/ESAFEOUT2/CHARGER
+		standard regulator constratints[*].
+	};
+
+	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+Example:
+	max77693@66 {
+		compatible = "maxim,max77693";
+		reg = <0x66>;
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 2>;
+
+		regulators {
+			esafeout@1 {
+				regulator-compatible = "ESAFEOUT1";
+				regulator-name = "ESAFEOUT1";
+				regulator-boot-on;
+			};
+			esafeout@2 {
+				regulator-compatible = "ESAFEOUT2";
+				regulator-name = "ESAFEOUT2";
+				};
+			charger@0 {
+				regulator-compatible = "CHARGER";
+				regulator-name = "CHARGER";
+				regulator-min-microamp = <60000>;
+				regulator-max-microamp = <2580000>;
+					regulator-boot-on;
+			};
+		};
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9296425..f1e6ad9 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -250,6 +250,15 @@ config REGULATOR_MAX77686
 	  via I2C bus. The provided regulator is suitable for
 	  Exynos-4 chips to control VARM and VINT voltages.
 
+config REGULATOR_MAX77693
+	tristate "Maxim MAX77693 regulator"
+	depends on MFD_MAX77693
+	help
+	  This driver controls a Maxim 77693 regulator via I2C bus.
+	  The regulators include two LDOs, 'SAFEOUT1', 'SAFEOUT2'
+	  and one current regulator 'CHARGER'. This is suitable for
+	  Exynos-4x12 chips.
+
 config REGULATOR_PCAP
 	tristate "Motorola PCAP2 regulator driver"
 	depends on EZX_PCAP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 26e6c4a..ba4a3cf 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_REGULATOR_MAX8973) += max8973-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_MAX77686) += max77686.o
+obj-$(CONFIG_REGULATOR_MAX77693) += max77693.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
new file mode 100644
index 0000000..674ece7
--- /dev/null
+++ b/drivers/regulator/max77693.c
@@ -0,0 +1,324 @@
+/*
+ * max77693.c - Regulator driver for the Maxim 77693
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max77686.c
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/regulator/of_regulator.h>
+
+#define CHGIN_ILIM_STEP_20mA			20000
+
+struct max77693_pmic_dev {
+	struct device *dev;
+	struct max77693_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+};
+
+/* CHARGER regulator ops */
+/* CHARGER regulator uses two bits for enabling */
+static int max77693_chg_is_enabled(struct regulator_dev *rdev)
+{
+	int ret;
+	u8 val;
+
+	ret = max77693_read_reg(rdev->regmap, rdev->desc->enable_reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & rdev->desc->enable_mask) == rdev->desc->enable_mask;
+}
+
+/*
+ * CHARGER regulator - Min : 20mA, Max : 2580mA, step : 20mA
+ * 0x00, 0x01, 0x2, 0x03	= 60 mA
+ * 0x04 ~ 0x7E			= (60 + (X - 3) * 20) mA
+ */
+static int max77693_chg_get_current_limit(struct regulator_dev *rdev)
+{
+	unsigned int chg_min_uA = rdev->constraints->min_uA;
+	unsigned int chg_max_uA = rdev->constraints->max_uA;
+	u8 reg, sel;
+	unsigned int val;
+	int ret;
+
+	ret = max77693_read_reg(rdev->regmap,
+				MAX77693_CHG_REG_CHG_CNFG_09, &reg);
+	if (ret < 0)
+		return ret;
+
+	sel = reg & CHG_CNFG_09_CHGIN_ILIM_MASK;
+
+	/* the first four codes for charger current are all 60mA */
+	if (sel <= 3)
+		sel = 0;
+	else
+		sel -= 3;
+
+	val = chg_min_uA + CHGIN_ILIM_STEP_20mA * sel;
+	if (val > chg_max_uA)
+		return -EINVAL;
+
+	return val;
+}
+
+static int max77693_chg_set_current_limit(struct regulator_dev *rdev,
+						int min_uA, int max_uA)
+{
+	unsigned int chg_min_uA = rdev->constraints->min_uA;
+	int sel = 0;
+
+	while (chg_min_uA + CHGIN_ILIM_STEP_20mA * sel < min_uA)
+		sel++;
+
+	if (chg_min_uA * CHGIN_ILIM_STEP_20mA * sel > max_uA)
+		return -EINVAL;
+
+	/* the first four codes for charger current are all 60mA */
+	sel += 3;
+
+	return max77693_write_reg(rdev->regmap,
+				MAX77693_CHG_REG_CHG_CNFG_09, sel);
+}
+/* end of CHARGER regulator ops */
+
+static const unsigned int max77693_safeout_table[] = {
+	4850000,
+	4900000,
+	4950000,
+	3300000,
+};
+
+static struct regulator_ops max77693_safeout_ops = {
+	.list_voltage		= regulator_list_voltage_table,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+};
+
+static struct regulator_ops max77693_charger_ops = {
+	.is_enabled		= max77693_chg_is_enabled,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_current_limit	= max77693_chg_get_current_limit,
+	.set_current_limit	= max77693_chg_set_current_limit,
+};
+
+#define regulator_desc_esafeout(_num)	{			\
+	.name		= "ESAFEOUT"#_num,			\
+	.id		= MAX77693_ESAFEOUT##_num,		\
+	.n_voltages	= 4,					\
+	.ops		= &max77693_safeout_ops,		\
+	.type		= REGULATOR_VOLTAGE,			\
+	.volt_table	= max77693_safeout_table,		\
+	.vsel_reg	= MAX77693_CHG_REG_SAFEOUT_CTRL,	\
+	.vsel_mask	= SAFEOUT_CTRL_SAFEOUT##_num##_MASK,	\
+	.enable_reg	= MAX77693_CHG_REG_SAFEOUT_CTRL,	\
+	.enable_mask	= SAFEOUT_CTRL_ENSAFEOUT##_num##_MASK ,	\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_esafeout(1),
+	regulator_desc_esafeout(2),
+	{
+		.name = "CHARGER",
+		.id = MAX77693_CHARGER,
+		.ops = &max77693_charger_ops,
+		.type = REGULATOR_CURRENT,
+		.owner = THIS_MODULE,
+		.enable_reg = MAX77693_CHG_REG_CHG_CNFG_00,
+		.enable_mask = CHG_CNFG_00_CHG_MASK |
+				CHG_CNFG_00_BUCK_MASK,
+	},
+};
+
+#ifdef CONFIG_OF
+static int max77693_pmic_dt_parse_rdata(struct device *dev,
+					struct max77693_regulator_data **rdata)
+{
+	struct device_node *np;
+	struct of_regulator_match *rmatch;
+	struct max77693_regulator_data *tmp;
+	int i, matched = 0;
+
+	np = of_find_node_by_name(dev->parent->of_node, "regulators");
+	if (!np)
+		return -EINVAL;
+
+	rmatch = devm_kzalloc(dev,
+		 sizeof(*rmatch) * ARRAY_SIZE(regulators), GFP_KERNEL);
+	if (!rmatch)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(regulators); i++)
+		rmatch[i].name = regulators[i].name;
+
+	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(regulators));
+	if (matched <= 0)
+		return matched;
+	*rdata = devm_kzalloc(dev, sizeof(**rdata) * matched, GFP_KERNEL);
+	if (!(*rdata))
+		return -ENOMEM;
+
+	tmp = *rdata;
+
+	for (i = 0; i < ARRAY_SIZE(regulators); i++) {
+		if (!rmatch[i].init_data)
+			continue;
+		tmp->initdata = rmatch[i].init_data;
+		tmp->of_node = rmatch[i].of_node;
+		tmp->id = regulators[i].id;
+		tmp++;
+	}
+
+	return matched;
+}
+#else
+static int max77693_pmic_dt_parse_rdata(struct device *dev,
+					struct max77693_regulator_data **rdata)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
+static int max77693_pmic_init_rdata(struct device *dev,
+				    struct max77693_regulator_data **rdata)
+{
+	struct max77693_platform_data *pdata;
+	int num_regulators = 0;
+
+	pdata = dev_get_platdata(dev->parent);
+	if (pdata) {
+		*rdata = pdata->regulators;
+		num_regulators = pdata->num_regulators;
+	}
+
+	if (!(*rdata) && dev->parent->of_node)
+		num_regulators = max77693_pmic_dt_parse_rdata(dev, rdata);
+
+	return num_regulators;
+}
+
+static int max77693_pmic_probe(struct platform_device *pdev)
+{
+	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77693_pmic_dev *max77693_pmic;
+	struct max77693_regulator_data *rdata = NULL;
+	int num_rdata, i, ret;
+	struct regulator_config config;
+
+	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
+	if (!rdata || num_rdata <= 0) {
+		dev_err(&pdev->dev, "No init data supplied.\n");
+		return -ENODEV;
+	}
+
+	max77693_pmic = devm_kzalloc(&pdev->dev,
+				sizeof(struct max77693_pmic_dev),
+				GFP_KERNEL);
+	if (!max77693_pmic)
+		return -ENOMEM;
+
+	max77693_pmic->rdev = devm_kzalloc(&pdev->dev,
+				sizeof(struct regulator_dev *) * num_rdata,
+				GFP_KERNEL);
+	if (!max77693_pmic->rdev)
+		return -ENOMEM;
+
+	max77693_pmic->dev = &pdev->dev;
+	max77693_pmic->iodev = iodev;
+	max77693_pmic->num_regulators = num_rdata;
+
+	config.dev = &pdev->dev;
+	config.regmap = iodev->regmap;
+	config.driver_data = max77693_pmic;
+	platform_set_drvdata(pdev, max77693_pmic);
+
+	for (i = 0; i < max77693_pmic->num_regulators; i++) {
+		int id = rdata[i].id;
+
+		config.init_data = rdata[i].initdata;
+		config.of_node = rdata[i].of_node;
+
+		max77693_pmic->rdev[i] = regulator_register(&regulators[id],
+							    &config);
+		if (IS_ERR(max77693_pmic->rdev[i])) {
+			ret = PTR_ERR(max77693_pmic->rdev[i]);
+			dev_err(max77693_pmic->dev,
+				"Failed to initialize regulator-%d\n", id);
+			max77693_pmic->rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+ err:
+	while (--i >= 0)
+		regulator_unregister(max77693_pmic->rdev[i]);
+
+	return ret;
+}
+
+static int max77693_pmic_remove(struct platform_device *pdev)
+{
+	struct max77693_pmic_dev *max77693_pmic = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max77693_pmic->rdev;
+	int i;
+
+	for (i = 0; i < max77693_pmic->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return 0;
+}
+
+static const struct platform_device_id max77693_pmic_id[] = {
+	{"max77693-pmic", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(platform, max77693_pmic_id);
+
+static struct platform_driver max77693_pmic_driver = {
+	.driver = {
+		   .name = "max77693-pmic",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = max77693_pmic_probe,
+	.remove = max77693_pmic_remove,
+	.id_table = max77693_pmic_id,
+};
+
+module_platform_driver(max77693_pmic_driver);
+
+MODULE_DESCRIPTION("MAXIM MAX77693 regulator driver");
+MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 1aa4f13..244fb0d 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -85,6 +85,19 @@ enum max77693_pmic_reg {
 	MAX77693_PMIC_REG_END,
 };
 
+/* MAX77693 CHG_CNFG_00 register */
+#define CHG_CNFG_00_CHG_MASK		0x1
+#define CHG_CNFG_00_BUCK_MASK		0x4
+
+/* MAX77693 CHG_CNFG_09 Register */
+#define CHG_CNFG_09_CHGIN_ILIM_MASK	0x7F
+
+/* MAX77693 CHG_CTRL Register */
+#define SAFEOUT_CTRL_SAFEOUT1_MASK	0x3
+#define SAFEOUT_CTRL_SAFEOUT2_MASK	0xC
+#define SAFEOUT_CTRL_ENSAFEOUT1_MASK	0x40
+#define SAFEOUT_CTRL_ENSAFEOUT2_MASK	0x80
+
 /* Slave addr = 0x4A: MUIC */
 enum max77693_muic_reg {
 	MAX77693_MUIC_REG_ID		= 0x00,
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 3109a6c..676f0f3 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -30,6 +30,20 @@
 #ifndef __LINUX_MFD_MAX77693_H
 #define __LINUX_MFD_MAX77693_H
 
+/* MAX77686 regulator IDs */
+enum max77693_regulators {
+	MAX77693_ESAFEOUT1 = 0,
+	MAX77693_ESAFEOUT2,
+	MAX77693_CHARGER,
+	MAX77693_REG_MAX,
+};
+
+struct max77693_regulator_data {
+	int id;
+	struct regulator_init_data *initdata;
+	struct device_node *of_node;
+};
+
 struct max77693_reg_data {
 	u8 addr;
 	u8 data;
@@ -52,6 +66,10 @@ struct max77693_muic_platform_data {
 struct max77693_platform_data {
 	int wakeup;
 
+	/* regulator data */
+	struct max77693_regulator_data *regulators;
+	int num_regulators;
+
 	/* muic data */
 	struct max77693_muic_platform_data *muic_data;
 };
-- 
1.7.9.5

