Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3HETao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:30:44 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:61754
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab3HETaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:30:39 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 15:30:38 EDT
X-IronPort-AV: E=Sophos;i="4.89,820,1367964000"; 
   d="scan'208";a="23301949"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] trivial: adjust code alignment
Date: Mon,  5 Aug 2013 21:20:49 +0200
Message-Id: <1375730449-1709-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch either adds or removes a tab so that each statement is lined
up with its neighbors.  One common problem is when a statement is
lined up with the argument list of its predecessor.  Other cases not
fitting any particular pattern arise as well.

A few checkpatch errors are cleaned up as well.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Omitted the change in drivers/media/i2c/ov7670.c that would hide a bug.

 arch/arm/mach-omap2/cclock3xxx_data.c                           |    2 -
 arch/arm/mach-omap2/display.c                                   |    2 -
 arch/m68k/sun3/prom/console.c                                   |    4 +-
 arch/parisc/kernel/perf.c                                       |    6 +--
 arch/powerpc/platforms/chrp/pci.c                               |    2 -
 arch/powerpc/platforms/ps3/system-bus.c                         |    4 +-
 arch/powerpc/sysdev/fsl_rio.c                                   |    6 +--
 arch/x86/lib/csum-partial_64.c                                  |    2 -
 arch/xtensa/platforms/iss/network.c                             |    2 -
 drivers/acpi/sbs.c                                              |    6 +--
 drivers/atm/ambassador.c                                        |    2 -
 drivers/atm/he.c                                                |    2 -
 drivers/block/mtip32xx/mtip32xx.c                               |    4 +-
 drivers/dma/iop-adma.c                                          |    2 -
 drivers/gpu/drm/gma500/cdv_intel_dp.c                           |    4 +-
 drivers/gpu/drm/i915/i915_gpu_error.c                           |    2 -
 drivers/gpu/drm/radeon/cik.c                                    |    2 -
 drivers/hid/hid-prodikeys.c                                     |    2 -
 drivers/hid/hid-sensor-hub.c                                    |    8 ++---
 drivers/i2c/algos/i2c-algo-pca.c                                |    2 -
 drivers/iio/gyro/hid-sensor-gyro-3d.c                           |    2 -
 drivers/infiniband/hw/nes/nes_nic.c                             |    2 -
 drivers/infiniband/hw/nes/nes_verbs.c                           |    2 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c                         |    4 +-
 drivers/media/dvb-frontends/dib0070.c                           |    2 -
 drivers/media/dvb-frontends/stv0900_sw.c                        |    4 +-
 drivers/media/pci/bt8xx/bttv-driver.c                           |    2 -
 drivers/media/pci/saa7134/saa7134-cards.c                       |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c                 |    3 +
 drivers/media/usb/cx231xx/cx231xx-417.c                         |    5 +--
 drivers/media/usb/dvb-usb/af9005-fe.c                           |    2 -
 drivers/media/usb/dvb-usb/dw2102.c                              |    2 -
 drivers/media/usb/gspca/benq.c                                  |    3 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                         |    6 ++-
 drivers/memstick/host/jmb38x_ms.c                               |   12 +++----
 drivers/message/fusion/mptscsih.c                               |    2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                |    6 +--
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                      |    2 -
 drivers/net/ethernet/chelsio/cxgb/sge.c                         |    4 +-
 drivers/net/ethernet/dec/tulip/interrupt.c                      |    2 -
 drivers/net/ethernet/dec/tulip/uli526x.c                        |    2 -
 drivers/net/ethernet/natsemi/ns83820.c                          |    2 -
 drivers/net/ethernet/neterion/vxge/vxge-main.c                  |    8 ++---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                    |    4 +-
 drivers/net/ethernet/realtek/atp.c                              |    2 -
 drivers/net/fddi/skfp/smt.c                                     |    2 -
 drivers/net/hamradio/scc.c                                      |    3 +
 drivers/net/irda/w83977af_ir.c                                  |   14 ++++----
 drivers/net/wireless/ath/ath5k/reset.c                          |    4 +-
 drivers/net/wireless/b43legacy/main.c                           |    2 -
 drivers/net/wireless/hostap/hostap_ap.c                         |    2 -
 drivers/net/wireless/hostap/hostap_ioctl.c                      |    2 -
 drivers/net/wireless/libertas_tf/main.c                         |    2 -
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c              |    2 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                     |    4 +-
 drivers/parisc/eisa_enumerator.c                                |    7 +---
 drivers/pci/hotplug/ibmphp_core.c                               |    6 +--
 drivers/s390/block/dasd_eckd.c                                  |    4 +-
 drivers/s390/net/qeth_core_main.c                               |    4 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c                            |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                                |   10 +++---
 drivers/scsi/atp870u.c                                          |   16 +++++-----
 drivers/scsi/bfa/bfa_ioc.c                                      |    2 -
 drivers/scsi/hpsa.c                                             |    2 -
 drivers/scsi/ipr.c                                              |    4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                                    |    2 -
 drivers/scsi/lpfc/lpfc_els.c                                    |    2 -
 drivers/scsi/lpfc/lpfc_sli.c                                    |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c                                |    2 -
 drivers/scsi/qla2xxx/qla_init.c                                 |    2 -
 drivers/scsi/qla2xxx/qla_mr.c                                   |    2 -
 drivers/scsi/scsi_debug.c                                       |    2 -
 drivers/scsi/scsi_error.c                                       |    2 -
 drivers/staging/cxt1e1/comet.c                                  |   16 +++++-----
 drivers/staging/cxt1e1/musycc.c                                 |    2 -
 drivers/staging/frontier/tranzport.c                            |    6 +--
 drivers/staging/speakup/speakup_keypc.c                         |    2 -
 drivers/usb/gadget/fsl_qe_udc.c                                 |    5 +--
 drivers/usb/host/ohci-ppc-of.c                                  |    2 -
 drivers/usb/host/u132-hcd.c                                     |    3 +
 drivers/usb/misc/ftdi-elan.c                                    |    3 +
 drivers/usb/misc/sisusbvga/sisusb.c                             |    2 -
 drivers/usb/serial/visor.c                                      |    2 -
 drivers/video/mbx/mbxfb.c                                       |    5 +--
 drivers/vlynq/vlynq.c                                           |    2 -
 fs/compat_ioctl.c                                               |    2 -
 mm/migrate.c                                                    |    2 -
 net/bluetooth/rfcomm/core.c                                     |    4 +-
 sound/oss/sb_ess.c                                              |    2 -
 sound/pci/asihpi/asihpi.c                                       |    4 +-
 sound/sparc/dbri.c                                              |    6 +--
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c |    2 -
 92 files changed, 171 insertions(+), 169 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 334b767..c8e90d1 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3615,7 +3615,7 @@ int __init omap3xxx_clk_init(void)
 		WARN(1, "clock: could not identify OMAP3 variant\n");
 	}
 
-		omap2_clk_disable_autoidle_all();
+	omap2_clk_disable_autoidle_all();
 
 	omap2_clk_enable_init_clocks(enable_init_clks,
 				     ARRAY_SIZE(enable_init_clks));
diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index ff37be1..b6a36af 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -127,7 +127,7 @@ static void __init omap4_hdmi_mux_pads(enum omap_hdmi_flags flags)
 		reg = omap4_ctrl_pad_readl(control_i2c_1);
 		reg |= (OMAP4_HDMI_DDC_SDA_PULLUPRESX_MASK |
 			OMAP4_HDMI_DDC_SCL_PULLUPRESX_MASK);
