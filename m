Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaF3Vvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:51:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:5061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447AbaF3Vvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:45 -0400
Message-Id: <20140630215038.852406012@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 30 Jun 2014 17:50:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 0/4] [3.16] tracing/uprobes: Fixes
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: fb6bab6a5ad46d00b5ffa22268f21df1cd7c59df


Oleg Nesterov (4):
      tracing/uprobes: Revert "Support mix of ftrace and perf"
      uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
      tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in uprobe_dispatcher()
      tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_event_enable()

----
 kernel/events/uprobes.c     |  6 +++---
 kernel/trace/trace_uprobe.c | 46 ++++++++++++++++++++++++++-------------------
 2 files changed, 30 insertions(+), 22 deletions(-)
