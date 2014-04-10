Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbaDJS4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:56:00 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38652 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049AbaDJSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:55:54 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 15/15] kernel:auditfilter no space
Date: Thu, 10 Apr 2014 19:55:51 +0100
Message-Id: <1397156151-7023-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: please, no space before tabs

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 kernel/auditfilter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 92062fd..82894b5 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -37,13 +37,13 @@
  * Locking model:
  *
  * audit_filter_mutex:
- * 		Synchronizes writes and blocking reads of audit's filterlist
- * 		data.  Rcu is used to traverse the filterlist and access
- * 		contents of structs audit_entry, audit_watch and opaque
- * 		LSM rules during filtering.  If modified, these structures
- * 		must be copied and replace their counterparts in the filterlist.
- * 		An audit_parent struct is not accessed during filtering, so may
- * 		be written directly provided audit_filter_mutex is held.
+ *		Synchronizes writes and blocking reads of audit's filterlist
+ *		data.  Rcu is used to traverse the filterlist and access
+ *		contents of structs audit_entry, audit_watch and opaque
+ *		LSM rules during filtering.  If modified, these structures
+ *		must be copied and replace their counterparts in the filterlist.
+ *		An audit_parent struct is not accessed during filtering, so may
+ *		be written directly provided audit_filter_mutex is held.
  */
 
 /* Audit filter lists, defined in <linux/audit.h> */
-- 
1.8.3.2

