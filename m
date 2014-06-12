Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaFLQYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:24:01 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34927 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaFLQX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:58 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 0/4] tracing: Small updates on tracing/set_graph_notrace file
Date: Fri, 13 Jun 2014 01:23:49 +0900
Message-Id: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is an update of recent notrace filter change in the function graph
tracer.  It adds a new kernel boot parameter and also adds description of
the file to the tracing/README in debugfs.  Finally it changes message
when the (both of) notrace filter hash is empty.  They'll print below
message when there's no entry:

  # cat /sys/kernel/debug/tracing/set_graph_notrace
  #### no functions disabled ####


It's also available at 'ftrace/nograph-v3' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Thanks,
Namhyung


Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Namhyung Kim (4):
  tracing: Add ftrace_graph_notrace boot parameter
  tracing: Improve message of empty set_graph_notrace file
  tracing: Improve message of empty set_ftrace_notrace file
  tracing: Add description of set_graph_notrace to tracing/README

 Documentation/kernel-parameters.txt |    6 +++++
 kernel/trace/ftrace.c               |   46 ++++++++++++++++++++++++++++++-----
 kernel/trace/trace.c                |    1 +
 3 files changed, 47 insertions(+), 6 deletions(-)

-- 
1.7.9.2

