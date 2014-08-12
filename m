Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaHLQSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:18:36 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33139 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaHLQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:18:33 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, ccross@android.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 1/5] staging: android: ion: ion.c Fix checkpatch warning
Date: Tue, 12 Aug 2014 23:17:26 +0700
Message-Id: <1407860250-9779-2-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the coding style

- Add a new line after variable declaration
- Remove return of void fuction

Tested by compilation

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 2703609..56604f4 100644
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
@@ -1056,7 +1057,6 @@ static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
 			       void *ptr)
 {
-	return;
 }
 
 static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start,
-- 
1.9.3

