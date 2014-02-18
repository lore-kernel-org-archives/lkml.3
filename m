Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaBRLWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:22:25 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56528 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBRLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:22:24 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] staging: android: binder: remove unnecessary comment
Date: Tue, 18 Feb 2014 20:23:25 +0900
Message-Id: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/binder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..b23cbc9 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2553,8 +2553,6 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
-
 	trace_binder_ioctl(cmd, arg);
 
 	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
-- 
1.8.3.2

