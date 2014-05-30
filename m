Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbaE3QMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:12:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:49130 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbaE3QMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:12:38 -0400
From: jaegeuk@kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforget.net
Cc: cm224.lee@samsung.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] MAINTAINERS: add a co-maintainer from samsung for F2FS
Date: Sat, 31 May 2014 01:12:09 +0900
Message-Id: <1401466329-91626-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1401466329-91626-1-git-send-email-jaegeuk@kernel.org>
References: <1401466329-91626-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

This patch adds a samsung guy for an F2FS maintainer.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38ffb57..e154141 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3775,6 +3775,7 @@ F:	include/linux/fscache*.h
 
 F2FS FILE SYSTEM
 M:	Jaegeuk Kim <jaegeuk@kernel.org>
+M:	Changman Lee <cm224.lee@samsung.com>
 L:	linux-f2fs-devel@lists.sourceforge.net
 W:	http://en.wikipedia.org/wiki/F2FS
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
-- 
1.8.5.2 (Apple Git-48)

