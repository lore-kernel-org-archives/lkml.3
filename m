Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaGBQxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42490 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbaGBQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 33/48] staging: rtl8188eu: Remove unused member rsp_cnt from struct cmd_priv
Date: Wed,  2 Jul 2014 22:17:29 +0530
Message-Id: <1404319664-8327-33-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    1 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 1e6e52e..ef5f507 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -66,7 +66,6 @@ int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_issued_cnt = 0;
 	pcmdpriv->cmd_done_cnt = 0;
-	pcmdpriv->rsp_cnt = 0;
 exit:
 	return res;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index b3529da..60f953b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -54,7 +54,6 @@ struct cmd_priv {
 	u8	*rsp_allocated_buf;
 	u32	cmd_issued_cnt;
 	u32	cmd_done_cnt;
-	u32	rsp_cnt;
 	u8 cmdthd_running;
 	struct adapter *padapter;
 };
-- 
1.7.10.4

