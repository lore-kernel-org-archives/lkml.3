Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBJF6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:58:07 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58042 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaBJF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:58:05 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>, swetland@google.com
Cc: konkers <konkers@android.com>, "john.stultz" <john.stultz@linaro.org>,
        rdunlap <rdunlap@infradead.org>, standby24x7 <standby24x7@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging : android : sync : fix a checkpatch warning
Date: Sun, 09 Feb 2014 21:58:03 -0800 (PST)
Message-ID: <19098109.K5Vqu3vXYV@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16140b1ec1b1e1060f74707e4a6661aface81a14 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 14:36:48 +0900
Subject: [PATCH] staging : android : sync : fix a checkpatch warning

- WARNING: missing space after return type

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/sync.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 62e2255b..6ee8d69 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -53,7 +53,7 @@ struct sync_timeline_ops {
 	const char *driver_name;
 
 	/* required */
-	struct sync_pt *(*dup)(struct sync_pt *pt);
+	struct sync_pt * (*dup)(struct sync_pt *pt);
 
 	/* required */
 	int (*has_signaled)(struct sync_pt *pt);
-- 
1.7.9.5


