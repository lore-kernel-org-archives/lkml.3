Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaFOQxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaFOQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:53:37 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 0/4] perf tools tui: Display columns headers
Date: Sun, 15 Jun 2014 18:53:19 +0200
Message-Id: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding the way to display columns headers in perf TUI on
'H' press.

Patches 1 and 2 are not necessary for the functionality,
they are just byproducts of another early way I tried,
but I think they could go in.

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_headers

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (4):
      perf tools: Factor ui_browser ops out of ui_browser struct
      perf tools: Remove ev_name argument from perf_evsel__hists_browse
      perf tools: Fix scrollbar refresh row index
      perf tools tui: Display columns header text on 'H' press

 tools/perf/ui/browser.c           |  39 +++++++++++++++++++--------------
 tools/perf/ui/browser.h           |  28 +++++++++++++----------
 tools/perf/ui/browsers/annotate.c |  19 +++++++++-------
 tools/perf/ui/browsers/header.c   |   8 ++++---
 tools/perf/ui/browsers/hists.c    | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 tools/perf/ui/browsers/map.c      |   8 ++++---
 tools/perf/ui/browsers/scripts.c  |   2 +-
 tools/perf/ui/tui/util.c          |   8 ++++---
 8 files changed, 161 insertions(+), 68 deletions(-)
