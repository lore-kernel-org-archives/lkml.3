Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3I1TAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:00:46 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:54707 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3I1TAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:00:43 -0400
From: Martin Berglund <martin@rogsta.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, martin@rogsta.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: vt6655: 80211mgr: Cleanup of brace coding style issues
Date: Sat, 28 Sep 2013 21:03:24 +0200
Message-Id: <1380395004-31680-1-git-send-email-martin@rogsta.net>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup of a few brace coding style issues.

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
 drivers/staging/vt6655/80211mgr.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 76c8490..7949d58 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -165,9 +165,8 @@ vMgrDecodeBeacon(
 			break;
 
 		case WLAN_EID_RSN:
-			if (pFrame->pRSN == NULL) {
+			if (pFrame->pRSN == NULL)
 				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-			}
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
@@ -382,9 +381,8 @@ vMgrDecodeAssocRequest(
 			break;
 
 		case WLAN_EID_RSN:
-			if (pFrame->pRSN == NULL) {
+			if (pFrame->pRSN == NULL)
 				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-			}
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
@@ -556,9 +554,8 @@ vMgrDecodeReassocRequest(
 			break;
 
 		case WLAN_EID_RSN:
-			if (pFrame->pRSN == NULL) {
+			if (pFrame->pRSN == NULL)
 				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-			}
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
@@ -742,9 +739,8 @@ vMgrDecodeProbeResponse(
 			break;
 
 		case WLAN_EID_RSN:
-			if (pFrame->pRSN == NULL) {
+			if (pFrame->pRSN == NULL)
 				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-			}
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
@@ -858,9 +854,9 @@ vMgrDecodeAuthen(
 	pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
 			   + WLAN_AUTHEN_OFF_CHALLENGE);
 
-	if ((((unsigned char *)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_CHALLENGE)) {
+	if (((unsigned char *)pItem) < (pFrame->pBuf + pFrame->len) &&
+	    pItem->byElementID == WLAN_EID_CHALLENGE)
 		pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
-	}
 
 	return;
 }
-- 
1.8.4

