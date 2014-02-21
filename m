Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaBUMHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:07:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaBUMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:07:39 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/3] media: omap3isp: fix typos
Date: Fri, 21 Feb 2014 17:37:21 +0530
Message-Id: <1392984443-16694-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/isp.c        |    2 +-
 drivers/media/platform/omap3isp/ispccdc.c    |    2 +-
 drivers/media/platform/omap3isp/ispccp2.c    |    4 ++--
 drivers/media/platform/omap3isp/isphist.c    |    2 +-
 drivers/media/platform/omap3isp/isppreview.c |    4 ++--
 drivers/media/platform/omap3isp/ispqueue.c   |    2 +-
 drivers/media/platform/omap3isp/ispresizer.h |    4 ++--
 drivers/media/platform/omap3isp/ispstat.c    |    4 ++--
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5807185..65a9b1d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -391,7 +391,7 @@ static void isp_disable_interrupts(struct isp_device *isp)
  * @isp: OMAP3 ISP device
  * @idle: Consider idle state.
  *
- * Set the power settings for the ISP and SBL bus and cConfigure the HS/VS
+ * Set the power settings for the ISP and SBL bus and configure the HS/VS
  * interrupt source.
  *
  * We need to configure the HS/VS interrupt source before interrupts get
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 5db2c88..7160e4a 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -293,7 +293,7 @@ static int __ccdc_lsc_enable(struct isp_ccdc_device *ccdc, int enable)
 			isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC,
 				    ISPCCDC_LSC_CONFIG, ISPCCDC_LSC_ENABLE);
 			ccdc->lsc.state = LSC_STATE_STOPPED;
-			dev_warn(to_device(ccdc), "LSC prefecth timeout\n");
+			dev_warn(to_device(ccdc), "LSC prefetch timeout\n");
 			return -ETIMEDOUT;
 		}
 		ccdc->lsc.state = LSC_STATE_RUNNING;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e84fe05..c81ca8f 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -518,7 +518,7 @@ static void ccp2_mem_configure(struct isp_ccp2_device *ccp2,
 		       ISPCCP2_LCM_IRQSTATUS_EOF_IRQ,
 		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_IRQSTATUS);
 
-	/* Enable LCM interupts */
+	/* Enable LCM interrupts */
 	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCM_IRQENABLE,
 		    ISPCCP2_LCM_IRQSTATUS_EOF_IRQ |
 		    ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ);
@@ -1096,7 +1096,7 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 	 * implementation we use a fixed 32 bytes alignment regardless of the
 	 * input format and width. If strict 128 bits alignment support is
 	 * required ispvideo will need to be made aware of this special dual
-	 * alignement requirements.
+	 * alignment requirements.
 	 */
 	ccp2->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	ccp2->video_in.bpl_alignment = 32;
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index e070c24..6db6cfb 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -351,7 +351,7 @@ static int hist_validate_params(struct ispstat *hist, void *new_conf)
 
 	buf_size = hist_get_buf_size(user_cfg);
 	if (buf_size > user_cfg->buf_size)
-		/* User's buf_size request wasn't enoght */
+		/* User's buf_size request wasn't enough */
 		user_cfg->buf_size = buf_size;
 	else if (user_cfg->buf_size > OMAP3ISP_HIST_MAX_BUF_SIZE)
 		user_cfg->buf_size = OMAP3ISP_HIST_MAX_BUF_SIZE;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 1c776c1..e8fb008 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -122,7 +122,7 @@ static struct omap3isp_prev_csc flr_prev_csc = {
 #define PREV_MAX_OUT_WIDTH_REV_15	4096
 
 /*
- * Coeficient Tables for the submodules in Preview.
+ * Coefficient Tables for the submodules in Preview.
  * Array is initialised with the values from.the tables text file.
  */
 
@@ -1363,7 +1363,7 @@ static void preview_init_params(struct isp_prev_device *prev)
 }
 
 /*
- * preview_max_out_width - Handle previewer hardware ouput limitations
+ * preview_max_out_width - Handle previewer hardware output limitations
  * @isp_revision : ISP revision
  * returns maximum width output for current isp revision
  */
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 5f0f8fa..a5e6585 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -597,7 +597,7 @@ static int isp_video_buffer_wait(struct isp_video_buffer *buf, int nonblocking)
  * isp_video_queue_free - Free video buffers memory
  *
  * Buffers can only be freed if the queue isn't streaming and if no buffer is
- * mapped to userspace. Return -EBUSY if those conditions aren't statisfied.
+ * mapped to userspace. Return -EBUSY if those conditions aren't satisfied.
  *
  * This function must be called with the queue lock held.
  */
diff --git a/drivers/media/platform/omap3isp/ispresizer.h b/drivers/media/platform/omap3isp/ispresizer.h
index 70c1c0e..9b01e90 100644
--- a/drivers/media/platform/omap3isp/ispresizer.h
+++ b/drivers/media/platform/omap3isp/ispresizer.h
@@ -30,12 +30,12 @@
 #include <linux/types.h>
 
 /*
- * Constants for filter coefficents count
+ * Constants for filter coefficients count
  */
 #define COEFF_CNT		32
 
 /*
- * struct isprsz_coef - Structure for resizer filter coeffcients.
+ * struct isprsz_coef - Structure for resizer filter coefficients.
  * @h_filter_coef_4tap: Horizontal filter coefficients for 8-phase/4-tap
  *			mode (.5x-4x)
  * @v_filter_coef_4tap: Vertical filter coefficients for 8-phase/4-tap
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index a75407c..5707f85 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -144,7 +144,7 @@ static int isp_stat_buf_check_magic(struct ispstat *stat,
 	for (w = buf->virt_addr + buf_size, end = w + MAGIC_SIZE;
 	     w < end; w++) {
 		if (unlikely(*w != MAGIC_NUM)) {
-			dev_dbg(stat->isp->dev, "%s: endding magic check does "
+			dev_dbg(stat->isp->dev, "%s: ending magic check does "
 				"not match.\n", stat->subdev.name);
 			return -EINVAL;
 		}
@@ -841,7 +841,7 @@ int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (enable) {
 		/*
 		 * Only set enable PCR bit if the module was previously
-		 * enabled through ioct.
+		 * enabled through ioctl.
 		 */
 		isp_stat_try_enable(stat);
 	} else {
-- 
1.7.9.5

