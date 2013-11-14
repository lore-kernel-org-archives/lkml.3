Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3KNMPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:15:33 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35056 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3KNMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:15:04 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/3] staging: alarm-dev: Remove unnecessary blank lines
Date: Thu, 14 Nov 2013 21:15:11 +0900
Message-Id: <1384431312-2685-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384431312-2685-1-git-send-email-sj38.park@gmail.com>
References: <y>
 <1384431312-2685-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index ccf74ee..a3b467b 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -72,7 +72,6 @@ static int is_wakeup(enum android_alarm_type type)
 		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;
 }
 
-
 static void devalarm_start(struct devalarm *alrm, ktime_t exp)
 {
 	if (is_wakeup(alrm->type))
@@ -111,7 +110,6 @@ static void alarm_clear(enum android_alarm_type alarm_type)
 	}
 	alarm_enabled &= ~alarm_type_mask;
 	spin_unlock_irqrestore(&alarm_slock, flags);
-
 }
 
 static void alarm_set(enum android_alarm_type alarm_type,
@@ -371,7 +369,6 @@ static void devalarm_triggered(struct devalarm *alarm)
 	spin_unlock_irqrestore(&alarm_slock, flags);
 }
 
-
 static enum hrtimer_restart devalarm_hrthandler(struct hrtimer *hrt)
 {
 	struct devalarm *devalrm = container_of(hrt, struct devalarm, u.hrt);
-- 
1.7.9.5

