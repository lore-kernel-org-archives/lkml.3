Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaBHC7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:59:52 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38273 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaBHC7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:59:51 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: arve@android.com, swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] staging: android: binder: use whitespace consistently
Date: Sat,  8 Feb 2014 11:59:40 +0900
Message-Id: <1391828381-4303-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace between #define keyword and BINDER_* constants are space in
some point and tab in some point. Using space or tab is just writer's
choice. But, let's use them more consistently.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/binder.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index cbe34516..c4c1ed6 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -85,11 +85,11 @@ struct binder_version {
 #define BINDER_CURRENT_PROTOCOL_VERSION 7
 
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
-#define	BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
-#define	BINDER_SET_MAX_THREADS		_IOW('b', 5, __u32)
-#define	BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
-#define	BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
-#define	BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
+#define BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
+#define BINDER_SET_MAX_THREADS		_IOW('b', 5, __u32)
+#define BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
+#define BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
+#define BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
 #define BINDER_VERSION			_IOWR('b', 9, struct binder_version)
 
 /*
-- 
1.8.1.2

