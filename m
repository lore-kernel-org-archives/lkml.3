Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3KNMIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:08:24 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53790 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3KNMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:08:18 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: grepkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/3] staging: alarm-dev: Remove unnecessary parenthesis
Date: Thu, 14 Nov 2013 21:07:50 +0900
Message-Id: <1384430872-2070-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
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
1.7.9.5

