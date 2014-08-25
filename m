Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbaHYLfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:35:43 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:64166 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaHYLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:35:41 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8821ae: Fix spaces required around that '?' errors
Date: Mon, 25 Aug 2014 06:35:02 -0500
Message-Id: <1408966502-22350-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl spaces required around that '?' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  | 33 +++++++-------
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h  |  2 +-
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.c   | 12 ++---
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.c  | 28 ++++++------
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.h  |  2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.c  | 20 ++++-----
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  | 24 +++++-----
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.h  |  2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  | 52 +++++++++++-----------
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      |  2 +-
 10 files changed, 89 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
index cf8c382..fb64941 100644
--- a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
@@ -652,7 +652,7 @@ halbtc8812a1ant_SetFwDecBtPwr(
 	u1Byte	buf[5] = {0};
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC, ("[BTCoex], decrease Bt Power : %s\n", 
-			(dec_bt_pwr? "Yes!!":"No!!")));
+			(dec_bt_pwr ? "Yes!!":"No!!")));
 
 	buf[0] = dataLen;
 	buf[1] = 0x3;		// OP_Code
@@ -674,7 +674,7 @@ halbtc8812a1ant_DecBtPwr(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s Dec BT power = %s\n",  
-		(force_exec? "force to":""), ((dec_bt_pwr)? "ON":"OFF")));
+		(force_exec ? "force to":""), ((dec_bt_pwr) ? "ON":"OFF")));
 	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
 
 	if(!force_exec)
@@ -700,7 +700,7 @@ halbtc8812a1ant_SetFwBtLnaConstrain(
 	u1Byte	buf[5] = {0};
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC, ("[BTCoex], set BT LNA Constrain: %s\n", 
-		(bt_lna_cons_on? "ON!!":"OFF!!")));
+		(bt_lna_cons_on ? "ON!!":"OFF!!")));
 
 	buf[0] = dataLen;
 	buf[1] = 0x2;		// OP_Code
@@ -721,7 +721,7 @@ halbtc8812a1ant_SetBtLnaConstrain(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s BT Constrain = %s\n",  
-		(force_exec? "force":""), ((bt_lna_cons_on)? "ON":"OFF")));
+		(force_exec ? "force":""), ((bt_lna_cons_on) ? "ON":"OFF")));
 	coex_dm->bCurBtLnaConstrain = bt_lna_cons_on;
 
 	if(!force_exec)
@@ -766,7 +766,7 @@ halbtc8812a1ant_SetBtPsdMode(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s BT PSD mode = 0x%x\n",  
-		(force_exec? "force":""), bt_psd_mode));
+		(force_exec ? "force":""), bt_psd_mode));
 	coex_dm->bCurBtPsdMode = bt_psd_mode;
 
 	if(!force_exec)
@@ -841,7 +841,7 @@ halbtc8812a1ant_FwDacSwingLvl(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s set FW Dac Swing level = %d\n",  
-		(force_exec? "force to":""), fw_dac_swing_lvl));
+		(force_exec ? "force to":""), fw_dac_swing_lvl));
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if(!force_exec)
@@ -890,7 +890,8 @@ halbtc8812a1ant_RfShrink(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn Rx RF Shrink = %s\n",  
-		(force_exec? "force to":""), ((rx_rf_shrink_on)? "ON":"OFF")));
+		(force_exec ? "force to":""),
+		((rx_rf_shrink_on) ? "ON":"OFF")));
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if(!force_exec)
@@ -939,7 +940,7 @@ halbtc8812a1ant_LowPenaltyRa(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn LowPenaltyRA = %s\n",  
-		(force_exec? "force to":""), ((low_penalty_ra)? "ON":"OFF")));
+		(force_exec ? "force to":""), ((low_penalty_ra) ? "ON":"OFF")));
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if(!force_exec)
@@ -1041,7 +1042,7 @@ halbtc8812a1ant_AdcBackOff(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn AdcBackOff = %s\n",  
-		(force_exec? "force to":""), ((adc_back_off)? "ON":"OFF")));
+		(force_exec ? "force to":""), ((adc_back_off) ? "ON":"OFF")));
 	coex_dm->cur_adc_back_off = adc_back_off;
 
 	if(!force_exec)
