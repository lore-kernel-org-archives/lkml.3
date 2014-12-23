Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaLWPcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:32:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:38161 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaLWPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:32:50 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes and improvements
Date: Tue, 23 Dec 2014 12:32:40 -0300
Message-Id: <1419348763-29118-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit ac931f87a647ca156f65a4c00e7297165e4fa2d8:

  perf: Fix building warning on ARM 32 (2014-12-19 13:09:43 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo

for you to fetch changes up to 82aa019e0098a1e0801df94345c0297448323126:

  perf callchain: Append callchains only when requested (2014-12-23 12:06:39 -0300)

----------------------------------------------------------------
perf/urgent fixes and improvements:

User visible:

- Show progress bar in more places while doing histogram processing
  in the hists browser (Namhyung Kim)

- Print backtrace symbols when segfault occurs in 'report' (Namhyung Kim)

Infrastructure:

- Append callchains only when requested (Namhyung Kim)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (3):
      perf report: Show progress bar for output resorting
      perf ui/tui: Print backtrace symbols when segfault occurs
      perf callchain: Append callchains only when requested

 tools/perf/builtin-annotate.c     |  2 +-
 tools/perf/builtin-diff.c         |  2 +-
 tools/perf/builtin-report.c       | 24 ++++++++++++++++++++++--
 tools/perf/builtin-top.c          |  4 ++--
 tools/perf/tests/hists_cumulate.c |  2 +-
 tools/perf/tests/hists_filter.c   |  2 +-
 tools/perf/tests/hists_output.c   | 10 +++++-----
 tools/perf/ui/tui/setup.c         | 26 ++++++++++++++++++++++++--
 tools/perf/util/hist.c            | 17 +++++++++++++----
 tools/perf/util/hist.h            |  2 +-
 10 files changed, 71 insertions(+), 20 deletions(-)
