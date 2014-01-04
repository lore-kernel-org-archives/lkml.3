Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaADPZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:25:52 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49300 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbaADPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:50 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] Staging: vt6656: Correct operator coding style
Date: Sat,  4 Jan 2014 16:25:09 +0100
Message-Id: <1388849118-11994-5-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Adds spaces around operators (like &&, ||, !=, +, ...) and removes
spaces before postfix increment and decrement operators. Parentheses
around return values are removed, too.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 64 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index e9c61ee..84bac2d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -58,8 +58,8 @@
 #include "iowpa.h"
 #include "power.h"
 
-static int msglevel =MSG_LEVEL_INFO;
-/* static int msglevel =MSG_LEVEL_DEBUG; */
+static int msglevel = MSG_LEVEL_INFO;
+/* static int msglevel = MSG_LEVEL_DEBUG; */
 
 static const u16 awHWRetry0[5][5] = {
 			{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
@@ -104,7 +104,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
-			(memcmp(pbyDesireBSSID, ZeroBSSID, 6)!= 0)){
+			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)){
 				pbyBSSID = pbyDesireBSSID;
 		}
 	}
@@ -114,9 +114,9 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		}
 	}
 
-	if ((pbyBSSID != NULL)&&(pDevice->bRoaming == false)) {
+	if ((pbyBSSID != NULL) && (pDevice->bRoaming == false)) {
 		/* match BSSID first */
-		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
+		for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 
 			pCurrBSS->bSelected = false;
@@ -134,7 +134,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 								((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
 								) {
 								pCurrBSS->bSelected = true;
-								return(pCurrBSS);
+								return pCurrBSS;
 							}
 						}
 					} else {
@@ -143,7 +143,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 							((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
 							) {
 							pCurrBSS->bSelected = true;
-							return(pCurrBSS);
+							return pCurrBSS;
 						}
 					}
 				}
@@ -151,7 +151,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		}
 	} else {
 		/* ignore BSSID */
-		for (ii = 0; ii <MAX_BSS_NUM; ii++) {
+		for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 			pCurrBSS = &(pMgmt->sBSSList[ii]);
 
 			/* 2007-0721-01<Mark>by MikeLiu
@@ -211,13 +211,13 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pSelect->bSelected = true;
 			if (pDevice->bRoaming == false)  {
 				/* Einsn Add @20070907 */
-				memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
+				memcpy(pbyDesireSSID, pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
 			}
 
-			return(pSelect);
+			return pSelect;
 		}
 	}
-	return(NULL);
+	return NULL;
 
 }
 
@@ -418,7 +418,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 		PSKeyItem  pTransmitKey = NULL;
 		bool	   bIs802_1x = false;
 
-		for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii ++) {
+		for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii++) {
 			if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
 				bIs802_1x = true;
 				break;
@@ -510,10 +510,10 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	if ((pSSID->len != 0) && (pSSID->abySSID[0] != 0))
 		memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
-	memcpy(pBSSList->abySuppRates, pSuppRates,pSuppRates->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
 	if (pExtSuppRates != NULL) {
-		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates,pExtSuppRates->len + WLAN_IEHDR_LEN);
+		memcpy(pBSSList->abyExtSuppRates, pExtSuppRates, pExtSuppRates->len + WLAN_IEHDR_LEN);
 	} else {
 		memset(pBSSList->abyExtSuppRates, 0, WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1);
 	}
@@ -585,7 +585,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 				jj++;
 			}
 		}
-		pBSSList->ldBmAverRange = ldBmSum /jj;
+		pBSSList->ldBmAverRange = ldBmSum / jj;
 	}
 
 	pBSSList->uIELength = uIELength;