@@ -1182,7 +1183,7 @@ halbtc8812a1ant_SetFwIgnoreWlanAct(
 	u1Byte	buf[5] = {0};
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC, ("[BTCoex], %s BT Ignore Wlan_Act\n",
-		(enable? "Enable":"Disable")));
+		(enable ? "Enable":"Disable")));
 
 	buf[0] = dataLen;
 	buf[1] = 0x1;			// OP_Code
@@ -1203,7 +1204,7 @@ halbtc8812a1ant_IgnoreWlanAct(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn Ignore WlanAct %s\n", 
-		(force_exec? "force to":""), (enable? "ON":"OFF")));
+		(force_exec ? "force to":""), (enable ? "ON":"OFF")));
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if(!force_exec)
@@ -1340,7 +1341,7 @@ halbtc8812a1ant_PsTdma(
 	u1Byte			psTdmaTypeByCnt=0, rssi_adjust_val=0;
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn %s PS TDMA, type=%d\n", 
-		(force_exec? "force to":""), (turn_on? "ON":"OFF"), type));
+		(force_exec ? "force to":""), (turn_on ? "ON":"OFF"), type));
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
@@ -3308,7 +3309,7 @@ EXhalbtc8812a1ant_DisplayCoexInfo(
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION, &wifiTrafficDir);
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ", "Wifi status", \
-		(wifi_under5g? "5G":"2.4G"),
+		(wifi_under5g ? "5G":"2.4G"),
 		((BTC_WIFI_BW_LEGACY==wifi_bw)? "Legacy": (((BTC_WIFI_BW_HT40==wifi_bw)? "HT40":"HT20"))),
 		((!wifi_busy)? "idle": ((BTC_WIFI_TRAFFIC_TX==wifiTrafficDir)? "uplink":"downlink")));
 	CL_PRINTF(cli_buf);
@@ -3329,7 +3330,7 @@ EXhalbtc8812a1ant_DisplayCoexInfo(
 
 	bt_info_ext = coex_sta->bt_info_ext;
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s", "BT Info A2DP rate", \
-		(bt_info_ext&BIT0)? "Basic rate":"EDR rate");
+		(bt_info_ext&BIT0) ? "Basic rate":"EDR rate");
 	CL_PRINTF(cli_buf);	
 
 	for(i=0; i<BT_INFO_SRC_8812A_1ANT_MAX; i++)
@@ -3345,8 +3346,8 @@ EXhalbtc8812a1ant_DisplayCoexInfo(
 		}
 	}
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s/%s, (0x%x/0x%x)", "PS state, IPS/LPS, (lps/rpwm)", \
-		((coex_sta->under_ips? "IPS ON":"IPS OFF")),
-		((coex_sta->under_lps? "LPS ON":"LPS OFF")), 
+		((coex_sta->under_ips ? "IPS ON":"IPS OFF")),
+		((coex_sta->under_lps ? "LPS ON":"LPS OFF")),
 		btcoexist->bt_info.lps1Ant, 
 		btcoexist->bt_info.rpwm1Ant);
 	CL_PRINTF(cli_buf);
diff --git a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
index 37bdab5..5a46c33 100644
--- a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
@@ -11,7 +11,7 @@
 #define	BT_INFO_8812A_1ANT_B_CONNECTION				BIT0
 
 #define	BT_INFO_8812A_1ANT_A2DP_BASIC_RATE(_BT_INFO_EXT_)	\
-		(((_BT_INFO_EXT_&BIT0))? true:false)
+		(((_BT_INFO_EXT_&BIT0)) ? true:false)
 
 #define	BTC_RSSI_COEX_THRESH_TOL_8812A_1ANT		2
 
diff --git a/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c b/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
index 8e4293a..88c8fa3 100644
--- a/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
@@ -121,7 +121,7 @@ halbtc8723a1ant_RfShrink(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn Rx RF Shrink = %s\n",  
-		(bForceExec? "force to":""), ((bRxRfShrinkOn)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bRxRfShrinkOn) ? "ON":"OFF")));
 	pCoexDm->bCurRfRxLpfShrink = bRxRfShrinkOn;
 
 	if(!bForceExec)
@@ -170,7 +170,7 @@ halbtc8723a1ant_LowPenaltyRa(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn LowPenaltyRA = %s\n",  
-		(bForceExec? "force to":""), ((bLowPenaltyRa)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bLowPenaltyRa) ? "ON":"OFF")));
 	pCoexDm->bCurLowPenaltyRa = bLowPenaltyRa;
 
 	if(!bForceExec)
