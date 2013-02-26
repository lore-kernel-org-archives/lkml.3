Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab3BZEN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:13:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab3BZENy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:13:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6768932"
From: liguang <lig.fnst@cn.fujitsu.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org, jolsa@redhat.com,
        penberg@kernel.org, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] perf: sort command-list.txt by alphabet order
Date: Tue, 26 Feb 2013 12:12:52 +0800
Message-Id: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:02,
	Serialize complete at 2013/02/26 12:13:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 tools/perf/command-list.txt |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

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
1.7.2.5

