Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaE1Oc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:32:26 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:46989 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaE1OcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:32:24 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        andrea.merello@gmail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 1/2] Staging: rtl8192u: r8192U_wx.c Added missing spaces
Date: Wed, 28 May 2014 07:32:38 -0700
Message-Id: <1401287559-7692-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added spaces needed in the proper places to address:

WARNING: please, no spaces at the start of a line
WARNING: missing space after struct definition
ERROR: spaces required around that '!=' (ctx:WxV)
ERROR: spaces required around that '=' (ctx:WxV)
ERROR: spaces required around that '=' (ctx:VxW)
ERROR: spaces required around that '&&' (ctx:VxV)
ERROR: spaces required around that '!=' (ctx:VxV)
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: space required before the open parenthesis '('
ERROR: space required before the open brace '{'
ERROR: space required after that ',' (ctx:VxV)
ERROR: space required after that close brace '}'
ERROR: space prohibited before that '--' (ctx:WxO)
ERROR: space prohibited before that close parenthesis ')'
ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 146 +++++++++++++++++------------------
 1 file changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index dab716f..1ba03ad 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -24,8 +24,8 @@
 #include "dot11d.h"
 
 #define RATE_COUNT 12
-u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
-	6000000,9000000,12000000,18000000,24000000,36000000,48000000,54000000};
+u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
+	6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 54000000};
 
 
 #ifndef ENETDOWN
@@ -38,16 +38,16 @@ static int r8192_wx_get_freq(struct net_device *dev,
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	return ieee80211_wx_get_freq(priv->ieee80211,a,wrqu,b);
+	return ieee80211_wx_get_freq(priv->ieee80211, a, wrqu, b);
 }
 
 
 static int r8192_wx_get_mode(struct net_device *dev, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
-	struct r8192_priv *priv=ieee80211_priv(dev);
+	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	return ieee80211_wx_get_mode(priv->ieee80211,a,wrqu,b);
+	return ieee80211_wx_get_mode(priv->ieee80211, a, wrqu, b);
 }
 
 
