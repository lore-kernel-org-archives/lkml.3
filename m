Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3EVGYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:24:37 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50814 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3EVGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:23:14 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, peterz@infradead.org,
        eranian@google.com, ak@linux.intel.com, mingo@kernel.org
Subject: [PATCH 0/5] perf: Introducing new conditional branch filter
Date: Wed, 22 May 2013 11:52:36 +0530
Message-Id: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052206-8878-0000-0000-000007357B87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces conditional branch filter in perf branch stack
sampling framework incorporating review comments from Michael Neuling,
Peter Zijlstra and Stephane Eranian.

Anshuman Khandual (5):
  perf: New conditional branch filter criteria in branch stack sampling
  powerpc, perf: Enable conditional branch filter for POWER8
  perf, tool: Conditional branch filter 'cond' added to perf record
  x86, perf: Add conditional branch filtering support
  perf, documentation: Description for conditional branch filter

 arch/powerpc/perf/power8-pmu.c             | 10 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  6 ++++++
 include/uapi/linux/perf_event.h            |  3 ++-
 tools/perf/Documentation/perf-record.txt   |  3 ++-
 tools/perf/builtin-record.c                |  1 +
 5 files changed, 21 insertions(+), 2 deletions(-)

-- 
1.7.11.7

