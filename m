Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaAUV0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:26:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:56719 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaAUV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        <lm-sensors@lm-sensors.org>
Subject: [PATCH 50/73] drivers/hwmon: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:53 -0500
Message-ID: <1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/adcxx.c              | 1 -
 drivers/hwmon/adm1021.c            | 1 -
 drivers/hwmon/adm1025.c            | 1 -
 drivers/hwmon/adm1026.c            | 1 -
 drivers/hwmon/adm1029.c            | 1 -
 drivers/hwmon/adm1031.c            | 1 -
 drivers/hwmon/adm9240.c            | 1 -
 drivers/hwmon/ads1015.c            | 1 -
 drivers/hwmon/ads7828.c            | 1 -
 drivers/hwmon/ads7871.c            | 1 -
 drivers/hwmon/adt7310.c            | 1 -
 drivers/hwmon/adt7410.c            | 1 -
 drivers/hwmon/adt7411.c            | 1 -
 drivers/hwmon/adt7475.c            | 1 -
 drivers/hwmon/adt7x10.c            | 1 -
 drivers/hwmon/amc6821.c            | 1 -
 drivers/hwmon/asb100.c             | 1 -
 drivers/hwmon/atxp1.c              | 1 -
 drivers/hwmon/da9052-hwmon.c       | 1 -
 drivers/hwmon/da9055-hwmon.c       | 1 -
 drivers/hwmon/ds1621.c             | 1 -
 drivers/hwmon/ds620.c              | 1 -
 drivers/hwmon/emc1403.c            | 1 -
 drivers/hwmon/emc2103.c            | 1 -
 drivers/hwmon/emc6w201.c           | 1 -
 drivers/hwmon/fam15h_power.c       | 1 -
 drivers/hwmon/fschmd.c             | 1 -
 drivers/hwmon/g760a.c              | 1 -
 drivers/hwmon/g762.c               | 1 -
 drivers/hwmon/gl518sm.c            | 1 -
 drivers/hwmon/gl520sm.c            | 1 -
 drivers/hwmon/gpio-fan.c           | 1 -
 drivers/hwmon/hih6130.c            | 1 -
 drivers/hwmon/ina209.c             | 1 -
 drivers/hwmon/ina2xx.c             | 1 -
 drivers/hwmon/jc42.c               | 1 -
 drivers/hwmon/k10temp.c            | 1 -
 drivers/hwmon/k8temp.c             | 1 -
 drivers/hwmon/lineage-pem.c        | 1 -
 drivers/hwmon/lm63.c               | 1 -
 drivers/hwmon/lm70.c               | 1 -
 drivers/hwmon/lm73.c               | 1 -
 drivers/hwmon/lm75.c               | 1 -
 drivers/hwmon/lm77.c               | 1 -
 drivers/hwmon/lm80.c               | 1 -
 drivers/hwmon/lm83.c               | 1 -
 drivers/hwmon/lm85.c               | 1 -
 drivers/hwmon/lm87.c               | 1 -
 drivers/hwmon/lm90.c               | 1 -
 drivers/hwmon/lm92.c               | 1 -
 drivers/hwmon/lm93.c               | 1 -
 drivers/hwmon/lm95234.c            | 1 -
 drivers/hwmon/lm95241.c            | 1 -
 drivers/hwmon/lm95245.c            | 1 -
 drivers/hwmon/ltc4151.c            | 1 -
 drivers/hwmon/ltc4215.c            | 1 -
 drivers/hwmon/ltc4245.c            | 1 -
 drivers/hwmon/ltc4261.c            | 1 -
 drivers/hwmon/max1111.c            | 1 -
 drivers/hwmon/max16065.c           | 1 -
 drivers/hwmon/max1619.c            | 1 -
 drivers/hwmon/max1668.c            | 1 -
 drivers/hwmon/max197.c             | 1 -
 drivers/hwmon/max6639.c            | 1 -
 drivers/hwmon/max6642.c            | 1 -
 drivers/hwmon/max6650.c            | 1 -
 drivers/hwmon/max6697.c            | 1 -
 drivers/hwmon/pmbus/adm1275.c      | 1 -
 drivers/hwmon/pmbus/lm25066.c      | 1 -
 drivers/hwmon/pmbus/ltc2978.c      | 1 -
 drivers/hwmon/pmbus/max16064.c     | 1 -
 drivers/hwmon/pmbus/max34440.c     | 1 -
 drivers/hwmon/pmbus/max8688.c      | 1 -
 drivers/hwmon/pmbus/pmbus.c        | 1 -
 drivers/hwmon/pmbus/pmbus_core.c   | 1 -
 drivers/hwmon/pmbus/ucd9000.c      | 1 -
 drivers/hwmon/pmbus/ucd9200.c      | 1 -
 drivers/hwmon/pmbus/zl6100.c       | 1 -
 drivers/hwmon/s3c-hwmon.c          | 1 -
 drivers/hwmon/sch5627.c            | 1 -
 drivers/hwmon/sch5636.c            | 1 -
 drivers/hwmon/sht15.c              | 1 -
 drivers/hwmon/sht21.c              | 1 -
 drivers/hwmon/smm665.c             | 1 -
 drivers/hwmon/smsc47m192.c         | 1 -
 drivers/hwmon/thmc50.c             | 1 -
 drivers/hwmon/tmp102.c             | 1 -
 drivers/hwmon/tmp401.c             | 1 -
 drivers/hwmon/tmp421.c             | 1 -
 drivers/hwmon/twl4030-madc-hwmon.c | 1 -
 drivers/hwmon/w83791d.c            | 1 -
 drivers/hwmon/w83792d.c            | 1 -
 drivers/hwmon/w83793.c             | 1 -
 drivers/hwmon/w83795.c             | 1 -
 drivers/hwmon/w83l785ts.c          | 1 -
 drivers/hwmon/w83l786ng.c          | 1 -
 96 files changed, 96 deletions(-)

diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
index 04c08c2..757103d 100644
--- a/drivers/hwmon/adcxx.c
+++ b/drivers/hwmon/adcxx.c
@@ -34,7 +34,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 29dd9f7..48bcbe1 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 7e16e5d..a3857da 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -46,7 +46,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index b3498ac..f3fa888 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 9ee5e06..f7fc55d 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 253ea39..c8f4ac3 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index 086d02a..4abdbf9 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -41,7 +41,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index 7f9dc2f..b40044d 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index 7092c78..166c024 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -29,7 +29,6 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index 3eff73b..d440431 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -61,7 +61,6 @@
 #define OSC_RBG_BM	(1 << 0)
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spi/spi.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
diff --git a/drivers/hwmon/adt7310.c b/drivers/hwmon/adt7310.c
index 5994cf6..b7080bc 100644
--- a/drivers/hwmon/adt7310.c
+++ b/drivers/hwmon/adt7310.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spi/spi.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/hwmon/adt7410.c b/drivers/hwmon/adt7410.c
index 0dc066a..9e93743 100644
--- a/drivers/hwmon/adt7410.c
+++ b/drivers/hwmon/adt7410.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 
 #include "adt7x10.h"
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index d9299de..81b4ee0 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 22d008b..c175631 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/adt7x10.c b/drivers/hwmon/adt7x10.c
index 98141f4..039ee65 100644
--- a/drivers/hwmon/adt7x10.c
+++ b/drivers/hwmon/adt7x10.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index eea8172..d8be85d 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>	/* Needed for KERN_INFO */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index f960636..219e1f8 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -45,7 +45,6 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include "lm75.h"
diff --git a/drivers/hwmon/atxp1.c b/drivers/hwmon/atxp1.c
index ddff02e..d350d7e 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index afd3104..bcce638 100644
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -15,7 +15,6 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 029ecab..38269c8 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -16,7 +16,6 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index 872d767..8440ece 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -35,7 +35,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ds620.c b/drivers/hwmon/ds620.c
index 0918b91..a32d062 100644
--- a/drivers/hwmon/ds620.c
+++ b/drivers/hwmon/ds620.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 90ec117..89b13b6 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index 2c137b2..a1ed77e 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/emc6w201.c b/drivers/hwmon/emc6w201.c
index 82e661e..9735909 100644
--- a/drivers/hwmon/emc6w201.c
+++ b/drivers/hwmon/emc6w201.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 6040121..ea59b8d 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -21,7 +21,6 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index d58abdc..b445f13 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -33,7 +33,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index ea6480b..641738d 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/g762.c b/drivers/hwmon/g762.c
index b4b8b5b..b5ddfce 100644
--- a/drivers/hwmon/g762.c
+++ b/drivers/hwmon/g762.c
@@ -42,7 +42,6 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/gl518sm.c b/drivers/hwmon/gl518sm.c
index 95257a5..ab9d967 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -33,7 +33,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index ed56e09..e45adec 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 73181be..2f3199e 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/hwmon/hih6130.c b/drivers/hwmon/hih6130.c
index 7d68a08..679e3b1 100644
--- a/drivers/hwmon/hih6130.c
+++ b/drivers/hwmon/hih6130.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/ina209.c b/drivers/hwmon/ina209.c
index 5378fde..9559443 100644
--- a/drivers/hwmon/ina209.c
+++ b/drivers/hwmon/ina209.c
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 93d26e8..cb7629e 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 6013611..e679a1e 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index baf375b..3123529 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -20,7 +20,6 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <asm/processor.h>
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 734d55d..976358c 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/pci.h>
diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index ebbb9f4..49b2fa9 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index d0def50..a7e1fa8 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -38,7 +38,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index 505a59e..61fe3fc 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -26,7 +26,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 9653bb8..b71fc5a 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 84a55ea..56a2d54 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm77.c b/drivers/hwmon/lm77.c
index f17beb5..6a4b1a0 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index eba89aa..3398f9e 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
index e998034..58d7284 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index 3894c40..178e9a1 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index 333092c..87319d7 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -57,7 +57,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 8b8f3aa..bc41682 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -85,7 +85,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 71626f3..c0de4b4 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -41,7 +41,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index a6f4605..6c16d4e 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -39,7 +39,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/lm95234.c b/drivers/hwmon/lm95234.c
index 411202b..c1dba98 100644
--- a/drivers/hwmon/lm95234.c
+++ b/drivers/hwmon/lm95234.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 4b68fb2..beb5d71 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index a6c85f0..e16291d 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ltc4151.c b/drivers/hwmon/ltc4151.c
index af81be1..b1e4d16 100644
--- a/drivers/hwmon/ltc4151.c
+++ b/drivers/hwmon/ltc4151.c
@@ -30,7 +30,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index 8a14296..1217165 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index d4172933..e5b24dc 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/ltc4261.c b/drivers/hwmon/ltc4261.c
index 0becd69..4be7e65 100644
--- a/drivers/hwmon/ltc4261.c
+++ b/drivers/hwmon/ltc4261.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index eda077d..e45a35f 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -15,7 +15,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index d4efc79..cf1fa11 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index 445e5d4..a2bef68 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -27,7 +27,6 @@
 
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index a762635..11a2b21 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
index 96dccaf..49c6d31 100644
--- a/drivers/hwmon/max197.c
+++ b/drivers/hwmon/max197.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index 066e587..7be11bb 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index 8326fbd..a8d0a7c 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -33,7 +33,6 @@
 
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 0cafc39..a56bae8 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 7fd3eaf..8b60817 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index 60aad95..4594060 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -17,7 +17,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index a26b1d1..dcacb62 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index de3c152..a7dec29 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/max16064.c b/drivers/hwmon/pmbus/max16064.c
index fa237a3..ff1d90d 100644
--- a/drivers/hwmon/pmbus/max16064.c
+++ b/drivers/hwmon/pmbus/max16064.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include "pmbus.h"
diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index 7e930c3..070a3af 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include "pmbus.h"
diff --git a/drivers/hwmon/pmbus/max8688.c b/drivers/hwmon/pmbus/max8688.c
index f04454a..fb704d7 100644
--- a/drivers/hwmon/pmbus/max8688.c
+++ b/drivers/hwmon/pmbus/max8688.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include "pmbus.h"
diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index 7e91700..7369c2d 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 3cbf66e..6f89a41 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index fbb1479..48e1c0d 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 033d6ac..67ff25a 100644
--- a/drivers/hwmon/pmbus/ucd9200.c
+++ b/drivers/hwmon/pmbus/ucd9200.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/pmbus/zl6100.c b/drivers/hwmon/pmbus/zl6100.c
index 8196441..318022f 100644
--- a/drivers/hwmon/pmbus/zl6100.c
+++ b/drivers/hwmon/pmbus/zl6100.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index 73bd64e..7aab78a 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index 0cc99fd..aa8afbd 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -20,7 +20,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/platform_device.h>
diff --git a/drivers/hwmon/sch5636.c b/drivers/hwmon/sch5636.c
index 547b5c9..8a82c64 100644
--- a/drivers/hwmon/sch5636.c
+++ b/drivers/hwmon/sch5636.c
@@ -20,7 +20,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/platform_device.h>
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 97cd45a..b9503a0 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -20,7 +20,6 @@
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/mutex.h>
diff --git a/drivers/hwmon/sht21.c b/drivers/hwmon/sht21.c
index 2e9f957..9c5635e 100644
--- a/drivers/hwmon/sht21.c
+++ b/drivers/hwmon/sht21.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
index d9e1b7d..aa2c677 100644
--- a/drivers/hwmon/smm665.c
+++ b/drivers/hwmon/smm665.c
@@ -17,7 +17,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index efee4c5..c663ecb 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/thmc50.c b/drivers/hwmon/thmc50.c
index db288db..9d716aa 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 6748b45..b5a048d 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 7fa6e7d..a472ac2 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ae26b06..1107cfd 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 6c6d440..6a58de3 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -23,7 +23,6 @@
  * 02110-1301 USA
  *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/i2c/twl.h>
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index bdcf2dc..f42f50e 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -33,7 +33,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index df58580..f25d93e 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 9d63d71..9ee58bf 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
index 908209d..875fd94 100644
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
diff --git a/drivers/hwmon/w83l785ts.c b/drivers/hwmon/w83l785ts.c
index 39dbe99..d295524 100644
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -32,7 +32,6 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 6ed76ce..339e1c4 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
-- 
1.8.4.1

