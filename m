Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab3G3IU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:20:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56094 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:20:53 -0400
X-AuditID: cbfee68f-b7f436d000000f81-27-51f777604119
From: Jingoo Han <jg1.han@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 34/35] regulator: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:20:47 +0900
Message-id: <005d01ce8cfd$b1c64a60$1552df20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M/YdZ88sgeetsToCUINe9gon7+Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zfd2E8u+BBpva5S2mPnzCZnF54SVW
	i29XOpgsLu+aw+bA4rFz1l12j02rOtk8+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+No9ya2
	gtnHGCsmHbrL3sD4dAVjFyMnh4SAicTGqwtZIWwxiQv31rN1MXJxCAksY5RY/nk1E0zRtHOf
	mEFsIYFFjBJ3FoZAFP1ilFi5cglYN5uAmsSXL4fZuxg5OEQE1CUuruEHCTMLpEqcXTAFbJmw
	gIXE7D1rWEBsFgFViddLn4LN5xWwlLjVuJ0VwhaU+DH5HgtEr5bE+p3HmSBseYnNa94yQ9yj
	ILHj7GuwmSICehKXz76EqheR2PfiHdRj29glNtyKhdglIPFt8iEWkNMkBGQlNh2AGiMpcXDF
	DZYJjGKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGSJz172C8
	e8D6EGMy0PqJzFKiyfnAOM0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA6Ni6uzQd5n/ut4Jcr/3cljxyTSqdSrzx1Xc39tkv/H13pF00vE3dWDS
	4nm8eOE+k8cWf3QPzE4rVmy9+drz2P/iP3u79yntPpWjNzNWWvJo3D61l8HFx5dPM3pzr4Pt
	8fvgzKrJal0rN3oeZzthJDRB3tl1+97Ny07+zlthZWmcVhTkubJYPE6JpTgj0VCLuag4EQDZ
	QClnyQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd2E8u+BBkfbJCymPnzCZnF54SVW
	i29XOpgsLu+aw+bA4rFz1l12j02rOtk8+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHjaPcmtoLZxxgrJh26y97A+HQFYxcjJ4eEgInEtHOfmCFsMYkL
	99azgdhCAosYJe4sDOli5AKyfzFKrFy5hBUkwSagJvHly2H2LkYODhEBdYmLa/hBwswCqRJn
	F0wBmyksYCExe88aFhCbRUBV4vXSp0wgNq+ApcStxu2sELagxI/J91ggerUk1u88zgRhy0ts
	XvMW6h4FiR1nX4PNFBHQk7h89iVUvYjEvhfvGCcwCsxCMmoWklGzkIyahaRlASPLKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgOH4mvYNxVYPFIUYBDkYlHt4NBd8ChVgTy4orcw8xSnAw
	K4nwstwACvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MMXklcQbGpuYGVkamVkYmZibkyas
	JM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOj74PVZeaesvcmPHOt+HbqoGl1wtKIojkr2iXP
	ZrtNmdj6veeM9IyVM1wU+T/abAkL+SSTebDEruHw7FUcPnZnT0Uyv4mJSAt3uTspZLJIRaOM
	8NvUT073n1y/vF7eTD/nrMbzKysiFkx91pM+I1NPd5KLtqm3Z9CH3PvxC9XyeuM+RrM8V/JV
	YinOSDTUYi4qTgQAb4gklScDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/88pm800.c            |    2 +-
 drivers/regulator/88pm8607.c           |    2 +-
 drivers/regulator/aat2870-regulator.c  |    2 +-
 drivers/regulator/ab3100.c             |    2 +-
 drivers/regulator/ad5398.c             |    2 +-
 drivers/regulator/da903x.c             |    2 +-
 drivers/regulator/da9052-regulator.c   |    2 +-
 drivers/regulator/da9055-regulator.c   |    2 +-
 drivers/regulator/fan53555.c           |    2 +-
 drivers/regulator/fixed.c              |    2 +-
 drivers/regulator/gpio-regulator.c     |    2 +-
 drivers/regulator/isl6271a-regulator.c |    2 +-
 drivers/regulator/lp3971.c             |    2 +-
 drivers/regulator/lp3972.c             |    2 +-
 drivers/regulator/lp872x.c             |    2 +-
 drivers/regulator/lp8755.c             |    2 +-
 drivers/regulator/max1586.c            |    2 +-
 drivers/regulator/max8649.c            |    2 +-
 drivers/regulator/max8660.c            |    2 +-
 drivers/regulator/max8925-regulator.c  |    2 +-
 drivers/regulator/max8952.c            |    2 +-
 drivers/regulator/max8973-regulator.c  |    2 +-
 drivers/regulator/palmas-regulator.c   |    2 +-
 drivers/regulator/pcap-regulator.c     |    2 +-
 drivers/regulator/pcf50633-regulator.c |    2 +-
 drivers/regulator/tps51632-regulator.c |    2 +-
 drivers/regulator/tps62360-regulator.c |    2 +-
 drivers/regulator/tps65023-regulator.c |    2 +-
 drivers/regulator/tps6524x-regulator.c |    2 +-
 drivers/regulator/twl-regulator.c      |    2 +-
 drivers/regulator/userspace-consumer.c |    2 +-
 drivers/regulator/virtual.c            |    2 +-
 drivers/regulator/wm831x-dcdc.c        |    8 ++++----
 drivers/regulator/wm831x-isink.c       |    2 +-
 drivers/regulator/wm831x-ldo.c         |    6 +++---
 drivers/regulator/wm8350-regulator.c   |    2 +-
 drivers/regulator/wm8400-regulator.c   |    2 +-
 drivers/regulator/wm8994-regulator.c   |    2 +-
 38 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index b4c29b1..c72fe95 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -283,7 +283,7 @@ static int pm800_regulator_dt_init(struct platform_device *pdev)
 static int pm800_regulator_probe(struct platform_device *pdev)
 {
 	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm80x_platform_data *pdata = pdev->dev.parent->platform_data;
+	struct pm80x_platform_data *pdata = dev_get_platdata(pdev->dev.parent);
 	struct pm800_regulators *pm800_data;
 	struct pm800_regulator_info *info;
 	struct regulator_config config = { };
diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 8a7cb1f..7023097 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -346,7 +346,7 @@ static int pm8607_regulator_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm8607_regulator_info *info = NULL;
-	struct regulator_init_data *pdata = pdev->dev.platform_data;
+	struct regulator_init_data *pdata = dev_get_platdata(&pdev->dev);
 	struct regulator_config config = { };
 	struct resource *res;
 	int i;
diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 8b58763..881159d 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -174,7 +174,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 
 	config.dev = &pdev->dev;
 	config.driver_data = ri;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 
 	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 3be9e46..7d5eaa8 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -660,7 +660,7 @@ ab3100_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
 
 static int ab3100_regulators_probe(struct platform_device *pdev)
 {
-	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
+	struct ab3100_platform_data *plfdata = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
 	int err = 0;
 	u8 data;
diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 6b981b5..b2b203c 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -214,7 +214,7 @@ MODULE_DEVICE_TABLE(i2c, ad5398_id);
 static int ad5398_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	struct regulator_init_data *init_data = client->dev.platform_data;
+	struct regulator_init_data *init_data = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct ad5398_chip_info *chip;
 	const struct ad5398_current_data_format *df =
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 1378a24..f06854c 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -460,7 +460,7 @@ static int da903x_regulator_probe(struct platform_device *pdev)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = ri;
 
 	rdev = regulator_register(&ri->desc, &config);
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 96b569a..1e4d483 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -349,7 +349,7 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	da9052 = dev_get_drvdata(pdev->dev.parent);
-	pdata = da9052->dev->platform_data;
+	pdata = dev_get_platdata(da9052->dev);
 	regulator->da9052 = da9052;
 
 	regulator->info = find_regulator_info(regulator->da9052->chip_id,
diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 3022109..77b53e5 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -535,7 +535,7 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct da9055_regulator *regulator;
 	struct da9055 *da9055 = dev_get_drvdata(pdev->dev.parent);
-	struct da9055_pdata *pdata = da9055->dev->platform_data;
+	struct da9055_pdata *pdata = dev_get_platdata(da9055->dev);
 	int ret, irq;
 
 	if (pdata == NULL || pdata->regulators[pdev->id] == NULL)
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 192444a..70b7220 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -237,7 +237,7 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	unsigned int val;
 	int ret;
 
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 	if (!pdata || !pdata->regulator) {
 		dev_err(&client->dev, "Platform data not found!\n");
 		return -ENODEV;
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index e5c03b5..7610920 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -146,7 +146,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		if (IS_ERR(config))
 			return PTR_ERR(config);
 	} else {
-		config = pdev->dev.platform_data;
+		config = dev_get_platdata(&pdev->dev);
 	}
 
 	if (!config)
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 9d39eb4..98a98ff 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -219,7 +219,7 @@ static struct regulator_ops gpio_regulator_current_ops = {
 
 static int gpio_regulator_probe(struct platform_device *pdev)
 {
-	struct gpio_regulator_config *config = pdev->dev.platform_data;
+	struct gpio_regulator_config *config = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
 	struct gpio_regulator_data *drvdata;
 	struct regulator_config cfg = { };
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index b99c49b..88c1a3a 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -110,7 +110,7 @@ static int isl6271a_probe(struct i2c_client *i2c,
 				     const struct i2c_device_id *id)
 {
 	struct regulator_config config = { };
-	struct regulator_init_data *init_data	= i2c->dev.platform_data;
+	struct regulator_init_data *init_data	= dev_get_platdata(&i2c->dev);
 	struct isl_pmic *pmic;
 	int err, i;
 
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 3809b43..5a4604e 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -425,7 +425,7 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct lp3971 *lp3971;
-	struct lp3971_platform_data *pdata = i2c->dev.platform_data;
+	struct lp3971_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret;
 	u16 val;
 
diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 5730240..093e6f4 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -519,7 +519,7 @@ static int lp3972_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct lp3972 *lp3972;
-	struct lp3972_platform_data *pdata = i2c->dev.platform_data;
+	struct lp3972_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret;
 	u16 val;
 
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 1018fb2..2b84b72 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -962,7 +962,7 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	}
 
 	lp->dev = &cl->dev;
-	lp->pdata = cl->dev.platform_data;
+	lp->pdata = dev_get_platdata(&cl->dev);
 	lp->chipid = id->driver_data;
 	lp->num_regulators = num_regulators;
 	i2c_set_clientdata(cl, lp);
diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index b37ef30..785a25e 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -450,7 +450,7 @@ static int lp8755_probe(struct i2c_client *client,
 {
 	int ret, icnt;
 	struct lp8755_chip *pchip;
-	struct lp8755_platform_data *pdata = client->dev.platform_data;
+	struct lp8755_platform_data *pdata = dev_get_platdata(&client->dev);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_err(&client->dev, "i2c functionality check fail.\n");
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 54af610..3a599ee 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -163,7 +163,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 					const struct i2c_device_id *i2c_id)
 {
 	struct regulator_dev **rdev;
-	struct max1586_platform_data *pdata = client->dev.platform_data;
+	struct max1586_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct max1586_data *max1586;
 	int i, id, ret = -ENOMEM;
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index db6c9be..19c6f08 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -152,7 +152,7 @@ static struct regmap_config max8649_regmap_config = {
 static int max8649_regulator_probe(struct i2c_client *client,
 					     const struct i2c_device_id *id)
 {
-	struct max8649_platform_data *pdata = client->dev.platform_data;
+	struct max8649_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct max8649_regulator_info *info = NULL;
 	struct regulator_config config = { };
 	unsigned int val;
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index d428ef9..bfd4108 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -309,7 +309,7 @@ static int max8660_probe(struct i2c_client *client,
 				   const struct i2c_device_id *i2c_id)
 {
 	struct regulator_dev **rdev;
-	struct max8660_platform_data *pdata = client->dev.platform_data;
+	struct max8660_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct max8660 *max8660;
 	int boot_on, i, id, ret = -EINVAL;
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index e6d54a5..d80b5fa 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -277,7 +277,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 static int max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct regulator_init_data *pdata = pdev->dev.platform_data;
+	struct regulator_init_data *pdata = dev_get_platdata(&pdev->dev);
 	struct regulator_config config = { };
 	struct max8925_regulator_info *ri;
 	struct resource *res;
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 5259c2f..788e5ae 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -196,7 +196,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 		const struct i2c_device_id *i2c_id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct max8952_platform_data *pdata = client->dev.platform_data;
+	struct max8952_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct max8952_data *max8952;
 
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 0c5195a..5b77ab7 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -371,7 +371,7 @@ static int max8973_probe(struct i2c_client *client,
 	struct max8973_chip *max;
 	int ret;
 
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 
 	if (!pdata && !client->dev.of_node) {
 		dev_err(&client->dev, "No Platform data");
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d0c8785..e8877e4 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -765,7 +765,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 static int palmas_regulators_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
-	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
+	struct palmas_pmic_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 1a73a29..b49eaee 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -243,7 +243,7 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 
 	config.dev = &pdev->dev;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = pcap;
 
 	rdev = regulator_register(&pcap_regulators[pdev->id], &config);
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 54df9f7..0f3576d 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -86,7 +86,7 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 	pcf = dev_to_pcf50633(pdev->dev.parent);
 
 	config.dev = &pdev->dev;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = pcf;
 	config.regmap = pcf->regmap;
 
diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 6e67be7..9392a7c 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -275,7 +275,7 @@ static int tps51632_probe(struct i2c_client *client,
 		}
 	}
 
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 	if (!pdata && client->dev.of_node)
 		pdata = of_get_tps51632_platform_data(&client->dev);
 	if (!pdata) {
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index a490d5b..0b7ebb1 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -350,7 +350,7 @@ static int tps62360_probe(struct i2c_client *client,
 	int i;
 	int chip_id;
 
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 
 	if (client->dev.of_node) {
 		const struct of_device_id *match;
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 9d053e2..a15263d 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -218,7 +218,7 @@ static int tps_65023_probe(struct i2c_client *client,
 	 * init_data points to array of regulator_init structures
 	 * coming from the board-evm file.
 	 */
-	init_data = client->dev.platform_data;
+	init_data = dev_get_platdata(&client->dev);
 	if (!init_data)
 		return -EIO;
 
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 1094393..62e8d28 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -601,7 +601,7 @@ static int pmic_probe(struct spi_device *spi)
 	struct regulator_config config = { };
 	int ret = 0, i;
 
-	init_data = dev->platform_data;
+	init_data = dev_get_platdata(dev);
 	if (!init_data) {
 		dev_err(dev, "could not find regulator platform data\n");
 		return -EINVAL;
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 93bc4f4..78aae4c 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1108,7 +1108,7 @@ static int twlreg_probe(struct platform_device *pdev)
 		drvdata = NULL;
 	} else {
 		id = pdev->id;
-		initdata = pdev->dev.platform_data;
+		initdata = dev_get_platdata(&pdev->dev);
 		for (i = 0, template = NULL; i < ARRAY_SIZE(twl_of_match); i++) {
 			template = twl_of_match[i].data;
 			if (template && template->desc.id == id)
diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index a7c8deb..765acc1 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -111,7 +111,7 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 	struct userspace_consumer_data *drvdata;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata)
 		return -EINVAL;
 
diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index a9d4284..f53e78b 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -287,7 +287,7 @@ static const struct attribute_group regulator_virtual_attr_group = {
 
 static int regulator_virtual_probe(struct platform_device *pdev)
 {
-	char *reg_id = pdev->dev.platform_data;
+	char *reg_id = dev_get_platdata(&pdev->dev);
 	struct virtual_consumer_data *drvdata;
 	int ret;
 
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 46938cf..11861cb 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -451,7 +451,7 @@ static void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 static int wm831x_buckv_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id;
 	struct wm831x_dcdc *dcdc;
@@ -624,7 +624,7 @@ static struct regulator_ops wm831x_buckp_ops = {
 static int wm831x_buckp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id;
 	struct wm831x_dcdc *dcdc;
@@ -770,7 +770,7 @@ static struct regulator_ops wm831x_boostp_ops = {
 static int wm831x_boostp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	struct wm831x_dcdc *dcdc;
@@ -880,7 +880,7 @@ static struct regulator_ops wm831x_epe_ops = {
 static int wm831x_epe_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id = pdev->id % ARRAY_SIZE(pdata->epe);
 	struct wm831x_dcdc *dcdc;
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 16ebdf9..4eb373d 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -151,7 +151,7 @@ static irqreturn_t wm831x_isink_irq(int irq, void *data)
 static int wm831x_isink_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_isink *isink;
 	int id = pdev->id % ARRAY_SIZE(pdata->isink);
 	struct regulator_config config = { };
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 76792c7..1432b26 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -221,7 +221,7 @@ static struct regulator_ops wm831x_gp_ldo_ops = {
 static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
@@ -447,7 +447,7 @@ static struct regulator_ops wm831x_aldo_ops = {
 static int wm831x_aldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
@@ -605,7 +605,7 @@ static struct regulator_ops wm831x_alive_ldo_ops = {
 static int wm831x_alive_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 5453dd0..835b5f0 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1201,7 +1201,7 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 	}
 
 	config.dev = &pdev->dev;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = dev_get_drvdata(&pdev->dev);
 	config.regmap = wm8350->regmap;
 
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 2ac7e1a..58f51be 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -215,7 +215,7 @@ static int wm8400_regulator_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdev->dev.platform_data;
+	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = wm8400;
 	config.regmap = wm8400->regmap;
 
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 8f2a8a7..5ee2a20 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -125,7 +125,7 @@ static const struct regulator_init_data wm8994_ldo_default[] = {
 static int wm8994_ldo_probe(struct platform_device *pdev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
-	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	struct wm8994_pdata *pdata = dev_get_platdata(wm8994->dev);
 	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct regulator_config config = { };
 	struct wm8994_ldo *ldo;
-- 
1.7.10.4


