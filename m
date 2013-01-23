Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3AWUeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:34:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3AWUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:34 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JvwOx7J4J3MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gwj_eQpz6jIA:10 a=20KFwNOVAAAA:8 a=_niWYe1L8QWXoFqC6TYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203433.412993927@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/12 -next] tracing: Remove trace.h header from trace_clock.c
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Remove-trace.h-header-from-trace_clock.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As trace_clock is used by other things besides tracing, and it
does not require anything from trace.h, it is best not to include
the header file in trace_clock.c.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 3947835..22b638b 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -21,8 +21,6 @@
 #include <linux/ktime.h>
 #include <linux/trace_clock.h>
 
-#include "trace.h"
-
 /*
  * trace_clock_local(): the simplest and least coherent tracing clock.
  *
-- 
1.7.10.4


