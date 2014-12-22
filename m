Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaLVEnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:43:42 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50435 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaLVEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:43:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCHSET 0/7] perf tools: A small random cleanup and fixups
Date: Mon, 22 Dec 2014 13:44:08 +0900
Message-Id: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a just random collection of small cleanup and fixes that was
needed (or found) for my work.  I'd like to share it before posting
the real work as it's independent change and the work can be quite
large.. ;-)

Thanks,
Namhyung


Namhyung Kim (7):
  perf report: Get rid of report__inc_stat()
  perf report: Show progress bar for output resorting
  perf ui/tui: Print backtrace symbols when segfault occurred
  perf diff: Fix to sort by baseline field by default
  perf diff: Get rid of hists__compute_resort()
  perf tools: Append callchains only when requested
  perf tools: Set attr.task bit for a tracking event

 tools/perf/builtin-annotate.c     |  2 +-
 tools/perf/builtin-diff.c         | 84 +++++++++++++++++++--------------------
 tools/perf/builtin-report.c       | 40 ++++++++++++-------
 tools/perf/builtin-top.c          |  4 +-
 tools/perf/tests/hists_cumulate.c |  2 +-
 tools/perf/tests/hists_filter.c   |  2 +-
 tools/perf/tests/hists_output.c   | 10 ++---
 tools/perf/ui/tui/setup.c         | 26 +++++++++++-
 tools/perf/util/evsel.c           |  1 +
 tools/perf/util/hist.c            | 19 +++++++--
 tools/perf/util/hist.h            |  2 +-
 11 files changed, 116 insertions(+), 76 deletions(-)

-- 
2.1.3