-			omap4_ctrl_pad_writel(reg, control_i2c_1);
+		omap4_ctrl_pad_writel(reg, control_i2c_1);
 	}
 }
 
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index e923643..0b2e0be 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -22,7 +22,7 @@ prom_nbgetchar(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-		i = (*(romvec->pv_nbgetchar))();
+	i = (*(romvec->pv_nbgetchar))();
 	local_irq_restore(flags);
 	return i; /* Ugh, we could spin forever on unsupported proms ;( */
 }
@@ -37,7 +37,7 @@ prom_nbputchar(char c)
 	int i = -1;
 
 	local_irq_save(flags);
-		i = (*(romvec->pv_nbputchar))(c);
+	i = (*(romvec->pv_nbputchar))(c);
 	local_irq_restore(flags);
 	return i; /* Ugh, we could spin forever on unsupported proms ;( */
 }
diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index ba0c053..0aa1ebf 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -237,7 +237,7 @@ static int perf_config(uint32_t *image_ptr)
 		return -EINVAL; 
 	}
 
-printk("Preparing to write image\n");
+	printk("Preparing to write image\n");
 	/* Write the image to the chip */
 	error = perf_write_image((uint64_t *)image_ptr);
 	if (error != 0) {
@@ -245,7 +245,7 @@ printk("Preparing to write image\n");
 		return -EINVAL; 
 	}
 
-printk("Preparing to start counters\n");
+	printk("Preparing to start counters\n");
 
 	/* Start the counters */
 	perf_start_counters();
@@ -833,7 +833,7 @@ static void perf_rdr_write(uint32_t rdr_num, uint64_t *buffer)
 	const struct rdr_tbl_ent *tentry;
 	int32_t		i;
 
-printk("perf_rdr_write\n");
+	printk("perf_rdr_write\n");
 	tentry = perf_rdr_get_entry(rdr_num);
 	if (tentry->width == 0) { return; }
 
diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
index 1b87e19..4cf466d 100644
--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -293,7 +293,7 @@ chrp_find_bridges(void)
 					dma = (unsigned int *)
 						(((unsigned long)dma) +
 						len - sizeof(*dma));
-						pci_dram_offset = *dma;
+					pci_dram_offset = *dma;
 				}
 			}
 		} else {
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 5606fe3..201ecfc 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -78,7 +78,7 @@ static int ps3_open_hv_device_sb(struct ps3_system_bus_device *dev)
 	if (result) {
 		pr_debug("%s:%d: lv1_open_device failed: %s\n", __func__,
 			__LINE__, ps3_result(result));
-			result = -EPERM;
+		result = -EPERM;
 	}
 
 done:
@@ -134,7 +134,7 @@ static int ps3_open_hv_device_gpu(struct ps3_system_bus_device *dev)
 	if (result) {
 		pr_debug("%s:%d: lv1_gpu_open failed: %s\n", __func__,
 			__LINE__, ps3_result(result));
-			result = -EPERM;
+		result = -EPERM;
 	}
 
 done:
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index e2fb317..16a6af4 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -522,9 +522,9 @@ int fsl_rio_setup(struct platform_device *dev)
 			dev_err(&dev->dev, "RIO: Error requesting master port region"
 				" 0x%016llx-0x%016llx\n",
 				(u64)port->iores.start, (u64)port->iores.end);
-				kfree(priv);
-				kfree(port);
-				continue;
+			kfree(priv);
+			kfree(port);
+			continue;
 		}
 		sprintf(port->name, "RIO mport %d", i);
 
diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index 9845371..3947f76 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -93,7 +93,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
 				    : "m" (*(unsigned long *)buff), 
 				    "r" (zero),  "0" (result));
 				--count; 
-					buff += 8;
+				buff += 8;
 			}
 			result = add32_with_carry(result>>32,
 						  result&0xffffffff); 
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 56f88b7..0b9e430 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -448,7 +448,7 @@ out:
 static int iss_net_close(struct net_device *dev)
 {
 	struct iss_net_private *lp = netdev_priv(dev);
-printk("iss_net_close!\n");
+	printk("iss_net_close!\n");
 	netif_stop_queue(dev);
 	spin_lock(&lp->lock);
 
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index aef7e1c..61c8eb0 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -426,11 +426,11 @@ static int acpi_battery_set_alarm(struct acpi_battery *battery)
 		if ((value & 0xf000) != sel) {
 			value &= 0x0fff;
 			value |= sel;
-		ret = acpi_smbus_write(sbs->hc, SMBUS_WRITE_WORD,
+			ret = acpi_smbus_write(sbs->hc, SMBUS_WRITE_WORD,
 					 ACPI_SBS_MANAGER,
 					 0x01, (u8 *)&value, 2);
-		if (ret)
-			goto end;
+			if (ret)
+				goto end;
 		}
 	}
 	ret = acpi_smbus_write(sbs->hc, SMBUS_WRITE_WORD, ACPI_SBS_BATTERY,
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index 62a7607..154c74c 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -2258,7 +2258,7 @@ static int amb_probe(struct pci_dev *pci_dev,
 
 	PRINTD (DBG_INFO, "registered Madge ATM adapter (no. %d) (%p) at %p",
 		dev->atm_dev->number, dev, dev->atm_dev);
-		dev->atm_dev->dev_data = (void *) dev;
+	dev->atm_dev->dev_data = (void *) dev;
 
 	// register our address
 	amb_esi (dev, dev->atm_dev->esi);
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 80f9743..ca1bee2 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1698,7 +1698,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 
 		if (RBRQ_HBUF_ERR(he_dev->rbrq_head)) {
 			hprintk("HBUF_ERR!  (cid 0x%x)\n", cid);
-				atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc(&vcc->stats->rx_drop);
 			goto return_host_buffers;
 		}
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 952dbfe..c246e91 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2319,8 +2319,8 @@ static int exec_drive_taskfile(struct driver_data *dd,
 				dev_warn(&dd->pdev->dev,
 					"data movement but "
 					"sect_count is 0\n");
-					err = -EINVAL;
-					goto abort;
+				err = -EINVAL;
+				goto abort;
 			}
 		}
 	}
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index cc727ec..28dce84 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -267,7 +267,7 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 					&iop_chan->chain, chain_node) {
 					zero_sum_result |=
 					    iop_desc_get_zero_result(grp_iter);
-					    pr_debug("\titer%d result: %d\n",
+					pr_debug("\titer%d result: %d\n",
 					    grp_iter->idx, zero_sum_result);
 					slot_cnt -= slots_per_op;
 					if (slot_cnt == 0)
diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
index 88d9ef6..d1a1071 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -1331,7 +1331,7 @@ cdv_intel_dp_start_link_train(struct psb_intel_encoder *encoder)
 	clock_recovery = false;
 
 	DRM_DEBUG_KMS("Start train\n");
-		reg = DP | DP_LINK_TRAIN_PAT_1;
+	reg = DP | DP_LINK_TRAIN_PAT_1;
 
 
 	for (;;) {
@@ -1407,7 +1407,7 @@ cdv_intel_dp_complete_link_train(struct psb_intel_encoder *encoder)
 	channel_eq = false;
 
 	DRM_DEBUG_KMS("\n");
-		reg = DP | DP_LINK_TRAIN_PAT_2;
+	reg = DP | DP_LINK_TRAIN_PAT_2;
 
 	for (;;) {
 
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index d970d84..1fb0c23 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -369,7 +369,7 @@ int i915_error_state_to_str(struct drm_i915_error_state_buf *m,
 					   obj->pages[0][elt+1],
 					   obj->pages[0][elt+2],
 					   obj->pages[0][elt+3]);
-					offset += 16;
+				offset += 16;
 			}
 		}
 	}
diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 6adbc99..d085258 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4849,7 +4849,7 @@ static int cik_rlc_resume(struct radeon_device *rdev)
 	WREG32(RLC_UCODE_CNTL, 0);
 
 	fw_data = (const __be32 *)rdev->rlc_fw->data;
-		WREG32(RLC_GPM_UCODE_ADDR, 0);
+	WREG32(RLC_GPM_UCODE_ADDR, 0);
 	for (i = 0; i < size; i++)
 		WREG32(RLC_GPM_UCODE_DATA, be32_to_cpup(fw_data++));
 	WREG32(RLC_GPM_UCODE_ADDR, 0);
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 7ed8280..19808ab 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -399,7 +399,7 @@ static int pcmidi_handle_report4(struct pcmidi_snd *pm, u8 *data)
 		if (!((0x01 << bit_index) & bit_mask)) {
 			input_event(pm->input_ep82, EV_KEY,
 				pm->last_key[bit_index], 0);
-				pm->last_key[bit_index] = 0;
+			pm->last_key[bit_index] = 0;
 		}
 	}
 
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index ca74981..5cfa0d3 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -529,8 +529,8 @@ static int sensor_hub_probe(struct hid_device *hdev,
 						GFP_KERNEL);
 	if (sd->hid_sensor_hub_client_devs == NULL) {
 		hid_err(hdev, "Failed to allocate memory for mfd cells\n");
-			ret = -ENOMEM;
-			goto err_close;
+		ret = -ENOMEM;
+		goto err_close;
 	}
 	list_for_each_entry(report, &report_enum->report_list, list) {
 		hid_dbg(hdev, "Report id:%x\n", report->id);
@@ -541,8 +541,8 @@ static int sensor_hub_probe(struct hid_device *hdev,
 						field->physical);
 			if (name  == NULL) {
 				hid_err(hdev, "Failed MFD device name\n");
-					ret = -ENOMEM;
-					goto err_free_names;
+				ret = -ENOMEM;
+				goto err_free_names;
 			}
 			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].name = name;
diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index f892a42..761d027 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -431,7 +431,7 @@ static int pca_init(struct i2c_adapter *adap)
 				printk(KERN_WARNING
 					"%s: Invalid I2C clock speed selected."
 					" Using default 59kHz.\n", adap->name);
-			pca_data->i2c_clock = I2C_PCA_CON_59kHz;
+				pca_data->i2c_clock = I2C_PCA_CON_59kHz;
 			}
 		} else {
 			printk(KERN_WARNING "%s: "
diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index bc943dd..21a6e61 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -138,7 +138,7 @@ static int gyro_3d_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		ret = hid_sensor_read_samp_freq_value(
 			&gyro_state->common_attributes, val, val2);
-			ret_type = IIO_VAL_INT_PLUS_MICRO;
+		ret_type = IIO_VAL_INT_PLUS_MICRO;
 		break;
 	case IIO_CHAN_INFO_HYSTERESIS:
 		ret = hid_sensor_read_raw_hyst_value(
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 49eb511..f0effd7 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -928,7 +928,7 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 				nesadapter->pft_mcast_map[mc_index] !=
 					nesvnic->nic_index &&
 					mc_index < max_pft_entries_avaiable) {
-						nes_debug(NES_DBG_NIC_RX,
+				nes_debug(NES_DBG_NIC_RX,
 					"mc_index=%d skipping nic_index=%d, "
 					"used for=%d \n", mc_index,
 					nesvnic->nic_index,
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5b53ca5..054a177 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3746,7 +3746,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 				entry->byte_len = le32_to_cpu(cqe.cqe_words[NES_CQE_PAYLOAD_LENGTH_IDX]);
 				wrid = ((u64)(le32_to_cpu(nesqp->hwqp.rq_vbase[wqe_index].wqe_words[NES_IWARP_RQ_WQE_COMP_SCRATCH_LOW_IDX]))) |
 					((u64)(le32_to_cpu(nesqp->hwqp.rq_vbase[wqe_index].wqe_words[NES_IWARP_RQ_WQE_COMP_SCRATCH_HIGH_IDX]))<<32);
-					entry->opcode = IB_WC_RECV;
+				entry->opcode = IB_WC_RECV;
 
 				nesqp->hwqp.rq_tail = (wqe_index+1)&(nesqp->hwqp.rq_size - 1);
 				if ((entry->status != IB_WC_SUCCESS) && (nesqp->hwqp.rq_tail != nesqp->hwqp.rq_head)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 3eceb61..a6636ad 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -384,8 +384,8 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 		if (!ipoib_cm_alloc_rx_skb(dev, rx->rx_ring, i, IPOIB_CM_RX_SG - 1,
 					   rx->rx_ring[i].mapping)) {
 			ipoib_warn(priv, "failed to allocate receive buffer %d\n", i);
-				ret = -ENOMEM;
-				goto err_count;
+			ret = -ENOMEM;
+			goto err_count;
 		}
 		ret = ipoib_cm_post_receive_nonsrq(dev, rx, &t->wr, t->sge, i);
 		if (ret) {
diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index 3b024bf..6ab0cb0 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -195,7 +195,7 @@ static int dib0070_captrim(struct dib0070_state *state, enum frontend_tune_state
 		state->adc_diff = 3000;
 		ret = 20;
 
-	*tune_state = CT_TUNER_STEP_1;
+		*tune_state = CT_TUNER_STEP_1;
 	} else if (*tune_state == CT_TUNER_STEP_1) {
 		state->step /= 2;
 		dib0070_write_reg(state, 0x14, state->lo4 | state->captrim);
diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index 0a40edf..f7f7419 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1556,7 +1556,7 @@ static u32 stv0900_search_srate_fine(struct dvb_frontend *fe)
 	}
 
 	symbcomp = 13 * (coarse_srate / 10);
-		coarse_freq = (stv0900_read_reg(intp, CFR2) << 8)
+	coarse_freq = (stv0900_read_reg(intp, CFR2) << 8)
 					| stv0900_read_reg(intp, CFR1);
 
 	if (symbcomp < intp->symbol_rate[demod])
@@ -2008,7 +2008,7 @@ enum fe_stv0900_signal_type stv0900_algo(struct dvb_frontend *fe)
 			signal_type = STV0900_NODATA;
 			no_signal = stv0900_check_signal_presence(intp, demod);
 
-				intp->result[demod].locked = FALSE;
+			intp->result[demod].locked = FALSE;
 		}
 	}
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index c6532de..8d2e678 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2673,7 +2673,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 		fh->ov.w.height = fb->fmt.height;
 		btv->init.ov.w.width  = fb->fmt.width;
 		btv->init.ov.w.height = fb->fmt.height;
-			kfree(fh->ov.clips);
+		kfree(fh->ov.clips);
 		fh->ov.clips = NULL;
 		fh->ov.nclips = 0;
 
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d45e7f6..5210b0e 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7813,7 +7813,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 				break;
 			case 0x001d:
 				dev->tuner_type = TUNER_PHILIPS_FMD1216ME_MK3;
-					printk(KERN_INFO "%s Board has DVB-T\n", dev->name);
+				printk(KERN_INFO "%s Board has DVB-T\n",
+				       dev->name);
 				break;
 			default:
 				printk(KERN_ERR "%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 368582b..1d88e89 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -184,7 +184,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_r, &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
-		s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
+			s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l,
+						 &ctx->bank1);
 			return ret;
 		}
 		BUG_ON(ctx->bank2.dma & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f63029..1f140af 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1151,9 +1151,8 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 	}
 
 	cx231xx_enable656(dev);
-			/* stop mpeg capture */
-			cx231xx_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE,
-				 3, 0, 1, 3, 4);
+	/* stop mpeg capture */
+	cx231xx_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0, 1, 3, 4);
 
 	cx231xx_codec_settings(dev);
 	msleep(60);
diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index 740f3f4..6e84a54 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -481,7 +481,7 @@ static int af9005_fe_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 		return ret;
 	if (temp != state->strong) {
 		deb_info("adjust for strong signal %d\n", temp);
-			state->strong = temp;
+		state->strong = temp;
 	}
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6e237b6..45d26e3 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -407,7 +407,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 						ibuf, msg[j].len + 2,
 						DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf + 2, msg[j].len);
-			mdelay(10);
+				mdelay(10);
 			} else if (((msg[j].buf[0] == 0xb0) &&
 						(msg[j].addr == 0x68)) ||
 						((msg[j].buf[0] == 0xf7) &&
diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index 05f406d..ec134fa 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -236,8 +236,7 @@ static void sd_isoc_irq(struct urb *urb)
 		}
 		data = (u8 *) urb->transfer_buffer
 					+ urb->iso_frame_desc[i].offset;
-			gspca_frame_add(gspca_dev, INTER_PACKET,
-					data, SD_PKT_SZ);
+		gspca_frame_add(gspca_dev, INTER_PACKET, data, SD_PKT_SZ);
 	}
 
 	/* resubmit the URBs */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index c4d51d7..a95c144 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2613,7 +2613,8 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 			unit_pointers[idx] = hdw;
 			break;
 		}
