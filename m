Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3CAQlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:41:51 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45978
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3CAQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:39:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, liguang <lig.fnst@cn.fujitsu.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/15] perf tools: Sort command-list.txt alphabetically
Date: Thu, 28 Feb 2013 18:05:17 -0300
Message-Id: <1362085527-25326-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1362085527-25326-1-git-send-email-acme@infradead.org>
References: <1362085527-25326-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liguang <lig.fnst@cn.fujitsu.com>

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
-- 
1.8.1.1.361.gec3ae6e