@@ -214,7 +214,7 @@ halbtc8723a1ant_CoexTable(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s write Coex Table 0x6c0=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n", 
-		(bForceExec? "force to":""), val0x6c0, val0x6c8, val0x6cc));
+		(bForceExec ? "force to":""), val0x6c0, val0x6c8, val0x6cc));
 	pCoexDm->curVal0x6c0 = val0x6c0;
 	pCoexDm->curVal0x6c8 = val0x6c8;
 	pCoexDm->curVal0x6cc = val0x6cc;
@@ -265,7 +265,7 @@ halbtc8723a1ant_IgnoreWlanAct(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn Ignore WlanAct %s\n", 
-		(bForceExec? "force to":""), (bEnable? "ON":"OFF")));
+		(bForceExec ? "force to":""), (bEnable ? "ON":"OFF")));
 	pCoexDm->bCurIgnoreWlanAct = bEnable;
 
 	if(!bForceExec)
@@ -1128,7 +1128,7 @@ EXhalbtc8723a1ant_DisplayCoexInfo(
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_BL_WIFI_BUSY, &bWifiBusy);
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION, &wifiTrafficDir);
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ", "Wifi status", \
-		(bWifiUnder5G? "5G":"2.4G"),
+		(bWifiUnder5G ? "5G":"2.4G"),
 		((BTC_WIFI_BW_LEGACY==wifiBw)? "Legacy": (((BTC_WIFI_BW_HT40==wifiBw)? "HT40":"HT20"))),
 		((!bWifiBusy)? "idle": ((BTC_WIFI_TRAFFIC_TX==wifiTrafficDir)? "uplink":"downlink")));
 	CL_PRINTF(cliBuf);
@@ -1149,7 +1149,7 @@ EXhalbtc8723a1ant_DisplayCoexInfo(
 
 	btInfoExt = pCoexSta->btInfoExt;
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s", "BT Info A2DP rate", \
-		(btInfoExt&BIT0)? "Basic rate":"EDR rate");
+		(btInfoExt&BIT0) ? "Basic rate":"EDR rate");
 	CL_PRINTF(cliBuf);	
 
 	for(i=0; i<BT_INFO_SRC_8723A_1ANT_MAX; i++)
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
index 1b04530..72572fc 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
@@ -657,7 +657,7 @@ halbtc8192e1ant_DecBtPwr(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s Dec BT power level = %d\n",  
-		(bForceExec? "force to":""), decBtPwrLvl));
+		(bForceExec ? "force to":""), decBtPwrLvl));
 	pCoexDm->curBtDecPwrLvl = decBtPwrLvl;
 
 	if(!bForceExec)
@@ -703,7 +703,7 @@ halbtc8192e1ant_SetBtLnaConstrain(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s BT Constrain = %s\n",  
-		(bForceExec? "force":""), ((bBtLnaConsOn)? "ON":"OFF")));
+		(bForceExec ? "force":""), ((bBtLnaConsOn) ? "ON":"OFF")));
 	pCoexDm->bCurBtLnaConstrain = bBtLnaConsOn;
 
 	if(!bForceExec)
@@ -747,7 +747,7 @@ halbtc8192e1ant_SetBtPsdMode(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s BT PSD mode = 0x%x\n",  
-		(bForceExec? "force":""), btPsdMode));
+		(bForceExec ? "force":""), btPsdMode));
 	pCoexDm->bCurBtPsdMode = btPsdMode;
 
 	if(!bForceExec)
@@ -817,7 +817,7 @@ halbtc8192e1ant_FwDacSwingLvl(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s set FW Dac Swing level = %d\n",  
-		(bForceExec? "force to":""), fwDacSwingLvl));
+		(bForceExec ? "force to":""), fwDacSwingLvl));
 	pCoexDm->curFwDacSwingLvl = fwDacSwingLvl;
 
 	if(!bForceExec)
@@ -866,7 +866,7 @@ halbtc8192e1ant_RfShrink(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn Rx RF Shrink = %s\n",  
-		(bForceExec? "force to":""), ((bRxRfShrinkOn)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bRxRfShrinkOn) ? "ON":"OFF")));
 	pCoexDm->bCurRfRxLpfShrink = bRxRfShrinkOn;
 
 	if(!bForceExec)