-	} while (0); mutex_unlock(&pvr2_unit_mtx);
+	} while (0);
+	mutex_unlock(&pvr2_unit_mtx);
 
 	cnt1 = 0;
 	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
@@ -2740,7 +2741,8 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 		    (unit_pointers[hdw->unit_number] == hdw)) {
 			unit_pointers[hdw->unit_number] = NULL;
 		}
-	} while (0); mutex_unlock(&pvr2_unit_mtx);
+	} while (0);
+	mutex_unlock(&pvr2_unit_mtx);
 	kfree(hdw->controls);
 	kfree(hdw->mpeg_ctrl_info);
 	kfree(hdw);
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index aeabaa5..5900210 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -437,13 +437,13 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 		writel(((1 << 16) & BLOCK_COUNT_MASK)
 		       | (data_len & BLOCK_SIZE_MASK),
 		       host->addr + BLOCK);
-			t_val = readl(host->addr + INT_STATUS_ENABLE);
-			t_val |= host->req->data_dir == READ
-				 ? INT_STATUS_FIFO_RRDY
-				 : INT_STATUS_FIFO_WRDY;
+		t_val = readl(host->addr + INT_STATUS_ENABLE);
+		t_val |= host->req->data_dir == READ
+			 ? INT_STATUS_FIFO_RRDY
+			 : INT_STATUS_FIFO_WRDY;
 
-			writel(t_val, host->addr + INT_STATUS_ENABLE);
-			writel(t_val, host->addr + INT_SIGNAL_ENABLE);
+		writel(t_val, host->addr + INT_STATUS_ENABLE);
+		writel(t_val, host->addr + INT_SIGNAL_ENABLE);
 	} else {
 		cmd &= ~(TPC_DATA_SEL | 0xf);
 		host->cmd_flags |= REG_DATA;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..133b4ce 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1946,7 +1946,7 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-    retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 	if (retval < 0)
 		status = FAILED;
 	else
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index ab5bd6c..d40f068 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -10716,10 +10716,8 @@ static void bnx2x_link_settings_requested(struct bnx2x *bp)
 		default:
 			BNX2X_ERR("NVRAM config error. BAD link speed link_config 0x%x\n",
 				  link_config);
-				bp->link_params.req_line_speed[idx] =
-							SPEED_AUTO_NEG;
-				bp->port.advertising[idx] =
-						bp->port.supported[idx];
+			bp->link_params.req_line_speed[idx] = SPEED_AUTO_NEG;
+			bp->port.advertising[idx] = bp->port.supported[idx];
 			break;
 		}
 
diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
index 6f3cac0..039f63c 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
@@ -740,7 +740,7 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_TIMEOUT:
 		bfa_nw_ioc_hw_sem_release(ioc);
-			bfa_ioc_pf_failed(ioc);
+		bfa_ioc_pf_failed(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail_sync);
 		break;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 8061fb0..a6f5f86 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -587,8 +587,8 @@ static int alloc_rx_resources(struct sge *sge, struct sge_params *p)
 		sizeof(struct cpl_rx_data) +
 		sge->freelQ[!sge->jumbo_fl].dma_offset;
 
-		size = (16 * 1024) -
-		    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = (16 * 1024) -
+	    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	sge->freelQ[sge->jumbo_fl].rx_buffer_size = size;
 
diff --git a/drivers/net/ethernet/dec/tulip/interrupt.c b/drivers/net/ethernet/dec/tulip/interrupt.c
index 92306b3..fd20b47 100644
--- a/drivers/net/ethernet/dec/tulip/interrupt.c
+++ b/drivers/net/ethernet/dec/tulip/interrupt.c
@@ -569,7 +569,7 @@ irqreturn_t tulip_interrupt(int irq, void *dev_instance)
 
 
 		if (csr5 & (RxIntr | RxNoBuf)) {
-				rx += tulip_rx(dev);
+			rx += tulip_rx(dev);
 			tulip_refill_rx(dev);
 		}
 
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 93845af..77ce3f5 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -1117,7 +1117,7 @@ static void uli526x_timer(unsigned long data)
 				netif_carrier_off(dev);
 			}
 		}
-		db->init=0;
+	db->init = 0;
 
 	/* Timer active again */
 	db->timer.expires = ULI526X_TIMER_WUT;
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index d3b4700..a3ebbe1 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -1339,7 +1339,7 @@ static int ns83820_set_settings(struct net_device *ndev,
 			writel(TBICR_MR_AN_ENABLE | TBICR_MR_RESTART_AN,
 				dev->base + TBICR);
 			writel(TBICR_MR_AN_ENABLE, dev->base + TBICR);
-				dev->linkstate = LINK_AUTONEGOTIATE;
+			dev->linkstate = LINK_AUTONEGOTIATE;
 
 			printk(KERN_INFO "%s: autoneg enabled via ethtool\n",
 				ndev->name);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 5a20eaf..5b82e56 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2489,7 +2489,7 @@ static int vxge_add_isr(struct vxgedev *vdev)
 					vxge_tx_msix_handle, 0,
 					vdev->desc[intr_cnt],
 					&vdev->vpaths[vp_idx].fifo);
-					vdev->vxge_entries[intr_cnt].arg =
+				vdev->vxge_entries[intr_cnt].arg =
 						&vdev->vpaths[vp_idx].fifo;
 				irq_req = 1;
 				break;
