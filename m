Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3CTCAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:00:44 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:43973 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3CTCAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:00:42 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typos in printk
Date: Wed, 20 Mar 2013 11:00:34 +0900
Message-Id: <1363744834-18503-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/ata/sata_fsl.c                | 2 +-
 drivers/clk/mvebu/clk-core.c          | 4 ++--
 drivers/gpu/drm/i915/intel_dp.c       | 2 +-
 drivers/media/usb/dvb-usb/opera1.c    | 2 +-
 drivers/net/ethernet/ti/cpts.c        | 2 +-
 drivers/power/pm2301_charger.c        | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c | 2 +-
 drivers/video/goldfishfb.c            | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 608f82f..dfc6fd0 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -311,7 +311,7 @@ static void fsl_sata_set_irq_coalescing(struct ata_host *host,
 	intr_coalescing_ticks = ticks;
 	spin_unlock(&host->lock);
 
-	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
+	DPRINTK("interrupt coalescing, count = 0x%x, ticks = %x\n",
 			intr_coalescing_count, intr_coalescing_ticks);
 	DPRINTK("ICC register status: (hcr base: 0x%x) = 0x%x\n",
 			hcr_base, ioread32(hcr_base + ICC));
diff --git a/drivers/clk/mvebu/clk-core.c b/drivers/clk/mvebu/clk-core.c
index 69056a7..1b4e333 100644
--- a/drivers/clk/mvebu/clk-core.c
+++ b/drivers/clk/mvebu/clk-core.c
@@ -157,7 +157,7 @@ static u32 __init armada_370_get_cpu_freq(void __iomem *sar)
 	cpu_freq_select = ((readl(sar) >> SARL_A370_PCLK_FREQ_OPT) &
 			   SARL_A370_PCLK_FREQ_OPT_MASK);
 	if (cpu_freq_select > ARRAY_SIZE(armada_370_cpu_frequencies)) {
-		pr_err("CPU freq select unsuported %d\n", cpu_freq_select);
+		pr_err("CPU freq select unsupported %d\n", cpu_freq_select);
 		cpu_freq = 0;
 	} else
 		cpu_freq = armada_370_cpu_frequencies[cpu_freq_select];
@@ -279,7 +279,7 @@ static u32 __init armada_xp_get_cpu_freq(void __iomem *sar)
 			     SARH_AXP_PCLK_FREQ_OPT_MASK)
 			    << SARH_AXP_PCLK_FREQ_OPT_SHIFT);
 	if (cpu_freq_select > ARRAY_SIZE(armada_xp_cpu_frequencies)) {
-		pr_err("CPU freq select unsuported: %d\n", cpu_freq_select);
+		pr_err("CPU freq select unsupported: %d\n", cpu_freq_select);
 		cpu_freq = 0;
 	} else
 		cpu_freq = armada_xp_cpu_frequencies[cpu_freq_select];
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 662a185..6d84431 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1975,7 +1975,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 	}
 
 	if (channel_eq)
-		DRM_DEBUG_KMS("Channel EQ done. DP Training successfull\n");
+		DRM_DEBUG_KMS("Channel EQ done. DP Training successful\n");
 
 	intel_dp_set_link_train(intel_dp, DP, DP_TRAINING_PATTERN_DISABLE);
 }
diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index c8a9504..16ba90a 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -151,7 +151,7 @@ static int opera1_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			break;
 		}
 		if (dvb_usb_opera1_debug & 0x10)
-			info("sending i2c mesage %d %d", tmp, msg[i].len);
+			info("sending i2c message %d %d", tmp, msg[i].len);
 	}
 	mutex_unlock(&d->i2c_mutex);
 	return num;
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 463597f..8c351f1 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -94,7 +94,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		case CPTS_EV_HW:
 			break;
 		default:
-			pr_err("cpts: unkown event type\n");
+			pr_err("cpts: unknown event type\n");
 			break;
 		}
 		if (type == match)
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ed48d75..ee346d4 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -235,7 +235,7 @@ out:
 
 static int pm2xxx_charger_wd_exp_mngt(struct pm2xxx_charger *pm2, int val)
 {
-	dev_dbg(pm2->dev , "20 minutes watchdog occured\n");
+	dev_dbg(pm2->dev , "20 minutes watchdog expired\n");
 
 	pm2->ac.wd_expired = true;
 	power_supply_changed(&pm2->ac_chg.psy);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 1df9ed4..4db0c7a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -148,7 +148,7 @@ _config_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 			desc = "raid_config";
 			break;
 		case MPI2_CONFIG_EXTPAGETYPE_DRIVER_MAPPING:
-			desc = "driver_mappping";
+			desc = "driver_mapping";
 			break;
 		}
 		break;
diff --git a/drivers/video/goldfishfb.c b/drivers/video/goldfishfb.c
index 489abb3..7f6c9e6 100644
--- a/drivers/video/goldfishfb.c
+++ b/drivers/video/goldfishfb.c
@@ -148,7 +148,7 @@ static int goldfish_fb_pan_display(struct fb_var_screeninfo *var,
 	wait_event_timeout(fb->wait,
 			fb->base_update_count != base_update_count, HZ / 15);
 	if (fb->base_update_count == base_update_count)
-		pr_err("goldfish_fb_pan_display: timeout wating for base update\n");
+		pr_err("goldfish_fb_pan_display: timeout waiting for base update\n");
 	return 0;
 }
 
-- 
1.8.2

