Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaAUVcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:32:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50809 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaAUVZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 64/73] drivers/misc: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:07 -0500
Message-ID: <1390339396-3479-65-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/misc/ad525x_dpot.c             | 1 -
 drivers/misc/apds9802als.c             | 1 -
 drivers/misc/bmp085.c                  | 1 -
 drivers/misc/carma/carma-fpga.c        | 1 -
 drivers/misc/ds1682.c                  | 1 -
 drivers/misc/eeprom/at25.c             | 1 -
 drivers/misc/eeprom/eeprom.c           | 1 -
 drivers/misc/eeprom/eeprom_93xx46.c    | 1 -
 drivers/misc/eeprom/max6875.c          | 1 -
 drivers/misc/eeprom/sunxi_sid.c        | 1 -
 drivers/misc/genwqe/card_debugfs.c     | 1 -
 drivers/misc/hmc6352.c                 | 1 -
 drivers/misc/isl29003.c                | 1 -
 drivers/misc/isl29020.c                | 1 -
 drivers/misc/lattice-ecp3-config.c     | 1 -
 drivers/misc/lis3lv02d/lis3lv02d.c     | 1 -
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c | 1 -
 drivers/misc/lis3lv02d/lis3lv02d_spi.c | 1 -
 drivers/misc/mei/amthif.c              | 1 -
 drivers/misc/mei/pci-me.c              | 1 -
 drivers/misc/ti-st/st_core.c           | 1 -
 drivers/misc/ti_dac7512.c              | 1 -
 drivers/misc/tsl2550.c                 | 1 -
 23 files changed, 23 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index d3eee11..a43053d 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -72,7 +72,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 0c6e037..c6cc3dc 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/err.h>
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 820e53d..9b313f7 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -47,7 +47,6 @@
 
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include "bmp085.h"
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 9e2b985..14d90ea 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -101,7 +101,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/poll.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kref.h>
 #include <linux/io.h>
diff --git a/drivers/misc/ds1682.c b/drivers/misc/ds1682.c
index 154b02e..6a672f9 100644
--- a/drivers/misc/ds1682.c
+++ b/drivers/misc/ds1682.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/string.h>
 #include <linux/list.h>
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 4f3bca1..634f729 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index c169e07..545ca39 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 78e55b5..9ebeacd 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -11,7 +11,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
diff --git a/drivers/misc/eeprom/max6875.c b/drivers/misc/eeprom/max6875.c
index e36157d..580ff9d 100644
--- a/drivers/misc/eeprom/max6875.c
+++ b/drivers/misc/eeprom/max6875.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
index 9c34e57..e703c71 100644
--- a/drivers/misc/eeprom/sunxi_sid.c
+++ b/drivers/misc/eeprom/sunxi_sid.c
@@ -21,7 +21,6 @@
 #include <linux/err.h>
 #include <linux/export.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
index 3bfdc07..50d2096 100644
--- a/drivers/misc/genwqe/card_debugfs.c
+++ b/drivers/misc/genwqe/card_debugfs.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 170bd3d..90520d7 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/err.h>
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index e3183f2..12c30b4 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index b7f84da..4a9c50a 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/err.h>
diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 61fbe6a..0a1565e 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/spi/spi.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 036effe..3ef4627 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index 7c97550..d324f8a 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index 9aa2bd2..bd06d0c 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -10,7 +10,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 2fad844..d9f14ef 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -21,7 +21,6 @@
 #include <linux/fcntl.h>
 #include <linux/aio.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/ioctl.h>
 #include <linux/cdev.h>
 #include <linux/list.h>
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index ddadd08..5434354 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -27,7 +27,6 @@
 #include <linux/aio.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
-#include <linux/init.h>
 #include <linux/ioctl.h>
 #include <linux/cdev.h>
 #include <linux/sched.h>
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 78a998b..e7fbc08 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -22,7 +22,6 @@
 #define pr_fmt(fmt)	"(stc): " fmt
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/tty.h>
 
 #include <linux/seq_file.h>
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 83da711..cb0289b 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spi/spi.h>
 #include <linux/of.h>
 
diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
index 5bc10fa1..b003356 100644
--- a/drivers/misc/tsl2550.c
+++ b/drivers/misc/tsl2550.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
-- 
1.8.4.1

