Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3JXHDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:03:09 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44045 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3JXHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:03:07 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, inki.dae@samsung.com,
        jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typo incomment in /gpu/drm/exynos
Date: Thu, 24 Oct 2013 16:02:57 +0900
Message-Id: <1382598177-19166-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.1.559.gdb9bdfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/gpu/drm/exynos

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

# Please enter the commit message for your changes. Lines starting
# with '#' will be kept; you may remove them yourself if you want to.
# An empty message aborts the commit.
# On branch exynos_typo
# Changes to be committed:
#	modified:   exynos_drm_crtc.c
#	modified:   exynos_drm_g2d.c
#	modified:   exynos_drm_gem.c
#	modified:   exynos_drm_gem.h
#	modified:   exynos_drm_ipp.c
#	modified:   exynos_drm_ipp.h
#
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 4 ++--
 drivers/gpu/drm/exynos/exynos_drm_g2d.c  | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c  | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h  | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c  | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.h  | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index ebc0150..6f3400f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -36,9 +36,9 @@ enum exynos_crtc_mode {
  * @pipe: a crtc index created at load() with a new crtc object creation
  *	and the crtc object would be set to private->crtc array
  *	to get a crtc object corresponding to this pipe from private->crtc
- *	array when irq interrupt occured. the reason of using this pipe is that
+ *	array when irq interrupt occurred. the reason of using this pipe is that
  *	drm framework doesn't support multiple irq yet.
- *	we can refer to the crtc to current hardware interrupt occured through
+ *	we can refer to the crtc to current hardware interrupt occurred through
  *	this pipe value.
  * @dpms: store the crtc dpms value
  * @mode: store the crtc mode value
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 3271fd4..c97709c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1124,7 +1124,7 @@ int exynos_g2d_set_cmdlist_ioctl(struct drm_device *drm_dev, void *data,
 	 * G2D interrupt event once current command list execution is
 	 * finished.
 	 * Otherwise only ACF bit should be set to INTEN register so
-	 * that one interrupt is occured after all command lists
+	 * that one interrupt is occurred after all command lists
 	 * have been completed.
 	 */
 	if (node->event) {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index 1ade191..be59d50 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -652,7 +652,7 @@ int exynos_drm_gem_dumb_create(struct drm_file *file_priv,
 	int ret;
 
 	/*
-	 * alocate memory to be used for framebuffer.
+	 * allocate memory to be used for framebuffer.
 	 * - this callback would be called by user application
 	 *	with DRM_IOCTL_MODE_CREATE_DUMB command.
 	 */
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.h b/drivers/gpu/drm/exynos/exynos_drm_gem.h
index 702ec3a..b8c818b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.h
@@ -60,7 +60,7 @@ struct exynos_drm_gem_buf {
  * @vma: a pointer to vm_area.
  * @flags: indicate memory type to allocated buffer and cache attruibute.
  *
- * P.S. this object would be transfered to user as kms_bo.handle so
+ * P.S. this object would be transferred to user as kms_bo.handle so
  *	user can access the buffer through kms_bo.handle.
  */
 struct exynos_drm_gem_obj {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 824e070..d519a4e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -335,7 +335,7 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 	} else {
 		/*
 		 * Getting ippdrv capability by ipp_id.
-		 * some deivce not supported wb, output interface.
+		 * some device not supported wb, output interface.
 		 * so, user application detect correct ipp driver
 		 * using this ioctl.
 		 */
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 4cadbea..ab1634b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -48,7 +48,7 @@ struct drm_exynos_ipp_cmd_work {
 /*
  * A structure of command node.
  *
- * @priv: IPP private infomation.
+ * @priv: IPP private information.
  * @list: list head to command queue information.
  * @event_list: list head of event.
  * @mem_list: list head to source,destination memory queue information.
@@ -92,7 +92,7 @@ struct drm_exynos_ipp_buf_info {
 };
 
 /*
- * A structure of wb setting infomation.
+ * A structure of wb setting information.
  *
  * @enable: enable flag for wb.
  * @refresh: HZ of the refresh rate.
-- 
1.8.4.1.559.gdb9bdfb

