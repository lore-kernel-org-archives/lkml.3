Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBMVRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:17:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaBMVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Thu, 13 Feb 2014 18:15:56 -0300
Message-Id: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 0e9f2204cfa6d79abe3e525ddf7c4ab5792cc751:

  perf/x86: Fix Userspace RDPMC switch (2014-02-09 13:08:25 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 844ae5b46c08dbc7ba695b543c023f9cf3bbf9ff:

  perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches (2014-02-13 17:28:31 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Handle PERF_RECORD_HEADER_EVENT_TYPE properly. (Jiri Olsa)

. Fix checking for supported events on older kernels in
  'perf list' (Vince Weaver)

. Do not add offset twice to uprobe address in
  'perf probe' (Masami Hiramatsu)

. Fix perf trace's ioctl 'request' beautifier build problems
  on !(i386 || x86_64) arches (Arnaldo Carvalho de Melo)

. Fix 'perf trace' build by adding a fallback definition for
  EFD_SEMAPHORE (Ben Hutchings)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches

Ben Hutchings (1):
      perf trace: Add fallback definition of EFD_SEMAPHORE

Jiri Olsa (1):
      perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly

Masami Hiramatsu (1):
      perf probe: Do not add offset twice to uprobe address

Vince Weaver (1):
      perf list: Fix checking for supported events on older kernels

 tools/perf/builtin-trace.c     | 22 ++++++++++++++++++++++
 tools/perf/util/parse-events.c | 17 +++++++++++++++--
 tools/perf/util/probe-event.c  |  2 +-
 tools/perf/util/session.c      |  6 ++++++
 4 files changed, 44 insertions(+), 3 deletions(-)
