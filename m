Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaJTKwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:52:15 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:43938 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaJTKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:52:10 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/2] ftracetest improvement and new testcase
Date: Mon, 20 Oct 2014 12:52:01 +0200
Message-Id: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102010-0025-0000-0000-000001F68EBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are a result from the s390 vs kprobes on ftrace
discussion, however they can be handled completely independent.

One patch simply sorts the ftrace testcases, while the second adds
a new testcase with a couple of sanity test with respect to the
coexistence of kprobes and ftrace.

Heiko Carstens (2):
  ftracetest: add kprobes on ftrace testcase
  ftracetest: sort testcases

 tools/testing/selftests/ftrace/ftracetest          |  2 +-
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          | 55 ++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc

-- 
1.8.5.5

