Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaDOPFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:05:35 -0400
Received: from mail.efficios.com ([78.47.125.74]:56089 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDOPFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:05:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Fix: tracing: use 'E' instead of 'X' for unsigned module tain flag
Date: Tue, 15 Apr 2014 11:05:16 -0400
Message-Id: <1397574316-518-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following commit:

commit 57673c2b0baa900dddae3b9eb3d7748ebf550eb3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 31 14:39:57 2014 +1030

    Use 'E' instead of 'X' for unsigned module taint flag.

One site has been forgotten in trace events module.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/trace/events/module.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 11fd51b..ed0b2c5 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -25,7 +25,7 @@ struct module;
 	{ (1UL << TAINT_OOT_MODULE),		"O" },		\
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
 	{ (1UL << TAINT_CRAP),			"C" },		\
-	{ (1UL << TAINT_UNSIGNED_MODULE),	"X" })
+	{ (1UL << TAINT_UNSIGNED_MODULE),	"E" })
 
 TRACE_EVENT(module_load,
 
-- 
1.7.10.4

