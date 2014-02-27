Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaB0N34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:29:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaB0N3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:29:54 -0500
Date: Thu, 27 Feb 2014 05:29:28 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9e8c06eaba76392644825a72d965ffa5f2a5784a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1392825179-5228-7-git-send-email-jolsa@redhat.com>
References: <1392825179-5228-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add NO_LIBDW_DWARF_UNWIND make test
Git-Commit-ID: 9e8c06eaba76392644825a72d965ffa5f2a5784a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e8c06eaba76392644825a72d965ffa5f2a5784a
Gitweb:     http://git.kernel.org/tip/9e8c06eaba76392644825a72d965ffa5f2a5784a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 16:52:59 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:37 -0300

perf tests: Add NO_LIBDW_DWARF_UNWIND make test

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
