Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaIDUiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:38:03 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:40023 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaIDUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:38:00 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, Ana Rey <anarey@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Chaitanya Hazarey <c@24.io>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8192u: Fix "space required before that '*'" errors
Date: Thu,  4 Sep 2014 15:37:41 -0500
Message-Id: <1409863061-15127-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space required before that '*'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h   | 6 +++---
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h  | 2 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h | 8 ++++----
 drivers/staging/rtl8192u/r8192U_hw.h             | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 125c5ab..3a96a9c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -1211,7 +1211,7 @@ typedef union _frameqos {
 		u16 reserved:1;
 		u16 txop:8;
 	}field;
-}frameqos,*pframeqos;
+} frameqos, *pframeqos;
 
 /* SWEEP TABLE ENTRIES NUMBER*/
 #define MAX_SWEEP_TAB_ENTRIES		  42
@@ -1648,7 +1648,7 @@ typedef struct _bandwidth_autoswitch {
 	long	threshold_40Mhzto20Mhz;
 	bool bforced_tx20Mhz;
 	bool bautoswitch_enable;
-}bandwidth_autoswitch,*pbandwidth_autoswitch;
+} bandwidth_autoswitch, *pbandwidth_autoswitch;
 
 
 //added by amy for order
@@ -1745,7 +1745,7 @@ typedef struct _RT_POWER_SAVE_CONTROL {
 	//
 	bool				bLeisurePs;
 
-}RT_POWER_SAVE_CONTROL,*PRT_POWER_SAVE_CONTROL;
+} RT_POWER_SAVE_CONTROL, *PRT_POWER_SAVE_CONTROL;
 
 typedef u32 RT_RF_CHANGE_SOURCE;
 #define RF_CHANGE_BY_SW BIT31
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
index 2b82835..c3aabba 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
@@ -53,7 +53,7 @@ typedef enum _HT_MCS_RATE{
 	HT_MCS14 = 0x00004000,
 	HT_MCS15 = 0x00008000,
 	// Do not define MCS32 here although 8190 support MCS32
-}HT_MCS_RATE,*PHT_MCS_RATE;
+} HT_MCS_RATE, *PHT_MCS_RATE;
 
 //
 // Represent Channel Width in HT Capabilities
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
index f2d52ca..9fbce91 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
@@ -66,7 +66,7 @@ typedef u32 QOS_MODE, *PQOS_MODE;
 typedef	enum _ACK_POLICY{
 	eAckPlc0_ACK		= 0x00,
 	eAckPlc1_NoACK		= 0x01,
-}ACK_POLICY,*PACK_POLICY;
+} ACK_POLICY, *PACK_POLICY;
 
 #define WMM_PARAM_ELEMENT_SIZE	(8+(4*AC_PARAM_SIZE))
 
@@ -276,7 +276,7 @@ typedef	union _AC_PARAM{
 typedef	enum _QOS_ELE_SUBTYPE{
 	QOSELE_TYPE_INFO	= 0x00,		// 0x00: Information element
 	QOSELE_TYPE_PARAM	= 0x01,		// 0x01: parameter element
-}QOS_ELE_SUBTYPE,*PQOS_ELE_SUBTYPE;
+} QOS_ELE_SUBTYPE, *PQOS_ELE_SUBTYPE;
 
 
 //
@@ -288,7 +288,7 @@ typedef	enum _DIRECTION_VALUE{
 	DIR_DOWN		= 1,		// 0x01	// DownLink
 	DIR_DIRECT		= 2,		// 0x10	// DirectLink
 	DIR_BI_DIR		= 3,		// 0x11	// Bi-Direction
-}DIRECTION_VALUE,*PDIRECTION_VALUE;
+} DIRECTION_VALUE, *PDIRECTION_VALUE;
 
 
 //
@@ -363,7 +363,7 @@ typedef	enum _ACM_METHOD{
 	eAcmWay0_SwAndHw		= 0,		// By SW and HW.
 	eAcmWay1_HW			= 1,		// By HW.
 	eAcmWay2_SW			= 2,		// By SW.
-}ACM_METHOD,*PACM_METHOD;
+} ACM_METHOD, *PACM_METHOD;
 
 
 typedef struct _ACM{
diff --git a/drivers/staging/rtl8192u/r8192U_hw.h b/drivers/staging/rtl8192u/r8192U_hw.h
index dd07a73..a93694f 100644
--- a/drivers/staging/rtl8192u/r8192U_hw.h
+++ b/drivers/staging/rtl8192u/r8192U_hw.h
@@ -24,7 +24,7 @@ typedef enum _VERSION_819xU{
 	VERSION_819xU_A, // A-cut
 	VERSION_819xU_B, // B-cut
 	VERSION_819xU_C,// C-cut
-}VERSION_819xU,*PVERSION_819xU;
+} VERSION_819xU, *PVERSION_819xU;
 //added for different RF type
 typedef enum _RT_RF_TYPE_DEF
 {
-- 
1.9.1

