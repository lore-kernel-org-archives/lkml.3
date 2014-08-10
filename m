Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHJOrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:22 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52596 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHJOrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/22] staging: rtl8188eu: Remove unused function rtw_IOL_exec_cmds_sync()
Date: Sun, 10 Aug 2014 20:14:27 +0530
Message-Id: <1407681875-2611-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_iol.h |    3 ---
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index ebc228d..4527aaa 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -53,11 +53,6 @@ bool rtw_IOL_applied(struct adapter  *adapter)
 	return false;
 }
 
-int rtw_IOL_exec_cmds_sync(struct adapter  *adapter, struct xmit_frame *xmit_frame, u32 max_wating_ms, u32 bndy_cnt)
-{
-	return rtw_hal_iol_cmd(adapter, xmit_frame, max_wating_ms, bndy_cnt);
-}
-
 int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary)
 {
 	return _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index f53bceb..fc5b916 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -49,9 +49,6 @@ enum ioreg_cmd {
 int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds,
 			u32 cmd_len);
 int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary);
-int rtw_IOL_exec_cmds_sync(struct adapter  *adapter,
-			   struct xmit_frame *xmit_frame, u32 max_wating_ms,
-			   u32 bndy_cnt);
 bool rtw_IOL_applied(struct adapter  *adapter);
 int rtw_IOL_append_DELAY_US_cmd(struct xmit_frame *xmit_frame, u16 us);
 int rtw_IOL_append_DELAY_MS_cmd(struct xmit_frame *xmit_frame, u16 ms);
-- 
1.7.10.4

