Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3FDEPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:15:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11334 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3FDEPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:15:18 -0400
X-AuditID: cbfee68f-b7f436d000000f81-7c-51ad69d480da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V3] misc: replace strict_strtoul() with kstrtoul()
Date: Tue, 04 Jun 2013 13:15:16 +0900
Message-id: <001301ce60da$1e43f430$5acbdc90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5g2dvAREf1VOgpSW+s4n7mWIgl2Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zA92rmWsDDe4tZLJ4OeEwo8XfScfY
	LQ7/vcRi0bx4PZtF/7QOVovLCy8BiV1z2CwmHN7MbjF5Sxu7A6fHq6uOHr9/TWL02DnrLrvH
	/rlr2D36tqxi9Lh7/SWTx4UWbo/Pm+QCOKK4bFJSczLLUov07RK4Mr5cfM9csK+LseLwt5lM
	DYxT87oYOTkkBEwk1u86xQphi0lcuLeerYuRi0NIYBmjxM49/1hgihZ8nMgOkZjOKHGj4w4j
	hPOLUWLJ5bVgVWwCahJfvhxmB7FFBEwlNr6fAlbELLCHSeLJtu1gO4QFnCT6np0Ga2ARUJV4
	8foNM4jNK2Apce3/ThYIW1Dix+R7YDazgJbE+p3HmSBseYnNa94yQ5ykILHj7GtGiGV6Elc3
	3ICqEZHY9+Id2GIJga/sEleuPmWDWCYg8W3yIaChHEAJWYlNB6DmSEocXHGDZQKj2Cwkq2ch
	WT0LyepZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESw/07GO8esD7EmAy0fiKz
	lGhyPjAF5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBkcftQWDdm6mclmF+yx9+dszbPm3rJn97ucfOnhExggEXdmZonY2fvd+rJdTV4D571D/f
	hU+3pCguMV7rLtlyR+qcnWnrjrgfCzJnbfYOP9oYufsJZ9G6vUYv5q1dZq4j2vU2ec7crL0X
	qpl/uP3Zu+1FZVKT42SOU7H6x2WfRV+w/7F8VtqSGCWW4oxEQy3mouJEANPlJHn3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd0rmWsDDVZutrB4OeEwo8XfScfY
	LQ7/vcRi0bx4PZtF/7QOVovLCy8BiV1z2CwmHN7MbjF5Sxu7A6fHq6uOHr9/TWL02DnrLrvH
	/rlr2D36tqxi9Lh7/SWTx4UWbo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMWZ8ufieuWBfF2PF4W8zmRoYp+Z1MXJySAiYSCz4OJEdwhaTuHBvPVsXIxeHkMB0
	RokbHXcYIZxfjBJLLq9lAaliE1CT+PLlMFiHiICpxMb3U8CKmAX2MEk82badFSQhLOAk0ffs
	NFgDi4CqxIvXb5hBbF4BS4lr/3eyQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniJAWJHWdf
	M0Is05O4uuEGVI2IxL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4ATxTHoH46oGi0OMAhyMSjy8ClvWBAqxJpYVV+YeYpTgYFYS4e11WRsoxJuS
	WFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA5JVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYzezxU44zfIXKhuPWlZNDs6fHp20VX/OStjJVu2zqw5dka/1LDl
	gtr8pSHicTN+W3z6UP/j06u7L5fsauApVCk7ksZsK78t9vljVoatCd+/bWe2N+/8E1p4/iK7
	v82vgw/bi2orlvi4lH5eu3fKqymV5rfsNnOIR0c4G4q+/xAZqLVw9iTLjN1KLMUZiYZazEXF
	iQAHvXzyVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Changes since v1:
- Split to two sequential checks.
- Replaced kstrtoul() & copy_from_user() with kstrtoul_from_user().
- Added Andy Shevchenko's Reviewed-by.

