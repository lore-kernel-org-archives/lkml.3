Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaHJUja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:39:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52193 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaHJUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:39:28 -0400
From: Suman Kumar <suman@inforcecomputing.com>
To: hverkuil@xs4all.nl
Cc: g.liakhovetski@gmx.de, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, suman@inforcecomputing.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: soc_camera.c: Fixed a Missing blank line coding style issue
Date: Mon, 11 Aug 2014 02:09:12 +0530
Message-Id: <1407703152-1847-1-git-send-email-suman@inforcecomputing.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Fixes a coding style issue of 'Missing a blank line after
    declarations' reported by checkpatch.pl

Signed-off-by: Suman Kumar <suman@inforcecomputing.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 7fec8cd..968a64b 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -830,6 +830,7 @@ void soc_camera_lock(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	mutex_lock(&ici->host_lock);
 }
 EXPORT_SYMBOL(soc_camera_lock);
@@ -838,6 +839,7 @@ void soc_camera_unlock(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	mutex_unlock(&ici->host_lock);
 }
 EXPORT_SYMBOL(soc_camera_unlock);
@@ -1703,6 +1705,7 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 	} else {
 		struct device *dev = to_soc_camera_control(icd);
 		struct device_driver *drv = dev ? dev->driver : NULL;
+
 		if (drv) {
 			sdesc->host_desc.del_device(icd);
 			module_put(drv->owner);
@@ -1728,18 +1731,21 @@ static int default_cropcap(struct soc_camera_device *icd,
 			   struct v4l2_cropcap *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
 	return v4l2_subdev_call(sd, video, cropcap, a);
 }
 
 static int default_g_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
 	return v4l2_subdev_call(sd, video, g_crop, a);
 }
 
 static int default_s_crop(struct soc_camera_device *icd, const struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
 	return v4l2_subdev_call(sd, video, s_crop, a);
 }
 
@@ -1747,6 +1753,7 @@ static int default_g_parm(struct soc_camera_device *icd,
 			  struct v4l2_streamparm *parm)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
 	return v4l2_subdev_call(sd, video, g_parm, parm);
 }
 
@@ -1754,6 +1761,7 @@ static int default_s_parm(struct soc_camera_device *icd,
 			  struct v4l2_streamparm *parm)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
 	return v4l2_subdev_call(sd, video, s_parm, parm);
 }
 
-- 
1.8.2

