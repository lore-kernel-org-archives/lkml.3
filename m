Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaINAN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 20:13:27 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:29886 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaINANZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 20:13:25 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: android: fix coding style
Date: Sat, 13 Sep 2014 17:13:20 -0700
Message-Id: <1410653600-4651-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_1
X-ZohoMail-Owner: <1410653600-4651-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add line after declaration

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
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
1.9.1


