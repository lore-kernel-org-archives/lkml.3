Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3GVASJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:18:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52796 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113Ab3GVASG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:18:06 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] MAINTAINERS: Update file pattern for ARC uart
Date: Sun, 21 Jul 2013 17:15:42 -0700
Message-Id: <545985532a17c37792f80843cd259ed2dd9944f1.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6659a20a76 ("ARC: MAINTAINERS update for ARC") typoed the
file pattern.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d1f600..cf20695 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7962,7 +7962,7 @@ M:	Vineet Gupta <vgupta@synopsys.com>
 S:	Supported
 F:	arch/arc/
 F:	Documentation/devicetree/bindings/arc/
-F:	drivers/tty/serial/arc-uart.c
+F:	drivers/tty/serial/arc_uart.c
 
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
-- 
1.8.1.2.459.gbcd45b4.dirty