@@ -2505,7 +2505,7 @@ static int vxge_add_isr(struct vxgedev *vdev)
 					0,
 					vdev->desc[intr_cnt],
 					&vdev->vpaths[vp_idx].ring);
-					vdev->vxge_entries[intr_cnt].arg =
+				vdev->vxge_entries[intr_cnt].arg =
 						&vdev->vpaths[vp_idx].ring;
 				irq_req = 1;
 				break;
@@ -4504,8 +4504,8 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	if (status != VXGE_HW_OK) {
 		vxge_debug_init(VXGE_ERR,
 			"Failed to initialize device (%d)", status);
-			ret = -EINVAL;
-			goto _exit3;
+		ret = -EINVAL;
+		goto _exit3;
 	}
 
 	if (VXGE_FW_VER(ll_config->device_hw_info.fw_version.major,
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 2553cf4..2b908b5 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -1159,10 +1159,10 @@ static void ql_update_lbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 
 			map = lbq_desc->p.pg_chunk.map +
 				lbq_desc->p.pg_chunk.offset;
-				dma_unmap_addr_set(lbq_desc, mapaddr, map);
+			dma_unmap_addr_set(lbq_desc, mapaddr, map);
 			dma_unmap_len_set(lbq_desc, maplen,
 					rx_ring->lbq_buf_size);
-				*lbq_desc->addr = cpu_to_le64(map);
+			*lbq_desc->addr = cpu_to_le64(map);
 
 			pci_dma_sync_single_for_device(qdev->pdev, map,
 						rx_ring->lbq_buf_size,
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index d77d60e..619a733 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -695,7 +695,7 @@ static irqreturn_t atp_interrupt(int irq, void *dev_instance)
 	}
 
 	/* Tell the adapter that it can go back to using the output line as IRQ. */
-    write_reg(ioaddr, CMR2, CMR2_IRQOUT);
+	 write_reg(ioaddr, CMR2, CMR2_IRQOUT);
 	/* Enable the physical interrupt line, which is sure to be low until.. */
 	outb(Ctrl_SelData + Ctrl_IRQEN, ioaddr + PAR_CONTROL);
 	/* .. we enable the interrupt sources. */
diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index 08d9432..cc54680 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -726,7 +726,7 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb, int fs)
 			smc->mib.priv.fddiPRIVECF_Req_Rx++ ;
 			{
 			if (sm->smt_len && !sm_to_para(smc,sm,SMT_P_ECHODATA)) {
-			DB_SMT("SMT: ECF with para problem,sending RDF\n",0,0) ;
+				DB_SMT("SMT: ECF with para problem,sending RDF\n", 0, 0) ;
 				smt_send_rdf(smc,mb,m_fc(mb),SMT_RDF_LENGTH,
 					local) ;
 				break ;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index bc1d521..b5dfd7b 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -2059,7 +2059,8 @@ static int scc_net_seq_show(struct seq_file *seq, void *v)
 				seq_printf(seq, "%2.2x ", scc->wreg[reg]);
 			seq_printf(seq, "\n");
 			
-		seq_printf(seq, "\tR %2.2x %2.2x XX ", InReg(scc->ctrl,R0), InReg(scc->ctrl,R1));
+			seq_printf(seq, "\tR %2.2x %2.2x XX ",
+				   InReg(scc->ctrl, R0), InReg(scc->ctrl, R1));
 			for (reg = 3; reg < 8; reg++)
 				seq_printf(seq, "%2.2x ", InReg(scc->ctrl, reg));
 			seq_printf(seq, "XX ");
diff --git a/drivers/net/irda/w83977af_ir.c b/drivers/net/irda/w83977af_ir.c
index bb8857a..306acf4 100644
--- a/drivers/net/irda/w83977af_ir.c
+++ b/drivers/net/irda/w83977af_ir.c
@@ -529,14 +529,14 @@ static netdev_tx_t w83977af_hard_xmit(struct sk_buff *skb,
 		self->tx_buff.len = skb->len;
 		
 		mtt = irda_get_mtt(skb);
-			IRDA_DEBUG(4, "%s(%ld), mtt=%d\n", __func__ , jiffies, mtt);
-			if (mtt)
-				udelay(mtt);
+		IRDA_DEBUG(4, "%s(%ld), mtt=%d\n", __func__ , jiffies, mtt);
+		if (mtt)
+			udelay(mtt);
 
-			/* Enable DMA interrupt */
-			switch_bank(iobase, SET0);
-	 		outb(ICR_EDMAI, iobase+ICR);
-	     		w83977af_dma_write(self, iobase);
+		/* Enable DMA interrupt */
+		switch_bank(iobase, SET0);
+		outb(ICR_EDMAI, iobase+ICR);
+		w83977af_dma_write(self, iobase);
 	} else {
 		self->tx_buff.data = self->tx_buff.head;
 		self->tx_buff.len = async_wrap_skb(skb, self->tx_buff.data, 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index a3399c4..b1813ea 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -634,7 +634,7 @@ ath5k_hw_on_hold(struct ath5k_hw *ah)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			usleep_range(2000, 2500);
+		usleep_range(2000, 2500);
 	} else {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_BASEBAND | bus_flags);
@@ -699,7 +699,7 @@ ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 			AR5K_RESET_CTL_MAC | AR5K_RESET_CTL_DMA |
 			AR5K_RESET_CTL_PHY | AR5K_RESET_CTL_PCI);
-			usleep_range(2000, 2500);
+		usleep_range(2000, 2500);
 	} else {
 		if (ath5k_get_bus_type(ah) == ATH_AHB)
 			ret = ath5k_hw_wisoc_reset(ah, AR5K_RESET_CTL_PCU |
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 5726688..ea5ac1d 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2979,7 +2979,7 @@ static void b43legacy_wireless_core_stop(struct b43legacy_wldev *dev)
 			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
 	}
 
-b43legacy_mac_suspend(dev);
+	b43legacy_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43legacydbg(wl, "Wireless interface stopped\n");
 }
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index d6033a8..585f95b 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -941,7 +941,7 @@ void hostap_free_data(struct ap_data *ap)
 
 #ifndef PRISM2_NO_KERNEL_IEEE80211_MGMT
 	if (ap->proc != NULL) {
-	  remove_proc_entry("ap", ap->proc);
+		remove_proc_entry("ap", ap->proc);
 		remove_proc_entry("ap_control", ap->proc);
 	}
 	ap_control_flush_macs(&ap->mac_restrictions);
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index ac07473..a61b76d 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1554,7 +1554,7 @@ static int prism2_ioctl_siwtxpow(struct net_device *dev,
 		val = HFA384X_TEST_CFG_BIT_ALC;
 		local->func->cmd(dev, HFA384X_CMDCODE_TEST |
 				 (HFA384X_TEST_CFG_BITS << 8), 0, &val, NULL);
-			local->txpower_type = PRISM2_TXPOWER_FIXED;
+		local->txpower_type = PRISM2_TXPOWER_FIXED;
 	}
 
 	if (rrq->flags == IW_TXPOW_DBM)
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 088de9d..af8b4ba 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -685,7 +685,7 @@ int lbtf_remove_card(struct lbtf_private *priv)
 	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
-    lbtf_deb_leave(LBTF_DEB_MAIN);
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbtf_remove_card);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
index 246e535..37c3b60 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -836,7 +836,7 @@ bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 					      currentcmd->para1,
 					      RFREG_OFFSET_MASK,
 					      rtlphy->rfreg_chnlval[rfpath]);
