Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAGM6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:58:30 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43046 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaAGM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:58:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typo in printk
Date: Tue,  7 Jan 2014 21:58:06 +0900
Message-Id: <1389099486-22597-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed several typo in printk from various
part of kernel source.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/powerpc/platforms/powernv/opal-flash.c   | 4 ++--
 drivers/i2c/busses/i2c-stu300.c               | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
 drivers/misc/fsa9480.c                        | 2 +-
 drivers/misc/mei/nfc.c                        | 2 +-
 drivers/net/wan/lmc/lmc_main.c                | 2 +-
 drivers/scsi/qla2xxx/qla_nx2.c                | 2 +-
 drivers/scsi/qla4xxx/ql4_83xx.c               | 2 +-
 drivers/tty/serial/crisv10.c                  | 2 +-
 drivers/usb/serial/kobil_sct.c                | 2 +-
 fs/btrfs/tests/free-space-tests.c             | 2 +-
 net/nfc/hci/llc_shdlc.c                       | 2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-flash.c b/arch/powerpc/platforms/powernv/opal-flash.c
index 4aeae4f..d8f67ba 100644
--- a/arch/powerpc/platforms/powernv/opal-flash.c
+++ b/arch/powerpc/platforms/powernv/opal-flash.c
@@ -105,7 +105,7 @@ struct image_header_t {
 
 struct validate_flash_t {
 	int		status;		/* Return status */
-	void		*buf;		/* Candiate image buffer */
+	void		*buf;		/* Candidate image buffer */
 	uint32_t	buf_size;	/* Image size */
 	uint32_t	result;		/* Update results token */
 };
@@ -481,7 +481,7 @@ static int alloc_image_buf(char *buffer, size_t count)
 
 	memcpy(&image_header, (void *)buffer, sizeof(struct image_header_t));
 	image_data.size = be32_to_cpu(image_header.size);
-	pr_debug("FLASH: Candiate image size = %u\n", image_data.size);
+	pr_debug("FLASH: Candidate image size = %u\n", image_data.size);
 
 	if (image_data.size > MAX_IMAGE_SIZE) {
 		pr_warn("FLASH: Too large image\n");
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index 04a17b9..5b80ef3 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -801,7 +801,7 @@ static int stu300_xfer_msg(struct i2c_adapter *adap,
 	/* Check that the bus is free, or wait until some timeout occurs */
 	ret = stu300_wait_while_busy(dev);
 	if (ret != 0) {
-		dev_err(&dev->pdev->dev, "timout waiting for transfer "
+		dev_err(&dev->pdev->dev, "timeout waiting for transfer "
 		       "to commence.\n");
 		goto exit_disable;
 	}
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index ca5fa6a..5e86e0f 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -322,7 +322,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
 	} else {
-		usnic_err("Failed to transistion %u from %s to %s",
+		usnic_err("Failed to transition %u from %s to %s",
 		qp_grp->grp_id,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index a725c79..71d2793 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -396,7 +396,7 @@ static int fsa9480_irq_init(struct fsa9480_usbsw *usbsw)
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				"fsa9480 micro USB", usbsw);
 		if (ret) {
-			dev_err(&client->dev, "failed to reqeust IRQ\n");
+			dev_err(&client->dev, "failed to request IRQ\n");
 			return ret;
 		}
 
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 0a89220..9e5a815 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -428,7 +428,7 @@ static void mei_nfc_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (mei_nfc_if_version(ndev) < 0) {
-		dev_err(&dev->pdev->dev, "Could not get the NFC interfave version");
+		dev_err(&dev->pdev->dev, "Could not get the NFC interface version");
 
 		goto err;
 	}
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index c59b91f..b45ea94 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -2124,7 +2124,7 @@ bug_out:
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
 
-    lmc_trace(dev, "lmc_driver_timout out");
+    lmc_trace(dev, "lmc_driver_timeout out");
 
 
 }
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index b45f4d7..f60989d 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2254,7 +2254,7 @@ qla8044_minidump_process_rdmem(struct scsi_qla_host *vha,
 
 	if (r_addr & 0xf) {
 		ql_dbg(ql_dbg_p3p, vha, 0xb0f1,
-		    "[%s]: Read addr 0x%x not 16 bytes alligned\n",
+		    "[%s]: Read addr 0x%x not 16 bytes aligned\n",
 		    __func__, r_addr);
 		return QLA_FUNCTION_FAILED;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 8196c2f..9192848 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -465,7 +465,7 @@ int qla4_83xx_drv_lock(struct scsi_qla_host *ha)
 				}
 				/* Recovery Failed, some other function
 				 * has the lock, wait for 2secs and retry */
-				ql4_printk(KERN_INFO, ha, "%s: IDC lock Recovery by %d failed, Retrying timout\n",
+				ql4_printk(KERN_INFO, ha, "%s: IDC lock Recovery by %d failed, Retrying timeout\n",
 					   __func__, ha->func_num);
 				timeout = 0;
 			}
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 477f22f..690bdea 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -2153,7 +2153,7 @@ static void flush_timeout_function(unsigned long data)
 
 	fast_timers[info->line].function = NULL;
 	serial_fast_timer_expired++;
-	TIMERD(DEBUG_LOG(info->line, "flush_timout %i ", info->line));
+	TIMERD(DEBUG_LOG(info->line, "flush_timeout %i ", info->line));
 	TIMERD(DEBUG_LOG(info->line, "num expired: %i\n", serial_fast_timer_expired));
 	check_flush_timeout(info);
 }
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 78b48c3..4c94ffc 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -194,7 +194,7 @@ static int kobil_open(struct tty_struct *tty, struct usb_serial_port *port)
 			  KOBIL_TIMEOUT
 	);
 	dev_dbg(dev, "%s - Send get_HW_version URB returns: %i\n", __func__, result);
-	dev_dbg(dev, "Harware version: %i.%i.%i\n", transfer_buffer[0],
+	dev_dbg(dev, "Hardware version: %i.%i.%i\n", transfer_buffer[0],
 		transfer_buffer[1], transfer_buffer[2]);
 
 	/* get firmware version */
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 790f118..c8d9ddf 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -266,7 +266,7 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	}
 
 	if (test_check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
-		test_msg("Left over peices after removing overlapping\n");
+		test_msg("Left over pieces after removing overlapping\n");
 		return -1;
 	}
 
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 719ad0a..401c7e2 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -298,7 +298,7 @@ static void llc_shdlc_rcv_rej(struct llc_shdlc *shdlc, int y_nr)
 {
 	struct sk_buff *skb;
 
-	pr_debug("remote asks retransmition from frame %d\n", y_nr);
+	pr_debug("remote asks retransmission from frame %d\n", y_nr);
 
 	if (llc_shdlc_x_lteq_y_lt_z(shdlc->dnr, y_nr, shdlc->ns)) {
 		if (shdlc->t2_active) {
-- 
1.8.5.2.229.g4448466

