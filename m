Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaG1WjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:39:14 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38356 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaG1WjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:39:10 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, daniel@ffwll.ch, waydi1@gmail.com,
        ydroneaud@opteya.com, sumit.semwal@linaro.org,
        maarten.lankhorst@canonical.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] Staging: android: sw_sync.c: fix missing blank line after declaration
Date: Mon, 28 Jul 2014 19:38:23 -0300
Message-Id: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/android/sw_sync.c |    2 ++
 1 file changed, 2 insertions(+)

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
-- 
1.7.10.4

