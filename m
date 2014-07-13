Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaGMOcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:32:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50952 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaGMOcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:32:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/16] staging: rtl8188eu: Rename _rtw_init_mlme_priv() to rtw_init_mlme_priv()
Date: Sun, 13 Jul 2014 19:59:38 +0530
Message-Id: <1405261778-7653-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |    9 +--------
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    3 ---
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 7293589..c15fab2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -35,7 +35,7 @@
 extern unsigned char	MCS_rate_2R[16];
 extern unsigned char	MCS_rate_1R[16];
 
-int _rtw_init_mlme_priv(struct adapter *padapter)
+int rtw_init_mlme_priv(struct adapter *padapter)
 {
 	int	i;
 	u8	*pbuf;
@@ -302,13 +302,6 @@ u8 *rtw_get_beacon_interval_from_ie(u8 *ie)
 	return ie + 8;
 }
 
-int rtw_init_mlme_priv(struct adapter *padapter)
-{
-	int	res;
-	res = _rtw_init_mlme_priv(padapter);/*  (pmlmepriv); */
-	return res;
-}
-
 static struct wlan_network *rtw_alloc_network(struct mlme_priv *pmlmepriv)
 {
 	return _rtw_alloc_network(pmlmepriv);
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 2a828ec..5b1fcd2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -562,9 +562,6 @@ void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
 #define rtw_set_scan_deny_timer_hdl(adapter) do {} while (0)
 #define rtw_set_scan_deny(adapter, ms) do {} while (0)
 
-
-int _rtw_init_mlme_priv(struct adapter *padapter);
-
 void rtw_free_mlme_priv_ie_data(struct mlme_priv *pmlmepriv);
 
 struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
-- 
1.7.10.4

