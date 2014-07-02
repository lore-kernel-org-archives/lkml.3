Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaGBQya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44811 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaGBQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 40/48] staging: rtl8188eu: rtw_[cmd, mlme_ext].h: Remove unused command codes
Date: Wed,  2 Jul 2014 22:17:36 +0530
Message-Id: <1404319664-8327-40-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h      |  159 ++++------------------
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |   77 ++---------
 2 files changed, 40 insertions(+), 196 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 47fdef1..8e8092b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -501,153 +501,50 @@ struct _cmd_callback {
 };
 
 enum rtw_h2c_cmd {
-	GEN_CMD_CODE(_Read_MACREG),	/*0*/
-	GEN_CMD_CODE(_Write_MACREG),
-	GEN_CMD_CODE(_Read_BBREG),
-	GEN_CMD_CODE(_Write_BBREG),
-	GEN_CMD_CODE(_Read_RFREG),
-	GEN_CMD_CODE(_Write_RFREG), /*5*/
-	GEN_CMD_CODE(_Read_EEPROM),
-	GEN_CMD_CODE(_Write_EEPROM),
-	GEN_CMD_CODE(_Read_EFUSE),
-	GEN_CMD_CODE(_Write_EFUSE),
-
-	GEN_CMD_CODE(_Read_CAM),	/*10*/
-	GEN_CMD_CODE(_Write_CAM),
-	GEN_CMD_CODE(_setBCNITV),
-	GEN_CMD_CODE(_setMBIDCFG),
-	GEN_CMD_CODE(_JoinBss),   /*14*/
-	GEN_CMD_CODE(_DisConnect), /*15*/
+	GEN_CMD_CODE(_JoinBss),
+	GEN_CMD_CODE(_DisConnect),
 	GEN_CMD_CODE(_CreateBss),
 	GEN_CMD_CODE(_SetOpMode),
-	GEN_CMD_CODE(_SiteSurvey),  /*18*/
+	GEN_CMD_CODE(_SiteSurvey),
 	GEN_CMD_CODE(_SetAuth),
-
-	GEN_CMD_CODE(_SetKey),	/*20*/
+	GEN_CMD_CODE(_SetKey),
 	GEN_CMD_CODE(_SetStaKey),
 	GEN_CMD_CODE(_SetAssocSta),
-	GEN_CMD_CODE(_DelAssocSta),
-	GEN_CMD_CODE(_SetStaPwrState),
-	GEN_CMD_CODE(_SetBasicRate), /*25*/
-	GEN_CMD_CODE(_GetBasicRate),
-	GEN_CMD_CODE(_SetDataRate),
-	GEN_CMD_CODE(_GetDataRate),
-	GEN_CMD_CODE(_SetPhyInfo),
-
-	GEN_CMD_CODE(_GetPhyInfo),	/*30*/
-	GEN_CMD_CODE(_SetPhy),
-	GEN_CMD_CODE(_GetPhy),
-	GEN_CMD_CODE(_readRssi),
-	GEN_CMD_CODE(_readGain),
-	GEN_CMD_CODE(_SetAtim), /*35*/
-	GEN_CMD_CODE(_SetPwrMode),
-	GEN_CMD_CODE(_JoinbssRpt),
-	GEN_CMD_CODE(_SetRaTable),
-	GEN_CMD_CODE(_GetRaTable),
-
-	GEN_CMD_CODE(_GetCCXReport), /*40*/
-	GEN_CMD_CODE(_GetDTMReport),
-	GEN_CMD_CODE(_GetTXRateStatistics),
-	GEN_CMD_CODE(_SetUsbSuspend),
-	GEN_CMD_CODE(_SetH2cLbk),
-	GEN_CMD_CODE(_AddBAReq), /*45*/
-	GEN_CMD_CODE(_SetChannel), /*46*/
-	GEN_CMD_CODE(_SetTxPower),
-	GEN_CMD_CODE(_SwitchAntenna),
-	GEN_CMD_CODE(_SetCrystalCap),
-	GEN_CMD_CODE(_SetSingleCarrierTx), /*50*/
-
-	GEN_CMD_CODE(_SetSingleToneTx),/*51*/
-	GEN_CMD_CODE(_SetCarrierSuppressionTx),
-	GEN_CMD_CODE(_SetContinuousTx),
-	GEN_CMD_CODE(_SwitchBandwidth), /*54*/
-	GEN_CMD_CODE(_TX_Beacon), /*55*/
-
-	GEN_CMD_CODE(_Set_MLME_EVT), /*56*/
-	GEN_CMD_CODE(_Set_Drv_Extra), /*57*/
-	GEN_CMD_CODE(_Set_H2C_MSG), /*58*/
-
-	GEN_CMD_CODE(_SetChannelPlan), /*59*/
-	GEN_CMD_CODE(_LedBlink), /*60*/
-
-	GEN_CMD_CODE(_SetChannelSwitch), /*61*/
-	GEN_CMD_CODE(_TDLS), /*62*/
+	GEN_CMD_CODE(_AddBAReq),
+	GEN_CMD_CODE(_SetChannel),
+	GEN_CMD_CODE(_TX_Beacon),
+	GEN_CMD_CODE(_Set_MLME_EVT),
+	GEN_CMD_CODE(_Set_Drv_Extra),
+	GEN_CMD_CODE(_Set_H2C_MSG),
+	GEN_CMD_CODE(_SetChannelPlan),
+	GEN_CMD_CODE(_LedBlink),
+	GEN_CMD_CODE(_SetChannelSwitch),
+	GEN_CMD_CODE(_TDLS),
 
 	MAX_H2CCMD
 };
 
 #ifdef _RTW_CMD_C_
 static struct _cmd_callback	rtw_cmd_callback[] = {
-	{GEN_CMD_CODE(_Read_MACREG), NULL}, /*0*/
-	{GEN_CMD_CODE(_Write_MACREG), NULL},
-	{GEN_CMD_CODE(_Read_BBREG), NULL},
-	{GEN_CMD_CODE(_Write_BBREG), NULL},
-	{GEN_CMD_CODE(_Read_RFREG), NULL},
-	{GEN_CMD_CODE(_Write_RFREG), NULL}, /*5*/
-	{GEN_CMD_CODE(_Read_EEPROM), NULL},
-	{GEN_CMD_CODE(_Write_EEPROM), NULL},
-	{GEN_CMD_CODE(_Read_EFUSE), NULL},
-	{GEN_CMD_CODE(_Write_EFUSE), NULL},
-
-	{GEN_CMD_CODE(_Read_CAM),	NULL},	/*10*/
-	{GEN_CMD_CODE(_Write_CAM),	 NULL},
-	{GEN_CMD_CODE(_setBCNITV), NULL},
-	{GEN_CMD_CODE(_setMBIDCFG), NULL},
-	{GEN_CMD_CODE(_JoinBss), &rtw_joinbss_cmd_callback},  /*14*/
-	{GEN_CMD_CODE(_DisConnect), &rtw_disassoc_cmd_callback}, /*15*/
+	{GEN_CMD_CODE(_JoinBss), &rtw_joinbss_cmd_callback},
+	{GEN_CMD_CODE(_DisConnect), &rtw_disassoc_cmd_callback},
 	{GEN_CMD_CODE(_CreateBss), &rtw_createbss_cmd_callback},
 	{GEN_CMD_CODE(_SetOpMode), NULL},
-	{GEN_CMD_CODE(_SiteSurvey), &rtw_survey_cmd_callback}, /*18*/
+	{GEN_CMD_CODE(_SiteSurvey), &rtw_survey_cmd_callback},
 	{GEN_CMD_CODE(_SetAuth), NULL},
-
-	{GEN_CMD_CODE(_SetKey), NULL},	/*20*/
+	{GEN_CMD_CODE(_SetKey), NULL},
 	{GEN_CMD_CODE(_SetStaKey), &rtw_setstaKey_cmdrsp_callback},
 	{GEN_CMD_CODE(_SetAssocSta), &rtw_setassocsta_cmdrsp_callback},
-	{GEN_CMD_CODE(_DelAssocSta), NULL},
-	{GEN_CMD_CODE(_SetStaPwrState), NULL},
-	{GEN_CMD_CODE(_SetBasicRate), NULL}, /*25*/
-	{GEN_CMD_CODE(_GetBasicRate), NULL},
-	{GEN_CMD_CODE(_SetDataRate), NULL},
-	{GEN_CMD_CODE(_GetDataRate), NULL},
-	{GEN_CMD_CODE(_SetPhyInfo), NULL},
-
-	{GEN_CMD_CODE(_GetPhyInfo), NULL}, /*30*/
-	{GEN_CMD_CODE(_SetPhy), NULL},
-	{GEN_CMD_CODE(_GetPhy), NULL},
-	{GEN_CMD_CODE(_readRssi), NULL},
-	{GEN_CMD_CODE(_readGain), NULL},
-	{GEN_CMD_CODE(_SetAtim), NULL}, /*35*/
-	{GEN_CMD_CODE(_SetPwrMode), NULL},
-	{GEN_CMD_CODE(_JoinbssRpt), NULL},
-	{GEN_CMD_CODE(_SetRaTable), NULL},
-	{GEN_CMD_CODE(_GetRaTable), NULL},
-
-	{GEN_CMD_CODE(_GetCCXReport), NULL}, /*40*/
-	{GEN_CMD_CODE(_GetDTMReport),	NULL},
-	{GEN_CMD_CODE(_GetTXRateStatistics), NULL},
-	{GEN_CMD_CODE(_SetUsbSuspend), NULL},
-	{GEN_CMD_CODE(_SetH2cLbk), NULL},
-	{GEN_CMD_CODE(_AddBAReq), NULL}, /*45*/
-	{GEN_CMD_CODE(_SetChannel), NULL},		/*46*/
-	{GEN_CMD_CODE(_SetTxPower), NULL},
-	{GEN_CMD_CODE(_SwitchAntenna), NULL},
-	{GEN_CMD_CODE(_SetCrystalCap), NULL},
-	{GEN_CMD_CODE(_SetSingleCarrierTx), NULL},	/*50*/
-
-	{GEN_CMD_CODE(_SetSingleToneTx), NULL}, /*51*/
-	{GEN_CMD_CODE(_SetCarrierSuppressionTx), NULL},
-	{GEN_CMD_CODE(_SetContinuousTx), NULL},
-	{GEN_CMD_CODE(_SwitchBandwidth), NULL},		/*54*/
-	{GEN_CMD_CODE(_TX_Beacon), NULL},/*55*/
-
-	{GEN_CMD_CODE(_Set_MLME_EVT), NULL},/*56*/
-	{GEN_CMD_CODE(_Set_Drv_Extra), NULL},/*57*/
-	{GEN_CMD_CODE(_Set_H2C_MSG), NULL},/*58*/
-	{GEN_CMD_CODE(_SetChannelPlan), NULL},/*59*/
-	{GEN_CMD_CODE(_LedBlink), NULL},/*60*/
-
-	{GEN_CMD_CODE(_SetChannelSwitch), NULL},/*61*/
-	{GEN_CMD_CODE(_TDLS), NULL},/*62*/
+	{GEN_CMD_CODE(_AddBAReq), NULL},
+	{GEN_CMD_CODE(_SetChannel), NULL},
+	{GEN_CMD_CODE(_TX_Beacon), NULL},
+	{GEN_CMD_CODE(_Set_MLME_EVT), NULL},
+	{GEN_CMD_CODE(_Set_Drv_Extra), NULL},
+	{GEN_CMD_CODE(_Set_H2C_MSG), NULL},
+	{GEN_CMD_CODE(_SetChannelPlan), NULL},
+	{GEN_CMD_CODE(_LedBlink), NULL},
+	{GEN_CMD_CODE(_SetChannelSwitch), NULL},
+	{GEN_CMD_CODE(_TDLS), NULL},
 };
 #endif
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 2a32caa..484e874 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -708,78 +708,25 @@ u8 tdls_hdl(struct adapter *padapter, unsigned char *pbuf);
 #ifdef _RTW_CMD_C_
 
 static struct cmd_hdl wlancmds[] = {
-	GEN_DRV_CMD_HANDLER(0, NULL) /*0*/
-	GEN_DRV_CMD_HANDLER(0, NULL)
-	GEN_DRV_CMD_HANDLER(0, NULL)
-	GEN_DRV_CMD_HANDLER(0, NULL)
-	GEN_DRV_CMD_HANDLER(0, NULL)
-	GEN_DRV_CMD_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL) /*10*/
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct wlan_bssid_ex), join_cmd_hdl) /*14*/
+	GEN_MLME_EXT_HANDLER(sizeof (struct wlan_bssid_ex), join_cmd_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct disconnect_parm), disconnect_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct wlan_bssid_ex), createbss_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct setopmode_parm), setopmode_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof (struct sitesurvey_parm),
-			     sitesurvey_cmd_hdl) /*18*/
+	GEN_MLME_EXT_HANDLER(sizeof (struct sitesurvey_parm), sitesurvey_cmd_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct setauth_parm), setauth_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof (struct setkey_parm), setkey_hdl) /*20*/
+	GEN_MLME_EXT_HANDLER(sizeof (struct setkey_parm), setkey_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct set_stakey_parm), set_stakey_hdl)
 	GEN_MLME_EXT_HANDLER(sizeof (struct set_assocsta_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct del_assocsta_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct setstapwrstate_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct setbasicrate_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct getbasicrate_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct setdatarate_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct getdatarate_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct setphyinfo_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct getphyinfo_parm), NULL)  /*30*/
