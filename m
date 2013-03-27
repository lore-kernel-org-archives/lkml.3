Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3C0LUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:20:14 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60096 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3C0LUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:20:12 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 20:20:11 +0900
X-Google-Sender-Auth: HONJaa0q3U6u7qiFv6WPCWwOl9k
Message-ID: <CAFyudig8ak-q+0LtrfG_we57UFM6RymhFdhggcEcqHpTg76rew@mail.gmail.com>
Subject: [PATCH] staging: rtl8192u: fix coding style
From: Haksu Jeong <hsjeong@snu.ac.kr>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style of r8192U_dm.h

Signed-off-by: Haksu Jeong <hsjeong@snu.ac.kr>
---
 drivers/staging/rtl8192u/r8192U_dm.h |   77 +++++++++++++++-------------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_dm.h
b/drivers/staging/rtl8192u/r8192U_dm.h
index ffb083c..ae55052 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.h
+++ b/drivers/staging/rtl8192u/r8192U_dm.h
@@ -48,16 +48,16 @@
 #define		VeryLowRSSI					15
 #define		CTSToSelfTHVal					30

-//defined by vivi, for tx power track
+/* defined by vivi, for tx power track */
 #define		E_FOR_TX_POWER_TRACK               300
-//Dynamic Tx Power Control Threshold
+/* Dynamic Tx Power Control Threshold */
 #define		TX_POWER_NEAR_FIELD_THRESH_HIGH		68
 #define		TX_POWER_NEAR_FIELD_THRESH_LOW		62
-//added by amy for atheros AP
+/* added by amy for atheros AP */
 #define         TX_POWER_ATHEROAP_THRESH_HIGH           78
 #define		TX_POWER_ATHEROAP_THRESH_LOW		72

-//defined by vivi, for showing on UI
+/* defined by vivi, for showing on UI */
 #define			Current_Tx_Rate_Reg         0x1b8
 #define			Initial_Tx_Rate_Reg		  0x1b9
 #define			Tx_Retry_Count_Reg         0x1ac
@@ -98,28 +98,25 @@ typedef struct _dynamic_initial_gain_threshold_ {
 	bool		initialgain_lowerbound_state;

 	long		rssi_val;
-}dig_t;
+} dig_t;

-typedef enum tag_dynamic_init_gain_state_definition
-{
+typedef enum tag_dynamic_init_gain_state_definition {
 	DM_STA_DIG_OFF = 0,
 	DM_STA_DIG_ON,
 	DM_STA_DIG_MAX
-}dm_dig_sta_e;
+} dm_dig_sta_e;


 /* 2007/10/08 MH Define RATR state. */
-typedef enum tag_dynamic_ratr_state_definition
-{
+typedef enum tag_dynamic_ratr_state_definition {
 	DM_RATR_STA_HIGH = 0,
 	DM_RATR_STA_MIDDLE = 1,
 	DM_RATR_STA_LOW = 2,
 	DM_RATR_STA_MAX
-}dm_ratr_sta_e;
+} dm_ratr_sta_e;

 /* 2007/10/11 MH Define DIG operation type. */
-typedef enum tag_dynamic_init_gain_operation_type_definition
-{
+typedef enum tag_dynamic_init_gain_operation_type_definition {
 	DIG_TYPE_THRESH_HIGH	= 0,
 	DIG_TYPE_THRESH_LOW	= 1,
 	DIG_TYPE_THRESH_HIGHPWR_HIGH	= 2,
@@ -134,43 +131,38 @@ typedef enum
tag_dynamic_init_gain_operation_type_definition
 	DIG_TYPE_ENABLE			= 20,
 	DIG_TYPE_DISABLE		= 30,
 	DIG_OP_TYPE_MAX
-}dm_dig_op_e;
+} dm_dig_op_e;

-typedef enum tag_dig_algorithm_definition
-{
+typedef enum tag_dig_algorithm_definition {
 	DIG_ALGO_BY_FALSE_ALARM = 0,
 	DIG_ALGO_BY_RSSI	= 1,
 	DIG_ALGO_MAX
-}dm_dig_alg_e;
+} dm_dig_alg_e;

-typedef enum tag_dig_dbgmode_definition
-{
+typedef enum tag_dig_dbgmode_definition {
 	DIG_DBG_OFF = 0,
 	DIG_DBG_ON = 1,
 	DIG_DBG_MAX
-}dm_dig_dbg_e;
+} dm_dig_dbg_e;

