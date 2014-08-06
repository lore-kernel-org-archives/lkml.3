Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHFVr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:47:59 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:48432 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHFVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:47:58 -0400
From: "Yee Chin, Chiam" <phathetique@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Yee Chin, Chiam" <phathetique@gmail.com>
Subject: [PATCH] Staging: android: sw_sync.c: Fixed coding style issue.
Date: Wed,  6 Aug 2014 17:47:34 -0400
Message-Id: <1407361654-27761-1-git-send-email-phathetique@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue where blank line is missing after declaration.

Signed-off-by: Yee Chin, Chiam <phathetique@gmail.com>
---
 drivers/staging/android/sw_sync.c | 2 ++
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
2.0.1

