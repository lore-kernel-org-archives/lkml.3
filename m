Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3DLQWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:22:37 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38023 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3DLQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:22:36 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, linux@roeck-us.net,
        khali@linux-fr.org, lm-sensors@lm-sensors.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: hwmon: Fix typo in documentation/hwmon
Date: Sat, 13 Apr 2013 01:22:11 +0900
Message-Id: <1365783731-17253-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentation/hwmon

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/hwmon/adt7410 | 2 +-
 Documentation/hwmon/sht15   | 2 +-
 Documentation/hwmon/zl6100  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/adt7410 b/Documentation/hwmon/adt7410
index 58150c4..bb6a4f3 100644
--- a/Documentation/hwmon/adt7410
+++ b/Documentation/hwmon/adt7410
@@ -27,7 +27,7 @@ temperature set point has been exceeded. Both pins can be set up with a common
 hysteresis of 0°C - 15°C and a fault queue, ranging from 1 to 4 events. Both
 pins can individually set to be active-low or active-high, while the whole
 device can either run in comparator mode or interrupt mode. The ADT7410
-supports continous temperature sampling, as well as sampling one temperature
+supports continuous temperature sampling, as well as sampling one temperature
 value per second or even justget one sample on demand for power saving.
 Besides, it can completely power down its ADC, if power management is
 required.
diff --git a/Documentation/hwmon/sht15 b/Documentation/hwmon/sht15
index 02850bd..778987d 100644
--- a/Documentation/hwmon/sht15
+++ b/Documentation/hwmon/sht15
@@ -40,7 +40,7 @@ bits for humidity, or 12 bits for temperature and 8 bits for humidity.
 The humidity calibration coefficients are programmed into an OTP memory on the
 chip. These coefficients are used to internally calibrate the signals from the
 sensors. Disabling the reload of those coefficients allows saving 10ms for each
-measurement and decrease power consumption, while loosing on precision.
+measurement and decrease power consumption, while losing on precision.
 
 Some options may be set directly in the sht15_platform_data structure
 or via sysfs attributes.
diff --git a/Documentation/hwmon/zl6100 b/Documentation/hwmon/zl6100
index 756b57c..33908a4 100644
--- a/Documentation/hwmon/zl6100
+++ b/Documentation/hwmon/zl6100
@@ -125,7 +125,7 @@ in2_label		"vmon"
 in2_input		Measured voltage on VMON (ZL2004) or VDRV (ZL9101M,
 			ZL9117M) pin. Reported voltage is 16x the voltage on the
 			pin (adjusted internally by the chip).
-in2_lcrit		Critical minumum VMON/VDRV Voltage.
+in2_lcrit		Critical minimum VMON/VDRV Voltage.
 in2_crit		Critical maximum VMON/VDRV voltage.
 in2_lcrit_alarm		VMON/VDRV voltage critical low alarm.
 in2_crit_alarm		VMON/VDRV voltage critical high alarm.
-- 
1.8.2.1.342.gfa7285d

