Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3C2OsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:48:23 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60059 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937Ab3C2OsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:48:21 -0400
Message-ID: <1364568500.1345.78.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Remove obsolete, iSeries specific, Makefile lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 15:48:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 14:48:20.0176 (UTC) FILETIME=[747DAD00:01CE2C8C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Entirely untested.

1) See commit 3d066d77cf464ea1e47808f95243301fd2175a7f ("powerpc: remove
CONFIG_PPC_ISERIES from the architecture Kconfig files") and commit
ba7a4822b48fbc7afd6b567c18e316a03f46684d ("powerpc: Remove some of the
legacy iSeries specific device drivers").

 drivers/block/Makefile | 1 -
 drivers/cdrom/Makefile | 1 -
 drivers/char/Makefile  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index a3b4023..ebb3a61 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -30,7 +30,6 @@ obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
 obj-$(CONFIG_BLK_DEV_CRYPTOLOOP) += cryptoloop.o
 obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 
-obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
diff --git a/drivers/cdrom/Makefile b/drivers/cdrom/Makefile
index ecf85fd..8ffde4f 100644
--- a/drivers/cdrom/Makefile
+++ b/drivers/cdrom/Makefile
@@ -10,5 +10,4 @@ obj-$(CONFIG_BLK_DEV_SR)	+=              cdrom.o
 obj-$(CONFIG_PARIDE_PCD)	+=		cdrom.o
 obj-$(CONFIG_CDROM_PKTCDVD)	+=		cdrom.o
 
-obj-$(CONFIG_VIOCD)		+= viocd.o      cdrom.o
 obj-$(CONFIG_GDROM)		+= gdrom.o      cdrom.o
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 7ff1d0d..290fe5b 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_MSM_SMD_PKT)	+= msm_smd_pkt.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_MMTIMER)		+= mmtimer.o
 obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
-obj-$(CONFIG_VIOTAPE)		+= viotape.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
-- 
1.7.11.7

