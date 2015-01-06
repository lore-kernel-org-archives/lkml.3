Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbAFXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:41:47 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:65148 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbbAFXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:41:45 -0500
Date: Tue, 6 Jan 2015 18:41:41 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH libata/for-3.19-fixes] libata: clean up MAINTAINERS entries
Message-ID: <20150106234141.GE24106@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32ac7cb262177f58c7c8846311599460e5e7e3c5 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 6 Jan 2015 18:36:44 -0500

Make all libata entries start with LIBATA and collect them in one
place.  Driver specfic ones have the second SATA or PATA prefix.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to libata/for-3.19-fixes.

Thanks.

 MAINTAINERS | 66 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..c20aebe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -754,13 +754,6 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/aptina-pll.*
 
-ARASAN COMPACT FLASH PATA CONTROLLER
-M:	Viresh Kumar <viresh.linux@gmail.com>
-L:	linux-ide@vger.kernel.org
-S:	Maintained
-F:	include/linux/pata_arasan_cf_data.h
-F:	drivers/ata/pata_arasan_cf.c
-
 ARC FRAMEBUFFER DRIVER
 M:	Jaya Kumar <jayalk@intworks.biz>
 S:	Maintained
@@ -5693,6 +5686,40 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	tools/lguest/
 
+LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)
+M:	Tejun Heo <tj@kernel.org>
+L:	linux-ide@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
+S:	Maintained
+F:	drivers/ata/
+F:	include/linux/ata.h
+F:	include/linux/libata.h
+
+LIBATA PATA ARASAN COMPACT FLASH CONTROLLER
+M:	Viresh Kumar <viresh.linux@gmail.com>
+L:	linux-ide@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
+S:	Maintained
+F:	include/linux/pata_arasan_cf_data.h
+F:	drivers/ata/pata_arasan_cf.c
+
+LIBATA SATA AHCI PLATFORM devices support
+M:	Hans de Goede <hdegoede@redhat.com>
+M:	Tejun Heo <tj@kernel.org>
+L:	linux-ide@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
+S:	Maintained
+F:	drivers/ata/ahci_platform.c
+F:	drivers/ata/libahci_platform.c
+F:	include/linux/ahci_platform.h
+
+LIBATA SATA PROMISE TX2/TX4 CONTROLLER DRIVER
+M:	Mikael Pettersson <mikpelinux@gmail.com>
+L:	linux-ide@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
+S:	Maintained
+F:	drivers/ata/sata_promise.*
+
 LIBLOCKDEP
 M:	Sasha Levin <sasha.levin@oracle.com>
 S:	Maintained
@@ -7566,12 +7593,6 @@ W:	http://wireless.kernel.org/en/users/Drivers/p54
 S:	Obsolete
 F:	drivers/net/wireless/prism54/
 
-PROMISE SATA TX2/TX4 CONTROLLER LIBATA DRIVER
-M:	Mikael Pettersson <mikpelinux@gmail.com>
-L:	linux-ide@vger.kernel.org
-S:	Maintained
-F:	drivers/ata/sata_promise.*
-
 PS3 NETWORK SUPPORT
 M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
@@ -8546,25 +8567,6 @@ S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/uapi/linux/phantom.h
 
-SERIAL ATA (SATA) SUBSYSTEM
-M:	Tejun Heo <tj@kernel.org>
-L:	linux-ide@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
-S:	Supported
-F:	drivers/ata/
-F:	include/linux/ata.h
-F:	include/linux/libata.h
-
-SERIAL ATA AHCI PLATFORM devices support
-M:	Hans de Goede <hdegoede@redhat.com>
-M:	Tejun Heo <tj@kernel.org>
-L:	linux-ide@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
-S:	Supported
-F:	drivers/ata/ahci_platform.c
-F:	drivers/ata/libahci_platform.c
-F:	include/linux/ahci_platform.h
-
 SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
 M:	Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
 L:	linux-scsi@vger.kernel.org
-- 
2.1.0

