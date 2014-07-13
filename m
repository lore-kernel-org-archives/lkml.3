Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaGMOdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:33:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42746 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaGMObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/16] staging: rtl8188eu: Remove unused function rtw_get_timestampe_from_ie()
Date: Sun, 13 Jul 2014 19:59:31 +0530
Message-Id: <1405261778-7653-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 1eef47d..3314708 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -331,11 +331,6 @@ u16 rtw_get_capability(struct wlan_bssid_ex *bss)
 	return le16_to_cpu(val);
 }
 
-u8 *rtw_get_timestampe_from_ie(u8 *ie)
-{
-	return ie + 0;
-}
-
 u8 *rtw_get_beacon_interval_from_ie(u8 *ie)
 {
 	return ie + 8;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 45c22ef..75f8cf5 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -590,7 +590,6 @@ int rtw_if_up(struct adapter *padapter);
 
 
 u8 *rtw_get_capability_from_ie(u8 *ie);
-u8 *rtw_get_timestampe_from_ie(u8 *ie);
 u8 *rtw_get_beacon_interval_from_ie(u8 *ie);
 
 
-- 
1.7.10.4

