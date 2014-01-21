Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaAUVjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:39:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:56410 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaAUVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 41/73] video: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:44 -0500
Message-ID: <1390339396-3479-42-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/aty/aty128fb.c            | 1 -
 drivers/video/aty/mach64_cursor.c       | 1 -
 drivers/video/auo_k1900fb.c             | 1 -
 drivers/video/auo_k1901fb.c             | 1 -
 drivers/video/backlight/88pm860x_bl.c   | 1 -
 drivers/video/backlight/adp5520_bl.c    | 1 -
 drivers/video/backlight/adp8860_bl.c    | 1 -
 drivers/video/backlight/adp8870_bl.c    | 1 -
 drivers/video/backlight/corgi_lcd.c     | 1 -
 drivers/video/backlight/da903x_bl.c     | 1 -
 drivers/video/backlight/generic_bl.c    | 1 -
 drivers/video/backlight/ili922x.c       | 1 -
 drivers/video/backlight/ili9320.c       | 1 -
 drivers/video/backlight/lm3533_bl.c     | 1 -
 drivers/video/backlight/ltv350qv.c      | 1 -
 drivers/video/backlight/max8925_bl.c    | 1 -
 drivers/video/backlight/omap1_bl.c      | 1 -
 drivers/video/backlight/pwm_bl.c        | 1 -
 drivers/video/backlight/tdo24m.c        | 1 -
 drivers/video/backlight/vgg2432a4.c     | 1 -
 drivers/video/backlight/wm831x_bl.c     | 1 -
 drivers/video/bfin-lq035q1-fb.c         | 1 -
 drivers/video/clps711xfb.c              | 1 -
 drivers/video/console/dummycon.c        | 1 -
 drivers/video/console/sticore.c         | 1 -
 drivers/video/goldfishfb.c              | 1 -
 drivers/video/i810/i810_main.c          | 1 -
 drivers/video/intelfb/intelfbhw.c       | 1 -
 drivers/video/matrox/matroxfb_base.h    | 1 -
 drivers/video/mb862xx/mb862xxfb_accel.c | 1 -
 drivers/video/mb862xx/mb862xxfbdrv.c    | 1 -
 drivers/video/mbx/mbxfb.c               | 1 -
 drivers/video/nuc900fb.c                | 1 -
 drivers/video/nvidia/nvidia.c           | 1 -
 drivers/video/pxa168fb.c                | 1 -
 drivers/video/riva/fbdev.c              | 1 -
 drivers/video/s3c-fb.c                  | 1 -
 drivers/video/sh_mobile_lcdcfb.c        | 1 -
 drivers/video/sm501fb.c                 | 1 -
 drivers/video/smscufx.c                 | 1 -
 drivers/video/sstfb.c                   | 1 -
 drivers/video/tgafb.c                   | 1 -
 drivers/video/udlfb.c                   | 1 -
 drivers/video/uvesafb.c                 | 1 -
 drivers/video/via/global.h              | 1 -
 drivers/video/vt8500lcdfb.c             | 1 -
 drivers/video/w100fb.c                  | 1 -
 drivers/video/wm8505fb.c                | 1 -
 drivers/video/xilinxfb.c                | 1 -
 49 files changed, 49 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 52108be..f572384 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -57,7 +57,6 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/console.h>
diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/aty/mach64_cursor.c
index 95ec042..af16ef6 100644
--- a/drivers/video/aty/mach64_cursor.c
+++ b/drivers/video/aty/mach64_cursor.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/string.h>
 
 #include <asm/io.h>
diff --git a/drivers/video/auo_k1900fb.c b/drivers/video/auo_k1900fb.c
index f5b668e..e81f4c5 100644
--- a/drivers/video/auo_k1900fb.c
+++ b/drivers/video/auo_k1900fb.c
@@ -35,7 +35,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/list.h>
 #include <linux/firmware.h>
diff --git a/drivers/video/auo_k1901fb.c b/drivers/video/auo_k1901fb.c
index 12b9adc..3ccb91c 100644
--- a/drivers/video/auo_k1901fb.c
+++ b/drivers/video/auo_k1901fb.c
@@ -39,7 +39,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/list.h>
 #include <linux/firmware.h>
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 7db5234..955632e 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index f37097a..bb7ab3c 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 9d65671..0a23509 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 6370720..2b3c91c 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index db8db5f..db4c094 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/fb.h>
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 12c5d84..7a48447 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 5d8d652..06dca66 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/fb.h>
diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index 73464e4..877426e 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -15,7 +15,6 @@
 #include <linux/fb.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/lcd.h>
 #include <linux/module.h>
diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index e2b8b40..42175d1 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -14,7 +14,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/lcd.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 187d1c2..b6c642d 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/backlight.h>
 #include <linux/fb.h>
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 383f550..77c509d 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -10,7 +10,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/lcd.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 66fa08c..75f5b7b 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index a0dcd88..dbd863c 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b75201f..15ada9f 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -14,7 +14,6 @@
 #include <linux/of_gpio.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 908016f..b5ab1da 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/tdo24m.h>
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index d538947..fac8577 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -14,7 +14,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/lcd.h>
 #include <linux/module.h>
 
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 8b9455e..16ebb3e 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/fb.h>
diff --git a/drivers/video/bfin-lq035q1-fb.c b/drivers/video/bfin-lq035q1-fb.c
index b594a58..f2dce09 100644
--- a/drivers/video/bfin-lq035q1-fb.c
+++ b/drivers/video/bfin-lq035q1-fb.c
@@ -15,7 +15,6 @@
 #include <linux/fb.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
diff --git a/drivers/video/clps711xfb.c b/drivers/video/clps711xfb.c
index f009806..bec42d5 100644
--- a/drivers/video/clps711xfb.c
+++ b/drivers/video/clps711xfb.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
index b63860f..b734028 100644
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -10,7 +10,6 @@
 #include <linux/console.h>
 #include <linux/vt_kern.h>
 #include <linux/screen_info.h>
-#include <linux/init.h>
 #include <linux/module.h>
 
 /*
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 4ad24f2..a077504 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/font.h>
 
diff --git a/drivers/video/goldfishfb.c b/drivers/video/goldfishfb.c
index 7f6c9e6..7bdb1ba 100644
--- a/drivers/video/goldfishfb.c
+++ b/drivers/video/goldfishfb.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index bb674e4..d5df169 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -35,7 +35,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/resource.h>
diff --git a/drivers/video/intelfb/intelfbhw.c b/drivers/video/intelfb/intelfbhw.c
index fbad61d..f3374c9 100644
--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
diff --git a/drivers/video/matrox/matroxfb_base.h b/drivers/video/matrox/matroxfb_base.h
index 11ed57b..e8d4ac5 100644
--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -36,7 +36,6 @@
 #include <linux/console.h>
 #include <linux/selection.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/video/mb862xx/mb862xxfb_accel.c b/drivers/video/mb862xx/mb862xxfb_accel.c
index fe92eed..a24a482 100644
--- a/drivers/video/mb862xx/mb862xxfb_accel.c
+++ b/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -14,7 +14,6 @@
  */
 #include <linux/fb.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
index 0cd4c33..c2bfed4 100644
--- a/drivers/video/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #if defined(CONFIG_OF)
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index f0a5392..30a0511 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -22,7 +22,6 @@
 
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 478f980..9cdf9b6 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index def0412..da7cb5e 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/console.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index c95b9e4..727db73 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 8a8d7f0..3ba0bb0 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/backlight.h>
 #include <linux/bitrev.h>
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 62acae2..4dc781e 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -17,7 +17,6 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/clk.h>
 #include <linux/fb.h>
 #include <linux/io.h>
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 2bcc84a..fec86d6 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -16,7 +16,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioctl.h>
 #include <linux/kernel.h>
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 1501979..3d84279 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index d513ed6..694033c 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -24,7 +24,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index f0cb279..f10ca57 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -85,7 +85,6 @@
 #include <linux/fb.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <asm/io.h>
 #include <linux/uaccess.h>
 #include <video/sstfb.h>
diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index 07c7df9..90e2583 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -18,7 +18,6 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 77b890e..c00aec3 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 256fba7..9b2c7b5 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -5,7 +5,6 @@
  *     Loosely based upon the vesafb driver.
  *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/skbuff.h>
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 275dbbb..d356dec 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -28,7 +28,6 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/console.h>
 #include <linux/timer.h>
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index a8f2b28..dc55ef4 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -19,7 +19,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 10951c8..1c55014 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -26,7 +26,6 @@
 
 #include <linux/delay.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 537d199..fc8e0d7 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -19,7 +19,6 @@
 #include <linux/fb.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 6ff1a91..4506252 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -27,7 +27,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fb.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
-- 
1.8.4.1

