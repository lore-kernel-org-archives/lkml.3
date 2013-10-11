Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3JKAtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:49:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:23993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab3JKAtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1075,1371106800"; 
   d="scan'208";a="373211907"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v10 11/12] tracing: fix tracing_snapshot kerneldoc
Date: Thu, 10 Oct 2013 19:48:35 -0500
Message-Id: <af1e1b69b339a85e11f580af9c3ba6dfa28cb20f.1381445299.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The names of the functions are tracing_snapshot_*, not
trace_snapshot_* - fix up the kerneldoc to avoid confusion.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5aa8f80..81d95bf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -514,7 +514,7 @@ EXPORT_SYMBOL_GPL(__trace_bputs);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 /**
- * trace_snapshot - take a snapshot of the current buffer.
+ * tracing_snapshot - take a snapshot of the current buffer.
  *
  * This causes a swap between the snapshot buffer and the current live
  * tracing buffer. You can use this to take snapshots of the live
@@ -617,9 +617,9 @@ int tracing_alloc_snapshot(void)
 EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
 
 /**
- * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
+ * tracing_snapshot_alloc - allocate and take a snapshot of the current buffer.
  *
- * This is similar to trace_snapshot(), but it will allocate the
+ * This is similar to tracing_snapshot(), but it will allocate the
  * snapshot buffer if it isn't already allocated. Use this only
  * where it is safe to sleep, as the allocation may sleep.
  *
-- 
1.7.11.4

