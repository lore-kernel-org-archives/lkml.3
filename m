Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3LDJ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:58:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3LDJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:32 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189162"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/5] perf tool: Fix a type of '=' in Document of perf-kvm.
Date: Wed, 4 Dec 2013 17:56:43 -0500
Message-Id: <6124d9eb10a3f1f6b399d1db660110bc7a60fd6b.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:21,
	Serialize complete at 2013/12/04 17:58:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As option --host and --guest request no input for it, there should
not be a '=' after them in Document. And --output request a filename
as the input, so there should be a '=' after it. This patch remove
the wrong '=' after --guest and --host, and add a '=' after --output
in perf-kvm.txt.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kvm.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index be1d263..96a9a1d 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -67,14 +67,14 @@ There are a couple of variants of perf kvm:
 OPTIONS
 -------
 -i::
---input=::
+--input=<path>::
         Input file name.
 -o::
---output::
+--output=<path>::
         Output file name.
---host=::
+--host::
         Collect host side performance profile.
---guest=::
+--guest::
         Collect guest side performance profile.
 --guestmount=<path>::
 	Guest os root file system mount directory. Users mounts guest os
-- 
1.8.2.1

