Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaHVN6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaHVN6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:58:54 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 0/2] perf tools: Add +field argument support for --field/--sort options
Date: Fri, 22 Aug 2014 15:58:37 +0200
Message-Id: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to add field(s) to default field and sort orders
via using the '+' prefix, like for report:
  $ perf report -F +period,sample
  $ perf report -s +cpu

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (2):
      perf tools: Add +field argument support for --field option
      perf tools: Add +field argument support for --sort option

 tools/perf/ui/hist.c   |  4 ++--
 tools/perf/util/sort.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/sort.h |  1 +
 3 files changed, 49 insertions(+), 8 deletions(-)
