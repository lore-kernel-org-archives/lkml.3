Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaAUVg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:36:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:56449 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaAUVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 52/73] drivers/pinctrl: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:55 -0500
Message-ID: <1390339396-3479-53-git-send-email-paul.gortmaker@windriver.com>
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c | 1 -
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  | 1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c       | 1 -
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   | 1 -
 drivers/pinctrl/pinconf-generic.c          | 1 -
 drivers/pinctrl/pinconf.c                  | 1 -
 drivers/pinctrl/pinctrl-imx.c              | 1 -
 drivers/pinctrl/pinctrl-mxs.c              | 1 -
 drivers/pinctrl/pinctrl-single.c           | 1 -
 drivers/pinctrl/pinctrl-tegra.c            | 1 -
 drivers/pinctrl/pinmux.c                   | 1 -
 drivers/pinctrl/sh-pfc/gpio.c              | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7722.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7723.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7724.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7734.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7757.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7785.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-sh7786.c        | 1 -
 drivers/pinctrl/sh-pfc/pfc-shx3.c          | 1 -
 drivers/pinctrl/sh-pfc/pinctrl.c           | 1 -
 21 files changed, 21 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index ae1f760..268476f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 843a51f..756c9f4 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 4726839..cbfdef4 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index 6b504b5..d5c44b6 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 3d9a999..90a46e0 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8bfa064..10b02dc 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 4779b8e..88a4feb 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index 40c76f2..b2f7cc7 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index de64596..41f1cfe 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -9,7 +9,6 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/slab.h>
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index a2e93a2..b2b6de0 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 9248ce4..5e7ecf6 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/radix-tree.h>
diff --git a/drivers/pinctrl/sh-pfc/gpio.c b/drivers/pinctrl/sh-pfc/gpio.c
index a9288ab..be02fb4 100644
--- a/drivers/pinctrl/sh-pfc/gpio.c
+++ b/drivers/pinctrl/sh-pfc/gpio.c
@@ -11,7 +11,6 @@
 
 #include <linux/device.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/slab.h>
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7722.c b/drivers/pinctrl/sh-pfc/pfc-sh7722.c
index 914d872..14eab90 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7722.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7722.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <cpu/sh7722.h>
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7723.c b/drivers/pinctrl/sh-pfc/pfc-sh7723.c
index 4eb7eae..7fd316b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7723.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7723.c
@@ -8,7 +8,6 @@
  * for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7723.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7724.c b/drivers/pinctrl/sh-pfc/pfc-sh7724.c
index 74a1a7f..1a39418 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7724.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7724.c
@@ -13,7 +13,6 @@
  * for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7724.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index e53dd1c..4b9c34f 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -8,7 +8,6 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7734.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7757.c b/drivers/pinctrl/sh-pfc/pfc-sh7757.c
index 625661a..c6fba87 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7757.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7757.c
@@ -13,7 +13,6 @@
  * for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7757.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7785.c b/drivers/pinctrl/sh-pfc/pfc-sh7785.c
index b38dd7e..34dab53 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7785.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7785.c
@@ -8,7 +8,6 @@
  * for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7785.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7786.c b/drivers/pinctrl/sh-pfc/pfc-sh7786.c
index 6cb4e0a..5238cac 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7786.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7786.c
@@ -13,7 +13,6 @@
  * for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/sh7786.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pfc-shx3.c b/drivers/pinctrl/sh-pfc/pfc-shx3.c
index a3fcb22..691d432 100644
--- a/drivers/pinctrl/sh-pfc/pfc-shx3.c
+++ b/drivers/pinctrl/sh-pfc/pfc-shx3.c
@@ -7,7 +7,6 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <cpu/shx3.h>
 
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index e758af9..c30b370 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -12,7 +12,6 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
-- 
1.8.4.1

