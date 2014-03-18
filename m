Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaCRI3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:29:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaCRI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:29:19 -0400
Date: Tue, 18 Mar 2014 01:28:55 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b63940970492f5f187d546e191bc2c6831491fe3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1393596135-4227-2-git-send-email-andi@firstfloor.org>
References: <1393596135-4227-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf mem: Clarify load-latency in documentation
Git-Commit-ID: b63940970492f5f187d546e191bc2c6831491fe3
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

Commit-ID:  b63940970492f5f187d546e191bc2c6831491fe3
Gitweb:     http://git.kernel.org/tip/b63940970492f5f187d546e191bc2c6831491fe3
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 28 Feb 2014 06:02:14 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 11:20:44 -0300

perf mem: Clarify load-latency in documentation

Clarify in the documentation that 'perf mem report' reports use-latency,
not load/store-latency on Intel systems.

This often causes confusion with users.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393596135-4227-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-mem.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 888d511..1d78a40 100644
--- a/tools/perf/Documentation/perf-mem.txt
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -18,6 +18,10 @@ from it, into perf.data. Perf record options are accepted and are passed through
 "perf mem -t <TYPE> report" displays the result. It invokes perf report with the
 right set of options to display a memory access profile.
 
+Note that on Intel systems the memory latency reported is the use-latency,
+not the pure load (or store latency). Use latency includes any pipeline
+queueing delays in addition to the memory subsystem latency.
+
 OPTIONS
 -------
 <command>...::
