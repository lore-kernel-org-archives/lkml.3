Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaKCV3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:29:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:52678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855AbaKCV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:28:43 -0500
Message-Id: <20141103212841.987650695@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 03 Nov 2014 16:27:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 3/4 v2] ftracetest: Add helper reset_tracer() function
References: <20141103212737.696365174@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftracetest-Add-helper-reset_tracer-function.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a helper function reset_tracer() that will clear the current_tracer
(echo nop > current_tracer).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/test.d/functions | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index c5bf630e9be8..5d8cd06d920f 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -10,3 +10,7 @@ disable_tracing() { # stop trace recording
 enable_tracing() { # start trace recording
     echo 1 > tracing_on
 }
+
+reset_tracer() { # reset the current tracer
+    echo nop > current_tracer
+}
-- 
2.1.1


