Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaE2Qob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:44:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55229 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaE2Qoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:44:30 -0400
From: Chaitanya Hazarey <c@24.io>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        burzalodowa@gmail.com, andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 1/5] Staging: rtl8192u: r8192U_wx.c Fixed a misplaced brace
Date: Thu, 29 May 2014 09:44:20 -0700
Message-Id: <1401381864-28718-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a misplaced brace in the r8192_wx_set_scan_type function.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 1af7c5d..675a12d 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -616,7 +616,8 @@ static int r8192_wx_set_enc(struct net_device *dev,
 
 
 static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
-					union iwreq_data *wrqu, char *p){
+					union iwreq_data *wrqu, char *p)
+{
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int *parms = (int *)p;
-- 
1.9.1

