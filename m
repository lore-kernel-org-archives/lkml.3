Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaBXTLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:11:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBXTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:11:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@samba.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Mon, 24 Feb 2014 16:10:43 -0300
Message-Id: <1393269045-11572-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit a9d3f94ec7708427b9f05a65246d3fd6e287fa51:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-02-22 17:20:46 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 98e9f03bbf2cb21a60f94b8b700eb5d38470819d:

  perf symbols: Destroy unused symsrcs (2014-02-24 11:13:08 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix annotation on stdio/GTK+ interfaces (Namhyung Kim)

. Fix file descriptor leaking while searching DSOs for suitable symtab (Namhyung Kim).

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (2):
      perf annotate: Check availability of annotate when processing samples
      perf symbols: Destroy unused symsrcs

 tools/perf/builtin-report.c | 40 ++++++++++++++++++++++++----------------
 tools/perf/builtin-top.c    |  6 ++++--
 tools/perf/util/annotate.c  |  9 ++++++++-
 tools/perf/util/annotate.h  |  2 ++
 tools/perf/util/symbol.c    |  2 ++
 5 files changed, 40 insertions(+), 19 deletions(-)
