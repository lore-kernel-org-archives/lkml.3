Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaBHDAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:00:42 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40110 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaBHDAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:00:01 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: arve@android.com, swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] staging: android: remove unused constant, BINDER_SET_IDLE_PRIORITY
Date: Sat,  8 Feb 2014 11:59:41 +0900
Message-Id: <1391828381-4303-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391828381-4303-1-git-send-email-sj38.park@gmail.com>
References: <1391828381-4303-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove constant BINDER_SET_IDLE_PRIORITY because it is not used from
anywhere.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/binder.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index c4c1ed6..6d08e61 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -87,10 +87,9 @@ struct binder_version {
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
 #define BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
 #define BINDER_SET_MAX_THREADS		_IOW('b', 5, __u32)
-#define BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
-#define BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
-#define BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
-#define BINDER_VERSION			_IOWR('b', 9, struct binder_version)
+#define BINDER_SET_CONTEXT_MGR		_IOW('b', 6, __s32)
+#define BINDER_THREAD_EXIT		_IOW('b', 7, __s32)
+#define BINDER_VERSION			_IOWR('b', 8, struct binder_version)
 
 /*
  * NOTE: Two special error codes you should check for when calling
-- 
1.8.1.2

