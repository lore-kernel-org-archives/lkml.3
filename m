Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3DHPdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:33:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001Ab3DHPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:33:16 -0400
Date: Mon, 8 Apr 2013 08:33:01 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-cc2f5a8adbc7ab1fdb7d9bcf4ea9838c73e82dfe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20130405144941.GA30503@quad>
References: <20130405144941.GA30503@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix comments in PERF_MEM_LVL bitmask
Git-Commit-ID: cc2f5a8adbc7ab1fdb7d9bcf4ea9838c73e82dfe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:33:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc2f5a8adbc7ab1fdb7d9bcf4ea9838c73e82dfe
Gitweb:     http://git.kernel.org/tip/cc2f5a8adbc7ab1fdb7d9bcf4ea9838c73e82dfe
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 5 Apr 2013 16:49:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:54:24 +0200

perf: Fix comments in PERF_MEM_LVL bitmask

This small patch fixes a mistake in the comments
for the PERF_MEM_LVL_* events. The L2, L3 bits simply
represent cache levels, not hits or misses. That is
encoded in PERF_MEM_LVL_MISS/PERF_MEM_LVL_HIT.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: jolsa@redhat.com
Link: http://lkml.kernel.org/r/20130405144941.GA30503@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 964a450..fb104e5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -645,8 +645,8 @@ union perf_mem_data_src {
 #define PERF_MEM_LVL_MISS	0x04  /* miss level  */
 #define PERF_MEM_LVL_L1		0x08  /* L1 */
 #define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
-#define PERF_MEM_LVL_L2		0x20  /* L2 hit */
-#define PERF_MEM_LVL_L3		0x40  /* L3 hit */
+#define PERF_MEM_LVL_L2		0x20  /* L2 */
+#define PERF_MEM_LVL_L3		0x40  /* L3 */
 #define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
 #define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
 #define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
