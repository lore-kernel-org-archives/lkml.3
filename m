Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3GPTiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:38:12 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64505 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPTiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:38:09 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial] treewide: Fix typo in printk
Date: Wed, 17 Jul 2013 04:37:44 +0900
Message-Id: <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/crypto/ux500/hash/hash_core.c               | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c      | 2 +-
 drivers/net/wireless/cw1200/wsm.c                   | 2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c       | 2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c         | 4 ++--
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c         | 4 ++--
 drivers/power/88pm860x_charger.c                    | 4 ++--
 drivers/power/pm2301_charger.c                      | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c                       | 8 ++++----
 drivers/scsi/qla2xxx/qla_mr.c                       | 2 +-
 11 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 496ae6a..33693d9 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -282,7 +282,7 @@ static int get_empty_message_digest(
 			}
 		} else {
 			dev_dbg(device_data->dev, "[%s] Continue hash "
-					"calculation, since hmac key avalable",
+					"calculation, since hmac key available",
 					__func__);
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 0913c62..3c51b77 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -1637,7 +1637,7 @@ int qlcnic_83xx_nic_set_promisc(struct qlcnic_adapter *adapter, u32 mode)
 	err = qlcnic_issue_cmd(adapter, &cmd);
 	if (err)
 		dev_info(&adapter->pdev->dev,
-			 "Promiscous mode config failed\n");
+			 "Promiscuous mode config failed\n");
 
 	qlcnic_free_mbx_args(&cmd);
 	return err;
@@ -3082,7 +3082,7 @@ int qlcnic_83xx_set_settings(struct qlcnic_adapter *adapter,
 	status = qlcnic_83xx_set_port_config(adapter);
 	if (status) {
 		dev_info(&adapter->pdev->dev,
-			 "Faild to Set Link Speed and autoneg.\n");
+			 "Failed to Set Link Speed and autoneg.\n");
 		adapter->ahw->port_config = config;
 	}
 	return status;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index d3f8797..2fe15c5 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1652,7 +1652,7 @@ static int qlcnic_83xx_process_rcv_ring(struct qlcnic_host_sds_ring *sds_ring,
 			break;
 		default:
 			dev_info(&adapter->pdev->dev,
-				 "Unkonwn opcode: 0x%x\n", opcode);
+				 "Unknown opcode: 0x%x\n", opcode);
 			goto skip;
 		}
 
diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index cbb74d7..9e0ca30 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -1199,7 +1199,7 @@ bool wsm_flush_tx(struct cw1200_common *priv)
 
 	if (priv->bh_error) {
 		/* In case of failure do not wait for magic. */
-		pr_err("[WSM] Fatal error occured, will not flush TX.\n");
+		pr_err("[WSM] Fatal error occurred, will not flush TX.\n");
 		return false;
 	} else {
 		/* Get a timestamp of "oldest" frame */
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index ad9bbca..39b3ffb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -184,7 +184,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		    (!te_data->vif->bss_conf.assoc ||
 		     !te_data->vif->bss_conf.dtim_period)) {
 			IWL_ERR(mvm,
-				"No assocation and the time event is over already...\n");
+				"No association and the time event is over already...\n");
 			ieee80211_connection_loss(te_data->vif);
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
index 57e4cc5..557bc5b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
@@ -341,7 +341,7 @@ static void _rtl88e_fill_h2c_command(struct ieee80211_hw *hw,
 			wait_h2c_limit--;
 			if (wait_h2c_limit == 0) {
 				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-					 "Wating too long for FW read "
+					 "Waiting too long for FW read "
 					 "clear HMEBox(%d)!\n", boxnum);
 				break;
 			}
@@ -351,7 +351,7 @@ static void _rtl88e_fill_h2c_command(struct ieee80211_hw *hw,
 			isfw_read = _rtl88e_check_fw_read_last_h2c(hw, boxnum);
 			u1b_tmp = rtl_read_byte(rtlpriv, 0x130);
 			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "Wating for FW read clear HMEBox(%d)!!! "
+				 "Waiting for FW read clear HMEBox(%d)!!! "
 				 "0x130 = %2x\n", boxnum, u1b_tmp);
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
index dedfa1e..ba1502b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
@@ -330,7 +330,7 @@ static void _rtl8723ae_fill_h2c_command(struct ieee80211_hw *hw,
 			wait_h2c_limmit--;
 			if (wait_h2c_limmit == 0) {
 				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-					 "Wating too long for FW read clear HMEBox(%d)!\n",
+					 "Waiting too long for FW read clear HMEBox(%d)!\n",
 					 boxnum);
 				break;
 			}