@@ -915,7 +915,7 @@ halbtc8192e1ant_LowPenaltyRa(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn LowPenaltyRA = %s\n",  
-		(bForceExec? "force to":""), ((bLowPenaltyRa)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bLowPenaltyRa) ? "ON":"OFF")));
 	pCoexDm->bCurLowPenaltyRa = bLowPenaltyRa;
 
 	if(!bForceExec)
@@ -1017,7 +1017,7 @@ halbtc8192e1ant_AdcBackOff(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn AdcBackOff = %s\n",  
-		(bForceExec? "force to":""), ((bAdcBackOff)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bAdcBackOff) ? "ON":"OFF")));
 	pCoexDm->bCurAdcBackOff = bAdcBackOff;
 
 	if(!bForceExec)
@@ -1219,7 +1219,7 @@ halbtc8192e1ant_IgnoreWlanAct(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn Ignore WlanAct %s\n", 
-		(bForceExec? "force to":""), (bEnable? "ON":"OFF")));
+		(bForceExec ? "force to":""), (bEnable ? "ON":"OFF")));
 	pCoexDm->bCurIgnoreWlanAct = bEnable;
 
 	if(!bForceExec)
@@ -1354,7 +1354,7 @@ halbtc8192e1ant_PsTdma(
 	u1Byte			psTdmaTypeByCnt=0, rssiAdjustVal=0;
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn %s PS TDMA, type=%d\n", 
-		(bForceExec? "force to":""), (bTurnOn? "ON":"OFF"), type));
+		(bForceExec ? "force to":""), (bTurnOn ? "ON":"OFF"), type));
 	pCoexDm->bCurPsTdmaOn = bTurnOn;
 	pCoexDm->curPsTdma = type;
 
@@ -1575,7 +1575,7 @@ halbtc8192e1ant_SwitchSsType(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE, ("[BTCoex], %s Switch SS Type = %d\n",  
-		(bForceExec? "force to":""), newSsType));
+		(bForceExec ? "force to":""), newSsType));
 	pCoexDm->curSsType = newSsType;
 
 	if(!bForceExec)
@@ -3169,7 +3169,7 @@ EXhalbtc8192e1ant_DisplayCoexInfo(
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_BL_WIFI_BUSY, &bWifiBusy);
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION, &wifiTrafficDir);
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ", "Wifi status", \
-		(bWifiUnder5G? "5G":"2.4G"),
+		(bWifiUnder5G ? "5G":"2.4G"),
 		((BTC_WIFI_BW_LEGACY==wifiBw)? "Legacy": (((BTC_WIFI_BW_HT40==wifiBw)? "HT40":"HT20"))),
 		((!bWifiBusy)? "idle": ((BTC_WIFI_TRAFFIC_TX==wifiTrafficDir)? "uplink":"downlink")));
 	CL_PRINTF(cliBuf);
@@ -3186,7 +3186,7 @@ EXhalbtc8192e1ant_DisplayCoexInfo(
 
 	btInfoExt = pCoexSta->btInfoExt;
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s", "BT Info A2DP rate", \
-		(btInfoExt&BIT0)? "Basic rate":"EDR rate");
+		(btInfoExt&BIT0) ? "Basic rate":"EDR rate");
 	CL_PRINTF(cliBuf);	
 
 	for(i=0; i<BT_INFO_SRC_8192E_1ANT_MAX; i++)
@@ -3202,8 +3202,8 @@ EXhalbtc8192e1ant_DisplayCoexInfo(
 		}
 	}
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s/%s, (0x%x/0x%x)", "PS state, IPS/LPS, (lps/rpwm)", \
-		((pCoexSta->bUnderIps? "IPS ON":"IPS OFF")),
-		((pCoexSta->bUnderLps? "LPS ON":"LPS OFF")), 
+		((pCoexSta->bUnderIps ? "IPS ON":"IPS OFF")),
+		((pCoexSta->bUnderLps ? "LPS ON":"LPS OFF")),
 		pBtCoexist->btInfo.lps1Ant, 
 		pBtCoexist->btInfo.rpwm_1ant);
 	CL_PRINTF(cliBuf);
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
index a759b75..01891b2 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
@@ -13,7 +13,7 @@
 #define	BT_INFO_8192E_1ANT_B_CONNECTION				BIT0
 
 #define	BT_INFO_8192E_1ANT_A2DP_BASIC_RATE(_BT_INFO_EXT_)	\
