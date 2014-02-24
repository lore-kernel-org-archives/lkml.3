Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBXT4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:56:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaBXT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf tests: Add NO_LIBDW_DWARF_UNWIND make test
Date: Mon, 24 Feb 2014 16:56:38 -0300
Message-Id: <1393271800-17505-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding make test for NO_LIBDW_DWARF_UNWIND option, plus updating minimal
build test with it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2d2495423be5..5daeae1cb4c0 100644
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
1.8.1.4

