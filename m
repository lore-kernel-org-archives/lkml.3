Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaIQCrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:47:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45279 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbaIQCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:47:31 -0400
X-AuditID: cbfee68f-f797f6d000001173-ac-5418f6409962
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/2] power: smb347-charger: Support devicetree binding for
 smb347 driver.
Date: Wed, 17 Sep 2014 11:47:23 +0900
Message-id: <1410922044-4170-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1410922044-4170-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWyRsSkWNfxm0SIwb/VbBYHt2paTHryntli
	4srJzBadZ58wW1zeNYfN4nPvEUaLu6eOslmc3l3iwOExof8To8fOWXfZPTav0PLYtKqTzaNv
	yypGjxWrv7N7fN4kF8AexWWTkpqTWZZapG+XwJVxcPox9oK9oRU37nSyNjDec+ti5OSQEDCR
	WLfpAyOELSZx4d56ti5GLg4hgaWMErvX7GKGKWq98pIZIrGIUWLP7m9QVW1MEldaTzCBVLEJ
	6Ej833eTHcQWEVCQ2Nz7jBWkiFlgMaPE01MvwEYJC0RLNG7fAtbAIqAqMXH2bLA4r4C7xMNT
	J4GaOYDWKUjMmWQDEuYU8JC4Nnsm2HlCQCUr/2xkBJkpIbCOXeLHw36oOQIS3yYfYoHolZXY
	dADqakmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzACTv971r+D8e4B
	60OMAhyMSjy8Gy5LhAixJpYVV+YeYjQF2jCRWUo0OR8YZ3kl8YbGZkYWpiamxkbmlmZK4rwL
	pX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAMCBCcs3unjdSFExctzzOuXcRoHVtXL2u8
	KWAPX3dU0JfmpPW7Ge3WFOxa4WCXF89RtXDjmo3O5xfFWLSmX812X5EQFZ5zTFzDhrF2juuk
	cKGeNB/Wg0fOTqt6+lxTauZy3XxzfsNzWxeo3v1Z9XLN4RmC3ed8uxsyAmbPrmr3P8z7c8cF
	mZNKLMUZiYZazEXFiQARDek4ewIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAV2HbxIhBqtWWFoc3KppMenJe2aL
	iSsnM1t0nn3CbHF51xw2i8+9Rxgt7p46ymZxeneJA4fHhP5PjB47Z91l99i8Qstj06pONo++
	LasYPVas/s7u8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjIPT
	j7EX7A2tuHGnk7WB8Z5bFyMnh4SAiUTrlZfMELaYxIV769m6GLk4hAQWMUrs2f0NymljkrjS
	eoIJpIpNQEfi/76b7CC2iICCxObeZ6wgRcwCixklnp56ATZKWCBaonH7FrAGFgFViYmzZ4PF
	eQXcJR6eOgnUzAG0TkFiziQbkDCngIfEtdkzGUFsIaCSlX82Mk5g5F3AyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzi+nkntYFzZYHGIUYCDUYmHd8NliRAh1sSy4srcQ4wSHMxKIrwi
	94BCvCmJlVWpRfnxRaU5qcWHGE2BjprILCWanA+M/bySeENjEzMjSyNzQwsjY3Mlcd4DrdaB
	QgLpiSWp2ampBalFMH1MHJxSDYy8HW+qpnLeCXly8fK69pCetd+Nbdm4f7HOMRdJntn59ejd
	doHFPR/Kz69c9minvDIby7dvZnNjk5Xu5H2zFHONbPkcauR4uODTpNXrVqcxLmjfcUuvyY7R
	+P9pLeY7EpusJ65vbonzvt8gMNl6zj7RrUL+z5nns/GYHmZ4dzL/V8NN3+XhAtlKLMUZiYZa
	zEXFiQDJuOhcxQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes smb347 charger driver to support dt binding. All legacy
