Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab3HSEKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:10:41 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58794 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3HSEKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:10:38 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typo in printk
Date: Mon, 19 Aug 2013 13:10:30 +0900
Message-Id: <1376885430-9606-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c  | 4 ++--
 drivers/infiniband/ulp/isert/Kconfig     | 2 +-
 drivers/media/i2c/Kconfig                | 2 +-
 drivers/media/i2c/adv7183.c              | 2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 4 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c     | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 6e047bd..8926d68 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -343,7 +343,7 @@ static bool fimc_check_ovf(struct fimc_context *ctx)
 
 		fimc_write(cfg, EXYNOS_CIWDOFST);
 
-		dev_err(ippdrv->dev, "occured overflow at %d, status 0x%x.\n",
+		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
 		return true;
 	}
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 90b8a1a..7751a43 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1300,13 +1300,13 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
 
 	status = gsc_read(GSC_IRQ);
 	if (status & GSC_IRQ_STATUS_OR_IRQ) {
-		dev_err(ippdrv->dev, "occured overflow at %d, status 0x%x.\n",
+		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
 		return IRQ_NONE;
 	}
 
 	if (status & GSC_IRQ_STATUS_OR_FRM_DONE) {
-		dev_dbg(ippdrv->dev, "occured frame done at %d, status 0x%x.\n",
+		dev_dbg(ippdrv->dev, "occurred frame done at %d, status 0x%x.\n",
 			ctx->id, status);
 
 		buf_id[EXYNOS_DRM_OPS_SRC] = gsc_get_src_buf_index(ctx);
diff --git a/drivers/infiniband/ulp/isert/Kconfig b/drivers/infiniband/ulp/isert/Kconfig
index ce3fd32..5afcfa6 100644
--- a/drivers/infiniband/ulp/isert/Kconfig
+++ b/drivers/infiniband/ulp/isert/Kconfig
@@ -1,5 +1,5 @@
 config INFINIBAND_ISERT
-	tristate "iSCSI Extentions for RDMA (iSER) target support"
+	tristate "iSCSI Extensions for RDMA (iSER) target support"
 	depends on INET && INFINIBAND_ADDR_TRANS && TARGET_CORE && ISCSI_TARGET
 	---help---
 	Support for iSCSI Extentions for RDMA (iSER) Target on Infiniband fabrics.
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b2cd8ca..70c4671 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -623,7 +623,7 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
-comment "Miscelaneous helper chips"
+comment "Miscellaneous helper chips"
 
 config VIDEO_THS7303
 	tristate "THS7303/53 Video Amplifier"
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 6f738d8..d45e0e3 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -178,7 +178,7 @@ static int adv7183_log_status(struct v4l2_subdev *sd)
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_1),
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_2),
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_3));
-	v4l2_info(sd, "adv7183: Hsync positon control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
+	v4l2_info(sd, "adv7183: Hsync position control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_1),
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_2),
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_3));
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 825ea86..d153440 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1455,7 +1455,7 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
 	mutex_unlock(&state->lock);
 
 	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: Booting %s (%d)\n",
-		 __func__, ret ? "failed" : "succeded", ret);
+		 __func__, ret ? "failed" : "succeeded", ret);
 
 	return ret;
 }
@@ -1646,7 +1646,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto out_err;
 
-	v4l2_info(sd, "%s: completed succesfully\n", __func__);
+	v4l2_info(sd, "%s: completed successfully\n", __func__);
 	return 0;
 
 out_err:
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fccd08b..1765182 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -420,7 +420,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Advanced Simple",
 		"Core",
 		"Simple Scalable",
-		"Advanced Coding Efficency",
+		"Advanced Coding Efficiency",
 		NULL,
 	};
 
-- 
1.8.4.rc3.2.g2c2b664

