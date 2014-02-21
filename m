Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaBUMHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:07:51 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60188 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaBUMHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:07:48 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/3] media: omap3isp: rename the variable names in description
Date: Fri, 21 Feb 2014 17:37:23 +0530
Message-Id: <1392984443-16694-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch renames the variable in the description to
match it appropriately to function definition.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/isp.h        |   12 ++++++------
 drivers/media/platform/omap3isp/ispccdc.c    |    8 ++++----
 drivers/media/platform/omap3isp/ispccp2.c    |    2 +-
 drivers/media/platform/omap3isp/isphist.c    |    2 +-
 drivers/media/platform/omap3isp/isppreview.c |    9 +++++----
 drivers/media/platform/omap3isp/ispresizer.c |    6 +++---
 drivers/media/platform/omap3isp/ispvideo.c   |    4 ++--
 7 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 081f5ec..6d5e697 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -265,7 +265,7 @@ void omap3isp_unregister_entities(struct platform_device *pdev);
 
 /*
  * isp_reg_readl - Read value of an OMAP3 ISP register
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @isp_mmio_range: Range to which the register offset refers to.
  * @reg_offset: Register offset to read from.
  *
@@ -280,7 +280,7 @@ u32 isp_reg_readl(struct isp_device *isp, enum isp_mem_resources isp_mmio_range,
 
 /*
  * isp_reg_writel - Write value to an OMAP3 ISP register
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @reg_value: 32 bit value to write to the register.
  * @isp_mmio_range: Range to which the register offset refers to.
  * @reg_offset: Register offset to write into.
@@ -293,8 +293,8 @@ void isp_reg_writel(struct isp_device *isp, u32 reg_value,
 }
 
 /*
- * isp_reg_and - Clear individual bits in an OMAP3 ISP register
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * isp_reg_clr - Clear individual bits in an OMAP3 ISP register
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @mmio_range: Range to which the register offset refers to.
  * @reg: Register offset to work on.
  * @clr_bits: 32 bit value which would be cleared in the register.
@@ -310,7 +310,7 @@ void isp_reg_clr(struct isp_device *isp, enum isp_mem_resources mmio_range,
 
 /*
  * isp_reg_set - Set individual bits in an OMAP3 ISP register
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @mmio_range: Range to which the register offset refers to.
  * @reg: Register offset to work on.
  * @set_bits: 32 bit value which would be set in the register.
@@ -326,7 +326,7 @@ void isp_reg_set(struct isp_device *isp, enum isp_mem_resources mmio_range,
 
 /*
  * isp_reg_clr_set - Clear and set invidial bits in an OMAP3 ISP register
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @mmio_range: Range to which the register offset refers to.
  * @reg: Register offset to work on.
  * @clr_bits: 32 bit value which would be cleared in the register.
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 7160e4a..4d920c8 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -674,7 +674,7 @@ static void ccdc_config_imgattr(struct isp_ccdc_device *ccdc, u32 colptn)
 /*
  * ccdc_config - Set CCDC configuration from userspace
  * @ccdc: Pointer to ISP CCDC device.
- * @userspace_add: Structure containing CCDC configuration sent from userspace.
+ * @ccdc_struct: Structure containing CCDC configuration sent from userspace.
  *
  * Returns 0 if successful, -EINVAL if the pointer to the configuration
  * structure is null, or the copy_from_user function fails to copy user space
@@ -793,7 +793,7 @@ static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
 
 /*
  * omap3isp_ccdc_restore_context - Restore values of the CCDC module registers
- * @dev: Pointer to ISP device
+ * @isp: Pointer to ISP device
  */
 void omap3isp_ccdc_restore_context(struct isp_device *isp)
 {
@@ -2525,7 +2525,7 @@ error_video:
 
 /*
  * omap3isp_ccdc_init - CCDC module initialization.
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  *
  * TODO: Get the initialisation values from platform data.
  *
@@ -2564,7 +2564,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 
 /*
  * omap3isp_ccdc_cleanup - CCDC module cleanup.
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  */
 void omap3isp_ccdc_cleanup(struct isp_device *isp)
 {
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index c81ca8f..b30b67d 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -211,7 +211,7 @@ static void ccp2_mem_enable(struct isp_ccp2_device *ccp2, u8 enable)
 /*
  * ccp2_phyif_config - Initialize CCP2 phy interface config
  * @ccp2: Pointer to ISP CCP2 device
- * @config: CCP2 platform data
+ * @pdata: CCP2 platform data
  *
  * Configure the CCP2 physical interface module from platform data.
  *
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 6db6cfb..06a5f81 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -299,7 +299,7 @@ static u32 hist_get_buf_size(struct omap3isp_hist_config *conf)
 
 /*
  * hist_validate_params - Helper function to check user given params.
- * @user_cfg: Pointer to user configuration structure.
+ * @new_conf: Pointer to user configuration structure.
  *
  * Returns 0 on success configuration.
  */
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index e8fb008..ffbb718 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -971,7 +971,8 @@ static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
 
 /*
  * preview_config_ycpos - Configure byte layout of YUV image.
- * @mode: Indicates the required byte layout.
+ * @prev: pointer to previewer private structure
+ * @pixelcode: pixel code
  */
 static void
 preview_config_ycpos(struct isp_prev_device *prev,
@@ -1364,7 +1365,7 @@ static void preview_init_params(struct isp_prev_device *prev)
 
 /*
  * preview_max_out_width - Handle previewer hardware output limitations
- * @isp_revision : ISP revision
+ * @prev: pointer to previewer private structure
  * returns maximum width output for current isp revision
  */
 static unsigned int preview_max_out_width(struct isp_prev_device *prev)
@@ -1610,7 +1611,7 @@ static const struct v4l2_ctrl_ops preview_ctrl_ops = {
 
 /*
  * preview_ioctl - Handle preview module private ioctl's
- * @prev: pointer to preview context structure
+ * @sd: pointer to v4l2 subdev structure
  * @cmd: configuration command
  * @arg: configuration argument
  * return -EINVAL or zero on success
@@ -2341,7 +2342,7 @@ error_video_in:
 
 /*
  * omap3isp_preview_init - Previewer initialization.
- * @dev : Pointer to ISP device
+ * @isp : Pointer to ISP device
  * return -ENOMEM or zero on success
  */
 int omap3isp_preview_init(struct isp_device *isp)
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 0d36b8b..86369df 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -206,7 +206,7 @@ static void resizer_set_bilinear(struct isp_res_device *res,
 /*
  * resizer_set_ycpos - Luminance and chrominance order
  * @res: Device context.
- * @order: order type.
+ * @pixelcode: pixel code.
  */
 static void resizer_set_ycpos(struct isp_res_device *res,
 			      enum v4l2_mbus_pixelcode pixelcode)
@@ -918,8 +918,8 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 /*
  * resizer_set_crop_params - Setup hardware with cropping parameters
  * @res : resizer private structure
- * @crop_rect : current crop rectangle
- * @ratio : resizer ratios
+ * @input : format on sink pad
+ * @output : format on source pad
  * return none
  */
 static void resizer_set_crop_params(struct isp_res_device *res,
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 856fdf5..a4f8235 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -333,7 +333,7 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 
 /*
  * ispmmu_vmap - Wrapper for Virtual memory mapping of a scatter gather list
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @sglist: Pointer to source Scatter gather list to allocate.
  * @sglen: Number of elements of the scatter-gatter list.
  *
@@ -363,7 +363,7 @@ ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
 
 /*
  * ispmmu_vunmap - Unmap a device address from the ISP MMU
- * @dev: Device pointer specific to the OMAP3 ISP.
+ * @isp: Device pointer specific to the OMAP3 ISP.
  * @da: Device address generated from a ispmmu_vmap call.
  */
 static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
-- 
1.7.9.5

