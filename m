Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3I3OTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:19:19 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34628 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3I3OTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:19:17 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typo in printk
Date: Mon, 30 Sep 2013 23:19:09 +0900
Message-Id: <1380550749-32272-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo within various part of the kernel

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/acpi/acpica/utobject.c                      | 2 +-
 drivers/media/i2c/adv7183.c                         | 2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c            | 2 +-
 drivers/mtd/nand/docg4.c                            | 2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c             | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
 drivers/net/wireless/ath/ath10k/pci.c               | 2 +-
 drivers/regulator/tps65910-regulator.c              | 2 +-
 drivers/scsi/mvsas/mv_sas.c                         | 2 +-
 fs/btrfs/tests/free-space-tests.c                   | 4 ++--
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpica/utobject.c b/drivers/acpi/acpica/utobject.c
index aa61f66..2ae2b46 100644
--- a/drivers/acpi/acpica/utobject.c
+++ b/drivers/acpi/acpica/utobject.c
@@ -356,7 +356,7 @@ u8 acpi_ut_valid_internal_object(void *object)
 	default:
 
 		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-				  "%p is not not an ACPI operand obj [%s]\n",
+				  "%p is not an ACPI operand obj [%s]\n",
 				  object, acpi_ut_get_descriptor_name(object)));
 		break;
 	}
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
index b76ec0e..31f40b3 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1651,7 +1651,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto out_err;
 
-	v4l2_info(sd, "%s: completed succesfully\n", __func__);
+	v4l2_info(sd, "%s: completed successfully\n", __func__);
 	return 0;
 
 out_err:
diff --git a/drivers/mtd/nand/docg4.c b/drivers/mtd/nand/docg4.c
index 7c38b8a..caa53b0 100644
--- a/drivers/mtd/nand/docg4.c
+++ b/drivers/mtd/nand/docg4.c
@@ -494,7 +494,7 @@ static uint8_t docg4_read_byte(struct mtd_info *mtd)
 		return status;
 	}
 
-	dev_warn(doc->dev, "unexpectd call to read_byte()\n");
+	dev_warn(doc->dev, "unexpected call to read_byte()\n");
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 0d63daa..8a750ca 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1739,7 +1739,7 @@ void mlx4_opreq_action(struct work_struct *work)
 				   MLX4_CMD_GET_OP_REQ, MLX4_CMD_TIME_CLASS_A,
 				   MLX4_CMD_NATIVE);
 		if (err) {
-			mlx4_err(dev, "Failed to retreive required operation: %d\n",
+			mlx4_err(dev, "Failed to retrieve required operation: %d\n",
 				 err);
 			return;
 		}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 3ca00e0..e8c56af 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -1722,7 +1722,7 @@ static void qlcnic_extend_lb_idc_cmpltn_wait(struct qlcnic_adapter *adapter,
 	struct qlcnic_hardware_context *ahw = adapter->ahw;
 	int temp;
 
-	netdev_info(adapter->netdev, "Recieved loopback IDC time extend event for 0x%x seconds\n",
+	netdev_info(adapter->netdev, "Received loopback IDC time extend event for 0x%x seconds\n",
 		    ahw->extend_lb_time);
 	temp = ahw->extend_lb_time * 1000;
 	*max_wait_count += temp / QLC_83XX_LB_MSLEEP_COUNT;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 56501f4..8b13b03 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2407,7 +2407,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		break;
 	default:
 		ret = -ENODEV;
-		ath10k_err("Unkown device ID: %d\n", pci_dev->device);
+		ath10k_err("Unknown device ID: %d\n", pci_dev->device);
 		goto err_ar_pci;
 	}
 
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b8167df..87b85f4 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -906,7 +906,7 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 		}
 		ret = tps65910_reg_write(pmic->mfd, sr_reg_add, 0);
 		if (ret < 0) {
-			dev_err(mfd->dev, "Error in settting sr register\n");
+			dev_err(mfd->dev, "Error in setting sr register\n");
 			return ret;
 		}
 	}
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6b1b4e9..6c1f223 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1411,7 +1411,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
-			mv_printk("executing internel task failed:%d\n", res);
+			mv_printk("executing internal task failed:%d\n", res);
 			goto ex_err;
 		}
 
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 6fc8201..c8d9ddf 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -101,7 +101,7 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 
 	ret = btrfs_remove_free_space(cache, 2 * 1024 * 1024, 4096);
 	if (ret) {
-		test_msg("Error removing middle peice %d\n", ret);
+		test_msg("Error removing middle piece %d\n", ret);
 		return ret;
 	}
 
@@ -266,7 +266,7 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
 	}
 
 	if (test_check_exists(cache, 512 * 1024, 3 * 1024 * 1024)) {
-		test_msg("Left over peices after removing overlapping\n");
+		test_msg("Left over pieces after removing overlapping\n");
 		return -1;
 	}
 
-- 
1.8.4.474.g128a96c

