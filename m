Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaLVB2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:28:32 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58787 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbaLVB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:27 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] dgnc/dgnc_sysfs.c: checkpatch: Use of pr_err insted of printk
Date: Mon, 22 Dec 2014 02:17:30 +0100
Message-Id: <1419211054-3052-3-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dgnc_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 2fd34ca..0fa2388 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -91,7 +91,7 @@ void dgnc_create_driver_sysfiles(struct pci_driver *dgnc_driver)
 	rc |= driver_create_file(driverfs, &driver_attr_maxboards);
 	rc |= driver_create_file(driverfs, &driver_attr_pollrate);
 	if (rc)
-		printk(KERN_ERR "DGNC: sysfs driver_create_file failed!\n");
+		pr_err("DGNC: sysfs driver_create_file failed!\n");
 }
 
 
@@ -360,7 +360,7 @@ void dgnc_create_ports_sysfiles(struct dgnc_board *bd)
 	rc |= device_create_file(&(bd->pdev->dev), &dev_attr_vpd);
 	rc |= device_create_file(&(bd->pdev->dev), &dev_attr_serial_number);
 	if (rc)
-		printk(KERN_ERR "DGNC: sysfs device_create_file failed!\n");
+		pr_err("DGNC: sysfs device_create_file failed!\n");
 }
 
 
-- 
1.9.1

