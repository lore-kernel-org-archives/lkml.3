Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbaGXC7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 22:59:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55042 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbaGXC7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 22:59:45 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, waydi1@gmail.com, executerx@gmail.com,
        alistair.strachan@imgtec.com, tanure@linux.com, ydroneaud@opteya.com,
        maarten.lankhorst@canonical.com, pkamliya@codeaurora.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Add blank line in sync.c
Date: Wed, 23 Jul 2014 22:59:40 -0400
Message-Id: <1406170780-4825-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a blank line after line 708 as declared when
running checkpatch on this file.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
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

