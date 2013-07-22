Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3GVASS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:18:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47881 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113Ab3GVASP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:18:15 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] MAINTAINERS: Update USB EHCI platform pattern
Date: Sun, 21 Jul 2013 17:15:43 -0700
Message-Id: <10d1f32bddb3bd8cf6d9eb9e217bbd0d29d32007.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f3bc64d6d1f ("USB: EHCI: DT support for generic bus glue")
removed the ehci-vt8500.c file, update the file pattern to include
ehci-platform.c.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf20695..d0c54ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1297,7 +1297,7 @@ F:	drivers/mmc/host/wmt-sdmmc.c
 F:	drivers/pwm/pwm-vt8500.c
 F:	drivers/rtc/rtc-vt8500.c
 F:	drivers/tty/serial/vt8500_serial.c
-F:	drivers/usb/host/ehci-vt8500.c
+F:	drivers/usb/host/ehci-platform.c
 F:	drivers/usb/host/uhci-platform.c
 F:	drivers/video/vt8500lcdfb.*
 F:	drivers/video/wm8505fb*
-- 
1.8.1.2.459.gbcd45b4.dirty

