Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaJTQnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:43:17 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:49087 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaJTQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:43:14 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "spaces required around that '='" errors
Date: Mon, 20 Oct 2014 11:42:36 -0500
Message-Id: <1413823356-13779-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "spaces required around that '='" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/llite/super25.c   | 2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
index e61dbed..6aff155 100644
--- a/drivers/staging/lustre/lustre/llite/super25.c
+++ b/drivers/staging/lustre/lustre/llite/super25.c
@@ -162,7 +162,7 @@ static int __init init_lustre_lite(void)
 
 	/* Nodes with small feet have little entropy
 	 * the NID for this node gives the most entropy in the low bits */
-	for (i=0; ; i++) {
+	for (i = 0; ; i++) {
 		if (LNetGetId(i, &lnet_id) == -ENOENT) {
 			break;
 		}
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index c314e9c..540ff4e 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -317,7 +317,7 @@ struct obd_device *class_newdev(const char *type_name, const char *name)
 					 result->obd_minor, new_obd_minor);
 
 				obd_devs[result->obd_minor] = NULL;
-				result->obd_name[0]='\0';
+				result->obd_name[0] = '\0';
 			 }
 			result = ERR_PTR(-EEXIST);
 			break;
-- 
1.9.1

