Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3HWMdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:33:37 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60884 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3HWMYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] staging: dgnc: driver.c: Add missing #include <linux/slab.h>
Date: Fri, 23 Aug 2013 14:23:49 +0200
Message-Id: <1377260629-1696-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/sparc64 allmodconfig:

drivers/staging/dgnc/dgnc_driver.c: In function ‘dgnc_cleanup_board’:
drivers/staging/dgnc/dgnc_driver.c:459: error: implicit declaration of function ‘kfree’
drivers/staging/dgnc/dgnc_driver.c: In function ‘dgnc_driver_kzmalloc’:
drivers/staging/dgnc/dgnc_driver.c:905: error: implicit declaration of function ‘kmalloc’
drivers/staging/dgnc/dgnc_driver.c:905: warning: initialization makes pointer from integer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/9356764/
http://kisskb.ellerman.id.au/kisskb/buildresult/9356016/

 drivers/staging/dgnc/dgnc_driver.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index fa4e91a..8032368 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -34,6 +34,7 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 #include <linux/sched.h>
-- 
1.7.9.5

