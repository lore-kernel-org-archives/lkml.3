Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaAUVZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:56516 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaAUVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        <linux-leds@vger.kernel.org>
Subject: [PATCH 54/73] drivers/leds: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:57 -0500
Message-ID: <1390339396-3479-55-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/leds/led-triggers.c       | 1 -
 drivers/leds/leds-88pm860x.c      | 1 -
 drivers/leds/leds-adp5520.c       | 1 -
 drivers/leds/leds-asic3.c         | 1 -
 drivers/leds/leds-blinkm.c        | 1 -
 drivers/leds/leds-cobalt-qube.c   | 1 -
 drivers/leds/leds-da903x.c        | 1 -
 drivers/leds/leds-da9052.c        | 1 -
 drivers/leds/leds-fsg.c           | 1 -
 drivers/leds/leds-gpio.c          | 1 -
 drivers/leds/leds-hp6xx.c         | 1 -
 drivers/leds/leds-lm3533.c        | 1 -
 drivers/leds/leds-lp5521.c        | 1 -
 drivers/leds/leds-lp5523.c        | 1 -
 drivers/leds/leds-lp5562.c        | 1 -
 drivers/leds/leds-lt3593.c        | 1 -
 drivers/leds/leds-mc13783.c       | 1 -
 drivers/leds/leds-netxbig.c       | 1 -
 drivers/leds/leds-ns2.c           | 1 -
 drivers/leds/leds-ot200.c         | 1 -
 drivers/leds/leds-pwm.c           | 1 -
 drivers/leds/leds-s3c24xx.c       | 1 -
 drivers/leds/leds-wm831x-status.c | 1 -
 drivers/leds/leds-wm8350.c        | 1 -
 24 files changed, 24 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index e387f41..df1a7c1 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 5f588c0..d1e1bca 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
index 7e311a1..86b5bdb 100644
--- a/drivers/leds/leds-adp5520.c
+++ b/drivers/leds/leds-adp5520.c
@@ -15,7 +15,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
diff --git a/drivers/leds/leds-asic3.c b/drivers/leds/leds-asic3.c
index 6de216a..70c74a7 100644
--- a/drivers/leds/leds-asic3.c
+++ b/drivers/leds/leds-asic3.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
diff --git a/drivers/leds/leds-blinkm.c b/drivers/leds/leds-blinkm.c
index 66d0a57..0c50860 100644
--- a/drivers/leds/leds-blinkm.c
+++ b/drivers/leds/leds-blinkm.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
diff --git a/drivers/leds/leds-cobalt-qube.c b/drivers/leds/leds-cobalt-qube.c
index 8abcb66..910339d 100644
--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -3,7 +3,6 @@
  *
  * Control the Cobalt Qube/RaQ front LED
  */
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/leds.h>
diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index 2a4b87f..35dffb1 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
diff --git a/drivers/leds/leds-da9052.c b/drivers/leds/leds-da9052.c
index 865d4fa..01486ad 100644
--- a/drivers/leds/leds-da9052.c
+++ b/drivers/leds/leds-da9052.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index b4d5a44..2b4dc73 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/module.h>
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 78b0e27..3f65a08 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -11,7 +11,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
diff --git a/drivers/leds/leds-hp6xx.c b/drivers/leds/leds-hp6xx.c
index 366b605..d61a988 100644
--- a/drivers/leds/leds-hp6xx.c
+++ b/drivers/leds/leds-hp6xx.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <asm/hd64461.h>
diff --git a/drivers/leds/leds-lm3533.c b/drivers/leds/leds-lm3533.c
index 027ede7..e2c642c11 100644
--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/mfd/core.h>
 #include <linux/mutex.h>
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 2ec34cf..8ca197a 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -25,7 +25,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 4ade66a..cb5ed82 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -25,7 +25,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
index bf006f4..315d3ca 100644
--- a/drivers/leds/leds-lp5562.c
+++ b/drivers/leds/leds-lp5562.c
@@ -13,7 +13,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index 3417e5b..059f5b1 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index ca87a1b..dca34c7 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index 2f9f141..e97f443 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index c7a4230..efa6258 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index 98cae52..c9d9060 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/leds.h>
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 6050474..dd17873 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/fb.h>
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 98174e7..28988b7 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -12,7 +12,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/gpio.h>
diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index 0a1a13f..e72c974 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/leds.h>
diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index 3f75fd2..4133ffe 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/err.h>
-- 
1.8.4.1

