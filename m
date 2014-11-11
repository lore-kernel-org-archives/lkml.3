Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKKOSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaKKOSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151501"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/25] perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
Date: Tue, 11 Nov 2014 16:16:40 +0200
Message-Id: <1415715423-15563-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently added executables Add perf-read-vdso32 and
perf-read-vdsox32 need to be added to .gitignore.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 717221e..40399c3 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -2,6 +2,8 @@ PERF-CFLAGS
 PERF-GUI-VARS
 PERF-VERSION-FILE
 perf
+perf-read-vdso32
+perf-read-vdsox32
 perf-help
 perf-record
 perf-report
-- 
1.9.1

