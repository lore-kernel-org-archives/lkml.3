Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaGMOc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:32:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49939 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaGMOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:32:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/16] staging: rtl8188eu: Rename _rtw_free_mlme_priv() to rtw_free_mlme_priv()
Date: Sun, 13 Jul 2014 19:59:37 +0530
Message-Id: <1405261778-7653-15-git-send-email-navin.patidar@gmail.com>
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
index 2aafac3..7293589 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -117,7 +117,7 @@ void rtw_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv)
 }
 #endif
 
-void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
+void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
 {
 	rtw_free_mlme_priv_ie_data(pmlmepriv);
 
@@ -309,12 +309,6 @@ int rtw_init_mlme_priv(struct adapter *padapter)
 	return res;
 }
 
-void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
-{
-	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("rtw_free_mlme_priv\n"));
-	_rtw_free_mlme_priv(pmlmepriv);
-}
-
 static struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv)
 {
 	return _rtw_alloc_network(pmlmepriv);
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 13f8702..2a828ec 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -567,8 +567,6 @@ int _rtw_init_mlme_priv(struct adapter *padapter);
 
 void rtw_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv);
 
-void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv);
-
 struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
 
 void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
-- 
1.7.10.4

