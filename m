Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbaGYOGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:06:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:40495 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760513AbaGYOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:06:14 -0400
Message-Id: <20140725140514.377803118@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 25 Jul 2014 10:05:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 0/4] ftrace: Fix the tramp count accounting
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Oleg Nesterov for pointing out some of the bugs.


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: dc6f03f26f570104a2bb03f9d1deb588026d7c75


Steven Rostedt (Red Hat) (4):
      ftrace: Rename ftrace_ops field from trampolines to nr_trampolines
      ring-buffer: Use rb_page_size() instead of open coded head_page size
      ftrace: Fix trampoline hash update check on rec->flags
      ftrace: Add warning if tramp hash does not match nr_trampolines

----
 include/linux/ftrace.h     |  2 +-
 kernel/trace/ftrace.c      | 21 ++++++++++++++++-----
 kernel/trace/ring_buffer.c |  2 +-
 3 files changed, 18 insertions(+), 7 deletions(-)
