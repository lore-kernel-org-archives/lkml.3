Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaFVIWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:22:51 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38092 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaFVIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:22:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/42] staging: rtl8188eu: Remove unused function rtw_list_insert_head()
Date: Sun, 22 Jun 2014 13:49:30 +0530
Message-Id: <1403425202-11942-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e5bfdd7..05cc352 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -201,7 +201,6 @@ void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
 void _rtw_init_listhead(struct list_head *list);
 u32  rtw_is_list_empty(struct list_head *phead);
-void rtw_list_insert_head(struct list_head *plist, struct list_head *phead);
 void rtw_list_insert_tail(struct list_head *plist, struct list_head *phead);
 void rtw_list_delete(struct list_head *plist);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 92203c3..8067f9c 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -107,11 +107,6 @@ u32	rtw_is_list_empty(struct list_head *phead)
 		return false;
 }
 
-void rtw_list_insert_head(struct list_head *plist, struct list_head *phead)
-{
-	list_add(plist, phead);
-}
-
 void rtw_list_insert_tail(struct list_head *plist, struct list_head *phead)
 {
 	list_add_tail(plist, phead);
-- 
1.7.10.4

