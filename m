Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbaGBQwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:31 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62587 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbaGBQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 25/48] staging: rtl8188eu: Remove unused function rtw_cmd_clr_isr()
Date: Wed,  2 Jul 2014 22:17:21 +0530
Message-Id: <1404319664-8327-25-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    6 ------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index ab3349f..651d809 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -205,12 +205,6 @@ struct cmd_obj	*rtw_dequeue_cmd(struct cmd_priv *pcmdpriv)
 	return cmd_obj;
 }
 
-void rtw_cmd_clr_isr(struct cmd_priv *pcmdpriv)
-{
-	pcmdpriv->cmd_done_cnt++;
-	/* up(&(pcmdpriv->cmd_done_sema)); */
-}
-
 void rtw_free_cmd_obj(struct cmd_obj *pcmd)
 {
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index b8adc05..bfd7eaf 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -78,8 +78,6 @@ int rtw_cmd_thread(void *context);
 u32 rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
 
-void rtw_cmd_clr_isr(struct cmd_priv *pcmdpriv);
-
 enum rtw_drvextra_cmd_id {
 	NONE_WK_CID,
 	DYNAMIC_CHK_WK_CID,
-- 
1.7.10.4

