Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaJGDzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:55:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33177 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJGDzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:55:12 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
        kexec@lists.infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] kexec: Remove unnecessary KERN_ERR from kexec.c
Date: Tue,  7 Oct 2014 12:54:58 +0900
Message-Id: <1412654098-31847-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.1.273.g97b8860
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_ERR from pr_err() within kexec.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2abf9f6..9a8a01a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -600,7 +600,7 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 	if (!kexec_on_panic) {
 		image->swap_page = kimage_alloc_control_pages(image, 0);
 		if (!image->swap_page) {
-			pr_err(KERN_ERR "Could not allocate swap buffer\n");
+			pr_err("Could not allocate swap buffer\n");
 			goto out_free_control_pages;
 		}
 	}
-- 
2.1.1.273.g97b8860

