Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaIVV42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:56:28 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59555 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaIVV4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:56:19 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 15/15] perf: replace _BSD_SOURCE macro by _DEFAULT_SOURCE
Date: Mon, 22 Sep 2014 23:53:16 +0200
Message-Id: <1411422796-27049-16-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from glibc-2.20, the macro _BSD_SOURCE is deprecated and
should be replaced by _DEFAULT_SOURCE.
---
 tools/perf/util/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6686436..f56b4e0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -38,7 +38,7 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
-#define _BSD_SOURCE 1
+#define _DEFAULT_SOURCE 1
 #define HAS_BOOL
 
 #include <unistd.h>
-- 
2.1.0

