Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbaCSWcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:32:36 -0400
Received: from mail.efficios.com ([78.47.125.74]:57763 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020AbaCSWbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:31:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH v6 2/3] Tracepoint API doc update: data argument
Date: Wed, 19 Mar 2014 18:31:01 -0400
Message-Id: <1395268262-31224-3-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the @data argument (probe private data).

Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to tracepoint callbacks"
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/tracepoint.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f27e5f0..2e4bfcb 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -370,6 +370,7 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @name: tracepoint name
  * @probe: probe handler
+ * @data: probe private data
  *
  * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
@@ -412,6 +413,7 @@ tracepoint_remove_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @name: tracepoint name
  * @probe: probe function pointer
+ * @data: probe private data
  *
  * We do not need to call a synchronize_sched to make sure the probes have
  * finished running before doing a module unload, because the module unload
-- 
1.7.10.4

