Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaG3Qvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:51:32 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63892 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaG3Qva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:51:30 -0400
From: fernando.apesteguia@gmail.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fernando Apesteguia <fernando.apesteguia@gmail.com>
Subject: [PATCH] Staging: vt6655: staticfy variable
Date: Wed, 30 Jul 2014 18:51:15 +0200
Message-Id: <1406739075-5194-1-git-send-email-fernando.apesteguia@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Apesteguia <fernando.apesteguia@gmail.com>

Add static to variable.

Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
---
 drivers/staging/vt6655/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 65e5933..cc6e47b 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -41,7 +41,7 @@
 static int msglevel = MSG_LEVEL_INFO;
 
 #ifdef WPA_SM_Transtatus
-SWPAResult wpa_Result;
+static SWPAResult wpa_Result;
 #endif
 
 int private_ioctl(PSDevice pDevice, struct ifreq *rq)
-- 
1.7.9.5

