Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaDPAz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:55:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51398 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaDPAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:55:24 -0400
From: Thomas Tanaka <thomas.tanaka@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jg1.han@samsung.com, akpm@linux-foundation.org, keescook@chromium.org,
        peter.p.waskiewicz.jr@intel.com, bernat.ada@gmail.com,
        thomas.tanaka@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgrp: Fixed coding style
Date: Tue, 15 Apr 2014 17:54:39 -0700
Message-Id: <1397609680-10321-1-git-send-email-thomas.tanaka@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed line width > 80

Signed-off-by: Thomas Tanaka <thomas.tanaka@gmail.com>
---
 drivers/staging/dgrp/dgrp_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index 2f9345f..93803e0c 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -108,8 +108,8 @@ int dgrp_create_class_sysfs_files(void)
 	ret = sysfs_create_group(&dgrp_class_global_settings_dev->kobj,
 		&dgrp_global_settings_attribute_group);
 	if (ret) {
-		pr_alert("%s: failed to create sysfs global settings device attributes.\n",
-			__func__);
+		pr_alert("%s: failed to create sysfs global settings device
+			 attributes.\n", __func__);
 		goto err_dev1;
 	}
 
-- 
1.7.9.5

