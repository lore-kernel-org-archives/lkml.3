Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaDTPLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 11:11:22 -0400
Received: from mx.insigma.com.cn ([115.236.48.170]:46864 "EHLO
	WX-Ex2010Edge01.insigma.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755201AbaDTPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 11:11:16 -0400
From: Jiaxing Wang <wangjiaxing@insigma.com.cn>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jiaxing Wang <wangjiaxing@insigma.com.cn>
Subject: [PATCH 0/2] Stack trace fix and ftrace documentation fixes
Date: Sun, 20 Apr 2014 23:10:42 +0800
Message-ID: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [120.40.72.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch makes trace_stack to skip 4 instead of 3 function 
return addresses on the stack when ftrace_ops_list_func is used in ftrace,
and added a function to check for this.

The second correct the documentation of two functions in ftrace.c

Jiaxing Wang (2):
  tracing/trace_stack:Skip 4 instead of 3 when using
    ftrace_ops_list_func
  Correct documentation of ftrace_set_global_filter and
    ftrace_set_global_notrace

 kernel/trace/ftrace.c      | 11 +++++++----
 kernel/trace/trace.h       |  1 +
 kernel/trace/trace_stack.c |  8 ++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

-- 
1.8.3.2

