Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab3E3Ook (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:44:40 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35141 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118Ab3E3Ood (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:44:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typo in printk
Date: Thu, 30 May 2013 23:44:25 +0900
Message-Id: <1369925065-16604-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk within various part of drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/acpi/acpica/utobject.c                 | 2 +-
 drivers/cpufreq/s3c2416-cpufreq.c              | 2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c      | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 drivers/net/wireless/ath/ath9k/Kconfig         | 2 +-
 drivers/scsi/libiscsi_tcp.c                    | 2 +-
 drivers/scsi/pmcraid.c                         | 2 +-
 lib/Kconfig.kgdb                               | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpica/utobject.c b/drivers/acpi/acpica/utobject.c
index 1099f5c..61a113c 100644
--- a/drivers/acpi/acpica/utobject.c
+++ b/drivers/acpi/acpica/utobject.c
@@ -354,7 +354,7 @@ u8 acpi_ut_valid_internal_object(void *object)
 
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-				  "%p is not not an ACPI operand obj [%s]\n",
+				  "%p is not an ACPI operand obj [%s]\n",
 				  object, acpi_ut_get_descriptor_name(object)));
 		break;
 	}
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4f1881e..e594c62 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -205,7 +205,7 @@ static int s3c2416_cpufreq_leave_dvs(struct s3c2416_data *s3c_freq, int idx)
 		ret = s3c2416_cpufreq_set_armdiv(s3c_freq,
 					clk_get_rate(s3c_freq->hclk) / 1000);
 		if (ret < 0) {
-			pr_err("cpufreq: Failed to to set the armdiv to %lukHz: %d\n",
+			pr_err("cpufreq: Failed to set the armdiv to %lukHz: %d\n",
 			       clk_get_rate(s3c_freq->hclk) / 1000, ret);
 			return ret;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 0d32a82..c8595ec 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -98,7 +98,7 @@ MODULE_PARM_DESC(log_num_mgm_entry_size, "log mgm size, that defines the num"
 static bool enable_64b_cqe_eqe;
 module_param(enable_64b_cqe_eqe, bool, 0444);
 MODULE_PARM_DESC(enable_64b_cqe_eqe,
-		 "Enable 64 byte CQEs/EQEs when the the FW supports this");
+		 "Enable 64 byte CQEs/EQEs when the FW supports this");
 
 #define HCA_GLOBAL_CAP_MASK            0
 
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index cbfaed5..5a20eaf 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3444,7 +3444,7 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 	}
 
 	vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
-		"%s : checksuming enabled", __func__);
+		"%s : checksumming enabled", __func__);
 
 	if (high_dma) {
 		ndev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 3b07851..b8fe237 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -28,7 +28,7 @@ config ATH9K
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
 	  of chipsets. For a specific list of supported external
 	  cards, laptops that already ship with these cards and
-	  APs that come with these cards refer to to ath9k wiki
+	  APs that come with these cards refer to ath9k wiki
 	  products page:
 
 	  http://wireless.kernel.org/en/users/Drivers/ath9k/products
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 552e8a2..92deec5 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -558,7 +558,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
-				  "negotiated for or driver has has leaked.\n");
+				  "negotiated for or driver has leaked.\n");
 		return ISCSI_ERR_PROTO;
 	}
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 8e1b737..1eb7b028 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6092,7 +6092,7 @@ static int __init pmcraid_init(void)
 
 	if (IS_ERR(pmcraid_class)) {
 		error = PTR_ERR(pmcraid_class);
-		pmcraid_err("failed to register with with sysfs, error = %x\n",
+		pmcraid_err("failed to register with sysfs, error = %x\n",
 			    error);
 		goto out_unreg_chrdev;
 	}
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 140e878..e00037f 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -64,7 +64,7 @@ config KGDB_LOW_LEVEL_TRAP
        default n
        help
          This will add an extra call back to kgdb for the breakpoint
-         exception handler on which will will allow kgdb to step
+         exception handler on which will allow kgdb to step
          through a notify handler.
 
 config KGDB_KDB
-- 
1.8.3

