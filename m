Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbaDJSuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:50:07 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57923 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbaDJSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:50:00 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 07/15] ipc:util.c whitespace
Date: Thu, 10 Apr 2014 19:49:56 +0100
Message-Id: <1397155796-6624-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 2eb0d1e..00bd4f5 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -183,7 +183,7 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
  * ipc_findkey	- find a key in an ipc identifier set
  * @ids: ipc identifier set
  * @key: key to find
- *	
+ *
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
@@ -538,7 +538,7 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
-	if ((requested_mode & ~granted_mode & 0007) && 
+	if ((requested_mode & ~granted_mode & 0007) &&
 	    !ns_capable(ns->user_ns, CAP_IPC_OWNER))
 		return -1;
 
-- 
1.8.3.2