Changes since v1:
- Used return code from kstrtoul().

 drivers/misc/ad525x_dpot.c              |    2 +-
 drivers/misc/apds9802als.c              |    5 +--
 drivers/misc/apds990x.c                 |   37 ++++++++++++-------
 drivers/misc/bh1770glc.c                |   59 ++++++++++++++++++++-----------
 drivers/misc/bh1780gli.c                |    2 +-
 drivers/misc/carma/carma-fpga-program.c |   10 +++---
 drivers/misc/carma/carma-fpga.c         |    4 +--
 drivers/misc/hmc6352.c                  |    5 +--
 drivers/misc/isl29003.c                 |   24 ++++++++++---
 drivers/misc/isl29020.c                 |    6 ++--
 drivers/misc/lis3lv02d/lis3lv02d.c      |    6 ++--
 drivers/misc/sgi-gru/gruprocfs.c        |   14 +++-----
 drivers/misc/spear13xx_pcie_gadget.c    |   57 +++++++++++++++++++----------
 drivers/misc/ti_dac7512.c               |    6 ++--
 14 files changed, 154 insertions(+), 83 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 8f99e8e..0daadcf 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -470,7 +470,7 @@ static ssize_t sysfs_set_reg(struct device *dev,
 		!test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtoul(buf, 10, &value);
 	if (err)
 		return err;
 
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 5b5fd84..0c6e037 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -126,8 +126,9 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtoul(buf, 10, &val);
+	if (ret_val)
+		return ret_val;
 
 	if (val < 4096)
 		val = 1;
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 98f9bb2..868a30a 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -696,9 +696,11 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
 {
 	struct apds990x_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	chip->lux_calib = value;
 
@@ -759,8 +761,9 @@ static ssize_t apds990x_rate_store(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	ret = apds990x_set_arate(chip, value);
@@ -813,9 +816,11 @@ static ssize_t apds990x_prox_enable_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 
@@ -892,11 +897,12 @@ static ssize_t apds990x_lux_thresh_below_show(struct device *dev,
 static ssize_t apds990x_set_lux_thresh(struct apds990x_chip *chip, u32 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret)
+		return ret;
 
 	if (thresh > APDS_RANGE)
 		return -EINVAL;
@@ -957,9 +963,11 @@ static ssize_t apds990x_prox_threshold_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if ((value > APDS_RANGE) || (value == 0) ||
 		(value < APDS_PROX_HYSTERESIS))
@@ -990,9 +998,12 @@ static ssize_t apds990x_power_state_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
 	if (value) {
 		pm_runtime_get_sync(dev);
 		mutex_lock(&chip->mutex);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index f4975f7..99a0468 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -651,8 +651,9 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 	unsigned long value;
 	ssize_t ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	if (value) {
@@ -726,9 +727,11 @@ static ssize_t bh1770_prox_enable_store(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	/* Assume no proximity. Sensor will tell real state soon */
@@ -824,9 +827,11 @@ static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate_threshold = bh1770_prox_rate_validate(value);
@@ -840,9 +845,11 @@ static ssize_t bh1770_set_prox_rate_below(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate = bh1770_prox_rate_validate(value);
@@ -865,8 +872,10 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
+
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
 
@@ -893,9 +902,11 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if (value > BH1770_PROX_MAX_PERSISTENCE)
 		return -EINVAL;
@@ -918,9 +929,11 @@ static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
@@ -963,9 +976,11 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 	unsigned long value;
 	u32 old_calib;
 	u32 new_corr;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	old_calib = chip->lux_calib;
@@ -1012,8 +1027,9 @@ static ssize_t bh1770_set_lux_rate(struct device *dev,
 	unsigned long rate_hz;
 	int ret, i;
 
-	if (strict_strtoul(buf, 0, &rate_hz))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &rate_hz);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(lux_rates_hz) - 1; i++)
 		if (rate_hz >= lux_rates_hz[i])
@@ -1047,11 +1063,12 @@ static ssize_t bh1770_get_lux_thresh_below(struct device *dev,
 static ssize_t bh1770_set_lux_thresh(struct bh1770_chip *chip, u16 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret)
+		return ret;
 
 	if (thresh > BH1770_LUX_RANGE)
 		return -EINVAL;
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 818f3a0..057580e 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -107,7 +107,7 @@ static ssize_t bh1780_store_power_state(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 0, &val);
+	error = kstrtoul(buf, 0, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index fa017cf..c6bd7e8 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -830,8 +830,9 @@ static ssize_t penable_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (val) {
 		ret = fpga_enable_power_supplies(priv);
@@ -859,8 +860,9 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	/* We can't have an image writer and be programming simultaneously */
 	if (mutex_lock_interruptible(&priv->lock))
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index a2128af..7b56563 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -1002,10 +1002,10 @@ static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
 	unsigned long enable;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &enable);
+	ret = kstrtoul(buf, 0, &enable);
 	if (ret) {
 		dev_err(priv->dev, "unable to parse enable input\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	/* protect against concurrent enable/disable */
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 423cd40..170bd3d 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -46,8 +46,9 @@ static int compass_store(struct device *dev, const char *buf, size_t count,
 	int ret;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 	if (val >= strlen(map))
 		return -EINVAL;
 	mutex_lock(&compass_mutex);
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index c5145b3..e3183f2 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -208,7 +208,11 @@ static ssize_t isl29003_store_range(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val > 3)
 		return -EINVAL;
 
 	ret = isl29003_set_range(client, val);
@@ -239,7 +243,11 @@ static ssize_t isl29003_store_resolution(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val > 3)
 		return -EINVAL;
 
 	ret = isl29003_set_resolution(client, val);
@@ -267,7 +275,11 @@ static ssize_t isl29003_store_mode(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 2))
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val > 2)
 		return -EINVAL;
 
 	ret = isl29003_set_mode(client, val);
@@ -298,7 +310,11 @@ static ssize_t isl29003_store_power_state(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 1))
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val > 1)
 		return -EINVAL;
 
 	ret = isl29003_set_power_state(client, val);
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 0aa08c7..b7f84da 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -90,8 +90,10 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtoul(buf, 10, &val);
+	if (ret_val)
+		return ret_val;
+
 	if (val < 1 || val > 64000)
 		return -EINVAL;
 
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 4cd4a3d..036effe 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -831,9 +831,11 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 {
 	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	unsigned long rate;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &rate))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &rate);
+	if (ret)
+		return ret;
 
 	lis3lv02d_sysfs_poweron(lis3);
 	if (lis3lv02d_set_odr(lis3, rate))
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 797d796..4f76359 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -160,15 +160,11 @@ static int options_show(struct seq_file *s, void *p)
 static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
-	char buf[20];
-
-	if (count >= sizeof(buf))
-		return -EINVAL;
-	if (copy_from_user(buf, userbuf, count))
-		return -EFAULT;
-	buf[count] = '\0';
-	if (strict_strtoul(buf, 0, &gru_options))
-		return -EINVAL;
+	int ret;
+
+	ret = kstrtoul_from_user(userbuf, count, 0, &gru_options);
+	if (ret)
+		return ret;
 
 	return count;
 }
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 84a8dab..807727f 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -316,8 +316,12 @@ static ssize_t pcie_gadget_store_no_of_msi(
 		struct spear_pcie_gadget_config *config,
 		const char *buf, size_t count)
 {
-	if (strict_strtoul(buf, 0, &config->requested_msi))
-		return -EINVAL;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &config->requested_msi);
+	if (ret)
+		return ret;
+
 	if (config->requested_msi > 32)
 		config->requested_msi = 32;
 
@@ -330,9 +334,11 @@ static ssize_t pcie_gadget_store_inta(
 {
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong en;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &en))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &en);
+	if (ret)
+		return ret;
 
 	if (en)
 		writel(readl(&app_reg->app_ctrl_0) | (1 << SYS_INT_ID),
@@ -351,9 +357,11 @@ static ssize_t pcie_gadget_store_send_msi(
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong vector;
 	u32 ven_msi;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &vector))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &vector);
+	if (ret)
+		return ret;
 
 	if (!config->configured_msi)
 		return -EINVAL;
@@ -395,9 +403,11 @@ static ssize_t pcie_gadget_store_vendor_id(
 		const char *buf, size_t count)
 {
 	ulong id;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &id))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &id);
+	if (ret)
+		return ret;
 
 	spear_dbi_write_reg(config, PCI_VENDOR_ID, 2, id);
 
@@ -420,9 +430,11 @@ static ssize_t pcie_gadget_store_device_id(
 		const char *buf, size_t count)
 {
 	ulong id;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &id))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &id);