-		(((_BT_INFO_EXT_&BIT0))? true:FALSE)
+		(((_BT_INFO_EXT_&BIT0)) ? true:FALSE)
 
 #define	BTC_RSSI_COEX_THRESH_TOL_8192E_1ANT		2
 
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
index 3f5c4fd..509b91b 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
@@ -691,7 +691,7 @@ halbtc8723a2ant_SetFwDecBtPwr(
 	}
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC, ("[BTCoex], decrease Bt Power : %s, FW write 0x21=0x%x\n", 
-		(bDecBtPwr? "Yes!!":"No!!"), H2C_Parameter[0]));
+		(bDecBtPwr ? "Yes!!":"No!!"), H2C_Parameter[0]));
 
 	pBtCoexist->btc_fill_h2c(pBtCoexist, 0x21, 1, H2C_Parameter);	
 }
@@ -704,7 +704,7 @@ halbtc8723a2ant_DecBtPwr(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s Dec BT power = %s\n",  
-		(bForceExec? "force to":""), ((bDecBtPwr)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bDecBtPwr) ? "ON":"OFF")));
 	pCoexDm->bCurDecBtPwr = bDecBtPwr;
 
 	if(!bForceExec)
@@ -728,7 +728,7 @@ halbtc8723a2ant_FwDacSwingLvl(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s set FW Dac Swing level = %d\n",  
-		(bForceExec? "force to":""), fwDacSwingLvl));
+		(bForceExec ? "force to":""), fwDacSwingLvl));
 	pCoexDm->curFwDacSwingLvl = fwDacSwingLvl;
 
 	if(!bForceExec)
@@ -777,7 +777,7 @@ halbtc8723a2ant_RfShrink(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn Rx RF Shrink = %s\n",  
-		(bForceExec? "force to":""), ((bRxRfShrinkOn)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bRxRfShrinkOn) ? "ON":"OFF")));
 	pCoexDm->bCurRfRxLpfShrink = bRxRfShrinkOn;
 
 	if(!bForceExec)
@@ -826,7 +826,7 @@ halbtc8723a2ant_LowPenaltyRa(
 {
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn LowPenaltyRA = %s\n",  
-		(bForceExec? "force to":""), ((bLowPenaltyRa)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bLowPenaltyRa) ? "ON":"OFF")));
 	pCoexDm->bCurLowPenaltyRa = bLowPenaltyRa;
 
 	if(!bForceExec)
@@ -916,7 +916,7 @@ halbtc8723a2ant_AdcBackOff(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s turn AdcBackOff = %s\n",  
-		(bForceExec? "force to":""), ((bAdcBackOff)? "ON":"OFF")));
+		(bForceExec ? "force to":""), ((bAdcBackOff) ? "ON":"OFF")));
 	pCoexDm->bCurAdcBackOff = bAdcBackOff;
 
 	if(!bForceExec)
@@ -1030,7 +1030,7 @@ halbtc8723a2ant_CoexTable(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW, ("[BTCoex], %s write Coex Table 0x6c0=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n", 
-		(bForceExec? "force to":""), val0x6c0, val0x6c8, val0x6cc));
+		(bForceExec ? "force to":""), val0x6c0, val0x6c8, val0x6cc));
 	pCoexDm->curVal0x6c0 = val0x6c0;
 	pCoexDm->curVal0x6c8 = val0x6c8;
 	pCoexDm->curVal0x6cc = val0x6cc;
@@ -1081,7 +1081,7 @@ halbtc8723a2ant_IgnoreWlanAct(
 	)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s turn Ignore WlanAct %s\n", 
-		(bForceExec? "force to":""), (bEnable? "ON":"OFF")));
+		(bForceExec ? "force to":""), (bEnable ? "ON":"OFF")));
 	pCoexDm->bCurIgnoreWlanAct = bEnable;
 
 	if(!bForceExec)
@@ -3431,7 +3431,7 @@ EXhalbtc8723a2ant_DisplayCoexInfo(
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_BL_WIFI_BUSY, &bWifiBusy);
 	pBtCoexist->btc_get(pBtCoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION, &wifiTrafficDir);
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ", "Wifi status", \
-		(bWifiUnder5G? "5G":"2.4G"),
+		(bWifiUnder5G ? "5G":"2.4G"),
 		((BTC_WIFI_BW_LEGACY==wifiBw)? "Legacy": (((BTC_WIFI_BW_HT40==wifiBw)? "HT40":"HT20"))),
 		((!bWifiBusy)? "idle": ((BTC_WIFI_TRAFFIC_TX==wifiTrafficDir)? "uplink":"downlink")));
 	CL_PRINTF(cliBuf);
