Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3KDScZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:32:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3KDScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:32:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/2] perf record: mmap output file - v3
Date: Mon,  4 Nov 2013 19:31:43 +0100
Message-Id: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
after discussion with David, sending his change
updated into the new data file object.

David's original post:
  http://marc.info/?l=linux-kernel&m=138180575328977&w=2

Here's the change:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/mmap1

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
Jiri Olsa (2):
      perf tools: Add perf_data__write implementation into perf_data_file object
      perf tools: Add perf_data_file__write mmap support

 tools/perf/builtin-record.c |  49 ++++++++++++++++++--------------------------
 tools/perf/util/data.c      | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h      |  23 ++++++++++++++-------
 3 files changed, 152 insertions(+), 36 deletions(-)
