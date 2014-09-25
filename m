Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaIYBrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:47:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41023 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIYBrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:47:23 -0400
From: Rahul Garg <rahul.lnmiit@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rahul Garg <rahul.lnmiit@gmail.com>
Subject: [PATCH] patch "staging: rtl8723au: os_dep: declared cfg80211_infrastructure_mode static
Date: Thu, 25 Sep 2014 07:16:59 +0530
Message-Id: <1411609619-17006-1-git-send-email-rahul.lnmiit@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declared cfg80211_infrastructure_mode method static to remove sparse warning

Signed-off-by: Rahul Garg <rahul.lnmiit@gmail.com>
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index f2615dc..bd6953a 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1119,7 +1119,7 @@ exit:
 	return ret;
 }
 
-int cfg80211_infrastructure_mode(struct rtw_adapter *padapter,
+static int cfg80211_infrastructure_mode(struct rtw_adapter *padapter,
 				 enum nl80211_iftype ifmode)
 {
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-- 
1.9.1

