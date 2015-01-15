Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbAOEFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:05:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:43732 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750924AbbAOEFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:05:08 -0500
Message-Id: <20150115040407.859948617@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 23:04:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] tracing: A couple of fixes
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bugs have been reported and this fixes them. I'll be testing them
a bit more before pushing them to Linus.


Steven Rostedt (Red Hat) (2):
      tracing: Remove extra call to init_ftrace_syscalls()
      tracing: Fix enabling of syscall events on the command line

----
 kernel/trace/trace.c        |  1 -
 kernel/trace/trace_events.c | 69 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 55 insertions(+), 15 deletions(-)