@@ -3452,7 +3452,7 @@ EXhalbtc8723a2ant_DisplayCoexInfo(
 
 	btInfoExt = pCoexSta->btInfoExt;
 	CL_SPRINTF(cliBuf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s", "BT Info A2DP rate", \
-		(btInfoExt&BIT0)? "Basic rate":"EDR rate");
+		(btInfoExt&BIT0) ? "Basic rate":"EDR rate");
 	CL_PRINTF(cliBuf);	
 
 	for(i=0; i<BT_INFO_SRC_8723A_2ANT_MAX; i++)
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
index c969394..b0e11fa 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
@@ -783,7 +783,7 @@ static void halbtc8723b1ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
 		  "[BTCoex], decrease Bt Power : %s, FW write 0x62=0x%x\n",
-		  (dec_bt_pwr? "Yes!!":"No!!"),h2c_parameter[0]);
+		  (dec_bt_pwr ? "Yes!!":"No!!"), h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
@@ -823,7 +823,7 @@ static void halbtc8723b1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
 		  "[BTCoex], BT FW auto report : %s, FW write 0x68=0x%x\n",
-		  (enable_auto_report? "Enabled!!":"Disabled!!"),
+		  (enable_auto_report ? "Enabled!!":"Disabled!!"),
 		  h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
@@ -834,8 +834,8 @@ static void halbtc8723b1ant_bt_auto_report(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s BT Auto report = %s\n",
-		  (force_exec? "force to":""),
-		  ((enable_auto_report)? "Enabled":"Disabled"));
+		  (force_exec ? "force to":""),
+		  ((enable_auto_report) ? "Enabled":"Disabled"));
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
@@ -861,7 +861,7 @@ static void halbtc8723b1ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 	return;
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s set FW Dac Swing level = %d\n",
-		  (force_exec? "force to":""), fw_dac_swing_lvl);
+		  (force_exec ? "force to":""), fw_dac_swing_lvl);
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
@@ -3174,7 +3174,7 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %d",
 		   "BT stack/ hci ext ver", \
-		   ((stack_info->profile_notified)? "Yes":"No"),
+		   ((stack_info->profile_notified) ? "Yes":"No"),
 		   stack_info->hci_version);
 	CL_PRINTF(cli_buf);
 
@@ -3223,16 +3223,16 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 			   &wifi_traffic_dir);
 
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ",
-		   "Wifi status", (wifi_under_5g? "5G":"2.4G"),
+		   "Wifi status", (wifi_under_5g ? "5G":"2.4G"),
 		   ((BTC_WIFI_BW_LEGACY==wifi_bw)? "Legacy":
 			(((BTC_WIFI_BW_HT40==wifi_bw)? "HT40":"HT20"))),
-		   ((!wifi_busy)? "idle":
+		   ((!wifi_busy) ? "idle" :
 			((BTC_WIFI_TRAFFIC_TX==wifi_traffic_dir)?
 				"uplink":"downlink")));
 	CL_PRINTF(cli_buf);
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = [%s/ %d/ %d] ",
 		"BT [status/ rssi/ retryCnt]",
-		((btcoexist->bt_info.bt_disabled)? ("disabled"):
+		((btcoexist->bt_info.bt_disabled) ? ("disabled") :
 		  ((coex_sta->c2h_bt_inquiry_page)?("inquiry/page scan"):
 		    ((BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE == coex_dm->bt_status)?
 		      "non-connected idle":
@@ -3275,8 +3275,8 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n %-35s = %s/%s, (0x%x/0x%x)",
 		   "PS state, IPS/LPS, (lps/rpwm)", \
-		   ((coex_sta->under_ips? "IPS ON":"IPS OFF")),
-		   ((coex_sta->under_lps? "LPS ON":"LPS OFF")),
+		   ((coex_sta->under_ips ? "IPS ON":"IPS OFF")),
+		   ((coex_sta->under_lps ? "LPS ON":"LPS OFF")),
 		   btcoexist->bt_info.lps_1ant,
 		   btcoexist->bt_info.rpwm_1ant);
 	CL_PRINTF(cli_buf);
@@ -3856,7 +3856,7 @@ void ex_halbtc8723b1ant_periodical(struct btc_coexist *btcoexist)
 			  board_info->btdm_ant_pos);
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
 			  "[BTCoex], BT stack/ hci ext ver = %s / %d\n", \
-			  ((stack_info->profile_notified)? "Yes":"No"),
+			  ((stack_info->profile_notified) ? "Yes":"No"),
 			  stack_info->hci_version);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
 				   &bt_patch_ver);
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
index 5ce292f..e4778e7 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
@@ -13,7 +13,7 @@
 #define	BT_INFO_8723B_1ANT_B_CONNECTION			BIT0
 
 #define	BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(_BT_INFO_EXT_)	\
