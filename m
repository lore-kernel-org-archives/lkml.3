Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3GOIdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:33:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47427 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3GOIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:33:49 -0400
Message-ID: <51E3B396.8030905@huawei.com>
Date: Mon, 15 Jul 2013 16:32:22 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] tracing: some minor fix
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This patchset don't have big change on tracing, just three minor fix,
please check it.

Thanks.

zhangwei(Jovi) (3):
  tracing: use correct config guard CONFIG_STACK_TRACER
  tracing: use trace_seq_puts()/trace_seq_putc() where possible
  tracing: update typo of ring buffer comments

 kernel/trace/ring_buffer.c           |   26 +++++++++--------
 kernel/trace/trace.c                 |    4 +--
 kernel/trace/trace_events_filter.c   |    4 +--
 kernel/trace/trace_functions_graph.c |   52 +++++++++++++++++-----------------
 kernel/trace/trace_mmiotrace.c       |    8 +++---
 kernel/trace/trace_output.c          |   14 ++++-----
 kernel/trace/trace_syscalls.c        |    2 +-
 7 files changed, 56 insertions(+), 54 deletions(-)

-- 
1.7.9.7


