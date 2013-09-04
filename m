Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3IDUMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:12:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:1768 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761178Ab3IDULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1023,1367996400"; 
   d="scan'208";a="391145045"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf tools: fix parsing with no sample_id_all bit set
Date: Wed,  4 Sep 2013 23:18:15 +0300
Message-Id: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is a fix, with a test to illustrate the issue.


Adrian Hunter (2):
      perf tools: add test for parsing with no sample_id_all bit
      perf tools: fix parsing with no sample_id_all bit set

 tools/perf/Makefile                       |   3 +-
 tools/perf/tests/builtin-test.c           |   4 ++
 tools/perf/tests/parse-no-sample-id-all.c | 108 ++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                  |   1 +
 tools/perf/util/evlist.c                  |   9 ++-
 5 files changed, 122 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/tests/parse-no-sample-id-all.c


Regards
Adrian
