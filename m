Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaFDN1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaFDN1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:27:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Wed,  4 Jun 2014 15:26:58 +0200
Message-Id: <1401888420-23191-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit b69cf53640da2b86439596118cfa95233154ee76:

  perf: Fix a race between ring_buffer_detach() and ring_buffer_attach() (2014-05-19 21:44:56 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo

for you to fetch changes up to 082f96a93eb5ba9bf771518a0dda590624568e8e:

  perf probe: Fix perf probe to find correct variable DIE (2014-06-04 14:49:20 +0200)

----------------------------------------------------------------
perf/urgent fixes:

. Fix perf probe to find correct variable DIE (Masami Hiramatsu)

. Fix a segfault in perf probe if asked for variable it doesn't find (Masami Hiramatsu)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Masami Hiramatsu (2):
      perf probe: Fix a segfault if asked for variable it doesn't find
      perf probe: Fix perf probe to find correct variable DIE

 tools/perf/util/dwarf-aux.c    | 7 +++++--
 tools/perf/util/probe-finder.c | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)
