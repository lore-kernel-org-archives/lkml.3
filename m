Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaDMWih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:38:37 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64794 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaDMWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:38:35 -0400
Date: Sun, 13 Apr 2014 18:38:31 -0400
From: Julian Gindi <juliangindi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcm: Fixing a few checkpatch issues in InterfaceMisc.h
Message-ID: <20140413223827.GA1755@juliangindimbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just cleaned up a few issues presented by checkpatch in InterfaceMisc.h.
I converted some spaces to tabs, and removed unnecessary whitespace. The
kernel version I am using linux-next-20140411.

Signed-off-by: Julian Gindi <juliangindi@gmail.com>
---
 drivers/staging/bcm/InterfaceMisc.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceMisc.h b/drivers/staging/bcm/InterfaceMisc.h
index bce6869..efb6860 100644
--- a/drivers/staging/bcm/InterfaceMisc.h
+++ b/drivers/staging/bcm/InterfaceMisc.h
@@ -14,13 +14,13 @@ InterfaceWRM(struct bcm_interface_adapter *psIntfAdapter,
 			INT len);
 
 
-int InterfaceFileDownload( PVOID psIntfAdapter,
-                        struct file *flp,
-                        unsigned int on_chip_loc);
+int InterfaceFileDownload(PVOID psIntfAdapter,
+			struct file *flp,
+			unsigned int on_chip_loc);
 
-int InterfaceFileReadbackFromChip( PVOID psIntfAdapter,
-                        struct file *flp,
-                        unsigned int on_chip_loc);
+int InterfaceFileReadbackFromChip(PVOID psIntfAdapter,
+			struct file *flp,
+			unsigned int on_chip_loc);
 
 
 int BcmRDM(PVOID arg,
-- 
1.9.0

