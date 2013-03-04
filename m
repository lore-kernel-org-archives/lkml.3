Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3CDR0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:26:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280Ab3CDR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:17 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sSc0fecf9_cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=N656L0LLZN0A:10 a=VWPjUcXQO52KabcQzpsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172005.362537932@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 0/6] tracing: memory savings and minor fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more updates to the linux-next queue for 3.10. Li Zefan did a few
updates to save a bit of kernel memory.

I did a few minor fixes to the previous patchset I sent out.

-- Steve

Li Zefan (4):
      tracing: Add a helper function for event print functions
      tracing: Annotate event field-defining functions with __init
      tracing/syscalls: Annotate field-defining functions with __init
      tracing: Fix some section mismatch warninings

Steven Rostedt (Red Hat) (2):
      tracing: Add __per_cpu annotation to trace array percpu data pointer
      tracing: Fix trace events build without modules

----
 include/linux/ftrace_event.h  |    8 ++++--
 include/trace/ftrace.h        |   27 ++++++--------------
 kernel/trace/trace.h          |    2 +-
 kernel/trace/trace_events.c   |   55 +++++++++++++++++++++++++++--------------
 kernel/trace/trace_export.c   |    4 +--
 kernel/trace/trace_output.c   |   26 +++++++++++++++++++
 kernel/trace/trace_syscalls.c |    8 +++---
 7 files changed, 83 insertions(+), 47 deletions(-)
