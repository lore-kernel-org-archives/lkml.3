Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaBJF7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:59:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46896 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaBJF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:59:32 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>, swetland@google.com
Cc: prtvar.b@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: timed_output: fix a checkpatch warning
Date: Mon, 10 Feb 2014 14:59:26 +0900
Message-ID: <4087797.UX41NyGzdN@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 866c5eb6cb88b59702802876a724dfd0144c447e Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 14:38:05 +0900
Subject: [PATCH] staging: android: timed_output: fix a checkpatch warning

- WARNING: Multiple spaces after return type

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/timed_output.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/timed_output.h b/drivers/staging/android/timed_output.h
index 905c7cc..13d2ca5 100644
--- a/drivers/staging/android/timed_output.h
+++ b/drivers/staging/android/timed_output.h
@@ -20,10 +20,10 @@ struct timed_output_dev {
 	const char	*name;
 
 	/* enable the output and set the timer */
-	void	(*enable)(struct timed_output_dev *sdev, int timeout);
+	void (*enable)(struct timed_output_dev *sdev, int timeout);
 
 	/* returns the current number of milliseconds remaining on the timer */
-	int		(*get_time)(struct timed_output_dev *sdev);
+	int (*get_time)(struct timed_output_dev *sdev);
 
 	/* private data */
 	struct device	*dev;
-- 
1.7.9.5
---
