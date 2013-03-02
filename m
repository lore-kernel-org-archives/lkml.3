Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3CBPdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:33:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3CBPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:33:11 -0500
From: Richard Weinberger <richard@nod.at>
To: ocfs2-devel@oss.oracle.com
Cc: mfasheh@suse.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] ocfs2: Update version string
Date: Sat,  2 Mar 2013 16:33:00 +0100
Message-Id: <1362238380-11303-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version string is outdated.
Update it to 1.8.0 to reflect the real OCFS2 feature set.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ocfs2/ver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
index e2488f4..cae2a2c 100644
--- a/fs/ocfs2/ver.c
+++ b/fs/ocfs2/ver.c
@@ -29,7 +29,7 @@
 
 #include "ver.h"
 
-#define OCFS2_BUILD_VERSION "1.5.0"
+#define OCFS2_BUILD_VERSION "1.8.0"
 
 #define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
 
-- 
1.8.1.2

