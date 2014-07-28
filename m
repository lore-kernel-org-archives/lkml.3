Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaG1XEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:04:38 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:46308 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaG1XEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:04:36 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] Staging: android: sync.c: fix missing blank line after declaration
Date: Mon, 28 Jul 2014 20:03:46 -0300
Message-Id: <1406588626-6882-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/android/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index e7b2e02..69c16cb 100644
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
@@ -726,4 +727,3 @@ static const struct file_operations sync_fence_fops = {
 	.unlocked_ioctl = sync_fence_ioctl,
 	.compat_ioctl = sync_fence_ioctl,
 };
-
-- 
1.7.10.4

