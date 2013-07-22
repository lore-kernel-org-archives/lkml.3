Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3GVARd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37003 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754137Ab3GVARa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:30 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] MAINTAINERS: SI4713: Fix file pattern
Date: Sun, 21 Jul 2013 17:15:38 -0700
Message-Id: <6062264246ae08acf8e4784bcff5814ebce4a620.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c937ca034a0 ("[media] MAINTAINERS: Add maintainer entry for
si4713 FM transmitter driver") typoed the pattern, fix it.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Eduardo Valentin <edubezval@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 81d68ae..aa5ccd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7394,7 +7394,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/radio/radio-si4713.h
+F:	drivers/media/radio/radio-si4713.c
 
 SIANO DVB DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

