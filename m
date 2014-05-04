Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaEDPl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbaEDPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 111/158] media: videodev2.h: add parenthesis around macro arguments
Date: Sun,  4 May 2014 11:40:20 -0400
Message-Id: <20140504154045.083649859@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit aee786acfc0a12bcd37a1c60f3198fb25cf7181a upstream.

bt->width should be (bt)->width, and same for the other fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/videodev2.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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