-typedef enum tag_dig_connect_definition
-{
+typedef enum tag_dig_connect_definition {
 	DIG_DISCONNECT = 0,
 	DIG_CONNECT = 1,
 	DIG_CONNECT_MAX
-}dm_dig_connect_e;
+} dm_dig_connect_e;

-typedef enum tag_dig_packetdetection_threshold_definition
-{
+typedef enum tag_dig_packetdetection_threshold_definition {
 	DIG_PD_AT_LOW_POWER = 0,
 	DIG_PD_AT_NORMAL_POWER = 1,
 	DIG_PD_AT_HIGH_POWER = 2,
 	DIG_PD_MAX
-}dm_dig_pd_th_e;
+} dm_dig_pd_th_e;

-typedef enum tag_dig_cck_cs_ratio_state_definition
-{
+typedef enum tag_dig_cck_cs_ratio_state_definition {
 	DIG_CS_RATIO_LOWER = 0,
 	DIG_CS_RATIO_HIGHER = 1,
 	DIG_CS_MAX
-}dm_dig_cs_ratio_e;
+} dm_dig_cs_ratio_e;
 typedef struct _Dynamic_Rx_Path_Selection_ {
 	u8		Enable;
 	u8		DbgMode;
@@ -185,27 +177,25 @@ typedef struct _Dynamic_Rx_Path_Selection_ {
 	u8		rf_rssi[4];
 	u8		rf_enable_rssi_th[4];
 	long		cck_pwdb_sta[4];
-}DRxPathSel;
+} DRxPathSel;

-typedef enum tag_CCK_Rx_Path_Method_Definition
-{
+typedef enum tag_CCK_Rx_Path_Method_Definition {
 	CCK_Rx_Version_1 = 0,
-	CCK_Rx_Version_2= 1,
+	CCK_Rx_Version_2 = 1,
 	CCK_Rx_Version_MAX
-}DM_CCK_Rx_Path_Method;
+} DM_CCK_Rx_Path_Method;

-typedef enum tag_DM_DbgMode_Definition
-{
+typedef enum tag_DM_DbgMode_Definition {
 	DM_DBG_OFF = 0,
 	DM_DBG_ON = 1,
 	DM_DBG_MAX
-}DM_DBG_E;
+} DM_DBG_E;

 typedef struct tag_Tx_Config_Cmd_Format {
-	u32	Op;										/* Command packet type. */
-	u32	Length;									/* Command packet length. */
+	u32	Op;			/* Command packet type. */
+	u32	Length;			/* Command packet length. */
 	u32	Value;
-}DCMD_TXCMD_T, *PDCMD_TXCMD_T;
+} DCMD_TXCMD_T, *PDCMD_TXCMD_T;
 /*------------------------------Define structure----------------------------*/


@@ -232,13 +222,14 @@ extern  void
dm_txpower_trackingcallback(struct work_struct *work);
 extern  void    dm_restore_dynamic_mechanism_state(struct net_device *dev);
 extern  void    dm_backup_dynamic_mechanism_state(struct net_device *dev);
 extern  void    dm_change_dynamic_initgain_thresh(struct net_device *dev,
-								u32 dm_type, u32 dm_value);
-extern  void    dm_force_tx_fw_info(struct net_device *dev,u32
force_type, u32 force_value);
+						u32 dm_type, u32 dm_value);
+extern  void    dm_force_tx_fw_info(struct net_device *dev,
+					u32 force_type, u32 force_value);
 extern  void    dm_init_edca_turbo(struct net_device *dev);
 extern  void    dm_rf_operation_test_callback(unsigned long data);
 extern  void    dm_rf_pathcheck_workitemcallback(struct work_struct *work);
 extern  void dm_fsync_timer_callback(unsigned long data);
-extern	void	dm_cck_txpower_adjust(struct net_device *dev,bool  binch14);
+extern	void	dm_cck_txpower_adjust(struct net_device *dev, bool  binch14);
 extern  void    dm_shadow_init(struct net_device *dev);
 extern void dm_initialize_txpower_tracking(struct net_device *dev);
 /*--------------------------Exported Function prototype---------------------*/
-- 
1.7.9.5
