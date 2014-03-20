Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaCTDAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:00:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32197 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671AbaCTDAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:00:12 -0400
Message-Id: <20140320025831.285817697@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Mar 2014 22:58:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 0/4] tracing: More updates for 3.15
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor changes, but this includes updates from Mathieu Desnoyers for
fixing the documentation of the way the current code works in my next
repo. He's currently working on other ways to handle the changes, but
until that is ready, this will have to do.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: cb1deb5fc1fded22401c0e9ca6bda056a7f1b553


Jiri Slaby (1)
      ftrace: Fix compilation warning about control_ops_free

Mathieu Desnoyers (2)
      tracepoints: API doc update to data argument
      tracepoints: API doc update to tracepoint_probe_register() return value

Sasha Levin (1)
      ftrace: Constify ftrace_text_reserved

----
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   12 ++++++------
 kernel/tracepoint.c    |   16 +++++++++++++++-
 3 files changed, 23 insertions(+), 9 deletions(-)