@@ -821,7 +821,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 		~(WLAN_SET_ERP_BARKER_MODE(1) | WLAN_SET_ERP_NONERP_PRESENT(1));
 
 	if (pDevice->wUseProtectCntDown > 0) {
-		pDevice->wUseProtectCntDown --;
+		pDevice->wUseProtectCntDown--;
 	}
 	else {
 		/* disable protect mode */
@@ -872,7 +872,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 					if (pMgmt->sNodeDBTable[ii].uInActiveCount < ERP_RECOVER_COUNT) {
 						if (!pMgmt->sNodeDBTable[ii].bShortPreamble) {
 							pDevice->byERPFlag |= WLAN_SET_ERP_BARKER_MODE(1);
-							uLongPreambleSTACnt ++;
+							uLongPreambleSTACnt++;
 						}
 						if (!pMgmt->sNodeDBTable[ii].bERPExist) {
 							pDevice->byERPFlag |= WLAN_SET_ERP_NONERP_PRESENT(1);
@@ -909,7 +909,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if (pMgmt->sNodeDBTable[ii].wEnQueueCnt != 0) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index= %d, Queue = %d pending \n",
 						   ii, pMgmt->sNodeDBTable[ii].wEnQueueCnt);
-				if ((ii >0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
+				if ((ii > 0) && (pMgmt->sNodeDBTable[ii].wEnQueueCnt > 15)) {
 					BSSvRemoveOneNode(pDevice, ii);
 					DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Pending many queues PS STA Index = %d remove \n", ii);
 					continue;
@@ -1003,7 +1003,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pMgmt->eCurrState = WMAC_STATE_IDLE;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
+				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
 				pDevice->bRoaming = true;
 				pDevice->bIsRoaming = false;
 
@@ -1023,7 +1023,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
-				if ((pDevice->bRoaming == true)&&(pDevice->bIsRoaming == true)){
+				if ((pDevice->bRoaming == true) && (pDevice->bIsRoaming == true)){
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
 					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
 					bScheduleCommand((void *) pDevice,
@@ -1036,7 +1036,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 					pDevice->uIsroamingTime = 0;
 					pDevice->bRoaming = false;
 				}
-				else if ((pDevice->bRoaming == false)&&(pDevice->bIsRoaming == true)) {
+				else if ((pDevice->bRoaming == false) && (pDevice->bIsRoaming == true)) {
 					pDevice->uIsroamingTime++;
 					if (pDevice->uIsroamingTime >= 20)
 						pDevice->bIsRoaming = false;
@@ -1046,7 +1046,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				if (pDevice->uAutoReConnectTime < 10) {
 					pDevice->uAutoReConnectTime++;
 					/* network manager support need not do Roaming scan??? */
-					if(pDevice->bWPASuppWextEnabled ==true)
+					if(pDevice->bWPASuppWextEnabled == true)
 						pDevice->uAutoReConnectTime = 0;
 				}
 				else {
@@ -1089,13 +1089,13 @@ void BSSvSecondCallBack(struct work_struct *work)
 				s_vCheckSensitivity(pDevice);
 				s_vCheckPreEDThreshold(pDevice);
 			}
-			if (pMgmt->sNodeDBTable[0].uInActiveCount >=ADHOC_LOST_BEACON_COUNT) {
+			if (pMgmt->sNodeDBTable[0].uInActiveCount >= ADHOC_LOST_BEACON_COUNT) {
 				DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost other STA beacon [%d] sec, started !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 				pMgmt->eCurrState = WMAC_STATE_STARTED;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
+				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
 			}
 		}
 	}
@@ -1183,14 +1183,14 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 				}
 				pMgmt->sNodeDBTable[0].uTxOk[wFallBackRate]++;
 			} else {
-				pMgmt->sNodeDBTable[0].uTxFailures ++;
+				pMgmt->sNodeDBTable[0].uTxFailures++;
 			}
 			pMgmt->sNodeDBTable[0].uTxRetry += byTxRetry;
 			if (byTxRetry != 0) {
-				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE]+=byTxRetry;
+				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE] += byTxRetry;
 				if ( (byFallBack == AUTO_FB_NONE) ||
 					(wRate < RATE_18M) ) {
-					pMgmt->sNodeDBTable[0].uTxFail[wRate]+=byTxRetry;
+					pMgmt->sNodeDBTable[0].uTxFail[wRate] += byTxRetry;
 				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
 						if (ii < 5)
@@ -1241,14 +1241,14 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 					}
 					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[wFallBackRate]++;
 				} else {
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFailures ++;
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFailures++;
 				}
 				pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
 				if (byTxRetry != 0) {
-					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE]+=byTxRetry;
+					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] += byTxRetry;
 					if ( (byFallBack == AUTO_FB_NONE) ||
 						(wRate < RATE_18M) ) {
-						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate]+=byTxRetry;
+						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] += byTxRetry;
 					} else if (byFallBack == AUTO_FB_0) {
 						for (ii = 0; ii < byTxRetry; ii++) {
 							if (ii < 5)
@@ -1324,13 +1324,13 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 			signed long    uNumofdBm = 0;
 			for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
 				if (pBSSList->ldBmAverage[ii] != 0) {
-					uNumofdBm ++;
+					uNumofdBm++;
 					LocalldBmAverage += pBSSList->ldBmAverage[ii];
 				}
 			}
 			if (uNumofdBm > 0) {
 				LocalldBmAverage = LocalldBmAverage/uNumofdBm;
-				for (ii=0;ii<BB_VGA_LEVEL;ii++) {
+				for (ii = 0; ii < BB_VGA_LEVEL; ii++) {
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"LocalldBmAverage:%ld, %ld %02x\n", LocalldBmAverage, pDevice->ldBmThreshold[ii], pDevice->abyBBVGA[ii]);
 					if (LocalldBmAverage < pDevice->ldBmThreshold[ii]) {
 						pDevice->byBBVGANew = pDevice->abyBBVGA[ii];
-- 
1.8.1.2

