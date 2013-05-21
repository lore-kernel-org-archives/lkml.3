Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EUONh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:13:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39370 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3EUONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:13:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] treewide: Fix typo in printk
Date: Tue, 21 May 2013 23:13:12 +0900
Message-Id: <1369145592-26282-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.rc3
In-Reply-To: <1369063075-13798-1-git-send-email-standby24x7@gmail.com>
References: <1369063075-13798-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various part of drivers

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/drm_fb_cma_helper.c                      | 4 ++--
 drivers/gpu/drm/radeon/radeon_fb.c                       | 2 +-
 drivers/infiniband/ulp/isert/ib_isert.c                  | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             | 2 +-
 drivers/misc/dummy-irq.c                                 | 2 +-
 drivers/misc/lattice-ecp3-config.c                       | 2 +-
 drivers/misc/mei/hbm.c                                   | 2 +-
 drivers/misc/mei/init.c                                  | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 +-
 drivers/nfc/pn533.c                                      | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                         | 2 +-
 drivers/tty/serial/serial-tegra.c                        | 2 +-
 drivers/usb/musb/musb_dsps.c                             | 2 +-
 drivers/usb/musb/omap2430.c                              | 2 +-
 drivers/video/omap2/displays/panel-n8x0.c                | 2 +-
 fs/btrfs/free-space-cache.c                              | 2 +-
 tools/testing/ktest/ktest.pl                             | 2 +-
 17 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_cma_helper.c b/drivers/gpu/drm/drm_fb_cma_helper.c
