Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaGQOrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:47:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:63074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933051AbaGQOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:53 -0400
Message-Id: <20140717144707.625978566@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/7] tracing: ->filter cleanups
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 6355d54438bfc3b636cb6453cd091f782fb9b4d7


Oleg Nesterov (7):
      tracing: Kill destroy_preds() and destroy_file_preds()
      tracing: Kill destroy_call_preds()
      tracing: Kill call_filter_disable()
      tracing/uprobes: Kill the dead TRACE_EVENT_FL_USE_CALL_FILTER logic
      tracing: Kill ftrace_event_call->files
      tracing: Change apply_subsystem_event_filter() paths to check file->system == dir
      tracing: Kill "filter_string" arg of replace_preds()

----
 include/linux/ftrace_event.h       |  3 --
 kernel/trace/trace_events.c        |  4 +--
 kernel/trace/trace_events_filter.c | 73 +++++++++-----------------------------
 kernel/trace/trace_uprobe.c        |  3 +-
 4 files changed, 19 insertions(+), 64 deletions(-)
