Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3GVMoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3GVMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:44:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/5] perf tests: Add install tests to tests/make
Date: Mon, 22 Jul 2013 14:43:29 +0200
Message-Id: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding build tests for 'install*' targets and check for
ctags/cscope binaries.

I noticed that besides plain 'install' target following
are either broken or do not install a single file:
  install-doc
  install-man
  install-html
  install-info
  install-pdf

Complete description is in patch 5 changelog.

I guess we want all those targets functional the
same way as the main 'Documentation' stuff.

thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
---
Jiri Olsa (5):
      perf tests: Run ctags/cscope make tests only with needed binaries
      perf tests: Rename TMP to TMP_O tests/make variable
      perf tests: Add DESTDIR=TMP_DEST tests/make variable
      perf tests: Add 'make install/install-bin' tests into tests/make
      perf tests: Add broken install-* tests into tests/make

 tools/perf/tests/make | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 8 deletions(-)
