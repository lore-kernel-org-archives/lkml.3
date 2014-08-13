Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaHMNKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:10:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46008 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaHMNKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:10:02 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ccross@android.com, swetland@google.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, joe@perches.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, Phong Tran <tranmanphong@gmail.com>
Subject: [Patch V2 2/3] staging: android: ion: ion.c Fix coding style
Date: Wed, 13 Aug 2014 20:09:39 +0700
Message-Id: <1407935380-9324-2-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
 <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warning
- Add a new line after decleration
Tested by compilation.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 2703609..cad76ae 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -805,6 +805,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 						client, &debug_client_fops);
 	if (!client->debug_root) {
 		char buf[256], *path;
+
 		path = dentry_path(dev->clients_debug_root, buf, 256);
 		pr_err("Failed to create client debugfs at %s/%s\n",
 			path, client->display_name);
-- 
1.9.3

