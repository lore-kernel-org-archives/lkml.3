Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaHTON5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:13:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45562 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:13:55 -0400
From: Purnendu Kapadia <pro8linux@gmail.com>
To: konkers@android.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pro8linux@gmail.com
Subject: [PATCH] staging: android: fix style issue
Date: Wed, 20 Aug 2014 15:13:26 +0100
Message-Id: <1408544006-26673-1-git-send-email-pro8linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch fix. add a line before the switch statement

Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
---
 drivers/staging/android/sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index e7b2e02..0d37495 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -705,6 +705,7 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
 	struct sync_fence *fence = file->private_data;
+
 	switch (cmd) {
 	case SYNC_IOC_WAIT:
 		return sync_fence_ioctl_wait(fence, arg);
-- 
1.9.1

