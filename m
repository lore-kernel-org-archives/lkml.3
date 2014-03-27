Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaC0XtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:49:20 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34811 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbaC0XtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:49:19 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/3] Minor fixes around perf bench
Date: Thu, 27 Mar 2014 19:50:16 -0400
Message-Id: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just started looking at 'perf bench' this afternoon. Here are some
simple patches fixing the minor issues I had while starting out.

Thanks.

Ram

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

Ramkumar Ramachandra (3):
  perf bench: Set more defaults in the 'numa' suite
  perf bench: Update manpage to mention numa and futex
  perf bench: Fix segfault at the end of an 'all' execution

 tools/perf/Documentation/perf-bench.txt | 22 ++++++++++++++++++++++
 tools/perf/bench/numa.c                 |  4 ++++
 tools/perf/builtin-bench.c              |  2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)

-- 
1.9.0.431.g014438b

