Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaDWLbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaDWLbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Subject: [GIT PULL 0/4] perf/urgent fixes
Date: Wed, 23 Apr 2014 13:31:18 +0200
Message-Id: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit fd741edc25600e1660abd00b5c1bbe967018c6a0:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent (2014-04-20 09:53:55 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo

for you to fetch changes up to de04f8657de9d3351a2d5880f1f7080b23b798cf:

  tools lib traceevent: Fix memory leak in pretty_print() (2014-04-23 13:19:30 +0200)

----------------------------------------------------------------
perf/urgent fixes:

Developer stuff:
. Fix memory leak and backward compatibility macros for pevent
  filter enums in traceevent library (Steven Rostedt)

. Disable libdw unwind for all but x86 arch (Jiri Olsa)

. Fix memory leak in sample_ustack (Masanari Iida)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

----------------------------------------------------------------
Jiri Olsa (1):
      perf tools: Disable libdw unwind for all but x86 arch

Masanari Iida (1):
      perf tests x86: Fix memory leak in sample_ustack()

Steven Rostedt (2):
      tools lib traceevent: Fix backward compatibility macros for pevent filter enums
      tools lib traceevent: Fix memory leak in pretty_print()

 tools/lib/traceevent/event-parse.c       | 1 +
 tools/lib/traceevent/event-parse.h       | 4 ++--
 tools/perf/arch/x86/tests/dwarf-unwind.c | 1 +
 tools/perf/config/Makefile               | 8 ++++++++
 4 files changed, 12 insertions(+), 2 deletions(-)
