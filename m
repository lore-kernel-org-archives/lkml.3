Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaAIXvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:51:52 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34455 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAIXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:51:49 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 0/3] perf: note task_ctx_nr < 0 and sw event merging behavior
Date: Thu,  9 Jan 2014 15:51:29 -0800
Message-Id: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-5806-0000-0000-000023D47A2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches only add/adjust comments.

Cody P Schafer (3):
  perf: comment on usage of perf_invalid_context
  perf: clarify comment regarding event merging
  perf: clarify comment regarding perf_pmu_contexts

 include/linux/sched.h | 4 ++++
 kernel/events/core.c  | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
1.8.5.2

