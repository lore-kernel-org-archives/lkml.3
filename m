Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaGWS1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:27:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37590 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaGWS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:27:09 -0400
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: android: ion: fix missing a blank line after declarations
Date: Thu, 24 Jul 2014 02:26:50 +0800
Message-Id: <1406140014-22803-1-git-send-email-wangchao19890207@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning of missing a blank line after declarations,
found under drivers/staging/android/ion/.

Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
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

