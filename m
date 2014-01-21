Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaAUVZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50706 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaAUVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wim Van Sebroeck <wim@iguana.be>, <linux-watchdog@vger.kernel.org>
Subject: [PATCH 40/73] watchdog: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:43 -0500
Message-ID: <1390339396-3479-41-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/watchdog/ar7_wdt.c          | 1 -
 drivers/watchdog/ath79_wdt.c        | 1 -
 drivers/watchdog/bcm47xx_wdt.c      | 1 -
 drivers/watchdog/bcm63xx_wdt.c      | 1 -
 drivers/watchdog/cpu5wdt.c          | 1 -
 drivers/watchdog/cpwd.c             | 1 -
 drivers/watchdog/davinci_wdt.c      | 1 -
 drivers/watchdog/hpwdt.c            | 1 -
 drivers/watchdog/i6300esb.c         | 1 -
 drivers/watchdog/jz4740_wdt.c       | 1 -
 drivers/watchdog/max63xx_wdt.c      | 1 -
 drivers/watchdog/mtx-1_wdt.c        | 1 -
 drivers/watchdog/nuc900_wdt.c       | 1 -
 drivers/watchdog/of_xilinx_wdt.c    | 1 -
 drivers/watchdog/omap_wdt.c         | 1 -
 drivers/watchdog/orion_wdt.c        | 1 -
 drivers/watchdog/pnx4008_wdt.c      | 1 -
 drivers/watchdog/rdc321x_wdt.c      | 1 -
 drivers/watchdog/retu_wdt.c         | 1 -
 drivers/watchdog/riowd.c            | 1 -
 drivers/watchdog/s3c2410_wdt.c      | 1 -
 drivers/watchdog/sp805_wdt.c        | 1 -
 drivers/watchdog/stmp3xxx_rtc_wdt.c | 1 -
 drivers/watchdog/wdt_pci.c          | 1 -
 24 files changed, 24 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3a99657..ae6c287 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 9fa1f69..399c3fd 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -22,7 +22,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index b4021a2..b61fcc5 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/bcm47xx_wdt.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index 4eb188b..3fb18bb 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index f7ae49e..6d03e8e 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 213225e..e55ed70 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/major.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index b1bae03..d09ad22 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2b75e8b..75d2243 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -17,7 +17,6 @@
 
 #include <linux/device.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 25a2bfd..d7befd5 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -36,7 +36,6 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/uaccess.h>
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 3aa50cf..91e45ca 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index bdb3f4a..0e9cc6f 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -20,7 +20,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index edb31ff..ff27c4a 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -40,7 +40,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index a0d893b..7135803 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -12,7 +12,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index fb57103..19fa92d01 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 09cf013..fbcb6f6 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -34,7 +34,6 @@
 #include <linux/mm.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index f7722a4..4981634 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 5bec20f..15fb316 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/spinlock.h>
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 082d062..29cf4dc 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/retu_wdt.c b/drivers/watchdog/retu_wdt.c
index f53615d..a7a0695 100644
--- a/drivers/watchdog/retu_wdt.c
+++ b/drivers/watchdog/retu_wdt.c
@@ -16,7 +16,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 3dd8ed2..cfed0fe 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/of.h>
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index aec946d..aba6cd4 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 3f786ce..6ee6db1 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/amba/bus.h>
 #include <linux/bitops.h>
 #include <linux/clk.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
index bb64ae3..3804d5e 100644
--- a/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -9,7 +9,6 @@
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 3dc578e..48b2c05 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -49,7 +49,6 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/pci.h>
 #include <linux/io.h>
-- 
1.8.4.1

