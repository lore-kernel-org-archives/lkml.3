Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaGSMPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 08:15:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47593 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaGSMPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 08:15:09 -0400
From: Elias Boutaleb <kagekyio@gmail.com>
X-Google-Original-From: Elias Boutaleb <elias.boutaleb@etu.upmc.fr>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: Elias Boutaleb <elias.boutaleb@etu.upmc.fr>
Subject: [PATCH] staging: android: cleanup style issues
Date: Sat, 19 Jul 2014 14:14:54 +0200
Message-Id: <1405772094-8681-1-git-send-email-elias.boutaleb@etu.upmc.fr>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes 3 "Missing a blank line after declarations" checkpatch warnings.
---
 drivers/staging/android/sw_sync.c | 2 ++
 drivers/staging/android/sync.c    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3f..863d4b1 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
 				       char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
 	snprintf(str, size, "%d", pt->value);
 }
 
@@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
 static int sw_sync_release(struct inode *inode, struct file *file)
 {
 	struct sw_sync_timeline *obj = file->private_data;
+
 	sync_timeline_destroy(&obj->obj);
 	return 0;
 }
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

