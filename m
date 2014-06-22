Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaFVIhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:41 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37362 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaFVIhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/42] staging: rtl8188eu: Remove unused function rtw_get_time_interval_ms()
Date: Sun, 22 Jun 2014 14:06:25 +0530
Message-Id: <1403426208-12413-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index bf9bf3c..e9d5309 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -207,7 +207,6 @@ u32  _rtw_queue_empty(struct __queue *pqueue);
 u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
-s32  rtw_get_time_interval_ms(u32 start, u32 end);
 
 static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
 {
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index d63feea..76b02b5 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -98,11 +98,6 @@ inline s32 rtw_get_passing_time_ms(u32 start)
 	return rtw_systime_to_ms(jiffies-start);
 }
 
-inline s32 rtw_get_time_interval_ms(u32 start, u32 end)
-{
-	return rtw_systime_to_ms(end-start);
-}
-
 #define RTW_SUSPEND_LOCK_NAME "rtw_wifi"
 
 struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
-- 
1.7.10.4

