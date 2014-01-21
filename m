Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaAUV0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:26:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50869 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaAUV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
Subject: [PATCH 42/73] rtc: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:45 -0500
Message-ID: <1390339396-3479-43-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/rtc/rtc-ab8500.c   | 1 -
 drivers/rtc/rtc-au1xxx.c   | 1 -
 drivers/rtc/rtc-bfin.c     | 1 -
 drivers/rtc/rtc-bq32k.c    | 1 -
 drivers/rtc/rtc-bq4802.c   | 1 -
 drivers/rtc/rtc-dm355evm.c | 1 -
 drivers/rtc/rtc-ds1305.c   | 1 -
 drivers/rtc/rtc-ds1307.c   | 1 -
 drivers/rtc/rtc-ds1390.c   | 1 -
 drivers/rtc/rtc-ds1511.c   | 1 -
 drivers/rtc/rtc-ds1553.c   | 1 -
 drivers/rtc/rtc-ds2404.c   | 1 -
 drivers/rtc/rtc-ds3234.c   | 1 -
 drivers/rtc/rtc-lpc32xx.c  | 1 -
 drivers/rtc/rtc-ls1x.c     | 1 -
 drivers/rtc/rtc-m41t80.c   | 1 -
 drivers/rtc/rtc-m48t59.c   | 1 -
 drivers/rtc/rtc-max6902.c  | 1 -
 drivers/rtc/rtc-mpc5121.c  | 1 -
 drivers/rtc/rtc-mrst.c     | 1 -
 drivers/rtc/rtc-palmas.c   | 1 -
 drivers/rtc/rtc-pcf2123.c  | 1 -
 drivers/rtc/rtc-pcf50633.c | 1 -
 drivers/rtc/rtc-pcf8583.c  | 1 -
 drivers/rtc/rtc-pl030.c    | 1 -
 drivers/rtc/rtc-pl031.c    | 1 -
 drivers/rtc/rtc-pm8xxx.c   | 1 -
 drivers/rtc/rtc-puv3.c     | 1 -
 drivers/rtc/rtc-r9701.c    | 1 -
 drivers/rtc/rtc-rc5t583.c  | 1 -
 drivers/rtc/rtc-rs5c348.c  | 1 -
 drivers/rtc/rtc-rx4581.c   | 1 -
 drivers/rtc/rtc-rx8025.c   | 1 -
 drivers/rtc/rtc-s3c.c      | 1 -
 drivers/rtc/rtc-sa1100.c   | 1 -
 drivers/rtc/rtc-snvs.c     | 1 -
 drivers/rtc/rtc-spear.c    | 1 -
 drivers/rtc/rtc-stk17ta8.c | 1 -
 drivers/rtc/rtc-stmp3xxx.c | 1 -
 drivers/rtc/rtc-tps6586x.c | 1 -
 drivers/rtc/rtc-tps65910.c | 1 -
 drivers/rtc/rtc-tps80031.c | 1 -
 drivers/rtc/rtc-twl.c      | 1 -
 drivers/rtc/rtc-v3020.c    | 1 -
 drivers/rtc/rtc-vr41xx.c   | 1 -
 drivers/rtc/rtc-vt8500.c   | 1 -
 46 files changed, 46 deletions(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 727e2f5..480525c 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/mfd/abx500.h>
diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index ed526a1..4307a8f 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <asm/mach-au1x00/au1000.h>
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 0c53f45..a7669c1 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -44,7 +44,6 @@
 #include <linux/bcd.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index c74bf0d..5e2a74a 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
 
diff --git a/drivers/rtc/rtc-bq4802.c b/drivers/rtc/rtc-bq4802.c
index fc0ff87..23d0469 100644
--- a/drivers/rtc/rtc-bq4802.c
+++ b/drivers/rtc/rtc-bq4802.c
@@ -5,7 +5,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index 1aca083..e6b6bdc 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 2dd586a..d913952 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -9,7 +9,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/bcd.h>
 #include <linux/slab.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 4e75345..72d2bf9 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/string.h>
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index be9d8c0..3d5f128 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -13,7 +13,6 @@
  * (alarms, trickle charger, different control registers) are unavailable.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index bc7b4fc..a894336 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/bcd.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index fd31571..89e3008 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/bcd.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index fc209dc..8574301 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -9,7 +9,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/types.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index 4c9ba53..258fe11 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index bfdbcb8..23b7727 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-ls1x.c b/drivers/rtc/rtc-ls1x.c
index 682ecb0..fefeba8 100644
--- a/drivers/rtc/rtc-ls1x.c
+++ b/drivers/rtc/rtc-ls1x.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/types.h>
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index a5248aa..953bc79 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -15,7 +15,6 @@
 
 #include <linux/bcd.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 11880c1..9fac68b 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index ac3f419..4671366 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index dc4f142..0d0cb89 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -10,7 +10,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/of.h>
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index e2436d1..4925003 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -33,7 +33,6 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/sfi.h>
 
 #include <asm-generic/rtc.h>
diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index fffb7d3..8eee0a5 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -25,7 +25,6 @@
 
 #include <linux/bcd.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mfd/palmas.h>
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index d1953bb..27869a6 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -36,7 +36,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index e6b6911..adb5622 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index c263984..ead381e 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -16,7 +16,6 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index f85a1a9..746f8c7 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -9,7 +9,6 @@
  */
 #include <linux/module.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/amba/bus.h>
 #include <linux/io.h>
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 99181fff..0638941 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -17,7 +17,6 @@
  */
 #include <linux/module.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/amba/bus.h>
 #include <linux/io.h>
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 03f8f75..1db02aa 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 1ecfe3b..bac83ee 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index feeedbd..11bcd60 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-rc5t583.c b/drivers/rtc/rtc-rc5t583.c
index e53e9b1..9539efb 100644
--- a/drivers/rtc/rtc-rc5t583.c
+++ b/drivers/rtc/rtc-rc5t583.c
@@ -18,7 +18,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 090a101..e561910 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -16,7 +16,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/rtc/rtc-rx4581.c b/drivers/rtc/rtc-rx4581.c
index 6889222..d2e42df 100644
--- a/drivers/rtc/rtc-rx4581.c
+++ b/drivers/rtc/rtc-rx4581.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index 8fa23ea..fcdd253 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/bcd.h>
 #include <linux/i2c.h>
 #include <linux/list.h>
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7afd373..372554c 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0f7adeb..c0bcc67 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index fa384fe..8ee9483 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -9,7 +9,6 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c492cf0..de2c9a5 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -12,7 +12,6 @@
 #include <linux/bcd.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index a176ba6..5b55532 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/bcd.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index ea96492..337ee6c 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 426901c..6656ae1 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -22,7 +22,6 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mfd/tps6586x.h>
 #include <linux/module.h>
diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 7af0020..bc5beb5 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-tps80031.c b/drivers/rtc/rtc-tps80031.c
index 3e400dc..202d391 100644
--- a/drivers/rtc/rtc-tps80031.c
+++ b/drivers/rtc/rtc-tps80031.c
@@ -26,7 +26,6 @@
 #include <linux/bcd.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mfd/tps80031.h>
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 1915464..48920f1 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 25222cd..7fd489c 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -21,7 +21,6 @@
  */
 #include <linux/platform_device.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/types.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 88c9c92..37f2fb8 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -19,7 +19,6 @@
  */
 #include <linux/err.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index df2ef3e..22dd231 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/bcd.h>
-- 
1.8.4.1

