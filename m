Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934947AbaGXXHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:07:10 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35124 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 05/14] staging: vt6655: fix braces at newline for structs
Date: Fri, 25 Jul 2014 01:06:19 +0200
Message-Id: <1406243188-13413-6-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For structs definitions, the braces should be at the end of the
line. Reported by checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/bssdb.h  |  3 +--
 drivers/staging/vt6655/device.h | 15 +++++----------
 drivers/staging/vt6655/key.h    |  9 +++------
 drivers/staging/vt6655/wmgr.h   | 12 ++++--------
 4 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index a0938b7..0dbb2ca 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -77,8 +77,7 @@
 // IEEE 802.11 Structures and definitions
 //
 
-typedef enum _NDIS_802_11_NETWORK_TYPE
-{
+typedef enum _NDIS_802_11_NETWORK_TYPE {
 	Ndis802_11FH,
 	Ndis802_11DS,
 	Ndis802_11OFDM5,
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index f33ecf0..7c7fec4 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -201,8 +201,7 @@ typedef enum __device_init_type {
 // PMKID Structures
 typedef unsigned char NDIS_802_11_PMKID_VALUE[16];
 
-typedef enum _NDIS_802_11_WEP_STATUS
-{
+typedef enum _NDIS_802_11_WEP_STATUS {
 	Ndis802_11WEPEnabled,
 	Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
 	Ndis802_11WEPDisabled,
@@ -218,8 +217,7 @@ typedef enum _NDIS_802_11_WEP_STATUS
 } NDIS_802_11_WEP_STATUS, *PNDIS_802_11_WEP_STATUS,
 	NDIS_802_11_ENCRYPTION_STATUS, *PNDIS_802_11_ENCRYPTION_STATUS;
 
-typedef enum _NDIS_802_11_STATUS_TYPE
-{
+typedef enum _NDIS_802_11_STATUS_TYPE {
 	Ndis802_11StatusType_Authentication,
 	Ndis802_11StatusType_MediaStreamMode,
 	Ndis802_11StatusType_PMKID_CandidateList,
@@ -232,8 +230,7 @@ struct pmkid_candidate {
 	unsigned long Flags;
 };
 
-typedef struct _BSSID_INFO
-{
+typedef struct _BSSID_INFO {
 	NDIS_802_11_MAC_ADDRESS BSSID;
 	NDIS_802_11_PMKID_VALUE PMKID;
 } BSSID_INFO, *PBSSID_INFO;
@@ -293,8 +290,7 @@ typedef struct tagSCache {
 
 #define CB_MAX_RX_FRAG                 64
 // DeFragment Control Block, used for collecting fragments prior to reassembly
-typedef struct tagSDeFragControlBlock
-{
+typedef struct tagSDeFragControlBlock {
 	unsigned short wSequence;
 	unsigned short wFragNum;
 	unsigned char abyAddr2[ETH_ALEN];
@@ -334,8 +330,7 @@ typedef struct tagSDeFragControlBlock
 
 //PLICE_DEBUG->
 
-typedef	struct _RxManagementQueue
-{
+typedef	struct _RxManagementQueue {
 	int	packet_num;
 	int	head, tail;
 	PSRxMgmtPacket	Q[NUM];
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 4eee192..3eb881b 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -53,8 +53,7 @@
 #define KEY_CTL_CCMP        0x03
 #define KEY_CTL_INVALID     0xFF
 
-typedef struct tagSKeyItem
-{
+typedef struct tagSKeyItem {
 	bool bKeyValid;
 	unsigned long uKeyLength;
 	unsigned char abyKey[MAX_KEY_LEN];
@@ -67,8 +66,7 @@ typedef struct tagSKeyItem
 	void *pvKeyTable;
 } SKeyItem, *PSKeyItem; //64
 
-typedef struct tagSKeyTable
-{
+typedef struct tagSKeyTable {
 	unsigned char abyBSSID[ETH_ALEN];  //6
 	unsigned char byReserved0[2];              //8
 	SKeyItem    PairwiseKey;
@@ -82,8 +80,7 @@ typedef struct tagSKeyTable
 	unsigned char byReserved1[6];
 } SKeyTable, *PSKeyTable; //348
 
-typedef struct tagSKeyManagement
-{
+typedef struct tagSKeyManagement {
 	SKeyTable   KeyTable[MAX_KEY_TABLE];
 } SKeyManagement, *PSKeyManagement;
 
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 2312d71..a71daed 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -83,22 +83,19 @@ typedef void (*TimerFunction)(unsigned long);
 //+++ NDIS related
 
 typedef unsigned char NDIS_802_11_MAC_ADDRESS[6];
-typedef struct _NDIS_802_11_AI_REQFI
-{
+typedef struct _NDIS_802_11_AI_REQFI {
 	unsigned short Capabilities;
 	unsigned short ListenInterval;
 	NDIS_802_11_MAC_ADDRESS  CurrentAPAddress;
 } NDIS_802_11_AI_REQFI, *PNDIS_802_11_AI_REQFI;
 
-typedef struct _NDIS_802_11_AI_RESFI
-{
+typedef struct _NDIS_802_11_AI_RESFI {
 	unsigned short Capabilities;
 	unsigned short StatusCode;
 	unsigned short AssociationId;
 } NDIS_802_11_AI_RESFI, *PNDIS_802_11_AI_RESFI;
 
-typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION
-{
+typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION {
 	unsigned long Length;
 	unsigned short          AvailableRequestFixedIEs;
 	NDIS_802_11_AI_REQFI    RequestFixedIEs;
@@ -187,8 +184,7 @@ typedef struct tagSRxMgmtPacket {
 	unsigned char byRxChannel;
 } SRxMgmtPacket, *PSRxMgmtPacket;
 
-typedef struct tagSMgmtObject
-{
+typedef struct tagSMgmtObject {
 	void *pAdapter;
 	// MAC address
 	unsigned char abyMACAddr[WLAN_ADDR_LEN];
-- 
1.8.5.5

