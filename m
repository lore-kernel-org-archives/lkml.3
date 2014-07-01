Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaGAVwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:52:38 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:56748 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaGAVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:44 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 50/50] mars: activate MARS in drivers/block/mars/
Date: Tue,  1 Jul 2014 23:47:30 +0200
Message-Id: <1404251250-22992-51-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Schoebel-Theuer <schoebel@bell.site>

---
 drivers/block/Kconfig  | 2 ++
 drivers/block/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..8646956 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -283,6 +283,8 @@ config BLK_DEV_CRYPTOLOOP
 
 source "drivers/block/drbd/Kconfig"
 
+source "drivers/block/mars/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 02b688d..b0f1e81 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
+obj-$(CONFIG_MARS)             += mars/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
 
-- 
2.0.0

