Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbaD3PdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243AbaD3PdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Richard Yao <ryao@gentoo.org>,
        Xia Kaixu <xiakaixu@huawei.com>
Subject: [GIT PULL 0/7] perf/urgent fixes
Date: Wed, 30 Apr 2014 17:32:44 +0200
Message-Id: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 9f7ff8931e3c5ddc8535476971ec9501e9555c05:

  perf/x86: Fix RAPL rdmsrl_safe() usage (2014-04-24 08:12:41 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-urgent-for-mingo

for you to fetch changes up to 9a126728165eef9b1e9349fe57b9747ac6c6f7e3:

  perf tests x86: Fix stack map lookup in dwarf unwind test (2014-04-30 17:02:31 +0200)

----------------------------------------------------------------
perf/urgent fixes:

. Fix perf to use non-executable stack, again (Mathias Krause)

. Remove extra '/' character in events file path (Xia Kaixu)

. Search for modules in %s/lib/modules/%s (Richard Yao)

. Build related fixies plus static build test (Jiri Olsa)

. Fix stack map lookup in dwarf unwind test (Jiri Olsa)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Jiri Olsa (4):
      perf tools: Use LDFLAGS instead of ALL_LDFLAGS
      perf tools: Fix bfd dependency libraries detection
      perf tests: Add static build make test
      perf tests x86: Fix stack map lookup in dwarf unwind test

Mathias Krause (1):
      perf x86: Fix perf to use non-executable stack, again

Richard Yao (1):
      perf machine: Search for modules in %s/lib/modules/%s

Xia Kaixu (1):
      perf tools: Remove extra '/' character in events file path

 tools/lib/api/fs/debugfs.c               |  4 ++--
 tools/perf/Makefile.perf                 |  2 +-
 tools/perf/arch/x86/tests/dwarf-unwind.c |  2 +-
 tools/perf/arch/x86/tests/regs_load.S    |  8 ++++++-
 tools/perf/config/Makefile               | 38 +++++++++++++++++++++++---------
 tools/perf/tests/make                    |  2 ++
 tools/perf/util/machine.c                | 16 ++++++++++----
 7 files changed, 52 insertions(+), 20 deletions(-)
