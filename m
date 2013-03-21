Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3CUKyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:54:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3CUKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:54:32 -0400
Date: Thu, 21 Mar 2013 03:52:54 -0700
From: tip-bot for liguang <tipbot@zytor.com>
Message-ID: <tip-66857b5a8bc61b0c5e7a9c96f02558ef6d4109c6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, lig.fnst@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, lig.fnst@cn.fujitsu.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Sort command-list.txt alphabetically
Git-Commit-ID: 66857b5a8bc61b0c5e7a9c96f02558ef6d4109c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:53:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66857b5a8bc61b0c5e7a9c96f02558ef6d4109c6
Gitweb:     http://git.kernel.org/tip/66857b5a8bc61b0c5e7a9c96f02558ef6d4109c6
Author:     liguang <lig.fnst@cn.fujitsu.com>
AuthorDate: Tue, 26 Feb 2013 12:12:52 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:59 -0300

perf tools: Sort command-list.txt alphabetically

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/command-list.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 3e86bbd..a28e31b 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -10,17 +10,17 @@ perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
 perf-evlist			mainporcelain common
 perf-inject			mainporcelain common
+perf-kmem			mainporcelain common
+perf-kvm			mainporcelain common
 perf-list			mainporcelain common
-perf-sched			mainporcelain common
+perf-lock			mainporcelain common
+perf-probe			mainporcelain full
 perf-record			mainporcelain common
 perf-report			mainporcelain common
+perf-sched			mainporcelain common
+perf-script			mainporcelain common
 perf-stat			mainporcelain common
+perf-test			mainporcelain common
 perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
-perf-script			mainporcelain common
-perf-probe			mainporcelain full
-perf-kmem			mainporcelain common
-perf-lock			mainporcelain common
-perf-kvm			mainporcelain common
-perf-test			mainporcelain common
