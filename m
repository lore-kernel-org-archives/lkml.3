Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbAVM5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:57:05 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52146 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbAVM5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:57:02 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typo in printk messages
Date: Thu, 22 Jan 2015 21:56:54 +0900
Message-Id: <1421931414-24426-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in printk messages.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/powerpc/perf/hv-24x7.c                      | 2 +-
 drivers/clk/samsung/clk.c                        | 2 +-
 drivers/gpu/drm/drm_atomic.c                     | 4 ++--
 drivers/gpu/drm/nouveau/core/engine/graph/nv10.c | 4 ++--
 drivers/mfd/si476x-i2c.c                         | 2 +-
 drivers/mmc/core/mmc.c                           | 4 ++--
 drivers/mmc/core/sd.c                            | 4 ++--
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c            | 2 +-
 drivers/net/phy/dp83640.c                        | 2 +-
 drivers/net/wireless/airo.c                      | 4 ++--
 drivers/net/wireless/ath/wcn36xx/smd.c           | 2 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c         | 2 +-
 drivers/scsi/ch.c                                | 2 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c              | 2 +-
 fs/jffs2/xattr.c                                 | 2 +-
 lib/rhashtable.c                                 | 2 +-
 net/atm/mpoa_proc.c                              | 2 +-
 sound/soc/soc-core.c                             | 4 ++--
 18 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index f162d0b..ad54968 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -359,7 +359,7 @@ static int h_24x7_event_init(struct perf_event *event)
 	/* PHYSICAL domains & other lpars require extra capabilities */
 	if (!caps.collect_privileged && (is_physical_domain(domain) ||
 		(event_get_lpar(event) != event_get_lpar_max()))) {
-		pr_devel("hv permisions disallow: is_physical_domain:%d, lpar=0x%llx\n",
+		pr_devel("hv permissions disallow: is_physical_domain:%d, lpar=0x%llx\n",
 				is_physical_domain(domain),
 				event_get_lpar(event));
 		return -EACCES;
diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 4bda540..3168e16 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -386,7 +386,7 @@ void __init samsung_cmu_register_one(struct device_node *np,
 
 	ctx = samsung_clk_init(np, reg_base, cmu->nr_clk_ids);
 	if (!ctx)
-		panic("%s: unable to alllocate ctx\n", __func__);
+		panic("%s: unable to allocate ctx\n", __func__);
 
 	if (cmu->pll_clks)
 		samsung_clk_register_pll(ctx, cmu->pll_clks, cmu->nr_pll_clks,
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index af3f3df..e3a1e16 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1013,7 +1013,7 @@ int drm_atomic_commit(struct drm_atomic_state *state)
 	if (ret)
 		return ret;
 
-	DRM_DEBUG_KMS("commiting %p\n", state);
+	DRM_DEBUG_KMS("committing %p\n", state);
 
 	return config->funcs->atomic_commit(state->dev, state, false);
 }
@@ -1044,7 +1044,7 @@ int drm_atomic_async_commit(struct drm_atomic_state *state)
 	if (ret)
 		return ret;
 
-	DRM_DEBUG_KMS("commiting %p asynchronously\n", state);
+	DRM_DEBUG_KMS("committing %p asynchronously\n", state);
 
 	return config->funcs->atomic_commit(state->dev, state, true);
 }
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nv10.c b/drivers/gpu/drm/nouveau/core/engine/graph/nv10.c
index 2b12b09..0f280bd 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nv10.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nv10.c
@@ -848,7 +848,7 @@ nv10_graph_ctx_regs_find_offset(struct nv10_graph_priv *priv, int reg)
 		if (nv10_graph_ctx_regs[i] == reg)
 			return i;
 	}
-	nv_error(priv, "unknow offset nv10_ctx_regs %d\n", reg);
+	nv_error(priv, "unknown offset nv10_ctx_regs %d\n", reg);
 	return -1;
 }
 
@@ -860,7 +860,7 @@ nv17_graph_ctx_regs_find_offset(struct nv10_graph_priv *priv, int reg)
 		if (nv17_graph_ctx_regs[i] == reg)
 			return i;
 	}
