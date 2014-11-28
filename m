Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaK1V2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:28:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:58296 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaK1V2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:28:52 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Fri, 28 Nov 2014 18:28:42 -0300
Message-Id: <1417210123-19500-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 7ddc6a2199f1da405a2fb68c40db8899b1a8cd87:

  x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs (2014-11-25 07:26:55 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo

for you to fetch changes up to f61ff6c06dc8f32c7036013ad802c899ec590607:

  perf session: Do not fail on processing out of order event (2014-11-28 18:19:37 -0300)

----------------------------------------------------------------
perf/urgent fix:

* Do not stop processing when out of order events are detected, just count them
  and notify the user about it after processing all events. (Jiri Olsa)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Jiri Olsa (1):
      perf session: Do not fail on processing out of order event

 tools/perf/util/event.h   |  1 +
 tools/perf/util/session.c | 11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)
