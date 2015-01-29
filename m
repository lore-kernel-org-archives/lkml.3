Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbbA2Bgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:36:37 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:55322 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbbA2Bge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:36:34 -0500
From: Behan Webster <behanw@converseincode.com>
To: sathya.perla@emulex.com
Cc: behanw@converseincode.com, ajit.khaparde@emulex.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        subbu.seetharaman@emulex.com, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net, ethernet, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
Date: Wed, 28 Jan 2015 17:36:14 -0800
Message-Id: <1422495374-22835-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing MODULE_DEVICE_TABLE for pci ids from benet driver found by clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index d48806b..709400a 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -26,7 +26,6 @@
 #include <net/vxlan.h>
 
 MODULE_VERSION(DRV_VER);
-MODULE_DEVICE_TABLE(pci, be_dev_ids);
 MODULE_DESCRIPTION(DRV_DESC " " DRV_VER);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
-- 
1.9.1

