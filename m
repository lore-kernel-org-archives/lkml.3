Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaHKR4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:56:55 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50557 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaHKR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:56:54 -0400
From: Avinash kumar <avi.kp.137@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Avinash kumar <avi.kp.137@gmail.com>
Subject: [PATCH] drivers: staging: vt6655: wpactl.h: corrected comment format
Date: Mon, 11 Aug 2014 23:26:32 +0530
Message-Id: <1407779792-7926-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

corrected C99 style comment format related error

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/staging/vt6655/wpactl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.h b/drivers/staging/vt6655/wpactl.h
index f7638ba..2ff42c5 100644
--- a/drivers/staging/vt6655/wpactl.h
+++ b/drivers/staging/vt6655/wpactl.h
@@ -36,7 +36,7 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
-//WPA related
+/*WPA related*/
 
 enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
 enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
@@ -61,4 +61,4 @@ int wpa_set_wpadev(PSDevice pDevice, int val);
 int wpa_ioctl(PSDevice pDevice, struct iw_point *p);
 int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel);
 
-#endif // __WPACL_H__
+#endif /* __WPACL_H__*/
-- 
1.7.9.5

