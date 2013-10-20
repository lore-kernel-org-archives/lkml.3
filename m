Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3JTI2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:28:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3JTI14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:27:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Waiman Long <Waiman.Long@hp.com>, acme@ghostprotocols.net,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Sun, 20 Oct 2013 05:27:23 -0300
Message-Id: <1382257646-5808-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1651d120baddf68846188bcdf0ef5350068436cf:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-10-08 07:29:09 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 3090ffb5a2515990182f3f55b0688a7817325488:

  perf: Disable PERF_RECORD_MMAP2 support (2013-10-17 16:27:14 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix build error on Fedora 12.

. Fix to initialize fname always before use it, bug introduced
  during this merge window, from Masami Hiramatsu.

. Disable PERF_RECORD_MMAP2 support, from Stephane Eranian.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf scripting perl: Fix build error on Fedora 12

Masami Hiramatsu (1):
      perf probe: Fix to initialize fname always before use it

Stephane Eranian (1):
      perf: Disable PERF_RECORD_MMAP2 support

 kernel/events/core.c                               |  4 +++
 tools/perf/util/event.c                            | 30 ++++++++++------------
 tools/perf/util/evsel.c                            |  1 -
 tools/perf/util/probe-finder.c                     |  2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)
