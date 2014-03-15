Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaCODRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:17:17 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54086 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaCODRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:17:16 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/4] perf: trivial follow-ons to --list-cmds
Date: Fri, 14 Mar 2014 23:17:50 -0400
Message-Id: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.rc0.1.g9d22d25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With "perf kvm: introduce --list-cmds for use by scripts" accepted,
these are trivial follow-on patches to enable the same functionality
in kmem, mem, lock, and sched.

Thanks.

Ramkumar Ramachandra (4):
  perf kmem: introduce --list-cmds for use by scripts
  perf mem: introduce --list-cmds for use by scripts
  perf lock: introduce --list-cmds for use by scripts
  perf sched: introduce --list-cmds for use by scripts

 tools/perf/builtin-kmem.c     |  8 +++++---
 tools/perf/builtin-lock.c     | 10 ++++++----
 tools/perf/builtin-mem.c      | 15 ++++++++-------
 tools/perf/builtin-sched.c    | 10 ++++++----
 tools/perf/perf-completion.sh |  4 ++--
 5 files changed, 27 insertions(+), 20 deletions(-)

-- 
1.9.rc0.1.g9d22d25

