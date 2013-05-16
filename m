Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3EPNAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:00:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35011 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3EPNAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:00:11 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 6/7] media: davinci: vpif_display: remove unwanted header inclusion and sort them alphabetically
Date: Thu, 16 May 2013 18:28:21 +0530
Message-Id: <1368709102-2854-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes unwanted header inclusion and sorts them alphabetically

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   23 +++--------------------
 drivers/media/platform/davinci/vpif_display.h |    6 ++----
 2 files changed, 5 insertions(+), 24 deletions(-)

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
index a5a18f7..b4bb7d2 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -17,11 +17,9 @@
 #define DAVINCIHD_DISPLAY_H
 
 /* Header files */
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-device.h>
-#include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpif_types.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-device.h>
 
 #include "vpif.h"
 
-- 
1.7.4.1

