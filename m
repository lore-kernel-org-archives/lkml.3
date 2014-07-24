Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbaGXSzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:55:40 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45515 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270AbaGXSzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:55:38 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: remove redundant comments from card.h
Date: Thu, 24 Jul 2014 21:50:14 +0300
Message-Id: <1406227814-12404-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from card.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/80211hdr.h |    7 -------
 drivers/staging/vt6655/80211mgr.h |   38 -------------------------------------
 drivers/staging/vt6655/aes_ccmp.h |    9 ---------
 drivers/staging/vt6655/baseband.h |   12 ------------
 drivers/staging/vt6655/bssdb.h    |   25 ++----------------------
 drivers/staging/vt6655/card.h     |   10 +---------
 6 files changed, 3 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index ba155cd..e05d135 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -33,7 +33,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
 /* bit type */
 #define BIT0	0x00000001
 #define BIT1	0x00000002
@@ -315,10 +314,4 @@ typedef union tagUWLAN_80211HDR {
 	WLAN_80211HDR_A4        sA4;
 } UWLAN_80211HDR, *PUWLAN_80211HDR;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 #endif /* __80211HDR_H__ */
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
diff --git a/drivers/staging/vt6655/aes_ccmp.h b/drivers/staging/vt6655/aes_ccmp.h
index cc02e64..fe0c506 100644
--- a/drivers/staging/vt6655/aes_ccmp.h
+++ b/drivers/staging/vt6655/aes_ccmp.h
@@ -32,15 +32,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 bool AESbGenCCMP(unsigned char *pbyRxKey, unsigned char *pbyFrame, unsigned short wFrameSize);
 
 #endif /* __AES_H__ */
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index e31bb76..d90c7f9 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -34,8 +34,6 @@
 #include "tether.h"
 #include "device.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 //
 // Registers in the BASEBAND
 //
