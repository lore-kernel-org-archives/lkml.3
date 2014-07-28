Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaG1VHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:07:52 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:42855 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaG1VHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:07:50 -0400
From: adrianremonda@gmail.com
To: gregkh@linuxfoundation.org
Cc: daniel@ffwll.ch, waydi1@gmail.com, sumit.semwal@linaro.org,
        ydroneaud@opteya.com, adrianremonda@gmail.com,
        maarten.lankhorst@canonical.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: android: Missing a blank line after declarations in sw_sync.c This is a patch to the sw_sync.c file that fixes up a missing a blank warning found by the checkpatch.pl tool
Date: Mon, 28 Jul 2014 23:07:40 +0200
Message-Id: <1406581660-7863-1-git-send-email-adrianremonda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Remonda <adrianremonda@gmail.com>


Signed-off-by: Adrian Remonda <adrianremonda@gmail.com>
---
 drivers/staging/android/sw_sync.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3ff87cb..863d4b17387a 100644
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
-- 
1.7.10.4

