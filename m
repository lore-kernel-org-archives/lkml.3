Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3LMIxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:53:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:54371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3LMIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:53:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,477,1384329600"; 
   d="scan'208";a="449437390"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf tools: Fix next_pow2_l()
Date: Fri, 13 Dec 2013 10:53:34 +0200
Message-Id: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

My implementation of next_pow2_l() was incorrect.
Here is a fix, after which next_pow2() is unused
so I remove it and rename next_pow2_l() -> next_pow2()


Adrian Hunter (2):
      perf tools: Fix next_pow2_l()
      perf tools: Remove unused next_pow2() and rename next_pow2_l()

 tools/perf/util/evlist.c |  2 +-
 tools/perf/util/util.h   | 22 ++++++++--------------
 2 files changed, 9 insertions(+), 15 deletions(-)


Regards
Adrian
