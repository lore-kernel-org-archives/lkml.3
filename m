Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaGGSl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:41:26 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58508 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGGSlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:41:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/13] staging: rtl8188eu: Remove unused function efuse_GetMaxSize()
Date: Tue,  8 Jul 2014 00:10:04 +0530
Message-Id: <1404758413-12859-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |    7 -------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 0e20d5c..ede7708 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -1035,13 +1035,6 @@ u8 rtw_efuse_access(struct adapter *padapter, u8 write, u16 start_addr, u16 cnts
 	return res;
 }

-u16 efuse_GetMaxSize(struct adapter *padapter)
-{
-	u16 max_size;
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI , TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_size);
-	return max_size;
-}
-
 u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
 	u16 mapLen = 0;
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 6b56501..86a1832 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -99,7 +99,6 @@ struct efuse_hal {
 	u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN];
 };

-u16 efuse_GetMaxSize(struct adapter *adapter);
 u8 rtw_efuse_access(struct adapter *adapter, u8 read, u16 start_addr,
 		    u16 cnts, u8 *data);
 u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
--
1.7.10.4

