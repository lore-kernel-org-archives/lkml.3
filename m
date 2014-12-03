Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaLCWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:13:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54305 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752244AbaLCWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:55 -0500
Message-Id: <20141203221351.632914199@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 03 Dec 2014 17:13:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [for-next][PATCH 3/5] Documentation: describe trace_buf_size parameter more accurately
References: <20141203221311.563559646@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-Documentation-describe-trace_buf_size-parameter-more.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I'm stuck into panic that too litte free memory is left when I boot with
trace_buf_size parameter. After digging into the problem, I found that
trace_buf_size is the size of trace buffer on each cpu rather than total
size of trace buffer. To prevent victim like me, change description of
trace_buf_size parameter more accurately.

Link: http://lkml.kernel.org/r/1417570760-10620-1-git-send-email-iamjoonsoo.kim@lge.com

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7dbe5ec9d9cd..1d09eb37c562 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3477,7 +3477,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			are saved.
 
 	trace_buf_size=nn[KMG]
-			[FTRACE] will set tracing buffer size.
+			[FTRACE] will set tracing buffer size on each cpu.
 
 	trace_event=[event-list]
 			[FTRACE] Set and start specified trace events in order
-- 
2.1.3


