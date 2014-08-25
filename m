Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaHYThu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:37:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38193 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaHYTht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:37:49 -0400
From: Koray Gulcu <koray.gulcu@ozu.edu.tr>
To: devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc: Koray Gulcu <koray.gulcu@ozu.edu.tr>
Subject: [PATCH] staging: android: sw_sync.c: fix new line style issues
Date: Mon, 25 Aug 2014 20:35:31 +0100
Message-Id: <1408995335-4041-1-git-send-email-koray.gulcu@ozu.edu.tr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two new lines that are missing after declerations as detected by checkpatch.pl

Signed-off-by: Koray Gulcu <koray.gulcu@ozu.edu.tr>
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

