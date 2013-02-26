Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3BZOys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:54:48 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46941 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3BZOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:54:47 -0500
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] Staging: silicom: bp_mod: Removed trailing whitespaces
Date: Tue, 26 Feb 2013 16:53:16 +0200
Message-Id: <1361890396-5822-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/staging/silicom/bp_mod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bp_mod.c b/drivers/staging/silicom/bp_mod.c
index 58c5f5c..61a912d 100644
--- a/drivers/staging/silicom/bp_mod.c
+++ b/drivers/staging/silicom/bp_mod.c
@@ -6983,7 +6983,7 @@ static void __exit bypass_cleanup_module(void)
 /*	spin_lock_irqsave(&bpvm_lock, flags);
 	rcu_read_lock(); */
 		bypass_proc_remove_dev_sd(&bpctl_dev_arr[i]);
-/*	spin_unlock_irqrestore(&bpvm_lock, flags);        
+/*	spin_unlock_irqrestore(&bpvm_lock, flags);
 	rcu_read_unlock(); */
 #endif
 		remove_bypass_wd_auto(&bpctl_dev_arr[i]);
@@ -7006,7 +7006,7 @@ static void __exit bypass_cleanup_module(void)
 		kfree(bpctl_dev_arr);
 
 /*
-* Unregister the device                             
+* Unregister the device
 */
 	unregister_chrdev(major_num, DEVICE_NAME);
 }
-- 
1.7.9.5

