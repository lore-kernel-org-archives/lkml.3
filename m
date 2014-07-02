Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbaGBQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:53:20 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48420 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaGBQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:53:17 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 31/48] staging: rtl8188eu: Rename _rtw_free_cmd_priv() to rtw_free_cmd_priv()
Date: Wed,  2 Jul 2014 22:17:27 +0530
Message-Id: <1404319664-8327-31-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index e26a582..81f4b94 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -71,7 +71,7 @@ exit:
 	return res;
 }
 
-void _rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
+void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 
 	if (pcmdpriv) {
@@ -130,12 +130,6 @@ struct	cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue)
 	return obj;
 }
 
-void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
-{
-	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("rtw_free_cmd_priv\n"));
-	_rtw_free_cmd_priv(pcmdpriv);
-}
-
 static int rtw_cmd_filter(struct cmd_priv *pcmdpriv, struct cmd_obj *cmd_obj)
 {
 	u8 bAllow = false; /* set to true to allow enqueuing cmd when hw_init_completed is false */
-- 
1.7.10.4

