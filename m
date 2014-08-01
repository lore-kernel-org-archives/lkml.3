Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaHAMdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaHAMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:33:41 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 0/3] perf: Remove orphaned children events
Date: Fri,  1 Aug 2014 14:32:59 +0200
Message-Id: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding a support to remove orphaned children events, so they do not
eat resources once parent event is gone as discussed here:
  lkml.kernel.org/r/1405079782-8139-3-git-send-email-jolsa@kernel.org
and here:
  http://marc.info/?l=linux-kernel&m=140568679618148&w=2

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_orphans_removal

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/perf_event.h |   4 ++
 kernel/events/core.c       | 116 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 7 deletions(-)
