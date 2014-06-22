Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaFVIhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:38 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34020 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaFVIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/42] staging: rtl8188eu: Remove unused function rtw_division64()
Date: Sun, 22 Jun 2014 14:06:24 +0530
Message-Id: <1403426208-12413-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    6 ------
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index acce3e6..bf9bf3c 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -305,7 +305,6 @@ void rtw_free_netdev(struct net_device *netdev);
 #define rtw_signal_process(pid, sig) kill_pid(find_vpid((pid)), (sig), 1)
 
 u64 rtw_modular64(u64 x, u64 y);
-u64 rtw_division64(u64 x, u64 y);
 
 /* Macros for handling unaligned memory accesses */
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index fa31820..d63feea 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -225,12 +225,6 @@ u64 rtw_modular64(u64 x, u64 y)
 	return do_div(x, y);
 }
 
-u64 rtw_division64(u64 x, u64 y)
-{
-	do_div(x, y);
-	return x;
-}
-
 void rtw_buf_free(u8 **buf, u32 *buf_len)
 {
 	*buf_len = 0;
-- 
1.7.10.4

