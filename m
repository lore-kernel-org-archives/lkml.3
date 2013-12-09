Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3LIJtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:49:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab3LIJtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:49:39 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9221943"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] perf tools: Remove duplicated 'runs' in perf-archive.txt.
Date: Mon, 9 Dec 2013 17:47:47 -0500
Message-Id: <78a15a9f4f500b6074a1e25917d6e8251f894628.1386629050.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <ebedc3b95eae7f0fd68d32c7541f56841e2b92a0.1386629050.git.yangds.fnst@cn.fujitsu.com>
References: <ebedc3b95eae7f0fd68d32c7541f56841e2b92a0.1386629050.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:22,
	Serialize complete at 2013/12/09 17:49:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two 'runs' here breaks the sentence in Description of perf archive command.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-archive.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
index 5032a14..ac6ecbb 100644
--- a/tools/perf/Documentation/perf-archive.txt
+++ b/tools/perf/Documentation/perf-archive.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command runs runs perf-buildid-list --with-hits, and collects the files
-with the buildids found so that analysis of perf.data contents can be possible
-on another machine.
+This command runs perf-buildid-list --with-hits, and collects the files with the
+buildids found so that analysis of perf.data contents can be possible on another
+machine.
 
 
 SEE ALSO
-- 
1.8.2.1

