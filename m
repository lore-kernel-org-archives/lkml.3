Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaFWIA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaFWH7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:59:34 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 0/7] perf/core improvements and fixes
Date: Mon, 23 Jun 2014 09:59:11 +0200
Message-Id: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 4ba96195051be30160af6d5f5f83f9a055ab1f23:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-06-13 08:19:06 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 1545d8aca9ac1cb3f503fb9c29543d539d99c7af:

  tools lib traceevent: Clean up format of args in jbd2 plugin (2014-06-19 18:18:37 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Updates from trace-cmd for traceevent plugin_kvm plus args cleanup (Steven Rostedt, Jan Kiszka)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Jan Kiszka (3):
      tools lib traceevent: Report unknown VMX exit reasons with code
      tools lib traceevent: Factor out print_exit_reason in kvm plugin
      tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints

Steven Rostedt (3):
      tools lib traceevent: Fix format in plugin_kvm
      tools lib traceevent: Clean up format of args in cfg80211 plugin
      tools lib traceevent: Clean up format of args in jbd2 plugin

Steven Rostedt (Red Hat) (1):
      tools lib traceevent: Add back in kvm plugins nested_vmexit events

 tools/lib/traceevent/plugin_cfg80211.c |  3 +-
 tools/lib/traceevent/plugin_jbd2.c     |  6 ++--
 tools/lib/traceevent/plugin_kvm.c      | 64 +++++++++++++++++++++++++++++-----
 3 files changed, 59 insertions(+), 14 deletions(-)
