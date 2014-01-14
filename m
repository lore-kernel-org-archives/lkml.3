Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaANV2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:28:53 -0500
Received: from 24c7.rev.megiteam.pl ([91.227.36.199]:39714 "EHLO
	vk1071.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANV2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:28:50 -0500
From: =?UTF-8?q?Micha=C5=82=20Kwiatkowski?= 
	<michaelflowersky@geekingspree.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org,
        dan.carpenter@oracle.com, cruzjbishop@gmail.com
Cc: michaelflowersky@geekingspree.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: android: fix parentheses coding style issue in alarm-dev.c
Date: Tue, 14 Jan 2014 22:28:15 +0100
Message-Id: <1389734895-2760-1-git-send-email-michaelflowersky@geekingspree.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kwiatkowski <michaelflowersky@geekingspree.com>

This is a patch to the alarm-dev.c file that removes parentheses which
should not appear in return statement. This error was found by the
checkpatch.pl tool.

Signed-off-by: Michał Kwiatkowski <michaelflowersky@geekingspree.com>
---
 drivers/staging/android/alarm-dev.c |    4 ++--
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
1.7.9.5

