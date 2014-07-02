Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaGBQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:51:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43464 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbaGBQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:51:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/48] staging: rtl8188eu: Remove dummy function rtw_tdls_cmd()
Date: Wed,  2 Jul 2014 22:17:14 +0530
Message-Id: <1404319664-8327-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 7141ab4..de62902 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -1059,11 +1059,6 @@ exit:
 	return res;
 }
 
-u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option)
-{
-	return _SUCCESS;
-}
-
 static void traffic_status_watchdog(struct adapter *padapter)
 {
 	u8	bEnterPS;
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 108cf30..fa9d5f7 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -756,7 +756,6 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter);
 #endif
 
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
-u8 rtw_tdls_cmd(struct adapter *padapter, u8 *addr, u8 option);
 
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf);
 
-- 
1.7.10.4

