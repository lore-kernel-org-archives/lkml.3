Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3I0MgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:36:17 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42117 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3I0MgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:36:14 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] [TRIVIAL] Correct some typos
Date: Fri, 27 Sep 2013 14:36:04 +0200
Message-Id: <1380285364-24972-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/hwmon/abituguru.c        | 6 +++---
 drivers/hwmon/abituguru3.c       | 2 +-
 drivers/hwmon/asus_atk0110.c     | 2 +-
 drivers/hwmon/max6650.c          | 2 +-
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 drivers/hwmon/w83791d.c          | 2 +-
 drivers/hwmon/w83792d.c          | 2 +-
 drivers/hwmon/w83793.c           | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index 2ebd6ce..9c8a6ba 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -164,7 +164,7 @@ static const u8 abituguru_bank2_max_threshold = 50;
 static const int abituguru_pwm_settings_multiplier[5] = { 0, 1, 1, 1000, 1000 };
 /*
  * Min / Max allowed values for pwm_settings. Note: pwm1 (CPU fan) is a
- * special case the minium allowed pwm% setting for this is 30% (77) on
+ * special case the minimum allowed pwm% setting for this is 30% (77) on
  * some MB's this special case is handled in the code!
  */
 static const u8 abituguru_pwm_min[5] = { 0, 170, 170, 25, 25 };
@@ -517,7 +517,7 @@ abituguru_detect_bank1_sensor_type(struct abituguru_data *data,
 
 	ABIT_UGURU_DEBUG(2, "testing bank1 sensor %d\n", (int)sensor_addr);
 	/*
-	 * Volt sensor test, enable volt low alarm, set min value ridicously
+	 * Volt sensor test, enable volt low alarm, set min value ridiculously
 	 * high, or vica versa if the reading is very high. If its a volt
 	 * sensor this should always give us an alarm.
 	 */
@@ -564,7 +564,7 @@ abituguru_detect_bank1_sensor_type(struct abituguru_data *data,
 
 	/*
 	 * Temp sensor test, enable sensor as a temp sensor, set beep value
-	 * ridicously low (but not too low, otherwise uguru ignores it).
+	 * ridiculously low (but not too low, otherwise uguru ignores it).
 	 * If its a temp sensor this should always give us an alarm.
 	 */
 	buf[0] = ABIT_UGURU_TEMP_HIGH_ALARM_ENABLE;
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 0cac8c0..4ae74aa8 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -176,7 +176,7 @@ struct abituguru3_data {
 
 	/*
 	 * The abituguru3 supports up to 48 sensors, and thus has registers
-	 * sets for 48 sensors, for convienence reasons / simplicity of the
+	 * sets for 48 sensors, for convenience reasons / simplicity of the
 	 * code we always read and store all registers for all 48 sensors
 	 */
 
diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index b25c643..1d7ff46 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -119,7 +119,7 @@ struct atk_data {
 	acpi_handle rtmp_handle;
 	acpi_handle rvlt_handle;
 	acpi_handle rfan_handle;
-	/* new inteface */
+	/* new interface */
 	acpi_handle enumerate_handle;
 	acpi_handle read_handle;
 	acpi_handle write_handle;
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 3c16cbd..0cafc39 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -660,7 +660,7 @@ static int max6650_init_client(struct i2c_client *client)
 	/*
 	 * If mode is set to "full off", we change it to "open loop" and
 	 * set DAC to 255, which has the same effect. We do this because
-	 * there's no "full off" mode defined in hwmon specifcations.
+	 * there's no "full off" mode defined in hwmon specifications.
 	 */
 
 	if ((config & MAX6650_CFG_MODE_MASK) == MAX6650_CFG_MODE_OFF) {
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 9319fcf..264d093 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -156,7 +156,7 @@ EXPORT_SYMBOL_GPL(pmbus_write_byte);
 
 /*
  * _pmbus_write_byte() is similar to pmbus_write_byte(), but checks if
- * a device specific mapping funcion exists and calls it if necessary.
+ * a device specific mapping function exists and calls it if necessary.
  */
 static int _pmbus_write_byte(struct i2c_client *client, int page, u8 value)
 {
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index a3feee3..bdcf2dc 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1043,7 +1043,7 @@ static struct sensor_device_attribute sda_temp_alarm[] = {
 	SENSOR_ATTR(temp3_alarm, S_IRUGO, show_alarm, NULL, 13),
 };
 
-/* get reatime status of all sensors items: voltage, temp, fan */
+/* get realtime status of all sensors items: voltage, temp, fan */
 static ssize_t show_alarms_reg(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index 5febb43..df58580 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -579,7 +579,7 @@ static ssize_t store_temp23(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-/* get reatime status of all sensors items: voltage, temp, fan */
+/* get realtime status of all sensors items: voltage, temp, fan */
 static ssize_t
 show_alarms_reg(struct device *dev, struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index b0c30a5..b6470ec 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -808,7 +808,7 @@ show_sf_ctrl(struct device *dev, struct device_attribute *attr, char *buf)
 	if (nr == TEMP_FAN_MAP) {
 		val = data->temp_fan_map[index];
 	} else if (nr == TEMP_PWM_ENABLE) {
-		/* +2 to transfrom into 2 and 3 to conform with sysfs intf */
+		/* +2 to transform into 2 and 3 to conform with sysfs intf */
 		val = ((data->pwm_enable >> index) & 0x01) + 2;
 	} else if (nr == TEMP_CRUISE) {
 		val = TEMP_FROM_REG(data->temp_cruise[index] & 0x7f);
-- 
1.8.1.5

