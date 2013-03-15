Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3COQyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:54:14 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32879 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3COQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:54:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/4] posix_cpu_timers: Some code consolidation v2
Date: Fri, 15 Mar 2013 17:53:58 +0100
Message-Id: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this version, just a few warnings fixed due to missing type updates. And also
a selftest for quick basic breakage checks.

The branch is pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/posix-cpu-timers

Thanks.

Frederic Weisbecker (4):
  posix_cpu_timer: Consolidate expiry time type
  posix_cpu_timers: Consolidate timer list cleanups
  posix_cpu_timers: Consolidate expired timers check
  selftests: Add basic posix timers selftests

 include/linux/posix-timers.h                  |   16 +-
 kernel/posix-cpu-timers.c                     |  390 +++++++++----------------
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/timers/Makefile       |    8 +
 tools/testing/selftests/timers/posix_timers.c |  221 ++++++++++++++
 5 files changed, 378 insertions(+), 258 deletions(-)
 create mode 100644 tools/testing/selftests/timers/Makefile
 create mode 100644 tools/testing/selftests/timers/posix_timers.c

-- 
1.7.5.4

