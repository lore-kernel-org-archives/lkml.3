Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab3LHPXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:23:07 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42656 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab3LHPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:23:02 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typo in printk
Date: Mon,  9 Dec 2013 00:22:53 +0900
Message-Id: <1386516173-1939-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various part of kernel

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-imx/mach-pca100.c               | 2 +-
 arch/arm64/kvm/handle_exit.c                  | 2 +-
 arch/mips/ralink/cevt-rt3352.c                | 2 +-
 arch/mips/ralink/timer.c                      | 2 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c | 2 +-
 drivers/char/msm_smd_pkt.c                    | 2 +-
 drivers/devfreq/exynos/exynos5_bus.c          | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c      | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c       | 4 ++--
 drivers/i2c/busses/i2c-exynos5.c              | 2 +-
 drivers/iio/adc/twl6030-gpadc.c               | 2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c               | 2 +-
 drivers/media/platform/ti-vpe/vpdma.c         | 4 ++--
 drivers/net/wireless/libertas/cmdresp.c       | 2 +-
 drivers/video/udlfb.c                         | 2 +-
 fs/btrfs/tests/free-space-tests.c             | 2 +-
 net/nfc/digital_dep.c                         | 2 +-
 17 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index c5f9567..bf3ac51 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -249,7 +249,7 @@ static int pca100_sdhc2_init(struct device *dev, irq_handler_t detect_irq,
 			  "imx-mmc-detect", data);
 	if (ret)
 		printk(KERN_ERR
-			"pca100: Failed to reuest irq for sd/mmc detection\n");
+			"pca100: Failed to request irq for sd/mmc detection\n");
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 8da5606..42a0f1b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -90,7 +90,7 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 
 	if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers) ||
 	    !arm_exit_handlers[hsr_ec]) {
-		kvm_err("Unkown exception class: hsr: %#08x\n",
+		kvm_err("Unknown exception class: hsr: %#08x\n",
 			(unsigned int)kvm_vcpu_get_hsr(vcpu));
 		BUG();
 	}
diff --git a/arch/mips/ralink/cevt-rt3352.c b/arch/mips/ralink/cevt-rt3352.c
index cc17566..24bf057 100644
--- a/arch/mips/ralink/cevt-rt3352.c
+++ b/arch/mips/ralink/cevt-rt3352.c
@@ -138,7 +138,7 @@ static void __init ralink_systick_init(struct device_node *np)
 
 	clockevents_register_device(&systick.dev);
 
-	pr_info("%s: runing - mult: %d, shift: %d\n",
+	pr_info("%s: running - mult: %d, shift: %d\n",
 			np->name, systick.dev.mult, systick.dev.shift);
 }
 
diff --git a/arch/mips/ralink/timer.c b/arch/mips/ralink/timer.c
index 2027857..e38692a 100644
--- a/arch/mips/ralink/timer.c
+++ b/arch/mips/ralink/timer.c
@@ -147,7 +147,7 @@ static int rt_timer_probe(struct platform_device *pdev)
 	rt_timer_config(rt, 2);
 	rt_timer_enable(rt);
 
-	dev_info(&pdev->dev, "maximum frequncy is %luHz\n", rt->timer_freq);
+	dev_info(&pdev->dev, "maximum frequency is %luHz\n", rt->timer_freq);
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index be7b1aa..37f7a89 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -245,7 +245,7 @@ static irqreturn_t mpc52xx_lpbfifo_irq(int irq, void *dev_id)
 
 	if (dma && !write) {
 		spin_unlock_irqrestore(&lpbfifo.lock, flags);
-		pr_err("bogus LPBFIFO IRQ (dma and not writting)\n");
+		pr_err("bogus LPBFIFO IRQ (dma and not writing)\n");
 		return IRQ_HANDLED;
 	}
 
diff --git a/drivers/char/msm_smd_pkt.c b/drivers/char/msm_smd_pkt.c
index 8eca55d..ba82a06 100644
--- a/drivers/char/msm_smd_pkt.c
+++ b/drivers/char/msm_smd_pkt.c
@@ -182,7 +182,7 @@ static int smd_pkt_write(struct file *file, const char __user *buf,
 	if (count > MAX_BUF_SIZE)
 		return -EINVAL;
 
-	DBG("writting %d bytes\n", count);
+	DBG("writing %d bytes\n", count);
 
 	smd_pkt_devp = file->private_data;
 	if (!smd_pkt_devp || !smd_pkt_devp->ch)
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index a60da3c..6eef1f7 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -152,7 +152,7 @@ static int exynos5_busfreq_int_target(struct device *dev, unsigned long *_freq,
 	if (old_freq == freq)
 		return 0;
 
-	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, volt);
+	dev_dbg(dev, "targeting %lukHz %luuV\n", freq, volt);
 
 	mutex_lock(&data->lock);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 8adfc8f..30d76b2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -345,7 +345,7 @@ static bool fimc_check_ovf(struct fimc_context *ctx)
 
 		fimc_write(cfg, EXYNOS_CIWDOFST);
 
-		dev_err(ippdrv->dev, "occured overflow at %d, status 0x%x.\n",
+		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
 		return true;
 	}
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index cd6aebd..fa75059 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1301,13 +1301,13 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
 
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
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index c1ef228..044f85b 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -571,7 +571,7 @@ static int exynos5_i2c_xfer(struct i2c_adapter *adap,
 	int i = 0, ret = 0, stop = 0;
 
 	if (i2c->suspended) {
-		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
+		dev_err(i2c->dev, "HS-I2C is not initialized.\n");
 		return -EIO;
 	}
 
diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index 53e1c64..53a24eb 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -969,7 +969,7 @@ static int twl6030_gpadc_suspend(struct device *pdev)
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCR,
 				TWL6030_REG_TOGGLE1);
 	if (ret)
-		dev_err(pdev, "error reseting GPADC (%d)!\n", ret);
+		dev_err(pdev, "error resetting GPADC (%d)!\n", ret);
 
 	return 0;
 };
diff --git a/drivers/isdn/hisax/hfc4s8s_l1.c b/drivers/isdn/hisax/hfc4s8s_l1.c
index c49c294..414dbf6 100644
--- a/drivers/isdn/hisax/hfc4s8s_l1.c
+++ b/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -1620,7 +1620,7 @@ hfc4s8s_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #else
 	if (!request_region(hw->iobase, 8, hw->card_name)) {
 		printk(KERN_INFO
-		       "HFC-4S/8S: failed to rquest address space at 0x%04x\n",
+		       "HFC-4S/8S: failed to request address space at 0x%04x\n",
 		       hw->iobase);
 		goto out;
 	}
diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index af0a5ff..fcbe48a 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -577,8 +577,8 @@ static void dump_dtd(struct vpdma_dtd *dtd)
 		pr_debug("word5: max_width %d, max_height %d\n",
 			dtd_get_max_width(dtd), dtd_get_max_height(dtd));
 
-	pr_debug("word6: client specfic attr0 = 0x%08x\n", dtd->client_attr0);
-	pr_debug("word7: client specfic attr1 = 0x%08x\n", dtd->client_attr1);
+	pr_debug("word6: client specific attr0 = 0x%08x\n", dtd->client_attr0);
+	pr_debug("word7: client specific attr1 = 0x%08x\n", dtd->client_attr1);
 }
 
 /*
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 178b222..65f18f1 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -248,7 +248,7 @@ int lbs_process_event(struct lbs_private *priv, u32 event)
 		/* handle unexpected PS SLEEP event */
 		if (priv->psstate == PS_STATE_FULL_POWER) {
 			lbs_deb_cmd(
-			       "EVENT: in FULL POWER mode, ignoreing PS_SLEEP\n");
+			       "EVENT: in FULL POWER mode, ignoring PS_SLEEP\n");
 			break;
 		}
 		priv->psstate = PS_STATE_PRE_SLEEP;
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 025f14e..77b890e 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1624,7 +1624,7 @@ static int dlfb_usb_probe(struct usb_interface *interface,
 	}
 
 	if (pixel_limit) {
-		pr_warn("DL chip limit of %d overriden"
+		pr_warn("DL chip limit of %d overridden"
 			" by module param to %d\n",
 			dev->sku_pixel_limit, pixel_limit);
 		dev->sku_pixel_limit = pixel_limit;
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 6fc8201..790f118 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -101,7 +101,7 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 
 	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
 	if (ret) {
-		test_msg("Error removing middle peice %d\n", ret);
+		test_msg("Error removing middle piece %d\n", ret);
 		return ret;
 	}
 
diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 07bbc24..8b362e8 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -563,7 +563,7 @@ static void digital_tg_recv_psl_req(struct nfc_digital_dev *ddev, void *arg,
 		rf_tech = NFC_DIGITAL_RF_TECH_424F;
 		break;
 	default:
-		pr_err("Unsuported dsi value %d\n", dsi);
+		pr_err("Unsupported dsi value %d\n", dsi);
 		goto exit;
 	}
 
-- 
1.8.5.rc1.28.g7061504

