Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968227Ab3DSJxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:53:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59254 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968063Ab3DSJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:53:50 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: davinci: vpif: remove unwanted header file inclusion
Date: Fri, 19 Apr 2013 15:23:29 +0530
Message-Id: <1366365210-3778-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366365210-3778-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366365210-3778-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

this patch removes unwanted header file inclusion and sorts
header alphabetically.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   19 ++++---------------
 drivers/media/platform/davinci/vpif_capture.h |    5 +----
 drivers/media/platform/davinci/vpif_display.c |   23 +++--------------------
 drivers/media/platform/davinci/vpif_display.h |    5 +----
 4 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5f98df1..a1b42b0 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -18,28 +18,17 @@
  * TODO : add support for VBI & HBI data service
  *	  add static buffer allocation
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+
 #include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/string.h>
-#include <linux/videodev2.h>
-#include <linux/wait.h>
-#include <linux/time.h>
-#include <linux/i2c.h>
 #include <linux/platform_device.h>
-#include <linux/io.h>
 #include <linux/slab.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
+
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ioctl.h>
 
-#include "vpif_capture.h"
 #include "vpif.h"
+#include "vpif_capture.h"
 
 MODULE_DESCRIPTION("TI DaVinci VPIF Capture driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 3d3c1e5..0ebb312 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -22,11 +22,8 @@
 #ifdef __KERNEL__
 
 /* Header files */
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/davinci/vpif_types.h>
+#include <media/v4l2-device.h>
 
 #include "vpif.h"
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1b3fb5c..d833056 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -14,33 +14,16 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/string.h>
-#include <linux/videodev2.h>
-#include <linux/wait.h>
-#include <linux/time.h>
-#include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/io.h>
 #include <linux/slab.h>
 
-#include <asm/irq.h>
-#include <asm/page.h>
-
-#include <media/adv7343.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ioctl.h>
 
-#include "vpif_display.h"
 #include "vpif.h"
+#include "vpif_display.h"
 
 MODULE_DESCRIPTION("TI DaVinci VPIF Display driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index a5a18f7..5d87fc8 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -17,11 +17,8 @@
 #define DAVINCIHD_DISPLAY_H
 
 /* Header files */
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
 #include <media/videobuf2-dma-contig.h>
-#include <media/davinci/vpif_types.h>
+#include <media/v4l2-device.h>
 
 #include "vpif.h"
 
-- 
1.7.4.1

