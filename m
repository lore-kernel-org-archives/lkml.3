Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaGBQtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:50 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65450 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaGBQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/48] staging: rtl8188eu: rtw_cmd.h: Remove unused macro and structure
Date: Wed,  2 Jul 2014 22:17:03 +0530
Message-Id: <1404319664-8327-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 7a70f02..049e112 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -74,15 +74,6 @@ do {\
 	pcmd->rspsz = 0;\
 } while (0)
 
-struct c2h_evt_hdr {
-	u8 id:4;
-	u8 plen:4;
-	u8 seq;
-	u8 payload[0];
-};
-
-#define c2h_evt_exist(c2h_evt) ((c2h_evt)->id || (c2h_evt)->plen)
-
 u32 rtw_enqueue_cmd(struct cmd_priv *pcmdpriv, struct cmd_obj *obj);
 struct cmd_obj *rtw_dequeue_cmd(struct cmd_priv *pcmdpriv);
 void rtw_free_cmd_obj(struct cmd_obj *pcmd);
-- 
1.7.10.4