-			_rtl92c_phy_sw_rf_setting(hw, channel);
+				_rtl92c_phy_sw_rf_setting(hw, channel);
 			}
 			break;
 		default:
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index c333dfd..7f6e056 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -2253,8 +2253,8 @@ static void rtl8723ae_bt_var_init(struct ieee80211_hw *hw)
 	pcipriv->bt_coexist.bt_coexist_type =
 					pcipriv->bt_coexist.eeprom_bt_type;
 
-		pcipriv->bt_coexist.bt_ant_isolation =
-				pcipriv->bt_coexist.eeprom_bt_ant_isol;
+	pcipriv->bt_coexist.bt_ant_isolation =
+					pcipriv->bt_coexist.eeprom_bt_ant_isol;
 
 	pcipriv->bt_coexist.bt_radio_shared_type =
 				pcipriv->bt_coexist.eeprom_bt_radio_shared;
diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index caa1531..ceec27c 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -238,10 +238,9 @@ static int configure_port_init(const unsigned char *buf)
 			s=2;
 			if (c & HPEE_PORT_INIT_MASK) {
  				printk(KERN_WARNING "port_init: unverified mask attribute\n");
-				       outw((inw(get_16(buf+len+1)) &
-					     get_16(buf+len+3)) |
-					    get_16(buf+len+5), 
-					    get_16(buf+len+1));
+				outw((inw(get_16(buf+len+1)) &
+				     get_16(buf+len+3)) | get_16(buf+len+5),
+				     get_16(buf+len+1));
 			} else {
 				outw(cpu_to_le16(get_16(buf+len+3)), get_16(buf+len+1));
 			}
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index cbd72d8..975b368 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -543,9 +543,9 @@ static int __init init_ops(void)
 		    !(SLOT_PRESENT(slot_cur->status)) && 
 		    !(SLOT_LATCH(slot_cur->status))) {
 			debug("BEFORE POWER OFF COMMAND\n");
-				rc = power_off(slot_cur);
-				if (rc)
-					return rc;
+			rc = power_off(slot_cur);
+			if (rc)
+				return rc;
 
 	/*		retval = slot_update(&slot_cur);
 	 *		if (retval)
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index e61a6de..68a3ef4 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2255,8 +2255,8 @@ dasd_eckd_build_format(struct dasd_device *base,
 						DASD_ECKD_CCW_WRITE_CKD_MT;
 				ccw->flags = CCW_FLAG_SLI;
 				ccw->count = 8;
-					ccw->cda = (__u32)(addr_t) ect;
-					ccw++;
+				ccw->cda = (__u32)(addr_t) ect;
+				ccw++;
 			}
 		}
 	}
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0a328d0..eca2885 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4436,9 +4436,9 @@ static int qeth_snmp_command_cb(struct qeth_card *card,
 	}
 	qinfo->udata_offset += data_len;
 	/* check if all replies received ... */
-		QETH_CARD_TEXT_(card, 4, "srtot%i",
+	QETH_CARD_TEXT_(card, 4, "srtot%i",
 			       cmd->data.setadapterparms.hdr.used_total);
-		QETH_CARD_TEXT_(card, 4, "srseq%i",
+	QETH_CARD_TEXT_(card, 4, "srseq%i",
 			       cmd->data.setadapterparms.hdr.seq_no);
 	if (cmd->data.setadapterparms.hdr.seq_no <
 	    cmd->data.setadapterparms.hdr.used_total)
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
index 2e3117a..56a35d9 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -609,8 +609,8 @@ output_listing(char *ifilename)
 
 		while (line < cur_instr->srcline) {
 			fgets(buf, sizeof(buf), ifile);
-				fprintf(listfile, "             \t%s", buf);
-				line++;
+			fprintf(listfile, "             \t%s", buf);
+			line++;
 		}
 		fprintf(listfile, "%04x %02x%02x%02x%02x", instrptr,
 #ifdef __LITTLE_ENDIAN
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 33c52bc..8d31545 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -890,9 +890,9 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
 				, id
 				, lun
 				, ccb->arcmsr_cdb.DeviceStatus);
-				acb->devstate[id][lun] = ARECA_RAID_GONE;
-				ccb->pcmd->result = DID_NO_CONNECT << 16;
-				arcmsr_ccb_complete(ccb);
+			acb->devstate[id][lun] = ARECA_RAID_GONE;
+			ccb->pcmd->result = DID_NO_CONNECT << 16;
+			arcmsr_ccb_complete(ccb);
 			break;
 		}
 	}
@@ -2458,8 +2458,8 @@ polling_hbc_ccb_retry:
 					, pCCB->pcmd->device->id
 					, pCCB->pcmd->device->lun
 					, pCCB);
-					pCCB->pcmd->result = DID_ABORT << 16;
-					arcmsr_ccb_complete(pCCB);
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB);
 				continue;
 			}
 			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 15a629d..9ec9247 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -148,8 +148,8 @@ stop_dma:
 				{
 			   		k = dev->id[c][target_id].last_len;
 			   		k -= adrcnt;
-			   		dev->id[c][target_id].tran_len = k;			   
-			   	dev->id[c][target_id].last_len = adrcnt;			   
+					dev->id[c][target_id].tran_len = k;
+					dev->id[c][target_id].last_len = adrcnt;
 				}
 #ifdef ED_DBGP
 				printk("tmport = %x dev->id[c][target_id].last_len = %d dev->id[c][target_id].tran_len = %d\n",tmport,dev->id[c][target_id].last_len,dev->id[c][target_id].tran_len);
@@ -183,7 +183,7 @@ stop_dma:
 			 */
 			dev->in_int[c] = 0;
 #ifdef ED_DBGP
-				printk("Status 0x85 return\n");
+			printk("Status 0x85 return\n");
 #endif				
 			goto handled;
 		}
@@ -2528,9 +2528,11 @@ static int atp870u_init_tables(struct Scsi_Host *host)
 	int c,k;
 	for(c=0;c < 2;c++) {
 	   	for(k=0;k<16;k++) {
-	   			atp_dev->id[c][k].prd_table = pci_alloc_consistent(atp_dev->pdev, 1024, &(atp_dev->id[c][k].prd_bus));
-	   			if (!atp_dev->id[c][k].prd_table) {
-	   				printk("atp870u_init_tables fail\n");
+			atp_dev->id[c][k].prd_table =
+				pci_alloc_consistent(atp_dev->pdev, 1024,
+						&(atp_dev->id[c][k].prd_bus));
+			if (!atp_dev->id[c][k].prd_table) {
+				printk("atp870u_init_tables fail\n");
 				atp870u_free_tables(host);
 				return -ENOMEM;
 			}
@@ -2741,7 +2743,7 @@ flash_ok_880:
 		shpnt->n_io_port = 0x60;	/* Number of bytes of I/O space used */
 		shpnt->irq = pdev->irq;			
 	} else if (ent->device == ATP885_DEVID) {	
-			printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%x, IRQ:%d.\n"
+		printk(KERN_INFO "   ACARD AEC-67162 PCI Ultra3 LVD Host Adapter:  IO:%x, IRQ:%d.\n"
 			       , base_io, pdev->irq);
         	
 		atpdev->pdev = pdev;
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index f78bcb6..e23f21c 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -5525,7 +5525,7 @@ bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg)
 				(struct bfa_phy_stats_s *) phy->ubuf;
 			bfa_phy_ntoh32((u32 *)stats, (u32 *)phy->dbuf_kva,
 				sizeof(struct bfa_phy_stats_s));
-				bfa_trc(phy, stats->status);
+			bfa_trc(phy, stats->status);
 		}
 
 		phy->status = status;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..189b7c1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1894,7 +1894,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 			"maximum logical LUNs (%d) exceeded.  "
 			"%d LUNs ignored.\n", HPSA_MAX_LUN,
 			*nlogicals - HPSA_MAX_LUN);
