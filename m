Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbaFZMic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbaFZMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:38:30 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCHv3 0/2] perf tools tui: Display columns headers
Date: Thu, 26 Jun 2014 14:38:09 +0200
Message-Id: <1403786291-19412-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding the way to display columns headers in perf TUI on
'H' press.

v3 changes:
  - changed report.show-headers to ui.show-headers
    and fix default value setting for it (Namhyung)
  - ommited v2 patch 1
  - v2 patches 2 and 3 already in

v2 changes:
  - fixed resize/popup issues (Namhyung)
  - display headers by default (Namhyung)
  - add 'show-headers' config file option to setup
    the headers displaying

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
Jiri Olsa (2):
      perf tools tui: Display columns header text on 'H' press
      perf tools: Add ui.show-headers config file option

 tools/perf/ui/browsers/hists.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/config.c       | 13 +++++++++++++
 tools/perf/util/symbol.c       |  1 +
 tools/perf/util/symbol.h       |  3 ++-
 4 files changed, 93 insertions(+), 4 deletions(-)
