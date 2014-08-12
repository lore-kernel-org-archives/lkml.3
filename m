Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaHLPG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:06:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:20192 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaHLPG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,849,1400050800"; 
   d="scan'208";a="575602958"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/4] perf tools: API probing fixes
Date: Tue, 12 Aug 2014 18:04:27 +0300
Message-Id: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes for API probing issues that I have run into,
and a second attempt at the jump-label problem.

Patches apply to your tmp.perf/core branch.


Adrian Hunter (4):
      perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
      perf tools: Fix one of the probe events to exclude kernel
      perf tools: Fix probing the kernel API with cpu-wide events
      perf tools: Prefer to use a cpu-wide event for probing CLOEXEC


Regards
Adrian