index 0b5af7d..c385cc5 100644
--- a/drivers/gpu/drm/drm_fb_cma_helper.c
+++ b/drivers/gpu/drm/drm_fb_cma_helper.c
@@ -92,7 +92,7 @@ static struct drm_fb_cma *drm_fb_cma_alloc(struct drm_device *dev,
 
 	ret = drm_framebuffer_init(dev, &fb_cma->fb, &drm_fb_cma_funcs);
 	if (ret) {
-		dev_err(dev->dev, "Failed to initalize framebuffer: %d\n", ret);
+		dev_err(dev->dev, "Failed to initialize framebuffer: %d\n", ret);
 		kfree(fb_cma);
 		return ERR_PTR(ret);
 	}
@@ -376,7 +376,7 @@ struct drm_fbdev_cma *drm_fbdev_cma_init(struct drm_device *dev,
 
 	ret = drm_fb_helper_initial_config(helper, preferred_bpp);
 	if (ret < 0) {
-		dev_err(dev->dev, "Failed to set inital hw configuration.\n");
+		dev_err(dev->dev, "Failed to set initial hw configuration.\n");
 		goto err_drm_fb_helper_fini;
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index b174674..665ced3 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -230,7 +230,7 @@ static int radeonfb_create(struct drm_fb_helper *helper,
 
 	ret = radeon_framebuffer_init(rdev->ddev, &rfbdev->rfb, &mode_cmd, gobj);
 	if (ret) {
-		DRM_ERROR("failed to initalise framebuffer %d\n", ret);
+		DRM_ERROR("failed to initialize framebuffer %d\n", ret);
 		goto out_unref;
 	}
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 41712f0..2693129 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1587,7 +1587,7 @@ isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 	isert_init_send_wr(isert_cmd, send_wr);
 
-	pr_debug("Posting NOPIN Reponse IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
+	pr_debug("Posting NOPIN Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
 	return isert_post_response(isert_conn, isert_cmd);
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4af53bd..0fa1e9b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -954,7 +954,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[0] = ctx->dec_src_buf_size;
 		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 	} else {
-		mfc_err("This video node is dedicated to decoding. Decoding not initalised\n");
+		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/misc/dummy-irq.c b/drivers/misc/dummy-irq.c
index 7014167..7cde120 100644
--- a/drivers/misc/dummy-irq.c
+++ b/drivers/misc/dummy-irq.c
@@ -26,7 +26,7 @@ static irqreturn_t dummy_interrupt(int irq, void *dev_id)
 	static int count = 0;
 
 	if (count == 0) {
-		printk(KERN_INFO "dummy-irq: interrupt occured on IRQ %d\n",
+		printk(KERN_INFO "dummy-irq: interrupt occurred on IRQ %d\n",
 				irq);
 		count++;
 	}
diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index bb26f08..61fbe6a 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -170,7 +170,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 
 	/* Check result */
 	if (status & FPGA_STATUS_DONE)
-		dev_info(&spi->dev, "FPGA succesfully configured!\n");
+		dev_info(&spi->dev, "FPGA successfully configured!\n");
 	else
 		dev_info(&spi->dev, "FPGA not configured (DONE not set)\n");
 
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 6916045..54ffcbc 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -139,7 +139,7 @@ int mei_hbm_start_wait(struct mei_device *dev)
 
 	if (ret <= 0 && (dev->hbm_state <= MEI_HBM_START)) {
 		dev->hbm_state = MEI_HBM_IDLE;
-		dev_err(&dev->pdev->dev, "wating for mei start failed\n");
+		dev_err(&dev->pdev->dev, "waiting for mei start failed\n");
 		return -ETIMEDOUT;
 	}
 	return 0;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 713d89f..422d9c3 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -38,7 +38,7 @@ const char *mei_dev_state_str(int state)
 	MEI_DEV_STATE(POWER_DOWN);
 	MEI_DEV_STATE(POWER_UP);
 	default:
-		return "unkown";
+		return "unknown";
 	}
 #undef MEI_DEV_STATE
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 3869c38..e44bcbb 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -1675,7 +1675,7 @@ static int qlcnic_sriov_vf_handle_dev_ready(struct qlcnic_adapter *adapter)
 			qlcnic_sriov_vf_attach(adapter);
 			adapter->fw_fail_cnt = 0;
 			dev_info(dev,
-				 "%s: Reinitalization of VF 0x%x done after FW reset\n",
+				 "%s: Reinitialization of VF 0x%x done after FW reset\n",
 				 __func__, func);
 		} else {
 			dev_err(dev,
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 8f6f2ba..ec269e6 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1697,7 +1697,7 @@ static int pn533_poll_complete(struct pn533 *dev, void *arg,
 		goto done;
 
 	if (!dev->poll_mod_count) {
-		nfc_dev_dbg(&dev->interface->dev, "Polling has been stoped.");
+		nfc_dev_dbg(&dev->interface->dev, "Polling has been stopped.");
 		goto done;
 	}
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 302514d..1c5e7d2 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3204,7 +3204,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unresgister the deviece\n"));
+			pm8001_printk("unregister the device\n"));
 		pm8001_mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 9799d04..ee7c812 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1377,7 +1377,7 @@ static int __init tegra_uart_init(void)
 
 	ret = platform_driver_register(&tegra_uart_platform_driver);
 	if (ret < 0) {
-		pr_err("Uart platfrom driver register failed, e = %d\n", ret);
+		pr_err("Uart platform driver register failed, e = %d\n", ret);
 		uart_unregister_driver(&tegra_uart_driver);
 		return ret;
 	}
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index e1b661d..5233804 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -551,7 +551,7 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata) {
 			dev_err(&pdev->dev,
-				"failed to allocate musb platfrom data\n");
+				"failed to allocate musb platform data\n");
 			ret = -ENOMEM;
 			goto err2;
 		}
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 628b93f..2325ef6 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -513,7 +513,7 @@ static int omap2430_probe(struct platform_device *pdev)
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata) {
 			dev_err(&pdev->dev,
-				"failed to allocate musb platfrom data\n");
+				"failed to allocate musb platform data\n");
 			goto err2;
 		}
 
diff --git a/drivers/video/omap2/displays/panel-n8x0.c b/drivers/video/omap2/displays/panel-n8x0.c
index f94ead6..860b180 100644
--- a/drivers/video/omap2/displays/panel-n8x0.c
+++ b/drivers/video/omap2/displays/panel-n8x0.c
@@ -527,7 +527,7 @@ static int n8x0_panel_update(struct omap_dss_device *dssdev,
 	dh = dssdev->panel.timings.y_res;
 
 	if (x != 0 || y != 0 || w != dw || h != dh) {
-		dev_err(&dssdev->dev, "invaid update region %d, %d, %d, %d\n",
+		dev_err(&dssdev->dev, "invalid update region %d, %d, %d, %d\n",
 			x, y, w, h);
 		return -EINVAL;
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ecca6c7..420bf9c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3203,7 +3203,7 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 
 	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
 	if (ret) {
-		printk(KERN_ERR "Error removing middle peice %d\n", ret);
+		printk(KERN_ERR "Error removing middle piece %d\n", ret);
 		return ret;
 	}
 
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0d7fd8b..999eab1 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1796,7 +1796,7 @@ sub monitor {
 		# We already booted into the kernel we are testing,
 		# but now we booted into another kernel?
 		# Consider this a triple fault.
-		doprint "Aleady booted in Linux kernel $version, but now\n";
+		doprint "Already booted in Linux kernel $version, but now\n";
 		doprint "we booted into Linux kernel $1.\n";
 		doprint "Assuming that this is a triple fault.\n";
 		doprint "To disable this: set DETECT_TRIPLE_FAULT to 0\n";
-- 
1.8.3.rc3

