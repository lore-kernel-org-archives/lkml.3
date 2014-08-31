Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaHaUnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:43:24 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:59894 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHaUnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:43:20 -0400
From: Grzegorz Swirski <grzegorz@swirski.name>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, daniel@ffwll.ch, waydi1@gmail.com,
        alistair.strachan@imgtec.com, grzegorz@swirski.name,
        pkamliya@codeaurora.org, executerx@gmail.com,
        maarten.lankhorst@canonical.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: add a blank line after declarations
Date: Sun, 31 Aug 2014 21:43:15 +0100
Message-Id: <1409517795-10237-1-git-send-email-grzegorz@swirski.name>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grzegorz Swirski <grzegorz@swirski.name>
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

