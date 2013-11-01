Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3KAO5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:57:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3KAO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:57:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Fri,  1 Nov 2013 11:56:44 -0300
Message-Id: <1383317807-25062-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit e8a923cc1fff6e627f906655ad52ee694ef2f6d7:

  perf/x86: Fix NMI measurements (2013-10-29 12:01:20 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 46d525eae2a076adfde92dca1db12d9a3b8ad8bb:

  perf test: Update command line callchain attribute tests (2013-11-01 10:42:57 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix command line callchain attribute tests to handle the new
  -g/--call-chain semantics.

. Remove cast of non-variadic function to variadic, fixing perf output
  on armhf arch. Fix from Michael Hudson-Doyle.

. Fix 32-bit building of 'perf bench', from Wei Yang.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf test: Update command line callchain attribute tests

Michael Hudson-Doyle (1):
      perf tools: Remove cast of non-variadic function to variadic

Wei Yang (1):
      perf bench: Fix two warnings

 tools/perf/bench/numa.c                         |  4 ++--
 tools/perf/tests/attr/README                    |  6 +++---
 tools/perf/tests/attr/test-record-graph-default |  2 +-
 tools/perf/tests/attr/test-record-graph-dwarf   |  2 +-
 tools/perf/tests/attr/test-record-graph-fp      |  2 +-
 tools/perf/ui/hist.c                            |  2 +-
 tools/perf/util/color.c                         | 11 +++++++++--
 tools/perf/util/color.h                         |  2 +-
 8 files changed, 19 insertions(+), 12 deletions(-)
