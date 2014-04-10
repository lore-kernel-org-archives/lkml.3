Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935688AbaDJSvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:51:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56153 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbaDJSvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:51:42 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com, davidlohr@hp.com
Subject: [PATCH 09/15] ipc:util.h Unnecessary space Removed
Date: Thu, 10 Apr 2014 19:51:38 +0100
Message-Id: <1397155898-6732-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Unnecessary space before function pointer arguments

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/util.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index 0dbb554..e426d42 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -78,9 +78,9 @@ struct ipc_params {
  *      . routine to call for an extra check if needed
  */
 struct ipc_ops {
-	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
-	int (*associate) (struct kern_ipc_perm *, int);
-	int (*more_checks) (struct kern_ipc_perm *, struct ipc_params *);
+	int (*getnew)(struct ipc_namespace *, struct ipc_params *);
+	int (*associate)(struct kern_ipc_perm *, int);
+	int (*more_checks)(struct kern_ipc_perm *, struct ipc_params *);
 };
 
 struct seq_file;
-- 
1.8.3.2

