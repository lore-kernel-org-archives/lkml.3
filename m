Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3LUWoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:44:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:47826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3LUWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,529,1384329600"; 
   d="scan'208";a="453969741"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/3] tracing: A few trace event triggers fixes
Date: Sat, 21 Dec 2013 16:43:59 -0600
Message-Id: <cover.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a few sparse warnings and build problems seen
under certain configurations, as uncovered by the kbuild test robot.

Applies to linux-trace.git ftrace/core.

The following changes since commit 611e9015501ab9597d6a43253813d4efd90936de:

  tracing: Add documentation for trace event triggers (2013-12-20 23:24:20 -0500)

are available in the git repository at:

  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/event-triggers-ftrace-core-kbuild-robot-fixes
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/event-triggers-ftrace-core-kbuild-robot-fixes

Tom Zanussi (3):
  tracing: Move tracing_alloc_snapshot() declaration to tracing.h
  tracing: Add and use event_trigger_lseek()
  tracing: Add rcu annotation for event_trigger_data.filter

 include/linux/kernel.h              |  2 --
 kernel/trace/trace.h                |  3 ++-
 kernel/trace/trace_events_trigger.c | 15 ++++++++++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

-- 
1.8.3.1

