Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaFBQNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:13:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33690 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaFBQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:11:53 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 4/4] Staging: rtl8192u: r8192U_wx.c Removed some more commented out dead code
Date: Mon,  2 Jun 2014 09:11:45 -0700
Message-Id: <1401725505-3459-4-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401725505-3459-1-git-send-email-c@24.io>
References: <1401725505-3459-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed dead code from the file.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 09b1e81..ceb06d8 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -516,12 +516,9 @@ static int r8192_wx_set_enc(struct net_device *dev,
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret;
-
-	/* u32 TargetContent; */
 	u32 hwkey[4] = {0, 0, 0, 0};
 	u8 mask = 0xff;
 	u32 key_idx = 0;
-	/* u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff}; */
 	u8 zero_addr[4][6] = {	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
 				{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
 				{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
@@ -667,14 +664,6 @@ static int r8192_wx_set_retry(struct net_device *dev,
 	 */
 
 	rtl8192_commit(dev);
-	/*
-	if(priv->up){
-		rtl8180_rtx_disable(dev);
-		rtl8180_rx_enable(dev);
-		rtl8180_tx_enable(dev);
-
-	}
-	*/
 exit:
 	up(&priv->wx_sem);
 
@@ -953,14 +942,9 @@ static const struct iw_priv_args r8192_private_args[] = {
 
 
 static iw_handler r8192_private_handler[] = {
-	/* r8192_wx_set_monitor, */ /* SIOCIWFIRSTPRIV */
-	r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
-	/* r8192_wx_set_forceassociate, */
-	/* r8192_wx_set_beaconinterval, */
-	/* r8192_wx_set_monitor_type, */
+	r8192_wx_set_crcmon, 
 	r8192_wx_set_scan_type,
 	r8192_wx_set_rawtx,
-	/* r8192_wx_null, */
 	r8192_wx_force_reset,
 };
 
-- 
1.9.1

