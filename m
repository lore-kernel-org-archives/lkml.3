Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3GVARH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54218 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502Ab3GVARC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:02 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] MAINTAINERS: ghes_edac: Update pattern
Date: Sun, 21 Jul 2013 17:15:35 -0700
Message-Id: <a5bba2d14b51e8bf7d346c1ea417cd00eae4e39c.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 77c5f5d2 ("ghes_edac: Register at EDAC core the BIOS report")
typoed the file pattern.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e94aecb..9c224cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2981,7 +2981,7 @@ M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
-F:	drivers/edac/ghes-edac.c
+F:	drivers/edac/ghes_edac.c
 
 EDAC-I82443BXGX
 M:	Tim Small <tim@buttersideup.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

