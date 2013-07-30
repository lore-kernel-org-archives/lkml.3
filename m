Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3G3ITh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:19:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59997 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3G3ITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:19:30 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-40-51f7770f0c35
From: Jingoo Han <jg1.han@samsung.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 33/35] power: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:19:27 +0900
Message-id: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M/XduxdB5jIVwQ4yV2hWDSk8UoQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zI12B8u+BBgsfM1oc3KppMXHlZGaL
	ywsvsVpc3jWHzYHFY0L/J0aPzSu0PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSuj4ehH1oLm
	fYwVrZ9PszYwLljI2MXIySEhYCLxcOo9FghbTOLCvfVsXYxcHEICyxgleg/2s8AULf15lgUi
	sYhRYtn0ZlYI5xejxMV9U9lAqtgE1CS+fDnMDmKLANmnL79kBbGZBbIl1q05CjZJGGjS/8vz
	mEFsFgFViYmtK4HqOTh4BSwlWu45gIR5BQQlfkyGuIhZQEti/c7jTBC2vMTmNW+ZIQ5SkNhx
	9jUjxCo9iVX7X0HVi0jse/EO6rNN7BJLtidCrBKQ+Db5EAvIKgkBWYlNB6DGSEocXHGDZQKj
	2Cwkm2ch2TwLyeZZSDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESZb07GG8fsD7E
	mAy0fiKzlGhyPjBK80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXA2FRYsIfNLmOmG/MK/eIzF25uvLdxR0t3N1vcJePHDW7GNU2XtJw7qwvvvtla
	OXO7Uc0plpSf1+JWFxx5c7dCTHa1qk2GHJ/wF5bQ3MTs+LuK7pOEVm82f+Xyxyn1pGb+mQfG
	Bfu1uJj4d+XJKTE4Hp3ENPG7tuKPymzmDUJ/+m9rX+2WqtFXYinOSDTUYi4qTgQAXT088MgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAV3+8u+BBl9fmFsc3KppMXHlZGaL
	ywsvsVpc3jWHzYHFY0L/J0aPzSu0PPq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xo+HoR9aC5n2MFa2fT7M2MC5YyNjFyMkhIWAisfTnWRYIW0ziwr31
	bF2MXBxCAosYJZZNb2aFcH4xSlzcN5UNpIpNQE3iy5fD7CC2CJB9+vJLVhCbWSBbYt2ao2CT
	hIGm/r88jxnEZhFQlZjYuhKonoODV8BSouWeA0iYV0BQ4sfkeywQrVoS63ceZ4Kw5SU2r3nL
	DHGQgsSOs68ZIVbpSaza/wqqXkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwFD+T3sG4qsHiEKMAB6MSD++Ggm+BQqyJZcWVuYcYJTiYlUR4
	WW4AhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmGDySuINjU3MjCyNzCyMTMzNSRNWEuc9
	2GodKCSQnliSmp2aWpBaBLOFiYNTqoGxQtzN9cyEWZtL/+xYcdfW1dxFyewEz9y7JS0Lb8rk
	Sx6eG5+p9//ZLpZHzHcfzS6Y9equULzun/n5LZ4W8fdmrZPa6Lv392nd9p3GGxP+v4svZV2X
	talZ3V5vn9Gchzubc7+8elxUvW+WRaL4tKD155JaIp5uq3Cr23WLZdfCaduL72fF2VvJKrEU
	ZyQaajEXFScCAPzKWWImAwAA
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
 drivers/power/88pm860x_battery.c    |    2 +-
 drivers/power/ab8500_btemp.c        |    2 +-
 drivers/power/ab8500_charger.c      |    2 +-
 drivers/power/ab8500_fg.c           |    2 +-
 drivers/power/abx500_chargalg.c     |    2 +-
 drivers/power/avs/smartreflex.c     |    8 ++++----
 drivers/power/bq2415x_charger.c     |    4 ++--
 drivers/power/bq27x00_battery.c     |    4 ++--
 drivers/power/da9030_battery.c      |    2 +-
 drivers/power/da9052-battery.c      |    2 +-
 drivers/power/ds2782_battery.c      |    2 +-
 drivers/power/generic-adc-battery.c |    2 +-
 drivers/power/gpio-charger.c        |    3 ++-
 drivers/power/isp1704_charger.c     |    2 +-
 drivers/power/jz4740-battery.c      |    3 ++-
 drivers/power/lp8727_charger.c      |    2 +-
 drivers/power/max17040_battery.c    |    2 +-
 drivers/power/max17042_battery.c    |    4 ++--
 drivers/power/max8903_charger.c     |    2 +-
 drivers/power/max8925_power.c       |    4 ++--
 drivers/power/pda_power.c           |    2 +-
 drivers/power/pm2301_charger.c      |    3 ++-
 drivers/power/s3c_adc_battery.c     |   10 +++++-----
 drivers/power/sbs-battery.c         |    6 +++---
 drivers/power/smb347-charger.c      |    2 +-
 drivers/power/twl4030_charger.c     |    2 +-
 drivers/power/wm831x_backup.c       |    4 ++--
 drivers/power/wm831x_power.c        |    4 ++--
 drivers/power/wm97xx_battery.c      |   12 ++++++------
 drivers/power/z2_battery.c          |    2 +-
 30 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index dfcda3a..90ef60c 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
