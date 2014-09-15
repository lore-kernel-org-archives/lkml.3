Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaIOMHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:07:10 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54757 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaIOMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:07:08 -0400
From: Purnendu Kapadia <pro8linux@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pro8linux@gmail.com
Subject: [PATCH] staging: android: sw_sync: checkpatch fixes
Date: Mon, 15 Sep 2014 13:06:36 +0100
Message-Id: <1410782796-24707-1-git-send-email-pro8linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   - no space after cast
   - allignment should match open parenthesis
   - remove unnecessary new line

Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
---
 drivers/staging/android/sw_sync.c | 7 +++----
 drivers/staging/android/sw_sync.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index 863d4b1..c90838d 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -48,11 +48,11 @@ EXPORT_SYMBOL(sw_sync_pt_create);
 
 static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
 {
-	struct sw_sync_pt *pt = (struct sw_sync_pt *) sync_pt;
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
 	struct sw_sync_timeline *obj =
 		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
 
-	return (struct sync_pt *) sw_sync_pt_create(obj, pt->value);
+	return (struct sync_pt *)sw_sync_pt_create(obj, pt->value);
 }
 
 static int sw_sync_pt_has_signaled(struct sync_pt *sync_pt)
@@ -94,7 +94,7 @@ static void sw_sync_timeline_value_str(struct sync_timeline *sync_timeline,
 }
 
 static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
-				       char *str, int size)
+				 char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
 
@@ -111,7 +111,6 @@ static struct sync_timeline_ops sw_sync_timeline_ops = {
 	.pt_value_str = sw_sync_pt_value_str,
 };
 
-
 struct sw_sync_timeline *sw_sync_timeline_create(const char *name)
 {
 	struct sw_sync_timeline *obj = (struct sw_sync_timeline *)
diff --git a/drivers/staging/android/sw_sync.h b/drivers/staging/android/sw_sync.h
index 1a50669..c87ae9e 100644
--- a/drivers/staging/android/sw_sync.h
+++ b/drivers/staging/android/sw_sync.h
@@ -50,7 +50,7 @@ static inline void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
 }
 
 static inline struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj,
-		u32 value)
+						u32 value)
 {
 	return NULL;
 }
-- 
1.9.1

