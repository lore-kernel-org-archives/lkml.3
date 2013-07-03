Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3GCLhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3GCLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:22 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IJMsW1jkZJwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3fwaw_eFWe4A:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=yRdj_GOoMAiOEVa5NvQA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113719.323009497@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 6/8] tracing: Remove TRACE_EVENT_TYPE enum definition
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Remove-TRACE_EVENT_TYPE-enum-definition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

TRACE_EVENT_TYPE enum is not used at present, remove it.

Link: http://lkml.kernel.org/r/1365564393-10972-8-git-send-email-jovi.zhangwei@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c7fbf93..1cbba04 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -907,12 +907,6 @@ static inline void trace_branch_disable(void)
 /* set ring buffers to default size if not already done so */
 int tracing_update_buffers(void);
 
-/* trace event type bit fields, not numeric */
-enum {
-	TRACE_EVENT_TYPE_PRINTF		= 1,
-	TRACE_EVENT_TYPE_RAW		= 2,
-};
-
 struct ftrace_event_field {
 	struct list_head	link;
 	const char		*name;
-- 
1.7.10.4


