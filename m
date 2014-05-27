Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaE0UJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:09:53 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64118 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaE0UJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:50 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 3/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:47 -0700
Message-Id: <1401221390-10655-3-git-send-email-c@24.io>
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
 drivers/staging/rtl8192u/r8192U_wx.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index ca0e21c..7f8a3e0 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -72,7 +72,7 @@ static int r8192_wx_set_rate(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_rate(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_rate(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -89,7 +89,7 @@ static int r8192_wx_set_rts(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_rts(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_rts(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -101,7 +101,7 @@ static int r8192_wx_get_rts(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_rts(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_rts(priv->ieee80211, info, wrqu, extra);
 }
 
 static int r8192_wx_set_power(struct net_device *dev,
@@ -113,7 +113,7 @@ static int r8192_wx_set_power(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_power(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_power(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -125,7 +125,8 @@ static int r8192_wx_get_power(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_power(priv->ieee80211,info,wrqu,extra);
+
+	return ieee80211_wx_get_power(priv->ieee80211, info, wrqu, extra);
 }
 
 static int r8192_wx_force_reset(struct net_device *dev,
@@ -136,7 +137,7 @@ static int r8192_wx_force_reset(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	printk("%s(): force reset ! extra is %d\n",__func__, *extra);
+	printk("%s(): force reset ! extra is %d\n", __func__, *extra);
 	priv->force_reset = *extra;
 	up(&priv->wx_sem);
 	return 0;
@@ -172,17 +173,17 @@ static int r8192_wx_set_crcmon(struct net_device *dev,
 
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
-		//rtl8180_down(dev);
-		//rtl8180_up(dev);
+	if (prev != priv->crcmon && priv->up) {
+		/*rtl8180_down(dev);*/
+		/*rtl8180_up(dev);*/
 	}
 
 	up(&priv->wx_sem);
@@ -195,9 +196,10 @@ static int r8192_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int ret;
+
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_mode(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
 
 	rtl8192_set_rxconf(dev);
 
-- 
1.7.9.5

