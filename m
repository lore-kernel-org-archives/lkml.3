Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3LRKch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LRKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:34 -0500
Date: Wed, 18 Dec 2013 02:31:51 -0800
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-189b84fb54490ae24111124346a8e63f8e019385@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, vince@deater.net, vincent.weaver@maine.edu,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, vince@deater.net, vincent.weaver@maine.edu,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy>
References: <alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Document the new transaction sample type
Git-Commit-ID: 189b84fb54490ae24111124346a8e63f8e019385
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:31:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  189b84fb54490ae24111124346a8e63f8e019385
Gitweb:     http://git.kernel.org/tip/189b84fb54490ae24111124346a8e63f8e019385
Author:     Vince Weaver <vince@deater.net>
AuthorDate: Fri, 13 Dec 2013 15:52:25 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:04:01 +0100

perf: Document the new transaction sample type

Commit fdfbbd07e91f8fe3871 ("perf: Add generic transaction flags")
added support for PERF_SAMPLE_TRANSACTION but forgot to add documentation
for the sample type to include/uapi/linux/perf_event.h

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..959d454 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -679,6 +679,7 @@ enum perf_event_type {
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
