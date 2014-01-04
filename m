Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaADPZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:25:54 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49310 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbaADPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:25:53 -0500
From: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
To: sebastian.rachuj@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, linux@rationality.eu,
        forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        more.andres@gmail.com, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] Staging: vt6656: Correct single space mistakes
Date: Sat,  4 Jan 2014 16:25:10 +0100
Message-Id: <1388849118-11994-6-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
References: <1388849118-11994-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Schuster <linux@rationality.eu>

Adds missing spaces between an if-statement and its condition as well
as between the condition and the following curly brace. At casts
there is also a space added between the type and the variable.

Spaces that either follow an opening parenthese or the sizeof operator
or that preceed semicolons are removed as well.

Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Signed-off-by: Simon Schuster <linux@rationality.eu>
---
 drivers/staging/vt6656/bssdb.c | 136 ++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 84bac2d..38c267b 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -104,12 +104,12 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"BSSpSearchBSSList BSSID[%pM]\n", pbyDesireBSSID);
 		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
-			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)){
+			(memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0)) {
 				pbyBSSID = pbyDesireBSSID;
 		}
 	}
 	if (pbyDesireSSID != NULL) {
-		if (((PWLAN_IE_SSID)pbyDesireSSID)->len != 0) {
+		if (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0) {
 			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
 		}
 	}
@@ -126,8 +126,8 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
 					if (pSSID != NULL) {
 						/* compare ssid */
-						if ( !memcmp(pSSID->abySSID,
-							((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
+						if (!memcmp(pSSID->abySSID,
+							((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
 							pSSID->len)) {
 							if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
 								((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
@@ -164,16 +164,16 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 				if (pSSID != NULL) {
 					/* matched SSID */
 					if (memcmp(pSSID->abySSID,
-						((PWLAN_IE_SSID)pCurrBSS->abySSID)->abySSID,
+						((PWLAN_IE_SSID) pCurrBSS->abySSID)->abySSID,
 						pSSID->len) ||
-						(pSSID->len != ((PWLAN_IE_SSID)pCurrBSS->abySSID)->len)) {
+						(pSSID->len != ((PWLAN_IE_SSID) pCurrBSS->abySSID)->len)) {
 						/* SSID not match skip this BSS */
 						continue;
 					  }
 				}
 				if (((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) ||
 					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo))
-					){
+					) {
 					/* Type not match skip this BSS */
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSS type mismatch.... Config[%d] BSS[0x%04x]\n", pMgmt->eConfigMode, pCurrBSS->wCapInfo);
 					continue;
@@ -211,7 +211,7 @@ PKnownBSS BSSpSearchBSSList(struct vnt_private *pDevice,
 			pSelect->bSelected = true;
 			if (pDevice->bRoaming == false)  {
 				/* Einsn Add @20070907 */
-				memcpy(pbyDesireSSID, pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
+				memcpy(pbyDesireSSID, pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			}
 
 			return pSelect;
@@ -276,9 +276,9 @@ PKnownBSS BSSpAddrIsInBSSList(struct vnt_private *pDevice,
 		pBSSList = &(pMgmt->sBSSList[ii]);
 		if (pBSSList->bActive) {
 			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
-				if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len){
+				if (pSSID->len == ((PWLAN_IE_SSID) pBSSList->abySSID)->len) {
 					if (memcmp(pSSID->abySSID,
-						((PWLAN_IE_SSID)pBSSList->abySSID)->abySSID,
+						((PWLAN_IE_SSID) pBSSList->abySSID)->abySSID,
 						pSSID->len) == 0)
 						return pBSSList;
 				}
@@ -316,26 +316,26 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_rx_mgmt *pRxPacket =
-		(struct vnt_rx_mgmt *)pRxPacketContext;
+		(struct vnt_rx_mgmt *) pRxPacketContext;
 	PKnownBSS pBSSList = NULL;
 	unsigned int ii;
 	bool bParsingQuiet = false;
 
-	pBSSList = (PKnownBSS)&(pMgmt->sBSSList[0]);
+	pBSSList = (PKnownBSS) &(pMgmt->sBSSList[0]);
 
 	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-		pBSSList = (PKnownBSS)&(pMgmt->sBSSList[ii]);
+		pBSSList = (PKnownBSS) &(pMgmt->sBSSList[ii]);
 		if (!pBSSList->bActive)
 			break;
 	}
 
-	if (ii == MAX_BSS_NUM){
+	if (ii == MAX_BSS_NUM) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
 		return false;
 	}
 	/* save the BSS info */
 	pBSSList->bActive = true;
-	memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
+	memcpy(pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
 	pBSSList->qwBSSTimestamp = cpu_to_le64(qwTimestamp);
 	pBSSList->wBeaconInterval = cpu_to_le16(wBeaconInterval);
 	pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
@@ -343,13 +343,13 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 
 	if (pSSID->len > WLAN_SSID_MAXLEN)
 		pSSID->len = WLAN_SSID_MAXLEN;
-	memcpy( pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySSID, pSSID, pSSID->len + WLAN_IEHDR_LEN);
 
 	pBSSList->uChannel = byCurrChannel;
 
 	if (pSuppRates->len > WLAN_RATES_MAXLEN)
 		pSuppRates->len = WLAN_RATES_MAXLEN;
-	memcpy( pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
+	memcpy(pBSSList->abySuppRates, pSuppRates, pSuppRates->len + WLAN_IEHDR_LEN);
 
 	if (pExtSuppRates != NULL) {
 		if (pExtSuppRates->len > WLAN_RATES_MAXLEN)
@@ -424,8 +424,8 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 				break;
 			}
 		}
-		if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len) &&
-			( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
+		if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->len) &&
+			(!memcmp(pSSID->abySSID, ((PWLAN_IE_SSID) pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
 
 			bAdd_PMKID_Candidate((void *) pDevice,
 					 pBSSList->abyBSSID,
@@ -446,7 +446,7 @@ int BSSbInsertToBSSList(struct vnt_private *pDevice,
 	if (pDevice->bUpdateBBVGA) {
 		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt = 0;
-		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &pBSSList->ldBmMAX);
+		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI), &pBSSList->ldBmMAX);
 		pBSSList->ldBmAverage[0] = pBSSList->ldBmMAX;
 		pBSSList->ldBmAverRange = pBSSList->ldBmMAX;
 		for (ii = 1; ii < RSSI_STAT_COUNT; ii++)
@@ -490,7 +490,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_rx_mgmt *pRxPacket =
-		(struct vnt_rx_mgmt *)pRxPacketContext;
+		(struct vnt_rx_mgmt *) pRxPacketContext;
 	int ii, jj;
 	signed long ldBm, ldBmSum;
 	bool bParsingQuiet = false;
@@ -533,7 +533,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 
 	pBSSList->byRxRate = pRxPacket->byRxRate;
 	pBSSList->qwLocalTSF = pRxPacket->qwLocalTSF;
-	if(bChannelHit)
+	if (bChannelHit)
 		pBSSList->uRSSI = pRxPacket->uRSSI;
 	pBSSList->bySQ = pRxPacket->bySQ;
 
@@ -570,7 +570,7 @@ int BSSbUpdateToBSSList(struct vnt_private *pDevice,
 	}
 
 	if (pRxPacket->uRSSI != 0) {
-		RFvRSSITodBm(pDevice, (u8)(pRxPacket->uRSSI), &ldBm);
+		RFvRSSITodBm(pDevice, (u8) (pRxPacket->uRSSI), &ldBm);
 		/* Monitor if RSSI is too strong. */
 		pBSSList->byRSSIStatCnt++;
 		pBSSList->byRSSIStatCnt %= RSSI_STAT_COUNT;
@@ -656,7 +656,7 @@ void BSSvCreateOneNode(struct vnt_private *pDevice, u32 *puNodeIndex)
 	}
 
 	/* if not found replace uInActiveCount with the largest one. */
-	if ( ii == (MAX_NODE_NUM + 1)) {
+	if (ii == (MAX_NODE_NUM + 1)) {
 		*puNodeIndex = SelectIndex;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Replace inactive node = %d\n", SelectIndex);
 		/* clear ps buffer */
@@ -723,15 +723,15 @@ void BSSvUpdateAPNode(struct vnt_private *pDevice,
 	if (pDevice->byBBType == BB_TYPE_11B) {
 		uRateLen = WLAN_RATES_MAXLEN_11B;
 	}
-	pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pSuppRates,
-						(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
+	pMgmt->abyCurrSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES) pSuppRates,
+						(PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
 						uRateLen);
-	pMgmt->abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES)pExtSuppRates,
-						(PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+	pMgmt->abyCurrExtSuppRates[1] = RATEuSetIE((PWLAN_IE_SUPP_RATES) pExtSuppRates,
+						(PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
 						uRateLen);
 	RATEvParseMaxRate((void *) pDevice,
-			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
+			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
 			  true,
 			  &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
 			  &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
@@ -767,8 +767,8 @@ void BSSvAddMulticastNode(struct vnt_private *pDevice)
 	pMgmt->sNodeDBTable[0].bPSEnable = false;
 	skb_queue_head_init(&pMgmt->sNodeDBTable[0].sTxPSQueue);
 	RATEvParseMaxRate((void *) pDevice,
-			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-			  (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
+			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates,
+			  (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates,
 			  true,
 			  &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
 			  &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
@@ -809,9 +809,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 	pDevice->uAssocCount = 0;
 
 	/* Power Saving Mode Tx Burst */
-	if ( pDevice->bEnablePSMode == true ) {
+	if (pDevice->bEnablePSMode == true) {
 		pDevice->ulPSModeWaitTx++;
-		if ( pDevice->ulPSModeWaitTx >= 2 ) {
+		if (pDevice->ulPSModeWaitTx >= 2) {
 			pDevice->ulPSModeWaitTx = 0;
 			pDevice->bPSModeTxBurst = false;
 		}
@@ -828,25 +828,25 @@ void BSSvSecondCallBack(struct work_struct *work)
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
 
-	if(pDevice->byReAssocCount > 0) {
+	if (pDevice->byReAssocCount > 0) {
 		pDevice->byReAssocCount++;
-		if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  /* 10 sec timeout */
+		if ((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  /* 10 sec timeout */
 			printk("Re-association timeout!!!\n");
 			pDevice->byReAssocCount = 0;
-			/* if(pDevice->bWPASuppWextEnabled == true) */
+			/* if (pDevice->bWPASuppWextEnabled == true) */
 			{
 				union iwreq_data  wrqu;
-				memset(&wrqu, 0, sizeof (wrqu));
+				memset(&wrqu, 0, sizeof(wrqu));
 				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 				PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 				wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 			}
 		}
-		else if(pDevice->bLinkPass == true)
+		else if (pDevice->bLinkPass == true)
 			pDevice->byReAssocCount = 0;
 	}
 
-	pMgmt->eLastState = pMgmt->eCurrState ;
+	pMgmt->eLastState = pMgmt->eCurrState;
 
 	s_uCalculateLinkQual(pDevice);
 
@@ -893,13 +893,13 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if (!pDevice->bFixRate) {
 				if (ii > 0) {
 					/* ii = 0 for multicast node (AP & Adhoc) */
-					RATEvTxRateFallBack((void *)pDevice,
+					RATEvTxRateFallBack((void *) pDevice,
 						&(pMgmt->sNodeDBTable[ii]));
 				}
 				else {
 					/* ii = 0 reserved for unicast AP node (Infra STA) */
 					if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)
-						RATEvTxRateFallBack((void *)pDevice,
+						RATEvTxRateFallBack((void *) pDevice,
 							&(pMgmt->sNodeDBTable[ii]));
 				}
 
@@ -940,14 +940,14 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if (pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = false;
 				BBvSetShortSlotTime(pDevice);
-				vUpdateIFS((void *)pDevice);
+				vUpdateIFS((void *) pDevice);
 			}
 		}
 		else {
 			if (!pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = true;
 				BBvSetShortSlotTime(pDevice);
-				vUpdateIFS((void *)pDevice);
+				vUpdateIFS((void *) pDevice);
 			}
 		}
 
@@ -976,8 +976,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 			pMgmt->sNodeDBTable[0].bPSEnable = false;
 	}
 
-	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-	pCurrSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
+	pItemSSID = (PWLAN_IE_SSID) pMgmt->abyDesireSSID;
+	pCurrSSID = (PWLAN_IE_SSID) pMgmt->abyCurrSSID;
 
 	if ((pMgmt->eCurrMode == WMAC_MODE_STANDBY) ||
 		(pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
@@ -990,7 +990,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 			}
 
 			if ((pMgmt->sNodeDBTable[0].uInActiveCount >= (LOST_BEACON_COUNT/2)) &&
-				(pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) ) {
+				(pDevice->byBBVGACurrent != pDevice->abyBBVGA[0])) {
 				pDevice->byBBVGANew = pDevice->abyBBVGA[0];
 				bScheduleCommand((void *) pDevice,
 					WLAN_CMD_CHANGE_BBSENSITIVITY,
@@ -1011,7 +1011,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				/* let wpa supplicant know AP may disconnect */
 				{
 					union iwreq_data  wrqu;
-					memset(&wrqu, 0, sizeof (wrqu));
+					memset(&wrqu, 0, sizeof(wrqu));
 						wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 					PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 					wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
@@ -1021,9 +1021,9 @@ void BSSvSecondCallBack(struct work_struct *work)
 		else if (pItemSSID->len != 0) {
 			/* Davidwang */
 			if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
-				if ((pDevice->bRoaming == true) && (pDevice->bIsRoaming == true)){
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming);
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming);
+				if ((pDevice->bRoaming == true) && (pDevice->bIsRoaming == true)) {
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
 					BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
 					bScheduleCommand((void *) pDevice,
@@ -1046,12 +1046,12 @@ void BSSvSecondCallBack(struct work_struct *work)
 				if (pDevice->uAutoReConnectTime < 10) {
 					pDevice->uAutoReConnectTime++;
 					/* network manager support need not do Roaming scan??? */
-					if(pDevice->bWPASuppWextEnabled == true)
+					if (pDevice->bWPASuppWextEnabled == true)
 						pDevice->uAutoReConnectTime = 0;
 				}
 				else {
 					/* mike use old encryption status for wpa reauthen */
-					if(pDevice->bWPADEVUp)
+					if (pDevice->bWPADEVUp)
 						pDevice->eEncryptionStatus = pDevice->eOldEncryptionStatus;
 
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming ...\n");
@@ -1164,11 +1164,11 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 	if (wFIFOCtl & FIFOCTL_NEEDACK) {
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
 			pMgmt->sNodeDBTable[0].uTxAttempts += 1;
-			if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+			if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
 				/* transmit success, TxAttempts at least plus one */
 				pMgmt->sNodeDBTable[0].uTxOk[MAX_RATE]++;
-				if ( (byFallBack == AUTO_FB_NONE) ||
-					 (wRate < RATE_18M) ) {
+				if ((byFallBack == AUTO_FB_NONE) ||
+					 (wRate < RATE_18M)) {
 					wFallBackRate = wRate;
 				} else if (byFallBack == AUTO_FB_0) {
 					if (byTxRetry < 5)
@@ -1188,8 +1188,8 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 			pMgmt->sNodeDBTable[0].uTxRetry += byTxRetry;
 			if (byTxRetry != 0) {
 				pMgmt->sNodeDBTable[0].uTxFail[MAX_RATE] += byTxRetry;
-				if ( (byFallBack == AUTO_FB_NONE) ||
-					(wRate < RATE_18M) ) {
+				if ((byFallBack == AUTO_FB_NONE) ||
+					(wRate < RATE_18M)) {
 					pMgmt->sNodeDBTable[0].uTxFail[wRate] += byTxRetry;
 				} else if (byFallBack == AUTO_FB_0) {
 					for (ii = 0; ii < byTxRetry; ii++) {
@@ -1222,11 +1222,11 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 						  pbyDestAddr,
 						  &uNodeIndex)) {
 				pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts += 1;
-				if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
+				if (!(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
 					/* transmit success, TxAttempts at least plus one */
 					pMgmt->sNodeDBTable[uNodeIndex].uTxOk[MAX_RATE]++;
-					if ( (byFallBack == AUTO_FB_NONE) ||
-						(wRate < RATE_18M) ) {
+					if ((byFallBack == AUTO_FB_NONE) ||
+						(wRate < RATE_18M)) {
 						wFallBackRate = wRate;
 					} else if (byFallBack == AUTO_FB_0) {
 						if (byTxRetry < 5)
@@ -1246,8 +1246,8 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 				pMgmt->sNodeDBTable[uNodeIndex].uTxRetry += byTxRetry;
 				if (byTxRetry != 0) {
 					pMgmt->sNodeDBTable[uNodeIndex].uTxFail[MAX_RATE] += byTxRetry;
-					if ( (byFallBack == AUTO_FB_NONE) ||
-						(wRate < RATE_18M) ) {
+					if ((byFallBack == AUTO_FB_NONE) ||
+						(wRate < RATE_18M)) {
 						pMgmt->sNodeDBTable[uNodeIndex].uTxFail[wRate] += byTxRetry;
 					} else if (byFallBack == AUTO_FB_0) {
 						for (ii = 0; ii < byTxRetry; ii++) {
@@ -1299,7 +1299,7 @@ void BSSvClearNodeDBTable(struct vnt_private *pDevice, u32 uStartIndex)
 		if (pMgmt->sNodeDBTable[ii].bActive) {
 			/* check if sTxPSQueue has been initial */
 			if (pMgmt->sNodeDBTable[ii].sTxPSQueue.next != NULL) {
-				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL){
+				while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[ii].sTxPSQueue)) != NULL) {
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS skb != NULL %d\n", ii);
 					dev_kfree_skb(skb);
 				}
@@ -1317,7 +1317,7 @@ static void s_vCheckSensitivity(struct vnt_private *pDevice)
 
 	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
 		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
-		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
+		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList != NULL) {
 			/* Update BB register if RSSI is too strong */
 			signed long    LocalldBmAverage = 0;
@@ -1373,7 +1373,7 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 	if (pDevice->bLinkPass != true) {
 		pDevice->wstats.qual.qual = 0;
 	} else {
-		RFvRSSITodBm(pDevice, (u8)(pDevice->uCurrRSSI), &ldBm);
+		RFvRSSITodBm(pDevice, (u8) (pDevice->uCurrRSSI), &ldBm);
 		if (-ldBm < 50)
 			RssiRatio = 4000;
 		else if (-ldBm > 90)
@@ -1383,7 +1383,7 @@ static void s_uCalculateLinkQual(struct vnt_private *pDevice)
 
 		qual = (RssiRatio + TxOkRatio + RxOkRatio) / 100;
 		if (qual < 100)
-			pDevice->wstats.qual.qual = (u8)qual;
+			pDevice->wstats.qual.qual = (u8) qual;
 		else
 			pDevice->wstats.qual.qual = 100;
 	}
@@ -1407,7 +1407,7 @@ static void s_vCheckPreEDThreshold(struct vnt_private *pDevice)
 
 	if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
 		((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
-		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
+		pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 		if (pBSSList != NULL) {
 			pDevice->byBBPreEDRSSI = (u8) (~(pBSSList->ldBmAverRange) + 1);
 			BBvUpdatePreEDThreshold(pDevice, false);
-- 
1.8.1.2