@@ -929,7 +929,7 @@ static int pm860x_battery_probe(struct platform_device *pdev)
 	    (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
 	info->dev = &pdev->dev;
 	info->status = POWER_SUPPLY_STATUS_UNKNOWN;
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	mutex_init(&info->lock);
 	platform_set_drvdata(pdev, info);
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a454..302cb40 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1057,7 +1057,7 @@ static char *supply_interface[] = {
 static int ab8500_btemp_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index f098fda..3df94db 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3437,7 +3437,7 @@ static char *supply_interface[] = {
 static int ab8500_charger_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_charger *di;
 	int irq, i, charger_status, ret = 0, ch_stat;
 
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7549707..1e30392 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3090,7 +3090,7 @@ static char *supply_interface[] = {
 static int ab8500_fg_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct ab8500_fg *di;
 	int i, irq;
 	int ret = 0;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..2e0d544 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -2046,7 +2046,7 @@ static char *supply_interface[] = {
 static int abx500_chargalg_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct abx500_bm_data *plat = pdev->dev.platform_data;
+	struct abx500_bm_data *plat = dev_get_platdata(&pdev->dev);
 	struct abx500_chargalg *di;
 	int ret = 0;
 
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973b..c989085 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -207,7 +207,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  */
 static int sr_late_init(struct omap_sr *sr_info)
 {
-	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&psr_info->pdev->dev);
 	int ret = 0;
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
@@ -842,7 +842,7 @@ DEFINE_SIMPLE_ATTRIBUTE(pm_sr_fops, omap_sr_autocomp_show,
 static int __init omap_sr_probe(struct platform_device *pdev)
 {
 	struct omap_sr *sr_info;
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource *mem, *irq;
 	struct dentry *nvalue_dir;
 	int i, ret = 0;
@@ -984,7 +984,7 @@ err_list_del:
 
 static int omap_sr_remove(struct platform_device *pdev)
 {
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct omap_sr *sr_info;
 
 	if (!pdata) {
@@ -1011,7 +1011,7 @@ static int omap_sr_remove(struct platform_device *pdev)
 
 static void omap_sr_shutdown(struct platform_device *pdev)
 {
-	struct omap_sr_data *pdata = pdev->dev.platform_data;
+	struct omap_sr_data *pdata = dev_get_platdata(&pdev->dev);
 	struct omap_sr *sr_info;
 
 	if (!pdata) {
diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..a17b882 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1509,7 +1509,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	char *name;
 	struct bq2415x_device *bq;
 
-	if (!client->dev.platform_data) {
+	if (!dev_get_platdata(&client->dev)) {
 		dev_err(&client->dev, "platform data not set\n");
 		return -ENODEV;
 	}
@@ -1546,7 +1546,7 @@ static int bq2415x_probe(struct i2c_client *client,
 	bq->autotimer = 0;
 	bq->automode = 0;
 
-	memcpy(&bq->init_data, client->dev.platform_data,
+	memcpy(&bq->init_data, dev_get_platdata(&client->dev),
 			sizeof(bq->init_data));
 
 	bq2415x_reset_chip(bq);
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b309713..c8d4be5 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -899,7 +899,7 @@ static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
 			bool single)
 {
 	struct device *dev = di->dev;
-	struct bq27000_platform_data *pdata = dev->platform_data;
+	struct bq27000_platform_data *pdata = dev_get_platdata(dev);
 	unsigned int timeout = 3;
 	int upper, lower;
 	int temp;
@@ -932,7 +932,7 @@ static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
 static int bq27000_battery_probe(struct platform_device *pdev)
 {
 	struct bq27x00_device_info *di;
-	struct bq27000_platform_data *pdata = pdev->dev.platform_data;
+	struct bq27000_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	if (!pdata) {
diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index ae6c418..08af5a5 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -494,7 +494,7 @@ static int da9030_battery_charger_init(struct da9030_charger *charger)
 static int da9030_battery_probe(struct platform_device *pdev)
 {
 	struct da9030_charger *charger;
-	struct da9030_battery_info *pdata = pdev->dev.platform_data;
+	struct da9030_battery_info *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	if (pdata == NULL)
diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index f8f4c0f..622267b 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -606,7 +606,7 @@ static s32 da9052_bat_probe(struct platform_device *pdev)
 	bat->health = POWER_SUPPLY_HEALTH_UNKNOWN;
 	bat->nb.notifier_call = da9052_USB_current_notifier;
 
-	pdata = bat->da9052->dev->platform_data;
+	pdata = dev_get_platdata(bat->da9052->dev);
 	if (pdata != NULL && pdata->use_for_apm)
 		bat->psy.use_for_apm = pdata->use_for_apm;
 	else
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 5631748..0155668 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -380,7 +380,7 @@ static struct ds278x_battery_ops ds278x_ops[] = {
 static int ds278x_battery_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	struct ds278x_platform_data *pdata = client->dev.platform_data;
+	struct ds278x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct ds278x_info *info;
 	int ret;
 	int num;
diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 59a1421..750bebc 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -240,7 +240,7 @@ static int gab_probe(struct platform_device *pdev)
 {
 	struct gab *adc_bat;
 	struct power_supply *psy;
-	struct gab_platform_data *pdata = pdev->dev.platform_data;
+	struct gab_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	enum power_supply_property *properties;
 	int ret = 0;
 	int chan;
diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 4e858a2..ab1e2fa 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -70,7 +70,8 @@ static enum power_supply_property gpio_charger_properties[] = {
 
 static int gpio_charger_probe(struct platform_device *pdev)
 {
-	const struct gpio_charger_platform_data *pdata = pdev->dev.platform_data;
+	const struct gpio_charger_platform_data *pdata =
+				dev_get_platdata(&pdev->dev);
 	struct gpio_charger *gpio_charger;
 	struct power_supply *charger;
 	int ret;
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index fc04d19..1046528 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -87,7 +87,7 @@ static inline int isp1704_write(struct isp1704_charger *isp, u32 val, u32 reg)
  */
 static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 {
-	struct isp1704_charger_data	*board = isp->dev->platform_data;
+	struct isp1704_charger_data	*board = dev_get_platdata(isp->dev);
 
 	if (board && board->set_power)
 		board->set_power(on);
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index d9686aa..d9ea2c6 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -241,7 +241,8 @@ static void jz_battery_work(struct work_struct *work)
 static int jz_battery_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct jz_battery_platform_data *pdata = pdev->dev.parent->platform_data;
+	struct jz_battery_platform_data *pdata =
+			dev_get_platdata(pdev->dev.parent);
 	struct jz_battery *jz_battery;
 	struct power_supply *battery;
 	struct resource *mem;
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 32de636..1001b90 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -556,7 +556,7 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 
 	pchg->client = cl;
 	pchg->dev = &cl->dev;
-	pchg->pdata = cl->dev.platform_data;
+	pchg->pdata = dev_get_platdata(&cl->dev);
 	i2c_set_clientdata(cl, pchg);
 
 	mutex_init(&pchg->xfer_lock);
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index c7ff6d6..31b524c7 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -212,7 +212,7 @@ static int max17040_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->client = client;
-	chip->pdata = client->dev.platform_data;
+	chip->pdata = dev_get_platdata(&client->dev);
 
 	i2c_set_clientdata(client, chip);
 
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d664ef5..aed1e95 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -657,7 +657,7 @@ max17042_get_pdata(struct device *dev)
 	struct max17042_platform_data *pdata;
 
 	if (!np)
-		return dev->platform_data;
+		return dev_get_platdata(dev);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -678,7 +678,7 @@ max17042_get_pdata(struct device *dev)
 static struct max17042_platform_data *
 max17042_get_pdata(struct device *dev)
 {
-	return dev->platform_data;
+	return dev_get_platdata(dev);
 }
 #endif
 
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 08f0d79..5b99ccc 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -183,7 +183,7 @@ static int max8903_probe(struct platform_device *pdev)
 {
 	struct max8903_data *data;
 	struct device *dev = &pdev->dev;
-	struct max8903_pdata *pdata = pdev->dev.platform_data;
+	struct max8903_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int ret = 0;
 	int gpio;
 	int ta_in = 0;
diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 0ee1e14..4412f49 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -441,7 +441,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	struct max8925_power_pdata *pdata;
 
 	if (!nproot)
-		return pdev->dev.platform_data;
+		return dev_get_platdata(&pdev->dev);
 
 	np = of_find_node_by_name(nproot, "charger");
 	if (!np) {
@@ -471,7 +471,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 static struct max8925_power_pdata *
 max8925_power_dt_init(struct platform_device *pdev)
 {
-	return pdev->dev.platform_data;
+	return dev_get_platdata(&pdev->dev);
 }
 #endif
 
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 0c52e2a..da96140 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -273,7 +273,7 @@ static int pda_power_probe(struct platform_device *pdev)
 		goto wrongid;
 	}
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->init) {
 		ret = pdata->init(dev);
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 1c0bfcb..129a82c 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1001,7 +1001,8 @@ static const struct dev_pm_ops pm2xxx_pm_ops = {
 static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		const struct i2c_device_id *id)
 {
-	struct pm2xxx_platform_data *pl_data = i2c_client->dev.platform_data;
+	struct pm2xxx_platform_data *pl_data =
+			dev_get_platdata(&i2c_client->dev);
 	struct pm2xxx_charger *pm2;
 	int ret = 0;
 	u8 val;
diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index 5948ce0..eba6596 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -292,7 +292,7 @@ static irqreturn_t s3c_adc_bat_charged(int irq, void *dev_id)
 static int s3c_adc_bat_probe(struct platform_device *pdev)
 {
 	struct s3c_adc_client	*client;
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	client = s3c_adc_register(pdev, NULL, NULL, 0);
@@ -315,7 +315,7 @@ static int s3c_adc_bat_probe(struct platform_device *pdev)
 		goto err_reg_main;
 	if (pdata->backup_volt_mult) {
 		backup_bat.client = client;
-		backup_bat.pdata = pdev->dev.platform_data;
+		backup_bat.pdata = dev_get_platdata(&pdev->dev);
 		backup_bat.volt_value = -1;
 		ret = power_supply_register(&pdev->dev, &backup_bat.psy);
 		if (ret)
@@ -370,7 +370,7 @@ err_reg_main:
 static int s3c_adc_bat_remove(struct platform_device *pdev)
 {
 	struct s3c_adc_client *client = platform_get_drvdata(pdev);
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	power_supply_unregister(&main_bat.psy);
 	if (pdata->backup_volt_mult)
@@ -395,7 +395,7 @@ static int s3c_adc_bat_remove(struct platform_device *pdev)
 static int s3c_adc_bat_suspend(struct platform_device *pdev,
 	pm_message_t state)
 {
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->gpio_charge_finished >= 0) {
 		if (device_may_wakeup(&pdev->dev))
@@ -412,7 +412,7 @@ static int s3c_adc_bat_suspend(struct platform_device *pdev,
 
 static int s3c_adc_bat_resume(struct platform_device *pdev)
 {
-	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;
+	struct s3c_adc_bat_pdata *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->gpio_charge_finished >= 0) {
 		if (device_may_wakeup(&pdev->dev))
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76..05fa847 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -617,7 +617,7 @@ static struct sbs_platform_data *sbs_of_populate_pdata(
 		struct i2c_client *client)
 {
 	struct device_node *of_node = client->dev.of_node;
-	struct sbs_platform_data *pdata = client->dev.platform_data;
+	struct sbs_platform_data *pdata = dev_get_platdata(&client->dev);
 	enum of_gpio_flags gpio_flags;
 	int rc;
 	u32 prop;
@@ -671,7 +671,7 @@ of_out:
 static struct sbs_platform_data *sbs_of_populate_pdata(
 	struct i2c_client *client)
 {
-	return client->dev.platform_data;
+	return dev_get_platdata(&client->dev);
 }
 #endif
 
@@ -679,7 +679,7 @@ static int sbs_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct sbs_info *chip;
-	struct sbs_platform_data *pdata = client->dev.platform_data;
+	struct sbs_platform_data *pdata = dev_get_platdata(&client->dev);
 	int rc;
 	int irq;
 	char *name;
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index acf84e8..c518ddd 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -1197,7 +1197,7 @@ static int smb347_probe(struct i2c_client *client,
 	struct smb347_charger *smb;
 	int ret;
 
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	if (!pdata)
 		return -EINVAL;
 
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index be98e70..caa142b 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -493,7 +493,7 @@ static enum power_supply_property twl4030_charger_props[] = {
 static int __init twl4030_bci_probe(struct platform_device *pdev)
 {
 	struct twl4030_bci *bci;
-	struct twl4030_bci_platform_data *pdata = pdev->dev.platform_data;
+	struct twl4030_bci_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 	u32 reg;
 
diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index 56fb509..9a4fa61 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -44,7 +44,7 @@ static int wm831x_backup_read_voltage(struct wm831x *wm831x,
 
 static void wm831x_config_backup(struct wm831x *wm831x)
 {
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_backup_pdata *pdata;
 	int ret, reg;
 
@@ -164,7 +164,7 @@ static enum power_supply_property wm831x_backup_props[] = {
 static int wm831x_backup_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_backup *devdata;
 	struct power_supply *backup;
 	int ret;
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 3bed2f5..e7414fc 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -215,7 +215,7 @@ static void wm831x_battey_apply_config(struct wm831x *wm831x,
 
 static void wm831x_config_battery(struct wm831x *wm831x)
 {
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_battery_pdata *pdata;
 	int ret, reg1, reg2;
 
@@ -492,7 +492,7 @@ static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
 static int wm831x_power_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(wm831x->dev);
 	struct wm831x_power *power;
 	struct power_supply *usb;
 	struct power_supply *battery;
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 58f7348..674bff4 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -32,7 +32,7 @@ static enum power_supply_property *prop;
 
 static unsigned long wm97xx_read_bat(struct power_supply *bat_ps)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
@@ -42,7 +42,7 @@ static unsigned long wm97xx_read_bat(struct power_supply *bat_ps)
 
 static unsigned long wm97xx_read_temp(struct power_supply *bat_ps)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
@@ -54,7 +54,7 @@ static int wm97xx_bat_get_property(struct power_supply *bat_ps,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
 {
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	switch (psp) {
@@ -105,7 +105,7 @@ static void wm97xx_bat_external_power_changed(struct power_supply *bat_ps)
 static void wm97xx_bat_update(struct power_supply *bat_ps)
 {
 	int old_status = bat_status;
-	struct wm97xx_pdata *wmdata = bat_ps->dev->parent->platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(bat_ps->dev->parent);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	mutex_lock(&work_lock);
@@ -167,7 +167,7 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 	int ret = 0;
 	int props = 1;	/* POWER_SUPPLY_PROP_PRESENT */
 	int i = 0;
-	struct wm97xx_pdata *wmdata = dev->dev.platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(&dev->dev);
 	struct wm97xx_batt_pdata *pdata;
 
 	if (!wmdata) {
@@ -265,7 +265,7 @@ err:
 
 static int wm97xx_bat_remove(struct platform_device *dev)
 {
-	struct wm97xx_pdata *wmdata = dev->dev.platform_data;
+	struct wm97xx_pdata *wmdata = dev_get_platdata(&dev->dev);
 	struct wm97xx_batt_pdata *pdata = wmdata->batt_pdata;
 
 	if (pdata && gpio_is_valid(pdata->charge_gpio)) {
diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index 814d2e3..5801d37 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -186,7 +186,7 @@ static int z2_batt_probe(struct i2c_client *client,
 	int ret = 0;
 	int props = 1;	/* POWER_SUPPLY_PROP_PRESENT */
 	struct z2_charger *charger;
-	struct z2_battery_info *info = client->dev.platform_data;
+	struct z2_battery_info *info = dev_get_platdata(&client->dev);
 
 	if (info == NULL) {
 		dev_err(&client->dev,
-- 
1.7.10.4


