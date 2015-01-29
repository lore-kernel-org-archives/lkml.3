Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbbA2Bin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:38:43 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58216 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbbA2BhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:37:11 -0500
From: Behan Webster <behanw@converseincode.com>
To: JBottomley@parallels.com
Cc: behanw@converseincode.com, jayamohan.kallickal@emulex.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi, be2iscsi, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
Date: Wed, 28 Jan 2015 17:37:02 -0800
Message-Id: <1422495422-25281-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing MODULE_DEVICE_TABLE for pci ids from be2iscsi driver found by clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/be2iscsi/be_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..96241b2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -48,7 +48,6 @@ static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
 
-MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
 MODULE_AUTHOR("Emulex Corporation");
-- 
1.9.1

