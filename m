Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaE2Etf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:49:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42985 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaE2Etc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:49:32 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 3/5] Staging: rtl8192u: r8192U_wx.c Removed C99 comments
Date: Wed, 28 May 2014 21:49:19 -0700
Message-Id: <1401338961-27412-3-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401338961-27412-1-git-send-email-c@24.io>
References: <1401338961-27412-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To address the error -

ERROR: do not use C99 // comments

Removed all C99 comments.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 130 +++++++++++++++++------------------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 7dc2a96..b533784 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -180,8 +180,8 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
 	      priv->crcmon ? "accepted" : "rejected");
 
 	if (prev != priv->crcmon && priv->up) {
-		//rtl8180_down(dev);
-		//rtl8180_up(dev);
+		/* rtl8180_down(dev); */
+		/* rtl8180_up(dev); */
 	}
 
 	up(&priv->wx_sem);
@@ -249,15 +249,15 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	/* ~5 Mb/s real (802.11b) */
 	range->throughput = 5 * 1000 * 1000;
 
-	// TODO: Not used in 802.11b?
-//	range->min_nwid;	/* Minimal NWID we are able to set */
-	// TODO: Not used in 802.11b?
-//	range->max_nwid;	/* Maximal NWID we are able to set */
+	/* TODO: Not used in 802.11b? */
+	/* range->min_nwid; */	/* Minimal NWID we are able to set */
+	/* TODO: Not used in 802.11b? */
+	/* range->max_nwid; */	/* Maximal NWID we are able to set */
 
 	/* Old Frequency (backward compat - moved lower ) */
-//	range->old_num_channels;
-//	range->old_num_frequency;
-//	range->old_freq[6]; /* Filler to keep "version" at the same offset */
+	/* range->old_num_channels; */
+	/* range->old_num_frequency; */
+	/* range->old_freq[6]; */ /* Filler to keep "version" at the same offset */
 	if (priv->rf_set_sens != NULL)
 		range->sensitivity = priv->max_sens;	/* signal level threshold range */
 
@@ -292,26 +292,26 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 16;
 
-//	range->retry_capa;	/* What retry options are supported */
-//	range->retry_flags;	/* How to decode max/min retry limit */
-//	range->r_time_flags;	/* How to decode max/min retry life */
-//	range->min_retry;	/* Minimal number of retries */
-//	range->max_retry;	/* Maximal number of retries */
-//	range->min_r_time;	/* Minimal retry lifetime */
-//	range->max_r_time;	/* Maximal retry lifetime */
+	/* range->retry_capa; */	/* What retry options are supported */
+	/* range->retry_flags; */	/* How to decode max/min retry limit */
+	/* range->r_time_flags; */	/* How to decode max/min retry life */
+	/* range->min_retry; */ 	/* Minimal number of retries */
+	/* range->max_retry; */		/* Maximal number of retries */
+	/* range->min_r_time; */	/* Minimal retry lifetime */
+	/* range->max_r_time; */	/* Maximal retry lifetime */
 
 
 	for (i = 0, val = 0; i < 14; i++) {
 
-		// Include only legal frequencies for some countries
+		/* Include only legal frequencies for some countries */
 		if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
 			range->freq[val].i = i + 1;
 			range->freq[val].m = ieee80211_wlan_frequencies[i] * 100000;
 			range->freq[val].e = 1;
 			val++;
 		} else {
-			// FIXME: do we need to set anything for channels
-			// we don't use ?
+			/* FIXME: do we need to set anything for channels */
+			/* we don't use ? */
 		}
 
 		if (val == IW_MAX_FREQUENCIES)
