Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3KOTrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:47:09 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64377 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KOTrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:47:02 -0500
Date: Fri, 15 Nov 2013 20:46:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131115194655.GA25517@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 89b4be142bf2491a94af325f5206fc2f2aa18960 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Tooling changes only: it includes the ARM tooling fixlets, various 
other fixes, smaller updates, minor cleanups.

 Thanks,

	Ingo

------------------>

Adrian Hunter (1):
      perf record: Add an option to force per-cpu mmaps

Arnaldo Carvalho de Melo (4):
      perf tools: Use perf_evlist__{first,last}, perf_evsel__next
      perf evsel: Introduce perf_evsel__prev() method
      perf symbols: Limit max callchain using max_stack on DWARF unwinding too
      perf ui browser: Fix segfault caused by off by one handling END key

Azat Khuzhin (1):
      perf probe: Add '--demangle'/'--no-demangle'

Davidlohr Bueso (1):
      perf tools: Remove trivial extra semincolon

Don Zickus (1):
      perf tools: Synthesize anon MMAP records again

Ingo Molnar (5):
      Merge branch 'linus' into perf/urgent
      tools/perf/build: Fix timerfd feature check
      tools/perf/build: Fix feature-libunwind-debug-frame handling
      perf top: Add missing newline if the 'uid' is invalid
      Merge tag 'perf-core-for-mingo' of git://git.kernel.org/.../acme/linux into perf/urgent

Pekka Enberg (1):
      perf trace: Tweak summary output


 tools/perf/Documentation/perf-record.txt    |  6 ++++++
 tools/perf/builtin-probe.c                  |  2 ++
 tools/perf/builtin-record.c                 |  2 ++
 tools/perf/builtin-top.c                    |  4 ++--
 tools/perf/builtin-trace.c                  | 10 +++++-----
 tools/perf/config/Makefile                  | 14 ++++++++++----
 tools/perf/config/feature-checks/Makefile   |  3 +++
 tools/perf/config/feature-checks/test-all.c |  4 ----
 tools/perf/tests/parse-events.c             |  3 +--
 tools/perf/ui/browser.c                     |  4 ++--
 tools/perf/ui/browsers/hists.c              | 11 +++++------
 tools/perf/util/event.c                     |  6 ++++--
 tools/perf/util/evlist.c                    |  6 ++++--
 tools/perf/util/evsel.c                     |  4 ++--
 tools/perf/util/evsel.h                     |  5 +++++
 tools/perf/util/machine.c                   |  2 +-
 tools/perf/util/target.h                    |  1 +
 tools/perf/util/unwind.c                    |  9 +++++----
 tools/perf/util/unwind.h                    |  5 +++--
 19 files changed, 63 insertions(+), 38 deletions(-)

