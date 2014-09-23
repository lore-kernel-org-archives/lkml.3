Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaIWGPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:15:07 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:29621 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaIWGPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:15:05 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        ccross@android.com, mitchelh@codeaurora.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: android: ion: Add blank line after variable declaration
Date: Mon, 22 Sep 2014 23:14:52 -0700
Message-Id: <1411452892-4786-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_18094_2
X-ZohoMail-Owner: <1411452892-4786-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl warning:

WARNING: Missing a blank line after declarations

Signed-off-by: Sorin Facaoaru <work@sorin.cc> 
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
1.9.1