-			*nlogicals = HPSA_MAX_LUN;
+		*nlogicals = HPSA_MAX_LUN;
 	}
 	if (*nlogicals + *nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 6601e03..674a5e4 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8920,8 +8920,8 @@ static int ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 			if (i == 0) {
 				entries_each_hrrq = IPR_NUM_INTERNAL_CMD_BLKS;
 				ioa_cfg->hrrq[i].min_cmd_id = 0;
-					ioa_cfg->hrrq[i].max_cmd_id =
-						(entries_each_hrrq - 1);
+				ioa_cfg->hrrq[i].max_cmd_id =
+					(entries_each_hrrq - 1);
 			} else {
 				entries_each_hrrq =
 					IPR_NUM_BASE_CMD_BLKS/
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6630520..606ce69 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2861,7 +2861,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 			cmd->un.cont64[i].addrLow = putPaddrLow(mp[i]->phys);
 			cmd->un.cont64[i].tus.f.bdeSize =
 				((struct lpfc_dmabufext *)mp[i])->size;
-					cmd->ulpBdeCount = ++i;
+			cmd->ulpBdeCount = ++i;
 
 			if ((--num_bde > 0) && (i < 2))
 				continue;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6b8ee74..81935ff 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5656,7 +5656,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		return 1;
 
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
-		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t); /* Skip past command */
 
 	/* use the command's xri in the response */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43440ca..a2b116f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15470,8 +15470,8 @@ lpfc_sli4_read_fcf_rec(struct lpfc_hba *phba, uint16_t fcf_index)
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_INIT,
 				"2758 Failed to allocate mbox for "
 				"READ_FCF cmd\n");
-				error = -ENOMEM;
-				goto fail_fcf_read;
+		error = -ENOMEM;
+		goto fail_fcf_read;
 	}
 	/* Construct the read FCF record mailbox command */
 	rc = lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a85d73d..65ec553 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -650,7 +650,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 		if (dev->dev_type == SAS_SATA_DEV) {
 			pm8001_device->attached_phy =
 				dev->rphy->identify.phy_identifier;
-				flag = 1; /* directly sata*/
+			flag = 1; /* directly sata*/
 		}
 	} /*register this device to HBA*/
 	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f2216ed..90617ad 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -605,7 +605,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x00d4,
 			    "Unable to initialize ISP84XX.\n");