@@ -57,7 +57,7 @@ static int r8192_wx_get_rate(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_rate(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_rate(priv->ieee80211, info, wrqu, extra);
 }
 
 
@@ -71,7 +71,7 @@ static int r8192_wx_set_rate(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_rate(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_rate(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -88,7 +88,7 @@ static int r8192_wx_set_rts(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_rts(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_rts(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -100,7 +100,7 @@ static int r8192_wx_get_rts(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_rts(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_rts(priv->ieee80211, info, wrqu, extra);
 }
 
 static int r8192_wx_set_power(struct net_device *dev,
@@ -112,7 +112,7 @@ static int r8192_wx_set_power(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_power(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_power(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -124,7 +124,7 @@ static int r8192_wx_get_power(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_power(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_power(priv->ieee80211, info, wrqu, extra);
 }
 
 static int r8192_wx_force_reset(struct net_device *dev,
@@ -135,7 +135,7 @@ static int r8192_wx_force_reset(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	printk("%s(): force reset ! extra is %d\n",__func__, *extra);
+	printk("%s(): force reset ! extra is %d\n", __func__, *extra);
 	priv->force_reset = *extra;
 	up(&priv->wx_sem);
 	return 0;
@@ -171,15 +171,15 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	if(enable)
-		priv->crcmon=1;
+	if (enable)
+		priv->crcmon = 1;
 	else
-		priv->crcmon=0;
+		priv->crcmon = 0;
 
 	DMESG("bad CRC in monitor mode are %s",
 	      priv->crcmon ? "accepted" : "rejected");
 
-	if(prev != priv->crcmon && priv->up){
+	if (prev != priv->crcmon && priv->up) {
 		//rtl8180_down(dev);
 		//rtl8180_up(dev);
 	}
@@ -196,7 +196,7 @@ static int r8192_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 	int ret;
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_mode(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
 
 	rtl8192_set_rxconf(dev);
 
@@ -258,7 +258,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 //	range->old_num_channels;
 //	range->old_num_frequency;
 //	range->old_freq[6]; /* Filler to keep "version" at the same offset */
-	if(priv->rf_set_sens != NULL)
+	if (priv->rf_set_sens != NULL)
 		range->sensitivity = priv->max_sens;	/* signal level threshold range */
 
 	range->max_qual.qual = 100;
@@ -281,7 +281,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->min_frag = MIN_FRAG_THRESHOLD;
 	range->max_frag = MAX_FRAG_THRESHOLD;
 
-	range->min_pmp=0;
+	range->min_pmp = 0;
 	range->max_pmp = 5000000;
 	range->min_pmt = 0;
 	range->max_pmt = 65535*1000;
@@ -333,7 +333,7 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret = 0;
 
-	if(!priv->up) return -ENETDOWN;
+	if (!priv->up) return -ENETDOWN;
 
 	if (priv->ieee80211->LinkDetectInfo.bBusyTraffic == true)
 		return -EAGAIN;
@@ -350,13 +350,13 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	}
 
 	down(&priv->wx_sem);
-	if(priv->ieee80211->state != IEEE80211_LINKED){
+	if (priv->ieee80211->state != IEEE80211_LINKED) {
 		priv->ieee80211->scanning = 0;
 		ieee80211_softmac_scan_syncro(priv->ieee80211);
 		ret = 0;
 	}
 	else
-	ret = ieee80211_wx_set_scan(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 	up(&priv->wx_sem);
 	return ret;
 }
@@ -369,11 +369,11 @@ static int r8192_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	int ret;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if(!priv->up) return -ENETDOWN;
+	if (!priv->up) return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_get_scan(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_get_scan(priv->ieee80211, a, wrqu, b);
 
 	up(&priv->wx_sem);
 
@@ -388,7 +388,7 @@ static int r8192_wx_set_essid(struct net_device *dev,
 	int ret;
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_essid(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
 
 	up(&priv->wx_sem);
 
@@ -483,7 +483,7 @@ static int r8192_wx_set_wap(struct net_device *dev,
 //        struct sockaddr *temp = (struct sockaddr *)awrq;
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_wap(priv->ieee80211,info,awrq,extra);
+	ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
 
 	up(&priv->wx_sem);
 
@@ -498,7 +498,7 @@ static int r8192_wx_get_wap(struct net_device *dev,
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	return ieee80211_wx_get_wap(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_wap(priv->ieee80211, info, wrqu, extra);
 }
 
 
@@ -520,34 +520,34 @@ static int r8192_wx_set_enc(struct net_device *dev,
 	int ret;
 
 	//u32 TargetContent;
-	u32 hwkey[4]={0,0,0,0};
-	u8 mask=0xff;
-	u32 key_idx=0;
+	u32 hwkey[4] = {0, 0, 0, 0};
+	u8 mask = 0xff;
+	u32 key_idx = 0;
 	//u8 broadcast_addr[6] ={	0xff,0xff,0xff,0xff,0xff,0xff};
-	u8 zero_addr[4][6] ={	{0x00,0x00,0x00,0x00,0x00,0x00},
-				{0x00,0x00,0x00,0x00,0x00,0x01},
-				{0x00,0x00,0x00,0x00,0x00,0x02},
-				{0x00,0x00,0x00,0x00,0x00,0x03} };
+	u8 zero_addr[4][6] = {	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x01},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
+				{0x00, 0x00, 0x00, 0x00, 0x00, 0x03} };
 	int i;
 
-       if(!priv->up) return -ENETDOWN;
+	if (!priv->up) return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
 	RT_TRACE(COMP_SEC, "Setting SW wep key");
-	ret = ieee80211_wx_set_encode(priv->ieee80211,info,wrqu,key);
+	ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
 
 	up(&priv->wx_sem);
 
 
 
 	//sometimes, the length is zero while we do not type key value
-	if(wrqu->encoding.length!=0){
+	if (wrqu->encoding.length != 0) {
 
-		for(i=0 ; i<4 ; i++){
+		for (i = 0; i < 4; i++) {
 			hwkey[i] |=  key[4*i+0]&mask;
-			if(i==1&&(4*i+1)==wrqu->encoding.length) mask=0x00;
-			if(i==3&&(4*i+1)==wrqu->encoding.length) mask=0x00;
+			if (i == 1 && (4*i+1) == wrqu->encoding.length) mask = 0x00;
+			if (i == 3 && (4*i+1) == wrqu->encoding.length) mask = 0x00;
 			hwkey[i] |= (key[4*i+1]&mask)<<8;
 			hwkey[i] |= (key[4*i+2]&mask)<<16;
 			hwkey[i] |= (key[4*i+3]&mask)<<24;
@@ -556,7 +556,7 @@ static int r8192_wx_set_enc(struct net_device *dev,
 		#define CONF_WEP40  0x4
 		#define CONF_WEP104 0x14
 
-		switch (wrqu->encoding.flags & IW_ENCODE_INDEX){
+		switch (wrqu->encoding.flags & IW_ENCODE_INDEX) {
 		case 0: key_idx = ieee->tx_keyidx; break;
 		case 1:	key_idx = 0; break;
 		case 2:	key_idx = 1; break;
@@ -565,11 +565,11 @@ static int r8192_wx_set_enc(struct net_device *dev,
 		default: break;
 		}
 
-		if(wrqu->encoding.length==0x5){
+		if (wrqu->encoding.length == 0x5) {
 				ieee->pairwise_key_type = KEY_TYPE_WEP40;
 			EnableHWSecurityConfig8192(dev);
 
-			setKey( dev,
+			setKey(dev,
 				key_idx,                //EntryNo
 				key_idx,                //KeyIndex
 				KEY_TYPE_WEP40,         //KeyType
@@ -579,11 +579,11 @@ static int r8192_wx_set_enc(struct net_device *dev,
 
 		}
 
-		else if(wrqu->encoding.length==0xd){
+		else if (wrqu->encoding.length == 0xd) {
 				ieee->pairwise_key_type = KEY_TYPE_WEP104;
 				EnableHWSecurityConfig8192(dev);
 
-			setKey( dev,
+			setKey(dev,
 				key_idx,                //EntryNo
 				key_idx,                //KeyIndex
 				KEY_TYPE_WEP104,        //KeyType
@@ -601,11 +601,11 @@ static int r8192_wx_set_enc(struct net_device *dev,
 
 
 static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
- iwreq_data *wrqu, char *p){
+					iwreq_data *wrqu, char *p){
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	int *parms=(int *)p;
-	int mode=parms[0];
+	int *parms = (int *)p;
+	int mode = parms[0];
 
 	priv->ieee80211->active_scan = mode;
 
@@ -628,20 +628,20 @@ static int r8192_wx_set_retry(struct net_device *dev,
 		err = -EINVAL;
 		goto exit;
 	}
-	if (!(wrqu->retry.flags & IW_RETRY_LIMIT)){
+	if (!(wrqu->retry.flags & IW_RETRY_LIMIT)) {
 		err = -EINVAL;
 		goto exit;
 	}
 
-	if(wrqu->retry.value > R8180_MAX_RETRY){
-		err= -EINVAL;
+	if (wrqu->retry.value > R8180_MAX_RETRY) {
+		err = -EINVAL;
 		goto exit;
 	}
 	if (wrqu->retry.flags & IW_RETRY_MAX) {
 		priv->retry_rts = wrqu->retry.value;
 		DMESG("Setting retry for RTS/CTS data to %d", wrqu->retry.value);
 
-	}else {
+	} else {
 		priv->retry_data = wrqu->retry.value;
 		DMESG("Setting retry for non RTS/CTS data to %d", wrqu->retry.value);
 	}
@@ -698,7 +698,7 @@ static int r8192_wx_get_sens(struct net_device *dev,
 				union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	if(priv->rf_set_sens == NULL)
+	if (priv->rf_set_sens == NULL)
 		return -1; /* we have not this support for this radio */
 	wrqu->sens.value = priv->sens;
 	return 0;
@@ -715,14 +715,14 @@ static int r8192_wx_set_sens(struct net_device *dev,
 	short err = 0;
 	down(&priv->wx_sem);
 	//DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
-	if(priv->rf_set_sens == NULL) {
-		err= -1; /* we have not this support for this radio */
+	if (priv->rf_set_sens == NULL) {
+		err = -1; /* we have not this support for this radio */
 		goto exit;
 	}
-	if(priv->rf_set_sens(dev, wrqu->sens.value) == 0)
+	if (priv->rf_set_sens(dev, wrqu->sens.value) == 0)
 		priv->sens = wrqu->sens.value;
 	else
-		err= -EINVAL;
+		err = -EINVAL;
 
 exit:
 	up(&priv->wx_sem);
@@ -735,7 +735,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *wrqu, char *extra)
 {
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	//printk("===>%s()\n", __func__);
@@ -745,7 +745,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 	ret = ieee80211_wx_set_encode_ext(priv->ieee80211, info, wrqu, extra);
 
 	{
-		u8 broadcast_addr[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
+		u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 		u8 zero[6] = {0};
 		u32 key[4] = {0};
 		struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
@@ -758,22 +758,22 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		alg =  (ext->alg == IW_ENCODE_ALG_CCMP)?KEY_TYPE_CCMP:ext->alg; // as IW_ENCODE_ALG_CCMP is defined to be 3 and KEY_TYPE_CCMP is defined to 4;
 		idx = encoding->flags & IW_ENCODE_INDEX;
 		if (idx)
-			idx --;
+			idx--;
 		group = ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY;
 
 		if ((!group) || (IW_MODE_ADHOC == ieee->iw_mode) || (alg ==  KEY_TYPE_WEP40))
 		{
-			if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40) )
+			if ((ext->key_len == 13) && (alg == KEY_TYPE_WEP40))
 				alg = KEY_TYPE_WEP104;
 			ieee->pairwise_key_type = alg;
 			EnableHWSecurityConfig8192(dev);
 		}
 		memcpy((u8 *)key, ext->key, 16); //we only get 16 bytes key.why? WB 2008.7.1
 
-		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode !=2) )
+		if ((alg & KEY_TYPE_WEP40) && (ieee->auth_mode != 2))
 		{
 
-			setKey( dev,
+			setKey(dev,
 					idx,//EntryNo
 					idx, //KeyIndex
 					alg,  //KeyType
@@ -784,7 +784,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		else if (group)
 		{
 			ieee->group_key_type = alg;
-			setKey( dev,
+			setKey(dev,
 					idx,//EntryNo
 					idx, //KeyIndex
 					alg,  //KeyType
@@ -794,7 +794,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		}
 		else //pairwise key
 		{
-			setKey( dev,
+			setKey(dev,
 					4,//EntryNo
 					idx, //KeyIndex
 					alg,  //KeyType
@@ -816,7 +816,7 @@ static int r8192_wx_set_auth(struct net_device *dev,
 					struct iw_request_info *info,
 					union iwreq_data *data, char *extra)
 {
-	int ret=0;
+	int ret = 0;
 	//printk("====>%s()\n", __func__);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
@@ -831,7 +831,7 @@ static int r8192_wx_set_mlme(struct net_device *dev,
 {
 	//printk("====>%s()\n", __func__);
 
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_mlme(priv->ieee80211, info, wrqu, extra);
@@ -845,7 +845,7 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
 					union iwreq_data *data, char *extra)
 {
 	   //printk("====>%s(), len:%d\n", __func__, data->length);
-	int ret=0;
+	int ret = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 	ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, data->data.length);
@@ -857,7 +857,7 @@ static int r8192_wx_set_gen_ie(struct net_device *dev,
 }
 
 static int dummy(struct net_device *dev, struct iw_request_info *a,
-		 union iwreq_data *wrqu,char *b)
+		 union iwreq_data *wrqu, char *b)
 {
 	return -1;
 }
@@ -965,13 +965,13 @@ static iw_handler r8192_private_handler[] = {
 
 struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 {
-       struct r8192_priv *priv = ieee80211_priv(dev);
+	struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	struct iw_statistics *wstats = &priv->wstats;
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-	if(ieee->state < IEEE80211_LINKED)
+	if (ieee->state < IEEE80211_LINKED)
 	{
 		wstats->qual.qual = 0;
 		wstats->qual.level = 0;
@@ -980,7 +980,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 		return wstats;
 	}
 
-       tmp_level = (&ieee->current_network)->stats.rssi;
+	tmp_level = (&ieee->current_network)->stats.rssi;
 	tmp_qual = (&ieee->current_network)->stats.signal;
 	tmp_noise = (&ieee->current_network)->stats.noise;
 	//printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
@@ -993,7 +993,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 }
 
 
-struct iw_handler_def  r8192_wx_handlers_def={
+struct iw_handler_def  r8192_wx_handlers_def = {
 	.standard = r8192_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
-- 
1.9.1

