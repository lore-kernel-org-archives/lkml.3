Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3LFHfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:35:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:4740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3LFHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:35:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="447839353"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH V2 0/3] perf script: Add an option to print the source line number
Date: Fri,  6 Dec 2013 09:42:55 +0200
Message-Id: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is perf script srcline printing.

Changes in V2:
	Also print scrline for callchains


Adrian Hunter (3):
      perf script: Fix symoff printing in callchains
      perf script: Add an option to print the source line number
      perf script: Improve srcline display for BTS

 tools/perf/Documentation/perf-script.txt |  2 +-
 tools/perf/builtin-script.c              | 30 +++++++++++++++++++++++++-----
 tools/perf/util/map.c                    | 17 +++++++++++++++++
 tools/perf/util/map.h                    |  2 ++
 tools/perf/util/session.c                | 15 ++++++++++++++-
 tools/perf/util/session.h                |  1 +
 6 files changed, 60 insertions(+), 7 deletions(-)


Regards
Adrian

