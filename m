Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaGMObf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:31:35 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34564 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaGMOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/16] staging: rtl8188eu: Rename _rtw_free_network_queue() to rtw_free_network_queue()
Date: Sun, 13 Jul 2014 19:59:32 +0530
Message-Id: <1405261778-7653-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |    8 +-------
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    2 --
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 3314708..b1e406e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -265,7 +265,7 @@ exit:
 }
 
 
-void _rtw_free_network_queue(struct adapter *padapter, u8 isfreeall)
+void rtw_free_network_queue(struct adapter *padapter, u8 isfreeall)
 {
 	struct list_head *phead, *plist;
 	struct wlan_network *pnetwork;
@@ -360,12 +360,6 @@ static void rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 	_rtw_free_network_nolock(pmlmepriv, pnetwork);
 }
 
-
-void rtw_free_network_queue(struct adapter *dev, u8 isfreeall)
-{
-	_rtw_free_network_queue(dev, isfreeall);
-}
-
 /*
 	return the wlan_network with the matching addr
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 75f8cf5..56ef600 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -584,8 +584,6 @@ void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 
 struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr);
 
-void _rtw_free_network_queue(struct adapter *padapter, u8 isfreeall);
-
 int rtw_if_up(struct adapter *padapter);
 
 
-- 
1.7.10.4

