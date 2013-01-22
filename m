Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3AVWHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:07:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52690 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3AVWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:07:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Tue, 22 Jan 2013 19:07:15 -0300
Message-Id: <1358892435-21945-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	Please consider pulling, reusing the perf-urgent-for-mingo signed tag
I used when requesting Ingo to pull this a week or so ago,

Best Regards,

- Arnaldo

The following changes since commit 5c49985c21bba4d2f899e3a97121868a5c58a876:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2013-01-09 08:58:57 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to acb8fb04b74e1c26117b89945dc058b52b28ccb9:

  perf tools: Fix building from 'make perf-*-src-pkg' tarballs (2013-01-10 16:03:26 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. revert 20b279 - require exclude_guest to use PEBS - kernel side,
  now older binaries will continue working for things like cycles:pp
  without needing to pass extra modifiers, from David Ahern.

. Fix building from 'make perf-*-src-pkg' tarballs, broken by UAPI, from
  Sebastian Andrzej Siewior

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (1):
      perf x86: revert 20b279 - require exclude_guest to use PEBS - kernel side

Sebastian Andrzej Siewior (1):
      perf tools: Fix building from 'make perf-*-src-pkg' tarballs

 arch/x86/kernel/cpu/perf_event.c |    6 ------
 tools/perf/MANIFEST              |   10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)