-	GEN_MLME_EXT_HANDLER(sizeof (struct setphy_parm), NULL)
-	GEN_MLME_EXT_HANDLER(sizeof (struct getphy_parm), NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)	/*40*/
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
 	GEN_MLME_EXT_HANDLER(sizeof(struct addBaReq_parm), add_ba_hdl)
-	GEN_MLME_EXT_HANDLER(sizeof(struct set_ch_parm), set_ch_hdl) /* 46 */
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL) /*50*/
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(0, NULL)
-	GEN_MLME_EXT_HANDLER(sizeof(struct wlan_bssid_ex),
-			     tx_beacon_hdl) /*55*/
-
-	GEN_MLME_EXT_HANDLER(0, mlme_evt_hdl) /*56*/
-	GEN_MLME_EXT_HANDLER(0, rtw_drvextra_cmd_hdl) /*57*/
-
-	GEN_MLME_EXT_HANDLER(0, h2c_msg_hdl) /*58*/
-	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param),
-			     set_chplan_hdl) /*59*/
-	GEN_MLME_EXT_HANDLER(sizeof(struct LedBlink_param),
-			     led_blink_hdl) /*60*/
-
-	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelSwitch_param),
-			     set_csa_hdl) /*61*/
-	GEN_MLME_EXT_HANDLER(sizeof(struct TDLSoption_param),
-			     tdls_hdl) /*62*/
+	GEN_MLME_EXT_HANDLER(sizeof(struct set_ch_parm), set_ch_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof(struct wlan_bssid_ex), tx_beacon_hdl)
+	GEN_MLME_EXT_HANDLER(0, mlme_evt_hdl)
+	GEN_MLME_EXT_HANDLER(0, rtw_drvextra_cmd_hdl)
+	GEN_MLME_EXT_HANDLER(0, h2c_msg_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelPlan_param), set_chplan_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof(struct LedBlink_param), led_blink_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof(struct SetChannelSwitch_param), set_csa_hdl)
+	GEN_MLME_EXT_HANDLER(sizeof(struct TDLSoption_param), tdls_hdl)
 };
 
 #endif
-- 
1.7.10.4

