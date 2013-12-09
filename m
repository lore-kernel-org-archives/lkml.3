Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab3LIKDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3LIKDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:03:19 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/2] perf tools: Add --header/--header-only options
Date: Mon,  9 Dec 2013 11:02:48 +0100
Message-Id: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the perf.data header is always displayed for stdio
output, which is no always useful.

Disabling header information by default and adding following
options to control header output:
  --header      - display header information (old default)
  --header-only - display header information only w/o further
                  processing.

thanks,
jirka


Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |  6 ++++++
 tools/perf/Documentation/perf-script.txt |  6 ++++++
 tools/perf/builtin-report.c              | 19 ++++++++++++++++---
 tools/perf/builtin-script.c              | 13 ++++++++++---
 4 files changed, 38 insertions(+), 6 deletions(-)
