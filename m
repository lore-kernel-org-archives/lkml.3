Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaGVMgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:36:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56946 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaGVMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:36:22 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: Removed redundant comments and newlines
Date: Tue, 22 Jul 2014 15:36:10 +0300
Message-Id: <1406032571-19626-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments and newlines from 80211mgr.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/80211mgr.h |   38 -------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 065238b..8b126bb 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -34,8 +34,6 @@
 #include "ttype.h"
 #include "80211hdr.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define WLAN_MIN_ARRAY          1
 
 /* Information Element ID value */
@@ -202,12 +200,6 @@
 #define MEASURE_MODE_INCAPABLE  0x02
 #define MEASURE_MODE_REFUSED    0x04
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
 /* Information Element Types */
 
 #pragma pack(1)
@@ -472,14 +464,11 @@ typedef struct tagWLAN_FR_BEACON {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/* fixed fields */
 	PQWORD                  pqwTimestamp;
 	unsigned short *pwBeaconInterval;
 	unsigned short *pwCapInfo;
-	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
 	PWLAN_IE_SUPP_RATES     pSuppRates;
-/*  PWLAN_IE_FH_PARMS       pFHParms; */
 	PWLAN_IE_DS_PARMS       pDSParms;
 	PWLAN_IE_CF_PARMS       pCFParms;
 	PWLAN_IE_TIM            pTIM;
@@ -501,10 +490,6 @@ typedef struct tagWLAN_FR_IBSSATIM {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-
-	/* fixed fields */
-	/* info elements */
-	/* this frame type has a null body */
 } WLAN_FR_IBSSATIM, *PWLAN_FR_IBSSATIM;
 
 /* Disassociation */
@@ -513,9 +498,7 @@ typedef struct tagWLAN_FR_DISASSOC {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwReason;
-	/*-- info elements ----------*/
 } WLAN_FR_DISASSOC, *PWLAN_FR_DISASSOC;
 
 /* Association Request */
@@ -524,10 +507,8 @@ typedef struct tagWLAN_FR_ASSOCREQ {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwListenInterval;
-	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_RSN            pRSN;
@@ -543,11 +524,9 @@ typedef struct tagWLAN_FR_ASSOCRESP {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwStatus;
 	unsigned short *pwAid;
-	/*-- info elements ----------*/
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_SUPP_RATES     pExtSuppRates;
 } WLAN_FR_ASSOCRESP, *PWLAN_FR_ASSOCRESP;
@@ -558,13 +537,9 @@ typedef struct tagWLAN_FR_REASSOCREQ {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-
-	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwListenInterval;
 	PIEEE_ADDR              pAddrCurrAP;
-
-	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_RSN            pRSN;
@@ -578,11 +553,9 @@ typedef struct tagWLAN_FR_REASSOCRESP {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwCapInfo;
 	unsigned short *pwStatus;
 	unsigned short *pwAid;
-	/*-- info elements ----------*/
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_SUPP_RATES     pExtSuppRates;
 } WLAN_FR_REASSOCRESP, *PWLAN_FR_REASSOCRESP;
@@ -593,8 +566,6 @@ typedef struct tagWLAN_FR_PROBEREQ {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
-	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_SUPP_RATES     pExtSuppRates;
@@ -606,11 +577,9 @@ typedef struct tagWLAN_FR_PROBERESP {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	PQWORD                  pqwTimestamp;
 	unsigned short *pwBeaconInterval;
 	unsigned short *pwCapInfo;
-	/*-- info elements ----------*/
 	PWLAN_IE_SSID           pSSID;
 	PWLAN_IE_SUPP_RATES     pSuppRates;
 	PWLAN_IE_DS_PARMS       pDSParms;
@@ -633,11 +602,9 @@ typedef struct tagWLAN_FR_AUTHEN {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwAuthAlgorithm;
 	unsigned short *pwAuthSequence;
 	unsigned short *pwStatus;
-	/*-- info elements ----------*/
 	PWLAN_IE_CHALLENGE      pChallenge;
 } WLAN_FR_AUTHEN, *PWLAN_FR_AUTHEN;
 
@@ -647,14 +614,9 @@ typedef struct tagWLAN_FR_DEAUTHEN {
 	unsigned int	len;
 	unsigned char *pBuf;
 	PUWLAN_80211HDR         pHdr;
-	/*-- fixed fields -----------*/
 	unsigned short *pwReason;
-
-	/*-- info elements ----------*/
 } WLAN_FR_DEAUTHEN, *PWLAN_FR_DEAUTHEN;
 
-/*---------------------  Export Functions  --------------------------*/
-
 void
 vMgrEncodeBeacon(
 	PWLAN_FR_BEACON  pFrame
-- 
1.7.9.5

