Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaJCPjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:39:23 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:49032 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaJCPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:36:48 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "open brace '{' following struct go on the same line" errors
Date: Fri,  3 Oct 2014 10:36:40 -0500
Message-Id: <1412350600-30224-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "open brace '{' following struct go on the same line" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c     | 3 +--
 drivers/staging/rtl8723au/include/rtl8723a_dm.h   | 3 +--
 drivers/staging/rtl8723au/include/rtl8723a_recv.h | 3 +--
 drivers/staging/rtl8723au/include/rtw_cmd.h       | 3 +--
 drivers/staging/rtl8723au/include/rtw_ht.h        | 3 +--
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h  | 6 ++----
 6 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 76371ae..c4c7326 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -23,8 +23,7 @@
 
 #define CRC32_POLY 0x04c11db7
 
-struct arc4context
-{
+struct arc4context {
 	u32 x;
 	u32 y;
 	u8 state[256];
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_dm.h b/drivers/staging/rtl8723au/include/rtl8723a_dm.h
index 1811222..bf236e8 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_dm.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_dm.h
@@ -37,8 +37,7 @@ enum{
 #define IQK_BB_REG_NUM			9
 #define HP_THERMAL_NUM		8
 /*  duplicate code,will move to ODM ######### */
-struct dm_priv
-{
+struct dm_priv {
 	u32	InitODMFlag;
 
 	/*  Upper and Lower Signal threshold for Rate Adaptive*/
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_recv.h b/drivers/staging/rtl8723au/include/rtl8723a_recv.h
index 885d4d3..0109052 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_recv.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_recv.h
@@ -35,8 +35,7 @@
 #define PHY_LINKQUALITY_SLID_WIN_MAX	20
 
 
-struct phy_stat
-{
+struct phy_stat {
 	unsigned int phydw0;
 	unsigned int phydw1;
 	unsigned int phydw2;
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index ef67068..8ffe5de 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -450,8 +450,7 @@ struct getrfintfs_parm {
 	u8	rfintfs;
 };
 
-struct Tx_Beacon_param
-{
+struct Tx_Beacon_param {
 	struct wlan_bssid_ex network;
 };
 
diff --git a/drivers/staging/rtl8723au/include/rtw_ht.h b/drivers/staging/rtl8723au/include/rtw_ht.h
index cfc947d..780eb89 100644
--- a/drivers/staging/rtl8723au/include/rtw_ht.h
+++ b/drivers/staging/rtl8723au/include/rtw_ht.h
@@ -19,8 +19,7 @@
 #include "linux/ieee80211.h"
 #include "wifi.h"
 
-struct ht_priv
-{
+struct ht_priv {
 	bool	ht_option;
 	bool	ampdu_enable;/* for enable Tx A-MPDU */
 	/* u8	baddbareq_issued[16]; */
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index 97c3c44..51dba1f 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -270,8 +270,7 @@ struct action_handler {
 	int (*func)(struct rtw_adapter *padapter, struct recv_frame *precv_frame);
 };
 
-struct	ss_res
-{
+struct	ss_res {
 	int	state;
 	int	bss_cnt;
 	int	channel_idx;
@@ -318,8 +317,7 @@ struct FW_Sta_Info {
  * 5. ... and so on, till survey done.
  */
 
-struct mlme_ext_info
-{
+struct mlme_ext_info {
 	u32	state;
 	u32	reauth_count;
 	u32	reassoc_count;
-- 
1.9.1

