Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbaEMKYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:24:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933470AbaEMKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/182] media: videodev2.h: add parenthesis around macro arguments
Date: Tue, 13 May 2014 11:27:19 +0200
Message-Id: <144b497ead9e2555d7071c426cccfe63fdf74f20.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aee786acfc0a12bcd37a1c60f3198fb25cf7181a upstream.

bt->width should be (bt)->width, and same for the other fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/videodev2.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0f8937..c5e2c7df1b0f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1059,14 +1059,14 @@ struct v4l2_bt_timings {
 
 /* A few useful defines to calculate the total blanking and frame sizes */
 #define V4L2_DV_BT_BLANKING_WIDTH(bt) \
-	(bt->hfrontporch + bt->hsync + bt->hbackporch)
+	((bt)->hfrontporch + (bt)->hsync + (bt)->hbackporch)
 #define V4L2_DV_BT_FRAME_WIDTH(bt) \
-	(bt->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
+	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
-	(bt->vfrontporch + bt->vsync + bt->vbackporch + \
-	 bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch)
+	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
+	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
-	(bt->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
+	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
 /** struct v4l2_dv_timings - DV timings
  * @type:	the type of the timings
-- 
1.9.3

