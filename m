Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3LINKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:10:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:57434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562Ab3LINKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:10:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="449172775"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/4] perf tools: Pedantic fixes for mmap_pages
Date: Mon,  9 Dec 2013 15:18:36 +0200
Message-Id: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some pedantic fixes for mmap_pages.


Adrian Hunter (4):
      perf tools: Remove unnecessary parentheses
      perf tools: Fix max mmap_pages
      perf tools: Fix mmap pages rounding to power of 2
      perf tools: Fix display of incorrect mmap pages

 tools/perf/builtin-record.c |  2 +-
 tools/perf/util/evlist.c    | 10 ++++++----
 tools/perf/util/util.h      | 12 ++++++++++++
 3 files changed, 19 insertions(+), 5 deletions(-)


Regards
Adrian
