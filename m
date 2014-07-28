Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaG1XL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:11:58 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:63244 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaG1XL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:11:56 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] Staging: android: timed_gpio.c: remove else statement after return
Date: Mon, 28 Jul 2014 20:11:15 -0300
Message-Id: <1406589075-7483-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes checkpatch.pl script happy by fixing the following
warning:

WARNING: else is not generally useful after a break or return

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/android/timed_gpio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index 180c209..05cb578 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -53,8 +53,9 @@ static int gpio_get_time(struct timed_output_dev *dev)
 		struct timeval t = ktime_to_timeval(r);
 
 		return t.tv_sec * 1000 + t.tv_usec / 1000;
-	} else
-		return 0;
+	}
+
+	return 0;
 }
 
 static void gpio_enable(struct timed_output_dev *dev, int value)
-- 
1.7.10.4