platform data now can be parsed from dt.
Because of that smb347 is i2c client driver, IRQ number can be passed
automatically through client's irq variable if it is defined in dt.
No more to use requesting gpio to irq manually in dt-way.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by : Chanwoo Choi <cw00.choi@samsung.com>
Acked-by : Myungjoo Ham <myungjoo.ham@samsung.com>
---
 .../bindings/power_supply/smb347_charger.txt       |   57 ++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/smb347-charger.c                     |  144 +++++++++++++++-----
 3 files changed, 167 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/smb347_charger.txt

diff --git a/Documentation/devicetree/bindings/power_supply/smb347_charger.txt b/Documentation/devicetree/bindings/power_supply/smb347_charger.txt
new file mode 100644
index 0000000..91570a5
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/smb347_charger.txt
@@ -0,0 +1,57 @@
+smb347_charger bindings
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+[Required porperties]
+- compatible : "summit,smb347"
+- reg : Slave address for i2c interface
+# At least one of followings should be set
+  - enable-usb-charging
+  - enable-otg-charging
+  - enable-mains-charging
+
+[Optional properties]
+- interrupt-parent : The phandle for the interrupt controller
+- interrupts : Interrupt line index for mapping
+- enable-chg-ctrl : Enable charging control
+		<0> : SW (i2c interface)
+		<1> : Pin control (Active Low)
+		<2> : Pin control (Active High)
+# Charging constraints
+- max-chg-curr : Maximum current for charging (in uA)
+- max-chg-volt : Maximum voltage for charging (in uV)
+- pre-chg-curr : Pre-charging current (in uA)
+- term-curr : Charging cycle termination current (in uA)
+- fast-volt-thershold : Voltage threshold to transit to fast charge mode (in uV)
+- mains-curr-limit : Maximum input current from AC/DC input (in uA)
+- usb-curr-limit : Maximum input current from USB input (in uA)
+
+# Related thermometer monitoring (in degree C)
+- chip-temp-threshold : Chip temperature for thermal regulaton.   <100, 130>
+- soft-cold-temp-limit : Cold battery temperature for soft alarm. <0, 15>*
+- soft-hot-temp-limit : Hot battery temperature for soft alarm.   <40, 55>
+- hard-cold-temp-limit : Cold battery temperature for hard alarm. <0, 15>*
+- hard-hot-temp-limit : Hot battery temperature for hard alarm.   <55, 65>
+(* The written temperature has +5'C offset. 0'C -> -5'C, 15'C -> 10'C)
+- soft-comp-method : Soft temperature limit compensation method
+	(Not defined) : Use default setting
+		<0> : Compensation none
+		<1> : Charge current compensation
+		<2> : Voltage compensation
+
+Example:
+	smb347@7f {
+		compatible = "summit,smb347";
+		reg = <0x7f>;
+		status = "okay";
+
+		max-chg-curr = <1800000>;
+		mains-curr-limit = <2000000>;
+		usb-curr-limit = <450000>;
+
+		chip-temp-thershold = <110>;
+
+		enable-usb-charging;
+		enable-mains-charging;
+
+		enable-chg-ctrl = <2>;	/* Pin control (Active High) */
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 13fda72..616e2a1 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -121,6 +121,7 @@ spansion	Spansion Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
+summit	Summit microelectronics
 synology	Synology, Inc.
 ti	Texas Instruments
 tlm	Trusted Logic Mobility
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index acf84e8..8073879 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -835,20 +835,28 @@ static int smb347_irq_init(struct smb347_charger *smb,
 			   struct i2c_client *client)
 {
 	const struct smb347_charger_platform_data *pdata = smb->pdata;
-	int ret, irq = gpio_to_irq(pdata->irq_gpio);
+	int ret;
 
-	ret = gpio_request_one(pdata->irq_gpio, GPIOF_IN, client->name);
-	if (ret < 0)
-		goto fail;
+	/* Requesting GPIO for IRQ is only needed in non-DT way */
+	if (!client->irq) {
+		int irq = gpio_to_irq(pdata->irq_gpio);
+		ret = devm_gpio_request_one(smb->dev, pdata->irq_gpio,
+						GPIOF_IN, client->name);
+		if (ret < 0)
+			goto out;
 
-	ret = request_threaded_irq(irq, NULL, smb347_interrupt,
-				   IRQF_TRIGGER_FALLING, client->name, smb);
+		client->irq = irq;
+	}
+
+	ret = devm_request_threaded_irq(smb->dev, client->irq, NULL,
+					smb347_interrupt, IRQF_TRIGGER_FALLING,
+					client->name, smb);
 	if (ret < 0)
-		goto fail_gpio;
+		goto out;
 
 	ret = smb347_set_writable(smb, true);
 	if (ret < 0)
-		goto fail_irq;
+		goto out;
 
 	/*
 	 * Configure the STAT output to be suitable for interrupts: disable
@@ -858,20 +866,10 @@ static int smb347_irq_init(struct smb347_charger *smb,
 				 CFG_STAT_ACTIVE_HIGH | CFG_STAT_DISABLED,
 				 CFG_STAT_DISABLED);
 	if (ret < 0)
-		goto fail_readonly;
-
-	smb347_set_writable(smb, false);
-	client->irq = irq;
-	return 0;
+		client->irq = 0;
 
-fail_readonly:
 	smb347_set_writable(smb, false);
-fail_irq:
-	free_irq(irq, smb);
-fail_gpio:
-	gpio_free(pdata->irq_gpio);
-fail:
-	client->irq = 0;
+out:
 	return ret;
 }
 
@@ -1180,6 +1178,80 @@ static bool smb347_readable_reg(struct device *dev, unsigned int reg)
 	return smb347_volatile_reg(dev, reg);
 }
 
+static void smb347_dt_parse_pdata(struct device_node *np,
+				 struct smb347_charger_platform_data *pdata)
+{
+	/* Charing constraints */
+	of_property_read_u32(np, "max-chg-curr", &pdata->max_charge_current);
+	of_property_read_u32(np, "max-chg-volt", &pdata->max_charge_voltage);
+	of_property_read_u32(np, "pre-chg-curr", &pdata->pre_charge_current);
+	of_property_read_u32(np, "term-curr", &pdata->termination_current);
+	of_property_read_u32(np, "fast-volt-threshold",
+						&pdata->pre_to_fast_voltage);
+	of_property_read_u32(np, "mains-curr-limit",
+						&pdata->mains_current_limit);
+	of_property_read_u32(np, "usb-curr-limit",
+						&pdata->usb_hc_current_limit);
+
+	/* For thermometer monitoring */
+	of_property_read_u32(np, "chip-temp-threshold",
+				&pdata->chip_temp_threshold);
+	if (of_property_read_u32(np, "soft-cold-temp-limit",
+				&pdata->soft_cold_temp_limit))
+		pdata->soft_cold_temp_limit = SMB347_TEMP_USE_DEFAULT;
+	if (of_property_read_u32(np, "soft-hot-temp-limit",
+				&pdata->soft_hot_temp_limit))
+		pdata->soft_hot_temp_limit = SMB347_TEMP_USE_DEFAULT;
+	if (of_property_read_u32(np, "hard-cold-temp-limit",
+				&pdata->hard_cold_temp_limit))
+		pdata->hard_cold_temp_limit = SMB347_TEMP_USE_DEFAULT;
+	if (of_property_read_u32(np, "hard-hot-temp-limit",
+				&pdata->hard_hot_temp_limit))
+		pdata->hard_hot_temp_limit = SMB347_TEMP_USE_DEFAULT;
+
+	/* Suspend when battery temperature is outside hard limits */
+	if ((pdata->hard_cold_temp_limit != SMB347_TEMP_USE_DEFAULT)
+		|| (pdata->hard_hot_temp_limit != SMB347_TEMP_USE_DEFAULT))
+		pdata->suspend_on_hard_temp_limit = true;
+
+	if (of_property_read_u32(np, "soft-comp-method",
+				&pdata->soft_temp_limit_compensation))
+		pdata->soft_temp_limit_compensation =
+				SMB347_SOFT_TEMP_COMPENSATE_DEFAULT;
+
+	of_property_read_u32(np, "chg-curr-comp",
+				&pdata->charge_current_compensation);
+
+	/* Supported charging mode */
+	pdata->use_mains = of_property_read_bool(np, "enable-mains-charging");
+	pdata->use_usb = of_property_read_bool(np, "enable-usb-charging");
+	pdata->use_usb_otg = of_property_read_bool(np, "enable-otg-charging");
+
+	/* Enable charging method */
+	of_property_read_u32(np, "enable-chg-ctrl", &pdata->enable_control);
+
+	/* If IRQ is enabled or not */
+	if (!of_get_property(np, "interrupts", NULL))
+		pdata->irq_gpio = -1;
+
+	return;
+}
+
+static struct smb347_charger_platform_data
+			*smb347_get_platdata(struct device *dev)
+{
+	struct smb347_charger_platform_data *pdata = NULL;
+
+	if (dev->of_node) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		smb347_dt_parse_pdata(dev->of_node, pdata);
+	} else {
+		pdata = dev_get_platdata(dev);
+	}
+
+	return pdata;
+}
+
 static const struct regmap_config smb347_regmap = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
@@ -1192,27 +1264,25 @@ static int smb347_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	static char *battery[] = { "smb347-battery" };
-	const struct smb347_charger_platform_data *pdata;
 	struct device *dev = &client->dev;
 	struct smb347_charger *smb;
 	int ret;
 
-	pdata = dev->platform_data;
-	if (!pdata)
-		return -EINVAL;
-
-	if (!pdata->use_mains && !pdata->use_usb)
-		return -EINVAL;
-
 	smb = devm_kzalloc(dev, sizeof(*smb), GFP_KERNEL);
 	if (!smb)
 		return -ENOMEM;
 
+	smb->pdata = smb347_get_platdata(dev);
+	if (!smb->pdata)
+		return -ENODEV;
+
+	if (!smb->pdata->use_mains && !smb->pdata->use_usb)
+		return -EINVAL;
+
 	i2c_set_clientdata(client, smb);
 
 	mutex_init(&smb->lock);
 	smb->dev = &client->dev;
-	smb->pdata = pdata;
 
 	smb->regmap = devm_regmap_init_i2c(client, &smb347_regmap);
 	if (IS_ERR(smb->regmap))
@@ -1257,7 +1327,6 @@ static int smb347_probe(struct i2c_client *client,
 	smb->battery.properties = smb347_battery_properties;
 	smb->battery.num_properties = ARRAY_SIZE(smb347_battery_properties);
 
-
 	ret = power_supply_register(dev, &smb->battery);
 	if (ret < 0) {
 		if (smb->pdata->use_usb)
@@ -1271,7 +1340,7 @@ static int smb347_probe(struct i2c_client *client,
 	 * Interrupt pin is optional. If it is connected, we setup the
 	 * interrupt support here.
 	 */
-	if (pdata->irq_gpio >= 0) {
+	if (smb->pdata->irq_gpio >= 0) {
 		ret = smb347_irq_init(smb, client);
 		if (ret < 0) {
 			dev_warn(dev, "failed to initialize IRQ: %d\n", ret);
@@ -1288,11 +1357,8 @@ static int smb347_remove(struct i2c_client *client)
 {
 	struct smb347_charger *smb = i2c_get_clientdata(client);
 
-	if (client->irq) {
+	if (client->irq)
 		smb347_irq_disable(smb);
-		free_irq(client->irq, smb);
-		gpio_free(smb->pdata->irq_gpio);
-	}
 
 	power_supply_unregister(&smb->battery);
 	if (smb->pdata->use_usb)
@@ -1308,9 +1374,17 @@ static const struct i2c_device_id smb347_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, smb347_id);
 
+#ifdef CONFIG_OF
+static struct of_device_id of_smb347_ids[] = {
+	{ .compatible = "summit,smb347" },
+	{},
+};
+#endif
+
 static struct i2c_driver smb347_driver = {
 	.driver = {
 		.name = "smb347",
+		.of_match_table = of_match_ptr(of_smb347_ids),
 	},
 	.probe        = smb347_probe,
 	.remove       = smb347_remove,
-- 
1.7.9.5