@@ -478,7 +478,7 @@ static int r8192_wx_set_wap(struct net_device *dev,
 
 	int ret;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-//        struct sockaddr *temp = (struct sockaddr *)awrq;
+	/* struct sockaddr *temp = (struct sockaddr *)awrq; */
 	down(&priv->wx_sem);
 
 	ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
@@ -517,11 +517,11 @@ static int r8192_wx_set_enc(struct net_device *dev,
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret;
 
-	//u32 TargetContent;
+	/* u32 TargetContent; */
 	u32 hwkey[4] = {0, 0, 0, 0};
 	u8 mask = 0xff;
 	u32 key_idx = 0;
-	//u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff};
+	/* u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff}; */
 	u8 zero_addr[4][6] = {	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
 				{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
 				{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
@@ -540,7 +540,7 @@ static int r8192_wx_set_enc(struct net_device *dev,
 
 
 
-	//sometimes, the length is zero while we do not type key value
+	/* sometimes, the length is zero while we do not type key value */
 	if (wrqu->encoding.length != 0) {
 
 		for (i = 0; i < 4; i++) {
@@ -582,12 +582,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
 			EnableHWSecurityConfig8192(dev);
 
 			setKey(dev,
-				key_idx,                //EntryNo
-				key_idx,                //KeyIndex
-				KEY_TYPE_WEP40,         //KeyType
+				key_idx,                /* EntryNo */
+				key_idx,                /* KeyIndex */
+				KEY_TYPE_WEP40,         /* KeyType */
 				zero_addr[key_idx],
-				0,                      //DefaultKey
-				hwkey);                 //KeyContent
+				0,                      /* DefaultKey */
+				hwkey);                 /* KeyContent */
 
 		}
 
@@ -596,12 +596,12 @@ static int r8192_wx_set_enc(struct net_device *dev,
 				EnableHWSecurityConfig8192(dev);
 
 			setKey(dev,
-				key_idx,                //EntryNo
-				key_idx,                //KeyIndex
-				KEY_TYPE_WEP104,        //KeyType
+				key_idx,                /* EntryNo */
+				key_idx,                /* KeyIndex */
+				KEY_TYPE_WEP104,        /* KeyType */
 				zero_addr[key_idx],
-				0,                      //DefaultKey
-				hwkey);                 //KeyContent
+				0,                      /* DefaultKey */
+				hwkey);                 /* KeyContent */
 
 		} else {
 			printk("wrong type in WEP, not WEP40 and WEP104\n");
@@ -742,7 +742,7 @@ exit:
 	return err;
 }
 
-//hw security need to reorganized.
+/* hw security need to reorganized. */
 static int r8192_wx_set_enc_ext(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
@@ -763,10 +763,10 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		struct iw_point *encoding = &wrqu->encoding;
 		u8 idx = 0, alg = 0, group = 0;
 		if ((encoding->flags & IW_ENCODE_DISABLED) || ext->alg == IW_ENCODE_ALG_NONE)
-			//none is not allowed to use hwsec WB 2008.07.01
+			/* none is not allowed to use hwsec WB 2008.07.01 */
 			goto end_hw_sec;
 
-		// as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
+		/* as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4; */
 		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg;
 		idx = encoding->flags & IW_ENCODE_INDEX;
 		if (idx)
@@ -779,34 +779,34 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 			ieee->pairwise_key_type = alg;
 			EnableHWSecurityConfig8192(dev);
 		}
-		memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
+		memcpy((u8 *)key, ext->key, 16); /* we only get 16 bytes key.why? WB 2008.7.1 */
 
 		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2)) {
 
 			setKey(dev,
-					idx,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					zero, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
+					idx,	/* EntryNao */
+					idx,	/* KeyIndex */
+					alg,	/* KeyType */
+					zero,	/* MacAddr */
+					0,	/* DefaultKey */
+					key);	/* KeyContent */
 		} else if (group) {
 			ieee->group_key_type = alg;
 			setKey(dev,
-					idx,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					broadcast_addr, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
-		} else {//pairwise key
+					idx,	/* EntryNo */
+					idx,	/* KeyIndex */
+					alg,	/* KeyType */
+					broadcast_addr,	/* MacAddr */
+					0,		/* DefaultKey */
+					key);		/* KeyContent */
+		} else {	/* pairwise key */
 			setKey(dev,
-					4,//EntryNo
-					idx, //KeyIndex
-					alg,  //KeyType
-					(u8 *)ieee->ap_mac_addr, //MacAddr
-					0,              //DefaultKey
-					key);           //KeyContent
+					4,	/* EntryNo */
+					idx,	/* KeyIndex */
+					alg,	/* KeyType */
+					(u8 *)ieee->ap_mac_addr,/* MacAddr */
+					0,			/* DefaultKey */
+					key);           	/* KeyContent */
 		}
 
 
@@ -914,13 +914,13 @@ static iw_handler r8192_wx_handlers[] = {
 	r8192_wx_get_power,                    /* SIOCGIWPOWER */
 	NULL,			/*---hole---*/
 	NULL,			/*---hole---*/
-	r8192_wx_set_gen_ie,//NULL,			/* SIOCSIWGENIE */
+	r8192_wx_set_gen_ie, /* NULL, */		/* SIOCSIWGENIE */
 	NULL,			/* SIOCSIWGENIE */
 
-	r8192_wx_set_auth,//NULL,			/* SIOCSIWAUTH */
-	NULL,//r8192_wx_get_auth,//NULL,			/* SIOCSIWAUTH */
+	r8192_wx_set_auth,/* NULL, */			/* SIOCSIWAUTH */
+	NULL,/* r8192_wx_get_auth, */ /* NULL, */	/* SIOCSIWAUTH */
 	r8192_wx_set_enc_ext,			/* SIOCSIWENCODEEXT */
-	NULL,//r8192_wx_get_enc_ext,//NULL,			/* SIOCSIWENCODEEXT */
+	NULL,/* r8192_wx_get_enc_ext, *//* NULL, */			/* SIOCSIWENCODEEXT */
 	NULL,			/* SIOCSIWPMKSA */
 	NULL,			 /*---hole---*/
 
@@ -953,14 +953,14 @@ static const struct iw_priv_args r8192_private_args[] = {
 
 
 static iw_handler r8192_private_handler[] = {
-//	r8192_wx_set_monitor,  /* SIOCIWFIRSTPRIV */
+	/* r8192_wx_set_monitor, */ /* SIOCIWFIRSTPRIV */
 	r8192_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
-//	r8192_wx_set_forceassociate,
-//	r8192_wx_set_beaconinterval,
-//	r8192_wx_set_monitor_type,
+	/* r8192_wx_set_forceassociate, */
+	/* r8192_wx_set_beaconinterval, */
+	/* r8192_wx_set_monitor_type, */
 	r8192_wx_set_scan_type,
 	r8192_wx_set_rawtx,
-	//r8192_wx_null,
+	/* r8192_wx_null, */
 	r8192_wx_force_reset,
 };
 
-- 
1.9.1

