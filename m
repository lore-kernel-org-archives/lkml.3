Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3CKHOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:35 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26619 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3CKHOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:32 -0400
Message-ID: <513D842A.2000907@huawei.com>
Date: Mon, 11 Mar 2013 15:13:46 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 04/13] tracing: make trace_destroy_fields as static
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_destroy_fields is not used outside, make it as static.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 85e6ff5..0626792 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -147,7 +147,7 @@ static int trace_define_common_fields(void)
 	return ret;
 }

-void trace_destroy_fields(struct ftrace_event_call *call)
+static void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
 	struct list_head *head;
-- 
1.7.9.7


