Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3LIJts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:49:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab3LIJtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:49:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9221945"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] perf tools: Remove redundant 'stat' in perf-kvm.txt.
Date: Mon, 9 Dec 2013 17:47:46 -0500
Message-Id: <ebedc3b95eae7f0fd68d32c7541f56841e2b92a0.1386629050.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:22,
	Serialize complete at 2013/12/09 17:49:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subcommand stat was added into manpage by bcf6edcd, but the usage of stat
was picked out for a new usage by 9a6d3166. So, the old 'stat' at the tail
is not needed any more.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kvm.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 96a9a1d..959dd75 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 	[--guestkallsyms=<path> --guestmodules=<path> | --guestvmlinux=<path>]]
 	{top|record|report|diff|buildid-list}
 'perf kvm' [--host] [--guest] [--guestkallsyms=<path> --guestmodules=<path>
-	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat}
+	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list}
 'perf kvm stat [record|report|live] [<options>]
 
 DESCRIPTION
-- 
1.8.2.1

