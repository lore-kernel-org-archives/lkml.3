Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaC0EyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:6063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaC0EyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="500618820"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/5] tracing: Hash triggers
Date: Wed, 26 Mar 2014 23:54:02 -0500
Message-Id: <cover.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

This is my current code for the hash triggers mentioned in the other
thread.

I've been using it for a project here, and as such it works fine for
me, but it's nowhere near anything like a mergeable state; I'm only
sending/posting it because I didn't realize until today that you were
presenting on triggers at Collab Summit, and if as mentioned you're
thinking of adding a bullet or two for it wrt future/3.16 work, it
might be useful to have the code to play around with too...

Tom

The following changes since commit f217c44ebd41ce7369d2df07622b2839479183b0:

  Merge tag 'trace-fixes-v3.14-rc7-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2014-03-26 09:09:18 -0700)

are available in the git repository at:


  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/hashtriggers-v0
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/hashtriggers-v0

Tom Zanussi (5):
  tracing: Make ftrace_event_field checking functions available
  tracing: Add event record param to trigger_ops.func()
  tracing: Add get_syscall_name()
  tracing: Add hash trigger to Documentation
  tracing: Add 'hash' event trigger command

 Documentation/trace/events.txt      |   81 ++
 include/linux/ftrace_event.h        |    8 +-
 kernel/trace/trace.h                |   27 +-
 kernel/trace/trace_events_filter.c  |   15 +-
 kernel/trace/trace_events_trigger.c | 1439 ++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_syscalls.c       |   11 +
 6 files changed, 1546 insertions(+), 35 deletions(-)

-- 
1.8.3.1

