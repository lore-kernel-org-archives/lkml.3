Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaE0UK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:10:56 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59430 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaE0UJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:52 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 4/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:48 -0700
Message-Id: <1401221390-10655-4-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401221390-10655-1-git-send-email-c@24.io>
References: <1401221390-10655-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up dead code, added curly {} braces where needed
	and fixed the following:

ERROR: do not use C99 // comments
ERROR: else should follow close brace '}'
ERROR: space required after that ',' (ctx:VxV)
ERROR: space required before the open brace '{'
ERROR: spaces required around that '=' (ctx:WxV)
ERROR: space required after that close brace '}'
ERROR: spaces required around that '=' (ctx:VxW)
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: spaces required around that '<' (ctx:VxV)
ERROR: spaces required around that '!=' (ctx:WxV)
ERROR: spaces required around that '==' (ctx:VxV)
ERROR: spaces required around that '!=' (ctx:VxV)
ERROR: spaces required around that '&&' (ctx:VxV)
ERROR: trailing statements should be on next line
ERROR: space prohibited before that '--' (ctx:WxO)
ERROR: need consistent spacing around '|' (ctx:VxW)
ERROR: need consistent spacing around '*' (ctx:WxV)
ERROR: space required before the open parenthesis '('
ERROR: that open brace { should be on the previous line
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'

WARNING: missing space after struct definition
WARNING: Missing a blank line after declarations
WARNING: please, no spaces at the start of a line
WARNING: suspect code indent for conditional statements (16, 16)
WARNING: __func__ should be used instead of gcc specific __FUNCTION__

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c |   63 +++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 7f8a3e0..6b48c08 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -252,16 +252,16 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	/* ~5 Mb/s real (802.11b) */
 	range->throughput = 5 * 1000 * 1000;
 
-	// TODO: Not used in 802.11b?
-//	range->min_nwid;	/* Minimal NWID we are able to set */
-	// TODO: Not used in 802.11b?
-//	range->max_nwid;	/* Maximal NWID we are able to set */
+	/* TODO: Not used in 802.11b? */
+/*	range->min_nwid; */	/* Minimal NWID we are able to set */
+	/* TODO: Not used in 802.11b? */
+/*	range->max_nwid; */	/* Maximal NWID we are able to set */
 
 	/* Old Frequency (backward compat - moved lower ) */
-//	range->old_num_channels;
-//	range->old_num_frequency;
-//	range->old_freq[6]; /* Filler to keep "version" at the same offset */
-	if(priv->rf_set_sens != NULL)
+/*	range->old_num_channels; */
+/*	range->old_num_frequency; */
+/*	range->old_freq[6]; */ /* Filler to keep "version" at the same offset */
+	if (priv->rf_set_sens != NULL)
 		range->sensitivity = priv->max_sens;	/* signal level threshold range */
 
 	range->max_qual.qual = 100;
@@ -284,7 +284,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->min_frag = MIN_FRAG_THRESHOLD;
 	range->max_frag = MAX_FRAG_THRESHOLD;
 
-	range->min_pmp=0;
+	range->min_pmp = 0;
 	range->max_pmp = 5000000;
 	range->min_pmt = 0;
 	range->max_pmt = 65535*1000;
@@ -295,30 +295,30 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 16;
 
-//	range->retry_capa;	/* What retry options are supported */
-//	range->retry_flags;	/* How to decode max/min retry limit */
-//	range->r_time_flags;	/* How to decode max/min retry life */
-//	range->min_retry;	/* Minimal number of retries */
-//	range->max_retry;	/* Maximal number of retries */
-//	range->min_r_time;	/* Minimal retry lifetime */
-//	range->max_r_time;	/* Maximal retry lifetime */
+/*	range->retry_capa; */	/* What retry options are supported */
+/*	range->retry_flags; */	/* How to decode max/min retry limit */
+/*	range->r_time_flags; */	/* How to decode max/min retry life */
+/*	range->min_retry; */	/* Minimal number of retries */
+/*	range->max_retry; */	/* Maximal number of retries */
+/*	range->min_r_time; */	/* Minimal retry lifetime */
+/*	range->max_r_time; */	/* Maximal retry lifetime */
 
 
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
-		break;
+			break;
 	}
 	range->num_frequency = val;
 	range->num_channels = val;
@@ -336,30 +336,28 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	struct ieee80211_device *ieee = priv->ieee80211;
 	int ret = 0;
 
-	if(!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	if (priv->ieee80211->LinkDetectInfo.bBusyTraffic == true)
 		return -EAGAIN;
-	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)
-	{
+	if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
-		if (req->essid_len)
-		{
-			//printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
+		if (req->essid_len) {
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
-			//printk("=====>network ssid:%s\n", ieee->current_network.ssid);
 		}
 	}
 
 	down(&priv->wx_sem);
-	if(priv->ieee80211->state != IEEE80211_LINKED){
+	if (priv->ieee80211->state != IEEE80211_LINKED) {
 		priv->ieee80211->scanning = 0;
 		ieee80211_softmac_scan_syncro(priv->ieee80211);
 		ret = 0;
+	} else {
+		ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 	}
-	else
-	ret = ieee80211_wx_set_scan(priv->ieee80211,a,wrqu,b);
+
 	up(&priv->wx_sem);
 	return ret;
 }
@@ -372,11 +370,12 @@ static int r8192_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	int ret;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	if(!priv->up) return -ENETDOWN;
+	if (!priv->up)
+		return -ENETDOWN;
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_get_scan(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_get_scan(priv->ieee80211, a, wrqu, b);
 
 	up(&priv->wx_sem);
 
-- 
1.7.9.5

