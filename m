Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3LIJtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:49:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab3LIJtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:49:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9221944"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] perf tools: Fix typo in builtin-annotate.c
Date: Mon, 9 Dec 2013 17:47:48 -0500
Message-Id: <46cb069a4ce21141057a07c0b50baa9968e3228c.1386629050.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <ebedc3b95eae7f0fd68d32c7541f56841e2b92a0.1386629050.git.yangds.fnst@cn.fujitsu.com>
References: <ebedc3b95eae7f0fd68d32c7541f56841e2b92a0.1386629050.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 17:49:21,
	Serialize complete at 2013/12/09 17:49:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A typo in comment of builtin-annotate.c about that.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4087ab1..6fd52c8 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -373,7 +373,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (argc) {
 		/*
-		 * Special case: if there's an argument left then assume tha
+		 * Special case: if there's an argument left then assume that
 		 * it's a symbol filter:
 		 */
 		if (argc > 1)
-- 
1.8.2.1