-	nv_error(priv, "unknow offset nv17_ctx_regs %d\n", reg);
+	nv_error(priv, "unknown offset nv17_ctx_regs %d\n", reg);
 	return -1;
 }
 
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
index 0e4a76d..7f87c62 100644
--- a/drivers/mfd/si476x-i2c.c
+++ b/drivers/mfd/si476x-i2c.c
@@ -766,7 +766,7 @@ static int si476x_core_probe(struct i2c_client *client,
 			   sizeof(struct v4l2_rds_data),
 			   GFP_KERNEL);
 	if (rval) {
-		dev_err(&client->dev, "Could not alloate the FIFO\n");
+		dev_err(&client->dev, "Could not allocate the FIFO\n");
 		goto free_gpio;
 	}
 	mutex_init(&core->rds_drainer_status_lock);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1fc48a2..214664d 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1748,7 +1748,7 @@ static int mmc_runtime_suspend(struct mmc_host *host)
 
 	err = _mmc_suspend(host, true);
 	if (err)
-		pr_err("%s: error %d doing aggessive suspend\n",
+		pr_err("%s: error %d doing aggressive suspend\n",
 			mmc_hostname(host), err);
 
 	return err;
@@ -1766,7 +1766,7 @@ static int mmc_runtime_resume(struct mmc_host *host)
 
 	err = _mmc_resume(host);
 	if (err)
-		pr_err("%s: error %d doing aggessive resume\n",
+		pr_err("%s: error %d doing aggressive resume\n",
 			mmc_hostname(host), err);
 
 	return 0;
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index ad4d43e..31a9ef2 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1157,7 +1157,7 @@ static int mmc_sd_runtime_suspend(struct mmc_host *host)
 
 	err = _mmc_sd_suspend(host);
 	if (err)
-		pr_err("%s: error %d doing aggessive suspend\n",
+		pr_err("%s: error %d doing aggressive suspend\n",
 			mmc_hostname(host), err);
 
 	return err;
@@ -1175,7 +1175,7 @@ static int mmc_sd_runtime_resume(struct mmc_host *host)
 
 	err = _mmc_sd_resume(host);
 	if (err)
-		pr_err("%s: error %d doing aggessive resume\n",
+		pr_err("%s: error %d doing aggressive resume\n",
 			mmc_hostname(host), err);
 
 	return 0;
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 27f272e..43fa16b 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -1105,7 +1105,7 @@ int gpmi_is_ready(struct gpmi_nand_data *this, unsigned chip)
 		mask = MX28_BF_GPMI_STAT_READY_BUSY(1 << chip);
 		reg = readl(r->gpmi_regs + HW_GPMI_STAT);
 	} else
-		dev_err(this->dev, "unknow arch.\n");
+		dev_err(this->dev, "unknown arch.\n");
 	return reg & mask;
 }
 
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index e22e602..4c2b5a80 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -614,7 +614,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	trigger = CAL_TRIGGER;
 	cal_gpio = 1 + ptp_find_pin(clock->ptp_clock, PTP_PF_PHYSYNC, 0);
 	if (cal_gpio < 1) {
-		pr_err("PHY calibration pin not avaible - PHY is not calibrated.");
+		pr_err("PHY calibration pin not available - PHY is not calibrated.");
 		return;
 	}
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index e71a2ce..b97367d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3211,7 +3211,7 @@ static void airo_print_status(const char *devname, u16 status)
 			airo_print_dbg(devname, "link lost (TSF sync lost)");
 			break;
 		default:
-			airo_print_dbg(devname, "unknow status %x\n", status);
+			airo_print_dbg(devname, "unknown status %x\n", status);
 			break;
 		}
 		break;
@@ -3233,7 +3233,7 @@ static void airo_print_status(const char *devname, u16 status)
 	case STAT_REASSOC:
 		break;
 	default:
-		airo_print_dbg(devname, "unknow status %x\n", status);
+		airo_print_dbg(devname, "unknown status %x\n", status);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 6398693..3866b285 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1632,7 +1632,7 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 	} else if (packet_type == WCN36XX_HAL_KEEP_ALIVE_UNSOLICIT_ARP_RSP) {
 		/* TODO: it also support ARP response type */
 	} else {
-		wcn36xx_warn("unknow keep alive packet type %d\n", packet_type);
+		wcn36xx_warn("unknown keep alive packet type %d\n", packet_type);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 1806b24..23db4c9 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -466,7 +466,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 		break;
 
 	default:
-		dev_dbg(pct->dev, "unknow alt_setting %d\n", alt_setting);
+		dev_dbg(pct->dev, "unknown alt_setting %d\n", alt_setting);
 
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 79e462f..f65ff06 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -347,7 +347,7 @@ ch_readconfig(scsi_changer *ch)
 			ch->firsts[CHET_DT],
 			ch->counts[CHET_DT]);
 	} else {
-		VPRINTK(KERN_INFO, "reading element address assigment page failed!\n");
+		VPRINTK(KERN_INFO, "reading element address assignment page failed!\n");
 	}
 
 	/* vendor specific element types */
