Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3GVASA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:18:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40155 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113Ab3GVAR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:57 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] MAINTAINERS: Update ssbi patterns
Date: Sun, 21 Jul 2013 17:15:41 -0700
Message-Id: <c1b21e64d593113fb69a1a541a1ab6aa8725d190.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 45fcac1aad5 ("mfd: Move ssbi driver into drivers/mfd")
move the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Arnd Bergmann <arnd@arndb.de>
cc: Samuel Ortiz <sameo@linux.intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b24f82..3d1f600 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1044,7 +1044,7 @@ F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
-F:	drivers/ssbi/
+F:	drivers/mfd/ssbi/
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
-- 
1.8.1.2.459.gbcd45b4.dirty

