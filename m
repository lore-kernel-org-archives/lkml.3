Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3C0Jti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45190 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3C0Jte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:34 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 08/14] tracing: remove TRACE_EVENT_TYPE enum definition
Date: Wed, 27 Mar 2013 17:48:50 +0800
Message-ID: <1364377737-10540-10-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

TRACE_EVENT_TYPE enum is not used at present, remove it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ff28b5a..398ff9e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -794,12 +794,6 @@ static inline void trace_branch_disable(void)
 /* set ring buffers to default size if not already done so */
 int tracing_update_buffers(void);
 
-/* trace event type bit fields, not numeric */
-enum {
-	TRACE_EVENT_TYPE_PRINTF		= 1,
-	TRACE_EVENT_TYPE_RAW		= 2,
-};
-
 struct event_filter {
 	int			n_preds;	/* Number assigned */
 	int			a_preds;	/* allocated */
-- 
1.7.9.7


