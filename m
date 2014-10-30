Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbaJ3Gog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:44:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbaJ3God (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:44:33 -0400
Date: Wed, 29 Oct 2014 23:43:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-dme1nsu07a0spkmcl401srec@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, namhyung@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, fweisbec@gmail.com, jolsa@redhat.com,
        hpa@zytor.com, jean.pihet@linaro.org, tglx@linutronix.de,
        paulus@samba.org, dsahern@gmail.com, efault@gmx.de, mingo@kernel.org,
        dzickus@redhat.com, bp@suse.de
Reply-To: dsahern@gmail.com, paulus@samba.org, bp@suse.de, dzickus@redhat.com,
        mingo@kernel.org, efault@gmx.de, acme@redhat.com, namhyung@kernel.org,
        eranian@google.com, jean.pihet@linaro.org, tglx@linutronix.de,
        hpa@zytor.com, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Remove misplaced __maybe_unused
Git-Commit-ID: f498784c39c7c840347e28b830aedc31ce699816
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

Commit-ID:  f498784c39c7c840347e28b830aedc31ce699816
Gitweb:     http://git.kernel.org/tip/f498784c39c7c840347e28b830aedc31ce699816
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 23 Oct 2014 17:20:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:46 -0200

perf tests: Remove misplaced __maybe_unused

The 'machine' parameter is used in this function, ditch the
__maybe_unused annotation, not needed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-dme1nsu07a0spkmcl401srec@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/hists_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 5a31787..74f257a 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -43,7 +43,7 @@ static struct sample fake_samples[] = {
 };
 
 static int add_hist_entries(struct perf_evlist *evlist,
-			    struct machine *machine __maybe_unused)
+			    struct machine *machine)
 {
 	struct perf_evsel *evsel;
 	struct addr_location al;
