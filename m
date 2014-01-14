Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaANQrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:47:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaANQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:21 -0500
Date: Tue, 14 Jan 2014 08:39:36 -0800
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-88aca8d966a1349631a0946ed77c7ed360519ed4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, peterz@infradead.org, jolsa@redhat.com,
        ak@linux.intel.com, sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        peterz@infradead.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1389199434-21761-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389199434-21761-1-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools perf: Comment typo fix
Git-Commit-ID: 88aca8d966a1349631a0946ed77c7ed360519ed4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88aca8d966a1349631a0946ed77c7ed360519ed4
Gitweb:     http://git.kernel.org/tip/88aca8d966a1349631a0946ed77c7ed360519ed4
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Wed, 8 Jan 2014 08:43:51 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:24 -0300

tools perf: Comment typo fix

s/temr/term/

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1389199434-21761-1-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 0934d64..d9cab4d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -505,7 +505,7 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
 
 /*
  * Setup one of config[12] attr members based on the
- * user input data - temr parameter.
+ * user input data - term parameter.
  */
 static int pmu_config_term(struct list_head *formats,
 			   struct perf_event_attr *attr,