-		(((_BT_INFO_EXT_&BIT0))? true:false)
+		(((_BT_INFO_EXT_&BIT0)) ? true:false)
 
 #define	BTC_RSSI_COEX_THRESH_TOL_8723B_1ANT		2
 
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
index da3f62d..fa7ca90 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
@@ -710,7 +710,7 @@ static void halbtc8723b2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
 		  "[BTCoex], decrease Bt Power : %s, FW write 0x62=0x%x\n",
-		  (dec_bt_pwr? "Yes!!":"No!!"), h2c_parameter[0]);
+		  (dec_bt_pwr ? "Yes!!":"No!!"), h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
@@ -720,7 +720,7 @@ static void halbtc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s Dec BT power = %s\n",
-		  (force_exec? "force to":""), (dec_bt_pwr? "ON":"OFF"));
+		  (force_exec ? "force to":""), (dec_bt_pwr ? "ON":"OFF"));
 	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
 
 	if (!force_exec) {
@@ -748,7 +748,7 @@ static void halbtc8723b2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
 		  "[BTCoex], BT FW auto report : %s, FW write 0x68=0x%x\n",
-		  (enable_auto_report? "Enabled!!":"Disabled!!"),
+		  (enable_auto_report ? "Enabled!!":"Disabled!!"),
 		  h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
@@ -759,8 +759,8 @@ static void halbtc8723b2ant_bt_auto_report(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s BT Auto report = %s\n",
-		  (force_exec? "force to":""),
-		  ((enable_auto_report)? "Enabled":"Disabled"));
+		  (force_exec ? "force to":""),
+		  ((enable_auto_report) ? "Enabled":"Disabled"));
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
@@ -785,7 +785,7 @@ static void halbtc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s set FW Dac Swing level = %d\n",
-		  (force_exec? "force to":""), fw_dac_swing_lvl);
+		  (force_exec ? "force to":""), fw_dac_swing_lvl);
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
@@ -833,7 +833,7 @@ static void halbtc8723b2ant_rf_shrink(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		  (force_exec? "force to":""), (rx_rf_shrink_on? "ON":"OFF"));
+		  (force_exec ? "force to":""), (rx_rf_shrink_on ? "ON":"OFF"));
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if (!force_exec) {
@@ -872,7 +872,7 @@ static void halbtc8723b2ant_set_sw_penalty_txrate_adaptive(
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
 		  "[BTCoex], set WiFi Low-Penalty Retry: %s",
-		  (low_penalty_ra? "ON!!":"OFF!!"));
+		  (low_penalty_ra ? "ON!!":"OFF!!"));
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
@@ -883,7 +883,7 @@ static void halbtc8723b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 	/*return; */
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s turn LowPenaltyRA = %s\n",
-		  (force_exec? "force to":""), (low_penalty_ra? "ON":"OFF"));
+		  (force_exec ? "force to":""), (low_penalty_ra ? "ON":"OFF"));
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -929,8 +929,8 @@ static void halbtc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl=0x%x\n",
-		  (force_exec? "force to":""),
-		  (dac_swing_on? "ON":"OFF"), dac_swing_lvl);
+		  (force_exec ? "force to":""),
+		  (dac_swing_on ? "ON":"OFF"), dac_swing_lvl);
 	coex_dm->cur_dac_swing_on = dac_swing_on;
 	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
