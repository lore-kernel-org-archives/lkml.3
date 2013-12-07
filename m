Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab3LGWid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 17:38:33 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55837 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3LGWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:38:32 -0500
From: "Preetam D'Souza" <preetamjdsouza@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Preetam D'Souza" <preetamjdsouza@gmail.com>
Subject: [PATCH] Staging: android: fix parantheses coding style issue in alarm-dev.c
Date: Sat,  7 Dec 2013 14:35:52 -0800
Message-Id: <1386455752-17600-1-git-send-email-preetamjdsouza@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an unecessary return statement parantheses error
found in alarm-dev.c by the checkpatch.pl tool -- alarm-dev.c now has
no more errors/warnings!

Signed-off-by: Preetam D'Souza <preetamjdsouza@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 647694f..ccf74ee 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -68,8 +68,8 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
  */
 static int is_wakeup(enum android_alarm_type type)
 {
-	return (type == ANDROID_ALARM_RTC_WAKEUP ||
-		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
+	return type == ANDROID_ALARM_RTC_WAKEUP ||
+		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;
 }
 
 
-- 
1.7.10.4

