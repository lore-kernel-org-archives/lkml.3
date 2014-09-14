Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaINATR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 20:19:17 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:29925 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaINATQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 20:19:16 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: android: ion: fix coding style
Date: Sat, 13 Sep 2014 17:19:13 -0700
Message-Id: <1410653953-4849-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_0
X-ZohoMail-Owner: <1410653953-4849-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add line after declaration
- remove return statement in empty void function

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
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
1.9.1


