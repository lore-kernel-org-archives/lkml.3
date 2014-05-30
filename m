Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaE3QMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:12:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:49116 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbaE3QMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:12:32 -0400
From: jaegeuk@kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforget.net
Cc: cm224.lee@samsung.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] MAINTAINERS: change the email address for f2fs
Date: Sat, 31 May 2014 01:12:08 +0900
Message-Id: <1401466329-91626-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

This patch changes the valid email address to maintain the f2fs file system.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51ebb77..38ffb57 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3774,7 +3774,7 @@ F:	fs/fscache/
 F:	include/linux/fscache*.h
 
 F2FS FILE SYSTEM
-M:	Jaegeuk Kim <jaegeuk.kim@samsung.com>
+M:	Jaegeuk Kim <jaegeuk@kernel.org>
 L:	linux-f2fs-devel@lists.sourceforge.net
 W:	http://en.wikipedia.org/wiki/F2FS
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
-- 
1.8.5.2 (Apple Git-48)

