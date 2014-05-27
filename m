Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaE0ULy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:11:54 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40424 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaE0UJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:09:48 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH 2/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix checkpatch.pl errors and warnings
Date: Tue, 27 May 2014 13:09:46 -0700
Message-Id: <1401221390-10655-2-git-send-email-c@24.io>
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
 drivers/staging/rtl8192u/r8192U_wx.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index dab716f..ca0e21c 100644
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
 
 
@@ -57,7 +57,8 @@ static int r8192_wx_get_rate(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_rate(priv->ieee80211,info,wrqu,extra);
+
+	return ieee80211_wx_get_rate(priv->ieee80211, info, wrqu, extra);
 }
 
 
-- 
1.7.9.5

