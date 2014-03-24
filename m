Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaCXUFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:05:50 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35598 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaCXUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:05:47 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, daniel.lezcano@linaro.org,
        zoran.markovic@linaro.org
Subject: [RFC PATCH 0/2] sched: proposal for idlestat scheduler benchmarking tool
Date: Mon, 24 Mar 2014 13:05:20 -0700
Message-Id: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conclusions from Energy Aware Scheduling sessions at the latest Kernel Summit
identified a need for tools that would assess power consumption of the system
These tools would be used to prove efficiency of scheduler patches by
comparing power consumption before and after they were applied.

Attached is the proposal for the idlestat tool. The purpose of this patch
is to solicit feedback on tool's features, possible enhancements, etc.

Source code and sample idlestat report are provided for reference.

Please review and provide comments in anticipation of further development.

Regards, Zoran

Zoran Markovic (2):
  power: Add idlestat tool for benchmarking energy-aware scheduler
  sched: Add documentation for idlestat scheduler benchmarking tool

 Documentation/scheduler/idlestat.txt |   79 +++
 tools/power/idlestat/.gitignore      |   50 ++
 tools/power/idlestat/Makefile        |   34 +
 tools/power/idlestat/idlestat.c      | 1229 ++++++++++++++++++++++++++++++++++
 tools/power/idlestat/idlestat.h      |  106 +++
 tools/power/idlestat/list.h          |  588 ++++++++++++++++
 tools/power/idlestat/topology.c      |  503 ++++++++++++++
 tools/power/idlestat/topology.h      |   77 +++
 tools/power/idlestat/trace.c         |   87 +++
 tools/power/idlestat/trace.h         |   43 ++
 tools/power/idlestat/utils.c         |  115 ++++
 tools/power/idlestat/utils.h         |   35 +
 12 files changed, 2946 insertions(+)
 create mode 100644 Documentation/scheduler/idlestat.txt
 create mode 100644 tools/power/idlestat/.gitignore
 create mode 100644 tools/power/idlestat/Makefile
 create mode 100644 tools/power/idlestat/idlestat.c
 create mode 100644 tools/power/idlestat/idlestat.h
 create mode 100644 tools/power/idlestat/list.h
 create mode 100644 tools/power/idlestat/topology.c
 create mode 100644 tools/power/idlestat/topology.h
 create mode 100644 tools/power/idlestat/trace.c
 create mode 100644 tools/power/idlestat/trace.h
 create mode 100644 tools/power/idlestat/utils.c
 create mode 100644 tools/power/idlestat/utils.h

-- 
1.7.9.5

