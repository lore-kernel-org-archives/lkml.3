Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaDTPMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 11:12:18 -0400
Received: from mx.insigma.com.cn ([115.236.48.170]:46953 "EHLO
	WX-Ex2010Edge01.insigma.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755463AbaDTPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 11:11:56 -0400
From: Jiaxing Wang <wangjiaxing@insigma.com.cn>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [PATCH 2/2] Correct documentation of ftrace_set_global_filter and ftrace_set_global_notrace
Date: Sun, 20 Apr 2014 23:10:44 +0800
Message-ID: <1398006644-5935-3-git-send-email-wangjiaxing@insigma.com.cn>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
References: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [120.40.72.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiaxing Wang <wangjiaxing@insigma.com.cn>
---
 kernel/trace/ftrace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e7e7302..57cdaba 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3644,8 +3644,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
- * ftrace_set_filter - set a function to filter on in ftrace
- * @ops - the ops to set the filter with
+ * ftrace_set_global_filter - set a function to filter on with global tracers
  * @buf - the string that holds the function filter text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -3660,8 +3659,7 @@ void ftrace_set_global_filter(unsigned char *buf, int len, int reset)
 EXPORT_SYMBOL_GPL(ftrace_set_global_filter);
 
 /**
- * ftrace_set_notrace - set a function to not trace in ftrace
- * @ops - the ops to set the notrace filter with
+ * ftrace_set_global_notrace - set a function to not trace with global tracers
  * @buf - the string that holds the function notrace text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
-- 
1.8.3.2

