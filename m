Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaAUVbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:31:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:56608 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaAUVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: [PATCH 63/73] drivers/platform: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:06 -0500
Message-ID: <1390339396-3479-64-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/platform/goldfish/pdev_bus.c      | 1 -
 drivers/platform/x86/classmate-laptop.c   | 1 -
 drivers/platform/x86/hp_accel.c           | 1 -
 drivers/platform/x86/ideapad-laptop.c     | 1 -
 drivers/platform/x86/intel-rst.c          | 1 -
 drivers/platform/x86/intel-smartconnect.c | 1 -
 drivers/platform/x86/intel_mid_powerbtn.c | 1 -
 drivers/platform/x86/intel_mid_thermal.c  | 1 -
 drivers/platform/x86/panasonic-laptop.c   | 1 -
 drivers/platform/x86/pvpanic.c            | 1 -
 drivers/platform/x86/topstar-laptop.c     | 1 -
 drivers/platform/x86/toshiba_bluetooth.c  | 1 -
 drivers/platform/x86/xo15-ebook.c         | 1 -
 13 files changed, 13 deletions(-)

diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
index e4e999f..4f426b2 100644
--- a/drivers/platform/goldfish/pdev_bus.c
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 70d355a..790267b 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -17,7 +17,6 @@
  */
 
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index aff4d06..3fb7672 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6dd060a..6242ac8 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
 #include <linux/rfkill.h>
diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
index d45bca3..da64aee 100644
--- a/drivers/platform/x86/intel-rst.c
+++ b/drivers/platform/x86/intel-rst.c
@@ -17,7 +17,6 @@
  */
 
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
diff --git a/drivers/platform/x86/intel-smartconnect.c b/drivers/platform/x86/intel-smartconnect.c
index 04cf5df..01215fc 100644
--- a/drivers/platform/x86/intel-smartconnect.c
+++ b/drivers/platform/x86/intel-smartconnect.c
@@ -17,7 +17,6 @@
  */
 
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/acpi.h>
 
diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 8d67752..7d1f27f4 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 93fab8b..e7a79b1 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -25,7 +25,6 @@
 #define pr_fmt(fmt) "intel_mid_thermal: " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/param.h>
 #include <linux/device.h>
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 609d387..1c04871 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -118,7 +118,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/backlight.h>
 #include <linux/ctype.h>
diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
index c9f6e51..b91aad2 100644
--- a/drivers/platform/x86/pvpanic.c
+++ b/drivers/platform/x86/pvpanic.c
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
 
diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index e597de0..d3b27e1 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/input.h>
diff --git a/drivers/platform/x86/toshiba_bluetooth.c b/drivers/platform/x86/toshiba_bluetooth.c
index 2cb1ea6..ff21318 100644
--- a/drivers/platform/x86/toshiba_bluetooth.c
+++ b/drivers/platform/x86/toshiba_bluetooth.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
 
diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 49cbcce..4d4bb4c 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/input.h>
 #include <linux/acpi.h>
-- 
1.8.4.1

