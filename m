Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbaDJSvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:51:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46184 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbaDJSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:51:02 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com, davidlohr@hp.com
Subject: [PATCH 08/15] ipc:util.h whitespace Removed
Date: Thu, 10 Apr 2014 19:50:58 +0100
Message-Id: <1397155858-6686-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/util.h b/ipc/util.h
index 9c47d6f..0dbb554 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -142,7 +142,7 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
-  /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
+/* On IA-64, we always use the "64-bit version" of the IPC structures.  */
 # define ipc_parse_version(cmd)	IPC_64
 #else
 int ipc_parse_version(int *cmd);
-- 
1.8.3.2

