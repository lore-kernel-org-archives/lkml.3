Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaGMOaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:30:30 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49652 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaGMOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/16] staging: rtl8188eu: Remove unused function rtw_set_scan_mode()
Date: Sun, 13 Jul 2014 19:59:25 +0530
Message-Id: <1405261778-7653-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   17 -----------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 5eb21cd..09d5bf4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -1075,23 +1075,6 @@ u16 rtw_get_cur_max_rate(struct adapter *adapter)
 }
 
 /*
-* rtw_set_scan_mode -
-* @adapter: pointer to struct adapter structure
-* @scan_mode:
-*
-* Return _SUCCESS or _FAIL
-*/
-int rtw_set_scan_mode(struct adapter *adapter, enum rt_scan_type scan_mode)
-{
-	if (scan_mode != SCAN_ACTIVE && scan_mode != SCAN_PASSIVE)
-		return _FAIL;
-
-	adapter->mlmepriv.scan_mode = scan_mode;
-
-	return _SUCCESS;
-}
-
-/*
 * rtw_set_country -
 * @adapter: pointer to struct adapter structure
 * @country_code: string of country code
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 7335147..525abbd 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -42,7 +42,6 @@ u8 rtw_set_802_11_remove_key(struct adapter *adapt,
 			     struct ndis_802_11_remove_key *key);
 u8 rtw_validate_ssid(struct ndis_802_11_ssid *ssid);
 u16 rtw_get_cur_max_rate(struct adapter *adapter);
-int rtw_set_scan_mode(struct adapter *adapter, enum rt_scan_type scan_mode);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
 
 #endif
-- 
1.7.10.4

