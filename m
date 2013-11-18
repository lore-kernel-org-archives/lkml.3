Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3KRJs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:48:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:2056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3KRJsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:48:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="435266884"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/4] perf record: Make per-cpu mmaps the default.
Date: Mon, 18 Nov 2013 11:55:53 +0200
Message-Id: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are patches to use per-cpu mmaps
by default as requested by Ingo and Peter.


Adrian Hunter (4):
      perf record: Make per-cpu mmaps the default.
      perf tools: Allow '--inherit' as the negation of '--no-inherit'
      perf tools: Add option macro OPT_BOOLEAN_SET
      perf record: Default -t option to no inheritance

 tools/perf/Documentation/perf-record.txt     | 12 +++++++-----
 tools/perf/builtin-record.c                  | 13 +++++++++----
 tools/perf/perf.h                            |  1 +
 tools/perf/tests/attr/test-record-no-inherit |  2 +-
 tools/perf/util/evlist.c                     |  6 ++++--
 tools/perf/util/evsel.c                      |  5 +++--
 tools/perf/util/parse-options.c              | 21 +++++++++++++++++++++
 tools/perf/util/parse-options.h              |  8 ++++++++
 tools/perf/util/target.c                     | 11 ++++++++++-
 tools/perf/util/target.h                     |  4 +++-
 10 files changed, 67 insertions(+), 16 deletions(-)


Regards
Adrian Hunter
