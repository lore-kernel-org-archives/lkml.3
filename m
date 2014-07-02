Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaGBQwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:05 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61018 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbaGBQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/48] staging: rtl8188eu: rtw_cmd.h: Remove unused function declaration
Date: Wed,  2 Jul 2014 22:17:18 +0530
Message-Id: <1404319664-8327-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index d356cf4..1e3161e 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -731,11 +731,6 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms,
 u8 rtw_setopmode_cmd(struct adapter *padapter,
 		     enum ndis_802_11_network_infra networktype);
 u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset);
-u8 rtw_setrfintfs_cmd(struct adapter *padapter, u8 mode);
-
-u8 rtw_gettssi_cmd(struct adapter *padapter, u8 offset, u8 *pval);
-u8 rtw_setfwdig_cmd(struct adapter *padapter, u8 type);
-u8 rtw_setfwra_cmd(struct adapter *padapter, u8 type);
 
 u8 rtw_addbareq_cmd(struct adapter *padapter, u8 tid, u8 *addr);
 
@@ -752,7 +747,6 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter);
 #endif
 
 u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue);
-
 u8 rtw_drvextra_cmd_hdl(struct adapter *padapter, unsigned char *pbuf);
 
 void rtw_survey_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd);
-- 
1.7.10.4

