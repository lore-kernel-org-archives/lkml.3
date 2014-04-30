Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbaD3Mm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:42:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:42203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758830AbaD3Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:42:33 -0400
Message-Id: <20140430124231.162325790@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 08:41:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [for-next][PATCH 2/4] tracing: Fix documentation of ftrace_set_global_{filter,notrace}()
References: <20140430124153.334527053@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-documentation-of-ftrace_set_global_-filt.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaxing Wang <wangjiaxing@insigma.com.cn>

The functions ftrace_set_global_filter() and ftrace_set_global_notrace()
still have their old names in the kernel doc (ftrace_set_filter and
ftrace_set_notrace respectively). Replace these with the real names.

Link: http://lkml.kernel.org/p/1398006644-5935-3-git-send-email-wangjiaxing@insigma.com.cn

Signed-off-by: Jiaxing Wang <wangjiaxing@insigma.com.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3cfeb66..34b098bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3542,8 +3542,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
- * ftrace_set_filter - set a function to filter on in ftrace
- * @ops - the ops to set the filter with
+ * ftrace_set_global_filter - set a function to filter on with global tracers
  * @buf - the string that holds the function filter text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -3558,8 +3557,7 @@ void ftrace_set_global_filter(unsigned char *buf, int len, int reset)
 EXPORT_SYMBOL_GPL(ftrace_set_global_filter);
 
 /**
- * ftrace_set_notrace - set a function to not trace in ftrace
- * @ops - the ops to set the notrace filter with
+ * ftrace_set_global_notrace - set a function to not trace with global tracers
  * @buf - the string that holds the function notrace text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
-- 
1.8.5.3


