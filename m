Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaITQTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:19:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:60547 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbaITQTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:19:05 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs-tools: release 1.4.0
Date: Sat, 20 Sep 2014 09:19:01 -0700
Message-Id: <1411229941-18054-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version includes:
 - fsck.f2fs fixing corrupted images/partitions
 - dump.f2fs retrieving speicific file
 - bug fixes on f2fsstat and fibmap.f2fs
 - refactor code blocks for android build

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 VERSION | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/VERSION b/VERSION
index c3a3dd8..4e11b43 100644
--- a/VERSION
+++ b/VERSION
@@ -1,2 +1,2 @@
-1.2.0
-2013-10-25
+1.4.0
+2014-09-18
-- 
1.8.5.2 (Apple Git-48)

