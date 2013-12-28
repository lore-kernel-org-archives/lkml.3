Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3L1QDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 11:03:36 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:48074 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3L1QDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 11:03:35 -0500
From: Arthur Schwalbenberg <arthurs578@gmail.com>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, dan.carpenter@oracle.com, arthurs578@gmail.com,
        cruzjbishop@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 	Staging: Android: Fixed coding issue return parenthesis in alarm_dev.c
Date: Sat, 28 Dec 2013 11:03:28 -0500
Message-Id: <1388246608-11272-1-git-send-email-arthurs578@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is a patch to the alarm_dev.c file that fixes up a return is not
	a function warning found by the checkpatch.pl tool

	Signed-off-by: Arthur Schwalbenberg <arthurs578@gmail.com>
---
 drivers/staging/android/alarm-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 647694f..96b2f53 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -68,8 +68,8 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
  */
 static int is_wakeup(enum android_alarm_type type)
 {
-	return (type == ANDROID_ALARM_RTC_WAKEUP ||
-		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
+	return type == ANDROID_ALARM_RTC_WAKEUP ||
+	       type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;
 }
 
 
-- 
1.8.3.2

