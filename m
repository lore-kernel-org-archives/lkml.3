Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaIHNYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:24:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46168 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaIHNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:24:14 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH] xen/balloon: Remove unused pr_fmt() macro
Date: Mon,  8 Sep 2014 15:23:58 +0200
Message-Id: <1410182638-18820-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused pr_fmt() macro. Additionally, remove surplus empty
lines which left after earlier various fixes and cleanups.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/xen/balloon.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 5c660c7..08417b3 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -36,8 +36,6 @@
  * IN THE SOFTWARE.
  */
 
-#define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
-
 #include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -84,7 +82,6 @@ enum bp_state {
 	BP_ECANCELED
 };
 
-
 static DEFINE_MUTEX(balloon_mutex);
 
 struct balloon_stats balloon_stats;
@@ -94,7 +91,6 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
 static DEFINE_PER_CPU(struct page *, balloon_scratch_page);
 
-
 /* List of ballooned pages, threaded through the mem_map array. */
 static LIST_HEAD(ballooned_pages);
 
@@ -616,7 +612,6 @@ static int alloc_balloon_scratch_page(int cpu)
 	return 0;
 }
 
-
 static int balloon_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
-- 
1.7.10.4

