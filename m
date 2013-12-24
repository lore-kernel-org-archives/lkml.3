Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3LXPyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:54:47 -0500
Received: from ip3mta.uwm.edu ([129.89.7.192]:31057 "EHLO ip3mta.uwm.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3LXPyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:54:47 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2013 10:54:46 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EABiruVJrz7Ub/2dsb2JhbABZg0O6UIEwdIMlgTQLEsxchXsXjx2EPQSJQ5AElDA
X-UWM-Non: True
From: Evan Hosseini <hosse005@umn.edu>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, cruzjbishop@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Evan Hosseini <hosse005@umn.edu>
Subject: [PATCH]
Date: Tue, 24 Dec 2013 09:45:03 -0600
Message-Id: <1387899903-2890-1-git-send-email-hosse005@umn.edu>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
Staging: android: fix parenthesis coding style issue in alarm-dev.c
This is a patch to the alarm-dev.c file that fixes up a
 parenthesis warning found by the checkpatch.pl tool.
Signed-off-by: Evan Hosseini <hosse005@umn.edu>

---
 drivers/staging/android/alarm-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 647694f..893362f 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -68,7 +68,6 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
  */
 static int is_wakeup(enum android_alarm_type type)
 {
-	return (type == ANDROID_ALARM_RTC_WAKEUP ||
-		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
+	return type == ANDROID_ALARM_RTC_WAKEUP ||
+	  type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;
 }
--
1.8.3.2