@@ -974,7 +974,7 @@ static void halbtc8723b2ant_adc_backoff(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s turn AdcBackOff = %s\n",
-		  (force_exec? "force to":""), (adc_backoff? "ON":"OFF"));
+		  (force_exec ? "force to":""), (adc_backoff ? "ON":"OFF"));
 	coex_dm->cur_adc_back_off = adc_backoff;
 
 	if (!force_exec) {
@@ -1071,8 +1071,8 @@ static void halbtc8723b2ant_agc_table(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s %s Agc Table\n",
-		  (force_exec? "force to":""),
-		  (agc_table_en? "Enable":"Disable"));
+		  (force_exec ? "force to":""),
+		  (agc_table_en ? "Enable":"Disable"));
 	coex_dm->cur_agc_table_en = agc_table_en;
 
 	if (!force_exec) {
@@ -1117,7 +1117,7 @@ static void halbtc8723b2ant_coex_table(struct btc_coexist *btcoexist,
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_SW,
 		  "[BTCoex], %s write Coex Table 0x6c0=0x%x,"
 		  " 0x6c4=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n",
-		  (force_exec? "force to":""), val0x6c0,
+		  (force_exec ? "force to":""), val0x6c0,
 		  val0x6c4, val0x6c8, val0x6cc);
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
@@ -1235,7 +1235,7 @@ static void halbtc8723b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s turn Ignore WlanAct %s\n",
-		  (force_exec? "force to":""), (enable? "ON":"OFF"));
+		  (force_exec ? "force to":""), (enable ? "ON":"OFF"));
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
@@ -1397,7 +1397,7 @@ static void halbtc8723b2ant_ps_tdma(struct btc_coexist *btcoexist,
 
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s turn %s PS TDMA, type=%d\n",
-		  (force_exec? "force to":""), (turn_on? "ON":"OFF"), type);
+		  (force_exec ? "force to":""), (turn_on ? "ON":"OFF"), type);
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
@@ -3639,7 +3639,7 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %d",
 		   "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified)? "Yes":"No"),
+		   ((stack_info->profile_notified) ? "Yes":"No"),
 		   stack_info->hci_version);
 	CL_PRINTF(cli_buf);
 
@@ -3687,10 +3687,10 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
 			   &wifi_traffic_dir);
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s ",
-		   "Wifi status", (wifi_under_5g? "5G":"2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw)? "Legacy":
-		   (((BTC_WIFI_BW_HT40 == wifi_bw)? "HT40":"HT20"))),
-		   ((!wifi_busy)? "idle":
+		   "Wifi status", (wifi_under_5g ? "5G":"2.4G"),
+		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
+		   (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40":"HT20"))),
+		   ((!wifi_busy) ? "idle" :
 		   ((BTC_WIFI_TRAFFIC_TX ==wifi_traffic_dir)?\
 		   "uplink":"downlink")));
 	CL_PRINTF(cli_buf);
@@ -3708,7 +3708,7 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	bt_info_ext = coex_sta->bt_info_ext;
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
 		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0)? "Basic rate":"EDR rate");
+		   (bt_info_ext&BIT0) ? "Basic rate":"EDR rate");
 	CL_PRINTF(cli_buf);
 
 	for (i=0; i<BT_INFO_SRC_8723B_2ANT_MAX; i++) {
@@ -3731,8 +3731,8 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s/%s",
 		   "PS state, IPS/LPS",
-		   ((coex_sta->under_ips? "IPS ON":"IPS OFF")),
-		   ((coex_sta->under_lps? "LPS ON":"LPS OFF")));
+		   ((coex_sta->under_ips ? "IPS ON":"IPS OFF")),
+		   ((coex_sta->under_lps ? "LPS ON":"LPS OFF")));
 	CL_PRINTF(cli_buf);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
@@ -4169,7 +4169,7 @@ void ex_halbtc8723b2ant_periodical(struct btc_coexist *btcoexist)
 			  board_info->btdm_ant_num, board_info->btdm_ant_pos);
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
 			  "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
-			  ((stack_info->profile_notified)? "Yes":"No"),
+			  ((stack_info->profile_notified) ? "Yes":"No"),
 			  stack_info->hci_version);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
 				   &bt_patch_ver);
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
index f885ca7..fcc17a6 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
@@ -406,7 +406,7 @@ void rtl8821ae_dm_bt_set_fw_dec_bt_pwr(
 
 	RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 		("[BTCoex], decrease Bt Power : %s, write 0x21=0x%x\n",
-		(b_dec_bt_pwr? "Yes!!":"No!!"), h2c_parameter[0]));
+		(b_dec_bt_pwr ? "Yes!!":"No!!"), h2c_parameter[0]));
 
 	rtl8821ae_fill_h2c_cmd(hw, 0x21, 1, h2c_parameter);
 }
-- 
1.9.1

