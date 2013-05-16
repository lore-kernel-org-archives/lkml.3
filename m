Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3EPM75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:59:57 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:38940 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3EPM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:59:53 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/7] media: davinci: vpif_capture: remove unwanted header inclusion and sort them alphabetically
Date: Thu, 16 May 2013 18:28:19 +0530
Message-Id: <1368709102-2854-5-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   21 +++++----------------
 drivers/media/platform/davinci/vpif_capture.h |    6 ++----
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5f98df1..c26b6e4 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -18,28 +18,17 @@
  * TODO : add support for VBI & HBI data service
  *	  add static buffer allocation
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
+
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
index 3d3c1e5..517e7d1 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -22,11 +22,9 @@
 #ifdef __KERNEL__
 
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

