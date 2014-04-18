Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaDRKVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDRKVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:21:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Adrien BAK <adrien.bak@metascale.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vladimir Nikulichev <nvs@tbricks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Fri, 18 Apr 2014 12:20:40 +0200
Message-Id: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 6381c24cd6d5d6373620426ab0a96c80ed953e20:

  kprobes/x86: Fix page-fault handling logic (2014-04-17 10:57:02 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo

for you to fetch changes up to 5fef49f71bd0f2f11f55b316ab7473b7f12fd8e0:

  perf tools: Error reporting improvement (2014-04-18 11:40:01 +0200)

----------------------------------------------------------------
perf/urgent fixes:

User visible:

. Adjust symbols in VDSO to properly resolve its function names (Vladimir Nikulichev)

. Improve error reporting for record session failure (Adrien BAK)

. Fix of 'Min time' counting in report command (Alexander Yarygin)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

----------------------------------------------------------------
Adrien BAK (1):
      perf tools: Error reporting improvement

Alexander Yarygin (1):
      perf kvm: Fix of 'Min time' counting in report command

Vladimir Nikulichev (1):
      perf tools: Adjust symbols in VDSO

 tools/perf/builtin-kvm.c     | 1 +
 tools/perf/builtin-record.c  | 2 +-
 tools/perf/util/data.c       | 9 ++++++++-
 tools/perf/util/symbol-elf.c | 2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)
