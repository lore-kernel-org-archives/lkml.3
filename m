Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaBSPyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbaBSPyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:54:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 6/6] perf tests: Add NO_LIBDW_DWARF_UNWIND make test
Date: Wed, 19 Feb 2014 16:52:59 +0100
Message-Id: <1392825179-5228-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1392825179-5228-1-git-send-email-jolsa@redhat.com>
References: <1392825179-5228-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding make test for NO_LIBDW_DWARF_UNWIND option,
plus updating minimal build test with it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/tests/make | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2d24954..5daeae1 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -27,6 +27,7 @@ make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
 make_no_demangle    := NO_DEMANGLE=1
 make_no_libelf      := NO_LIBELF=1
 make_no_libunwind   := NO_LIBUNWIND=1
+make_no_libdw_dwarf_unwind := NO_LIBDW_DWARF_UNWIND=1
 make_no_backtrace   := NO_BACKTRACE=1
 make_no_libnuma     := NO_LIBNUMA=1
 make_no_libaudit    := NO_LIBAUDIT=1
@@ -50,6 +51,7 @@ make_install_pdf    := install-pdf
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
 make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
 make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+make_minimal        += NO_LIBDW_DWARF_UNWIND=1
 
 # $(run) contains all available tests
 run := make_pure
@@ -66,6 +68,7 @@ run += make_no_ui
 run += make_no_demangle
 run += make_no_libelf
 run += make_no_libunwind
+run += make_no_libdw_dwarf_unwind
 run += make_no_backtrace
 run += make_no_libnuma
 run += make_no_libaudit
-- 
1.8.3.1

