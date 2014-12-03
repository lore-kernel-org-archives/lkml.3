Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaLCWNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:13:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54270 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbaLCWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:52 -0500
Message-Id: <20141203221311.563559646@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 03 Dec 2014 17:13:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] tracing: Updates for 3.19
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 3558a5ac50dbb2419cc649d5e154af161d661037


Byungchul Park (1):
      tracing: Add additional marks to signal very large time deltas

Dan Carpenter (1):
      tracing: Truncated output is better than nothing

Joonsoo Kim (1):
      Documentation: describe trace_buf_size parameter more accurately

Steven Rostedt (Red Hat) (2):
      tracing: Add NOT to filtering logic
      tracing: Allow NOT to filter AND and OR clauses

----
 Documentation/kernel-parameters.txt  |  2 +-
 Documentation/trace/ftrace.txt       | 10 +++++++---
 kernel/trace/trace.c                 |  7 ++-----
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_events_filter.c   | 29 +++++++++++++++++++++++------
 kernel/trace/trace_functions_graph.c | 23 +++--------------------
 kernel/trace/trace_output.c          | 34 +++++++++++++++++++++++++++++-----
 7 files changed, 67 insertions(+), 40 deletions(-)