-		qla84xx_put_chip(vha);
+			qla84xx_put_chip(vha);
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d799379..946ac05 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1752,7 +1752,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	fdisc = &sp->u.iocb_cmd;
 	switch (fx_type) {
 	case FXDISC_GET_CONFIG_INFO:
-	fdisc->u.fxiocb.flags =
+		fdisc->u.fxiocb.flags =
 		    SRB_FXDISC_RESP_DMA_VALID;
 		fdisc->u.fxiocb.rsp_len = sizeof(struct config_info_data);
 		break;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..79f6065 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1769,7 +1769,7 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("%s: REF check failed on sector %lu\n",
 			__func__, (unsigned long)sector);
-			dif_errors++;
+		dif_errors++;
 		return 0x03;
 	}
 	return 0;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2150596..22b118b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1768,7 +1768,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 							  " retry cmd: %p\n",
 							  current->comm,
 							  scmd));
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+			scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
 		} else {
 			/*
 			 * If just we got sense for the device (called
diff --git a/drivers/staging/cxt1e1/comet.c b/drivers/staging/cxt1e1/comet.c
index fabfd77..b71b8e6 100644
--- a/drivers/staging/cxt1e1/comet.c
+++ b/drivers/staging/cxt1e1/comet.c
@@ -488,14 +488,14 @@ WrtRcvEqualizerTbl(ci_t *ci, comet_t *comet, u_int32_t *table)
 
 	/* Storing RAM address, causes RAM to be updated */
 
-		/* Set up for a write operation */
-		pci_write_32((u_int32_t *) &comet->rlps_eq_rwsel, 0);
-		/* for write order preservation when optimizing driver */
-		pci_flush_write(ci);
-		/* write the addr, initiate a read */
-		pci_write_32((u_int32_t *) &comet->rlps_eq_iaddr, (u_int8_t) ramaddr);
-		 /* for write order preservation when optimizing driver */
-		pci_flush_write(ci);
+	/* Set up for a write operation */
+	pci_write_32((u_int32_t *) &comet->rlps_eq_rwsel, 0);
+	/* for write order preservation when optimizing driver */
+	pci_flush_write(ci);
+	/* write the addr, initiate a read */
+	pci_write_32((u_int32_t *) &comet->rlps_eq_iaddr, (u_int8_t) ramaddr);
+	 /* for write order preservation when optimizing driver */
+	pci_flush_write(ci);
 
 	/*
 	* wait 3 line rate clock cycles to ensure address bits are captured
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 1037086..e1cc348 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -1074,7 +1074,7 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 	else if (error == ERR_SHT)
 	    ch->s.rx_length_errors++;
 	FLUSH_MEM_WRITE();
-	       status = cxt1e1_max_mru;
+	status = cxt1e1_max_mru;
 	if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
 	    status |= EOBIRQ_ENABLE;
 	md->status = cpu_to_le32(status);
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 6cbf9c7..5310f9f 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -273,8 +273,8 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 			 dev->interrupt_in_buffer[6],
 			 dev->interrupt_in_buffer[7]);
 #if SUPPRESS_EXTRA_OFFLINE_EVENTS
-	if (dev->offline == 2 && dev->interrupt_in_buffer[1] == 0xff)
-		goto resubmit;
+		if (dev->offline == 2 && dev->interrupt_in_buffer[1] == 0xff)
+			goto resubmit;
 		if (dev->offline == 1 && dev->interrupt_in_buffer[1] == 0xff) {
 			dev->offline = 2;
 			goto resubmit;
@@ -287,7 +287,7 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 			dev->offline = 1;
 
 #endif	/* SUPPRESS_EXTRA_OFFLINE_EVENTS */
-	   dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n",
+		dbg_info(&dev->intf->dev, "%s: head, tail are %x, %x\n",
 		__func__, dev->ring_head, dev->ring_tail);
 
 		next_ring_head = (dev->ring_head + 1) % ring_buffer_size;
diff --git a/drivers/staging/speakup/speakup_keypc.c b/drivers/staging/speakup/speakup_keypc.c
index 2f2fe5e..3e5249a 100644
--- a/drivers/staging/speakup/speakup_keypc.c
+++ b/drivers/staging/speakup/speakup_keypc.c
@@ -187,7 +187,7 @@ static void do_catch_up(struct spk_synth *synth)
 	jiffy_delta = spk_get_var(JIFFY);
 	delay_time = spk_get_var(DELAY);
 	full_time = spk_get_var(FULL);
-spin_lock_irqsave(&speakup_info.spinlock, flags);
+	spin_lock_irqsave(&speakup_info.spinlock, flags);
 	jiffy_delta_val = jiffy_delta->u.n.value;
 	spin_unlock_irqrestore(&speakup_info.spinlock, flags);
 
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index f3bb363..2137927 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2601,10 +2601,9 @@ err5:
 	irq_dispose_mapping(udc->usb_irq);
 err_noirq:
 	if (udc->nullmap) {
-		dma_unmap_single(udc->gadget.dev.parent,
-			udc->nullp, 256,
+		dma_unmap_single(udc->gadget.dev.parent, udc->nullp, 256,
 				DMA_TO_DEVICE);
-			udc->nullp = DMA_ADDR_INVALID;
+		udc->nullp = DMA_ADDR_INVALID;
 	} else {
 		dma_sync_single_for_cpu(udc->gadget.dev.parent,
 			udc->nullp, 256,
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 75f5a1e..232eba9 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -165,7 +165,7 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
 			if (!request_mem_region(res.start, 0x4, hcd_name)) {
 				writel_be((readl_be(&ohci->regs->control) |
 					OHCI_USB_SUSPEND), &ohci->regs->control);
-					(void) readl_be(&ohci->regs->control);
+				(void) readl_be(&ohci->regs->control);
 			} else
 				release_mem_region(res.start, 0x4);
 		} else
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index e402beb..839ca8a 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -2491,7 +2491,8 @@ static int u132_endp_urb_dequeue(struct u132 *u132, struct u132_endp *endp,
 				spin_unlock_irqrestore(&endp->queue_lock.slock,
 					irqs);
 				kfree(urbq);
-			} urb->error_count = 0;
+			}
+			urb->error_count = 0;
 			usb_hcd_giveback_urb(hcd, urb, status);
 			return 0;
 		} else if (list_empty(&endp->urb_more)) {
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index a4a3c7c..e763b40 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2930,7 +2930,8 @@ static void __exit ftdi_elan_exit(void)
                 ftdi_status_cancel_work(ftdi);
                 ftdi_command_cancel_work(ftdi);
                 ftdi_response_cancel_work(ftdi);
-        } flush_workqueue(status_queue);
+	}
+	flush_workqueue(status_queue);
         destroy_workqueue(status_queue);
         status_queue = NULL;
         flush_workqueue(command_queue);
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index de98906..5ea51ba 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -922,7 +922,7 @@ static int sisusb_write_mem_bulk(struct sisusb_usb_data *sisusb, u32 addr,
 							bytes_written, 0, 1);
 				kernbuffer += (*bytes_written);
 			   } else {
-			ret |= sisusb_send_bulk_msg(sisusb,
+				ret |= sisusb_send_bulk_msg(sisusb,
 							SISUSB_EP_GFX_LBULK_OUT,
 							(length & ~3),
 							NULL, NULL, index,
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 9910aa2..ee0b2bd 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -343,7 +343,7 @@ static int palm_os_3_probe(struct usb_serial *serial,
 	}
 
 	if (retval == sizeof(*connection_info)) {
-			connection_info = (struct visor_connection_info *)
+		connection_info = (struct visor_connection_info *)
 							transfer_buffer;
 
 		num_ports = le16_to_cpu(connection_info->num_ports);
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 0c1a874..e2bdb11 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -408,9 +408,8 @@ static int mbxfb_setupOverlay(struct mbxfb_overlaySetup *set)
 	 * for packed formats.
 	 */
 	set->UV_stride = ((set->width/2) + 0x7 ) & ~0x7;
-		set->U_offset = set->height * set->Y_stride;
-		set->V_offset = set->U_offset +
-						set->height * set->UV_stride;
+	set->U_offset = set->height * set->Y_stride;
+	set->V_offset = set->U_offset + set->height * set->UV_stride;
 	vubase |= Vubase_Ubase_Adr(
 			(0x60000 + set->mem_offset + set->U_offset)>>3);
 	vvbase |= Vvbase_Vbase_Adr(
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 7b07135..f1ed896 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -484,7 +484,7 @@ static int __vlynq_try_external(struct vlynq_device *dev)
 	if (vlynq_linked(dev)) {
 		printk(KERN_DEBUG "%s: using external clock\n",
 			dev_name(&dev->dev));
-			dev->divisor = vlynq_div_external;
+		dev->divisor = vlynq_div_external;
 		return 0;
 	}
 
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5d19acf..b163c6b 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -628,7 +628,7 @@ static int serial_struct_ioctl(unsigned fd, unsigned cmd,
                 ss.iomap_base = 0UL;
         }
         set_fs(KERNEL_DS);
-                err = sys_ioctl(fd,cmd,(unsigned long)(&ss));
+	err = sys_ioctl(fd, cmd, (unsigned long)(&ss));
         set_fs(oldseg);
         if (cmd == TIOCGSERIAL && err >= 0) {
                 if (!access_ok(VERIFY_WRITE, ss32, sizeof(SS32)))
diff --git a/mm/migrate.c b/mm/migrate.c
index 1da0092..9c46470 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -83,7 +83,7 @@ void putback_lru_pages(struct list_head *l)
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-			putback_lru_page(page);
+		putback_lru_page(page);
 	}
 }
 
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index ca957d3..e6199d1 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1626,8 +1626,8 @@ static int rfcomm_recv_data(struct rfcomm_session *s, u8 dlci, int pf, struct sk
 	}
 
 	if (pf && d->cfc) {
-		u8 credits = *(u8 *) skb->data; skb_pull(skb, 1);
-
+		u8 credits = *(u8 *) skb->data;
+		skb_pull(skb, 1);
 		d->tx_credits += credits;
 		if (d->tx_credits)
 			clear_bit(RFCOMM_TX_THROTTLED, &d->flags);
diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index c0be085..58125ab 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -604,7 +604,7 @@ static void ess_audio_output_block_audio2
 	ess_chgmixer (devc, 0x78, 0x03, 0x03);   /* Go */
 
 	devc->irq_mode_16 = IMODE_OUTPUT;
-		devc->intr_active_16 = 1;
+	devc->intr_active_16 = 1;
 }
 
 static void ess_audio_output_block
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index dc632cd..49a941b 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -1254,9 +1254,9 @@ static int snd_card_asihpi_pcm_new(struct snd_card_asihpi *asihpi, int device)
 	if (err < 0)
 		return err;
 	/* pointer to ops struct is stored, dont change ops afterwards! */
-		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
 				&snd_card_asihpi_playback_mmap_ops);
-		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE,
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE,
 				&snd_card_asihpi_capture_mmap_ops);
 
 	pcm->private_data = asihpi;
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index eee7afc..30ce64f 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -1204,9 +1204,9 @@ static int setup_descs(struct snd_dbri *dbri, int streamno, unsigned int period)
 			dbri->dma->desc[desc].word1,
 			dbri->dma->desc[desc].ba,
 			dbri->dma->desc[desc].nda, dbri->dma->desc[desc].word4);
-			desc = dbri->next_desc[desc];
-			if (desc == first_desc)
-				break;
+		desc = dbri->next_desc[desc];
+		if (desc == first_desc)
+			break;
 	}
 #endif
 	return 0;
diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 40b3e54..e2bf634 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -122,7 +122,7 @@ void cmdline(int argc, char **argv)
 			new_bias = strtoull(argv[optind], &endptr, 0);
 			if (endptr == argv[optind] ||
 				new_bias > BIAS_POWERSAVE) {
-					fprintf(stderr, "invalid value: %s\n",
+				fprintf(stderr, "invalid value: %s\n",
 						argv[optind]);
 				usage();
 			}