+	if (ret)
+		return ret;
 
 	spear_dbi_write_reg(config, PCI_DEVICE_ID, 2, id);
 
@@ -443,9 +455,12 @@ static ssize_t pcie_gadget_store_bar0_size(
 	ulong size;
 	u32 pos, pos1;
 	u32 no_of_bit = 0;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &size);
+	if (ret)
+		return ret;
 
-	if (strict_strtoul(buf, 0, &size))
-		return -EINVAL;
 	/* min bar size is 256 */
 	if (size <= 0x100)
 		size = 0x100;
@@ -490,9 +505,11 @@ static ssize_t pcie_gadget_store_bar0_address(
 {
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong address;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &address))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &address);
+	if (ret)
+		return ret;
 
 	address &= ~(config->bar0_size - 1);
 	if (config->va_bar0_address)
@@ -518,9 +535,11 @@ static ssize_t pcie_gadget_store_bar0_rw_offset(
 		const char *buf, size_t count)
 {
 	ulong offset;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &offset))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &offset);
+	if (ret)
+		return ret;
 
 	if (offset % 4)
 		return -EINVAL;
@@ -549,9 +568,11 @@ static ssize_t pcie_gadget_store_bar0_data(
 		const char *buf, size_t count)
 {
 	ulong data;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &data))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &data);
+	if (ret)
+		return ret;
 
 	if (!config->va_bar0_address)
 		return -ENOMEM;
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 1d86407..9b23722 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -33,9 +33,11 @@ static ssize_t dac7512_store_val(struct device *dev,
 	struct spi_device *spi = to_spi_device(dev);
 	unsigned char tmp[2];
 	unsigned long val;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 
 	tmp[0] = val >> 8;
 	tmp[1] = val & 0xff;
-- 
1.7.10.4


