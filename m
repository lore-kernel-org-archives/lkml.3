Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaFVIhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59923 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFVIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/42] staging: rtl8188eu: osdep_service.c: Remove unused macro
Date: Sun, 22 Jun 2014 14:06:28 +0530
Message-Id: <1403426208-12413-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/osdep_service.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 76b02b5..ff6ee5b 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -98,8 +98,6 @@ inline s32 rtw_get_passing_time_ms(u32 start)
 	return rtw_systime_to_ms(jiffies-start);
 }
 
-#define RTW_SUSPEND_LOCK_NAME "rtw_wifi"
-
 struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
 						    void *old_priv)
 {
-- 
1.7.10.4

