Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbaFPSPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:12 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:38467 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbaFPSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:11 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] perf bench: Updates for 3.17
Date: Mon, 16 Jun 2014 11:14:18 -0700
Message-Id: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First set of various updates for the perf-bench tool. I am
in the process of adding more benchmarks (ipc & futex) but
wanted to get these changes in early in the -rc cycle.

Patches 3 & 5 depend on the first patch, otherwise updates
are pretty much without order.

Please consider applying.

Thanks!

Davidlohr Bueso (9):
  perf bench: Add --repeat option
  perf bench: sched-messaging: Redo runtime output
  perf bench: sched-messaging: Support multiple runs
  perf bench: sched-messaging: Plug memleak
  perf bench: futex: Use global --repeat option
  perf bench: futex: Replace --silent option with global --format
  perf bench: mem: -o and -n options are mutually exclusive
  perf bench: sched-messaging: Drop barf()
  perf bench: futex: Support operations for shared futexes

 tools/perf/Documentation/perf-bench.txt |   4 +
 tools/perf/bench/bench.h                |   1 +
 tools/perf/bench/futex-hash.c           |  39 ++++++---
 tools/perf/bench/futex-requeue.c        |  58 ++++++++-----
 tools/perf/bench/futex-wake.c           |  52 ++++++-----
 tools/perf/bench/mem-memcpy.c           |   5 ++
 tools/perf/bench/mem-memset.c           |   5 ++
 tools/perf/bench/sched-messaging.c      | 149 ++++++++++++++++++--------------
 tools/perf/builtin-bench.c              |   7 ++
 9 files changed, 196 insertions(+), 124 deletions(-)

-- 
1.8.1.4