@@ -340,7 +340,7 @@ static void _rtl8723ae_fill_h2c_command(struct ieee80211_hw *hw,
 			isfw_rd = rtl8723ae_check_fw_read_last_h2c(hw, boxnum);
 			u1tmp = rtl_read_byte(rtlpriv, 0x1BF);
 			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "Wating for FW read clear HMEBox(%d)!!! "
+				 "Waiting for FW read clear HMEBox(%d)!!! "
 				 "0x1BF = %2x\n", boxnum, u1tmp);
 		}
 
diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index ffff66b..de029bb 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -554,7 +554,7 @@ static irqreturn_t pm860x_vchg_handler(int irq, void *data)
 					OVTEMP_AUTORECOVER,
 					OVTEMP_AUTORECOVER);
 			dev_dbg(info->dev,
-				"%s, pm8606 over-temp occure\n", __func__);
+				"%s, pm8606 over-temp occurred\n", __func__);
 		}
 	}
 
@@ -562,7 +562,7 @@ static irqreturn_t pm860x_vchg_handler(int irq, void *data)
 		set_vchg_threshold(info, VCHG_OVP_LOW, 0);
 		info->allowed = 0;
 		dev_dbg(info->dev,
-			"%s,pm8607 over-vchg occure,vchg = %dmv\n",
+			"%s,pm8607 over-vchg occurred,vchg = %dmv\n",
 			__func__, vchg);
 	} else if (vchg < VCHG_OVP_LOW) {
 		set_vchg_threshold(info, VCHG_NORMAL_LOW,
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 1c0bfcb..ffa10ed 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -386,7 +386,7 @@ static int pm2_int_reg2(void *pm2_data, int val)
 	if (val & (PM2XXX_INT3_ITCHPRECHARGEWD |
 				PM2XXX_INT3_ITCHCCWD | PM2XXX_INT3_ITCHCVWD)) {
 		dev_dbg(pm2->dev,
-			"Watchdog occured for precharge, CC and CV charge\n");
+			"Watchdog occurred for precharge, CC and CV charge\n");
 	}
 
 	return ret;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 5cb08ae..f4360c5 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -818,7 +818,7 @@ lpfc_issue_reset(struct device *dev, struct device_attribute *attr,
  * the readyness after performing a firmware reset.
  *
  * Returns:
- * zero for success, -EPERM when port does not have privilage to perform the
+ * zero for success, -EPERM when port does not have privilege to perform the
  * reset, -EIO when port timeout from recovering from the reset.
  *
  * Note:
@@ -835,7 +835,7 @@ lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 	lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
 		   &portstat_reg.word0);
 
-	/* verify if privilaged for the request operation */
+	/* verify if privileged for the request operation */
 	if (!bf_get(lpfc_sliport_status_rn, &portstat_reg) &&
 	    !bf_get(lpfc_sliport_status_err, &portstat_reg))
 		return -EPERM;
@@ -927,9 +927,9 @@ lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 	rc = lpfc_sli4_pdev_status_reg_wait(phba);
 
 	if (rc == -EPERM) {
-		/* no privilage for reset */
+		/* no privilege for reset */
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"3150 No privilage to perform the requested "
+				"3150 No privilege to perform the requested "
 				"access: x%x\n", reg_val);
 	} else if (rc == -EIO) {
 		/* reset failed, there is nothing more we can do */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d799379..ab4be10 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1779,7 +1779,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		p_sysid = utsname();
 		if (!p_sysid) {
 			ql_log(ql_log_warn, vha, 0x303c,
-			    "Not able to get the system informtion\n");
+			    "Not able to get the system information\n");
 			goto done_free_sp;
 		}
 		break;
-- 
1.8.3.2.804.g0da7a53