@@ -64,22 +62,12 @@
 #define TOP_RATE_2M         0x00200000
 #define TOP_RATE_1M         0x00100000
 
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Macros ------------------------------*/
-
 #define BBvClearFOE(dwIoBase)				\
 	BBbWriteEmbedded(dwIoBase, 0xB1, 0)
 
 #define BBvSetFOE(dwIoBase)				\
 	BBbWriteEmbedded(dwIoBase, 0xB1, 0x0C)
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 unsigned int
 BBuGetFrameTime(
 	unsigned char byPreambleType,
diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index a0938b7..9337afe 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -35,8 +35,6 @@
 #include "80211mgr.h"
 #include "card.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define MAX_NODE_NUM             64
 #define MAX_BSS_NUM              42
 #define LOST_BEACON_COUNT        10   // 10 sec, XP defined
@@ -67,12 +65,6 @@
 
 #define MAX_WPA_IE_LEN      64
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
 //
 // IEEE 802.11 Structures and definitions
 //
@@ -99,7 +91,6 @@ typedef struct tagSRSNCapObject {
 // BSS info(AP)
 #pragma pack(1)
 typedef struct tagKnownBSS {
-	// BSS info
 	bool bActive;
 	unsigned char abyBSSID[WLAN_BSSID_LEN];
 	unsigned int	uChannel;
@@ -116,10 +107,8 @@ typedef struct tagKnownBSS {
 	long            ldBmMAX;
 	long            ldBmAverage[RSSI_STAT_COUNT];
 	long            ldBmAverRange;
-	//For any BSSID selection improvment
 	bool bSelected;
 
-	//++ WPA informations
 	bool bWPAValid;
 	unsigned char byGKType;
 	unsigned char abyPKType[4];
@@ -128,9 +117,7 @@ typedef struct tagKnownBSS {
 	unsigned short wAuthCount;
 	unsigned char byDefaultK_as_PK;
 	unsigned char byReplayIdx;
-	//--
 
-	//++ WPA2 informations
 	bool bWPA2Valid;
 	unsigned char byCSSGK;
 	unsigned short wCSSPKCount;
@@ -138,28 +125,24 @@ typedef struct tagKnownBSS {
 	unsigned short wAKMSSAuthCount;
 	unsigned char abyAKMSSAuthType[4];
 
-	//++  wpactl
 	unsigned char byWPAIE[MAX_WPA_IE_LEN];
 	unsigned char byRSNIE[MAX_WPA_IE_LEN];
 	unsigned short wWPALen;
 	unsigned short wRSNLen;
 
-	// Clear count
 	unsigned int	uClearCount;
 	unsigned int	uIELength;
 	QWORD           qwBSSTimestamp;
-	QWORD           qwLocalTSF;     // local TSF timer
+	QWORD           qwLocalTSF;
 
-//    NDIS_802_11_NETWORK_TYPE    NetworkTypeInUse;
 	CARD_PHY_TYPE   eNetworkTypeInUse;
 
 	ERPObject       sERP;
 	SRSNCapObject   sRSNCapObj;
-	unsigned char abyIEs[1024];   // don't move this field !!
+	unsigned char abyIEs[1024];
 } __attribute__ ((__packed__))
 KnownBSS , *PKnownBSS;
 
-//2006-1116-01,<Add> by NomadZhao
 #pragma pack()
 
 typedef enum tagNODE_STATE {
@@ -172,7 +155,6 @@ typedef enum tagNODE_STATE {
 
 // STA node info
 typedef struct tagKnownNodeDB {
-	// STA info
 	bool bActive;
 	unsigned char abyMACAddr[WLAN_ADDR_LEN];
 	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
@@ -211,7 +193,6 @@ typedef struct tagKnownNodeDB {
 	unsigned short wTSC15_0;
 	unsigned int	uWepKeyLength;
 	unsigned char abyWepKey[WLAN_WEPMAX_KEYLEN];
-	//
 	// Auto rate fallback vars
 	bool bIsInFallback;
 	unsigned int	uAverageRSSI;
@@ -228,8 +209,6 @@ typedef struct tagKnownNodeDB {
 	unsigned int	uTimeCount;
 } KnownNodeDB, *PKnownNodeDB;
 
-/*---------------------  Export Functions  --------------------------*/
-
 PKnownBSS
 BSSpSearchBSSList(
 	void *hDeviceContext,
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 829be92..443461d 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -32,7 +32,6 @@
 #include "ttype.h"
 #include <linux/types.h>
 
-/*---------------------  Export Definitions -------------------------*/
 //
 // Loopback mode
 //
@@ -48,7 +47,7 @@
 #define DEFAULT_MGN_LIFETIME_RES_64us   125  // 64us
 
 #define CB_MAX_CHANNEL_24G      14
-#define CB_MAX_CHANNEL_5G       42 //[20050104] add channel9(5045MHz), 41==>42
+#define CB_MAX_CHANNEL_5G       42
 #define CB_MAX_CHANNEL          (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
 
 typedef enum _CARD_PHY_TYPE {
@@ -78,12 +77,6 @@ typedef enum _CARD_OP_MODE {
 	OP_MODE_UNKNOWN
 } CARD_OP_MODE, *PCARD_OP_MODE;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void CARDvSetRSPINF(void *pDeviceHandler, CARD_PHY_TYPE ePHYType);
 void vUpdateIFS(void *pDeviceHandler);
 void CARDvUpdateBasicTopRate(void *pDeviceHandler);
@@ -101,7 +94,6 @@ unsigned char CARDbyGetPktType(void *pDeviceHandler);
 void CARDvSafeResetTx(void *pDeviceHandler);
 void CARDvSafeResetRx(void *pDeviceHandler);
 
-//xxx
 bool CARDbRadioPowerOff(void *pDeviceHandler);
 bool CARDbRadioPowerOn(void *pDeviceHandler);
 bool CARDbIsShortPreamble(void *pDeviceHandler);
-- 
1.7.9.5

