Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaAUVZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:43 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50775 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaAUVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>
Subject: [PATCH 59/73] drivers/gpio: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:02 -0500
Message-ID: <1390339396-3479-60-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpio/gpio-74x164.c    | 1 -
 drivers/gpio/gpio-adp5520.c   | 1 -
 drivers/gpio/gpio-adp5588.c   | 1 -
 drivers/gpio/gpio-generic.c   | 1 -
 drivers/gpio/gpio-grgpio.c    | 1 -
 drivers/gpio/gpio-janz-ttl.c  | 1 -
 drivers/gpio/gpio-kempld.c    | 1 -
 drivers/gpio/gpio-lpc32xx.c   | 1 -
 drivers/gpio/gpio-max730x.c   | 1 -
 drivers/gpio/gpio-moxart.c    | 1 -
 drivers/gpio/gpio-msm-v2.c    | 1 -
 drivers/gpio/gpio-rcar.c      | 1 -
 drivers/gpio/gpio-rdc321x.c   | 1 -
 drivers/gpio/gpio-sch.c       | 1 -
 drivers/gpio/gpio-sodaville.c | 1 -
 drivers/gpio/gpio-twl6040.c   | 1 -
 drivers/gpio/gpio-vr41xx.c    | 1 -
 17 files changed, 17 deletions(-)

diff --git a/drivers/gpio/gpio-74x164.c b/drivers/gpio/gpio-74x164.c
index e4ae298..8aa8a97 100644
--- a/drivers/gpio/gpio-74x164.c
+++ b/drivers/gpio/gpio-74x164.c
@@ -9,7 +9,6 @@
  *  published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
diff --git a/drivers/gpio/gpio-adp5520.c b/drivers/gpio/gpio-adp5520.c
index 6132659..00f54fa 100644
--- a/drivers/gpio/gpio-adp5520.c
+++ b/drivers/gpio/gpio-adp5520.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/adp5520.h>
 
diff --git a/drivers/gpio/gpio-adp5588.c b/drivers/gpio/gpio-adp5588.c
index 3f190e6..a5b7a20 100644
--- a/drivers/gpio/gpio-adp5588.c
+++ b/drivers/gpio/gpio-adp5588.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index d2196bf..cdc8437 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -44,7 +44,6 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
  *               `.......````.```
  */
 
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 84d2478..d137fd3 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/of.h>
diff --git a/drivers/gpio/gpio-janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
index 2ecd3a0..ab0bfb9 100644
--- a/drivers/gpio/gpio-janz-ttl.c
+++ b/drivers/gpio/gpio-janz-ttl.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
index c6d8817..8a2ff81 100644
--- a/drivers/gpio/gpio-kempld.c
+++ b/drivers/gpio/gpio-kempld.c
@@ -14,7 +14,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 225344d..f2f9353 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
diff --git a/drivers/gpio/gpio-max730x.c b/drivers/gpio/gpio-max730x.c
index 8672755..f8c01a4 100644
--- a/drivers/gpio/gpio-max730x.c
+++ b/drivers/gpio/gpio-max730x.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/spi/max7301.h>
diff --git a/drivers/gpio/gpio-moxart.c b/drivers/gpio/gpio-moxart.c
index 2af9900..799da97 100644
--- a/drivers/gpio/gpio-moxart.c
+++ b/drivers/gpio/gpio-moxart.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index a3351ac..f817e59 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -21,7 +21,6 @@
 #include <linux/bitops.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irqchip/chained_irq.h>
diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index ca76ce7..32963f2 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -15,7 +15,6 @@
 
 #include <linux/err.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
diff --git a/drivers/gpio/gpio-rdc321x.c b/drivers/gpio/gpio-rdc321x.c
index 88577c3..45e1fc7 100644
--- a/drivers/gpio/gpio-rdc321x.c
+++ b/drivers/gpio/gpio-rdc321x.c
@@ -21,7 +21,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 5af6571..4dd3ded 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -18,7 +18,6 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
index 7c6c518..8bd814f 100644
--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -11,7 +11,6 @@
 
 #include <linux/errno.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff --git a/drivers/gpio/gpio-twl6040.c b/drivers/gpio/gpio-twl6040.c
index 0caf5cd..9377fc0 100644
--- a/drivers/gpio/gpio-twl6040.c
+++ b/drivers/gpio/gpio-twl6040.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 9902732..b983bc0 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -22,7 +22,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
-- 
1.8.4.1

