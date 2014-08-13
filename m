Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaHMNKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:10:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53818 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHMNJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:09:59 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ccross@android.com, swetland@google.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, joe@perches.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, Phong Tran <tranmanphong@gmail.com>
Subject: [Patch V2 1/3] staging: android: ion: ion_dummy_driver.c Fix coding style
Date: Wed, 13 Aug 2014 20:09:38 +0700
Message-Id: <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warning
- Replace kzalloc() by kcalloc()
Tested by compilation.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 3a45e79..6d0a38a 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -68,7 +68,7 @@ static int __init ion_dummy_init(void)
 	int i, err;
 
 	idev = ion_device_create(NULL);
-	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
+	heaps = kcalloc(dummy_ion_pdata.nr, sizeof(struct ion_heap *),
 			GFP_KERNEL);
 	if (!heaps)
 		return -ENOMEM;
-- 
1.9.3

