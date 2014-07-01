Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaGAPpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:45:25 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51522 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGAPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:45:24 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] treewide: Fix typo in printk
Date: Wed,  2 Jul 2014 00:44:15 +0900
Message-Id: <1404229455-7248-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-Reply-To: <1404229455-7248-1-git-send-email-standby24x7@gmail.com>
References: <1404229455-7248-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in printk within vairous
part of the code.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/blackfin/mach-common/ints-priority.c          | 2 +-
 drivers/gpu/drm/i915/intel_bios.c                  | 2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      | 2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   | 2 +-
 drivers/net/bonding/bond_sysfs_slave.c             | 2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     | 2 +-
 drivers/net/wireless/libertas_tf/main.c            | 2 +-
 drivers/scsi/aic7xxx/Kconfig.aic79xx               | 2 +-
 drivers/scsi/nsp32.c                               | 2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       | 2 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     | 2 +-
 drivers/scsi/scsi_transport_fc.c                   | 2 +-
 net/mac802154/wpan.c                               | 2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 867b7ce..d5cdae8 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -455,7 +455,7 @@ void handle_sec_sci_fault(uint32_t gstat)
 			printk(KERN_DEBUG "sec ack err\n");
 			break;
 		default:
-			printk(KERN_DEBUG "sec sci unknow err\n");
+			printk(KERN_DEBUG "sec sci unknown err\n");
 		}
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 827498e..21b347e 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -945,7 +945,7 @@ static void parse_ddi_port(struct drm_i915_private *dev_priv, enum port port,
 		DRM_DEBUG_KMS("Analog port %c is also DP or TMDS compatible\n",
 			      port_name(port));
 	if (is_dvi && (port == PORT_A || port == PORT_E))
-		DRM_DEBUG_KMS("Port %c is TMDS compabile\n", port_name(port));
+		DRM_DEBUG_KMS("Port %c is TMDS compatible\n", port_name(port));
 	if (!is_dvi && !is_dp && !is_crt)
 		DRM_DEBUG_KMS("Port %c is not DP/TMDS/CRT compatible\n",
 			      port_name(port));
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e828a1d..24e2370 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -244,7 +244,7 @@ static bool is_ack(struct s3c24xx_i2c *i2c)
 		}
 		usleep_range(1000, 2000);
 	}
-	dev_err(i2c->dev, "ack was not recieved\n");
+	dev_err(i2c->dev, "ack was not received\n");
 	return false;
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index f8dfd76..db3588d 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -511,7 +511,7 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
 	} else {
-		usnic_err("Failed to transistion %u from %s to %s",
+		usnic_err("Failed to transition %u from %s to %s",
 		qp_grp->grp_id,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
index e60cbb3..f86cec0 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
@@ -259,7 +259,7 @@ static int vv6410_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	fine = val % VV6410_CIF_LINELENGTH;
 	coarse = min(512, val / VV6410_CIF_LINELENGTH);
 
-	PDEBUG(D_CONF, "Set coarse exposure to %d, fine expsure to %d",
+	PDEBUG(D_CONF, "Set coarse exposure to %d, fine exposure to %d",
 	       coarse, fine);
 
 	err = stv06xx_write_sensor(sd, VV6410_FINEH, fine >> 8);
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 198677f..d9672c6 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -36,7 +36,7 @@ static ssize_t state_show(struct slave *slave, char *buf)
 	case BOND_STATE_BACKUP:
 		return sprintf(buf, "backup\n");
 	default:
-		return sprintf(buf, "UNKONWN\n");
+		return sprintf(buf, "UNKNOWN\n");
 	}
 }
 static SLAVE_ATTR_RO(state);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
index db4280c..716fc37 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
@@ -922,7 +922,7 @@ int netxen_config_ipaddr(struct netxen_adapter *adapter, __be32 ip, int cmd)
 
 	rv = netxen_send_cmd_descs(adapter, (struct cmd_desc_type0 *)&req, 1);
 	if (rv != 0) {
-		printk(KERN_ERR "%s: could not notify %s IP 0x%x reuqest\n",
+		printk(KERN_ERR "%s: could not notify %s IP 0x%x request\n",
 				adapter->netdev->name,
 				(cmd == NX_IP_UP) ? "Add" : "Remove", ip);
 	}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 851cb4a..03cd4c3 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -941,7 +941,7 @@ void qlcnic_82xx_config_ipaddr(struct qlcnic_adapter *adapter,
 	rv = qlcnic_send_cmd_descs(adapter, (struct cmd_desc_type0 *)&req, 1);
 	if (rv != 0)
 		dev_err(&adapter->netdev->dev,
-				"could not notify %s IP 0x%x reuqest\n",
+				"could not notify %s IP 0x%x request\n",
 				(cmd == QLCNIC_IP_UP) ? "Add" : "Remove", ip);
 }
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 088de9d..25c5acc 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -332,7 +332,7 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 
 err_prog_firmware:
 	priv->hw_reset_device(card);
-	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programing fw; ret=%d", ret);
+	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programming fw; ret=%d", ret);
 	return ret;
 }
 
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index 6739069..3b3d599 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -70,7 +70,7 @@ config AIC79XX_DEBUG_MASK
 	default "0"
 	help
 	Bit mask of debug options that is only valid if the
-	CONFIG_AIC79XX_DEBUG_ENBLE option is enabled.  The bits in this mask
+	CONFIG_AIC79XX_DEBUG_ENABLE option is enabled.  The bits in this mask
 	are defined in the drivers/scsi/aic7xxx/aic79xx.h - search for the
 	variable ahd_debug in that file to find them.
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0665f9c..02ec4c8 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -930,7 +930,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 
 	/* check target ID is not same as this initiator ID */
 	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
-		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
+		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "target==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
 		return 0;
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 987fbb1..77085d4 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -533,7 +533,7 @@ static int nsp_negate_signal(struct scsi_cmnd *SCpnt, unsigned char mask,
 	} while ((--time_out != 0) && (reg & mask) != 0);
 
 	if (time_out == 0) {
-		nsp_msg(KERN_DEBUG, " %s signal off timeut", str);
+		nsp_msg(KERN_DEBUG, " %s signal off timeout", str);
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index da9e390..24a8528 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -399,7 +399,7 @@ qla8044_idc_lock(struct qla_hw_data *ha)
 				 */
 				 ql_dbg(ql_dbg_p3p, vha, 0xb08a,
 				     "%s: IDC lock Recovery by %d "
-				     "failed, Retrying timout\n", __func__,
+				     "failed, Retrying timeout\n", __func__,
 				     ha->portnum);
 				 timeout = 0;
 			}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8365705..20774a0 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3065,7 +3065,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
 					     (char *)&rport->node_name);
 		if (ret)
-			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
+			printk(KERN_ERR "FC Remote Port tgt nexus failed %d\n",
 			       ret);
 	}
 
diff --git a/net/mac802154/wpan.c b/net/mac802154/wpan.c
index 3c3069f..aa25269 100644
--- a/net/mac802154/wpan.c
+++ b/net/mac802154/wpan.c
@@ -90,7 +90,7 @@ mac802154_wpan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 	case SIOCSIFADDR:
 		dev_warn(&dev->dev,
-			 "Using DEBUGing ioctl SIOCSIFADDR isn't recommened!\n");
+			 "Using DEBUGing ioctl SIOCSIFADDR isn't recommended!\n");
 		if (sa->family != AF_IEEE802154 ||
 		    sa->addr.addr_type != IEEE802154_ADDR_SHORT ||
 		    sa->addr.pan_id == IEEE802154_PANID_BROADCAST ||
-- 
2.0.0.390.gcb682f8