diff --git a/drivers/usb/gadget/udc/bdc/bdc_ep.c b/drivers/usb/gadget/udc/bdc/bdc_ep.c
index b04980c..7e3deea 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@ -81,7 +81,7 @@ static void ep_bd_list_free(struct bdc_ep *ep, u32 num_tabs)
 			continue;
 		}
 		if (!bd_table->start_bd) {
-			dev_dbg(bdc->dev, "bd dma pool not allocted\n");
+			dev_dbg(bdc->dev, "bd dma pool not allocated\n");
 			continue;
 		}
 
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index d72817a..762c7a3 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -195,7 +195,7 @@ static int do_verify_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_dat
 	/* unchecked xdatum is chained with c->xattr_unchecked */
 	list_del_init(&xd->xindex);
 
-	dbg_xattr("success on verfying xdatum (xid=%u, version=%u)\n",
+	dbg_xattr("success on verifying xdatum (xid=%u, version=%u)\n",
 		  xd->xid, xd->version);
 
 	return 0;
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 84a78e3..5fcb998 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1002,7 +1002,7 @@ static void test_bucket_stats(struct rhashtable *ht, bool quiet)
 			rcu_cnt++;
 
 		if (rcu_cnt != cnt)
-			pr_warn("Test failed: Chain count mismach %d != %d",
+			pr_warn("Test failed: Chain count mismatch %d != %d",
 				cnt, rcu_cnt);
 
 		if (!quiet)
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 5bdd300..2df34eb 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -272,7 +272,7 @@ static int parse_qos(const char *buff)
 	qos.rxtp.max_pcr = rx_pcr;
 	qos.rxtp.max_sdu = rx_sdu;
 	qos.aal = ATM_AAL5;
-	dprintk("parse_qos(): setting qos paramameters to tx=%d,%d rx=%d,%d\n",
+	dprintk("parse_qos(): setting qos parameters to tx=%d,%d rx=%d,%d\n",
 		qos.txtp.max_pcr, qos.txtp.max_sdu,
 		qos.rxtp.max_pcr, qos.rxtp.max_sdu);
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index ededb97..f933821 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2733,7 +2733,7 @@ int snd_soc_register_component(struct device *dev,
 
 	ret = snd_soc_register_dais(cmpnt, dai_drv, num_dai, true);
 	if (ret < 0) {
-		dev_err(dev, "ASoC: Failed to regster DAIs: %d\n", ret);
+		dev_err(dev, "ASoC: Failed to register DAIs: %d\n", ret);
 		goto err_cleanup;
 	}
 
@@ -3047,7 +3047,7 @@ int snd_soc_register_codec(struct device *dev,
 
 	ret = snd_soc_register_dais(&codec->component, dai_drv, num_dai, false);
 	if (ret < 0) {
-		dev_err(dev, "ASoC: Failed to regster DAIs: %d\n", ret);
+		dev_err(dev, "ASoC: Failed to register DAIs: %d\n", ret);
 		goto err_cleanup;
 	}
 
-- 
2.3.0.rc1

