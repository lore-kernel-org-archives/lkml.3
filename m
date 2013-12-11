Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3LKNrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:47:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59267 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:47:15 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] vfs, eventfd: fix the typo
Date: Wed, 11 Dec 2013 21:47:03 +0800
Message-Id: <1386769623-14366-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121113-0928-0000-0000-0000048CFE4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/eventfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..710bf80 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -45,7 +45,7 @@ struct eventfd_ctx {
  *
  * This function is supposed to be called by the kernel in paths that do not
  * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returining a POLLERR
+ * value, and we signal this as overflow condition by returning a POLLERR
  * to poll(2).
  *
  * Returns the amount by which the counter was incrememnted.  This will be less
-- 
1.7.6.5

