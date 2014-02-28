Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaB1V0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:26:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43229 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaB1V0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:26:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Fri, 28 Feb 2014 18:25:49 -0300
Message-Id: <1393622751-21513-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit b6e53f321ee6f4b237d8cc54fbace3217fa96e05:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-02-27 12:47:59 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to b39c2a57a00a841f057a75b41df4c26173288b66:

  perf tools: Fix strict alias issue for find_first_bit (2014-02-28 10:39:40 -0300)

----------------------------------------------------------------
perf/urgent build fixes:

. Problem on recent gcc on x86-32 related to strict alias issue for
  find_first_bit (Jiri Olsa).

. OpenSuSE: BFD detection problems related to not explicitely listing all
  required libraries (Andi Kleen)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf tools: fix BFD detection on opensuse

Jiri Olsa (1):
      perf tools: Fix strict alias issue for find_first_bit

 tools/perf/config/Makefile                | 2 +-
 tools/perf/config/feature-checks/Makefile | 2 +-
 tools/perf/util/include/linux/bitops.h    | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)
