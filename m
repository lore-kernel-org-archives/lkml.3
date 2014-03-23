Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaCWTCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:02:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35932 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCWTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:02:34 -0400
Message-ID: <532F2FC7.10502@gmail.com>
Date: Sun, 23 Mar 2014 21:02:31 +0200
From: Tair <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: luca.risolia@studio.unibo.it
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media/sn9c102/sn9c102_hv7131d.c: fixed pointer coding
 style issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed pointer coding style issues reported by checkpatch (Eudyptula challenge).

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
index 4680721..f1d94f0 100644
--- a/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
+++ b/drivers/staging/media/sn9c102/sn9c102_hv7131d.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int hv7131d_init(struct sn9c102_device* cam)
+static int hv7131d_init(struct sn9c102_device *cam)
 {
 	int err;
 
@@ -39,8 +39,8 @@ static int hv7131d_init(struct sn9c102_device* cam)
 }
 
 
-static int hv7131d_get_ctrl(struct sn9c102_device* cam,
-			    struct v4l2_control* ctrl)
+static int hv7131d_get_ctrl(struct sn9c102_device *cam,
+			    struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_EXPOSURE:
@@ -88,8 +88,8 @@ static int hv7131d_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_ctrl(struct sn9c102_device* cam,
-			    const struct v4l2_control* ctrl)
+static int hv7131d_set_ctrl(struct sn9c102_device *cam,
+			    const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -121,10 +121,10 @@ static int hv7131d_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int hv7131d_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 2,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 2;
@@ -136,8 +136,8 @@ static int hv7131d_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int hv7131d_set_pix_format(struct sn9c102_device* cam,
-				  const struct v4l2_pix_format* pix)
+static int hv7131d_set_pix_format(struct sn9c102_device *cam,
+				  const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -248,7 +248,7 @@ static const struct sn9c102_sensor hv7131d = {
 };
 
 
-int sn9c102_probe_hv7131d(struct sn9c102_device* cam)
+int sn9c102_probe_hv7131d(struct sn9c102_device *cam)
 {
 	int r0 = 0, r1 = 0, err;
 
-- 
1.8.3.2

