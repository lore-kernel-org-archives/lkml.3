Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3ETKCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:02:52 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61658 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3ETKCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:02:50 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] videodev2.h: fix typos
Date: Mon, 20 May 2013 15:32:40 +0530
Message-Id: <1369044160-7571-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch fixes several typos in videodev2.h file

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 include/uapi/linux/videodev2.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index f40b41c..ee4af53 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -555,7 +555,7 @@ struct v4l2_jpegcompression {
 	__u32 jpeg_markers;     /* Which markers should go into the JPEG
 				 * output. Unless you exactly know what
 				 * you do, leave them untouched.
-				 * Inluding less markers will make the
+				 * Including less markers will make the
 				 * resulting code smaller, but there will
 				 * be fewer applications which can read it.
 				 * The presence of the APP and COM marker
@@ -567,7 +567,7 @@ struct v4l2_jpegcompression {
 #define V4L2_JPEG_MARKER_DRI (1<<5)    /* Define Restart Interval */
 #define V4L2_JPEG_MARKER_COM (1<<6)    /* Comment segment */
 #define V4L2_JPEG_MARKER_APP (1<<7)    /* App segment, driver will
-					* allways use APP0 */
+					* always use APP0 */
 };
 
 /*
@@ -900,7 +900,7 @@ typedef __u64 v4l2_std_id;
 /*
  * "Common" PAL - This macro is there to be compatible with the old
  * V4L1 concept of "PAL": /BGDKHI.
- * Several PAL standards are mising here: /M, /N and /Nc
+ * Several PAL standards are missing here: /M, /N and /Nc
  */
 #define V4L2_STD_PAL		(V4L2_STD_PAL_BG	|\
 				 V4L2_STD_PAL_DK	|\
@@ -1790,7 +1790,7 @@ struct v4l2_event_subscription {
 #define V4L2_CHIP_MATCH_HOST V4L2_CHIP_MATCH_BRIDGE
 #define V4L2_CHIP_MATCH_I2C_DRIVER  1  /* Match against I2C driver name */
 #define V4L2_CHIP_MATCH_I2C_ADDR    2  /* Match against I2C 7-bit address */
-#define V4L2_CHIP_MATCH_AC97        3  /* Match against anciliary AC97 chip */
+#define V4L2_CHIP_MATCH_AC97        3  /* Match against ancillary AC97 chip */
 #define V4L2_CHIP_MATCH_SUBDEV      4  /* Match against subdev index */
 
 struct v4l2_dbg_match {
-- 
1.7.4.1

