Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaLRQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:51:48 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41539 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbaLRQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:47 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>
Cc: linux-kernel@i4.cs.fau.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] perf/x86/intel/uncore: Fix multiple coding style issues
Date: Thu, 18 Dec 2014 17:51:35 +0100
Message-Id: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series fixes multiple coding style issues. Most of them
were found by checkpatch.

v2: This is the version that's actually supposed to be sent out.

Julian Brost (5):
  perf/x86/intel/uncore: checkpatch: Replace deprecated macro.
  perf/x86/intel/uncore: checkpatch: Replace kzalloc with kcalloc
  perf/x86/intel/uncore: coding style: Fix alignment in macros
  perf/x86/intel/uncore: checkpatch: Remove unnecessary line
    continuation
  perf/x86/intel/uncore: checkpatch: Add newlines after declarations

 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  6 +++-
 .../x86/kernel/cpu/perf_event_intel_uncore_nhmex.c |  1 +
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 39 +++++++++++++---------
 3 files changed, 30 insertions(+), 16 deletions(-)

-- 
1.9.1

