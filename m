Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaCMPdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:33:20 -0400
Received: from mail.efficios.com ([78.47.125.74]:56227 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaCMPdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:33:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/3] Tracepoint API doc update: data argument
Date: Thu, 13 Mar 2014 11:32:58 -0400
Message-Id: <1394724779-17892-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394724779-17892-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1394724779-17892-1-git-send-email-mathieu.desnoyers@efficios.com>
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
index 0faf2a4..cc6c8b6 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -373,6 +373,7 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @name: tracepoint name
  * @probe: probe handler
+ * @data: probe private data
  *
  * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
@@ -415,6 +416,7 @@ tracepoint_remove_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @name: tracepoint name
  * @probe: probe function pointer
+ * @data: probe private data
  *
  * We do not need to call a synchronize_sched to make sure the probes have
  * finished running before doing a module unload, because the module unload
-- 
1.7.10.4

